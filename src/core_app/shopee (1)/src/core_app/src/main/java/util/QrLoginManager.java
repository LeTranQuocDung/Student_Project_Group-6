package util;

import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Quản lý QR Login Tokens (in-memory)
 * Token có 3 trạng thái: PENDING → CONFIRMED (với userId) hoặc EXPIRED
 */
public class QrLoginManager {

    private static final QrLoginManager INSTANCE = new QrLoginManager();
    private static final long TOKEN_EXPIRY_MS = 5 * 60 * 1000; // 5 phút

    // token → QrSession
    private final ConcurrentHashMap<String, QrSession> sessions = new ConcurrentHashMap<>();

    public static QrLoginManager getInstance() {
        return INSTANCE;
    }

    /**
     * Tạo token mới với trạng thái PENDING
     */
    public String generateToken() {
        // Xóa các token cũ đã hết hạn
        cleanExpired();

        String token = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        sessions.put(token, new QrSession(System.currentTimeMillis()));
        return token;
    }

    /**
     * Xác nhận token (khi user quét QR thành công)
     */
    public boolean confirmToken(String token, int userId) {
        QrSession session = sessions.get(token);
        if (session == null) return false;
        if (isExpired(session)) {
            sessions.remove(token);
            return false;
        }
        session.status = "CONFIRMED";
        session.userId = userId;
        return true;
    }

    /**
     * Kiểm tra trạng thái token (polling từ client)
     * @return null nếu token không tồn tại hoặc hết hạn
     */
    public QrSession checkToken(String token) {
        QrSession session = sessions.get(token);
        if (session == null) return null;
        if (isExpired(session)) {
            sessions.remove(token);
            return null;
        }
        return session;
    }

    /**
     * Xóa token sau khi dùng xong
     */
    public void removeToken(String token) {
        sessions.remove(token);
    }

    private boolean isExpired(QrSession session) {
        return System.currentTimeMillis() - session.createdAt > TOKEN_EXPIRY_MS;
    }

    private void cleanExpired() {
        sessions.entrySet().removeIf(entry -> isExpired(entry.getValue()));
    }

    // ===== Inner class =====
    public static class QrSession {
        public String status = "PENDING";
        public int userId = -1;
        public long createdAt;

        public QrSession(long createdAt) {
            this.createdAt = createdAt;
        }
    }
}
