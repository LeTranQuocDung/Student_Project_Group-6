<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - System Migration</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .log-box { background: #000; color: #0f0; font-family: monospace; height: 400px; overflow-y: scroll; padding: 15px; }
    </style>
</head>
<body class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white"><h3>🚀 HỆ THỐNG MIGRATION & CLEANING (10K Rows)</h3></div>
        <div class="card-body text-center">
            <p>Hệ thống tự động Import, Reset Database và sửa lỗi (SĐT, Email, Tên).</p>
            
            <form action="admin-import" method="post">
                <button type="submit" id="btn" class="btn btn-danger btn-lg" onclick="loading()">
                    🔥 BẮT ĐẦU IMPORT NGAY
                </button>
            </form>
            
            <div id="load" class="d-none mt-3">
                <div class="spinner-border text-primary"></div>
                <span class="ms-2 fw-bold">Đang xử lý dữ liệu lớn, vui lòng chờ...</span>
            </div>
        </div>
    </div>

    <div class="card mt-3">
        <div class="card-header fw-bold">📋 LOGS KẾT QUẢ</div>
        <div class="card-body p-0">
            <div class="log-box">
                <%= (request.getAttribute("logs") != null ? request.getAttribute("logs") : "Waiting for command... Ready to import CSV.") %>
            </div>
        </div>
    </div>

    <script>
        function loading() {
            // Ẩn nút bấm, hiện loading
            document.getElementById('btn').classList.add('d-none');
            document.getElementById('load').classList.remove('d-none');
        }
    </script>
</body>
</html>