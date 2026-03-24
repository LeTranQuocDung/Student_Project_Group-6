package controller;

import dal.AddressDAO;
import model.Address;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UserAddressServlet", urlPatterns = {"/user/account/address"})
public class UserAddressServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // Auto-create table if not exists
        new AddressDAO().initTable();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AddressDAO dao = new AddressDAO();
        List<Address> addresses = dao.getByUserId(acc.getId());
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/user_address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        AddressDAO dao = new AddressDAO();

        if ("add".equals(action)) {
            Address addr = new Address();
            addr.setUserId(acc.getId());
            addr.setFullName(request.getParameter("fullName"));
            addr.setPhone(request.getParameter("phone"));
            addr.setAddressDetail(request.getParameter("addressDetail"));
            addr.setDefault("on".equals(request.getParameter("isDefault")));

            if (dao.addAddress(addr)) {
                session.setAttribute("success", "Thêm địa chỉ thành công!");
            } else {
                session.setAttribute("error", "Thêm địa chỉ thất bại");
            }

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Address addr = new Address();
            addr.setId(id);
            addr.setUserId(acc.getId());
            addr.setFullName(request.getParameter("fullName"));
            addr.setPhone(request.getParameter("phone"));
            addr.setAddressDetail(request.getParameter("addressDetail"));
            addr.setDefault("on".equals(request.getParameter("isDefault")));

            if (dao.updateAddress(addr)) {
                session.setAttribute("success", "Cập nhật địa chỉ thành công!");
            } else {
                session.setAttribute("error", "Cập nhật địa chỉ thất bại");
            }

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.deleteAddress(id, acc.getId())) {
                session.setAttribute("success", "Xóa địa chỉ thành công!");
            } else {
                session.setAttribute("error", "Xóa địa chỉ thất bại");
            }

        } else if ("setDefault".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.setDefault(id, acc.getId())) {
                session.setAttribute("success", "Đã thiết lập địa chỉ mặc định!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/user/account/address");
    }
}
