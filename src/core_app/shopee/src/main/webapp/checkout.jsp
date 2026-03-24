<%@page import="model.Cart" %>
<%@page import="model.CartItem" %>
<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    User user = (User) session.getAttribute("account");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    if (cart == null || cart.getItems().isEmpty()) { response.sendRedirect("home"); return; }
    int totalQty = cart.getTotalQuantity();
    java.math.BigDecimal totalMoney = cart.getTotalMoney();

%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - Shopee</title>
    <link rel="stylesheet" href="css/checkout.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ===== HEADER ===== -->
<header class="checkout-header">
    <div class="container header-inner">
        <a href="home" class="header-logo-link">
            <i class="fa-solid fa-bag-shopping header-logo-icon"></i>
            <span class="header-brand">Shopee</span>
            <span class="header-divider"></span>
            <span class="header-page-title">Thanh Toán</span>
        </a>
    </div>
</header>

<main class="checkout-main">
<div class="container checkout-layout">

<!-- ===== LEFT COLUMN ===== -->
<div class="checkout-left">

    <!-- 1. ĐỊA CHỈ NHẬN HÀNG -->
    <section class="checkout-section address-section">
        <div class="section-header address-header">
            <div class="address-label">
                <i class="fa-solid fa-location-dot" style="color:#ee4d2d; font-size:18px;"></i>
                <span class="address-title">Địa Chỉ Nhận Hàng</span>
            </div>
        </div>
        <div class="address-body" id="selectedAddressContainer">
            <div class="address-info">
                <span class="address-name"><%= user.getFullName() %></span>
                <span class="address-phone"><%= user.getPhone() != null ? user.getPhone() : "(chưa có SĐT)" %></span>
                <span class="address-badge">Mặc định</span>
            </div>
            <div class="address-detail">
                <span class="address-text"><%= user.getEmail() %></span>
                <button type="button" class="btn-change" onclick="showAddressModal()">Thay Đổi</button>
            </div>
        </div>
    </section>

    <!-- 2. SẢN PHẨM -->
    <section class="checkout-section products-section">
        <div class="products-table-header">
            <div class="ptcol-product">Sản phẩm</div>
            <div class="ptcol-price">Đơn giá</div>
            <div class="ptcol-qty">Số lượng</div>
            <div class="ptcol-total">Thành tiền</div>
        </div>

        <!-- Shop Group -->
        <div class="shop-group">
            <div class="shop-header-row">
                <span class="shop-badge-fav">Yêu thích+</span>
                <span class="shop-name-text">Shopee Official Store</span>
                <i class="fa-solid fa-message" style="color:#ee4d2d; margin-left:6px; font-size:13px;"></i>
            </div>

            <% for (CartItem item : cart.getItems()) {
                java.math.BigDecimal oldPrice = item.getPrice().multiply(new java.math.BigDecimal("1.2"));
            %>
            <div class="product-row">
                <div class="ptcol-product product-info-col">
                    <img src="<%= item.getProduct().getImageUrl() %>" alt="<%= item.getProduct().getName() %>" class="product-thumb" loading="lazy">
                    <div class="product-meta">
                        <div class="product-name-text"><%= item.getProduct().getName() %></div>
                        <div class="product-variant">Phân loại hàng: Mặc định</div>
                        <img src="https://down-vn.img.susercontent.com/file/vn-50009109-c7a2e1ae720f9704f92f72c9ef1a494a" style="height:14px; margin-top:4px;" alt="freeship">
                    </div>
                </div>
                <div class="ptcol-price price-col">
                    <span class="price-old">₫<%= String.format("%,.0f", oldPrice) %></span>
                    <span class="price-new">₫<%= String.format("%,.0f", item.getPrice()) %></span>
                </div>
                <div class="ptcol-qty"><%= item.getQuantity() %></div>
                <div class="ptcol-total total-col">₫<%= String.format("%,.0f", item.getTotalPrice()) %></div>
            </div>
            <% } %>
        </div>

        <!-- Voucher Row inside products section -->
        <div class="voucher-inline-row">
            <div class="voucher-inline-left">
                <i class="fa-solid fa-ticket" style="color:#ee4d2d;"></i>
                <span>Voucher của Shop</span>
            </div>
            <div class="voucher-inline-right" id="shopVoucherStatus">
                <a href="javascript:void(0)" class="voucher-select-link" onclick="showVoucherModal()">Chọn Voucher</a>
            </div>
        </div>

        <!-- Message Row -->
        <div class="message-row">
            <span class="message-label">Lời nhắn:</span>
            <input type="text" class="message-input" placeholder="Lưu ý cho Người bán...">
        </div>

        <!-- Shipping Row -->
        <div class="shipping-method-row" id="shippingDisplay">
            <div class="shipping-left">
                <span class="shipping-title">Phương thức vận chuyển:</span>
                <div class="shipping-detail">
                    <span class="shipping-type" id="shippingTypeName">Nhanh</span>
                    <span class="shipping-est" id="shippingEst">Nhận hàng vào 1 Tháng 3 - 5 Tháng 3</span>
                </div>
            </div>
            <div class="shipping-right">
                <span class="shipping-fee-display" id="shippingFeeDisplay">
                    <span class="shipping-fee-new" id="shippingFeeText">₫25.500</span>
                </span>
                <button type="button" class="btn-change-small" onclick="showShippingModal()">THAY ĐỔI</button>
            </div>
        </div>

        <!-- Order total mini -->
        <div class="order-mini-total">
            <span>Tổng số tiền (<%= totalQty %> sản phẩm):</span>
            <span class="order-mini-amount">₫<%= String.format("%,.0f", totalMoney) %></span>
        </div>
    </section>

    <!-- 3. SHOPEE VOUCHER + XU -->
    <section class="checkout-section platform-voucher-section">
        <div class="platform-voucher-row">
            <div class="pv-left">
                <i class="fa-solid fa-ticket" style="color:#ee4d2d; font-size:16px;"></i>
                <span class="pv-label">Shopee Voucher</span>
            </div>
            <div class="pv-right" id="platformVoucherStatus">
                <a href="javascript:void(0)" class="pv-link" onclick="showPlatformVoucherModal()">Chọn hoặc nhập mã</a>
            </div>
        </div>
        <div class="platform-xu-row">
            <div class="px-left">
                <i class="fa-solid fa-coins" style="color:#f6a700; font-size:16px;"></i>
                <span class="px-label">Shopee Xu</span>
                <span class="px-hint">Không thể dùng xu</span>
            </div>
            <span class="px-value">-₫0</span>
        </div>
    </section>

    <!-- 4. PHƯƠNG THỨC THANH TOÁN -->
    <section class="checkout-section payment-section">
        <div class="payment-header">
            <span class="payment-title">Phương thức thanh toán</span>
        </div>
        <div class="payment-options">
            <label class="payment-option active" data-method="cod">
                <input type="radio" name="paymentMethod" value="COD" checked>
                <span class="payment-option-label">Thanh toán khi nhận hàng</span>
            </label>
            <label class="payment-option" data-method="wallet">
                <input type="radio" name="paymentMethod" value="WALLET">
                <span class="payment-option-label">Ví ShopeePay</span>
            </label>
            <label class="payment-option" data-method="card">
                <input type="radio" name="paymentMethod" value="CARD">
                <span class="payment-option-label">Thẻ Tín dụng/Ghi nợ</span>
            </label>
            <label class="payment-option" data-method="transfer">
                <input type="radio" name="paymentMethod" value="TRANSFER">
                <span class="payment-option-label">Chuyển khoản ngân hàng</span>
            </label>
        </div>
        <div class="payment-cod-notice" id="codNotice">
            <i class="fa-solid fa-circle-info" style="color:#ee4d2d;"></i>
            Phí thu hộ: ₫0 VNĐ. Ưu đãi về phí vận chuyển (nếu có) áp dụng cả với phí thu hộ.
        </div>
    </section>

