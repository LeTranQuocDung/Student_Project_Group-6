package controller;

import dal.ProductDAO;
import dal.AuditLogDAO;
import dal.ShopDAO;
import model.Product;
import model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminProductServlet", urlPatterns = { "/admin-products" })
public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String pageRaw = request.getParameter("page");
        String action = request.getParameter("action");
        int page = 1;
        if (pageRaw != null && !pageRaw.isEmpty()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (Exception e) {}
        }

        ProductDAO dao = new ProductDAO();
        dal.CategoryDAO cateDao = new dal.CategoryDAO();
        
        if ("view_trash".equals(action)) {
            List<Product> trashedProducts = dao.getDeletedProducts(search, page);
            request.setAttribute("products", trashedProducts);
            request.setAttribute("isTrash", true);
            request.setAttribute("categories", cateDao.getAllCategories());
            request.setAttribute("shops", new ShopDAO().getAllShopsSimple());
            request.getRequestDispatcher("admin_products.jsp").forward(request, response);
            return;
        }
        
        int totalProducts = dao.countAdminProducts(search);
        int totalPages = (int) Math.ceil((double) totalProducts / dao.getPageSize());
        
        List<Product> products = dao.getAdminProducts(search, page);
        
        request.setAttribute("products", products);
        request.setAttribute("categories", cateDao.getAllCategories());
        request.setAttribute("shops", new ShopDAO().getAllShopsSimple());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search != null ? search : "");
        request.getRequestDispatcher("admin_products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();
        AuditLogDAO audit = new AuditLogDAO();
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        int adminId = (admin != null) ? admin.getId() : 1;

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");
                String cateRaw = request.getParameter("category_id");

                if (image == null || image.isEmpty()) {
                    image = "https://down-vn.img.susercontent.com/file/sg-11134201-22100-s6q7y2y2mhivda";
                }

                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) {
                    price = new BigDecimal(priceRaw);
                }
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    request.getSession().setAttribute("errorMessage", "Giá sản phẩm không được âm!");
                    response.sendRedirect("admin-products");
                    return;
                }
                int categoryId = (cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 1;
                String shopIdRaw = request.getParameter("shop_id");
                int shopId = (shopIdRaw != null && !shopIdRaw.isEmpty()) ? Integer.parseInt(shopIdRaw) : 1;

                dao.insertProduct(name, price, image, categoryId, shopId);
                audit.insertLog(adminId, "CREATE", "products", "-", "Thêm mới sản phẩm: " + name);

            } else if ("edit".equals(action)) {
                String idRaw = request.getParameter("id");
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");
                String cateRaw = request.getParameter("category_id");

                int id = Integer.parseInt(idRaw);
                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) {
                    price = new BigDecimal(priceRaw);
                }
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    request.getSession().setAttribute("errorMessage", "Giá sản phẩm không được âm!");
                    response.sendRedirect("admin-products");
                    return;
                }
                int categoryId = (cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 1;
                String shopIdRaw = request.getParameter("shop_id");
                int shopId = (shopIdRaw != null && !shopIdRaw.isEmpty()) ? Integer.parseInt(shopIdRaw) : 1;

                dao.updateProduct(id, name, price, image, categoryId, shopId);
                audit.insertLog(adminId, "UPDATE", "products", idRaw, "Cập nhật sản phẩm: " + name);

            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                dao.deleteProduct(id);
                audit.insertLog(adminId, "DELETE", "products", id, "Xóa sản phẩm vào thùng rác");
            } else if ("restore".equals(action)) {
                String id = request.getParameter("id");
                dao.restoreProduct(id);
                audit.insertLog(adminId, "RESTORE", "products", id, "Khôi phục sản phẩm từ thùng rác");
                response.sendRedirect("admin-products?action=view_trash");
                return;
            } else if ("bulk_delete".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeleteProducts(ids);
                    audit.insertLog(adminId, "DELETE", "products", String.join(",", ids), "Xóa hàng loạt " + ids.length + " sản phẩm vào thùng rác");
                }
            } else if ("bulk_restore".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkRestoreProducts(ids);
                    audit.insertLog(adminId, "RESTORE", "products", String.join(",", ids), "Khôi phục hàng loạt " + ids.length + " sản phẩm từ thùng rác");
                }
                response.sendRedirect("admin-products?action=view_trash");
                return;
            } else if ("bulk_delete_permanent".equals(action)) {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null && ids.length > 0) {
                    dao.bulkDeletePermanentProducts(ids);
                    audit.insertLog(adminId, "DELETE_FERM", "products", String.join(",", ids), "Xóa VĨNH VIỄN hàng loạt " + ids.length + " sản phẩm khỏi hệ thống");
                }
                response.sendRedirect("admin-products?action=view_trash");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-products");
    }
}
