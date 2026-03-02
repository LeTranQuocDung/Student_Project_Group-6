import de.mkammerer.argon2.Argon2;
import de.mkammerer.argon2.Argon2Factory;

public class CreateUser {
    public static void main(String[] args) {
        String password = "zxczxc123";
        Argon2 argon2 = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);
        String hash = argon2.hash(2, 65536, 1, password.toCharArray());
        System.out.println("HASH_RESULT:" + hash);
    }
}
