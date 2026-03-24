package controller;

import dal.ReviewModerationDAO;
import dal.AuditLogDAO;
import model.Review;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReviewServlet", urlPatterns = {"/admin-reviews"})
public class AdminReviewServlet extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReviewModerationDAO dao = new ReviewModerationDAO();
        dao.ensureStatusColumn(); // Auto-migrate nếu chưa có cột status

        // Filter theo trạng thái
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "ALL";
        }

        // Phân trang
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;

        List<Review> reviews = dao.getReviewsByStatus(statusFilter, page, PAGE_SIZE);
        int totalReviews = dao.countByStatus(statusFilter);
        int totalPages = (int) Math.ceil((double) totalReviews / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        // Status counts cho badges
        int[] counts = dao.getStatusCounts();

        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("pendingCount", counts[0]);
        request.setAttribute("approvedCount", counts[1]);
        request.setAttribute("rejectedCount", counts[2]);

        request.getRequestDispatcher("admin_reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        if (admin == null) { response.sendRedirect("login"); return; }

        ReviewModerationDAO dao = new ReviewModerationDAO();
        AuditLogDAO logDAO = new AuditLogDAO();
        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("reviewId"));
            dao.updateStatus(id, "APPROVED");
            logDAO.insertLog(admin.getId(), "APPROVE", "reviews", String.valueOf(id), "Approved review #" + id);

        } else if ("reject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("reviewId"));
            dao.updateStatus(id, "REJECTED");
            logDAO.insertLog(admin.getId(), "REJECT", "reviews", String.valueOf(id), "Rejected review #" + id);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("reviewId"));
            dao.deleteReview(id);
            logDAO.insertLog(admin.getId(), "DELETE", "reviews", String.valueOf(id), "Permanently deleted review #" + id);

        } else if ("bulk_approve".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            int count = dao.bulkUpdateStatus(ids, "APPROVED");
            logDAO.insertLog(admin.getId(), "BULK_APPROVE", "reviews", null, "Bulk approved " + count + " reviews");

        } else if ("bulk_reject".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            int count = dao.bulkUpdateStatus(ids, "REJECTED");
            logDAO.insertLog(admin.getId(), "BULK_REJECT", "reviews", null, "Bulk rejected " + count + " reviews");

        } else if ("bulk_delete".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            int count = dao.bulkDelete(ids);
            logDAO.insertLog(admin.getId(), "BULK_DELETE", "reviews", null, "Bulk deleted " + count + " reviews");
        }

        // Redirect back, giữ filter hiện tại
        String statusFilter = request.getParameter("statusFilter");
        response.sendRedirect("admin-reviews" + (statusFilter != null ? "?status=" + statusFilter : ""));
    }
}
