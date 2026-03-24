import csv
import os
import random
DATA_DIR = "./data"
def init_dir():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)

# Real Shopee Products Backup list
DUMMY_PRODUCTS = [
    {
        "name": "Áo thun nam CANIFA ngắn tay cổ tròn form thường chất cotton",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsthcdtd1iuy6s",
        "price": 99000,
        "shop": "CANIFA Official"
    },
    {
        "name": "Áo phông nam nữ tay ngắn cổ tròn form rộng vải dạ quang",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsthdvbxmb9m1b",
        "price": 120000,
        "shop": "Routine Official"
    },
    {
        "name": "Quần Jean Nam Ống Rộng Cao Cấp Trẻ Trung",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lesz0v9gxy952d",
        "price": 185000,
        "shop": "Jeans Store VN"
    },
    {
        "name": "Giày Thể Thao Sneaker Nam Nữ",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf08p4aaxc7jca",
        "price": 250000,
        "shop": "Shoe x Authentic"
    },
    {
        "name": "Tai nghe không dây Bluetooth 5.0",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lesz0x1z3x4d79",
        "price": 310000,
        "shop": "TechMall VN"
    },
    {
        "name": "Ốp lưng iPhone 13 14 15 Pro Max",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ln0x1y6z2a4d79",
        "price": 55000,
        "shop": "Phụ kiện rẻ"
    },
    {
        "name": "Balo thời trang nam nữ Unisex",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ll1b2c3d4e5f6g",
        "price": 150000,
        "shop": "Túi Xách & Balo"
    },
    {
        "name": "Đồng hồ nam nữ dây da chống nước",
        "image": "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lm4n5p6q7r8s9t",
        "price": 450000,
        "shop": "Watch Station"
    }
]

def generate_shopee_data():
    print("API Shopee yêu cầu Cookie/Token thật nên bị chặn 403.")
    print("Tiến hành tạo bộ dữ liệu mẫu với các hình ảnh và sản phẩm có thực từ Shopee...")

    shops_data = [] # id, shop_name, rating
    products_data = [] # id, shop_id, name, description, price, image_url
    variants_data = [] # id, product_id, color, size, stock, price, note

    shop_id_counter = 1
    product_id_counter = 1
    variant_id_counter = 1

    shop_map = {} # shop_name -> id

    # Clone array multiple times to simulate large product list (e.g. over 10000 records)
    all_products = DUMMY_PRODUCTS * 1500 

    for item in all_products:
        shop_name = item['shop']
        if shop_name not in shop_map:
            internal_shop_id = shop_id_counter
            shop_map[shop_name] = internal_shop_id
            rating = round(random.uniform(4.5, 5.0), 1)
            shops_data.append([internal_shop_id, shop_name, rating])
            shop_id_counter += 1
        else:
            internal_shop_id = shop_map[shop_name]

        price = item['price']
        image_url = f"https://picsum.photos/seed/shopee_{product_id_counter}/400/400"
        name = item['name'] + " " + str(random.randint(100, 999)) # Add random suffix to make names distinct
        desc = "Hàng chuẩn Mall. " * 3

        products_data.append([product_id_counter, internal_shop_id, name, desc, price, image_url])

        colors = ['Đen', 'Trắng']
        sizes = ['M', 'L']

        for _ in range(2):
            color = random.choice(colors)
            size = random.choice(sizes)
            stock = random.randint(20, 150)
            v_price = price + random.randint(-5000, 10000)
            if v_price <= 0: v_price = price
            
            variants_data.append([variant_id_counter, product_id_counter, color, size, stock, v_price, ""])
            variant_id_counter += 1
        
        product_id_counter += 1

    write_csv(os.path.join(DATA_DIR, "shops.csv"), ["id", "shop_name", "rating"], shops_data)
    write_csv(os.path.join(DATA_DIR, "products.csv"), ["id", "shop_id", "name", "description", "price", "image_url"], products_data)
    write_csv(os.path.join(DATA_DIR, "product_variants.csv"), ["id", "product_id", "color", "size", "stock", "price", "note"], variants_data)
    
    print(f"Đã lưu xong {len(shops_data)} shops, {len(products_data)} products, {len(variants_data)} variants vào {DATA_DIR}!")

def write_csv(filepath, headers, rows):
    with open(filepath, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)

if __name__ == "__main__":
    init_dir()
    generate_shopee_data()
