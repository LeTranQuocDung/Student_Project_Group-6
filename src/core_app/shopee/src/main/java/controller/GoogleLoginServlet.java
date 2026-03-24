package controller;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Bước 1 của Google OAuth 2.0:
 * Redirect user sang trang đăng nhập Google (consent screen)
 */
@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/google-login"})
public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID;
    private static final String REDIRECT_URI = "http://localhost:8080/google-callback";

    static {
        Properties props = new Properties();
        try (InputStream is = GoogleLoginServlet.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) props.load(is);
        } catch (Exception e) { /* ignore */ }
        CLIENT_ID = props.getProperty("google.client.id", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8)
                + "&access_type=offline"
                + "&prompt=consent";

        response.sendRedirect(googleAuthUrl);
    }
}
