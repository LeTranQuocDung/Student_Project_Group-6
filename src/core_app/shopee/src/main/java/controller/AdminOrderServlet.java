package controller;

import dal.OrderDAO;
import dal.AuditLogDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminOrderServlet", urlPatterns = { "/admin-orders" })
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();
        
        if ("view_trash".equals(action)) {
            List<String[]> trashedOrders = dao.getDeletedOrders();
            request.setAttribute("orders", trashedOrders);
            request.setAttribute("isTrash", true); // Flag for jsp
            request.setAttribute("currentStatus", "ALL"); // Trash view usually shows all statuses
            request.getRequestDispatcher("admin_orders.jsp").forward(request, response);
            return;
        }

        List<String[]> orders = dao.getAllOrders(status);
        request.setAttribute("orders", orders);
        request.setAttribute("currentStatus", status != null ? status : "ALL");
        request.getRequestDispatcher("admin_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();
        AuditLogDAO audit = new AuditLogDAO();
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        int adminId = (admin != null) ? admin.getId() : 1;

        try {
            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                dao.updateOrderStatus(orderId, status);
                audit.insertLog(adminId, "UPDATE", "orders", String.valueOf(orderId), "Cập nhật trạng thái đơn hàng thành: " + status);
            } else if ("delete".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                dao.deleteOrder(orderId);
                audit.insertLog(adminId, "DELETE", "orders", String.valueOf(orderId), "Xóa đơn hàng vào thùng rác");
            } else if ("restore".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                dao.restoreOrder(orderId);
                audit.insertLog(adminId, "RESTORE", "orders", String.valueOf(orderId), "Khôi phục đơn hàng từ thùng rác");
                response.sendRedirect("admin-orders?action=view_trash");
                return;
            } else if ("bulk_update_status".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                String newStatus = request.getParameter("bulk_status");
                if (ids != null && ids.length > 0 && newStatus != null) {
                    dao.bulkUpdateOrderStatus(ids, newStatus);
                    audit.insertLog(adminId, "UPDATE", "orders", String.join(",", ids), "Cập nhật hàng loạt " + ids.length + " đơn hàng thành: " + newStatus);
                }
            } else if ("bulk_delete".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeleteOrders(ids);
                    audit.insertLog(adminId, "DELETE", "orders", String.join(",", ids), "Chuyển hàng loạt " + ids.length + " đơn hàng vào thùng rác");
                }
            } else if ("bulk_restore".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkRestoreOrders(ids);
                    audit.insertLog(adminId, "RESTORE", "orders", String.join(",", ids), "Khôi phục hàng loạt " + ids.length + " đơn hàng từ thùng rác");
                }
                response.sendRedirect("admin-orders?action=view_trash");
                return;
            } else if ("bulk_delete_permanent".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeletePermanentOrders(ids);
                    audit.insertLog(adminId, "DELETE_FERM", "orders", String.join(",", ids), "Xóa VĨNH VIỄN hàng loạt " + ids.length + " đơn hàng và dữ liệu giỏ hàng liên quan");
                }
                response.sendRedirect("admin-orders?action=view_trash");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-orders");
    }
}
