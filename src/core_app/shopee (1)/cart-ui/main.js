// Mock State
let cartData = [];
let suggestedData = [];
let lastDeletedItem = null;
let lastDeletedIndex = -1;
let hideToastTimeout = null;

// DOM Elements
const cartItemsContainer = document.getElementById('cartItemsContainer');
const recommendedGrid = document.getElementById('recommendedGrid');
const totalSelectedCountStr = document.getElementById('totalSelectedCount');
const totalSelectedCountText = document.getElementById('totalSelectedCountText');
const mobileCartCount = document.getElementById('mobileCartCount');
const totalAmountEl = document.getElementById('totalAmount');
const btnCheckout = document.getElementById('btnCheckout');
const selectAllTop = document.getElementById('selectAllTop');
const selectAllBottom = document.getElementById('selectAllBottom');
const selectAllMobile = document.getElementById('selectAllMobile');
const emptyState = document.getElementById('emptyState');
const cartContent = document.getElementById('cartContent');
const cartSummary = document.getElementById('cartSummary');

// Mobile specific
const mobileOpenCartBtn = document.getElementById('mobileOpenCartBtn');
const cartOverlay = document.getElementById('cartOverlay');
const cartPanel = document.getElementById('cartPanel');
const closeCartBtn = document.getElementById('closeCartBtn');

// Formatting
const formatPrice = (price) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price).replace('₫', 'đ');

// API mocking
async function fetchData() {
  try {
    // TODO: replace with /api/cart, /api/voucher, /api/checkout
    const res = await fetch('sample-data.json');
    const data = await res.json();
    cartData = data.products.map(p => ({ ...p, checked: false }));
    suggestedData = data.suggested_products;
    renderCart();
    renderSuggested();
  } catch (err) {
    console.error("Failed to load data", err);
  }
}

function updateTotals() {
  let selectedCount = 0;
  let totalRaw = 0;
  
  cartData.forEach(item => {
    if (item.checked) {
      selectedCount++;
      totalRaw += item.price * item.qty;
    }
  });

  const isAllChecked = cartData.length > 0 && selectedCount === cartData.length;
  if(selectAllTop) selectAllTop.checked = isAllChecked;
  if(selectAllBottom) selectAllBottom.checked = isAllChecked;
  if(selectAllMobile) selectAllMobile.checked = isAllChecked;
  
  if(totalSelectedCountStr) totalSelectedCountStr.innerText = selectedCount;
  if(totalSelectedCountText) totalSelectedCountText.innerText = selectedCount;
  if(mobileCartCount) mobileCartCount.innerText = cartData.length;
  
  // Animation for total
  totalAmountEl.innerText = formatPrice(totalRaw);

  if (selectedCount > 0) {
    btnCheckout.disabled = false;
  } else {
    btnCheckout.disabled = true;
  }
}

function toggleItem(id) {
  const item = cartData.find(p => p.id === id);
  if (item) {
    item.checked = !item.checked;
    renderCart();
  }
}

function updateQty(id, delta) {
  const item = cartData.find(p => p.id === id);
  if (item) {
    const newQty = item.qty + delta;
    if (newQty >= 1 && newQty <= (item.stock || 99)) {
      item.qty = newQty;
      renderCart();
    }
  }
}

function removeItem(id) {
  const index = cartData.findIndex(p => p.id === id);
  if (index > -1) {
    lastDeletedItem = cartData[index];
    lastDeletedIndex = index;
    cartData.splice(index, 1);
    renderCart();
    showToast();
  }
}

function showToast() {
  const existing = document.getElementById('undoToast');
  if (existing) existing.remove();

  const toast = document.createElement('div');
  toast.id = 'undoToast';
  toast.className = 'toast';
  toast.innerHTML = `
    <span>Đã xóa sản phẩm</span>
    <span class="toast-undo" onclick="undoRemove()">Hoàn tác</span>
  `;
  document.body.appendChild(toast);
  
  if (hideToastTimeout) clearTimeout(hideToastTimeout);
  hideToastTimeout = setTimeout(() => {
    const t = document.getElementById('undoToast');
    if (t) t.remove();
  }, 4000);
}