</div>

<!-- ===== RIGHT COLUMN - STICKY SUMMARY ===== -->
<div class="checkout-right">
    <div class="order-summary-sticky">
        <div class="summary-title">Chi Tiết Thanh Toán</div>

        <div class="summary-line">
            <span>Tổng tiền hàng</span>
            <span id="summarySubtotal">₫<%= String.format("%,.0f", totalMoney) %></span>
        </div>
        <div class="summary-line">
            <span>Phí vận chuyển</span>
            <span id="summaryShipping">₫25.500</span>
        </div>
        <div class="summary-line discount-line" id="summaryVoucherLine">
            <span>Giảm giá voucher</span>
            <span class="discount-value" id="summaryVoucherDiscount">-₫0</span>
        </div>
        <div class="summary-line discount-line" id="summaryShipDiscountLine" style="display:none;">
            <span>Giảm giá phí vận chuyển</span>
            <span class="discount-value" id="summaryShipDiscount">-₫0</span>
        </div>

        <div class="summary-divider"></div>

        <div class="summary-total-line">
            <span>Tổng thanh toán</span>
            <span class="summary-total-amount" id="summaryGrandTotal">₫<%= String.format("%,.0f", totalMoney.add(new java.math.BigDecimal("25500"))) %></span>
        </div>

        <form action="checkout" method="post" id="checkoutForm">
            <button type="submit" class="btn-order" id="btnPlaceOrder">
                Đặt hàng
            </button>
        </form>

        <div class="summary-note">
            Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo
            <a href="javascript:void(0)">Điều khoản Shopee</a>
        </div>
    </div>
