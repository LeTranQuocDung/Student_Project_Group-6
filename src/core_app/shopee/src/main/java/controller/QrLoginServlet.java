package controller;

import com.google.gson.JsonObject;
import dal.UserDAO;
import model.User;
import util.QrLoginManager;
import util.QrLoginManager.QrSession;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * QR Code Login Servlet
 * - action=generate → tạo QR token mới
 * - action=check    → polling trạng thái token (AJAX)
 * - action=confirm  → xác nhận QR (giả lập quét từ app)
 */
@WebServlet(name = "QrLoginServlet", urlPatterns = {"/qr-login"})
public class QrLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CORS cho mobile app
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");

        if (action == null) {
            response.getWriter().write("{\"error\":\"Missing action\"}");
            return;
        }

        QrLoginManager manager = QrLoginManager.getInstance();
        JsonObject json = new JsonObject();

        switch (action) {
            case "generate": {
                // Tạo QR token mới
                String token = manager.generateToken();
                json.addProperty("token", token);
                json.addProperty("status", "PENDING");
                response.getWriter().write(json.toString());
                break;
            }

            case "check": {
                // Kiểm tra trạng thái token (polling)
                String token = request.getParameter("token");
                if (token == null) {
                    json.addProperty("error", "Missing token");
                    response.getWriter().write(json.toString());
                    return;
                }

                QrSession session = manager.checkToken(token);
                if (session == null) {
                    json.addProperty("status", "EXPIRED");
                } else {
                    json.addProperty("status", session.status);
                    if ("CONFIRMED".equals(session.status)) {
                        json.addProperty("userId", session.userId);

                        // Lấy user từ DB và set vào session HTTP
                        UserDAO dao = new UserDAO();
                        User user = dao.getUserById(session.userId);
                        if (user != null) {
                            HttpSession httpSession = request.getSession();
                            httpSession.setAttribute("account", user);
                            json.addProperty("redirect", "home");
                        }
                        // Xóa token sau khi dùng
                        manager.removeToken(token);
                    }
                }
                response.getWriter().write(json.toString());
                break;
            }

            default:
                json.addProperty("error", "Unknown action");
                response.getWriter().write(json.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CORS cho mobile app
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();

        if ("confirm".equals(action)) {
            // Giả lập quét QR: dùng user đang đăng nhập hoặc user demo
            String token = request.getParameter("token");
            if (token == null) {
                json.addProperty("error", "Missing token");
                response.getWriter().write(json.toString());
                return;
            }

            QrLoginManager manager = QrLoginManager.getInstance();

            // Thử lấy user từ session hiện tại (nếu đã đăng nhập ở tab khác)
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("account") : null;

            if (currentUser != null) {
                // User đã đăng nhập → dùng user hiện tại
                boolean confirmed = manager.confirmToken(token, currentUser.getId());
                json.addProperty("success", confirmed);
            } else {
                // Chưa đăng nhập → tạo user demo để demo QR scan
                UserDAO dao = new UserDAO();
                User demoUser = dao.signupSocial("qr_user@shopee.vn", "QR User Demo", "QR Code");
                if (demoUser != null) {
                    boolean confirmed = manager.confirmToken(token, demoUser.getId());
                    json.addProperty("success", confirmed);
                } else {
                    json.addProperty("error", "Không thể tạo user demo");
                }
            }

            response.getWriter().write(json.toString());
        } else {
            json.addProperty("error", "Unknown action");
            response.getWriter().write(json.toString());
        }
    }
}
