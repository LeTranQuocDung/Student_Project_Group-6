package controller;

import java.io.InputStream;
import java.util.Properties;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Bước 1 của Facebook OAuth 2.0:
 * Redirect user sang trang đăng nhập Facebook (consent screen)
 */
@WebServlet(name = "FacebookLoginServlet", urlPatterns = {"/facebook-login"})
public class FacebookLoginServlet extends HttpServlet {

    private static final String APP_ID;
    private static final String REDIRECT_URI = "http://localhost:8080/facebook-callback";

    static {
        Properties props = new Properties();
        try (InputStream is = FacebookLoginServlet.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) props.load(is);
        } catch (Exception e) { /* ignore */ }
        APP_ID = props.getProperty("facebook.app.id", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String facebookAuthUrl = "https://www.facebook.com/v18.0/dialog/oauth"
                + "?client_id=" + URLEncoder.encode(APP_ID, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&scope=" + URLEncoder.encode("email,public_profile", StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&state=shopee_fb_login";

        response.sendRedirect(facebookAuthUrl);
    }
}
