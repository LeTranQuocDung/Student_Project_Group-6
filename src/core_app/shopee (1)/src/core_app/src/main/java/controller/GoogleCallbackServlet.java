package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dal.UserDAO;
import model.User;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Bước 2 của Google OAuth 2.0:
 * Nhận authorization code từ Google → đổi lấy access_token → lấy thông tin user
 */
@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/google-callback"})
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID;
    private static final String CLIENT_SECRET;
    private static final String REDIRECT_URI = "http://localhost:8080/google-callback";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

    static {
        Properties props = new Properties();
        try (InputStream is = GoogleCallbackServlet.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) props.load(is);
        } catch (Exception e) { /* ignore */ }
        CLIENT_ID = props.getProperty("google.client.id", "");
        CLIENT_SECRET = props.getProperty("google.client.secret", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String error = request.getParameter("error");

        // Nếu user từ chối quyền truy cập
        if (error != null || code == null) {
            request.setAttribute("error", "Đăng nhập Google bị hủy hoặc có lỗi xảy ra!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Bước 2a: Đổi authorization code lấy access_token
            String tokenResponse = exchangeCodeForToken(code);
            JsonObject tokenJson = JsonParser.parseString(tokenResponse).getAsJsonObject();

            if (!tokenJson.has("access_token")) {
                request.setAttribute("error", "Không thể lấy access token từ Google!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            String accessToken = tokenJson.get("access_token").getAsString();

            // Bước 2b: Dùng access_token để lấy thông tin user
            String userInfoResponse = getUserInfo(accessToken);
            JsonObject userInfo = JsonParser.parseString(userInfoResponse).getAsJsonObject();

            String email = userInfo.has("email") ? userInfo.get("email").getAsString() : "";
            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;

            if (email.isEmpty()) {
                request.setAttribute("error", "Không thể lấy email từ Google!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Bước 2c: Tìm hoặc tạo user trong database
            UserDAO dao = new UserDAO();
            User account = dao.signupSocial(email, name, "Google");

            if (account != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("account", account);
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Lỗi khi tạo tài khoản từ Google!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kết nối với Google: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Gửi POST request đến Google để đổi code → access_token
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String params = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                + "&client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&grant_type=authorization_code";

        return sendPostRequest(TOKEN_URL, params);
    }

    /**
     * Gọi Google API để lấy thông tin user (email, name, picture)
     */
    private String getUserInfo(String accessToken) throws IOException {
        URL url = new URL(USERINFO_URL + "?access_token=" + URLEncoder.encode(accessToken, StandardCharsets.UTF_8));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        return readResponse(conn);
    }

    /**
     * Helper: Gửi POST request
     */
    private String sendPostRequest(String urlStr, String params) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        return readResponse(conn);
    }

    /**
     * Helper: Đọc response từ HttpURLConnection
     */
    private String readResponse(HttpURLConnection conn) throws IOException {
        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode >= 200 && responseCode < 300)
                ? conn.getInputStream()
                : conn.getErrorStream();

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}
