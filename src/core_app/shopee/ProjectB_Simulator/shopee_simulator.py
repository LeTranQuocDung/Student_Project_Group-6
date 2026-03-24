"""
╔══════════════════════════════════════════════════════════════╗
║          SHOPEE WEB - USER LOAD SIMULATOR v2.0               ║
║  Giả lập người dùng: Đăng nhập → Duyệt SP → Giỏ hàng →     ║
║  Thanh toán. Đo lường khả năng chịu tải của hệ thống.       ║
╚══════════════════════════════════════════════════════════════╝

Cách dùng:
  python shopee_simulator.py                          # Mặc định: 10 users, 30 giây
  python shopee_simulator.py --users 50 --duration 60 # 50 users, 60 giây
  python shopee_simulator.py --users 100 --scenario cart_only  # Chỉ test giỏ hàng
  python shopee_simulator.py --help                   # Xem tất cả tùy chọn

Yêu cầu:
  pip install requests
"""

import argparse
import json
import random
import re
import statistics
import sys
import threading
import time
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from datetime import datetime
from typing import List, Optional

try:
    import requests
except ImportError:
    print("❌ Cần cài đặt thư viện requests:")
    print("   pip install requests")
    sys.exit(1)


# ══════════════════════════════════════════════════════════════
# DATA CLASSES
# ══════════════════════════════════════════════════════════════

@dataclass
class RequestMetric:
    """Lưu thông tin 1 request"""
    action: str             # Tên hành động (login, browse, add_to_cart, checkout)
    url: str                # URL đã gọi
    method: str             # GET/POST
    status_code: int        # HTTP status code
    response_time: float    # Thời gian phản hồi (giây)
    success: bool           # Thành công hay không
    error: str = ""         # Thông báo lỗi nếu có
    timestamp: float = 0    # Thời điểm request


@dataclass
class UserSimulationResult:
    """Kết quả mô phỏng của 1 user"""
    user_id: int
    metrics: List[RequestMetric] = field(default_factory=list)
    total_time: float = 0
    actions_completed: int = 0
    errors: int = 0


# ══════════════════════════════════════════════════════════════
# METRICS COLLECTOR (Thread-safe)
# ══════════════════════════════════════════════════════════════

