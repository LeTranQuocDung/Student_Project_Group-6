package controller;

import dal.StressDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StressTestServlet", urlPatterns = {"/api/buy"})
public class StressTestServlet extends HttpServlet {

    @Override
    protected synchronized void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StressDAO dao = new StressDAO();
        int productId = 1;

        if (request.getParameter("reset") != null) {
            dao.resetStock(productId);
            response.getWriter().print("Da reset kho ve 1");
            return;
        }

        boolean result = dao.buyProduct(productId);

        if (result) {
            response.getWriter().print("MUA_THANH_CONG");
        } else {
            response.getWriter().print("HET_HANG");
        }
    }
}
