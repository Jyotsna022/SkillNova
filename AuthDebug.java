import com.skillnova.util.DBConnection;
import com.skillnova.util.PasswordUtil;
import java.sql.*;

public class AuthDebug {
  public static void main(String[] args) throws Exception {
    String email = "admin@skillnova.com";
    String password = "Admin@123";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement s = c.prepareStatement("SELECT u.user_id, u.email, u.account_status, u.password_hash, r.role_name FROM users u JOIN roles r ON r.role_id=u.role_id WHERE u.email=?")) {
      s.setString(1, email);
      try (ResultSet rs = s.executeQuery()) {
        if (!rs.next()) {
          System.out.println("NO_USER");
          return;
        }
        String status = rs.getString("account_status");
        String hash = rs.getString("password_hash");
        System.out.println("user_id=" + rs.getLong("user_id"));
        System.out.println("role=" + rs.getString("role_name"));
        System.out.println("status=" + status);
        System.out.println("statusActive=" + "ACTIVE".equalsIgnoreCase(status));
        System.out.println("verify=" + PasswordUtil.verifyPassword(password, hash));
      }
    }
  }
}
