<%@ page pageEncoding="UTF-8" %>
<%-- SHARED SIDEBAR - Dùng chung cho tất cả trang admin --%>
<% String currentPage = request.getServletPath(); %>
<div class="sidebar d-flex flex-column" style="overflow-y: auto;">
    <div class="sidebar-logo">
        <h4><i class="fas fa-shopping-bag me-1"></i> Admin Panel</h4>
    </div>
    <% model.User s_admin = (model.User) session.getAttribute("account"); %>
    <div class="mt-4 flex-grow-1" style="overflow-y: auto; padding-bottom: 10px;">
        <% if (s_admin != null && s_admin.hasPermission("VIEW_DASHBOARD")) { %>
        <div class="nav-item"><a href="admin" class="<%= "/admin".equals(currentPage) ? "active" : "" %>"><i class="fas fa-chart-pie"></i> T&#7893;ng Quan</a></div>
        <% } %>
        <% if (s_admin != null && s_admin.hasPermission("MANAGE_ROLES")) { %>
        <div class="nav-item"><a href="admin-roles" class="<%= "/admin-roles".equals(currentPage) ? "active" : "" %>"><i class="fas fa-user-shield"></i> Nh&#243;m Quy&#7873;n</a></div>
        <% } %>
        <% if (s_admin != null && s_admin.hasPermission("MANAGE_SYSTEM")) { %>
        <div class="nav-item"><a href="admin-import" class="<%= "/admin-import".equals(currentPage) ? "active" : "" %>"><i class="fas fa-database"></i> Qu&#7843;n l&#253; D&#7919; Li&#7879;u</a></div>
        <div class="nav-item"><a href="admin-settings" class="<%= "/admin-settings".equals(currentPage) ? "active" : "" %>"><i class="fas fa-cog"></i> C&#7845;u H&#236;nh H&#7879; Th&#7889;ng</a></div>
        <div class="nav-item"><a href="admin-generate" class="<%= "/admin-generate".equals(currentPage) ? "active" : "" %>"><i class="fas fa-magic"></i> T&#7841;o D&#7919; Li&#7879;u</a></div>
        <% } %>
        <% if (s_admin != null && s_admin.hasPermission("MANAGE_PRODUCTS")) { %>
        <div class="nav-item"><a href="admin-products" class="<%= "/admin-products".equals(currentPage) ? "active" : "" %>"><i class="fas fa-box-open"></i> S&#7843;n Ph&#7849;m</a></div>
        <div class="nav-item"><a href="admin-categories" class="<%= "/admin-categories".equals(currentPage) ? "active" : "" %>"><i class="fas fa-tags"></i> Danh M&#7909;c</a></div>
        <div class="nav-item"><a href="admin-shops" class="<%= "/admin-shops".equals(currentPage) ? "active" : "" %>"><i class="fas fa-store"></i> Qu&#7843;n L&#253; Shop</a></div>
        <% } %>
        <% if (s_admin != null && s_admin.hasPermission("MANAGE_ORDERS")) { %>
        <div class="nav-item"><a href="admin-orders" class="<%= "/admin-orders".equals(currentPage) ? "active" : "" %>"><i class="fas fa-clipboard-list"></i> &#272;&#417;n H&#224;ng</a></div>
        <% } %>
        <% if (s_admin != null && s_admin.hasPermission("MANAGE_USERS")) { %>
        <div class="nav-item"><a href="admin-users" class="<%= "/admin-users".equals(currentPage) ? "active" : "" %>"><i class="fas fa-users"></i> Kh&#225;ch H&#224;ng</a></div>
        <% } %>
        <div class="nav-item"><a href="admin-reviews" class="<%= "/admin-reviews".equals(currentPage) ? "active" : "" %>"><i class="fas fa-star-half-alt"></i> X&#233;t Duy&#7879;t &#272;&#225;nh Gi&#225;</a></div>
        <div class="nav-item"><a href="admin-alerts" class="<%= "/admin-alerts".equals(currentPage) ? "active" : "" %>"><i class="fas fa-exclamation-triangle"></i> C&#7843;nh B&#225;o B&#7845;t Th&#432;&#7901;ng</a></div>
        <% if (s_admin != null && s_admin.hasPermission("VIEW_AUDIT_LOGS")) { %>
        <div class="nav-item"><a href="admin-logs" class="<%= "/admin-logs".equals(currentPage) ? "active" : "" %>"><i class="fas fa-history"></i> Nh&#7853;t K&#253;</a></div>
        <% } %>
        <div class="nav-item"><a href="home" target="_blank"><i class="fas fa-globe"></i> Truy C&#7853;p C&#7917;a H&#224;ng</a></div>
    </div>
    <div class="nav-item mb-4 border-top pt-3">
        <a href="logout" class="text-danger"><i class="fas fa-sign-out-alt"></i> &#272;&#259;ng Xu&#7845;t</a>
    </div>
</div>
