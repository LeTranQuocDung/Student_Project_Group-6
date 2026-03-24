package controller;

import dal.UserDAO;
import dal.AuditLogDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUserServlet", urlPatterns = { "/admin-users" })
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();
        
        if ("view_trash".equals(action)) {
            List<User> trashedUsers = dao.getDeletedUsers();
            request.setAttribute("users", trashedUsers);
            request.setAttribute("isTrash", true);
            request.getRequestDispatcher("admin_users.jsp").forward(request, response);
            return;
        }

        List<User> users = dao.getAllUsers();
        request.setAttribute("users", users);
        
        // Nạp danh sách Nhóm Quyền để gán
        dal.RoleDAO roleDao = new dal.RoleDAO();
        request.setAttribute("adminRoles", roleDao.getAllRoles());
        
        request.getRequestDispatcher("admin_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();
        AuditLogDAO audit = new AuditLogDAO();
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        int adminId = (admin != null) ? admin.getId() : 1;

        try {
            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("id"));
                dao.deleteUser(userId);
                audit.insertLog(adminId, "DELETE", "users", String.valueOf(userId), "Xóa khách hàng hoặc Admin");
            } else if ("restore".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("id"));
                dao.restoreUser(userId);
                audit.insertLog(adminId, "RESTORE", "users", String.valueOf(userId), "Khôi phục tài khoản người dùng");
                response.sendRedirect("admin-users?action=view_trash");
                return;
            } else if ("assign_role".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("id"));
                String roleIdStr = request.getParameter("admin_role_id");
                
                if (roleIdStr != null && !roleIdStr.isEmpty() && !roleIdStr.equals("0")) {
                    Integer assignedRoleId = Integer.valueOf(roleIdStr);
                    // Nâng cấp thành ADMIN và gán Role ID
                    dao.updateRole(userId, "ADMIN");
                    dao.updateAdminRole(userId, assignedRoleId);
                    audit.insertLog(adminId, "UPDATE", "users", String.valueOf(userId), "Cấp quyền Admin (Role ID: " + assignedRoleId + ")");
                } else {
                    // Thu hồi quyền Admin (Giáng cấp xuống CUSTOMER)
                    dao.updateRole(userId, "CUSTOMER");
                    dao.updateAdminRole(userId, (Integer) null);
                    audit.insertLog(adminId, "UPDATE", "users", String.valueOf(userId), "Thu hồi quyền Admin (Giáng cấp Customer)");
                }
                
                request.getSession().setAttribute("successMessage", "Đã cập nhật phân quyền thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-users");
    }
}
