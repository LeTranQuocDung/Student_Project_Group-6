package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    // IMPORTANT: Replace with your actual email and app password
    private static final String SENDER_EMAIL = "vuilennao2017123@gmail.com";
    private static final String APP_PASSWORD = "nnengyauttqmfwxs";

    /**
     * Tạo session SMTP chung
     */
    private static Session createMailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });
    }

    /**
     * Gửi OTP cho đăng ký user thường
     */
    public static boolean sendOtpEmail(String recipientEmail, String otp) {
        try {
            Session session = createMailSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Mã xác thực OTP Đăng ký của bạn");

            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; max-width: 500px; margin: auto;'>"
                    + "<h2 style='color: #ee4d2d; text-align: center;'>Shopee Clone - Xác thực Email</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Mã OTP của bạn là: <strong style='font-size: 24px; color: #333;'>" + otp + "</strong></p>"
                    + "<p>Mã OTP này sẽ hết hạn sau <strong>10 phút</strong>. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "<br><br><p>Trân trọng,<br>Đội ngũ Shopee Clone</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 🔒 Gửi OTP bảo mật cho ADMIN LOGIN (2FA)
     * Template email khác biệt, cảnh báo bảo mật rõ ràng hơn
     */
    public static boolean sendAdminOtpEmail(String recipientEmail, String otp) {
        try {
            Session session = createMailSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("🔒 [ADMIN] Mã xác thực đăng nhập Admin - Shopee Clone");

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 520px; margin: auto; border: 2px solid #ee4d2d; border-radius: 12px; overflow: hidden;'>"
                    // Header
                    + "<div style='background: linear-gradient(135deg, #ee4d2d, #ff7b54); padding: 25px; text-align: center;'>"
                    + "<h1 style='color: white; margin: 0; font-size: 22px;'>🛡️ Xác Thực Admin</h1>"
                    + "<p style='color: rgba(255,255,255,0.9); margin: 5px 0 0 0; font-size: 14px;'>Shopee Clone Admin Panel</p>"
                    + "</div>"
                    // Body
                    + "<div style='padding: 30px;'>"
                    + "<p style='color: #333; font-size: 15px;'>Xin chào <strong>Quản trị viên</strong>,</p>"
                    + "<p style='color: #555; font-size: 14px;'>Hệ thống phát hiện yêu cầu đăng nhập vào Admin Panel. Vui lòng sử dụng mã xác thực bên dưới:</p>"
                    // OTP Box
                    + "<div style='background: #f8f9fa; border: 2px dashed #ee4d2d; border-radius: 10px; padding: 20px; text-align: center; margin: 25px 0;'>"
                    + "<p style='color: #888; font-size: 12px; margin: 0 0 8px 0; text-transform: uppercase; letter-spacing: 2px;'>Mã Xác Thực OTP</p>"
                    + "<h2 style='color: #ee4d2d; font-size: 36px; letter-spacing: 8px; margin: 0; font-weight: 700;'>"
                    + otp + "</h2>"
                    + "</div>"
                    // Warning
                    + "<div style='background: #fff3cd; border-left: 4px solid #ffc107; padding: 12px 15px; border-radius: 4px; margin: 20px 0;'>"
                    + "<p style='color: #856404; margin: 0; font-size: 13px;'>⚠️ <strong>Cảnh báo bảo mật:</strong></p>"
                    + "<ul style='color: #856404; font-size: 13px; margin: 5px 0 0 0; padding-left: 20px;'>"
                    + "<li>Mã này hết hạn sau <strong>10 phút</strong></li>"
                    + "<li>Không chia sẻ mã này cho bất kỳ ai</li>"
                    + "<li>Nếu bạn không yêu cầu đăng nhập, vui lòng đổi mật khẩu ngay</li>"
                    + "</ul>"
                    + "</div>"
                    + "<p style='color: #999; font-size: 12px; margin-top: 20px;'>Email này được gửi tự động từ hệ thống. Vui lòng không trả lời.</p>"
                    + "</div>"
                    // Footer
                    + "<div style='background: #f5f5f5; padding: 15px; text-align: center; border-top: 1px solid #eee;'>"
                    + "<p style='color: #999; font-size: 11px; margin: 0;'>© 2026 Shopee Clone Admin System | Bảo mật 2FA</p>"
                    + "</div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
