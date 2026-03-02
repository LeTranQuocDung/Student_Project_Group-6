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
 * Bước 2 của Facebook OAuth 2.0:
 * Nhận authorization code → đổi lấy access_token → lấy thông tin user từ Graph API
 */
@WebServlet(name = "FacebookCallbackServlet", urlPatterns = {"/facebook-callback"})
public class FacebookCallbackServlet extends HttpServlet {

    private static final String APP_ID;
    private static final String APP_SECRET;

    static {
        Properties props = new Properties();
        try (InputStream is = FacebookCallbackServlet.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) props.load(is);
        } catch (Exception e) { /* ignore */ }
        APP_ID = props.getProperty("facebook.app.id", "");
        APP_SECRET = props.getProperty("facebook.app.secret", "");
    }
    private static final String REDIRECT_URI = "http://localhost:8080/facebook-callback";
    private static final String TOKEN_URL = "https://graph.facebook.com/v18.0/oauth/access_token";
    private static final String USERINFO_URL = "https://graph.facebook.com/me";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String error = request.getParameter("error");

        // Nếu user từ chối quyền truy cập
        if (error != null || code == null) {
            request.setAttribute("error", "Đăng nhập Facebook bị hủy hoặc có lỗi xảy ra!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Bước 2a: Đổi authorization code lấy access_token
            String tokenResponse = exchangeCodeForToken(code);
            JsonObject tokenJson = JsonParser.parseString(tokenResponse).getAsJsonObject();

            if (!tokenJson.has("access_token")) {
                String errorMsg = tokenJson.has("error")
                        ? tokenJson.getAsJsonObject("error").get("message").getAsString()
                        : "Không thể lấy access token";
                request.setAttribute("error", "Lỗi Facebook: " + errorMsg);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            String accessToken = tokenJson.get("access_token").getAsString();

            // Bước 2b: Dùng access_token để lấy thông tin user từ Graph API
            String userInfoResponse = getUserInfo(accessToken);
            System.out.println("[FB Login] UserInfo response: " + userInfoResponse);
            JsonObject userInfo = JsonParser.parseString(userInfoResponse).getAsJsonObject();

            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : "";
            String email = userInfo.has("email") ? userInfo.get("email").getAsString() : "";
            String fbId = userInfo.has("id") ? userInfo.get("id").getAsString() : "";

            System.out.println("[FB Login] id=" + fbId + ", name=" + name + ", email=" + email);

            // Nếu FB không trả email (user chưa verify email), dùng FB ID
            if (email.isEmpty()) {
                email = "fb_" + fbId + "@facebook.com"; // Tạo email giả từ FB ID
            }

            if (name.isEmpty()) {
                name = "Facebook User";
            }

            // Bước 2c: Tìm hoặc tạo user trong database
            UserDAO dao = new UserDAO();
            User account = dao.signupSocial(email, name, "Facebook");

            if (account != null) {
                // Đăng nhập thành công
                System.out.println("[FB Login] Đăng nhập thành công: " + account.getEmail());
                HttpSession session = request.getSession();
                session.setAttribute("account", account);
                response.sendRedirect("home");
            } else {
                System.err.println("[FB Login] signupSocial trả về null!");
                request.setAttribute("error", "Lỗi khi tạo tài khoản từ Facebook! Kiểm tra log Tomcat.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kết nối với Facebook: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Gửi GET request đến Facebook để đổi code → access_token
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String urlStr = TOKEN_URL
                + "?client_id=" + URLEncoder.encode(APP_ID, StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(APP_SECRET, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8);

        return sendGetRequest(urlStr);
    }

    /**
     * Gọi Facebook Graph API để lấy thông tin user (id, name, email)
     */
    private String getUserInfo(String accessToken) throws IOException {
        String urlStr = USERINFO_URL
                + "?fields=id,name,email"
                + "&access_token=" + URLEncoder.encode(accessToken, StandardCharsets.UTF_8);

        return sendGetRequest(urlStr);
    }

    /**
     * Helper: Gửi GET request
     */
    private String sendGetRequest(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

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
