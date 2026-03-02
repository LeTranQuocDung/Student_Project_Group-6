<%@page import="model.Cart" %>
    <%@page import="model.CartItem" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ Hàng - Shopee Clone</title>
                <link rel="stylesheet" href="css/cart.css">
                <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
                    rel="stylesheet">
                <!-- FontAwesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <!-- Header Desktop -->
                <header class="desktop-header desktop-only">
                    <div class="container header-inner">
                        <div class="header-logo">
                            <a href="home" style="text-decoration:none; display:flex; align-items:center; gap:10px;">
                                <i class="fa-solid fa-bag-shopping" style="color: var(--primary); font-size: 32px;"></i>
                                <h1 class="header-title" style="color:var(--primary); margin:0;">Shopee Giỏ Hàng</h1>
                            </a>
                        </div>
                        <div class="header-search">
                            <input type="text" placeholder="Freeship 0Đ (*)" aria-label="Tìm kiếm">
                            <button><i class="fa-solid fa-magnifying-glass"></i></button>
                        </div>
                    </div>
                </header>

                <!-- Mobile Toggle Button (to simulate opening cart panel) -->
                <button id="mobileOpenCartBtn" class="mobile-only mobile-open-btn" aria-label="Mở giỏ hàng">
                    <i class="fa-solid fa-cart-shopping"></i> Mở Giỏ Hàng
                </button>

                <!-- Mobile Cart Overlay -->
                <div id="cartOverlay" class="cart-overlay" aria-hidden="true"></div>

                <!-- Cart Main Container -->
                <div id="cartPanel" class="cart-panel">
                    <% Cart cart=(Cart) session.getAttribute("cart"); int totalQty=(cart !=null) ?
                        cart.getTotalQuantity() : 0; java.math.BigDecimal totalMoney=(cart !=null) ?
                        cart.getTotalMoney() : java.math.BigDecimal.ZERO; int totalItems=(cart !=null && cart.getItems()
                        !=null) ? cart.getItems().size() : 0; %>

                        <div class="cart-panel-header mobile-only">
                            <h2>Giỏ Hàng (<span id="mobileCartCount">
                                    <%= totalQty %>
                                </span>)</h2>
                            <button id="closeCartBtn" class="close-btn" aria-label="Đóng"><i
                                    class="fa-solid fa-xmark"></i></button>
                        </div>

                        <div class="container main-content">

                            <% if (cart==null || cart.getItems().isEmpty()) { %>
                                <!-- Empty State -->
                                <div id="emptyState" class="empty-state">
                                    <i class="fa-solid fa-cart-arrow-down empty-icon"></i>
                                    <p>Giỏ hàng của bạn còn trống</p>
                                    <button class="btn-checkout" onclick="window.location.href='home'">MUA SẮM
                                        NGAY</button>
                                </div>
                                <% } else { %>

                                    <div id="cartContent" class="cart-content">
                                        <!-- Desktop Table Header -->
                                        <div class="cart-table-header desktop-only">
                                            <label class="checkbox-container">
                                                <input type="checkbox" id="selectAllTop" aria-label="Chọn tất cả"
                                                    checked>
                                                <span class="checkmark"></span>
                                                Sản Phẩm
                                            </label>
                                            <div class="col-price">Đơn Giá</div>
                                            <div class="col-qty">Số Lượng</div>
                                            <div class="col-subtotal">Số Tiền</div>
                                            <div class="col-actions">Thao Tác</div>
                                        </div>

                                        <!-- Rendered Cart Items -->
                                        <div id="cartItemsContainer" aria-live="polite">
                                            <div class="shop-group">
                                                <div class="shop-header">
                                                    <label class="checkbox-container">
                                                        <input type="checkbox" class="shop-checkbox"
                                                            aria-label="Chọn shop" checked>
                                                        <span class="checkmark"></span>
                                                    </label>
                                                    <span class="shop-tag">Yêu thích+</span>
                                                    <span class="shop-name">Shopee Official Store</span>
                                                    <i class="fa-solid fa-message"
                                                        style="color: var(--primary); margin-left: 5px;"></i>
                                                </div>

                                                <div class="shop-items">
                                                    <% for (CartItem i : cart.getItems()) { java.math.BigDecimal
                                                        oldPrice=i.getPrice().multiply(new java.math.BigDecimal("1.2"));
                                                        %>
                                                        <div class="product-item">
                                                            <div class="product-info">
                                                                <label class="checkbox-container">
                                                                    <input type="checkbox" class="item-checkbox"
                                                                        data-id="<%= i.getProduct().getId() %>"
                                                                        data-price="<%= i.getPrice() %>"
                                                                        data-qty="<%= i.getQuantity() %>"
                                                                        onchange="calculateTotal()" checked
                                                                        aria-label="Chọn <%= i.getProduct().getName() %>">
                                                                    <span class="checkmark"></span>
                                                                </label>
                                                                <a
                                                                    href="product_detail?id=<%= i.getProduct().getId()%>">
                                                                    <img src="<%= i.getProduct().getImageUrl() %>"
                                                                        alt="<%= i.getProduct().getName() %>"
                                                                        class="product-img" loading="lazy">
                                                                </a>
                                                                <div class="product-details">
                                                                    <div class="product-title">
                                                                        <a href="product_detail?id=<%= i.getProduct().getId()%>"
                                                                            style="text-decoration:none; color:inherit;">
                                                                            <%= i.getProduct().getName() %>
                                                                        </a>
                                                                    </div>
                                                                    <div class="product-campaign">Free Ship</div>
                                                                    <div class="col-attr mobile-only"
                                                                        style="display:block; font-size:12px; color:#888; margin-top:4px;">
                                                                        Phân loại hàng: Mặc định</div>
                                                                    <img src="https://down-vn.img.susercontent.com/file/vn-50009109-c7a2e1ae720f9704f92f72c9ef1a494a"
                                                                        style="height:15px; margin-top:5px; align-self:flex-start;"
                                                                        alt="freeship extra">
                                                                </div>
                                                            </div>

                                                            <div class="col-attr desktop-only">
                                                                <div>Phân loại hàng: </div>
                                                                <div>Mặc định</div>
                                                            </div>

                                                            <div class="item-price desktop-only">
                                                                <span class="price-old">₫<%= String.format("%,.0f",
                                                                        oldPrice) %></span>
                                                                <span class="price-new">₫<%= String.format("%,.0f",
                                                                        i.getPrice()) %></span>
                                                            </div>

                                                            <div class="mobile-price-qty mobile-only">
                                                                <span class="mobile-price">₫<%= String.format("%,.0f",
                                                                        i.getPrice()) %></span>
                                                                <div class="qty-control" style="width:auto;">
                                                                    <div class="qty-wrapper">
                                                                        <button type="button" class="qty-btn"
                                                                            onclick="updateQty(<%= i.getProduct().getId() %>, -1, <%= i.getQuantity() %>)"
                                                                            aria-label="Giảm">-</button>
                                                                        <input type="text" class="qty-input"
                                                                            value="<%= i.getQuantity() %>" readonly
                                                                            aria-label="Số lượng">
                                                                        <button type="button" class="qty-btn"
                                                                            onclick="updateQty(<%= i.getProduct().getId() %>, 1, <%= i.getQuantity() %>)"
                                                                            aria-label="Tăng">+</button>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="qty-control desktop-only">
                                                                <div class="qty-wrapper">
                                                                    <button type="button" class="qty-btn"
                                                                        onclick="updateQty(<%= i.getProduct().getId() %>, -1, <%= i.getQuantity() %>)"
                                                                        aria-label="Giảm">-</button>
                                                                    <input type="text" class="qty-input"
                                                                        value="<%= i.getQuantity() %>" readonly
                                                                        aria-label="Số lượng">
                                                                    <button type="button" class="qty-btn"
                                                                        onclick="updateQty(<%= i.getProduct().getId() %>, 1, <%= i.getQuantity() %>)"
                                                                        aria-label="Tăng">+</button>
                                                                </div>
                                                            </div>

                                                            <div class="item-subtotal desktop-only">
                                                                ₫<%= String.format("%,.0f", i.getTotalPrice()) %>
                                                            </div>

                                                            <div class="item-actions desktop-only">
                                                                <a href="cart?action=delete&id=<%= i.getProduct().getId() %>"
                                                                    class="btn-text"
                                                                    style="text-decoration:none;">Xóa</a>
                                                                <button class="btn-text highlight"
                                                                    style="font-size:12px;">Tìm sản phẩm tương tự <i
                                                                        class="fa-solid fa-caret-down"></i></button>
                                                            </div>

                                                            <!-- Mobile Delete Icon -->
                                                            <a href="cart?action=delete&id=<%= i.getProduct().getId() %>"
                                                                class="btn-text mobile-only"
                                                                style="position:absolute; right:12px; top:12px; color:#888;"
                                                                aria-label="Xóa">
                                                                <i class="fa-solid fa-trash"></i>
                                                            </a>
                                                        </div>
                                                        <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Sticky Summary Desktop/Mobile -->
                                    <div class="cart-summary sticky-bottom" id="cartSummary">
                                        <div class="summary-top">
                                            <div class="voucher-row">
                                                <div class="voucher-left">
                                                    <i class="fa-solid fa-ticket" style="color: var(--primary);"></i>
                                                    Shopee Voucher
                                                </div>
                                                <a href="search?txt=" class="link-blue"
                                                    style="text-decoration:none;">Chọn hoặc nhập
                                                    mã</a>
                                            </div>
                                            <div class="coins-row">
                                                <div class="coins-left">
                                                    <i class="fa-solid fa-coins" style="color: #f6a700;"></i> Shopee Xu
                                                    <span class="coin-hint">Không thể dùng xu</span>
                                                </div>
                                                <div class="coins-right">-0₫</div>
                                            </div>
                                        </div>

                                        <div class="summary-bottom">
                                            <div class="summary-actions desktop-only">
                                                <label class="checkbox-container">
                                                    <input type="checkbox" id="selectAllBottom" aria-label="Chọn tất cả"
                                                        onchange="toggleSelectAll(this)" checked>
                                                    <span class="checkmark"></span>
                                                    Chọn Tất Cả (<span id="totalSelectedCountText">
                                                        <%= totalItems %>
                                                    </span>)
                                                </label>
                                                <button class="btn-text" id="btnDeleteSelected">Xóa</button>
                                                <button class="btn-text highlight">Lưu vào mục Đã thích</button>
                                            </div>

                                            <div class="summary-checkout">
                                                <label class="checkbox-container mobile-only"
                                                    style="padding-left: 24px;">
                                                    <input type="checkbox" id="selectAllMobile" aria-label="Chọn tất cả"
                                                        onchange="toggleSelectAll(this)" checked>
                                                    <span class="checkmark"></span>
                                                    Tất cả
                                                </label>

                                                <div class="total-info">
                                                    <div class="shipping-info desktop-only">
                                                        <i class="fa-solid fa-truck-fast"></i> Giảm 500.000₫ phí vận
                                                        chuyển đơn tối thiểu 0₫ <a href="search?txt=" class="link-blue"
                                                            style="font-size: 12px;text-decoration:none;">Tìm hiểu
                                                            thêm</a>
                                                    </div>
                                                    <div class="total-price-line">
                                                        <span class="total-label">Tổng thanh toán (<span
                                                                id="totalSelectedCount">
                                                                <%= totalQty %>
                                                            </span> sản phẩm):</span>
                                                        <span class="total-amount" id="totalAmount">₫<%=
                                                                String.format("%,.0f", totalMoney)%></span>
                                                    </div>
                                                </div>
                                                <form action="checkout" method="get" class="d-inline m-0"
                                                    style="height:100%; display:flex;">
                                                    <button type="submit" id="btnCheckout" class="btn-checkout"
                                                        style="height: 100%; border-radius: 0; margin-left: 10px; font-weight:bold; min-height: 50px;">
                                                        MUA HÀNG
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <% } %>

                        </div>

                        <!-- Recommended Section -->
                        <div class="container recommended-section">
                            <div class="recommended-header">
                                <h3 style="color: var(--text-muted); font-weight: 500; font-size:16px; margin:0;">CÓ THỂ
                                    BẠN CŨNG THÍCH</h3>
                                <a href="search?txt=" class="link-orange" style="text-decoration:none;">Xem Tất Cả <i
                                        class="fa-solid fa-chevron-right" style="font-size: 10px;"></i></a>
                            </div>
                            <div class="recommended-grid" id="recommendedGrid">
                                <!-- Sẽ chèn gợi ý sản phẩm placeholder từ JS -->
                            </div>
                        </div>

                </div>

                <!-- Scripts -->
                <!-- Không chèn main.js cũ vì nó sẽ render đè mất dữ liệu JSP. Mình giữ nguyên thẻ HTML này -->
                <script>
                    // JS API cho Giỏ Hàng
                    function updateQty(id, change, currentQty) {
                        const newQty = parseInt(currentQty) + parseInt(change);
                        if (newQty <= 0 && !confirm("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?")) {
                            return;
                        }
                        // Gửi request API cập nhật
                        fetch('cart?action=update&id=' + id + '&qty=' + newQty)
                            .then(res => {
                                if (res.ok) window.location.reload();
                            });
                    }

                    // JS Xử lý Checkbox tính tổng tiền tự động
                    function toggleSelectAll(source) {
                        const checkboxes = document.querySelectorAll('.item-checkbox');
                        checkboxes.forEach(cb => cb.checked = source.checked);

                        // Sync các nút selectAll với nhau (top, bottom, mobile)
                        document.getElementById('selectAllTop').checked = source.checked;
                        document.getElementById('selectAllBottom').checked = source.checked;
                        document.getElementById('selectAllMobile').checked = source.checked;
                        document.querySelector('.shop-checkbox').checked = source.checked;

                        calculateTotal();
                    }

                    document.getElementById('selectAllTop').addEventListener('change', function () { toggleSelectAll(this); });
                    document.querySelector('.shop-checkbox').addEventListener('change', function () { toggleSelectAll(this); });

                    function calculateTotal() {
                        const checkboxes = document.querySelectorAll('.item-checkbox');
                        let totalMoney = 0;
                        let totalQty = 0;
                        let unselectedAny = false;

                        checkboxes.forEach(cb => {
                            if (cb.checked) {
                                const price = parseFloat(cb.getAttribute('data-price') || 0);
                                const qty = parseInt(cb.getAttribute('data-qty') || 0);
                                totalMoney += (price * qty);
                                totalQty += qty;
                            } else {
                                unselectedAny = true;
                            }
                        });

                        // Cập nhật text tổng số lượng và số tiền
                        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
                        document.getElementById('totalSelectedCountText').innerText = totalQty;
                        document.getElementById('totalSelectedCount').innerText = totalQty;
                        document.getElementById('totalAmount').innerText = formatter.format(totalMoney).replace(/\s/, '').replace("₫", "₫").replace("VND", "₫");

                        // Cập nhật trạng thái selectAll
                        const allChecked = !unselectedAny;
                        document.getElementById('selectAllTop').checked = allChecked;
                        document.getElementById('selectAllBottom').checked = allChecked;
                        document.getElementById('selectAllMobile').checked = allChecked;
                        document.querySelector('.shop-checkbox').checked = allChecked;

                        // Cập nhật nút Mua hàng
                        const btnCheckout = document.getElementById('btnCheckout');
                        if (totalQty > 0) {
                            btnCheckout.removeAttribute('disabled');
                            btnCheckout.style.opacity = "1";
                            btnCheckout.style.pointerEvents = "auto";
                        } else {
                            btnCheckout.setAttribute('disabled', 'disabled');
                            btnCheckout.style.opacity = "0.6";
                            btnCheckout.style.pointerEvents = "none";
                        }
                    }

                    document.addEventListener('DOMContentLoaded', () => {
                        const btnOpen = document.getElementById('mobileOpenCartBtn');
                        const panel = document.getElementById('cartPanel');
                        const overlay = document.getElementById('cartOverlay');
                        const btnClose = document.getElementById('closeCartBtn');

                        if (btnOpen) btnOpen.onclick = () => { panel.classList.add('open'); overlay.classList.add('show'); };
                        if (btnClose) btnClose.onclick = () => { panel.classList.remove('open'); overlay.classList.remove('show'); };
                        if (overlay) overlay.onclick = () => { panel.classList.remove('open'); overlay.classList.remove('show'); };

                        // Tính tiền lần đầu load
                        calculateTotal();
                    });
                </script>
            </body>

            </html>