window.undoRemove = function() {
  if (lastDeletedItem && lastDeletedIndex > -1) {
    cartData.splice(lastDeletedIndex, 0, lastDeletedItem);
    lastDeletedItem = null;
    lastDeletedIndex = -1;
    const t = document.getElementById('undoToast');
    if (t) t.remove();
    renderCart();
  }
}

function toggleAll(checked) {
  cartData = cartData.map(p => ({ ...p, checked }));
  renderCart();
}

function renderCart() {
  if (cartData.length === 0) {
    cartContent.style.display = 'none';
    cartSummary.style.display = 'none';
    emptyState.style.display = 'flex';
    if(mobileCartCount) mobileCartCount.innerText = "0";
    return;
  }

  cartContent.style.display = 'block';
  cartSummary.style.display = 'block';
  emptyState.style.display = 'none';

  // Group by shop
  const groups = {};
  cartData.forEach(p => {
    if (!groups[p.shop]) groups[p.shop] = [];
    groups[p.shop].push(p);
  });

  let html = '';
  Object.keys(groups).forEach(shopName => {
    const items = groups[shopName];
    const isShopAllChecked = items.every(i => i.checked);
    const voucherInfo = items.find(i => i.shop_voucher)?.shop_voucher;

    html += `
      <div class="shop-group">
        <div class="shop-header">
          <label class="checkbox-container">
            <input type="checkbox" onchange="toggleShop('${shopName}', this.checked)" ${isShopAllChecked ? 'checked' : ''} aria-label="Chọn shop ${shopName}">
            <span class="checkmark"></span>
          </label>
          <i class="fa-solid fa-store" style="margin-left:8px; margin-right:8px; color:var(--text-main);"></i>
          <span class="shop-name">${shopName}</span>
          <i class="fa-solid fa-chevron-right" style="margin-left:4px; font-size:10px; color:#888;"></i>
        </div>
        ${voucherInfo ? `<div class="shop-voucher-line"><i class="fa-solid fa-ticket"></i> ${voucherInfo}</div>` : ''}
    `;

    items.forEach(item => {
      html += `
        <div class="product-item">
          <div class="product-info">
            <label class="checkbox-container">
              <input type="checkbox" onchange="toggleItem('${item.id}')" ${item.checked ? 'checked' : ''} aria-label="Chọn ${item.title}">
              <span class="checkmark"></span>
            </label>
            <img src="${item.img}" alt="${item.title}" class="product-img" loading="lazy">
            <div class="product-details">
               <div class="product-title">${item.title}</div>
               ${item.shipping === 'Miễn phí' ? `<div class="product-campaign">Free Ship</div>` : ''}
               <div class="col-attr mobile-only" style="display:block; font-size:12px; color:#888; margin-top:4px;">Phân loại hàng: ${item.attributes}</div>
            </div>
          </div>
          
          <div class="col-attr desktop-only">
            <div>Phân loại hàng: </div>
            <div>${item.attributes}</div>
          </div>
          
          <div class="item-price desktop-only">
            ${item.price_old ? `<span class="price-old">${formatPrice(item.price_old)}</span>` : ''}
            <span class="price-new">${formatPrice(item.price)}</span>
          </div>

          <div class="mobile-price-qty mobile-only">
             <span class="mobile-price">${formatPrice(item.price)}</span>
             <div class="qty-control" style="width:auto;">
               <div class="qty-wrapper">
                 <button class="qty-btn" aria-label="Giảm số lượng" onclick="updateQty('${item.id}', -1)">-</button>
                 <input type="text" class="qty-input" value="${item.qty}" readonly aria-label="Số lượng">
                 <button class="qty-btn" aria-label="Tăng số lượng" onclick="updateQty('${item.id}', 1)">+</button>
               </div>
            </div>
          </div>
          
          <div class="qty-control desktop-only">
            <div class="qty-wrapper">
              <button class="qty-btn" aria-label="Giảm số lượng" onclick="updateQty('${item.id}', -1)">-</button>
              <input type="text" class="qty-input" value="${item.qty}" readonly aria-label="Số lượng">
              <button class="qty-btn" aria-label="Tăng số lượng" onclick="updateQty('${item.id}', 1)">+</button>
            </div>
          </div>
          
          <div class="item-subtotal desktop-only">
            ${formatPrice(item.price * item.qty)}
          </div>
          
          <div class="item-actions desktop-only">
            <button class="btn-text" onclick="removeItem('${item.id}')">Xóa</button>
            <button class="btn-text highlight" style="font-size:12px;">Tìm sản phẩm tương tự <i class="fa-solid fa-caret-down"></i></button>
          </div>
          
          <!-- Mobile Delete Icon -->
          <button class="btn-text mobile-only" style="position:absolute; right:12px; top:12px; color:#888;" onclick="removeItem('${item.id}')" aria-label="Xóa sản phẩm"><i class="fa-solid fa-trash"></i></button>
        </div>
      `;
    });
    
    html += `</div>`;
  });

  cartItemsContainer.innerHTML = html;
  updateTotals();
}

