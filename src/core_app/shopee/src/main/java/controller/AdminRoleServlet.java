package controller;

import dal.PermissionDAO;
import dal.RoleDAO;
import model.Permission;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminRoleServlet", urlPatterns = {"/admin-roles"})
public class AdminRoleServlet extends HttpServlet {

    private RoleDAO roleDAO;
    private PermissionDAO permissionDAO;

    @Override
    public void init() throws ServletException {
        roleDAO = new RoleDAO();
        permissionDAO = new PermissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRole(request, response);
                break;
            default:
                listRoles(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createRole(request, response);
        } else if ("update".equals(action)) {
            updateRole(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-roles");
        }
    }

    private void listRoles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = roleDAO.getAllRoles();
        // Nạp permissions cho từng role để hiện thị (nếu cần)
        for(Role r : roles) {
            r.setPermissions(permissionDAO.getPermissionsByRoleId(r.getId()));
        }
        List<Permission> allPermissions = permissionDAO.getAllPermissions();
        
        request.setAttribute("roles", roles);
        request.setAttribute("allPermissions", allPermissions);
        request.getRequestDispatcher("admin_roles.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Role existingRole = roleDAO.getRoleById(id);
        List<Permission> allPermissions = permissionDAO.getAllPermissions();
        
        request.setAttribute("role", existingRole);
        request.setAttribute("allPermissions", allPermissions);
        request.getRequestDispatcher("admin_roles.jsp").forward(request, response);
    }

    private void createRole(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] permissionIds = request.getParameterValues("permissions");

        Role newRole = new Role(0, name, description);
        int newId = roleDAO.insertRole(newRole);
        
        if (newId > 0 && permissionIds != null) {
            roleDAO.setRolePermissions(newId, permissionIds);
        }

        request.getSession().setAttribute("successMessage", "Đã tạo nhóm quyền thành công!");
        response.sendRedirect(request.getContextPath() + "/admin-roles");
    }

    private void updateRole(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] permissionIds = request.getParameterValues("permissions");

        // Super Admin ID = 1 không được phép đổi tên/xóa
        if (id == 1) {
            request.getSession().setAttribute("errorMessage", "Không thể sửa Full Quyền của Super Admin!");
            response.sendRedirect(request.getContextPath() + "/admin-roles");
            return;
        }

        Role role = new Role(id, name, description);
        roleDAO.updateRole(role);
        
        if (permissionIds != null) {
            roleDAO.setRolePermissions(id, permissionIds);
        } else {
            roleDAO.setRolePermissions(id, new String[0]); // Clear all
        }

        request.getSession().setAttribute("successMessage", "Đã cập nhật nhóm quyền thành công!");
        response.sendRedirect(request.getContextPath() + "/admin-roles");
    }

    private void deleteRole(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (id == 1) {
            request.getSession().setAttribute("errorMessage", "Không thể xóa nhóm Super Admin!");
        } else {
            roleDAO.deleteRole(id);
            request.getSession().setAttribute("successMessage", "Đã xóa nhóm quyền!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-roles");
    }
}
