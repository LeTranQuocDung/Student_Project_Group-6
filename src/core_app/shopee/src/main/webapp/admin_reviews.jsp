<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>X&#233;t Duy&#7879;t &#272;&#225;nh Gi&#225; - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            background: #ffffff;
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

        .nav-item { padding: 5px 15px; }

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

        .sidebar a i { width: 30px; font-size: 18px; }
        .sidebar a:hover { background-color: #fef0ee; color: var(--shopee-primary); }
        .sidebar a.active {
            background-color: var(--shopee-primary);
            color: #ffffff;
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
            margin-bottom: 30px;
        }

        /* Status Tabs */
        .status-tabs { display: flex; gap: 8px; margin-bottom: 24px; }
        .status-tabs a {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 20px; border-radius: 20px; text-decoration: none;
            font-size: 14px; font-weight: 500; background: #fff; color: #666;
            border: 1px solid #e0e0e0; transition: all 0.2s;
        }
        .status-tabs a:hover { border-color: var(--shopee-primary); color: var(--shopee-primary); }
        .status-tabs a.active { background: var(--shopee-primary); color: #fff; border-color: var(--shopee-primary); }
        .status-tabs .badge { font-size: 11px; padding: 3px 8px; border-radius: 10px; }

        /* Review Cards */
        .review-card {
            background: #f9f9f9; border-radius: 10px; padding: 18px;
            margin-bottom: 10px; display: flex; gap: 14px; align-items: flex-start;
            transition: all 0.2s; border-left: 4px solid transparent;
        }
        .review-card:hover { background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .review-card.status-PENDING { border-left-color: #ff9800; }
        .review-card.status-APPROVED { border-left-color: #4caf50; }
        .review-card.status-REJECTED { border-left-color: #f44336; }
        .review-rating { color: #ff9800; font-size: 14px; }
        .review-meta { font-size: 12px; color: #999; }
        .review-comment { font-size: 14px; color: #333; margin: 6px 0; line-height: 1.5; }
        .review-actions .btn { padding: 4px 12px; font-size: 12px; border-radius: 6px; }

        /* Bulk Bar */
        .bulk-bar {
            background: #fff3e0; border-radius: 10px; padding: 12px 20px;
            margin-bottom: 16px; display: none; align-items: center; gap: 12px;
            border: 1px solid #ffe0b2;
        }
        .bulk-bar.show { display: flex; }
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
                <h4 class="m-0 fw-bold text-dark"><i class="fas fa-star-half-alt text-warning me-2"></i>X&#233;t Duy&#7879;t &#272;&#225;nh Gi&#225;</h4>
                <small class="text-muted">Qu&#7843;n l&#253; v&#224; ki&#7875;m duy&#7879;t &#273;&#225;nh gi&#225; t&#7915; kh&#225;ch h&#224;ng</small>
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
                    <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true" width="45">
                    <div class="d-flex flex-column">
                        <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                        <span class="text-muted" style="font-size: 12px;">Quản trị viên</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Box -->
        <div class="content-box">
            <!-- Status Filter Tabs -->
            <div class="status-tabs">
                <a href="admin-reviews" class="${statusFilter == 'ALL' ? 'active' : ''}">
                    <i class="fas fa-list"></i> T&#7845;t C&#7843;
                    <span class="badge ${statusFilter == 'ALL' ? 'bg-light text-dark' : 'bg-secondary'}">${pendingCount + approvedCount + rejectedCount}</span>
                </a>
                <a href="admin-reviews?status=PENDING" class="${statusFilter == 'PENDING' ? 'active' : ''}">
                    <i class="fas fa-clock"></i> Ch&#7901; Duy&#7879;t
                    <span class="badge ${statusFilter == 'PENDING' ? 'bg-light text-dark' : 'bg-warning text-dark'}">${pendingCount}</span>
                </a>
                <a href="admin-reviews?status=APPROVED" class="${statusFilter == 'APPROVED' ? 'active' : ''}">
                    <i class="fas fa-check-circle"></i> &#272;&#227; Duy&#7879;t
                    <span class="badge ${statusFilter == 'APPROVED' ? 'bg-light text-dark' : 'bg-success'}">${approvedCount}</span>
                </a>
                <a href="admin-reviews?status=REJECTED" class="${statusFilter == 'REJECTED' ? 'active' : ''}">
                    <i class="fas fa-times-circle"></i> T&#7915; Ch&#7889;i
                    <span class="badge ${statusFilter == 'REJECTED' ? 'bg-light text-dark' : 'bg-danger'}">${rejectedCount}</span>
                </a>
            </div>

            <!-- Bulk Actions Bar -->
            <div class="bulk-bar" id="bulkBar">
                <input type="checkbox" id="selectAll" onchange="toggleSelectAll()" style="width:18px; height:18px;">
                <span id="selectedCount" class="fw-bold text-dark">0</span> <span class="text-muted">&#273;&#227; ch&#7885;n</span>
                <div class="ms-auto d-flex gap-2">
                    <button class="btn btn-sm btn-success" onclick="bulkAction('bulk_approve')"><i class="fas fa-check me-1"></i>Duy&#7879;t</button>
                    <button class="btn btn-sm btn-danger" onclick="bulkAction('bulk_reject')"><i class="fas fa-times me-1"></i>T&#7915; Ch&#7889;i</button>
                    <button class="btn btn-sm btn-outline-danger" onclick="bulkAction('bulk_delete')"><i class="fas fa-trash me-1"></i>X&#243;a</button>
                </div>
            </div>

            <!-- Review List -->
            <form id="reviewForm" method="post" action="admin-reviews">
                <input type="hidden" name="action" id="formAction">
                <input type="hidden" name="statusFilter" value="${statusFilter}">
                <input type="hidden" name="reviewId" id="formReviewId">

                <c:forEach var="review" items="${reviews}">
                    <div class="review-card status-${review.status}">
                        <input type="checkbox" name="selectedIds" value="${review.id}" class="review-checkbox mt-1"
                            onchange="updateBulkBar()" style="width:18px; height:18px; flex-shrink:0;">
                        <div style="flex:1; min-width:0;">
                            <div class="d-flex justify-content-between align-items-start mb-1">
                                <div>
                                    <span class="fw-bold" style="font-size:14px;">${review.username != null ? review.username : 'User #'.concat(review.userId)}</span>
                                    <span class="review-meta ms-2">
                                        &#273;&#225;nh gi&#225; <strong>${review.productName != null ? review.productName : 'SP #'.concat(review.productId)}</strong>
                                    </span>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${review.status == 'PENDING'}"><span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i>Ch&#7901; Duy&#7879;t</span></c:when>
                                        <c:when test="${review.status == 'APPROVED'}"><span class="badge bg-success"><i class="fas fa-check me-1"></i>&#272;&#227; Duy&#7879;t</span></c:when>
                                        <c:when test="${review.status == 'REJECTED'}"><span class="badge bg-danger"><i class="fas fa-times me-1"></i>T&#7915; Ch&#7889;i</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${review.status}</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="review-rating mb-1">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fa${i <= review.rating ? 's' : 'r'} fa-star"></i>
                                </c:forEach>
                                <span class="review-meta ms-2"><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                            <div class="review-comment">${review.comment}</div>
                            <div class="review-actions">
                                <c:if test="${review.status != 'APPROVED'}">
                                    <button type="button" class="btn btn-success" onclick="singleAction('approve', ${review.id})"><i class="fas fa-check me-1"></i>Duy&#7879;t</button>
                                </c:if>
                                <c:if test="${review.status != 'REJECTED'}">
                                    <button type="button" class="btn btn-outline-warning" onclick="singleAction('reject', ${review.id})"><i class="fas fa-times me-1"></i>T&#7915; Ch&#7889;i</button>
                                </c:if>
                                <button type="button" class="btn btn-outline-danger" onclick="if(confirm('X&#243;a v&#297;nh vi&#7877;n?')) singleAction('delete', ${review.id})"><i class="fas fa-trash"></i></button>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty reviews}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3"></i>
                        <h5>Kh&#244;ng c&#243; &#273;&#225;nh gi&#225; n&#224;o trong m&#7909;c n&#224;y.</h5>
                    </div>
                </c:if>
            </form>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item"><a class="page-link" href="admin-reviews?status=${statusFilter}&page=${currentPage - 1}">&laquo;</a></li>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="admin-reviews?status=${statusFilter}&page=${i}">${i}</a></li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item"><a class="page-link" href="admin-reviews?status=${statusFilter}&page=${currentPage + 1}">&raquo;</a></li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function singleAction(action, reviewId) {
            document.getElementById('formAction').value = action;
            document.getElementById('formReviewId').value = reviewId;
            document.getElementById('reviewForm').submit();
        }
        function bulkAction(action) {
            var checked = document.querySelectorAll('.review-checkbox:checked');
            if (checked.length === 0) { alert('Chua chon!'); return; }
            if (action === 'bulk_delete' && !confirm('Xoa ' + checked.length + ' danh gia?')) return;
            document.getElementById('formAction').value = action;
            document.getElementById('formReviewId').value = '';
            document.getElementById('reviewForm').submit();
        }
        function updateBulkBar() {
            var checked = document.querySelectorAll('.review-checkbox:checked');
            document.getElementById('selectedCount').textContent = checked.length;
            document.getElementById('bulkBar').classList.toggle('show', checked.length > 0);
        }
        function toggleSelectAll() {
            var all = document.getElementById('selectAll').checked;
            document.querySelectorAll('.review-checkbox').forEach(function(cb) { cb.checked = all; });
            updateBulkBar();
        }
    </script>
</body>
</html>