</div>

</div>
</main>

<!-- ===== ADDRESS MODAL (LIST) ===== -->
<div class="modal-overlay" id="addressModal">
    <div class="modal-box address-list-modal">
        <div class="modal-header">
            <h3>Địa Chỉ Của Tôi</h3>
            <button class="modal-close" onclick="closeAddressModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body" id="addressListContainer">
            <!-- JS Rendered -->
        </div>
        <div class="modal-footer footer-space-between">
            <button class="btn-add-new-address" onclick="showNewAddressModal()">
                <i class="fa-solid fa-plus"></i> Thêm Địa Chỉ Mới
            </button>
            <div class="footer-actions">
                <button class="btn-modal-cancel" onclick="closeAddressModal()">Hủy</button>
                <button class="btn-modal-confirm" onclick="confirmAddressSelection()">Xác Nhận</button>
            </div>
        </div>
    </div>
</div>

<!-- ===== NEW ADDRESS MODAL ===== -->
<div class="modal-overlay" id="newAddressModal">
    <div class="modal-box new-address-modal">
        <div class="modal-header">
            <h3>Địa chỉ mới (dùng thông tin trước sáp nhập)</h3>
            <button class="modal-close" onclick="closeNewAddressModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body new-address-body">
            <div class="form-row-2">
                <input type="text" id="newAddrName" class="shopee-input" placeholder="Họ và tên">
                <input type="text" id="newAddrPhone" class="shopee-input" placeholder="Số điện thoại">
            </div>
            <div class="form-row-1">
                <select id="newAddrCity" class="shopee-select">
                    <option value="">Tỉnh/ Thành phố, Quận/Huyện, Phường/Xã</option>
                    <option value="Phường Đống Đa, Thành Phố Quy Nhơn, Bình Định">Phường Đống Đa, Thành Phố Quy Nhơn, Bình Định</option>
                    <option value="Hà Nội">Hà Nội</option>
                    <option value="TP. Hồ Chí Minh">TP. Hồ Chí Minh</option>
                </select>
            </div>
            <div class="form-row-1">
                <textarea id="newAddrDetail" class="shopee-textarea" placeholder="Địa chỉ cụ thể" rows="2"></textarea>
            </div>
            
            <div class="map-placeholder">
                <button class="btn-add-location"><i class="fa-solid fa-plus"></i> Thêm vị trí</button>
            </div>

            <div class="address-type-group">
                <div class="address-type-label">Loại địa chỉ:</div>
                <div class="type-buttons">
                    <button class="btn-addr-type active" onclick="selectAddrType(this, 'Nhà Riêng')">Nhà Riêng</button>
                    <button class="btn-addr-type" onclick="selectAddrType(this, 'Văn Phòng')">Văn Phòng</button>
                </div>
            </div>

            <label class="default-checkbox-label">
                <input type="checkbox" id="newAddrDefault" class="shopee-checkbox">
                <span class="checkbox-text">Đặt làm địa chỉ mặc định</span>
            </label>
        </div>
        <div class="modal-footer footer-right">
            <button class="btn-modal-back" onclick="closeNewAddressModal()">Trở Lại</button>
            <button class="btn-modal-confirm" onclick="saveNewAddress()">Hoàn thành</button>
        </div>
    </div>
</div>

<!-- ===== VOUCHER MODAL (SHOP) ===== -->
<div class="modal-overlay" id="voucherModal">
    <div class="modal-box voucher-modal-box">
        <div class="modal-header">
            <h3><i class="fa-solid fa-ticket" style="color:#ee4d2d; margin-right:8px;"></i>Voucher của Shop</h3>
            <button class="modal-close" onclick="closeVoucherModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body voucher-modal-body">
            <div class="voucher-input-row">
                <input type="text" id="shopVoucherCode" class="shopee-input voucher-code-input" placeholder="Nhập mã voucher của Shop">
                <button class="btn-apply-voucher" onclick="applyShopVoucherCode()">ÁP DỤNG</button>
            </div>
            <div class="voucher-section-label">Voucher có sẵn</div>
            <div class="voucher-list" id="shopVoucherList">
                <!-- Rendered by JS -->
            </div>
        </div>
        <div class="modal-footer footer-right">
            <button class="btn-modal-cancel" onclick="closeVoucherModal()">Trở Lại</button>
            <button class="btn-modal-confirm" onclick="confirmShopVoucher()">OK</button>
        </div>
    </div>
