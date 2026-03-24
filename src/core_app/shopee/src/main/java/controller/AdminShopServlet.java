package controller;

import dal.ShopDAO;
import dal.AuditLogDAO;
import dal.ProductDAO;
import dal.CategoryDAO;
import model.Shop;
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

@WebServlet(name = "AdminShopServlet", urlPatterns = { "/admin-shops" })
public class AdminShopServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ShopDAO dao = new ShopDAO();

        if ("detail".equals(action)) {
            // --- Chi tiết 1 shop ---
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("admin-shops");
                return;
            }
            try {
                int shopId = Integer.parseInt(idStr);
                Shop shop = dao.getShopById(shopId);
                if (shop == null) {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy shop #" + shopId);
                    response.sendRedirect("admin-shops");
                    return;
                }

                // Stats
                double[] stats = dao.getShopStats(shopId);
                request.setAttribute("shop", shop);
                request.setAttribute("totalRevenue", stats[0]);
                request.setAttribute("orderCount", (int) stats[1]);
                request.setAttribute("productCount", (int) stats[2]);

                // Orders
                String status = request.getParameter("status");
                List<String[]> orders = dao.getShopOrders(shopId, status);
                request.setAttribute("orders", orders);
                request.setAttribute("currentStatus", status != null ? status : "ALL");

                // Products of this shop
                ProductDAO pdao = new ProductDAO();
                String productSearch = request.getParameter("psearch");
                String ppageRaw = request.getParameter("ppage");
                int ppage = 1;
                if (ppageRaw != null && !ppageRaw.isEmpty()) {
                    try { ppage = Integer.parseInt(ppageRaw); } catch (Exception ex) {}
                }
                List<Product> shopProducts = pdao.getProductsByShopId(shopId, productSearch, ppage);
                int totalShopProducts = pdao.countProductsByShopId(shopId, productSearch);
                int productTotalPages = (int) Math.ceil((double) totalShopProducts / 30);
                request.setAttribute("shopProducts", shopProducts);
                request.setAttribute("productPage", ppage);
                request.setAttribute("productTotalPages", productTotalPages);
                request.setAttribute("productSearch", productSearch != null ? productSearch : "");

                // Categories + shops for add/edit modals
                request.setAttribute("categories", new CategoryDAO().getAllCategories());

                request.getRequestDispatcher("admin_shop_detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("admin-shops");
            }
            return;
        }

        // --- Mặc định: Danh sách tất cả shops ---
        List<Shop> shops = dao.getAllShopsForAdmin();
        request.setAttribute("shops", shops);
        request.getRequestDispatcher("admin_shops.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ShopDAO dao = new ShopDAO();
        AuditLogDAO audit = new AuditLogDAO();

        jakarta.servlet.http.HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");
        int adminId = (admin != null) ? admin.getId() : 1;

        try {
            if ("edit".equals(action)) {
                int shopId = Integer.parseInt(request.getParameter("id"));
                String shopName = request.getParameter("shop_name");
                String ratingStr = request.getParameter("rating");
                String location = request.getParameter("location");

                double rating = 0;
                if (ratingStr != null && !ratingStr.isEmpty()) {
                    rating = Double.parseDouble(ratingStr);
                }
                if (rating < 0) rating = 0;
                if (rating > 5) rating = 5;

                boolean ok = dao.updateShop(shopId, shopName, rating, location);
                if (ok) {
                    session.setAttribute("successMessage", "Cập nhật shop #" + shopId + " thành công!");
                    audit.insertLog(adminId, "UPDATE", "shops", String.valueOf(shopId),
                            "Cập nhật shop: " + shopName + " (rating=" + rating + ")");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật shop #" + shopId);
                }
                response.sendRedirect("admin-shops?action=detail&id=" + shopId);
                return;
            }

            if ("create".equals(action)) {
                String shopName = request.getParameter("shop_name");
                String ratingStr = request.getParameter("rating");
                String location = request.getParameter("location");

                if (shopName == null || shopName.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Tên shop không được để trống!");
                    response.sendRedirect("admin-shops");
                    return;
                }

                double rating = 0;
                if (ratingStr != null && !ratingStr.isEmpty()) {
                    rating = Double.parseDouble(ratingStr);
                }
                if (rating < 0) rating = 0;
                if (rating > 5) rating = 5;

                int newId = dao.createShop(shopName.trim(), 1, rating, location);
                if (newId > 0) {
                    session.setAttribute("successMessage", "Tạo shop \"" + shopName + "\" thành công! (ID: #" + newId + ")");
                    audit.insertLog(adminId, "CREATE", "shops", String.valueOf(newId),
                            "Tạo shop mới: " + shopName);
                } else {
                    session.setAttribute("errorMessage", "Không thể tạo shop mới!");
                }
                response.sendRedirect("admin-shops");
                return;
            }

            if ("add_product".equals(action)) {
                int shopId = Integer.parseInt(request.getParameter("shop_id"));
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");
                String cateRaw = request.getParameter("category_id");
                if (image == null || image.isEmpty()) {
                    image = "https://down-vn.img.susercontent.com/file/sg-11134201-22100-s6q7y2y2mhivda";
                }
                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) price = new BigDecimal(priceRaw);
                int categoryId = (cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 1;
                new ProductDAO().insertProduct(name, price, image, categoryId, shopId);
                audit.insertLog(adminId, "CREATE", "products", "-", "Th\u00eam SP: " + name + " v\u00e0o shop #" + shopId);
                session.setAttribute("successMessage", "Th\u00eam s\u1ea3n ph\u1ea9m \"" + name + "\" th\u00e0nh c\u00f4ng!");
                response.sendRedirect("admin-shops?action=detail&id=" + shopId);
                return;
            }

            if ("edit_product".equals(action)) {
                int shopId = Integer.parseInt(request.getParameter("shop_id"));
                int productId = Integer.parseInt(request.getParameter("product_id"));
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");
                String cateRaw = request.getParameter("category_id");
                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) price = new BigDecimal(priceRaw);
                int categoryId = (cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 1;
                new ProductDAO().updateProduct(productId, name, price, image, categoryId, shopId);
                audit.insertLog(adminId, "UPDATE", "products", String.valueOf(productId), "S\u1eeda SP: " + name + " (shop #" + shopId + ")");
                session.setAttribute("successMessage", "C\u1eadp nh\u1eadt s\u1ea3n ph\u1ea9m #" + productId + " th\u00e0nh c\u00f4ng!");
                response.sendRedirect("admin-shops?action=detail&id=" + shopId);
                return;
            }

            if ("delete_product".equals(action)) {
                int shopId = Integer.parseInt(request.getParameter("shop_id"));
                String productId = request.getParameter("product_id");
                new ProductDAO().deleteProduct(productId);
                audit.insertLog(adminId, "DELETE", "products", productId, "X\u00f3a SP #" + productId + " c\u1ee7a shop #" + shopId);
                session.setAttribute("successMessage", "X\u00f3a s\u1ea3n ph\u1ea9m #" + productId + " th\u00e0nh c\u00f4ng!");
                response.sendRedirect("admin-shops?action=detail&id=" + shopId);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect("admin-shops");
    }
}
