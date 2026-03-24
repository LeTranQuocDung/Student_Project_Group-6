package dal;

import model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM admin_roles";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Role(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Role getRoleById(int id) {
        String sql = "SELECT id, name, description FROM admin_roles WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                );
                // Load permissions
                PermissionDAO permDao = new PermissionDAO();
                role.setPermissions(permDao.getPermissionsByRoleId(id));
                return role;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertRole(Role role) {
        String sql = "INSERT INTO admin_roles (name, description) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Return new ID
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateRole(Role role) {
        String sql = "UPDATE admin_roles SET name = ?, description = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            ps.setInt(3, role.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteRole(int id) {
        String sql = "DELETE FROM admin_roles WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void setRolePermissions(int roleId, String[] permissionIds) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // 1. Delete old permissions
            String delSql = "DELETE FROM admin_role_permissions WHERE role_id = ?";
            try (PreparedStatement delPs = conn.prepareStatement(delSql)) {
                delPs.setInt(1, roleId);
                delPs.executeUpdate();
            }
            
            // 2. Insert new permissions
            if (permissionIds != null && permissionIds.length > 0) {
                String insSql = "INSERT INTO admin_role_permissions (role_id, permission_id) VALUES (?, ?)";
                try (PreparedStatement insPs = conn.prepareStatement(insSql)) {
                    for (String pId : permissionIds) {
                        insPs.setInt(1, roleId);
                        insPs.setString(2, pId);
                        insPs.addBatch();
                    }
                    insPs.executeBatch();
                }
            }
            
            conn.commit();
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
