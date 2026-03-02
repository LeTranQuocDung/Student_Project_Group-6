import threading
import requests
import time

URL_RESET = "http://localhost:8080/api/buy?reset=true"
URL_BUY = "http://localhost:8080/api/buy"

def reset_stock():
    print("Resetting stock to 1...")
    response = requests.get(URL_RESET)
    print("Reset response:", response.text)

def buy_product(thread_id, success_count):
    try:
        response = requests.get(URL_BUY)
        if response.text == "MUA_THANH_CONG":
            success_count.append(thread_id)
            print(f"Thread {thread_id}: SUCCESS")
        else:
             pass # print(f"Thread {thread_id}: FAILED ({response.text})")
    except Exception as e:
        print(f"Thread {thread_id}: ERROR {e}")

if __name__ == "__main__":
    reset_stock()
    
    print("\nStarting stress test with 100 concurrent requests...")
    threads = []
    success_count = []
    
    start_time = time.time()
    
    for i in range(100):
        t = threading.Thread(target=buy_product, args=(i, success_count))
        threads.append(t)
        t.start()
        
    for t in threads:
        t.join()
        
    end_time = time.time()
    
    print(f"\n--- RESULTS ---")
    print(f"Total time: {end_time - start_time:.2f} seconds")
    print(f"Total successful purchases (MUA_THANH_CONG): {len(success_count)}")
    if len(success_count) > 1:
        print(">>> WARNING: RACE CONDITION DETECTED! <<<")
        print("Multiple users successfully bought the exact same single item!")
        print("This leads to Negative Stock (Kho bị ÂM)!!!")
    elif len(success_count) == 1:
        print("SUCCESS: Only one user could buy the item. No race condition.")
    else:
        print("No one bought it. Check the server.")
