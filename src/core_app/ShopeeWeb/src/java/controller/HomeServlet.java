package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductDTO;
import java.io.IOException;
import javax.servlet.ServletException; // Đổi từ jakarta sang javax
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

 
    static final String DB_URL = 
    
 "jdbc:sqlserver://localhost:1433;"
+ "databaseName=ShopeeDB;"
+ "encrypt=true;"
+ "trustServerCertificate=true;";

String user = "sa";
String pass = "123456";

     

   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy từ khóa tìm kiếm từ JSP gửi về (giả sử tên ô input là name="txt")
        String txtSearch = request.getParameter("txt"); 
        List<ProductDTO> list = new ArrayList<>();
        
        // 2. Xây dựng câu SQL cơ bản
        String sql = "SELECT TOP 60 p.id, p.name, s.shop_name, MIN(v.price) as min_price " +
                     "FROM Products p " +
                     "JOIN Shops s ON p.shop_id = s.id " +
                     "JOIN ProductVariants v ON p.id = v.product_id ";
        
        // 3. Nếu có tìm kiếm -> Thêm điều kiện WHERE
        if (txtSearch != null && !txtSearch.trim().isEmpty()) {
            sql += "WHERE p.name LIKE ? ";
        }
        
        sql += "GROUP BY p.id, p.name, s.shop_name ORDER BY p.id DESC";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, user, pass);
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                // 4. Nếu có tìm kiếm -> Nhét từ khóa vào dấu ?
                if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                    ps.setString(1, "%" + txtSearch + "%"); // Tìm tương đối (%chuỗi%)
                }
                
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(new ProductDTO(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("shop_name"),
                            rs.getDouble("min_price")
                        ));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 5. Trả về list sản phẩm
        request.setAttribute("products", list);
        // Trả lại từ khóa để ô tìm kiếm không bị mất chữ sau khi load lại
        request.setAttribute("txtS", txtSearch); 
        
        request.getRequestDispatcher("shopee_home.jsp").forward(request, response);
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}