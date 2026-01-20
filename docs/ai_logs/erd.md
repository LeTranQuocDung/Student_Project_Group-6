
 vẽ sơ đồ erd file md
 ```mermaid
erDiagram
    USER {
        int user_id PK
        string username
        string password
        string full_name
        string email
        string role
    }

    SHOP {
        int shop_id PK
        string shop_name
        int owner_id FK
    }

    PRODUCT {
        int product_id PK
        int shop_id FK
        string product_name
        string description
    }

    PRODUCT_VARIANT {
        int variant_id PK
        int product_id FK
        string color
        string size
        double price
        int stock
    }

    CART {
        int cart_id PK
        int user_id FK
    }

    CART_ITEM {
        int cart_item_id PK
        int cart_id FK
        int variant_id FK
        int quantity
    }

    VOUCHER {
        int voucher_id PK
        string code
        string type
        double value
        double max_cap
        double min_order
    }

    ORDER {
        int order_id PK
        int user_id FK
        double final_amount
        datetime created_at
    }

    ORDER_ITEM {
        int order_item_id PK
        int order_id FK
        int variant_id FK
        int quantity
        double price
    }

    FLASH_SALE {
        int flash_sale_id PK
        datetime start_time
        datetime end_time
    }

    FLASH_SALE_ITEM {
        int fs_item_id PK
        int flash_sale_id FK
        int variant_id FK
        int sale_stock
        double sale_price
    }

    IMPORT_LOG {
        int import_id PK
        string file_name
        int success_count
        int error_count
        datetime import_time
    }

    USER ||--o{ SHOP : owns
    SHOP ||--o{ PRODUCT : lists
    PRODUCT ||--o{ PRODUCT_VARIANT : has

    USER ||--|| CART : has
    CART ||--o{ CART_ITEM : contains
    PRODUCT_VARIANT ||--o{ CART_ITEM : selected

    USER ||--o{ ORDER : places
    ORDER ||--o{ ORDER_ITEM : includes
    PRODUCT_VARIANT ||--o{ ORDER_ITEM : sold_as

    VOUCHER }o--o{ ORDER : applied_to

    FLASH_SALE ||--o{ FLASH_SALE_ITEM : includes
    PRODUCT_VARIANT ||--o{ FLASH_SALE_ITEM : discounted
```
