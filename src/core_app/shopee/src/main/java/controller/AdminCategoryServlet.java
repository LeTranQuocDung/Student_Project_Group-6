package controller;

import dal.CategoryDAO;
import dal.AuditLogDAO;
import model.Category;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = { "/admin-categories" })
public class AdminCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CategoryDAO dao = new CategoryDAO();
        
        if ("view_trash".equals(action)) {
            List<Category> trashedCategories = dao.getDeletedCategories();
            request.setAttribute("categories", trashedCategories);
            request.setAttribute("isTrash", true); // Báo cho jsp biết đang ở thùng rác
            request.getRequestDispatcher("admin_categories.jsp").forward(request, response);
            return;
        }

        List<Category> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("admin_categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        CategoryDAO dao = new CategoryDAO();
        AuditLogDAO audit = new AuditLogDAO();
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        int adminId = (admin != null) ? admin.getId() : 1;

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String imageUrl = request.getParameter("image_url");

                if (imageUrl == null || imageUrl.isEmpty()) {
                    imageUrl = "images/cat_default.webp";
                }

                dao.insertCategory(name, imageUrl);
                audit.insertLog(adminId, "CREATE", "categories", "-", "Thêm mới danh mục: " + name);

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String imageUrl = request.getParameter("image_url");

                dao.updateCategory(id, name, imageUrl);
                audit.insertLog(adminId, "UPDATE", "categories", String.valueOf(id), "Cập nhật danh mục: " + name);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteCategory(id);
                audit.insertLog(adminId, "DELETE", "categories", String.valueOf(id), "Xóa danh mục vào thùng rác");
            } else if ("restore".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.restoreCategory(id);
                audit.insertLog(adminId, "RESTORE", "categories", String.valueOf(id), "Khôi phục danh mục từ thùng rác");
                response.sendRedirect("admin-categories?action=view_trash");
                return;
            } else if ("bulk_delete".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeleteCategories(ids);
                    audit.insertLog(adminId, "DELETE", "categories", String.join(",", ids), "Xóa hàng loạt " + ids.length + " danh mục vào thùng rác");
                }
            } else if ("bulk_restore".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkRestoreCategories(ids);
                    audit.insertLog(adminId, "RESTORE", "categories", String.join(",", ids), "Khôi phục hàng loạt " + ids.length + " danh mục từ thùng rác");
                }
                response.sendRedirect("admin-categories?action=view_trash");
                return;
            } else if ("bulk_delete_permanent".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeletePermanentCategories(ids);
                    audit.insertLog(adminId, "DELETE_FERM", "categories", String.join(",", ids), "Xóa VĨNH VIỄN hàng loạt " + ids.length + " danh mục khỏi hệ thống");
                }
                response.sendRedirect("admin-categories?action=view_trash");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-categories");
    }
}
