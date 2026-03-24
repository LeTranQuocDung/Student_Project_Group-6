"""
╔══════════════════════════════════════════════════════════════╗
║     SHOPEE WEB - LOAD SIMULATOR GUI v2.0                     ║
║     Giao diện Desktop cho công cụ kiểm tra tải               ║
╚══════════════════════════════════════════════════════════════╝

Cách chạy:
  python simulator_gui.py

Yêu cầu:
  pip install requests
"""

import os
import sys
import threading
import time
import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
from collections import defaultdict
from datetime import datetime
import statistics
import random

# System monitoring
try:
    import psutil
    HAS_PSUTIL = True
except ImportError:
    HAS_PSUTIL = False

# Import simulator core
try:
    from shopee_simulator import (
        MetricsCollector, UserSimulator, UserSimulationResult,
        run_user, check_server
    )
except ImportError:
    # Fallback nếu chạy từ thư mục khác
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from shopee_simulator import (
        MetricsCollector, UserSimulator, UserSimulationResult,
        run_user, check_server
    )


# ══════════════════════════════════════════════════════════════
# THEME & COLORS
# ══════════════════════════════════════════════════════════════

class Theme:
    """Shopee-inspired dark theme"""
    BG_DARK = "#1a1a2e"
    BG_CARD = "#16213e"
    BG_INPUT = "#0f3460"
    BG_HOVER = "#1f4068"

    ACCENT = "#e94560"
    ACCENT_LIGHT = "#ff6b6b"
    ACCENT_GREEN = "#00d2d3"
    ACCENT_YELLOW = "#feca57"
    ACCENT_BLUE = "#54a0ff"
    ACCENT_ORANGE = "#ff9f43"

    TEXT_PRIMARY = "#ffffff"
    TEXT_SECONDARY = "#a4b0be"
    TEXT_DIM = "#636e72"

    SUCCESS = "#00b894"
    ERROR = "#d63031"
    WARNING = "#fdcb6e"

    BORDER = "#2d3436"

    FONT_FAMILY = "Segoe UI"
    FONT_TITLE = ("Segoe UI", 18, "bold")
    FONT_SUBTITLE = ("Segoe UI", 12, "bold")
    FONT_BODY = ("Segoe UI", 10)
    FONT_SMALL = ("Segoe UI", 9)
    FONT_MONO = ("Consolas", 9)
    FONT_METRIC_BIG = ("Segoe UI", 24, "bold")
    FONT_METRIC_LABEL = ("Segoe UI", 9)


# ══════════════════════════════════════════════════════════════
# METRIC CARD WIDGET
# ══════════════════════════════════════════════════════════════

class MetricCard(tk.Frame):
    """Widget hiển thị 1 metric lớn"""

    def __init__(self, parent, icon, label, value="0", color=Theme.ACCENT_BLUE, **kwargs):
        super().__init__(parent, bg=Theme.BG_CARD, highlightbackground=Theme.BORDER,
                         highlightthickness=1, **kwargs)

        self.configure(padx=15, pady=10)

        # Icon + Label
        header = tk.Frame(self, bg=Theme.BG_CARD)
        header.pack(fill="x")
        tk.Label(header, text=icon, font=("Segoe UI", 14), bg=Theme.BG_CARD,
                 fg=color).pack(side="left")
        tk.Label(header, text=f"  {label}", font=Theme.FONT_SMALL, bg=Theme.BG_CARD,
                 fg=Theme.TEXT_SECONDARY).pack(side="left")

        # Value
        self.value_label = tk.Label(self, text=value, font=Theme.FONT_METRIC_BIG,
                                    bg=Theme.BG_CARD, fg=color)
        self.value_label.pack(anchor="w", pady=(2, 0))

        # Sub value
        self.sub_label = tk.Label(self, text="", font=Theme.FONT_SMALL,
                                  bg=Theme.BG_CARD, fg=Theme.TEXT_DIM)
        self.sub_label.pack(anchor="w")

    def update_value(self, value, sub=""):
        self.value_label.config(text=str(value))
        if sub:
            self.sub_label.config(text=sub)


# ══════════════════════════════════════════════════════════════
# PROGRESS BAR (custom styled)
# ══════════════════════════════════════════════════════════════

