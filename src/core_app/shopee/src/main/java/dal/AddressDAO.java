package dal;

import model.Address;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO extends DBContext {

    public void initTable() {
        String sql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='user_addresses' AND xtype='U') " +
                "CREATE TABLE user_addresses (" +
                "id INT IDENTITY(1,1) PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "full_name NVARCHAR(100), " +
                "phone NVARCHAR(20), " +
                "address_detail NVARCHAR(500), " +
                "is_default BIT DEFAULT 0, " +
                "FOREIGN KEY (user_id) REFERENCES users(id))";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Address> getByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapAddress(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addAddress(Address addr) {
        // If this is the first address or set as default, clear other defaults
        if (addr.isDefault()) {
            clearDefault(addr.getUserId());
        }
        String sql = "INSERT INTO user_addresses (user_id, full_name, phone, address_detail, is_default) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addr.getUserId());
            ps.setString(2, addr.getFullName());
            ps.setString(3, addr.getPhone());
            ps.setString(4, addr.getAddressDetail());
            ps.setBoolean(5, addr.isDefault());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAddress(Address addr) {
        if (addr.isDefault()) {
            clearDefault(addr.getUserId());
        }
        String sql = "UPDATE user_addresses SET full_name = ?, phone = ?, address_detail = ?, is_default = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, addr.getFullName());
            ps.setString(2, addr.getPhone());
            ps.setString(3, addr.getAddressDetail());
            ps.setBoolean(4, addr.isDefault());
            ps.setInt(5, addr.getId());
            ps.setInt(6, addr.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAddress(int id, int userId) {
        String sql = "DELETE FROM user_addresses WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setDefault(int id, int userId) {
        clearDefault(userId);
        String sql = "UPDATE user_addresses SET is_default = 1 WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void clearDefault(int userId) {
        String sql = "UPDATE user_addresses SET is_default = 0 WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Address getById(int id) {
        String sql = "SELECT * FROM user_addresses WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapAddress(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Address mapAddress(ResultSet rs) throws Exception {
        Address a = new Address();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setFullName(rs.getString("full_name"));
        a.setPhone(rs.getString("phone"));
        a.setAddressDetail(rs.getString("address_detail"));
        a.setDefault(rs.getBoolean("is_default"));
        return a;
    }
}