class MetricsCollector:
    """Thu thập và tổng hợp metrics từ tất cả các user threads"""

    def __init__(self):
        self.lock = threading.Lock()
        self.metrics: List[RequestMetric] = []
        self.user_results: List[UserSimulationResult] = []
        self.start_time = time.time()
        self.active_users = 0
        self.peak_users = 0

    def add_metric(self, metric: RequestMetric):
        with self.lock:
            metric.timestamp = time.time()
            self.metrics.append(metric)

    def add_user_result(self, result: UserSimulationResult):
        with self.lock:
            self.user_results.append(result)

    def user_started(self):
        with self.lock:
            self.active_users += 1
            if self.active_users > self.peak_users:
                self.peak_users = self.active_users

    def user_finished(self):
        with self.lock:
            self.active_users -= 1

    def generate_report(self):
        """Tạo báo cáo tổng kết"""
        total_time = time.time() - self.start_time

        if not self.metrics:
            print("\n⚠️ Không có dữ liệu metrics nào được thu thập!")
            return

        # Phân loại theo action
        by_action = defaultdict(list)
        for m in self.metrics:
            by_action[m.action].append(m)

        # Tổng quan
        total_requests = len(self.metrics)
        successful = sum(1 for m in self.metrics if m.success)
        failed = total_requests - successful
        all_times = [m.response_time for m in self.metrics]

        print("\n")
        print("=" * 72)
        print("  📊 BÁO CÁO KẾT QUẢ KIỂM TRA TẢI (LOAD TEST REPORT)")
        print("=" * 72)

        # Thông tin chung
        print(f"\n⏱️  Thời gian chạy:     {total_time:.1f} giây")
        print(f"👥 Tổng users:         {len(self.user_results)}")
        print(f"🔝 Peak concurrent:    {self.peak_users}")
        print(f"📨 Tổng requests:      {total_requests}")
        print(f"✅ Thành công:         {successful} ({successful/total_requests*100:.1f}%)")
        print(f"❌ Thất bại:           {failed} ({failed/total_requests*100:.1f}%)")
        print(f"🚀 Throughput:         {total_requests/total_time:.1f} req/s")

        # Bảng chi tiết theo action
        print(f"\n{'─' * 72}")
        print(f"{'Hành động':<20} {'Số lượng':>8} {'Thành công':>10} {'Avg(ms)':>10} "
              f"{'P95(ms)':>10} {'P99(ms)':>10}")
        print(f"{'─' * 72}")

        for action in ['login', 'browse_home', 'browse_product', 'add_to_cart', 'checkout']:
            if action not in by_action:
                continue
            items = by_action[action]
            times = [m.response_time * 1000 for m in items]  # Convert to ms
            success_count = sum(1 for m in items if m.success)

            avg_time = statistics.mean(times) if times else 0
            p95 = sorted(times)[int(len(times) * 0.95)] if len(times) >= 2 else (times[0] if times else 0)
            p99 = sorted(times)[int(len(times) * 0.99)] if len(times) >= 2 else (times[0] if times else 0)

            action_label = {
                'login': '🔐 Đăng nhập',
                'browse_home': '🏠 Trang chủ',
                'browse_product': '📦 Xem SP',
                'add_to_cart': '🛒 Thêm giỏ',
                'checkout': '💳 Thanh toán',
            }.get(action, action)

            print(f"{action_label:<20} {len(items):>8} {success_count:>10} "
                  f"{avg_time:>10.0f} {p95:>10.0f} {p99:>10.0f}")

        print(f"{'─' * 72}")

        # Tổng hợp response time
        if all_times:
            print(f"\n📈 Response Time Tổng Hợp:")
            print(f"   Min:  {min(all_times)*1000:>8.0f} ms")
            print(f"   Avg:  {statistics.mean(all_times)*1000:>8.0f} ms")
            print(f"   Max:  {max(all_times)*1000:>8.0f} ms")
            if len(all_times) >= 2:
                sorted_times = sorted(all_times)
                print(f"   P50:  {sorted_times[int(len(sorted_times)*0.50)]*1000:>8.0f} ms")
                print(f"   P95:  {sorted_times[int(len(sorted_times)*0.95)]*1000:>8.0f} ms")
                print(f"   P99:  {sorted_times[int(len(sorted_times)*0.99)]*1000:>8.0f} ms")

        # Lỗi phổ biến
        errors = [m for m in self.metrics if not m.success]
        if errors:
            print(f"\n⚠️  TOP LỖI PHỔ BIẾN:")
            error_counts = defaultdict(int)
            for m in errors:
                key = f"[{m.action}] {m.error[:80]}" if m.error else f"[{m.action}] HTTP {m.status_code}"
                error_counts[key] += 1
            for err, count in sorted(error_counts.items(), key=lambda x: -x[1])[:5]:
                print(f"   {count:>4}x  {err}")

        # Timeline (request rate per second)
        if len(self.metrics) > 10:
            print(f"\n📊 Timeline (req/s theo thời gian):")
            min_ts = min(m.timestamp for m in self.metrics)
            buckets = defaultdict(int)
            for m in self.metrics:
                bucket = int(m.timestamp - min_ts)
                buckets[bucket] += 1
            
            max_bucket = max(buckets.keys()) if buckets else 0
            for sec in range(0, min(max_bucket + 1, 30)):  # Hiển thị tối đa 30 giây
                count = buckets.get(sec, 0)
                bar = "█" * min(count, 60)
                print(f"   {sec:>3}s │ {bar} ({count})")

        print(f"\n{'=' * 72}")
        print(f"  ✅ Hoàn tất kiểm tra lúc: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"{'=' * 72}\n")


# ══════════════════════════════════════════════════════════════
# USER SIMULATOR
# ══════════════════════════════════════════════════════════════

class UserSimulator:
    """Mô phỏng hành vi của 1 người dùng"""

    def __init__(self, user_id: int, base_url: str, collector: MetricsCollector, 
                 scenario: str = "full", think_time: float = 0.5):
        self.user_id = user_id
        self.base_url = base_url.rstrip("/")
        self.collector = collector
        self.scenario = scenario
        self.think_time = think_time
        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": f"ShopeeSimulator/2.0 (User-{user_id})",
            "Accept": "text/html,application/json",
            "Accept-Language": "vi-VN,vi;q=0.9",
        })
        self.logged_in = False
        self.product_ids = []

    def _request(self, action: str, method: str, path: str, **kwargs) -> RequestMetric:
        """Thực hiện HTTP request và ghi metric"""
        url = f"{self.base_url}/{path.lstrip('/')}"
        start = time.time()
        metric = RequestMetric(
            action=action, url=url, method=method,
            status_code=0, response_time=0, success=False
        )

        try:
            kwargs.setdefault("timeout", 30)
            kwargs.setdefault("allow_redirects", True)
            
            if method.upper() == "GET":
                resp = self.session.get(url, **kwargs)
            else:
                resp = self.session.post(url, **kwargs)

            metric.status_code = resp.status_code
            metric.response_time = time.time() - start
            metric.success = (200 <= resp.status_code < 400)

            if not metric.success:
                metric.error = f"HTTP {resp.status_code}"
                if resp.status_code >= 500:
                    metric.error += f" - Server Error"
                    
            return metric

        except requests.exceptions.Timeout:
            metric.response_time = time.time() - start
            metric.error = "Timeout (>30s)"
            return metric
        except requests.exceptions.ConnectionError:
            metric.response_time = time.time() - start
            metric.error = "Connection refused"
            return metric
        except Exception as e:
            metric.response_time = time.time() - start
            metric.error = str(e)[:100]
            return metric
        finally:
            self.collector.add_metric(metric)

    def _think(self):
        """Giả lập thời gian suy nghĩ của user (random)"""
        if self.think_time > 0:
            time.sleep(random.uniform(self.think_time * 0.5, self.think_time * 1.5))

    # ─── Actions ───

    def do_login(self, email: str = None, password: str = None):
        """Đăng nhập - POST /login"""
        if email is None:
            # Dùng tài khoản user từ DB - lần lượt dùng user1@gmail.com, user2@gmail.com, ...
            email = f"user{self.user_id}@gmail.com"
        if password is None:
            password = "123456"

        metric = self._request("login", "POST", "/login", data={
            "user": email,
            "pass": password,
        })

        if metric.success:
            self.logged_in = True

        return metric

    def do_browse_home(self):
        """Xem trang chủ - GET /home"""
        metric = self._request("browse_home", "GET", "/home")
        
        # Thử extract product IDs từ HTML response
        if metric.success:
            try:
                resp = self.session.get(f"{self.base_url}/home", timeout=10)
                # Tìm các productId trong HTML
                ids = re.findall(r'productId["\s=:]+(\d+)', resp.text)
                if not ids:
                    ids = re.findall(r'san-pham-i\.\d+\.(\d+)', resp.text)
                if not ids:
                    ids = re.findall(r'product[_-]?id["\s=:]+["\']?(\d+)', resp.text, re.IGNORECASE)
                if ids:
                    self.product_ids = list(set(ids))[:20]  # Lấy tối đa 20 product IDs
            except Exception:
                pass

        return metric

    def do_browse_product(self, product_id: int = None):
        """Xem chi tiết sản phẩm - GET /product?id=..."""
        if product_id is None:
            if self.product_ids:
                product_id = random.choice(self.product_ids)
            else:
                product_id = random.randint(1, 100)

        # Thử URL format phổ biến
        metric = self._request("browse_product", "GET", f"/product?id={product_id}")
        return metric

    def do_add_to_cart(self, product_id: int = None, qty: int = None):
        """Thêm vào giỏ hàng - POST /add_to_cart"""
        if product_id is None:
            if self.product_ids:
                product_id = random.choice(self.product_ids)
            else:
                product_id = random.randint(1, 100)
        if qty is None:
            qty = random.randint(1, 3)

        metric = self._request("add_to_cart", "POST", "/add_to_cart", 
                               data={"productId": product_id, "qty": qty},
                               headers={"X-Requested-With": "XMLHttpRequest"})
        return metric

    def do_checkout(self):
        """Thanh toán - POST /checkout"""
        metric = self._request("checkout", "POST", "/checkout")
        return metric

    def do_view_cart(self):
        """Xem giỏ hàng - GET /cart"""
        return self._request("browse_product", "GET", "/cart")

    # ─── Scenarios ───

    def run_full_scenario(self):
        """Kịch bản đầy đủ: Login → Browse → Add to Cart → Checkout"""
        result = UserSimulationResult(user_id=self.user_id)
        start = time.time()

        try:
            # 1. Đăng nhập
            m = self.do_login()
            result.metrics.append(m)
            if m.success:
                result.actions_completed += 1
            else:
                result.errors += 1
            self._think()

            # 2. Duyệt trang chủ
            m = self.do_browse_home()
            result.metrics.append(m)
            result.actions_completed += 1
            self._think()

            # 3. Xem 2-3 sản phẩm
            for _ in range(random.randint(2, 3)):
                m = self.do_browse_product()
                result.metrics.append(m)
                result.actions_completed += 1
                self._think()

            # 4. Thêm 1-2 sản phẩm vào giỏ
            for _ in range(random.randint(1, 2)):
                m = self.do_add_to_cart()
                result.metrics.append(m)
                if m.success:
                    result.actions_completed += 1
                else:
                    result.errors += 1
                self._think()

            # 5. Xem giỏ hàng
            m = self.do_view_cart()
            result.metrics.append(m)
            result.actions_completed += 1
            self._think()

            # 6. Thanh toán
            m = self.do_checkout()
            result.metrics.append(m)
            if m.success:
                result.actions_completed += 1
            else:
                result.errors += 1

        except Exception as e:
            result.errors += 1

        result.total_time = time.time() - start
        return result

    def run_browse_only(self):
        """Kịch bản chỉ duyệt: Trang chủ → Xem sản phẩm (không mua)"""
        result = UserSimulationResult(user_id=self.user_id)
        start = time.time()

        try:
            m = self.do_browse_home()
            result.metrics.append(m)
            result.actions_completed += 1
            self._think()

            for _ in range(random.randint(3, 6)):
                m = self.do_browse_product()
                result.metrics.append(m)
                result.actions_completed += 1
                self._think()

        except Exception as e:
            result.errors += 1

        result.total_time = time.time() - start
        return result

    def run_cart_only(self):
        """Kịch bản giỏ hàng: Login → Thêm nhiều SP vào giỏ (stress cart)"""
        result = UserSimulationResult(user_id=self.user_id)
        start = time.time()

        try:
            m = self.do_login()
            result.metrics.append(m)
            result.actions_completed += 1
            self._think()

            m = self.do_browse_home()
            result.metrics.append(m)
            result.actions_completed += 1

            # Thêm 5-10 sản phẩm vào giỏ
            for _ in range(random.randint(5, 10)):
                m = self.do_add_to_cart()
                result.metrics.append(m)
                if m.success:
                    result.actions_completed += 1
                else:
                    result.errors += 1
                self._think()

        except Exception as e:
            result.errors += 1

        result.total_time = time.time() - start
        return result

    def run_checkout_stress(self):
        """Kịch bản stress checkout: Login → Cart → Checkout liên tục"""
        result = UserSimulationResult(user_id=self.user_id)
        start = time.time()

        try:
            m = self.do_login()
            result.metrics.append(m)
            result.actions_completed += 1

            m = self.do_browse_home()
            result.metrics.append(m)
            result.actions_completed += 1

            # Mua 3 lần liên tiếp
            for _ in range(3):
                m = self.do_add_to_cart()
                result.metrics.append(m)
                result.actions_completed += 1

                m = self.do_checkout()
                result.metrics.append(m)
                if m.success:
                    result.actions_completed += 1
                else:
                    result.errors += 1
                self._think()

        except Exception as e:
            result.errors += 1

        result.total_time = time.time() - start
        return result


