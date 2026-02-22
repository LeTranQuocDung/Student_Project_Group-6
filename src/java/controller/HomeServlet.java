package controller;

import dal.ProductDAO;
import model.ProductDTO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/search"})
public class HomeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy từ khóa tìm kiếm (nếu có)
        String txtSearch = request.getParameter("txt"); // Tên ô input bên JSP là "txt" hay "search" ông check lại nhé
        if (txtSearch == null) {
            // Trường hợp dùng form search của shopee_home.jsp nãy thì name="txt" hay name="key" phải khớp
            // Code HTML nãy tui đưa là <input name="txt" ...> nên OK.
            // Nếu dùng SearchServlet riêng thì có thể khác.
        }

        // 2. Gọi DAO để lấy danh sách sản phẩm
        ProductDAO dao = new ProductDAO();
        List<ProductDTO> list = dao.searchProducts(txtSearch);

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("products", list);
        request.setAttribute("txtS", txtSearch); // Giữ lại từ khóa tìm kiếm

        request.getRequestDispatcher("shopee_home.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
