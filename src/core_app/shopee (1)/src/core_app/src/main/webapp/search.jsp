<%@page import="model.ProductDTO" %>
    <%@page import="model.Admin" %>
        <%@page import="model.User" %>
            <%@page import="java.util.List" %>
                <%@page contentType="text/html" pageEncoding="UTF-8" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                                <!DOCTYPE html>
                                <html lang="vi">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Kết quả tìm kiếm | Shopee Việt Nam</title>
                                    <link rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
                                    <link rel="stylesheet" href="css/style.css">
                                    <link rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                                    <style>
                                        /* Tinh chỉnh Fix lỗi Banner đè Menu do Header Fixed của Shopee */
                                        .app__container {
                                            padding-top: 20px;
                                            background-color: #f5f5f5;
                                            /* Nền xám tiêu chuẩn của Shopee layout */
                                            padding-bottom: 50px;
                                        }

                                        .grid {
                                            width: 1200px;
                                            max-width: 100%;
                                            margin: 0 auto;
                                        }

                                        .header__navbar-item-link {
                                            text-decoration: none;
                                            color: white;
                                        }

                                        /* Dành riêng cho trang Tìm kiếm */
                                        .search-container {
                                            display: flex;
                                            width: 1200px;
                                            margin: 30px auto 0;
                                            gap: 20px;
                                            align-items: flex-start;
                                        }

                                        /* --- LEFT SIDEBAR (Bộ lọc) --- */
                                        .search-sidebar {
                                            width: 190px;
                                            flex-shrink: 0;
                                        }

                                        .filter-group {
                                            margin-bottom: 25px;
                                            border-bottom: 1px solid rgba(0, 0, 0, .05);
                                            padding-bottom: 20px;
                                        }

                                        .filter-group-header {
                                            font-size: 14px;
                                            font-weight: 500;
                                            color: rgba(0, 0, 0, .8);
                                            margin-bottom: 15px;
                                            text-transform: capitalize;
                                        }

                                        .filter-item {
                                            display: flex;
                                            align-items: center;
                                            margin-bottom: 12px;
                                            font-size: 14px;
                                            color: rgba(0, 0, 0, .8);
                                            cursor: pointer;
                                        }

                                        .filter-checkbox {
                                            margin-right: 10px;
                                            width: 13px;
                                            height: 13px;
                                        }

                                        .filter-title {
                                            font-size: 16px;
                                            font-weight: 700;
                                            margin-bottom: 20px;
                                            display: flex;
                                            align-items: center;
                                            color: rgba(0, 0, 0, .8);
                                        }

                                        /* --- RIGHT MAIN SECTION --- */
                                        .search-main {
                                            flex: 1;
                                            min-width: 0;
                                            /* để fix bug flexbox tràn */
                                        }

                                        .search-result-hint {
                                            font-size: 16px;
                                            color: #555;
                                            margin-bottom: 20px;
                                            display: flex;
                                            align-items: center;
                                        }

                                        .search-result-keyword {
                                            color: #ee4d2d;
                                            font-weight: 500;
                                            margin-left: 5px;
                                        }

                                        /* Thanh Sắp Xếp */
                                        .sort-bar {
                                            background: rgba(0, 0, 0, .03);
                                            padding: 13px 20px;
                                            border-radius: 2px;
                                            display: flex;
                                            align-items: center;
                                            justify-content: space-between;
                                            margin-bottom: 10px;
                                        }

                                        .sort-options {
                                            display: flex;
                                            align-items: center;
                                            gap: 10px;
                                        }

                                        .sort-label {
                                            color: #555;
                                            font-size: 14px;
                                            margin-right: 5px;
                                        }

                                        .sort-btn {
                                            background: #fff;
                                            border: 0;
                                            padding: 9px 15px;
                                            border-radius: 2px;
                                            font-size: 14px;
                                            color: rgba(0, 0, 0, .8);
                                            cursor: pointer;
                                            box-shadow: 0 1px 1px 0 rgba(0, 0, 0, .02);
                                        }

                                        .sort-btn.active {
                                            background: #ee4d2d;
                                            color: #fff;
                                        }

                                        .sort-btn a {
                                            text-decoration: none;
                                            color: inherit;
                                            display: block;
                                        }

                                        .sort-select {
                                            background: #fff;
                                            border: 0;
                                            padding: 0;
                                            border-radius: 2px;
                                            font-size: 14px;
                                            color: rgba(0, 0, 0, .8);
                                            width: 200px;
                                            display: flex;
                                            justify-content: space-between;
                                            align-items: center;
                                            cursor: pointer;
                                            box-shadow: 0 1px 1px 0 rgba(0, 0, 0, .02);
                                            position: relative;
                                        }

                                        .sort-select select {
                                            appearance: none;
                                            -webkit-appearance: none;
                                            border: 0;
                                            outline: none;
                                            background: #fff;
                                            padding: 9px 35px 9px 15px;
                                            font-size: 14px;
                                            color: rgba(0, 0, 0, .8);
                                            width: 100%;
                                            cursor: pointer;
                                        }

                                        .sort-select .sort-select-arrow {
                                            position: absolute;
                                            right: 12px;
                                            top: 50%;
                                            transform: translateY(-50%);
                                            pointer-events: none;
                                            font-size: 12px;
                                            color: rgba(0, 0, 0, .5);
                                        }

                                        .sort-select.active select {
                                            background: #ee4d2d;
                                            color: #fff;
                                        }

                                        .sort-select.active .sort-select-arrow {
                                            color: #fff;
                                        }

                                        .pagination-link {
                                            display: inline-flex;
                                            align-items: center;
                                            justify-content: center;
                                            text-decoration: none;
                                            border: 0;
                                            padding: 5px 15px;
                                            font-size: 16px;
                                            margin: 0 5px;
                                            min-width: 40px;
                                            cursor: pointer;
                                            border-radius: 2px;
                                            color: rgba(0, 0, 0, .4);
                                            background: transparent;
                                        }

                                        .pagination-link.active {
                                            background: #ee4d2d;
                                            color: #fff;
                                        }

                                        .pagination-link.disabled {
                                            cursor: not-allowed;
                                            color: #ccc;
                                            pointer-events: none;
                                        }

                                        /* Grid Kết quả (5 cột / hàng) */
                                        .search-grid {
                                            display: flex;
                                            flex-wrap: wrap;
                                            margin-left: -5px;
                                            margin-right: -5px;
                                        }

                                        .search-col {
                                            padding-left: 5px;
                                            padding-right: 5px;
                                            margin-bottom: 10px;
                                            width: 20%;
                                            /* 5 items per row */
                                            box-sizing: border-box;
                                        }

                                        /* Ghi đè CSS cho home-product-item từ style.css để fit với cột 20% */
                                        .home-product-item {
                                            display: block;
                                            text-decoration: none;
                                            background-color: #fff;
                                            border-radius: 2px;
                                            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .1);
                                            transition: transform ease-in .1s, box-shadow ease-in .1s;
                                            position: relative;
                                        }

                                        .home-product-item:hover {
                                            transform: translateY(-1px);
                                            box-shadow: 0 1px 20px 0 rgba(0, 0, 0, .05);
                                            border: 1px solid #ee4d2d;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="app">
                                        <!-- HEADER -->
                                        <header class="header">
                                            <!-- Navbar -->
                                            <nav class="header__navbar">
                                                <ul class="header__navbar-list">
                                                    <li class="header__navbar-item header__navbar-item--separate"><a
                                                            href="#" class="header__navbar-item-link">Kênh Người Bán</a>
                                                    </li>
                                                    <li class="header__navbar-item header__navbar-item--separate"><a
                                                            href="#" class="header__navbar-item-link">Trở thành Người
                                                            bán
                                                            Shopee</a>
                                                    </li>
                                                    <li class="header__navbar-item header__navbar-item--separate"><a
                                                            href="#" class="header__navbar-item-link">Tải ứng dụng</a>
                                                    </li>
                                                    <li class="header__navbar-item">
                                                        Kết nối
                                                        <a href="#" class="header__navbar-item-link"><i
                                                                class="fab fa-facebook"></i></a>
                                                        <a href="#" class="header__navbar-item-link"><i
                                                                class="fab fa-instagram"></i></a>
                                                    </li>
                                                </ul>

                                                <ul class="header__navbar-list">
                                                    <li class="header__navbar-item"><a href="#"
                                                            class="header__navbar-item-link"><i class="far fa-bell"></i>
                                                            Thông
                                                            báo</a></li>
                                                    <li class="header__navbar-item"><a href="#"
                                                            class="header__navbar-item-link"><i
                                                                class="far fa-question-circle"></i> Hỗ trợ</a></li>
                                                    <% User acc=(User) session.getAttribute("account"); if (acc !=null)
                                                        { %>
                                                        <li class="header__navbar-item header__navbar-item--separate"
                                                            style="font-weight: 500;">
                                                            <i class="fas fa-user-circle"></i>
                                                            <%= acc.getFullName() %>
                                                                <% if ("admin".equalsIgnoreCase(acc.getRole())) { %>
                                                                    <a href="admin"
                                                                        style="color: #ffce3d; margin-left:5px; font-weight: bold; text-decoration:none;">[ADMIN]</a>
                                                                    <% } %>
                                                        </li>
                                                        <li class="header__navbar-item"><a href="logout"
                                                                class="header__navbar-item-link"
                                                                style="font-weight: 500;">Đăng
                                                                xuất</a></li>
                                                        <% } else { %>
                                                            <li
                                                                class="header__navbar-item header__navbar-item--separate">
                                                                <a href="register" class="header__navbar-item-link"
                                                                    style="font-weight: 500;">Đăng ký</a>
                                                            </li>
                                                            <li class="header__navbar-item"><a href="login"
                                                                    class="header__navbar-item-link"
                                                                    style="font-weight: 500;">Đăng nhập</a></li>
                                                            <% } %>
                                                </ul>
                                            </nav>

                                            <!-- Header with Search -->
                                            <div class="header-with-search">
                                                <div class="header__logo">
                                                    <a href="home" class="header__logo-img-wrapper">
                                                        <i class="fa-solid fa-bag-shopping"></i> Shopee
                                                    </a>
                                                </div>

                                                <div style="flex: 1;">
                                                    <div class="header__search">
                                                        <form action="search" method="get"
                                                            class="header__search-input-wrap d-flex"
                                                            style="width:100%; display:flex;">
                                                            <input type="text" name="txt" class="header__search-input"
                                                                placeholder="Dùng thẻ S REWARDS hoàn xu 12%"
                                                                value="<%= request.getAttribute(" txtS")==null ? "" :
                                                                request.getAttribute("txtS") %>"
                                                            style="flex:1;">
                                                            <button type="submit" class="header__search-btn">
                                                                <i class="fas fa-search header__search-btn-icon"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                    <div class="header__search-suggest"
                                                        style="margin-top: 5px; font-size: 12px;">
                                                        <a href="search?txt=iPhone+16"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Săn
                                                            iPhone 0 Đồng</a>
                                                        <a href="search?txt=Đồ+Ren+Nữ"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Đồ
                                                            Ren Nữ</a>
                                                        <a href="search?txt=Ốp+iPhone"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Ốp
                                                            Lưng iPhone</a>
                                                        <a href="search?txt=Áo+Khoác+Nam"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Áo
                                                            Khoác Nam Đẹp</a>
                                                        <a href="search?txt=Mũ+Bảo+Hiểm"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Mũ
                                                            Bảo Hiểm</a>
                                                        <a href="search?txt=Dép+Crocs"
                                                            style="color: white; margin-right: 13px; text-decoration: none;">Dép
                                                            Crocs Chính Hãng</a>
                                                    </div>
                                                </div>

                                                <!-- Cart -->
                                                <div class="header__cart">
                                                    <div class="header__cart-wrap">
                                                        <a href="cart" style="text-decoration:none; color:#fff;">
                                                            <i class="fas fa-shopping-cart header__cart-icon"></i>
                                                            <span class="header__cart-notice">${sessionScope.cart !=
                                                                null ?
                                                                sessionScope.cart.totalQuantity : 0}</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </header>

                                        <!-- CONTAINER -->
                                        <div class="app__container">
                                            <div class="grid search-container">

                                                <!-- SIDEBAR BỘ LỌC TÌM KIẾM -->
                                                <div class="search-sidebar">
                                                    <div class="filter-title">
                                                        <i class="fas fa-filter"
                                                            style="margin-right: 10px; font-size: 14px;"></i> BỘ LỌC TÌM
                                                        KIẾM
                                                    </div>

                                                    <form action="search" method="get" id="filterForm">
                                                        <!-- Giữ lại keyword tìm kiếm -->
                                                        <% String searchTxt=(String) request.getAttribute("txtS"); if
                                                            (searchTxt==null) searchTxt="" ; %>
                                                            <input type="hidden" name="txt" value="<%= searchTxt %>">

                                                            <div class="filter-group">
                                                                <div class="filter-group-header">Theo Danh Mục</div>
                                                                <!-- List categories (nếu có map được) hoặc mock -->
                                                                <c:choose>
                                                                    <c:when test="${not empty categories}">
                                                                        <c:forEach var="c" items="${categories}"
                                                                            begin="0" end="4">
                                                                            <label class="filter-item">
                                                                                <input type="checkbox" name="cateId"
                                                                                    value="${c.id}"
                                                                                    class="filter-checkbox"
                                                                                    ${paramValues.cateId !=null &&
                                                                                    fn:contains(fn:join(paramValues.cateId, ','
                                                                                    ), c.id) ? 'checked' : '' }>
                                                                                ${c.name}
                                                                            </label>
                                                                        </c:forEach>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <label class="filter-item"><input
                                                                                type="checkbox" name="cateId" value="1"
                                                                                class="filter-checkbox">
                                                                            Thời Trang Nam</label>
                                                                        <label class="filter-item"><input
                                                                                type="checkbox" name="cateId" value="2"
                                                                                class="filter-checkbox">
                                                                            Điện Thoại & Phụ Kiện</label>
                                                                        <label class="filter-item"><input
                                                                                type="checkbox" name="cateId" value="3"
                                                                                class="filter-checkbox">
                                                                            Thiết Bị Điện Tử</label>
                                                                        <label class="filter-item"><input
                                                                                type="checkbox" name="cateId" value="4"
                                                                                class="filter-checkbox">
                                                                            Máy Tính & Laptop</label>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <div
                                                                    style="color: #ee4d2d; font-size: 14px; cursor: pointer; margin-top: 5px;">
                                                                    Thêm <i class="fas fa-chevron-down"
                                                                        style="font-size: 10px;"></i>
                                                                </div>
                                                            </div>

                                                            <div class="filter-group">
                                                                <div class="filter-group-header">Nơi Bán</div>
                                                                <label class="filter-item"><input type="checkbox"
                                                                        name="location" value="hcm"
                                                                        class="filter-checkbox" ${paramValues.location
                                                                        !=null &&
                                                                        fn:contains(fn:join(paramValues.location, ','
                                                                        ), 'hcm' ) ? 'checked' : '' }>
                                                                    TP. Hồ Chí Minh</label>
                                                                <label class="filter-item"><input type="checkbox"
                                                                        name="location" value="hn"
                                                                        class="filter-checkbox" ${paramValues.location
                                                                        !=null &&
                                                                        fn:contains(fn:join(paramValues.location, ','
                                                                        ), 'hn' ) ? 'checked' : '' }>
                                                                    Hà Nội</label>
                                                                <label class="filter-item"><input type="checkbox"
                                                                        name="location" value="dn"
                                                                        class="filter-checkbox" ${paramValues.location
                                                                        !=null &&
                                                                        fn:contains(fn:join(paramValues.location, ','
                                                                        ), 'dn' ) ? 'checked' : '' }>
                                                                    Đà Nẵng</label>
                                                                <div
                                                                    style="color: #ee4d2d; font-size: 14px; cursor: pointer; margin-top: 5px;">
                                                                    Thêm <i class="fas fa-chevron-down"
                                                                        style="font-size: 10px;"></i>
                                                                </div>
                                                            </div>

                                                            <div class="filter-group">
                                                                <div class="filter-group-header">Khoảng Giá</div>
                                                                <div
                                                                    style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                                                                    <input type="number" name="minPrice"
                                                                        placeholder="₫ TỪ" value="${param.minPrice}"
                                                                        style="width: 45%; padding: 5px; font-size: 12px; border: 1px solid rgba(0,0,0,.26); outline: none;">
                                                                    <span style="color: #ccc;">-</span>
                                                                    <input type="number" name="maxPrice"
                                                                        placeholder="₫ ĐẾN" value="${param.maxPrice}"
                                                                        style="width: 45%; padding: 5px; font-size: 12px; border: 1px solid rgba(0,0,0,.26); outline: none;">
                                                                </div>
                                                                <button type="submit"
                                                                    style="width: 100%; background: #ee4d2d; color: #fff; border: 0; padding: 8px 0; border-radius: 2px; cursor: pointer; text-transform: uppercase;">Áp
                                                                    dụng</button>
                                                            </div>

                                                            <div class="filter-group">
                                                                <div class="filter-group-header">Đánh Giá</div>
                                                                <input type="hidden" name="rating" id="ratingInput"
                                                                    value="${param.rating}">

                                                                <div class="filter-item cursor-pointer"
                                                                    style="display: flex; align-items: center; gap: 5px; cursor: pointer; ${param.rating == '5' ? 'background: #fdf3f0; border-radius: 100px; padding: 5px 10px;' : 'padding: 5px 10px;'}"
                                                                    onclick="document.getElementById('ratingInput').value='5';">
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                </div>

                                                                <div class="filter-item cursor-pointer"
                                                                    style="display: flex; align-items: center; gap: 5px; cursor: pointer; ${param.rating == '4' ? 'background: #fdf3f0; border-radius: 100px; padding: 5px 10px;' : 'padding: 5px 10px;'}"
                                                                    onclick="document.getElementById('ratingInput').value='4';">
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="far fa-star" style="color:#ccc;"></i>
                                                                    <span>trở lên</span>
                                                                </div>

                                                                <div class="filter-item cursor-pointer"
                                                                    style="display: flex; align-items: center; gap: 5px; cursor: pointer; ${param.rating == '3' ? 'background: #fdf3f0; border-radius: 100px; padding: 5px 10px;' : 'padding: 5px 10px;'}"
                                                                    onclick="document.getElementById('ratingInput').value='3';">
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="fas fa-star" style="color:#ffce3d;"></i>
                                                                    <i class="far fa-star" style="color:#ccc;"></i>
                                                                    <i class="far fa-star" style="color:#ccc;"></i>
                                                                    <span>trở lên</span>
                                                                </div>
                                                            </div>

                                                            <% String clearTxt=(String) request.getAttribute("txtS"); if
                                                                (clearTxt==null) clearTxt="" ; %>
                                                                <!-- Clear All Filters Button -->
                                                                <a href="search?txt=<%= clearTxt %>"
                                                                    style="display: block; text-align: center; width: 100%; background:
                                                    #fff; color: rgba(0,0,0,.8); border: 1px solid rgba(0,0,0,.2);
                                                    padding: 8px 0; border-radius: 2px; cursor: pointer; text-transform:
                                                    uppercase; margin-top: 15px; margin-bottom: 20px; text-decoration: none;">XÓA
                                                                    TẤT CẢ</a>
                                                    </form>
                                                </div>

                                                <!-- MAIN AREA (Kết quả hiển thị) -->
                                                <div class="search-main">

                                                    <div class="search-result-hint">
                                                        <i class="far fa-lightbulb"
                                                            style="color: #ee4d2d; margin-right: 10px; font-size: 20px;"></i>
                                                        Kết quả tìm kiếm cho từ khoá
                                                        <span class="search-result-keyword">'<%=
                                                                request.getAttribute("txtS") !=null ?
                                                                request.getAttribute("txtS") : "" %>'</span>
                                                    </div>

                                                    <!-- Thanh Sap xep -->
<%-- @formatter:off --%>
<%
String st = (String)request.getAttribute("txtS");
if(st==null) st="";
String enc = java.net.URLEncoder.encode(st,"UTF-8");
StringBuilder bu = new StringBuilder("search?txt="+enc);
String[] ci = request.getParameterValues("cateId");
if(ci!=null) for(String x:ci) bu.append("&cateId=").append(x);
String[] lo = request.getParameterValues("location");
if(lo!=null) for(String x:lo) bu.append("&location=").append(x);
String mp = request.getParameter("minPrice");
String xp = request.getParameter("maxPrice");
if(mp!=null&&!mp.isEmpty()) bu.append("&minPrice=").append(mp);
if(xp!=null&&!xp.isEmpty()) bu.append("&maxPrice=").append(xp);
String sr = request.getParameter("rating");
if(sr!=null&&!sr.isEmpty()) bu.append("&rating=").append(sr);
String baseUrlStr = bu.toString();
String currentSort = (String)request.getAttribute("sortBy");
if(currentSort==null) currentSort="popular";
int curPage = (Integer)request.getAttribute("currentPage");
int totPages = (Integer)request.getAttribute("totalPages");
String pcls = "popular".equals(currentSort)?"sort-btn active":"sort-btn";
String ncls = "newest".equals(currentSort)?"sort-btn active":"sort-btn";
String bcls = "bestselling".equals(currentSort)?"sort-btn active":"sort-btn";
boolean isP = "price_asc".equals(currentSort)||"price_desc".equals(currentSort);
String scls = isP?"sort-select active":"sort-select";
String pas = "price_asc".equals(currentSort)?"selected":"";
String pds = "price_desc".equals(currentSort)?"selected":"";
String dps = !isP?"selected":"";
%>
<%-- @formatter:on --%>
                                                        <div class="sort-bar">
                                                            <div class="sort-options">
                                                                <span class="sort-label">S&#7855;p x&#7871;p theo</span>
                                                                <a href="<%= baseUrlStr %>&sortBy=popular&page=1" class="<%= pcls %>">Li&#234;n quan</a>
                                                                <a href="<%= baseUrlStr %>&sortBy=newest&page=1" class="<%= ncls %>">M&#7899;i nh&#7845;t</a>
                                                                <a href="<%= baseUrlStr %>&sortBy=bestselling&page=1" class="<%= bcls %>">B&#225;n ch&#7841;y</a>
                                                                <div class="<%= scls %>">
                                                                    <select onchange="if(this.value) window.location.href=this.value;">
                                                                        <option value="" <%= dps %>>Gi&#225;</option>
                                                                        <option value="<%= baseUrlStr %>&sortBy=price_asc&page=1" <%= pas %>>Gi&#225;: Th&#7845;p &#273;&#7871;n Cao</option>
                                                                        <option value="<%= baseUrlStr %>&sortBy=price_desc&page=1" <%= pds %>>Gi&#225;: Cao &#273;&#7871;n Th&#7845;p</option>
                                                                    </select>
                                                                    <i class="fas fa-chevron-down sort-select-arrow"></i>
                                                                </div>
                                                            </div>
                                                            <div style="display: flex; align-items: center;">
                                                                <div style="margin-right: 15px; font-size: 14px;">
                                                                    <span style="color: #ee4d2d;">
                                                                        <%= curPage %>
                                                                    </span>/<%= totPages %>
                                                                </div>
                                                                <div
                                                                    style="display: flex; overflow: hidden; border-radius: 2px; box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);">
                                                                    <% if (curPage <=1) { %>
                                                                        <button
                                                                            style="padding: 10px 15px; border: 1px solid rgba(0,0,0,.09); background: #f9f9f9; cursor: not-allowed; color: #ccc;"><i
                                                                                class="fas fa-chevron-left"></i></button>
                                                                        <% } else { %>
                                                                            <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= curPage - 1 %>"
                                                                                style="padding: 10px 15px; border: 1px solid rgba(0,0,0,.09); background: #fff; cursor: pointer; color: rgba(0,0,0,.8); text-decoration: none;"><i
                                                                                    class="fas fa-chevron-left"></i></a>
                                                                            <% } %>
                                                                                <% if (curPage>= totPages) { %>
                                                                                    <button
                                                                                        style="padding: 10px 15px; border: 1px solid rgba(0,0,0,.09); background: #f9f9f9; cursor: not-allowed; color: #ccc; border-left: 0;"><i
                                                                                            class="fas fa-chevron-right"></i></button>
                                                                                    <% } else { %>
                                                                                        <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= curPage + 1 %>"
                                                                                            style="padding: 10px 15px; border: 1px solid rgba(0,0,0,.09); background: #fff; cursor: pointer; border-left: 0; color: rgba(0,0,0,.8); text-decoration: none;"><i
                                                                                                class="fas fa-chevron-right"></i></a>
                                                                                        <% } %>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Grid Result 5 Cột -->
                                                        <div class="search-grid">
                                                            <% List<ProductDTO> list = (List<ProductDTO>)
                                                                    request.getAttribute("products");
                                                                    if (list != null && !list.isEmpty()) {
                                                                    for (ProductDTO p : list) {
                                                                    String slug = "san-pham";
                                                                    if (p.getName() != null) {
                                                                    slug = p.getName().trim().replaceAll("[\\s/]+", "-")
                                                                    .replaceAll("[^\\p{L}\\p{N}\\-]", "")
                                                                    .replaceAll("-{2,}", "-").replaceAll("^-|-$", "");
                                                                    }
                                                                    %>
                                                                    <div class="search-col">
                                                                        <a class="home-product-item"
                                                                            href="<%= slug %>-i.686868.<%= p.getId() %>">
                                                                            <div class="home-product-item__img"
                                                                                style="background-image: url('<%= p.getImageUrl() %>'); padding-top: 100%;">
                                                                            </div>
                                                                            <h4 class="home-product-item__name">
                                                                                <%= p.getName() %>
                                                                            </h4>

                                                                            <div class="home-product-item__price">
                                                                                <span
                                                                                    class="home-product-item__price-current"
                                                                                    style="font-size: 1.6rem;">₫<%=
                                                                                        String.format("%,.0f",
                                                                                        p.getMinPrice()) %>
                                                                                </span>
                                                                            </div>

                                                                            <div class="home-product-item__action">
                                                                                <span class="home-product-item__rating">
                                                                                    <i
                                                                                        class="home-product-item__star--gold fas fa-star"></i>
                                                                                    <i
                                                                                        class="home-product-item__star--gold fas fa-star"></i>
                                                                                    <i
                                                                                        class="home-product-item__star--gold fas fa-star"></i>
                                                                                    <i
                                                                                        class="home-product-item__star--gold fas fa-star"></i>
                                                                                    <i
                                                                                        class="home-product-item__star--gold fas fa-star"></i>
                                                                                </span>
                                                                                <span class="home-product-item__sold">Đã
                                                                                    bán
                                                                                    ${(p.id
                                                                                    * 10) + 5}</span>
                                                                            </div>

                                                                            <div class="home-product-item__origin">
                                                                                <span>
                                                                                    <c:choose>
                                                                                        <c:when test="${p.id % 3 == 0}">
                                                                                            Đà Nẵng
                                                                                        </c:when>
                                                                                        <c:when test="${p.id % 2 == 0}">
                                                                                            Hà Nội
                                                                                        </c:when>
                                                                                        <c:otherwise>TP. Hồ Chí Minh
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                            </div>

                                                                            <%-- Gắn nhãn Yêu Thích <div
                                                                                class="home-product-item__favourite">
                                                                                <i class="fas fa-check"></i>
                                                                                <span>Yêu thích</span>
                                                                    </div> --%>
                                                                    <img src="https://down-vn.img.susercontent.com/file/vn-50009109-f0bdca4f25baf1fb1e95cfc14b2d10f8"
                                                                        style="position: absolute; top: 0; left: -4px; height: 16px;">

                                                                    <%-- Optional: Admin action --%>
                                                                        <% if (acc !=null && "admin"
                                                                            .equalsIgnoreCase(acc.getRole())) { %>
                                                                            <div
                                                                                style="text-align:center; padding: 5px; border-top: 1px dashed #ddd; background:#fff;">
                                                                                <object><a
                                                                                        href="product-manage?action=delete&id=<%= p.getId() %>"
                                                                                        style="color:#d0011b; font-size:12px; font-weight:bold; text-decoration:none;"
                                                                                        onclick="return confirm('Xóa thật hả?')">Xóa
                                                                                        SP</a></object>
                                                                            </div>
                                                                            <% } %>
                                                                                </a>
                                                        </div>
                                                        <% } } else { %>
                                                            <div
                                                                style="width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; background: #fff; padding: 100px 0; min-height: 400px; box-shadow: 0 1px 1px 0 rgba(0,0,0,.05); border-radius: 2px;">
                                                                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/search/a60759ad1dabe909c46a.png"
                                                                    style="width: 134px; margin-bottom: 20px;" alt="">
                                                                <div style="font-size: 16px; color: rgba(0,0,0,.8);">
                                                                    Không tìm
                                                                    thấy
                                                                    kết quả nào</div>
                                                                <div
                                                                    style="font-size: 14px; color: rgba(0,0,0,.54); margin-top: 10px;">
                                                                    Hãy thử sử dụng các từ khóa chung chung hơn</div>
                                                            </div>
                                                            <% } %>
                                                </div>

                                                <!-- Phan trang Bottom -->
                                                <% if (list !=null && !list.isEmpty() && totPages> 1) { %>
                                                    <div
                                                        style="display: flex; justify-content: center; align-items: center; margin-top: 40px;">
                                                        <% if (curPage> 1) { %>
                                                            <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= curPage - 1 %>"
                                                                style="border: 0; background: transparent; font-size: 20px; color: rgba(0,0,0,.4); cursor: pointer; margin: 0 15px; text-decoration: none;"><i
                                                                    class="fas fa-chevron-left"></i></a>
                                                            <% } else { %>
                                                                <span
                                                                    style="border: 0; background: transparent; font-size: 20px; color: #ccc; cursor: not-allowed; margin: 0 15px;"><i
                                                                        class="fas fa-chevron-left"></i></span>
                                                                <% } %>
                                                                    <% int startPage=Math.max(1, curPage - 2); int
                                                                        endPage=Math.min(totPages, curPage + 2); if
                                                                        (endPage - startPage < 4 && totPages>= 5) {
                                                                        if (startPage == 1) endPage = Math.min(totPages,
                                                                        5);
                                                                        else startPage = Math.max(1, endPage - 4);
                                                                        }
                                                                        %>
                                                                        <% if (startPage> 1) { %>
                                                                            <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=1"
                                                                                class="pagination-link">1</a>
                                                                            <% if (startPage> 2) { %>
                                                                                <span
                                                                                    style="margin: 0 5px; color: rgba(0,0,0,.4);">...</span>
                                                                                <% } %>
                                                                                    <% } %>
                                                                                        <% for (int pg=startPage; pg
                                                                                            <=endPage; pg++) { %>
                                                                                            <% if (pg==curPage) { %>
                                                                                                <span
                                                                                                    class="pagination-link active">
                                                                                                    <%= pg %>
                                                                                                </span>
                                                                                                <% } else { %>
                                                                                                    <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= pg %>"
                                                                                                        class="pagination-link">
                                                                                                        <%= pg %>
                                                                                                    </a>
                                                                                                    <% } %>
                                                                                                        <% } %>
                                                                                                            <% if
                                                                                                                (endPage
                                                                                                                <
                                                                                                                totPages)
                                                                                                                { %>
                                                                                                                <% if
                                                                                                                    (endPage
                                                                                                                    <
                                                                                                                    totPages
                                                                                                                    - 1)
                                                                                                                    { %>
                                                                                                                    <span
                                                                                                                        style="margin: 0 5px; color: rgba(0,0,0,.4);">...</span>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                                        <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= totPages %>"
                                                                                                                            class="pagination-link">
                                                                                                                            <%= totPages
                                                                                                                                %>
                                                                                                                        </a>
                                                                                                                        <% }
                                                                                                                            %>
                                                                                                                            <% if
                                                                                                                                (curPage
                                                                                                                                <
                                                                                                                                totPages)
                                                                                                                                {
                                                                                                                                %>
                                                                                                                                <a href="<%= baseUrlStr %>&sortBy=<%= currentSort %>&page=<%= curPage + 1 %>"
                                                                                                                                    style="border: 0; background: transparent; font-size: 20px; color: rgba(0,0,0,.4); cursor: pointer; margin: 0 15px; text-decoration: none;"><i
                                                                                                                                        class="fas fa-chevron-right"></i></a>
                                                                                                                                <% } else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span
                                                                                                                                        style="border: 0; background: transparent; font-size: 20px; color: #ccc; cursor: not-allowed; margin: 0 15px;"><i
                                                                                                                                            class="fas fa-chevron-right"></i></span>
                                                                                                                                    <% }
                                                                                                                                        %>
                                                    </div>
                                                    <% } %>

                                            </div>
                                        </div>
                                    </div>

                                    <!-- FOOTER -->
                                    <footer class="footer">
                                        <div class="grid">
                                            <div class="row" style="padding:0 20px;">
                                                <div class="col" style="width: 25%">
                                                    <h3 class="footer__heading">Chăm sóc khách hàng</h3>
                                                    <ul class="footer-list">
                                                        <li><a href="#" class="footer-item__link">Trung tâm trợ giúp</a>
                                                        </li>
                                                        <li><a href="#" class="footer-item__link">Shopee Blog</a></li>
                                                        <li><a href="#" class="footer-item__link">Shopee Mall</a></li>
                                                        <li><a href="#" class="footer-item__link">Hướng dẫn mua hàng</a>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div class="col" style="width: 25%">
                                                    <h3 class="footer__heading">Về Shopee</h3>
                                                    <ul class="footer-list">
                                                        <li><a href="#" class="footer-item__link">Giới thiệu</a></li>
                                                        <li><a href="#" class="footer-item__link">Tuyển dụng</a></li>
                                                        <li><a href="#" class="footer-item__link">Điều khoản</a></li>
                                                    </ul>
                                                </div>
                                                <div class="col" style="width: 25%">
                                                    <h3 class="footer__heading">Theo dõi</h3>
                                                    <ul class="footer-list">
                                                        <li><a href="#" class="footer-item__link"><i
                                                                    class="fab fa-facebook"
                                                                    style="font-size: 1.2rem; margin-right: 8px;"></i>
                                                                Facebook</a></li>
                                                        <li><a href="#" class="footer-item__link"><i
                                                                    class="fab fa-instagram"
                                                                    style="font-size: 1.2rem; margin-right: 8px;"></i>
                                                                Instagram</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="footer__bottom">
                                            <div class="grid">
                                                <p class="footer__text">© 2026 Shopee Clone. Trình tự môn Hệ Thống Web.
                                                </p>
                                            </div>
                                        </div>
                                    </footer>

                                    </div>
                                </body>

                                </html>