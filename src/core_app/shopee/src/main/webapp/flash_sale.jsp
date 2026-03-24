<%@page import="model.ProductDTO" %>
<%@page import="model.User" %>
<%@page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="referrer" content="no-referrer">
    <title>Flash Sale | Shopee Việt Nam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="css/style.css?v=3.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f5f5f5; }
        .grid { width: 1200px; max-width: 100%; margin: 0 auto; }
        .header__navbar-item-link { text-decoration: none; color: white; }

        /* Flash Sale Page */
        .fs-page { padding-top: 20px; }

        /* Banner */
        .fs-banner {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #ee4d2d 0%, #ff6633 40%, #ff8800 100%);
            border-radius: 4px 4px 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .fs-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
            animation: pulseGlow 3s ease-in-out infinite;
        }
        @keyframes pulseGlow {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 1; }
        }
        .fs-banner-text {
            position: relative;
            z-index: 2;
            text-align: center;
        }
        .fs-banner-text h1 {
            font-size: 42px;
            font-weight: 900;
            color: #fff;
            text-shadow: 0 3px 10px rgba(0,0,0,.2);
            margin: 0;
            letter-spacing: 3px;
        }
        .fs-banner-text h1 span {
            color: #ffd424;
        }
        .fs-banner-choice {
            position: absolute;
            right: 80px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 2;
        }
        .fs-banner-choice span {
            font-size: 60px;
            font-weight: 900;
            color: #fff;
            text-shadow: 0 2px 10px rgba(0,0,0,.15);
            font-style: italic;
        }

        /* Countdown Header */
        .fs-countdown-bar {
            background: #fff;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        .fs-countdown-bar .fs-logo {
            color: #ee4d2d;
            font-size: 22px;
            font-weight: 800;
            font-style: italic;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .fs-countdown-bar .fs-logo i { font-size: 18px; }
        .fs-countdown-label {
            color: rgba(0,0,0,.54);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .fs-countdown-label i { font-size: 12px; }
        .fs-timer {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .fs-timer-box {
            background: #333;
            color: #fff;
            padding: 3px 6px;
            border-radius: 3px;
            font-size: 16px;
            font-weight: 700;
            min-width: 28px;
            text-align: center;
        }
        .fs-timer-sep {
            color: #333;
            font-weight: 700;
            font-size: 14px;
        }
        .fs-divider {
            width: 40px;
            height: 2px;
            background: rgba(0,0,0,.1);
        }

        /* Time Slots */
        .fs-timeslots {
            background: #fff;
            display: flex;
            border-bottom: 2px solid #f0f0f0;
        }
        .fs-timeslot {
            flex: 1;
            text-align: center;
            padding: 14px 10px;
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }
        .fs-timeslot:hover { background: #fef6f5; }
        .fs-timeslot.active {
            background: linear-gradient(to bottom, #fff5f0, #fff);
        }
        .fs-timeslot.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: #ee4d2d;
        }
        .fs-timeslot-time {
            font-size: 18px;
            font-weight: 700;
            color: rgba(0,0,0,.8);
        }
        .fs-timeslot.active .fs-timeslot-time { color: #ee4d2d; }
        .fs-timeslot-status {
            font-size: 12px;
            color: rgba(0,0,0,.54);
            margin-top: 2px;
        }
        .fs-timeslot.active .fs-timeslot-status { color: #ee4d2d; }

        /* Category tabs */
        .fs-categories {
            background: #fff;
            display: flex;
            align-items: center;
            padding: 0 15px;
            border-bottom: 1px solid #f0f0f0;
            gap: 0;
            overflow-x: auto;
            scrollbar-width: none;
        }
        .fs-categories::-webkit-scrollbar { display: none; }
        .fs-cat-tab {
            padding: 14px 20px;
            font-size: 13px;
            color: rgba(0,0,0,.65);
            cursor: pointer;
            white-space: nowrap;
            text-transform: uppercase;
            font-weight: 500;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }
        .fs-cat-tab:hover { color: #ee4d2d; }
        .fs-cat-tab.active {
            color: #ee4d2d;
            border-bottom-color: #ee4d2d;
        }

        /* Product Grid */
        .fs-products {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 10px;
            padding: 15px 0;
        }
        .fs-product-card {
            background: #fff;
            border-radius: 2px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
            display: flex;
            flex-direction: column;
        }
        .fs-product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 12px rgba(0,0,0,.12);
        }
        .fs-product-img {
            position: relative;
            width: 100%;
            padding-top: 100%;
        }
        .fs-product-img img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .fs-discount-badge {
            position: absolute;
            top: 0;
            right: 0;
            background: rgba(255,212,36,.9);
            color: #ee4d2d;
            font-size: 12px;
            font-weight: 700;
            padding: 2px 6px;
            z-index: 2;
        }
        .fs-product-info {
            padding: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
        }
        .fs-product-price {
            color: #ee4d2d;
            font-size: 16px;
            font-weight: 600;
        }
        .fs-product-original {
            color: #999;
            font-size: 12px;
            text-decoration: line-through;
            margin-top: 2px;
        }
        /* Progress bar */
        .fs-sold-bar {
            position: relative;
            width: 100%;
            height: 16px;
            background: #ffbda6;
            border-radius: 8px;
            margin-top: 10px;
            overflow: hidden;
        }
        .fs-sold-fill {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: linear-gradient(to right, #ee4d2d, #ff3b3b);
            border-radius: 8px;
            transition: width 0.5s;
        }
        .fs-sold-label {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 10px;
            text-transform: uppercase;
            z-index: 2;
            text-shadow: 0 0 2px rgba(0,0,0,.3);
        }

        /* Footer simplified */
        .fs-footer {
            background: #fbfbfb;
            padding: 30px 0;
            margin-top: 30px;
            border-top: 4px solid #ee4d2d;
        }
        .fs-footer-text {
            text-align: center;
            font-size: 13px;
            color: rgba(0,0,0,.4);
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
                    <li class="header__navbar-item header__navbar-item--separate"><a href="seller-onboarding" class="header__navbar-item-link">Kênh Người Bán</a></li>
                    <li class="header__navbar-item header__navbar-item--separate"><a href="seller-login" class="header__navbar-item-link">Trở thành Người bán Shopee</a></li>
                    <li class="header__navbar-item header__navbar-item--separate"><a href="#" class="header__navbar-item-link">Tải ứng dụng</a></li>
                    <li class="header__navbar-item">
                        Kết nối
                        <a href="#" class="header__navbar-item-link"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="header__navbar-item-link"><i class="fab fa-instagram"></i></a>
                    </li>
                </ul>
                <ul class="header__navbar-list">
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-bell"></i> Thông báo</a></li>
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-question-circle"></i> Hỗ Trợ</a></li>
                    <li class="header__navbar-item">
                        <div class="lang-dropdown-wrapper">
                            <div class="lang-dropdown-trigger" id="langDropdownTrigger">
                                <i class="fas fa-globe"></i>
                                <span id="currentLangLabel">Tiếng Việt</span>
                                <i class="fas fa-chevron-down lang-dropdown-arrow"></i>
                            </div>
                            <div class="lang-dropdown-menu" id="langDropdownMenu">
                                <a href="#" class="lang-dropdown-item active" data-lang="vi" onclick="switchLang('vi', 'Tiếng Việt', event)">Tiếng Việt</a>
                                <a href="#" class="lang-dropdown-item" data-lang="en" onclick="switchLang('en', 'English', event)">English</a>
                                <a href="#" class="lang-dropdown-item" data-lang="km" onclick="switchLang('km', 'ខ្មែរ', event)">ខ្មែរ</a>
                            </div>
                        </div>
                    </li>
                    <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                        <li class="header__navbar-item header__navbar-item--separate" style="font-weight: 500;">
                            <a href="user/account/profile" class="header__navbar-item-link">
                                <i class="fas fa-user-circle"></i> <%= acc.getFullName() %>
                            </a>
                        </li>
                    <% } else { %>
                        <li class="header__navbar-item header__navbar-item--separate"><a href="register" class="header__navbar-item-link" style="font-weight: 500;">Đăng ký</a></li>
                        <li class="header__navbar-item"><a href="login" class="header__navbar-item-link" style="font-weight: 500;">Đăng nhập</a></li>
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
                        <form action="search" method="get" class="header__search-input-wrap d-flex" style="width:100%; display:flex;">
                            <input type="text" name="txt" class="header__search-input" placeholder="Shopee bao ship 0Đ - Đăng ký ngay!" style="flex:1;">
                            <button type="submit" class="header__search-btn">
                                <i class="fas fa-search header__search-btn-icon"></i>
                            </button>
                        </form>
                    </div>
                    <div class="header__search-suggest" style="margin-top: 5px; font-size: 12px;">
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Săn iPhone 0 Đồng</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Áo Dạ Banh In Tên</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Đồ Ngủ Ở Nhà</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Áo Kiểu Babydoll</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Dế V3</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Quần Bò Cạp Cao Ống Suông</a>
                        <a href="#" style="color: white; margin-right: 13px; text-decoration: none;">Gấu Bông 40cm</a>
                    </div>
                </div>
                <!-- Cart -->
                <div class="header__cart">
                    <div class="header__cart-wrap">
                        <a href="cart" style="text-decoration:none; color:inherit;">
                            <i class="fas fa-shopping-cart header__cart-icon"></i>
                            <span class="header__cart-notice">${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- FLASH SALE PAGE CONTENT -->
        <div class="fs-page">
            <div class="grid">

                <!-- Countdown Bar -->
                <div class="fs-countdown-bar" style="border-radius: 4px 4px 0 0; margin-top: 15px;">
                    <span style="font-size: 24px; color: #ee4d2d;">—</span>
                    <span class="fs-logo"><i class="fas fa-bolt"></i> FLASH SALE</span>
                    <span class="fs-countdown-label"><i class="far fa-clock"></i> KẾT THÚC TRONG</span>
                    <div class="fs-timer">
                        <span class="fs-timer-box" id="fsHours">02</span>
                        <span class="fs-timer-sep">:</span>
                        <span class="fs-timer-box" id="fsMinutes">03</span>
                        <span class="fs-timer-sep">:</span>
                        <span class="fs-timer-box" id="fsSeconds">54</span>
                    </div>
                    <span style="font-size: 24px; color: #ee4d2d;">—</span>
                </div>

                <!-- Banner -->
                <div class="fs-banner">
                    <div class="fs-banner-text">
                        <h1>BÙNG NỔ<br><span>FLASH SALE</span> CÙNG</h1>
                    </div>
                    <div class="fs-banner-choice">
                        <span>✓ Choice</span>
                    </div>
                </div>

                <!-- Time Slots -->
                <div class="fs-timeslots">
                    <div class="fs-timeslot active" onclick="selectSlot(this, 0)">
                        <div class="fs-timeslot-time">02:00</div>
                        <div class="fs-timeslot-status">Đang Diễn Ra</div>
                    </div>
                    <div class="fs-timeslot" onclick="selectSlot(this, 1)">
                        <div class="fs-timeslot-time">09:00</div>
                        <div class="fs-timeslot-status">Sắp Diễn Ra</div>
                    </div>
                    <div class="fs-timeslot" onclick="selectSlot(this, 2)">
                        <div class="fs-timeslot-time">12:00</div>
                        <div class="fs-timeslot-status">Sắp Diễn Ra</div>
                    </div>
                    <div class="fs-timeslot" onclick="selectSlot(this, 3)">
                        <div class="fs-timeslot-time">15:00</div>
                        <div class="fs-timeslot-status">Sắp Diễn Ra</div>
                    </div>
                    <div class="fs-timeslot" onclick="selectSlot(this, 4)">
                        <div class="fs-timeslot-time">17:00</div>
                        <div class="fs-timeslot-status">Sắp Diễn Ra</div>
                    </div>
                </div>

                <div class="fs-categories">
                    <div class="fs-cat-tab active" data-cat-id="0" onclick="selectCat(this)">Top sản phẩm nổi bật</div>
                    <c:forEach var="cat" items="${categories}" begin="0" end="5">
                        <div class="fs-cat-tab" data-cat-id="${cat.id}" onclick="selectCat(this)">${cat.name}</div>
                    </c:forEach>
                </div>

                <!-- Product Grid -->
                <div class="fs-products" id="fsProductGrid">
                    <c:forEach var="p" items="${flashProducts}" varStatus="status">
                        <a href="san-pham-i.686868.${p.id}" class="fs-product-card" data-cat-id="${p.categoryId}">
                            <div class="fs-product-img">
                                <img src="${p.imageUrl}" alt="${p.name}">
                                <% int discount = (int)(Math.random() * 36 + 15); %>
                                <div class="fs-discount-badge">-<%= discount %>%</div>
                            </div>
                            <div class="fs-product-info">
                                <div class="fs-product-price">₫${String.format("%,.0f", p.minPrice)}</div>
                                <%
                                    ProductDTO fp = (ProductDTO) pageContext.getAttribute("p");
                                    java.math.BigDecimal origPrice = fp.getMinPrice().multiply(java.math.BigDecimal.valueOf(100)).divide(java.math.BigDecimal.valueOf(100 - discount), 0, java.math.RoundingMode.UP);
                                %>
                                <div class="fs-product-original">₫<%= String.format("%,.0f", origPrice) %></div>
                                <div class="fs-sold-bar">
                                    <% int sold = (int)(Math.random() * 56 + 40); %>
                                    <div class="fs-sold-fill" style="width: <%= sold %>%;"></div>
                                    <div class="fs-sold-label">
                                        <% if (sold >= 80) { %>
                                            Sắp hết
                                        <% } else { %>
                                            Đang bán chạy
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>

            </div>
        </div>

        <!-- Footer -->
        <footer class="fs-footer">
            <div class="grid">
                <div class="fs-footer-text">© 2026 Shopee Clone. Trình tự môn Hệ Thống Web.</div>
            </div>
        </footer>
    </div>

    <script>
        // Countdown Timer
        (function() {
            var now = new Date();
            var endHour = Math.ceil(now.getHours() / 3) * 3;
            if (endHour <= now.getHours()) endHour += 3;
            var endTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(), endHour, 0, 0);
            
            function updateTimer() {
                var now = new Date();
                var diff = endTime - now;
                if (diff <= 0) {
                    endTime.setHours(endTime.getHours() + 3);
                    diff = endTime - now;
                }
                var h = Math.floor(diff / 3600000);
                var m = Math.floor((diff % 3600000) / 60000);
                var s = Math.floor((diff % 60000) / 1000);
                document.getElementById('fsHours').textContent = String(h).padStart(2, '0');
                document.getElementById('fsMinutes').textContent = String(m).padStart(2, '0');
                document.getElementById('fsSeconds').textContent = String(s).padStart(2, '0');
            }
            updateTimer();
            setInterval(updateTimer, 1000);
        })();

        // Shuffle + animate products
        function shuffleProducts() {
            var grid = document.getElementById('fsProductGrid');
            var cards = Array.from(grid.children);

            // Fade out
            grid.style.opacity = '0.3';
            grid.style.transition = 'opacity 0.2s';

            setTimeout(function() {
                // Shuffle cards
                for (var i = cards.length - 1; i > 0; i--) {
                    var j = Math.floor(Math.random() * (i + 1));
                    grid.appendChild(cards[j]);
                    var temp = cards[i];
                    cards[i] = cards[j];
                    cards[j] = temp;
                }

                // Randomize discount badges and sold bars
                grid.querySelectorAll('.fs-product-card').forEach(function(card) {
                    var disc = Math.floor(Math.random() * 36 + 15);
                    var badge = card.querySelector('.fs-discount-badge');
                    if (badge) badge.textContent = '-' + disc + '%';

                    var soldPct = Math.floor(Math.random() * 56 + 40);
                    var fill = card.querySelector('.fs-sold-fill');
                    if (fill) fill.style.width = soldPct + '%';

                    var label = card.querySelector('.fs-sold-label');
                    if (label) label.textContent = soldPct >= 80 ? 'Sắp hết' : 'Đang bán chạy';
                });

                // Fade in
                grid.style.opacity = '1';
            }, 200);
        }

        // Time Slot Selection
        function selectSlot(el, idx) {
            document.querySelectorAll('.fs-timeslot').forEach(function(s) { s.classList.remove('active'); });
            el.classList.add('active');
            document.querySelectorAll('.fs-timeslot').forEach(function(s, i) {
                s.querySelector('.fs-timeslot-status').textContent = (i === idx) ? 'Đang Diễn Ra' : 'Sắp Diễn Ra';
            });
            shuffleProducts();
        }

        // Category Tab Selection - filter by category
        function selectCat(el) {
            document.querySelectorAll('.fs-cat-tab').forEach(function(t) { t.classList.remove('active'); });
            el.classList.add('active');

            var catId = el.getAttribute('data-cat-id');
            var grid = document.getElementById('fsProductGrid');
            var cards = grid.querySelectorAll('.fs-product-card');

            // Fade out
            grid.style.opacity = '0.3';
            grid.style.transition = 'opacity 0.2s';

            setTimeout(function() {
                if (catId === '0') {
                    // "Top sản phẩm nổi bật" → show all
                    cards.forEach(function(card) { card.style.display = 'flex'; });
                } else {
                    // Filter by category
                    cards.forEach(function(card) {
                        if (card.getAttribute('data-cat-id') === catId) {
                            card.style.display = 'flex';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                }
                // Fade in
                grid.style.opacity = '1';
            }, 200);
        }
    </script>

    <script>
        // Language Switcher
        function switchLang(langCode, langLabel, event) {
            event.preventDefault();
            document.getElementById('currentLangLabel').textContent = langLabel;
            document.querySelectorAll('.lang-dropdown-item').forEach(function(item) {
                item.classList.remove('active');
            });
            event.target.classList.add('active');
            localStorage.setItem('shopee_lang', langCode);
        }
        document.addEventListener('DOMContentLoaded', function() {
            var savedLang = localStorage.getItem('shopee_lang');
            if (savedLang) {
                var langItem = document.querySelector('.lang-dropdown-item[data-lang="' + savedLang + '"]');
                if (langItem) {
                    document.getElementById('currentLangLabel').textContent = langItem.textContent;
                    document.querySelectorAll('.lang-dropdown-item').forEach(function(item) {
                        item.classList.remove('active');
                    });
                    langItem.classList.add('active');
                }
            }
        });
    </script>
</body>
</html>
