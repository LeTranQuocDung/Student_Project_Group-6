import React, { useState, useEffect, useMemo } from 'react';

// Giả lập dữ liệu
const mockData = {
    products: [
        {
            id: "p1",
            title: "Ốp Lưng iPhone TPU Họa Tiết Da Mềm Mèo Cầm Hoa Chống Sốc,...",
            shop: "Shop A",
            price: 14900,
            price_old: 24900,
            qty: 1,
            img: "https://placehold.co/80x80/eeeeee/999999?text=Cat+Case",
            attributes: "Nền trắng, size 16",
            shipping: "Miễn phí",
            shop_voucher: "Giảm 5k cho đơn từ 0đ"
        },
        {
            id: "p2",
            title: "Tai nghe bluetooth X bản mới nhất 2025 chống ồn",
            shop: "Shop B",
            price: 499000,
            price_old: null,
            qty: 2,
            img: "https://placehold.co/80x80/eeeeee/999999?text=Headphones",
            attributes: "Bản 2025 màu đen",
            shipping: "₫30.000"
        }
    ],
    suggested_products: [
        {
            id: "s1",
            title: "Ốp điện thoại iPhone 16 15 14",
            price: 8581,
            rating: 4.8,
            sold: "4k+",
            img: "https://placehold.co/200x200/eeeeee/999999",
            badge: "Yêu thích",
            discount_tag: "-1%"
        }
    ]
};

const formatPrice = (price) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price).replace('₫', 'đ');