window.toggleShop = function(shopName, checked) {
  cartData.forEach(p => {
    if(p.shop === shopName) p.checked = checked;
  });
  renderCart();
};

function renderSuggested() {
  let html = '';
  suggestedData.forEach(item => {
    html += `
      <div class="rec-card">
        ${item.badge ? `<div class="rec-badge">${item.badge}</div>` : ''}
        ${item.discount_tag ? `<div class="rec-discount"><span>${item.discount_tag}</span><span class="badge-text">GIẢM</span></div>` : ''}
        <img src="${item.img}" alt="${item.title}" class="rec-img" loading="lazy">
        <div class="rec-info">
          <div class="rec-title">${item.title}</div>
          <div class="rec-price">${formatPrice(item.price)}</div>
          <div class="rec-meta">
            <span><i class="fa-solid fa-star" style="color:#ffce3d; font-size:10px;"></i> ${item.rating}</span>
            <span>Đã bán ${item.sold}</span>
          </div>
        </div>
        
        <!-- Hover CTA overlay for Desktop -->
        <div class="desktop-only" style="position:absolute; bottom:0; padding:8px; width:100%; opacity:0; transition:opacity 0.2s;" onmouseover="this.style.opacity=1" onmouseout="this.style.opacity=0">
          <button class="btn-checkout" style="width:100%; padding:8px; font-size:14px; border-radius:4px;" onclick="alert('Đã thêm ${item.title} vào giỏ')">Thêm vào giỏ</button>
        </div>
      </div>
    `;
  });
  recommendedGrid.innerHTML = html;
}

// Event Listeners
selectAllTop?.addEventListener('change', (e) => toggleAll(e.target.checked));
selectAllBottom?.addEventListener('change', (e) => toggleAll(e.target.checked));
selectAllMobile?.addEventListener('change', (e) => toggleAll(e.target.checked));
document.getElementById('btnDeleteSelected')?.addEventListener('click', () => {
  const count = cartData.filter(p => p.checked).length;
  if(count > 0 && confirm(`Bạn có chắc muốn xóa ${count} sản phẩm đã chọn?`)) {
    cartData = cartData.filter(p => !p.checked);
    renderCart();
  }
});

// Mobile Slide-in handlers
mobileOpenCartBtn?.addEventListener('click', () => {
  cartPanel.classList.add('open');
  cartOverlay.classList.add('show');
  document.body.style.overflow = 'hidden'; // prevent background scroll
});

function closeCart() {
  cartPanel.classList.remove('open');
  cartOverlay.classList.remove('show');
  document.body.style.overflow = '';
}

closeCartBtn?.addEventListener('click', closeCart);
cartOverlay?.addEventListener('click', closeCart);

// Init
fetchData();
