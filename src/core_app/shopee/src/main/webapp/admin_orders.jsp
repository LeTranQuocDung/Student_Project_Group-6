<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Đơn Hàng | Shopee Admin</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                :root {
                    --shopee-primary: #ee4d2d;
                    --shopee-hover: #f05d40;
                    --sidebar-width: 260px;
                    --bg-color: #f5f5f5;
                    --card-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
                }

                body {
                    background: var(--bg-color);
                    font-family: 'Inter', sans-serif;
                    overflow-x: hidden;
                }

                .sidebar {
                    height: 100vh;
                    background: #fff;
                    width: var(--sidebar-width);
                    position: fixed;
                    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
                    z-index: 100;
                    overflow-y: auto;
                }

                .sidebar-logo {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 20px 0;
                    border-bottom: 1px solid #eee;
                }

                .sidebar-logo h4 {
                    color: var(--shopee-primary);
                    font-weight: 700;
                    margin: 0;
                    font-size: 22px;
                }

                .nav-item {
                    padding: 5px 15px;
                }

                .sidebar a {
                    color: #555;
                    text-decoration: none;
                    padding: 12px 20px;
                    display: flex;
                    align-items: center;
                    border-radius: 8px;
                    font-weight: 500;
                    transition: all 0.2s ease;
                    margin-bottom: 5px;
                }

                .sidebar a i {
                    width: 30px;
                    font-size: 18px;
                }

                .sidebar a:hover {
                    background-color: #fef0ee;
                    color: var(--shopee-primary);
                }

                .sidebar a.active {
                    background-color: var(--shopee-primary);
                    color: #fff;
                    box-shadow: 0 4px 6px rgba(238, 77, 45, 0.2);
                }

                .main-content {
                    margin-left: var(--sidebar-width);
                    padding: 30px 40px;
                }

                .top-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    background: #fff;
                    padding: 15px 30px;
                    border-radius: 12px;
                    box-shadow: var(--card-shadow);
                    margin-bottom: 30px;
                }

                .content-box {
                    background: #fff;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: var(--card-shadow);
                }

                .btn-shopee {
                    background-color: var(--shopee-primary);
                    color: white;
                    border: none;
                }

                .btn-shopee:hover {
                    background-color: var(--shopee-hover);
                    color: white;
                }

                .badge-pending {
                    background: #fff3cd;
                    color: #856404;
                    font-weight: 600;
                }

                .badge-completed {
                    background: #d4edda;
                    color: #155724;
                    font-weight: 600;
                }

                .badge-cancelled {
                    background: #f8d7da;
                    color: #721c24;
                    font-weight: 600;
                }

                .badge-paid {
                    background: #cce5ff;
                    color: #004085;
                    font-weight: 600;
                }

                .badge-shipped {
                    background: #e2e3f1;
                    color: #383d6e;
                    font-weight: 600;
                }

                .status-select {
                    border: 2px solid #dee2e6;
                    border-radius: 8px;
                    padding: 5px 10px;
                    font-size: 13px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: border-color 0.2s;
                }

                .status-select:focus {
                    border-color: var(--shopee-primary);
                    outline: none;
                    box-shadow: 0 0 0 3px rgba(238, 77, 45, 0.15);
                }
            </style>
        </head>

        <body>
            <!-- Sidebar -->

            <%@ include file="admin_sidebar.jsp" %>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <div class="top-header">
                    <div>
                        <h4 class="m-0 fw-bold text-dark">Quản Lý Đơn Hàng</h4>
                        <small class="text-muted">Theo dõi và cập nhật trạng thái đơn hàng</small>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="dropdown">
                            <button class="btn btn-light rounded-circle shadow-sm position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger rounded-circle"></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" style="width: 300px;">
                                <li><h6 class="dropdown-header fw-bold text-dark">Thông Báo</h6></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-center text-muted py-3" href="#">Chưa có thông báo mới nào</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-center fw-medium text-primary" href="#">Xem tất cả</a></li>
                            </ul>
                        </div>
                        <div class="d-flex align-items-center gap-2 border-start ps-3">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true"
                                width="45">
                            <div class="d-flex flex-column">
                                <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                                <span class="text-muted" style="font-size: 12px;">Quản trị viên</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content Box -->
                <div class="content-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold m-0 text-dark"><i class="fas fa-clipboard-list me-2 text-muted"></i>
                            <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                Thùng rác đơn hàng
                            <% } else { %>
                                Danh sách đơn hàng
                            <% } %>
                        </h5>
                        <div class="d-flex align-items-center gap-3">
                            <% if (request.getAttribute("isTrash") == null || !(Boolean) request.getAttribute("isTrash")) { %>
                                <% String currentStatus = (String) request.getAttribute("currentStatus"); %>
                                <select class="form-select form-select-sm" style="width: 160px;" onchange="location.href='admin-orders?status=' + this.value">
                                    <option value="ALL" <%= "ALL".equals(currentStatus) || currentStatus == null ? "selected" : "" %>>Tất cả trạng thái</option>
                                    <option value="PENDING" <%= "PENDING".equals(currentStatus) ? "selected" : "" %>>Chờ xử lý</option>
                                    <option value="PAID" <%= "PAID".equals(currentStatus) ? "selected" : "" %>>Đã thanh toán</option>
                                    <option value="SHIPPED" <%= "SHIPPED".equals(currentStatus) ? "selected" : "" %>>Đang giao</option>
                                    <option value="COMPLETED" <%= "COMPLETED".equals(currentStatus) ? "selected" : "" %>>Hoàn thành</option>
                                    <option value="CANCELLED" <%= "CANCELLED".equals(currentStatus) ? "selected" : "" %>>Đã hủy</option>
                                </select>
                            <% } %>
                            <span class="badge bg-secondary fs-6">
                                <% List<String[]> orders = (List<String[]>) request.getAttribute("orders");
                                        out.print(orders != null ? orders.size() : 0);
                                        %> đơn
                            </span>
                            <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                <a href="admin-orders" class="btn btn-secondary btn-sm shadow-sm ms-2">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                                </a>
                            <% } else { %>
                                <a href="admin-orders?action=view_trash" class="btn btn-warning btn-sm shadow-sm ms-2">
                                    <i class="fas fa-trash-alt me-1"></i> Xem Thùng Rác
                                </a>
                            <% } %>
                        </div>
                        </div>
                    </div>

                    <!-- Bulk Actions -->
                    <div class="bulk-actions mb-4" style="display: none;" id="bulk-action-bar">
                        <div class="d-flex align-items-center gap-3">
                            <span class="text-muted fw-medium"><span id="selected-count">0</span> đơn hàng đã chọn</span>
                            <div class="vr"></div>
                            
                            <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                <button type="button" class="btn btn-outline-success shadow-sm" onclick="submitBulkAction('bulk_restore')">
                                    <i class="fas fa-undo me-1"></i> Khôi phục mục chọn
                                </button>
                                <button type="button" class="btn btn-danger shadow-sm ms-2" onclick="submitBulkAction('bulk_delete_permanent')">
                                    <i class="fas fa-trash-alt me-1"></i> Xóa vĩnh viễn mục chọn
                                </button>
                            <% } else { %>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="fw-medium text-dark"><i class="fas fa-exchange-alt me-1 text-primary"></i> Đổi trạng thái:</span>
                                    <select class="form-select form-select-sm status-select bg-light" id="bulkStatusSelect" style="width: 140px;" onchange="submitBulkStatus()">
                                        <option value="">-- Chọn --</option>
                                        <option value="PENDING">Chờ xử lý</option>
                                        <option value="PAID">Đã thanh toán</option>
                                        <option value="SHIPPED">Đang giao</option>
                                        <option value="COMPLETED">Hoàn thành</option>
                                        <option value="CANCELLED">Đã hủy</option>
                                    </select>
                                </div>
                                <div class="vr"></div>
                                <button type="button" class="btn btn-outline-danger shadow-sm" onclick="submitBulkAction('bulk_delete')">
                                    <i class="fas fa-trash me-1"></i> Xóa mục chọn
                                </button>
                            <% } %>
                        </div>
                    </div>

                    <!-- Main Table Form -->
                    <form id="bulkForm" action="admin-orders" method="POST">
                        <input type="hidden" name="action" id="bulk-action-input" value="">
                        <input type="hidden" name="bulk_status" id="bulk-status-input" value="">
                        
                    <div class="table-responsive">
                        <table class="table table-hover border align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th width="40" class="text-center">
                                        <input class="form-check-input" type="checkbox" id="selectAll">
                                    </th>
                                    <th width="80">Mã ĐH</th>
                                    <th>Khách Hàng</th>
                                    <th>Email</th>
                                    <th width="150" class="text-end">Tổng Tiền</th>
                                    <th width="150" class="text-center">Trạng Thái</th>
                                    <th width="180">Ngày Tạo</th>
                                    <th width="130" class="text-center">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(orders !=null) { for(String[] o : orders) { String statusClass="badge-pending" ;
                                    String statusText="Xử lý"; if("COMPLETED".equals(o[4])) { statusClass="badge-completed"; statusText="Hoàn thành"; }
                                    else if("CANCELLED".equals(o[4])) { statusClass="badge-cancelled"; statusText="Đã hủy"; } else
                                    if("PAID".equals(o[4])) { statusClass="badge-paid"; statusText="Đã thanh toán"; } else if("SHIPPED".equals(o[4]))
                                    { statusClass="badge-shipped"; statusText="Đang giao"; } %>
                                    <tr>
                                        <td class="text-center">
                                            <input class="form-check-input row-checkbox" type="checkbox" name="selectedIds" value="<%= o[0] %>">
                                        </td>
                                        <td class="fw-bold">#<%= o[0] %>
                                        </td>
                                        <td><i class="fas fa-user-circle text-muted me-1"></i>
                                            <%= o[1] %>
                                        </td>
                                        <td class="text-muted">
                                            <%= o[2] %>
                                        </td>
                                        <td class="text-end text-danger fw-bold">
                                            <%= String.format("%,.0f", Double.parseDouble(o[3])) %> đ
                                        </td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill px-3 py-2 <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td class="text-muted" style="font-size: 13px;"><i
                                                class="fas fa-clock me-1"></i>
                                            <%= o[5] != null && o[5].length() >= 19 ? o[5].substring(0, 19) : o[5] %>
                                        </td>
                                        <td class="text-center">
                                            <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                                <form action="admin-orders" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="restore">
                                                    <input type="hidden" name="orderId" value="<%= o[0] %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-success shadow-sm">
                                                        <i class="fas fa-undo"></i> Khôi phục
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <form action="admin-orders" method="POST" style="display:inline;"
                                                    onsubmit="return confirm('Bạn có chắc chắn muốn đưa đơn hàng này vào rác?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="orderId" value="<%= o[0] %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </button>
                                                </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } %>
                            </tbody>
                        </table>
                    </div>
                    </form>

                    <% if(orders==null || orders.isEmpty()) { %>
                        <div class="text-center py-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3"></i>
                            <h5>Chưa có đơn hàng nào</h5>
                            <p>Đơn hàng sẽ hiển thị ở đây khi khách hàng đặt mua.</p>
                        </div>
                        <% } %>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // --- Bulk Actions Script ---
                document.addEventListener("DOMContentLoaded", function () {
                    const selectAllCheckbox = document.getElementById('selectAll');
                    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
                    const bulkActionBar = document.getElementById('bulk-action-bar');
                    const selectedCountSpan = document.getElementById('selected-count');

                    function updateBulkActionVisibility() {
                        const checkedCount = document.querySelectorAll('.row-checkbox:checked').length;
                        selectedCountSpan.textContent = checkedCount;
                        if (checkedCount > 0) {
                            bulkActionBar.style.display = 'block';
                        } else {
                            bulkActionBar.style.display = 'none';
                            selectAllCheckbox.checked = false;
                            
                            const sttSelect = document.getElementById('bulkStatusSelect');
                            if(sttSelect) sttSelect.value = ''; // Reset select tag
                        }
                    }

                    if (selectAllCheckbox) {
                        selectAllCheckbox.addEventListener('change', function () {
                            rowCheckboxes.forEach(cb => {
                                cb.checked = selectAllCheckbox.checked;
                            });
                            updateBulkActionVisibility();
                        });
                    }

                    rowCheckboxes.forEach(cb => {
                        cb.addEventListener('change', function () {
                            const allChecked = document.querySelectorAll('.row-checkbox:checked').length === rowCheckboxes.length;
                            selectAllCheckbox.checked = allChecked;
                            updateBulkActionVisibility();
                        });
                    });
                });

                function submitBulkAction(actionName) {
                    const count = document.querySelectorAll('.row-checkbox:checked').length;
                    if (count === 0) return;
                    
                    let msg = "";
                    if(actionName === 'bulk_delete') msg = "Xóa (chuyển vào thùng rác) " + count + " đơn hàng đã chọn?";
                    else if(actionName === 'bulk_restore') msg = "Khôi phục " + count + " đơn hàng đã chọn?";
                    else if(actionName === 'bulk_delete_permanent') msg = "⚠️ XÓA VĨNH VIỄN " + count + " đơn hàng sẽ xóa triệt để cả dữ liệu Cột mốc Hành trình (Order Activity). Bạn đồng ý?";

                    if (confirm(msg)) {
                        document.getElementById('bulk-action-input').value = actionName;
                        document.getElementById('bulkForm').submit();
                    }
                }
                
                function submitBulkStatus() {
                    const val = document.getElementById('bulkStatusSelect').value;
                    if (!val) return;
                    
                    const count = document.querySelectorAll('.row-checkbox:checked').length;
                    if (confirm("Chuyển trạng thái của " + count + " đơn hàng thành: [" + val + "] ?")) {
                        document.getElementById('bulk-action-input').value = 'bulk_update_status';
                        document.getElementById('bulk-status-input').value = val;
                        document.getElementById('bulkForm').submit();
                    } else {
                        document.getElementById('bulkStatusSelect').value = '';
                    }
                }
            </script>
        </body>
        </html>
```