export default function CartComponent() {
    const [cart, setCart] = useState([]);
    const [suggested, setSuggested] = useState([]);

    useEffect(() => {
        // Simulate API fetch
        setCart(mockData.products.map(p => ({ ...p, checked: false })));
        setSuggested(mockData.suggested_products);
    }, []);

    const total = useMemo(() => {
        let count = 0;
        let sum = 0;
        cart.forEach(item => {
            if (item.checked) {
                count++;
                sum += item.price * item.qty;
            }
        });
        return { count, sum };
    }, [cart]);

    const isAllChecked = cart.length > 0 && cart.every(i => i.checked);

    const toggleAll = () => {
        setCart(cart.map(item => ({ ...item, checked: !isAllChecked })));
    };

    const toggleItem = (id) => {
        setCart(cart.map(item => item.id === id ? { ...item, checked: !item.checked } : item));
    };

    const updateQty = (id, delta) => {
        setCart(cart.map(item => {
            if (item.id === id) {
                const newQty = Math.max(1, item.qty + delta);
                return { ...item, qty: newQty };
            }
            return item;
        }));
    };

    const removeItem = (id) => {
        if (window.confirm("Bạn có chắc muốn xóa?")) {
            setCart(cart.filter(item => item.id !== id));
        }
    };

    const groupedCart = useMemo(() => {
        const groups = {};
        cart.forEach(item => {
            if (!groups[item.shop]) groups[item.shop] = [];
            groups[item.shop].push(item);
        });
        return groups;
    }, [cart]);

    return (
        <div className="bg-[#f5f5f5] min-h-screen text-[#222] font-sans">
            {/* Header */}
            <header className="bg-white border-b hidden md:block border-[#e8e8e8] py-4">
                <div className="max-w-[1200px] mx-auto px-4 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <span className="text-[#ff5722] text-3xl">🛒</span>
                        <h1 className="text-xl text-[#ff5722] font-medium border-l border-[#ff5722] pl-4">Giỏ Hàng</h1>
                    </div>
                    <div className="flex border-2 border-[#ff5722] rounded-sm w-[400px]">
                        <input type="text" placeholder="Freeship 0Đ (*)" className="flex-1 px-3 py-2 outline-none" />
                        <button className="bg-[#ff5722] text-white px-6">🔍</button>
                    </div>
                </div>
            </header>

            {/* Main Cart */}
            <main className="max-w-[1200px] mx-auto px-4 mt-5 mb-5 pb-24 md:pb-0">

                {/* Table Header (Desktop) */}
                <div className="hidden md:flex items-center bg-white p-4 rounded-sm shadow-sm mb-3.5 text-[#888]">
                    <label className="flex-1 flex items-center gap-3 cursor-pointer select-none">
                        <input type="checkbox" checked={isAllChecked} onChange={toggleAll} className="w-4 h-4 accent-[#ff5722]" />
                        Sản Phẩm
                    </label>
                    <div className="w-[15%] text-center">Đơn Giá</div>
                    <div className="w-[15%] text-center">Số Lượng</div>
                    <div className="w-[15%] text-center">Số Tiền</div>
                    <div className="w-[15%] text-center">Thao Tác</div>
                </div>

                {/* Cart Items */}
                {cart.length === 0 ? (
                    <div className="bg-white p-12 text-center rounded-sm">
                        <div className="text-6xl text-gray-200 mb-4">🛒</div>
                        <p className="text-gray-500 mb-4">Giỏ hàng của bạn còn trống</p>
                        <button className="bg-[#ff5722] text-white px-8 py-2 rounded-sm" onClick={() => window.location.reload()}>MUA SẮM NGAY</button>
                    </div>
                ) : (
                    Object.entries(groupedCart).map(([shopName, items]) => {
                        const isShopChecked = items.every(i => i.checked);
                        const toggleShop = () => {
                            const ids = items.map(i => i.id);
                            setCart(cart.map(c => ids.includes(c.id) ? { ...c, checked: !isShopChecked } : c));
                        };

                        return (
                            <div key={shopName} className="bg-white rounded-sm shadow-sm mb-4">
                                <div className="p-4 border-b border-[#e8e8e8] flex items-center font-medium">
                                    <input type="checkbox" checked={isShopChecked} onChange={toggleShop} className="w-4 h-4 accent-[#ff5722] mr-3" />
                                    <span className="mr-2">🏠</span> {shopName}
                                </div>

                                {items.map(item => (
                                    <div key={item.id} className="p-4 border-b border-[#e8e8e8] last:border-0 flex flex-col md:flex-row md:items-center gap-3 relative">
                                        <div className="flex flex-1 items-start gap-3">
                                            <input type="checkbox" checked={item.checked} onChange={() => toggleItem(item.id)} className="w-4 h-4 accent-[#ff5722] mt-2 md:mt-0" />
                                            <img src={item.img} alt="" className="w-20 h-20 object-cover border border-[#e8e8e8] rounded-sm" />
                                            <div className="flex-1">
                                                <div className="line-clamp-2 text-sm leading-snug">{item.title}</div>
                                                {item.shipping === 'Miễn phí' && <div className="text-[10px] bg-[#ee4d2d] text-white px-1 py-0.5 inline-block rounded-sm mt-1">Free Ship</div>}
                                                <div className="text-xs text-gray-500 mt-1 md:hidden">Phân loại hàng: {item.attributes}</div>
                                            </div>
                                        </div>

                                        <div className="hidden md:block w-[150px] text-sm text-gray-500">Phân loại hàng: <br />{item.attributes}</div>

                                        <div className="hidden md:flex w-[15%] flex-col items-center">
                                            {item.price_old && <span className="line-through text-gray-400 text-xs">{formatPrice(item.price_old)}</span>}
                                            <span>{formatPrice(item.price)}</span>
                                        </div>

                                        {/* Mobile Price & Qty */}
                                        <div className="flex md:hidden justify-between items-center ml-7">
                                            <span className="text-[#ff5722]">{formatPrice(item.price)}</span>
                                            <div className="flex border border-gray-300 rounded-sm">
                                                <button className="w-8 h-8 flex items-center justify-center text-gray-500" onClick={() => updateQty(item.id, -1)}>-</button>
                                                <input type="text" readOnly value={item.qty} className="w-10 text-center border-l border-r border-gray-300 outline-none" />
                                                <button className="w-8 h-8 flex items-center justify-center text-gray-500" onClick={() => updateQty(item.id, 1)}>+</button>
                                            </div>
                                        </div>

                                        {/* Desktop Qty */}
                                        <div className="hidden md:flex w-[15%] justify-center">
                                            <div className="flex border border-gray-300 rounded-sm">
                                                <button className="w-8 h-8 flex items-center justify-center text-gray-500 hover:bg-gray-50" onClick={() => updateQty(item.id, -1)}>-</button>
                                                <input type="text" readOnly value={item.qty} className="w-12 text-center border-l border-r border-gray-300 outline-none" />
                                                <button className="w-8 h-8 flex items-center justify-center text-gray-500 hover:bg-gray-50" onClick={() => updateQty(item.id, 1)}>+</button>
                                            </div>
                                        </div>

                                        <div className="hidden md:block w-[15%] text-center text-[#ff5722]">{formatPrice(item.price * item.qty)}</div>

                                        <div className="hidden md:flex w-[15%] flex-col items-center gap-2">
                                            <button className="hover:text-[#ff5722]" onClick={() => removeItem(item.id)}>Xóa</button>
                                            <button className="text-[#ff5722] text-xs">Tìm sản phẩm tương tự ▼</button>
                                        </div>

                                        <button className="md:hidden absolute top-4 right-4 text-gray-400" onClick={() => removeItem(item.id)}>🗑️</button>
                                    </div>
                                ))}
                            </div>
                        );
                    })
                )}
            </main>

            {/* Sticky Bottom Summary */}
            <div className="fixed md:sticky bottom-0 left-0 w-full bg-white border-t border-dashed border-[#e8e8e8] shadow-[0_-4px_10px_rgba(0,0,0,0.05)] z-50">
                <div className="max-w-[1200px] mx-auto">
                    <div className="p-3 md:p-4 flex flex-col gap-3 md:gap-4 border-b border-dashed border-[#e8e8e8]">
                        <div className="flex justify-between md:justify-end items-center md:gap-14 text-sm">
                            <div className="flex items-center gap-2"><span className="text-[#ff5722]">🎫</span> Shopee Voucher</div>
                            <a href="#" className="text-blue-600">Chọn hoặc nhập mã</a>
                        </div>
                        <div className="flex justify-between md:justify-end items-center md:gap-14 text-sm text-gray-300">
                            <div className="flex items-center gap-2"><span className="text-yellow-500">💰</span> Shopee Xu <span className="text-gray-400 text-xs ml-2">Bạn chưa chọn sản phẩm</span></div>
                            <div>-0đ</div>
                        </div>
                    </div>

                    <div className="p-3 md:p-4 flex flex-wrap md:flex-nowrap justify-between items-center gap-3">
                        <div className="hidden md:flex items-center gap-6">
                            <label className="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" checked={isAllChecked} onChange={toggleAll} className="w-4 h-4 accent-[#ff5722]" />
                                Chọn Tất Cả ({total.count})
                            </label>
                            <button className="hover:text-[#ff5722]">Xóa</button>
                        </div>

                        <label className="md:hidden flex items-center gap-2 cursor-pointer ml-2">
                            <input type="checkbox" checked={isAllChecked} onChange={toggleAll} className="w-4 h-4 accent-[#ff5722]" />
                            Tất cả
                        </label>

                        <div className="flex flex-1 justify-end items-center gap-2 md:gap-6">
                            <div className="text-right">
                                <div className="hidden md:flex justify-end items-center gap-1 text-sm mb-1"><span className="text-teal-500">🚚</span> Giảm 500.000đ phí vận chuyển <a href="#" className="text-blue-500 text-xs">Tìm hiểu thêm</a></div>
                                <div className="flex items-center gap-2">
                                    <span className="text-xs md:text-sm">Tổng thanh toán ({total.count} sp):</span>
                                    <span className="text-lg md:text-2xl text-[#ff5722]">{formatPrice(total.sum)}</span>
                                </div>
                            </div>
                            <button disabled={total.count === 0} className="bg-[#ff5722] text-white px-4 md:px-10 py-2.5 md:py-3.5 rounded-sm disabled:bg-gray-300 hover:bg-[#e64a19] transition-colors whitespace-nowrap">
                                Mua Hàng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
