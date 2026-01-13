# DESIGN DOCUMENT: FLASH SALE & IMPORT MODULE

## 1. Flowchart: Flash Sale Purchase (Synchronous Processing)
Describes the processing flow when multiple users purchase simultaneously. The most important step is **Lock Stock**.

```mermaid
flowchart TD
    Start([Start]) --> Request[/User clicks Buy Now/]
    Request --> CheckTime{Check sale time?}
    
    CheckTime -- Not started/Ended --> ErrorTime[Error: Wrong time slot] --> End([End])
    CheckTime -- Open --> CheckStock{Check inventory?}
    
    CheckStock -- Out of stock 0 --> OutOfStock[Error: Out of stock] --> End
    CheckStock -- In stock >0 --> LockStock[🔥 LOCK RECORD DB LOCK]
    
    LockStock --> DoubleCheck{Double check}
    DoubleCheck -- Out Race condition --> Rollback[Cancel transaction] --> End
    DoubleCheck -- Available --> CreateOrder[Create order]
    
    CreateOrder --> UpdateStock[Deduct stock & Update Sold] --> Commit[Commit Transaction]
    Commit --> Success[Success: Purchase completed] --> End
```

## 2. Flowchart: Import Products from CSV
Describes the product import process from CSV file with error handling.

```mermaid
flowchart TD
    Start([Admin Upload CSV]) --> CheckFormat{Valid .csv format?}
    CheckFormat -- Invalid --> ErrorFile[File Error] --> End([End])
    CheckFormat -- Valid --> InitLog[Create Import Log]
    
    InitLog --> ReadFile[Read each row]
    ReadFile --> Validate{Data valid?}
    
    Validate -- Invalid Missing/Bad data --> WriteError[Write Error Log & Skip] --> NextRow
    
    Validate -- Valid --> SaveDB[(Save to Database)] --> NextRow
    
    NextRow{More rows?} -- Yes --> ReadFile
    NextRow -- No --> Summary[Summary: Success/Failed] 
    Summary --> UpdateLog[Update Log Status] --> End
```

## 3. Class Diagram: System Architecture
Shows the relationship between controllers, services, and data models.

```mermaid
classDiagram
    class FlashSaleController {
        +joinFlashSale(int userId, int itemId) Response
        +getCampaignInfo(int campaignId)
    }

    class FlashSaleService {
        +processTransaction(int userId, int itemId) boolean
        -lockInventory(int itemId) void
        -checkStock(int itemId) boolean
    }

    class FlashSaleItem {
        -int id
        -int productId
        -int quantity
        -int sold
        -double salePrice
    }

    class ImportController {
        +uploadFile(MultipartFile file) Response
        +getImportHistory()
    }

    class ImportService {
        +readCsv(File file) List
        +validateData(Row row) boolean
        +saveToDatabase(List data) void
    }

    class ImportLog {
        -int id
        -String fileName
        -int successCount
        -int errorCount
        -Date importTime
    }

    FlashSaleController --> FlashSaleService : uses
    FlashSaleService ..> FlashSaleItem : manages
    ImportController --> ImportService : uses
    ImportService ..> ImportLog : creates
```

## Key Features

### Flash Sale Module
- **Pessimistic Locking**: Prevents race conditions during high-traffic purchases
- **Double-check Mechanism**: Ensures stock accuracy before order creation
- **Transaction Management**: Guarantees data consistency with ACID properties

### Import Module
- **Batch Processing**: Handles large CSV files efficiently
- **Error Logging**: Tracks failed imports for debugging
- **Data Validation**: Ensures data integrity before database insertion

## Usage in VSCode

1. Install extension: `Markdown Preview Mermaid Support` or `Mermaid Preview`
2. View preview: Press `Ctrl+Shift+V` (Windows) or `Cmd+Shift+V` (Mac)
3. Or right-click file → **"Open Preview to the Side"**