<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>C&#7843;nh B&#225;o B&#7845;t Th&#432;&#7901;ng - Admin Panel</title>
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

        body { background: var(--bg-color); font-family: 'Inter', sans-serif; overflow-x: hidden; }
        .sidebar { height: 100vh; background: #ffffff; width: var(--sidebar-width); position: fixed; box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05); z-index: 100; overflow-y: auto; }
        .sidebar-logo { display: flex; align-items: center; justify-content: center; padding: 20px 0; border-bottom: 1px solid #eee; }
        .sidebar-logo h4 { color: var(--shopee-primary); font-weight: 700; margin: 0; font-size: 22px; }
        .nav-item { padding: 5px 15px; }
        .sidebar a { color: #555; text-decoration: none; padding: 12px 20px; display: flex; align-items: center; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; margin-bottom: 5px; }
        .sidebar a i { width: 30px; font-size: 18px; }
        .sidebar a:hover { background-color: #fef0ee; color: var(--shopee-primary); }
        .sidebar a.active { background-color: var(--shopee-primary); color: #ffffff; box-shadow: 0 4px 6px rgba(238, 77, 45, 0.2); }
        .main-content { margin-left: var(--sidebar-width); padding: 30px 40px; }
        .top-header { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: var(--card-shadow); margin-bottom: 30px; }
        .content-box { background: #fff; padding: 25px; border-radius: 12px; box-shadow: var(--card-shadow); margin-bottom: 30px; }

        /* Summary Cards */
        .summary-cards { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .summary-card { padding: 20px; border-radius: 12px; color: #fff; position: relative; overflow: hidden; }
        .summary-card .count { font-size: 36px; font-weight: 700; }
        .summary-card .label { font-size: 13px; opacity: 0.9; margin-top: 4px; }
        .summary-card .bg-icon { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); font-size: 50px; opacity: 0.15; }
        .card-total { background: linear-gradient(135deg, #667eea, #764ba2); }
        .card-high { background: linear-gradient(135deg, #e53935, #d32f2f); }
        .card-medium { background: linear-gradient(135deg, #ff9800, #f57c00); }
        .card-low { background: linear-gradient(135deg, #1e88e5, #1565c0); }

        /* Alert Items */
        .alert-item {
            display: flex; align-items: flex-start; gap: 16px; padding: 18px;
            border-radius: 10px; margin-bottom: 12px; border-left: 5px solid;
            background: #fafafa; transition: all 0.2s;
        }
        .alert-item:hover { background: #fff; box-shadow: 0 3px 10px rgba(0,0,0,0.08); transform: translateX(4px); }
        .alert-item.sev-HIGH { border-left-color: #e53935; }
        .alert-item.sev-MEDIUM { border-left-color: #ff9800; }
        .alert-item.sev-LOW { border-left-color: #1e88e5; }
        .alert-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff; flex-shrink: 0; }
        .alert-severity { font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .sev-badge-HIGH { background: #ffebee; color: #c62828; }
        .sev-badge-MEDIUM { background: #fff3e0; color: #e65100; }
        .sev-badge-LOW { background: #e3f2fd; color: #1565c0; }

        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 64px; color: #4caf50; margin-bottom: 16px; }
        .empty-state h5 { color: #333; font-weight: 600; }
        .empty-state p { color: #999; }

        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.6; } }
        .pulse { animation: pulse 2s ease-in-out infinite; }
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
                <h4 class="m-0 fw-bold text-dark">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>C&#7843;nh B&#225;o B&#7845;t Th&#432;&#7901;ng
                </h4>
                <small class="text-muted">Ph&#225;t hi&#7879;n t&#7921; &#273;&#7897;ng c&#225;c ho&#7841;t &#273;&#7897;ng b&#7845;t th&#432;&#7901;ng trong h&#7879; th&#7889;ng</small>
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
                        <span class="text-muted" style="font-size: 12px;">Qu&#7843;n tr&#7883; vi&#234;n</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card card-total">
                <div class="count">${totalAlerts}</div>
                <div class="label">T&#7893;ng C&#7843;nh B&#225;o</div>
                <i class="fas fa-bell bg-icon"></i>
            </div>
            <div class="summary-card card-high">
                <div class="count">${highCount}</div>
                <div class="label">Nghi&#234;m Tr&#7885;ng</div>
                <i class="fas fa-exclamation-circle bg-icon"></i>
            </div>
            <div class="summary-card card-medium">
                <div class="count">${mediumCount}</div>
                <div class="label">C&#7843;nh B&#225;o</div>
                <i class="fas fa-exclamation-triangle bg-icon"></i>
            </div>
            <div class="summary-card card-low">
                <div class="count">${lowCount}</div>
                <div class="label">Th&#244;ng Tin</div>
                <i class="fas fa-info-circle bg-icon"></i>
            </div>
        </div>

        <!-- Alert List -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold m-0 text-dark">
                    <i class="fas fa-list-ul me-2 text-muted"></i>Chi Ti&#7871;t C&#7843;nh B&#225;o
                </h5>
                <a href="admin-alerts" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-sync-alt me-1"></i> L&#224;m M&#7899;i
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty alerts}">
                    <c:forEach var="alert" items="${alerts}">
                        <div class="alert-item sev-${alert.severity}">
                            <div class="alert-icon" style="background: ${alert.color};">
                                <i class="fas ${alert.icon}"></i>
                            </div>
                            <div style="flex: 1;">
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <span class="alert-severity sev-badge-${alert.severity}">
                                        <c:choose>
                                            <c:when test="${alert.severity == 'HIGH'}">Nghi&#234;m Tr&#7885;ng</c:when>
                                            <c:when test="${alert.severity == 'MEDIUM'}">C&#7843;nh B&#225;o</c:when>
                                            <c:otherwise>Th&#244;ng Tin</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="text-muted" style="font-size: 12px;">
                                        <i class="fas fa-clock me-1"></i>V&#7915;a ki&#7875;m tra
                                    </span>
                                </div>
                                <div style="font-size: 14px; color: #333; font-weight: 500;">
                                    ${alert.message}
                                </div>
                                <div class="mt-1" style="font-size: 12px; color: #999;">
                                    S&#7889; l&#432;&#7907;ng ph&#225;t hi&#7879;n: <strong>${alert.count}</strong>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-shield-alt"></i>
                        <h5>H&#7879; th&#7889;ng an to&#224;n!</h5>
                        <p>Kh&#244;ng ph&#225;t hi&#7879;n b&#7845;t th&#432;&#7901;ng n&#224;o t&#7841;i th&#7901;i &#273;i&#7875;m hi&#7879;n t&#7841;i.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