</div>

<!-- ===== PLATFORM VOUCHER MODAL ===== -->
<div class="modal-overlay" id="platformVoucherModal">
    <div class="modal-box voucher-modal-box">
        <div class="modal-header">
            <h3><i class="fa-solid fa-ticket" style="color:#ee4d2d; margin-right:8px;"></i>Shopee Voucher</h3>
            <button class="modal-close" onclick="closePlatformVoucherModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body voucher-modal-body">
            <div class="voucher-input-row">
                <input type="text" id="platformVoucherCode" class="shopee-input voucher-code-input" placeholder="Nhập mã Shopee Voucher">
                <button class="btn-apply-voucher" onclick="applyPlatformVoucherCode()">ÁP DỤNG</button>
            </div>
            <div class="voucher-section-label">Voucher có sẵn</div>
            <div class="voucher-list" id="platformVoucherList">
                <!-- Rendered by JS -->
            </div>
        </div>
        <div class="modal-footer footer-right">
            <button class="btn-modal-cancel" onclick="closePlatformVoucherModal()">Trở Lại</button>
            <button class="btn-modal-confirm" onclick="confirmPlatformVoucher()">OK</button>
        </div>
    </div>
</div>

<!-- ===== SHIPPING MODAL ===== -->
<div class="modal-overlay" id="shippingModal">
    <div class="modal-box shipping-modal-box">
        <div class="modal-header">
            <h3><i class="fa-solid fa-truck" style="color:#26aa99; margin-right:8px;"></i>Chọn Phương Thức Vận Chuyển</h3>
            <button class="modal-close" onclick="closeShippingModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body shipping-modal-body">
            <div class="shipping-options-list" id="shippingOptionsList">
                <!-- Rendered by JS -->
            </div>
        </div>
        <div class="modal-footer footer-right">
            <button class="btn-modal-cancel" onclick="closeShippingModal()">Hủy</button>
            <button class="btn-modal-confirm" onclick="confirmShipping()">Hoàn Thành</button>
        </div>
    </div>
</div>