# ══════════════════════════════════════════════════════════════
# MAIN ORCHESTRATOR
# ══════════════════════════════════════════════════════════════

def run_user(user_id: int, base_url: str, collector: MetricsCollector, 
             scenario: str, think_time: float) -> UserSimulationResult:
    """Chạy 1 user simulation trong 1 thread"""
    collector.user_started()
    try:
        sim = UserSimulator(user_id, base_url, collector, scenario, think_time)
        
        if scenario == "browse":
            result = sim.run_browse_only()
        elif scenario == "cart_only":
            result = sim.run_cart_only()
        elif scenario == "checkout_stress":
            result = sim.run_checkout_stress()
        else:
            result = sim.run_full_scenario()

        collector.add_user_result(result)
        return result
    finally:
        collector.user_finished()


def check_server(base_url: str) -> bool:
    """Kiểm tra server có đang chạy không"""
    try:
        resp = requests.get(f"{base_url}/home", timeout=5)
        return resp.status_code < 500
    except Exception:
        return False


def main():
    parser = argparse.ArgumentParser(
        description="🛒 Shopee Web - User Load Simulator",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Ví dụ:
  python shopee_simulator.py                              # Default: 10 users
  python shopee_simulator.py --users 50 --duration 60     # 50 users, 60s
  python shopee_simulator.py --scenario cart_only          # Chỉ test giỏ hàng
  python shopee_simulator.py --scenario checkout_stress    # Stress test checkout
  python shopee_simulator.py --users 100 --think-time 0   # 100 users, không delay

Scenarios:
  full              Đăng nhập → Duyệt → Giỏ hàng → Thanh toán (mặc định)
  browse            Chỉ duyệt trang chủ và sản phẩm (không mua)
  cart_only          Đăng nhập → Thêm nhiều SP vào giỏ
  checkout_stress    Đăng nhập → Mua liên tục 3 lần
        """
    )
    parser.add_argument("--users", "-u", type=int, default=10,
                        help="Số lượng user đồng thời (default: 10)")
    parser.add_argument("--duration", "-d", type=int, default=0,
                        help="Thời gian chạy tối đa (giây, 0=chạy hết users)")
    parser.add_argument("--base-url", "-b", type=str, default="http://localhost:8080",
                        help="URL gốc của server (default: http://localhost:8080)")
    parser.add_argument("--scenario", "-s", type=str, default="full",
                        choices=["full", "browse", "cart_only", "checkout_stress"],
                        help="Kịch bản mô phỏng (default: full)")
    parser.add_argument("--think-time", "-t", type=float, default=0.3,
                        help="Thời gian suy nghĩ giữa các thao tác, giây (default: 0.3)")
    parser.add_argument("--ramp-up", "-r", type=float, default=0,
                        help="Thời gian ramp-up: tạo users từ từ trong N giây (default: 0)")
    parser.add_argument("--max-workers", "-w", type=int, default=0,
                        help="Số thread tối đa (default: bằng số users)")

    args = parser.parse_args()

    # Banner
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║          🛒 SHOPEE WEB - LOAD TEST SIMULATOR               ║")
    print("╚══════════════════════════════════════════════════════════════╝")
    print(f"  Server:     {args.base_url}")
    print(f"  Users:      {args.users}")
    print(f"  Scenario:   {args.scenario}")
    print(f"  Think time: {args.think_time}s")
    if args.ramp_up > 0:
        print(f"  Ramp-up:    {args.ramp_up}s")
    print()

    # Kiểm tra server
    print("🔍 Kiểm tra kết nối server... ", end="", flush=True)
    if not check_server(args.base_url):
        print("❌ THẤT BẠI!")
        print(f"   Không thể kết nối tới {args.base_url}")
        print(f"   Hãy chắc chắn server đang chạy (RUNB2.bat)")
        sys.exit(1)
    print("✅ OK")

    # Khởi tạo collector
    collector = MetricsCollector()
    max_workers = args.max_workers if args.max_workers > 0 else args.users

    # Chạy simulation
    print(f"\n🚀 Bắt đầu mô phỏng {args.users} người dùng đồng thời...")
    print(f"   Kịch bản: {args.scenario}")
    print()

    # Progress tracking
    completed = [0]
    lock = threading.Lock()

    def run_with_progress(user_id):
        if args.ramp_up > 0:
            # Ramp-up: users bắt đầu dần dần
            delay = (user_id / args.users) * args.ramp_up
            time.sleep(delay)

        result = run_user(user_id, args.base_url, collector, args.scenario, args.think_time)
        
        with lock:
            completed[0] += 1
            pct = completed[0] / args.users * 100
            status = "✅" if result.errors == 0 else "⚠️"
            print(f"   {status} User {user_id:>4} hoàn tất ({result.actions_completed} actions, "
                  f"{result.errors} errors, {result.total_time:.1f}s) [{pct:.0f}%]")

        return result

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = []
        for i in range(1, args.users + 1):
            futures.append(executor.submit(run_with_progress, i))

        # Chờ tất cả hoàn thành (hoặc timeout)
        for future in as_completed(futures):
            try:
                future.result()
            except Exception as e:
                print(f"   ❌ Lỗi thread: {e}")

    # In báo cáo
    collector.generate_report()


if __name__ == "__main__":
    main()
