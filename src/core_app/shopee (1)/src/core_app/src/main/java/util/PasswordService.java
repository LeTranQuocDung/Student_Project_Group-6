package util;

import de.mkammerer.argon2.Argon2;
import de.mkammerer.argon2.Argon2Factory;

/**
 * 🔒 DỊCH VỤ MÃ HÓA MẬT KHẨU - ARGON2ID
 * 
 * Thay thế hoàn toàn MD5. Argon2id là chuẩn vàng hiện tại cho password hashing.
 * Mỗi hash đều có salt riêng biệt → 2 password giống nhau sẽ có hash khác nhau.
 * 
 * Cấu hình: iterations=3, memory=65536KB (64MB), parallelism=1
 */
public class PasswordService {

    // Singleton Argon2 instance (thread-safe)
    private static final Argon2 argon2 = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);

    // Cấu hình Argon2
    private static final int ITERATIONS = 3; // Số vòng lặp
    private static final int MEMORY_KB = 65536; // 64 MB RAM
    private static final int PARALLELISM = 1; // Số thread

    /**
     * Mã hóa password → Argon2id hash string
     * Kết quả dạng: $argon2id$v=19$m=65536,t=3,p=1$salt$hash
     */
    public static String hash(String password) {
        try {
            return argon2.hash(ITERATIONS, MEMORY_KB, PARALLELISM, password.toCharArray());
        } finally {
            // Argon2 tự wipe char array nội bộ
        }
    }

    /**
     * Xác thực password với hash đã lưu trong DB
     * 
     * @return true nếu password đúng
     */
    public static boolean verify(String password, String hashFromDB) {
        try {
            return argon2.verify(hashFromDB, password.toCharArray());
        } catch (Exception e) {
            // Nếu hash không hợp lệ (ví dụ: hash MD5 cũ) → false
            return false;
        }
    }
}