<script>
    // ===== GLOBAL STATE =====
    const TOTAL_MONEY = <%= totalMoney %>;
    let selectedShopVoucherId = null;
    let tempShopVoucherId = null;
    let selectedPlatformVoucherId = null;
    let tempPlatformVoucherId = null;
    let selectedShippingId = 'fast';
    let tempShippingId = 'fast';

    // ===== VOUCHER DATA =====
    const shopVouchers = [
        { id: 'sv1', code: 'SHOP15K', label: 'Giảm ₫15.000', desc: 'Đơn tối thiểu ₫100.000', type: 'fixed', value: 15000, minOrder: 100000 },
        { id: 'sv2', code: 'SHOP10P', label: 'Giảm 10%', desc: 'Giảm tối đa ₫30.000 - Đơn tối thiểu ₫200.000', type: 'percent', value: 10, maxDiscount: 30000, minOrder: 200000 },
        { id: 'sv3', code: 'SHOP50K', label: 'Giảm ₫50.000', desc: 'Đơn tối thiểu ₫500.000', type: 'fixed', value: 50000, minOrder: 500000 }
    ];

    const platformVouchers = [
        { id: 'pv1', code: 'SHOPEE10K', label: 'Giảm ₫10.000', desc: 'Đơn tối thiểu ₫50.000', type: 'fixed', value: 10000, minOrder: 50000 },
        { id: 'pv2', code: 'SHOPEE5P', label: 'Giảm 5%', desc: 'Giảm tối đa ₫20.000 - Đơn tối thiểu ₫150.000', type: 'percent', value: 5, maxDiscount: 20000, minOrder: 150000 },
        { id: 'pv3', code: 'FREESHIP', label: 'Miễn phí vận chuyển', desc: 'Giảm tối đa ₫25.000 phí ship', type: 'freeship', value: 25000, minOrder: 0 }
    ];

    // ===== SHIPPING DATA =====
    const shippingMethods = [
        { id: 'fast', name: 'Nhanh', fee: 25500, est: '2-4 ngày', estText: 'Nhận hàng vào 1 Tháng 3 - 5 Tháng 3', icon: 'fa-truck-fast', color: '#26aa99' },
        { id: 'economy', name: 'Tiết kiệm', fee: 16500, est: '4-7 ngày', estText: 'Nhận hàng vào 3 Tháng 3 - 8 Tháng 3', icon: 'fa-box', color: '#05a' },
        { id: 'express', name: 'Hỏa tốc', fee: 45000, est: '1-2 ngày', estText: 'Nhận hàng vào 28 Tháng 2 - 1 Tháng 3', icon: 'fa-bolt', color: '#ee4d2d' },
        { id: 'bulky', name: 'Hàng cồng kềnh', fee: 35000, est: '3-5 ngày', estText: 'Nhận hàng vào 2 Tháng 3 - 6 Tháng 3', icon: 'fa-truck-moving', color: '#8B5CF6' }
    ];

    // ===== UTILITY FUNCTIONS =====
    function formatVND(num) {
        return '₫' + Math.round(num).toLocaleString('vi-VN');
    }

    function calcVoucherDiscount(voucher) {
        if (!voucher) return 0;
        if (TOTAL_MONEY < voucher.minOrder) return 0;
        if (voucher.type === 'fixed') return voucher.value;
        if (voucher.type === 'percent') {
            let d = TOTAL_MONEY * voucher.value / 100;
            return Math.min(d, voucher.maxDiscount || d);
        }
        if (voucher.type === 'freeship') return 0; // handled separately
        return 0;
    }

    function calcFreeshipDiscount(voucher, shippingFee) {
        if (!voucher || voucher.type !== 'freeship') return 0;
        return Math.min(voucher.value, shippingFee);
    }

    // ===== UPDATE SUMMARY =====
    function updateSummary() {
        const ship = shippingMethods.find(s => s.id === selectedShippingId) || shippingMethods[0];
        const shopV = shopVouchers.find(v => v.id === selectedShopVoucherId);
        const platV = platformVouchers.find(v => v.id === selectedPlatformVoucherId);

        const shippingFee = ship.fee;
        const shopDiscount = calcVoucherDiscount(shopV);
        const platDiscount = calcVoucherDiscount(platV);
        const freeshipDiscount = calcFreeshipDiscount(platV, shippingFee);
        const totalVoucherDiscount = shopDiscount + platDiscount;
        const grandTotal = TOTAL_MONEY + shippingFee - totalVoucherDiscount - freeshipDiscount;

        document.getElementById('summarySubtotal').textContent = formatVND(TOTAL_MONEY);
        document.getElementById('summaryShipping').textContent = formatVND(shippingFee);
        document.getElementById('summaryVoucherDiscount').textContent = '-' + formatVND(totalVoucherDiscount);
        document.getElementById('summaryVoucherLine').style.display = totalVoucherDiscount > 0 ? 'flex' : 'flex';

        if (freeshipDiscount > 0) {
            document.getElementById('summaryShipDiscountLine').style.display = 'flex';
            document.getElementById('summaryShipDiscount').textContent = '-' + formatVND(freeshipDiscount);
        } else {
            document.getElementById('summaryShipDiscountLine').style.display = 'none';
        }

        document.getElementById('summaryGrandTotal').textContent = formatVND(Math.max(0, grandTotal));
    }

    // ===== SHOP VOUCHER MODAL =====
    function renderShopVouchers() {
        const container = document.getElementById('shopVoucherList');
        container.innerHTML = '';
        shopVouchers.forEach(v => {
            const eligible = TOTAL_MONEY >= v.minOrder;
            const isSelected = v.id === tempShopVoucherId;
            const html = ''
                + '<div class="voucher-card ' + (isSelected ? 'selected' : '') + ' ' + (!eligible ? 'disabled' : '') + '" onclick="' + (eligible ? 'selectShopVoucher(\'' + v.id + '\')' : '') + '">'
                + '  <div class="voucher-card-left">'
                + '    <div class="voucher-card-icon"><i class="fa-solid fa-tag"></i></div>'
                + '  </div>'
                + '  <div class="voucher-card-body">'
                + '    <div class="voucher-card-title">' + v.label + '</div>'
                + '    <div class="voucher-card-desc">' + v.desc + '</div>'
                + '    <div class="voucher-card-code">Mã: ' + v.code + '</div>'
                + '  </div>'
                + '  <div class="voucher-card-radio">'
                + '    <input type="radio" name="shopVoucherSelect" ' + (isSelected ? 'checked' : '') + ' ' + (!eligible ? 'disabled' : '') + '>'
                + '  </div>'
                + '</div>';
            container.insertAdjacentHTML('beforeend', html);
        });
    }

    function selectShopVoucher(id) {
        tempShopVoucherId = (tempShopVoucherId === id) ? null : id;
        renderShopVouchers();
    }

    function showVoucherModal() {
        tempShopVoucherId = selectedShopVoucherId;
        renderShopVouchers();
        document.getElementById('voucherModal').classList.add('show');
    }

    function closeVoucherModal() {
        document.getElementById('voucherModal').classList.remove('show');
    }

    function confirmShopVoucher() {
        selectedShopVoucherId = tempShopVoucherId;
        updateShopVoucherDisplay();
        updateSummary();
        closeVoucherModal();
    }

    function updateShopVoucherDisplay() {
        const container = document.getElementById('shopVoucherStatus');
        const v = shopVouchers.find(x => x.id === selectedShopVoucherId);
        if (v) {
            container.innerHTML = '<span class="voucher-applied-tag"><i class="fa-solid fa-check-circle"></i> ' + v.label + '</span>'
                + '<a href="javascript:void(0)" class="voucher-change-link" onclick="showVoucherModal()">Thay đổi</a>';
        } else {
            container.innerHTML = '<a href="javascript:void(0)" class="voucher-select-link" onclick="showVoucherModal()">Chọn Voucher</a>';
        }
    }

    function applyShopVoucherCode() {
        const code = document.getElementById('shopVoucherCode').value.trim().toUpperCase();
        if (!code) return;
        const found = shopVouchers.find(v => v.code === code);
        if (found) {
            if (TOTAL_MONEY < found.minOrder) {
                alert('Đơn hàng chưa đạt giá trị tối thiểu ' + formatVND(found.minOrder));
                return;
            }
            tempShopVoucherId = found.id;
            renderShopVouchers();
            document.getElementById('shopVoucherCode').value = '';
        } else {
            alert('Mã voucher không hợp lệ!');
        }
    }

    // ===== PLATFORM VOUCHER MODAL =====
    function renderPlatformVouchers() {
        const container = document.getElementById('platformVoucherList');
        container.innerHTML = '';
        platformVouchers.forEach(v => {
            const eligible = TOTAL_MONEY >= v.minOrder;
            const isSelected = v.id === tempPlatformVoucherId;
            const iconClass = v.type === 'freeship' ? 'fa-truck' : 'fa-tag';
            const html = ''
                + '<div class="voucher-card ' + (isSelected ? 'selected' : '') + ' ' + (!eligible ? 'disabled' : '') + '" onclick="' + (eligible ? 'selectPlatformVoucher(\'' + v.id + '\')' : '') + '">'
                + '  <div class="voucher-card-left platform">'
                + '    <div class="voucher-card-icon"><i class="fa-solid ' + iconClass + '"></i></div>'
                + '  </div>'
                + '  <div class="voucher-card-body">'
                + '    <div class="voucher-card-title">' + v.label + '</div>'
                + '    <div class="voucher-card-desc">' + v.desc + '</div>'
                + '    <div class="voucher-card-code">Mã: ' + v.code + '</div>'
                + '  </div>'
                + '  <div class="voucher-card-radio">'
                + '    <input type="radio" name="platVoucherSelect" ' + (isSelected ? 'checked' : '') + ' ' + (!eligible ? 'disabled' : '') + '>'
                + '  </div>'
                + '</div>';
            container.insertAdjacentHTML('beforeend', html);
        });
    }

    function selectPlatformVoucher(id) {
        tempPlatformVoucherId = (tempPlatformVoucherId === id) ? null : id;
        renderPlatformVouchers();
    }

    function showPlatformVoucherModal() {
        tempPlatformVoucherId = selectedPlatformVoucherId;
        renderPlatformVouchers();
        document.getElementById('platformVoucherModal').classList.add('show');
    }

    function closePlatformVoucherModal() {
        document.getElementById('platformVoucherModal').classList.remove('show');
    }

    function confirmPlatformVoucher() {
        selectedPlatformVoucherId = tempPlatformVoucherId;
        updatePlatformVoucherDisplay();
        updateSummary();
        closePlatformVoucherModal();
    }

    function updatePlatformVoucherDisplay() {
        const container = document.getElementById('platformVoucherStatus');
        const v = platformVouchers.find(x => x.id === selectedPlatformVoucherId);
        if (v) {
            container.innerHTML = '<span class="voucher-applied-tag platform-tag"><i class="fa-solid fa-check-circle"></i> ' + v.label + '</span>'
                + '<a href="javascript:void(0)" class="voucher-change-link" onclick="showPlatformVoucherModal()">Thay đổi</a>';
        } else {
            container.innerHTML = '<a href="javascript:void(0)" class="pv-link" onclick="showPlatformVoucherModal()">Chọn hoặc nhập mã</a>';
        }
    }

    function applyPlatformVoucherCode() {
        const code = document.getElementById('platformVoucherCode').value.trim().toUpperCase();
        if (!code) return;
        const found = platformVouchers.find(v => v.code === code);
        if (found) {
            if (TOTAL_MONEY < found.minOrder) {
                alert('Đơn hàng chưa đạt giá trị tối thiểu ' + formatVND(found.minOrder));
                return;
            }
            tempPlatformVoucherId = found.id;
            renderPlatformVouchers();
            document.getElementById('platformVoucherCode').value = '';
        } else {
            alert('Mã voucher không hợp lệ!');
        }
    }

    // ===== SHIPPING MODAL =====
    function renderShippingOptions() {
        const container = document.getElementById('shippingOptionsList');
        container.innerHTML = '';
        shippingMethods.forEach(s => {
            const isSelected = s.id === tempShippingId;
            const html = ''
                + '<div class="shipping-option-card ' + (isSelected ? 'selected' : '') + '" onclick="selectShippingOption(\'' + s.id + '\')">'
                + '  <div class="shipping-opt-radio">'
                + '    <input type="radio" name="shippingSelect" ' + (isSelected ? 'checked' : '') + '>'
                + '  </div>'
                + '  <div class="shipping-opt-icon" style="color:' + s.color + '"><i class="fa-solid ' + s.icon + '"></i></div>'
                + '  <div class="shipping-opt-body">'
                + '    <div class="shipping-opt-name">' + s.name + '</div>'
                + '    <div class="shipping-opt-est">' + s.estText + '</div>'
                + '    <div class="shipping-opt-time"><i class="fa-regular fa-clock"></i> ' + s.est + '</div>'
                + '  </div>'
                + '  <div class="shipping-opt-fee">' + formatVND(s.fee) + '</div>'
                + '</div>';
            container.insertAdjacentHTML('beforeend', html);
        });
    }

    function selectShippingOption(id) {
        tempShippingId = id;
        renderShippingOptions();
    }

    function showShippingModal() {
        tempShippingId = selectedShippingId;
        renderShippingOptions();
        document.getElementById('shippingModal').classList.add('show');
    }

    function closeShippingModal() {
        document.getElementById('shippingModal').classList.remove('show');
    }

    function confirmShipping() {
        selectedShippingId = tempShippingId;
        updateShippingDisplay();
        updateSummary();
        closeShippingModal();
    }

    function updateShippingDisplay() {
        const ship = shippingMethods.find(s => s.id === selectedShippingId);
        if (!ship) return;
        document.getElementById('shippingTypeName').textContent = ship.name;
        document.getElementById('shippingTypeName').style.color = ship.color;
        document.getElementById('shippingEst').textContent = ship.estText;
        document.getElementById('shippingFeeText').textContent = formatVND(ship.fee);
    }

    // ===== PAYMENT METHOD =====
    document.querySelectorAll('.payment-option').forEach(opt => {
        opt.addEventListener('click', function() {
            document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('active'));
            this.classList.add('active');
            this.querySelector('input[type="radio"]').checked = true;
            const codNotice = document.getElementById('codNotice');
            codNotice.style.display = this.dataset.method === 'cod' ? 'flex' : 'none';
        });
    });

    // ===== ADDRESS MANAGEMENT =====
    let currentAddrType = 'Nhà Riêng';
    let addresses = [
        {
            id: 1,
            name: "<%= user.getFullName() %>",
            phone: "<%= user.getPhone() != null ? user.getPhone() : "(chưa có SĐT)" %>",
            detailText: "Phường Đống Đa, Thành Phố Quy Nhơn, Bình Định",
            specificText: "227/09 lê thanh nghị",
            isDefault: true,
            type: "Nhà Riêng"
        }
    ];
    let selectedAddressId = 1;
    let tempSelectedAddressId = 1;

    function renderAddressList() {
        const container = document.getElementById('addressListContainer');
        container.innerHTML = '';
        addresses.forEach(addr => {
            const isChecked = addr.id === tempSelectedAddressId ? 'checked' : '';
            const isSelected = addr.id === tempSelectedAddressId ? 'selected' : '';
            const defaultBadge = addr.isDefault ? '<span class="address-badge-sm">Mặc định</span>' : '';
            const html = ''
                + '<div class="address-item ' + isSelected + '" onclick="selectAddressItem(' + addr.id + ')">'
                + '    <div class="address-radio">'
                + '        <input type="radio" name="addressSelect" ' + isChecked + '>'
                + '        <span class="custom-radio"></span>'
                + '    </div>'
                + '    <div class="address-content">'
                + '        <div class="address-item-info-top">'
                + '            <span class="ai-name">' + addr.name + '</span>'
                + '            <span class="ai-phone">' + addr.phone + '</span>'
                + '            <a href="javascript:void(0)" class="btn-update-addr">Cập nhật</a>'
                + '        </div>'
                + '        <div class="ai-detail-wrap">'
                + '            <div class="ai-detail">' + addr.specificText + '</div>'
                + '            <div class="ai-detail">' + addr.detailText + '</div>'
                + '            ' + defaultBadge
                + '        </div>'
                + '    </div>'
                + '</div>';
            container.insertAdjacentHTML('beforeend', html);
        });
    }

    function selectAddressItem(id) { tempSelectedAddressId = id; renderAddressList(); }
    function showAddressModal() { tempSelectedAddressId = selectedAddressId; renderAddressList(); document.getElementById('addressModal').classList.add('show'); }
    function closeAddressModal() { document.getElementById('addressModal').classList.remove('show'); }
    function confirmAddressSelection() { selectedAddressId = tempSelectedAddressId; updateMainAddressDisplay(); closeAddressModal(); }

    function updateMainAddressDisplay() {
        const addr = addresses.find(a => a.id === selectedAddressId);
        if(!addr) return;
        const container = document.getElementById('selectedAddressContainer');
        const defaultBadge = addr.isDefault ? '<span class="address-badge">Mặc định</span>' : '';
        container.innerHTML = ''
            + '<div class="address-info">'
            + '    <span class="address-name">' + addr.name + '</span>'
            + '    <span class="address-phone">' + addr.phone + '</span>'
            + '    ' + defaultBadge
            + '</div>'
            + '<div class="address-detail">'
            + '    <span class="address-text">' + addr.specificText + ', ' + addr.detailText + '</span>'
            + '    <button type="button" class="btn-change" onclick="showAddressModal()">Thay Đổi</button>'
            + '</div>';
    }

    function showNewAddressModal() { closeAddressModal(); document.getElementById('newAddressModal').classList.add('show'); }
    function closeNewAddressModal() { document.getElementById('newAddressModal').classList.remove('show'); showAddressModal(); }
    function selectAddrType(btn, type) { document.querySelectorAll('.btn-addr-type').forEach(b => b.classList.remove('active')); btn.classList.add('active'); currentAddrType = type; }

    function saveNewAddress() {
        const name = document.getElementById('newAddrName').value;
        const phone = document.getElementById('newAddrPhone').value;
        const city = document.getElementById('newAddrCity').value;
        const detail = document.getElementById('newAddrDetail').value;
        const isDefault = document.getElementById('newAddrDefault').checked;
        if(!name || !phone || !city || !detail) { alert('Vui lòng điền đầy đủ thông tin!'); return; }
        if(isDefault) { addresses.forEach(a => a.isDefault = false); }
        const newAddr = { id: Date.now(), name, phone: "(+84) " + phone.replace(/^0/, ''), detailText: city, specificText: detail, isDefault, type: currentAddrType };
        addresses.push(newAddr);
        tempSelectedAddressId = newAddr.id;
        document.getElementById('newAddrName').value = '';
        document.getElementById('newAddrPhone').value = '';
        document.getElementById('newAddrCity').value = '';
        document.getElementById('newAddrDetail').value = '';
        document.getElementById('newAddrDefault').checked = false;
        closeNewAddressModal();
    }

    // ===== INIT =====
    document.addEventListener('DOMContentLoaded', () => {
        updateMainAddressDisplay();
        updateShippingDisplay();
        updateSummary();
    });

    // Close any modal on overlay click
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) this.classList.remove('show');
        });
    });
</script>

</body>
</html>
