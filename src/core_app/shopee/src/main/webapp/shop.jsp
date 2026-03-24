<%@page import="java.util.List" %>
<%@page import="model.Shop" %>
<%@page import="model.ProductDTO" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${shop.shopName} - Shopee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="css/home.css" rel="stylesheet">
    <style>
        body { background-color: #f5f5f5; font-family: 'Helvetica Neue', Arial, sans-serif; }

        /* ===== SHOP HEADER ===== */
        .shop-header-wrapper {
            background: linear-gradient(135deg, #ff6633, #ee4d2d);
            padding: 24px 0;
        }
        .shop-header {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            gap: 24px;
            padding: 0 15px;
        }
        .shop-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid #fff;
            object-fit: cover;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .shop-info { flex: 1; }
        .shop-name {
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 4px;
        }
        .shop-status {
            color: rgba(255,255,255,0.85);
            font-size: 13px;
        }
        .shop-actions { display: flex; gap: 10px; }
        .btn-follow {
            background: transparent;
            border: 1px solid #fff;
            color: #fff;
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-follow:hover { background: rgba(255,255,255,0.15); }
        .btn-follow.following { background: rgba(255,255,255,0.2); }
        .btn-chat-shop {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.5);
            color: #fff;
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-chat-shop:hover { background: rgba(255,255,255,0.25); }

        /* ===== SHOP STATS ===== */
        .shop-stats-bar {
            background: #fff;
            border-bottom: 1px solid #e8e8e8;
            padding: 12px 0;
        }
        .shop-stats {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            gap: 32px;
            padding: 0 15px;
            flex-wrap: wrap;
        }
        .stat-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: rgba(0,0,0,0.65);
        }
        .stat-item .stat-value {
            color: #ee4d2d;
            font-weight: 600;
        }

        /* ===== SORT & FILTER BAR ===== */
        .sort-bar {
            max-width: 1200px;
            margin: 16px auto 0;
            background: rgba(0,0,0,0.03);
            border-radius: 4px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .sort-bar span.label { color: rgba(0,0,0,0.54); font-size: 14px; }
        .sort-btn {
            background: #fff;
            border: 1px solid rgba(0,0,0,0.09);
            color: rgba(0,0,0,0.87);
            padding: 6px 16px;
            border-radius: 2px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.15s;
        }
        .sort-btn:hover { border-color: #ee4d2d; color: #ee4d2d; }
        .sort-btn.active { background: #ee4d2d; color: #fff; border-color: #ee4d2d; }

        /* ===== PRODUCT GRID ===== */
        .products-container {
            max-width: 1200px;
            margin: 16px auto;
            padding: 0 15px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
        }
        .product-card {
            background: #fff;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        .product-card img {
            width: 100%;
            aspect-ratio: 1;
            object-fit: cover;
        }
        .product-card .card-body { padding: 8px; }
        .product-card .product-name {
            font-size: 13px;
            color: rgba(0,0,0,0.87);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 36px;
            line-height: 1.4;
        }
        .product-card .product-price {
            color: #ee4d2d;
            font-size: 16px;
            font-weight: 600;
            margin-top: 8px;
        }
        .product-card .product-sold {
            font-size: 12px;
            color: rgba(0,0,0,0.54);
            margin-top: 4px;
        }
        .badge-label {
            position: absolute;
            top: 0;
            right: 0;
            background: #ee4d2d;
            color: #fff;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 0 0 0 4px;
        }

        /* ===== TOP SELLERS ===== */
        .top-sellers {
            max-width: 1200px;
            margin: 16px auto;
            padding: 0 15px;
        }
        .section-title {
            font-size: 16px;
            color: rgba(0,0,0,0.87);
            padding: 16px 0 12px;
            border-bottom: 1px solid #e8e8e8;
            margin-bottom: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }

        /* ===== PAGINATION ===== */
        .pagination-bar {
            max-width: 1200px;
            margin: 20px auto;
            display: flex;
            justify-content: center;
            gap: 6px;
            padding: 0 15px;
        }
        .page-btn {
            min-width: 40px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff;
            border: 1px solid rgba(0,0,0,0.09);
            color: rgba(0,0,0,0.87);
            text-decoration: none;
            font-size: 14px;
            border-radius: 4px;
            transition: all 0.15s;
        }
        .page-btn:hover { border-color: #ee4d2d; color: #ee4d2d; }
        .page-btn.active { background: #ee4d2d; color: #fff; border-color: #ee4d2d; }
        .page-btn.disabled { opacity: 0.5; pointer-events: none; }

        /* ===== EMPTY STATE ===== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: rgba(0,0,0,0.4);
        }
        .empty-state i { font-size: 48px; margin-bottom: 16px; }
        .empty-state p { font-size: 16px; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 992px) {
            .product-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 768px) {
            .product-grid { grid-template-columns: repeat(3, 1fr); }
            .shop-header { flex-direction: column; text-align: center; }
            .shop-actions { justify-content: center; }
            .shop-stats { justify-content: center; }
        }
        @media (max-width: 480px) {
            .product-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
<%
    Shop shop = (Shop) request.getAttribute("shop");
    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
    List<ProductDTO> topSellers = (List<ProductDTO>) request.getAttribute("topSellers");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String currentSort = (String) request.getAttribute("currentSort");
    boolean isFollowing = Boolean.TRUE.equals(request.getAttribute("isFollowing"));
%>

<!-- ===== SHOP HEADER ===== -->
<div class="shop-header-wrapper">
    <div class="shop-header">
        <img src="<%= shop.getOwnerAvatar() %>" alt="<%= shop.getShopName() %>" class="shop-avatar"
             onerror="this.src='https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(shop.getShopName(), "UTF-8") %>&background=ee4d2d&color=fff&size=80'">
        <div class="shop-info">
            <div class="shop-name"><%= shop.getShopName() %></div>
            <div class="shop-status">
                <i class="fas fa-circle" style="color:#2dc258; font-size:8px;"></i>
                Online
                &nbsp;·&nbsp;
                <i class="fas fa-map-marker-alt"></i> Hà Nội
            </div>
        </div>
        <div class="shop-actions">
            <button id="followBtn" class="btn-follow <%= isFollowing ? "following" : "" %>" onclick="toggleFollow()">
                <i class="fas fa-<%= isFollowing ? "check" : "plus" %>"></i>
                <span id="followText"><%= isFollowing ? "Đang Theo Dõi" : "Theo Dõi" %></span>
            </button>
            <button class="btn-chat-shop">
                <i class="far fa-comment-dots"></i> Chat
            </button>
        </div>
    </div>
</div>

<!-- ===== SHOP STATS ===== -->
<div class="shop-stats-bar">
    <div class="shop-stats">
        <div class="stat-item">
            <i class="fas fa-box"></i>
            Sản Phẩm: <span class="stat-value"><%= shop.getProductCount() %></span>
        </div>
        <div class="stat-item">
            <i class="fas fa-users"></i>
            Người Theo Dõi: <span class="stat-value" id="followerCount"><%= shop.getFollowerCount() %></span>
        </div>
        <div class="stat-item">
            <i class="fas fa-star"></i>
            Đánh Giá: <span class="stat-value"><%= String.format("%.1f", shop.getRating()) %> / 5.0</span>
        </div>
        <div class="stat-item">
            <i class="fas fa-reply"></i>
            Tỷ Lệ Phản Hồi: <span class="stat-value"><%= shop.getResponseRate() %></span>
        </div>
        <div class="stat-item">
            <i class="fas fa-clock"></i>
            Thời Gian Phản Hồi: <span class="stat-value"><%= shop.getResponseTime() %></span>
        </div>
        <div class="stat-item">
            <i class="fas fa-calendar-alt"></i>
            Tham Gia: <span class="stat-value"><%= shop.getJoinDuration() %></span>
        </div>
    </div>
</div>

<!-- ===== TOP SELLERS ===== -->
<% if (topSellers != null && !topSellers.isEmpty()) { %>
<div class="top-sellers">
    <div class="section-title"><i class="fas fa-fire" style="color:#ee4d2d;"></i> &nbsp;Sản Phẩm Bán Chạy</div>
    <div class="product-grid">
        <% for (ProductDTO item : topSellers) { %>
        <a href="product_detail?id=<%= item.getId() %>" class="product-card">
            <span class="badge-label">TOP</span>
            <img src="<%= item.getImageUrl() %>" alt="<%= item.getName() %>"
                 onerror="this.src='https://placehold.co/400x400/f5f5f5/999?text=No+Image'">
            <div class="card-body">
                <div class="product-name"><%= item.getName() %></div>
                <div class="product-price">
                    <fmt:formatNumber value="<%= item.getPrice() %>" type="number" groupingUsed="true" />đ
                </div>
                <div class="product-sold">
                    <i class="fas fa-fire-alt" style="color:#ee4d2d;"></i>
                    Đã bán <%= item.getSoldCount() %>
                </div>
            </div>
        </a>
        <% } %>
    </div>
</div>
<% } %>

<!-- ===== SORT BAR ===== -->
<div class="sort-bar">
    <span class="label">Sắp xếp theo</span>
    <a href="shop?id=<%= shop.getId() %>&sort=popular" class="sort-btn <%= "popular".equals(currentSort) ? "active" : "" %>">Phổ Biến</a>
    <a href="shop?id=<%= shop.getId() %>&sort=newest" class="sort-btn <%= "newest".equals(currentSort) ? "active" : "" %>">Mới Nhất</a>
    <a href="shop?id=<%= shop.getId() %>&sort=bestselling" class="sort-btn <%= "bestselling".equals(currentSort) ? "active" : "" %>">Bán Chạy</a>
    <a href="shop?id=<%= shop.getId() %>&sort=price_asc" class="sort-btn <%= "price_asc".equals(currentSort) ? "active" : "" %>">
        Giá <i class="fas fa-arrow-up" style="font-size:10px;"></i>
    </a>
    <a href="shop?id=<%= shop.getId() %>&sort=price_desc" class="sort-btn <%= "price_desc".equals(currentSort) ? "active" : "" %>">
        Giá <i class="fas fa-arrow-down" style="font-size:10px;"></i>
    </a>
</div>

<!-- ===== PRODUCT GRID ===== -->
<div class="products-container">
    <% if (products != null && !products.isEmpty()) { %>
    <div class="product-grid">
        <% for (ProductDTO item : products) { %>
        <a href="product_detail?id=<%= item.getId() %>" class="product-card">
            <img src="<%= item.getImageUrl() %>" alt="<%= item.getName() %>"
                 onerror="this.src='https://placehold.co/400x400/f5f5f5/999?text=No+Image'">
            <div class="card-body">
                <div class="product-name"><%= item.getName() %></div>
                <div class="product-price">
                    <fmt:formatNumber value="<%= item.getPrice() %>" type="number" groupingUsed="true" />đ
                </div>
                <div class="product-sold">Đã bán <%= item.getSoldCount() %></div>
            </div>
        </a>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <i class="fas fa-store"></i>
        <p>Shop chưa có sản phẩm nào</p>
    </div>
    <% } %>
</div>

<!-- ===== PAGINATION ===== -->
<% if (totalPages > 1) { %>
<div class="pagination-bar">
    <a href="shop?id=<%= shop.getId() %>&sort=<%= currentSort %>&page=<%= Math.max(1, currentPage - 1) %>"
       class="page-btn <%= currentPage <= 1 ? "disabled" : "" %>">
        <i class="fas fa-chevron-left"></i>
    </a>
    <% for (int i = 1; i <= totalPages && i <= 7; i++) { %>
    <a href="shop?id=<%= shop.getId() %>&sort=<%= currentSort %>&page=<%= i %>"
       class="page-btn <%= i == currentPage ? "active" : "" %>"><%= i %></a>
    <% } %>
    <% if (totalPages > 7) { %>
    <span class="page-btn disabled">...</span>
    <a href="shop?id=<%= shop.getId() %>&sort=<%= currentSort %>&page=<%= totalPages %>"
       class="page-btn"><%= totalPages %></a>
    <% } %>
    <a href="shop?id=<%= shop.getId() %>&sort=<%= currentSort %>&page=<%= Math.min(totalPages, currentPage + 1) %>"
       class="page-btn <%= currentPage >= totalPages ? "disabled" : "" %>">
        <i class="fas fa-chevron-right"></i>
    </a>
</div>
<% } %>

<!-- ===== FOOTER ===== -->
<div style="text-align:center; padding:40px 0 20px; color:rgba(0,0,0,0.4); font-size:13px;">
    &copy; 2024 Shopee. Tất cả các quyền được bảo lưu.
</div>

<script>
    var shopId = <%= shop.getId() %>;
    var isFollowing = <%= isFollowing %>;

    function toggleFollow() {
        fetch('shop/follow?shopId=' + shopId, { method: 'POST' })
            .then(res => {
                if (res.status === 401) {
                    alert('Vui lòng đăng nhập để theo dõi shop!');
                    window.location.href = 'login';
                    return null;
                }
                return res.json();
            })
            .then(data => {
                if (!data) return;
                isFollowing = data.following;

                var btn = document.getElementById('followBtn');
                var text = document.getElementById('followText');
                var count = document.getElementById('followerCount');

                if (isFollowing) {
                    btn.classList.add('following');
                    btn.innerHTML = '<i class="fas fa-check"></i> <span id="followText">Đang Theo Dõi</span>';
                } else {
                    btn.classList.remove('following');
                    btn.innerHTML = '<i class="fas fa-plus"></i> <span id="followText">Theo Dõi</span>';
                }

                count.textContent = data.followerCount;
            })
            .catch(err => console.error('Follow error:', err));
    }
</script>
</body>
</html>