class GradientProgressBar(tk.Canvas):
    """Custom gradient progress bar"""

    def __init__(self, parent, width=400, height=20, **kwargs):
        super().__init__(parent, width=width, height=height,
                         bg=Theme.BG_DARK, highlightthickness=0, **kwargs)
        self._progress = 0
        self._width = width
        self._height = height
        self._draw()

    def _draw(self):
        self.delete("all")
        # Background track
        self.create_rectangle(0, 0, self._width, self._height,
                              fill=Theme.BG_INPUT, outline="")
        # Progress fill
        if self._progress > 0:
            fill_width = int(self._width * self._progress / 100)
            self.create_rectangle(0, 0, fill_width, self._height,
                                  fill=Theme.ACCENT, outline="")
        # Percentage text
        self.create_text(self._width // 2, self._height // 2,
                         text=f"{self._progress:.0f}%",
                         fill=Theme.TEXT_PRIMARY, font=Theme.FONT_SMALL)

    def set_progress(self, value):
        self._progress = min(max(value, 0), 100)
        self._draw()


# ══════════════════════════════════════════════════════════════
# MINI BAR CHART
# ══════════════════════════════════════════════════════════════

class MiniBarChart(tk.Canvas):
    """Canvas nhỏ vẽ bar chart cho response times"""

    def __init__(self, parent, width=300, height=120, **kwargs):
        super().__init__(parent, width=width, height=height,
                         bg=Theme.BG_CARD, highlightthickness=0, **kwargs)
        self._width = width
        self._height = height

    def draw_bars(self, data_dict):
        """data_dict = {'label': (value, color)}"""
        self.delete("all")
        if not data_dict:
            self.create_text(self._width // 2, self._height // 2,
                             text="Chưa có dữ liệu", fill=Theme.TEXT_DIM,
                             font=Theme.FONT_SMALL)
            return

        labels = list(data_dict.keys())
        values = [v[0] for v in data_dict.values()]
        colors = [v[1] for v in data_dict.values()]

        max_val = max(values) if values else 1
        n = len(labels)
        if n == 0:
            return

        bar_width = max(20, (self._width - 40) // n - 10)
        spacing = (self._width - bar_width * n) // (n + 1)

        for i, (label, val, color) in enumerate(zip(labels, values, colors)):
            x = spacing + i * (bar_width + spacing)
            bar_height = max(3, int((val / max_val) * (self._height - 40)))
            y_top = self._height - 20 - bar_height

            # Bar
            self.create_rectangle(x, y_top, x + bar_width, self._height - 20,
                                  fill=color, outline="")
            # Value label
            self.create_text(x + bar_width // 2, y_top - 8,
                             text=f"{val:.0f}", fill=Theme.TEXT_SECONDARY,
                             font=("Consolas", 7))
            # Label
            self.create_text(x + bar_width // 2, self._height - 8,
                             text=label, fill=Theme.TEXT_DIM,
                             font=("Segoe UI", 7))


# ══════════════════════════════════════════════════════════════
# MAIN APPLICATION
# ══════════════════════════════════════════════════════════════

class SimulatorApp:

    def __init__(self, root):
        self.root = root
        self.root.title("🛒 Shopee Load Simulator")
        self.root.geometry("1150x880")
        self.root.configure(bg=Theme.BG_DARK)
        self.root.minsize(950, 700)

        # State
        self.is_running = False
        self.collector = None
        self.test_thread = None
        self.update_timer = None

        # Icon (windows)
        try:
            self.root.iconbitmap(default="")
        except Exception:
            pass

        self._build_ui()

    def _build_ui(self):
        """Xây dựng toàn bộ giao diện"""

        # ── HEADER ──
        header_frame = tk.Frame(self.root, bg=Theme.BG_CARD, pady=6)
        header_frame.pack(fill="x")

        title_container = tk.Frame(header_frame, bg=Theme.BG_CARD)
        title_container.pack()

        tk.Label(title_container, text="🛒 SHOPEE LOAD SIMULATOR",
                 font=Theme.FONT_TITLE, bg=Theme.BG_CARD,
                 fg=Theme.TEXT_PRIMARY).pack(side="left")
        tk.Label(title_container, text="  v2.0",
                 font=Theme.FONT_SMALL, bg=Theme.BG_CARD,
                 fg=Theme.TEXT_DIM).pack(side="left", pady=(6, 0))

        # ── MAIN CONTENT ──
        main = tk.Frame(self.root, bg=Theme.BG_DARK)
        main.pack(fill="both", expand=True, padx=15, pady=10)

        # Left panel (Config + Controls) - scrollable
        left_outer = tk.Frame(main, bg=Theme.BG_DARK, width=320)
        left_outer.pack(side="left", fill="y", padx=(0, 10))
        left_outer.pack_propagate(False)

        # Scrollable canvas for left panel
        left_canvas = tk.Canvas(left_outer, bg=Theme.BG_DARK, highlightthickness=0, width=300)
        left_scrollbar = ttk.Scrollbar(left_outer, orient="vertical", command=left_canvas.yview)
        left = tk.Frame(left_canvas, bg=Theme.BG_DARK)

        left.bind("<Configure>", lambda e: left_canvas.configure(scrollregion=left_canvas.bbox("all")))
        left_canvas.create_window((0, 0), window=left, anchor="nw", width=300)
        left_canvas.configure(yscrollcommand=left_scrollbar.set)

        left_canvas.pack(side="left", fill="both", expand=True)
        left_scrollbar.pack(side="right", fill="y")

        # Mouse wheel scroll
        def _on_mousewheel(event):
            left_canvas.yview_scroll(int(-1 * (event.delta / 120)), "units")
        left_canvas.bind_all("<MouseWheel>", _on_mousewheel)

        # Right panel (Results)
        right = tk.Frame(main, bg=Theme.BG_DARK)
        right.pack(side="right", fill="both", expand=True)

        self._build_config_panel(left)
        self._build_controls(left)
        self._build_results_panel(right)

    # ── CONFIG PANEL ──

    def _build_config_panel(self, parent):
        config = tk.LabelFrame(parent, text=" ⚙️ CẤU HÌNH TEST ", font=Theme.FONT_SUBTITLE,
                                bg=Theme.BG_CARD, fg=Theme.ACCENT_BLUE,
                                labelanchor="n", padx=10, pady=5)
        config.pack(fill="x", pady=(0, 5))

        # Server URL
        self._add_label(config, "🔗 Server URL")
        self.url_var = tk.StringVar(value="http://localhost:8080")
        self._add_entry(config, self.url_var)

        # Users and Concurrent
        row1 = tk.Frame(config, bg=Theme.BG_CARD)
        row1.pack(fill="x", pady=(0, 5))
        
        frame_users = tk.Frame(row1, bg=Theme.BG_CARD)
        frame_users.pack(side="left", fill="x", expand=True, padx=(0, 5))
        self._add_label(frame_users, "👥 Người dùng")
        self.users_var = tk.StringVar(value="10")
        tk.Entry(frame_users, textvariable=self.users_var, font=("Segoe UI", 12, "bold"),
                 bg=Theme.BG_INPUT, fg=Theme.ACCENT_YELLOW, insertbackground=Theme.TEXT_PRIMARY,
                 relief="flat", selectbackground=Theme.ACCENT, justify="center").pack(fill="x", ipady=3)

        frame_conc = tk.Frame(row1, bg=Theme.BG_CARD)
        frame_conc.pack(side="left", fill="x", expand=True)
        self._add_label(frame_conc, "⚡ Luồng thật")
        self.concurrent_var = tk.StringVar(value="100")
        tk.Entry(frame_conc, textvariable=self.concurrent_var, font=("Segoe UI", 12, "bold"),
                 bg=Theme.BG_INPUT, fg=Theme.ACCENT_GREEN, insertbackground=Theme.TEXT_PRIMARY,
                 relief="flat", selectbackground=Theme.ACCENT, justify="center").pack(fill="x", ipady=3)

        # Scenario Combobox
        self._add_label(config, "📋 Kịch bản mô phỏng")
        self.scenario_var = tk.StringVar(value="full")
        self.scenario_map = {
            "🛒 Đầy đủ (Login→Mua)": "full",
            "👀 Chỉ duyệt (Browse)": "browse",
            "🛍️ Stress giỏ hàng": "cart_only",
            "💳 Stress thanh toán": "checkout_stress",
        }
        self.scen_cb = ttk.Combobox(config, values=list(self.scenario_map.keys()), state="readonly", font=Theme.FONT_BODY)
        self.scen_cb.current(0)
        self.scen_cb.pack(fill="x", pady=(0, 5), ipady=2)

        # Think time & Ramp-up side-by-side
        row2 = tk.Frame(config, bg=Theme.BG_CARD)
        row2.pack(fill="x", pady=(0, 2))

        frame_tt = tk.Frame(row2, bg=Theme.BG_CARD)
        frame_tt.pack(side="left", fill="x", expand=True, padx=(0, 5))
        self._add_label(frame_tt, "⏱️ Think time(s)")
        self.think_var = tk.DoubleVar(value=0.3)
        tk.Entry(frame_tt, textvariable=self.think_var, font=Theme.FONT_BODY, bg=Theme.BG_INPUT, fg=Theme.TEXT_PRIMARY, justify="center", relief="flat").pack(fill="x", ipady=2)

        frame_ru = tk.Frame(row2, bg=Theme.BG_CARD)
        frame_ru.pack(side="left", fill="x", expand=True)
        self._add_label(frame_ru, "📈 Ramp-up(s)")
        self.rampup_var = tk.DoubleVar(value=0)
        tk.Entry(frame_ru, textvariable=self.rampup_var, font=Theme.FONT_BODY, bg=Theme.BG_INPUT, fg=Theme.TEXT_PRIMARY, justify="center", relief="flat").pack(fill="x", ipady=2)

    # ── CONTROLS ──

    def _build_controls(self, parent):
        ctrl = tk.Frame(parent, bg=Theme.BG_DARK)
        ctrl.pack(fill="x", pady=5)

        # Start button
        self.start_btn = tk.Button(ctrl, text="🚀  BẮT ĐẦU TEST", font=("Segoe UI", 13, "bold"),
                                   bg=Theme.ACCENT, fg="white", activebackground=Theme.ACCENT_LIGHT,
                                   activeforeground="white", relief="flat", cursor="hand2",
                                   pady=10, command=self.start_test)
        self.start_btn.pack(fill="x", pady=(0, 5))

        # Stop button
        self.stop_btn = tk.Button(ctrl, text="⏹  DỪNG", font=("Segoe UI", 11, "bold"),
                                  bg=Theme.BG_INPUT, fg=Theme.TEXT_SECONDARY,
                                  activebackground=Theme.ERROR, activeforeground="white",
                                  relief="flat", cursor="hand2", pady=6,
                                  command=self.stop_test, state="disabled")
        self.stop_btn.pack(fill="x", pady=(0, 5))

        # Status
        self.status_frame = tk.Frame(parent, bg=Theme.BG_CARD, pady=8, padx=10)
        self.status_frame.pack(fill="x", pady=5)

        self.status_label = tk.Label(self.status_frame, text="⏸️ Sẵn sàng",
                                     font=Theme.FONT_BODY, bg=Theme.BG_CARD,
                                     fg=Theme.TEXT_SECONDARY)
        self.status_label.pack()

        self.progress_bar = GradientProgressBar(self.status_frame, width=290, height=18)
        self.progress_bar.pack(pady=(5, 0))

        # Auto-stop toggle
        autostop_frame = tk.Frame(parent, bg=Theme.BG_CARD, padx=10, pady=6)
        autostop_frame.pack(fill="x", pady=(5, 0))

        self.autostop_var = tk.BooleanVar(value=True)
        autostop_cb = tk.Checkbutton(autostop_frame, text="🛡️ Tự động dừng khi máy quá tải",
                                      variable=self.autostop_var,
                                      bg=Theme.BG_CARD, fg=Theme.ACCENT_YELLOW,
                                      selectcolor=Theme.BG_INPUT,
                                      activebackground=Theme.BG_CARD,
                                      activeforeground=Theme.ACCENT_YELLOW,
                                      font=Theme.FONT_SMALL)
        autostop_cb.pack(anchor="w")
        tk.Label(autostop_frame, text="Dừng test nếu CPU > 90% hoặc RAM > 90%",
                 font=("Segoe UI", 8), bg=Theme.BG_CARD,
                 fg=Theme.TEXT_DIM).pack(anchor="w")

        # Resource monitor
        res_frame = tk.Frame(parent, bg=Theme.BG_CARD, padx=10, pady=6)
        res_frame.pack(fill="x", pady=(3, 0))

        tk.Label(res_frame, text="💻 Tài nguyên hệ thống:",
                 font=Theme.FONT_SMALL, bg=Theme.BG_CARD,
                 fg=Theme.TEXT_SECONDARY).pack(anchor="w")

        # CPU bar
        cpu_row = tk.Frame(res_frame, bg=Theme.BG_CARD)
        cpu_row.pack(fill="x", pady=(3, 0))
        tk.Label(cpu_row, text="CPU ", font=("Consolas", 8),
                 bg=Theme.BG_CARD, fg=Theme.TEXT_DIM, width=4).pack(side="left")
        self.cpu_bar = tk.Canvas(cpu_row, width=180, height=12,
                                 bg=Theme.BG_INPUT, highlightthickness=0)
        self.cpu_bar.pack(side="left", padx=(0, 5))
        self.cpu_label = tk.Label(cpu_row, text="0%", font=("Consolas", 8, "bold"),
                                   bg=Theme.BG_CARD, fg=Theme.SUCCESS, width=5)
        self.cpu_label.pack(side="left")

        # RAM bar
        ram_row = tk.Frame(res_frame, bg=Theme.BG_CARD)
        ram_row.pack(fill="x", pady=(2, 0))
        tk.Label(ram_row, text="RAM ", font=("Consolas", 8),
                 bg=Theme.BG_CARD, fg=Theme.TEXT_DIM, width=4).pack(side="left")
        self.ram_bar = tk.Canvas(ram_row, width=180, height=12,
                                 bg=Theme.BG_INPUT, highlightthickness=0)
        self.ram_bar.pack(side="left", padx=(0, 5))
        self.ram_label = tk.Label(ram_row, text="0%", font=("Consolas", 8, "bold"),
                                   bg=Theme.BG_CARD, fg=Theme.SUCCESS, width=5)
        self.ram_label.pack(side="left")

        # Start resource monitor timer
        self._update_resources()

        # Connection indicator
        self.conn_label = tk.Label(parent, text="", font=Theme.FONT_SMALL,
                                   bg=Theme.BG_DARK, fg=Theme.TEXT_DIM)
        self.conn_label.pack(fill="x", pady=(5, 0))

    # ── RESULTS PANEL ──

    def _build_results_panel(self, parent):
        # Top: Metric cards
        cards_frame = tk.Frame(parent, bg=Theme.BG_DARK)
        cards_frame.pack(fill="x", pady=(0, 10))

        self.card_requests = MetricCard(cards_frame, "📨", "Tổng Requests",
                                         "0", Theme.ACCENT_BLUE)
        self.card_requests.pack(side="left", fill="both", expand=True, padx=(0, 5))

        self.card_success = MetricCard(cards_frame, "✅", "Thành công",
                                        "0%", Theme.SUCCESS)
        self.card_success.pack(side="left", fill="both", expand=True, padx=5)

        self.card_throughput = MetricCard(cards_frame, "🚀", "Throughput",
                                          "0", Theme.ACCENT_ORANGE)
        self.card_throughput.pack(side="left", fill="both", expand=True, padx=5)

        self.card_avg_time = MetricCard(cards_frame, "⏱️", "Avg Response",
                                         "0ms", Theme.ACCENT_YELLOW)
        self.card_avg_time.pack(side="left", fill="both", expand=True, padx=(5, 0))

        # Middle: Chart + Details
        mid_frame = tk.Frame(parent, bg=Theme.BG_DARK)
        mid_frame.pack(fill="x", pady=(0, 10))

        # Response time chart
        chart_frame = tk.LabelFrame(mid_frame, text=" 📊 Response Time (ms) ",
                                     font=Theme.FONT_SUBTITLE, bg=Theme.BG_CARD,
                                     fg=Theme.ACCENT_BLUE, padx=10, pady=5)
        chart_frame.pack(side="left", fill="both", expand=True, padx=(0, 5))

        self.chart = MiniBarChart(chart_frame, width=350, height=130)
        self.chart.pack(fill="both", expand=True)

        # Action breakdown
        breakdown_frame = tk.LabelFrame(mid_frame, text=" 📋 Chi tiết ",
                                         font=Theme.FONT_SUBTITLE, bg=Theme.BG_CARD,
                                         fg=Theme.ACCENT_BLUE, padx=10, pady=5)
        breakdown_frame.pack(side="right", fill="both", expand=True, padx=(5, 0))

        # Treeview for action details
        style = ttk.Style()
        style.theme_use("clam")
        style.configure("Custom.Treeview",
                         background=Theme.BG_CARD,
                         foreground=Theme.TEXT_PRIMARY,
                         fieldbackground=Theme.BG_CARD,
                         font=Theme.FONT_SMALL,
                         rowheight=22)
        style.configure("Custom.Treeview.Heading",
                         background=Theme.BG_INPUT,
                         foreground=Theme.TEXT_PRIMARY,
                         font=("Segoe UI", 9, "bold"))

        self.tree = ttk.Treeview(breakdown_frame, columns=("count", "ok", "avg", "p95"),
                                  show="headings", height=5, style="Custom.Treeview")
        self.tree.heading("count", text="Số lượng")
        self.tree.heading("ok", text="OK")
        self.tree.heading("avg", text="Avg(ms)")
        self.tree.heading("p95", text="P95(ms)")
        self.tree.column("count", width=60, anchor="center")
        self.tree.column("ok", width=50, anchor="center")
        self.tree.column("avg", width=70, anchor="center")
        self.tree.column("p95", width=70, anchor="center")
        self.tree.pack(fill="both", expand=True)

        # Bottom: Log area
        log_frame = tk.LabelFrame(parent, text=" 📝 LOG ", font=Theme.FONT_SUBTITLE,
                                   bg=Theme.BG_CARD, fg=Theme.ACCENT_BLUE, padx=5, pady=5)
        log_frame.pack(fill="both", expand=True)

        self.log_text = scrolledtext.ScrolledText(log_frame, bg=Theme.BG_DARK,
                                                   fg=Theme.TEXT_SECONDARY,
                                                   font=Theme.FONT_MONO,
                                                   insertbackground=Theme.TEXT_PRIMARY,
                                                   selectbackground=Theme.ACCENT,
                                                   relief="flat", wrap="word", height=8)
        self.log_text.pack(fill="both", expand=True)

        # Tag colors for log
        self.log_text.tag_config("success", foreground=Theme.SUCCESS)
        self.log_text.tag_config("error", foreground=Theme.ERROR)
        self.log_text.tag_config("warning", foreground=Theme.WARNING)
        self.log_text.tag_config("info", foreground=Theme.ACCENT_BLUE)
        self.log_text.tag_config("accent", foreground=Theme.ACCENT)

    # ── HELPERS ──

    def _add_label(self, parent, text):
        tk.Label(parent, text=text, font=Theme.FONT_SMALL, bg=Theme.BG_CARD,
                 fg=Theme.TEXT_SECONDARY, anchor="w").pack(fill="x", pady=(8, 2))

    def _add_entry(self, parent, var):
        entry = tk.Entry(parent, textvariable=var, font=Theme.FONT_BODY,
                         bg=Theme.BG_INPUT, fg=Theme.TEXT_PRIMARY,
                         insertbackground=Theme.TEXT_PRIMARY, relief="flat",
                         selectbackground=Theme.ACCENT)
        entry.pack(fill="x", ipady=5, pady=(0, 5))
        return entry

    def log(self, message, tag=""):
        """Thêm log có timestamp"""
        ts = datetime.now().strftime("%H:%M:%S")
        self.log_text.insert("end", f"[{ts}] {message}\n", tag)
        self.log_text.see("end")

    def set_status(self, text):
        self.status_label.config(text=text)

    def _update_resources(self):
        """Cập nhật hiển thị CPU/RAM mỗi giây"""
        if HAS_PSUTIL:
            cpu = psutil.cpu_percent(interval=0)
            ram = psutil.virtual_memory().percent
        else:
            cpu = 0
            ram = 0

        # CPU bar
        self._draw_resource_bar(self.cpu_bar, cpu)
        cpu_color = Theme.SUCCESS if cpu < 70 else (Theme.WARNING if cpu < 90 else Theme.ERROR)
        self.cpu_label.config(text=f"{cpu:.0f}%", fg=cpu_color)

        # RAM bar
        self._draw_resource_bar(self.ram_bar, ram)
        ram_color = Theme.SUCCESS if ram < 70 else (Theme.WARNING if ram < 90 else Theme.ERROR)
        self.ram_label.config(text=f"{ram:.0f}%", fg=ram_color)

        # Auto-stop check
        if self.is_running and self.autostop_var.get():
            if cpu > 90 or ram > 90:
                self._auto_stop_triggered(cpu, ram)

        # Repeat every 1 second
        self.root.after(1000, self._update_resources)

    def _draw_resource_bar(self, canvas, percent):
        """Vẽ thanh resource trên canvas"""
        canvas.delete("all")
        w = 180
        h = 12
        fill_w = int(w * min(percent, 100) / 100)
        color = Theme.SUCCESS if percent < 70 else (Theme.WARNING if percent < 90 else Theme.ERROR)
        canvas.create_rectangle(0, 0, fill_w, h, fill=color, outline="")

    def _auto_stop_triggered(self, cpu, ram):
        """Tự động dừng test khi tài nguyên quá cao"""
        self.is_running = False
        reason = []
        if cpu > 90:
            reason.append(f"CPU={cpu:.0f}%")
        if ram > 90:
            reason.append(f"RAM={ram:.0f}%")
        msg = ", ".join(reason)
        self.log(f"🛡️ TỰ ĐỘNG DỪNG! Máy quá tải: {msg}", "error")
        self.log("   Test đã dừng để bảo vệ hệ thống.", "warning")

    # ── TEST LOGIC ──

    def start_test(self):
        if self.is_running:
            return

        base_url = self.url_var.get().strip().rstrip("/")
        try:
            num_users = int(self.users_var.get().strip())
            if num_users < 1:
                raise ValueError
        except ValueError:
            messagebox.showwarning("Cảnh báo", "Số người dùng phải là số nguyên dương!")
            return
        try:
            max_concurrent = int(self.concurrent_var.get().strip())
            if max_concurrent < 1:
                raise ValueError
        except ValueError:
            messagebox.showwarning("Cảnh báo", "Số luồng đồng thời phải là số nguyên dương!")
            return
        scenario = self.scenario_map.get(self.scen_cb.get(), "full")
        try:
            think_time = self.think_var.get()
            ramp_up = self.rampup_var.get()
        except tk.TclError:
            messagebox.showwarning("Cảnh báo", "Think time và Ramp-up phải là số!")
            return

        if not base_url:
            messagebox.showwarning("Cảnh báo", "Vui lòng nhập Server URL!")
            return

        # Clear previous
        self.log_text.delete("1.0", "end")
        for item in self.tree.get_children():
            self.tree.delete(item)
        self.card_requests.update_value("0")
        self.card_success.update_value("0%")
        self.card_throughput.update_value("0")
        self.card_avg_time.update_value("0ms")
        self.chart.draw_bars({})
        self.progress_bar.set_progress(0)

        self.is_running = True
        self.start_btn.config(state="disabled", bg=Theme.TEXT_DIM)
        self.stop_btn.config(state="normal", bg=Theme.ERROR)
        self.set_status("🔍 Đang kiểm tra kết nối...")

        self.log("═" * 50, "accent")
        self.log("🛒 SHOPEE LOAD SIMULATOR - BẮT ĐẦU", "accent")
        self.log("═" * 50, "accent")
        self.log(f"  Server:      {base_url}", "info")
        self.log(f"  Users:       {num_users} (tổng)", "info")
        self.log(f"  Concurrent:  {max_concurrent} (đồng thời thực)", "info")
        self.log(f"  Scenario:    {scenario}", "info")
        self.log(f"  Think:       {think_time}s", "info")
        self.log("")

        # Run in background thread
        self.max_concurrent = max_concurrent
        self.test_thread = threading.Thread(
            target=self._run_test_thread,
            args=(base_url, num_users, scenario, think_time, ramp_up, max_concurrent),
            daemon=True
        )
        self.test_thread.start()

        # Start UI update timer
        self._schedule_update()

    def _run_test_thread(self, base_url, num_users, scenario, think_time, ramp_up, max_concurrent):
        """Chạy test trong background thread"""
        from concurrent.futures import ThreadPoolExecutor, as_completed

        # Kiểm tra server
        self.root.after(0, lambda: self.log("🔍 Kiểm tra kết nối server...", "info"))
        if not check_server(base_url):
            self.root.after(0, lambda: self.log("❌ Không thể kết nối tới server!", "error"))
            self.root.after(0, lambda: self.log(f"   URL: {base_url}", "error"))
            self.root.after(0, lambda: self.log("   Hãy đảm bảo server đang chạy.", "error"))
            self.root.after(0, lambda: self.set_status("❌ Lỗi kết nối"))
            self.root.after(0, self._on_test_finished)
            return

        self.root.after(0, lambda: self.log("✅ Server OK!", "success"))
        self.root.after(0, lambda: self.log(""))

        # Khởi tạo collector
        self.collector = MetricsCollector()
        self.completed_count = 0
        self.total_users = num_users
        actual_workers = min(num_users, max_concurrent)

        self.root.after(0, lambda: self.set_status(f"🚀 Đang chạy... 0/{num_users} users ({actual_workers} đồng thời)"))
        self.root.after(0, lambda: self.log(f"🚀 Bắt đầu mô phỏng {num_users} người dùng ({actual_workers} luồng đồng thời)...", "info"))

        # Run users
        with ThreadPoolExecutor(max_workers=actual_workers) as executor:
            futures = []
            for i in range(1, num_users + 1):
                if not self.is_running:
                    break
                futures.append(executor.submit(self._run_single_user, i, base_url,
                                               scenario, think_time, ramp_up, num_users))

            for future in as_completed(futures):
                if not self.is_running:
                    break
                try:
                    future.result()
                except Exception as e:
                    self.root.after(0, lambda e=e: self.log(f"❌ Thread error: {e}", "error"))

        # Finished
        self.root.after(0, self._on_test_finished)

    def _run_single_user(self, user_id, base_url, scenario, think_time, ramp_up, total_users):
        """Chạy 1 user simulation"""
        if not self.is_running:
            return

        # Ramp-up delay
        if ramp_up > 0:
            delay = (user_id / total_users) * ramp_up
            time.sleep(delay)

        if not self.is_running:
            return

        result = run_user(user_id, base_url, self.collector, scenario, think_time)

        self.completed_count += 1
        status = "✅" if result.errors == 0 else "⚠️"
        msg = (f"  {status} User {user_id:>3}: {result.actions_completed} actions, "
               f"{result.errors} errors, {result.total_time:.1f}s")
        tag = "success" if result.errors == 0 else "warning"

        self.root.after(0, lambda: self.log(msg, tag))

    def _on_test_finished(self):
        """Callback khi test hoàn tất"""
        self.is_running = False
        self.start_btn.config(state="normal", bg=Theme.ACCENT)
        self.stop_btn.config(state="disabled", bg=Theme.BG_INPUT)
        self.progress_bar.set_progress(100)
        self.set_status("✅ Hoàn tất!")

        self.log("")
        self.log("═" * 50, "accent")
        self.log("✅ KIỂM TRA HOÀN TẤT!", "success")
        self.log(f"   Thời gian: {datetime.now().strftime('%H:%M:%S')}", "info")
        self.log("═" * 50, "accent")

        # Final update
        self._update_metrics()

    def stop_test(self):
        if self.is_running:
            self.is_running = False
            self.log("⏹ Đang dừng test...", "warning")
            self.set_status("⏹ Đang dừng...")

    def _schedule_update(self):
        """Schedule periodic UI update"""
        if self.is_running:
            self._update_metrics()
            self.update_timer = self.root.after(500, self._schedule_update)

    def _update_metrics(self):
        """Cập nhật tất cả metrics trên UI"""
        if not self.collector:
            return

        metrics = list(self.collector.metrics)
        if not metrics:
            return

        total = len(metrics)
        successful = sum(1 for m in metrics if m.success)
        failed = total - successful
        elapsed = time.time() - self.collector.start_time

        # Cards
        self.card_requests.update_value(f"{total:,}", f"✅ {successful}  ❌ {failed}")

        success_pct = (successful / total * 100) if total > 0 else 0
        self.card_success.update_value(f"{success_pct:.1f}%", f"{successful}/{total}")

        throughput = total / elapsed if elapsed > 0 else 0
        self.card_throughput.update_value(f"{throughput:.1f}", "req/s")

        all_times = [m.response_time * 1000 for m in metrics]
        avg_time = statistics.mean(all_times) if all_times else 0
        self.card_avg_time.update_value(f"{avg_time:.0f}ms")
        if len(all_times) >= 2:
            p95 = sorted(all_times)[int(len(all_times) * 0.95)]
            self.card_avg_time.update_value(f"{avg_time:.0f}ms", f"P95: {p95:.0f}ms")

        # Progress
        if hasattr(self, 'total_users') and self.total_users > 0:
            done = getattr(self, 'completed_count', 0)
            conc = getattr(self, 'max_concurrent', 100)
            actual = min(self.total_users, conc)
            pct = (done / self.total_users) * 100
            self.progress_bar.set_progress(pct)
            self.set_status(f"🚀 Đang chạy... {done}/{self.total_users} users ({actual} đồng thời)")

        # Chart - response time by action
        by_action = defaultdict(list)
        for m in metrics:
            by_action[m.action].append(m)

        chart_data = {}
        action_colors = {
            'login': Theme.ACCENT,
            'browse_home': Theme.ACCENT_BLUE,
            'browse_product': Theme.ACCENT_GREEN,
            'add_to_cart': Theme.ACCENT_ORANGE,
            'checkout': Theme.ACCENT_YELLOW,
        }
        action_labels = {
            'login': 'Login',
            'browse_home': 'Home',
            'browse_product': 'Product',
            'add_to_cart': 'Cart',
            'checkout': 'Checkout',
        }

        for action in ['login', 'browse_home', 'browse_product', 'add_to_cart', 'checkout']:
            if action in by_action:
                items = by_action[action]
                times = [m.response_time * 1000 for m in items]
                avg = statistics.mean(times) if times else 0
                label = action_labels.get(action, action)
                color = action_colors.get(action, Theme.ACCENT_BLUE)
                chart_data[label] = (avg, color)

        self.chart.draw_bars(chart_data)

        # Treeview
        for item in self.tree.get_children():
            self.tree.delete(item)

        for action in ['login', 'browse_home', 'browse_product', 'add_to_cart', 'checkout']:
            if action not in by_action:
                continue
            items = by_action[action]
            times = [m.response_time * 1000 for m in items]
            ok_count = sum(1 for m in items if m.success)
            avg = statistics.mean(times) if times else 0
            p95 = sorted(times)[int(len(times) * 0.95)] if len(times) >= 2 else (times[0] if times else 0)
            label = action_labels.get(action, action)
            self.tree.insert("", "end", values=(len(items), ok_count, f"{avg:.0f}", f"{p95:.0f}"),
                             text=label, tags=(label,))


# ══════════════════════════════════════════════════════════════
# ENTRY POINT
# ══════════════════════════════════════════════════════════════

def main():
    root = tk.Tk()

    # Center window
    screen_w = root.winfo_screenwidth()
    screen_h = root.winfo_screenheight()
    win_w, win_h = 1150, 880
    x = (screen_w - win_w) // 2
    y = max(0, (screen_h - win_h) // 2 - 30)
    root.geometry(f"{win_w}x{win_h}+{x}+{y}")

    app = SimulatorApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
