import requests
import json
from datetime import datetime, timedelta

# Adjust this to match your local or production server's base URL
BASE_URL = "http://127.0.0.1:8000/api" 

# Replace with a valid token from your database to test authenticated endpoints
AUTH_TOKEN = ""

# Updated list with app prefixes
ENDPOINTS = [
    # Common App
    "/common/regions/",
    "/common/categories/",
    "/common/disabilities/",
    "/common/languages/",
    
    # Services App
    "/services/services/",
    "/services/slots/",
    
    # Users App
    "/users/cwsn-profiles/",
    "/users/child-profiles/",
    "/users/caregiver-profiles/",
    
    # Interactions App
    "/interactions/requests/",
    "/interactions/reports/",
    "/interactions/upvotes/",
]

def get_headers():
    headers = {'Content-Type': 'application/json'}
    if AUTH_TOKEN:
        headers['Authorization'] = f'Token {AUTH_TOKEN}'
    return headers

def test_all_get_apis():
    print("======================================================")
    print(f"🚀 Starting API GET Health Check at: {BASE_URL}")
    print("======================================================\n")

    for endpoint in ENDPOINTS:
        url = f"{BASE_URL}{endpoint}"
        try:
            response = requests.get(url, headers=get_headers())
            status = response.status_code
            
            # Use color-coding based on success/failure for the terminal
            if 200 <= status < 300:
                status_display = f"✅ [{status} OK]"
            elif status == 401 or status == 403:
                status_display = f"🔒 [{status} UNAUTHORIZED]"
            else:
                status_display = f"❌ [{status} ERROR]"

            print(f"{status_display} GET {url}")

            # Parse and print response gracefully
            try:
                data = response.json()
                data_str = json.dumps(data)
                if len(data_str) > 150:
                    data_str = data_str[:150] + "... [truncated]"
                print(f"   ↳ Result: {data_str}")
            except ValueError:
                print(f"   ↳ Result: Non-JSON Response (Length: {len(response.text)} chars)")
            
        except requests.exceptions.RequestException as e:
            print(f"❌ [ERROR] GET {url}")
            print(f"   ↳ Exception: {e}")
            
        print("-" * 54)

def test_create_availability_slot():
    print("\n======================================================")
    print("📝 Testing POST: Create Availability Slot")
    print("======================================================")
    
    url = f"{BASE_URL}/services/slots/"
    
    # Calculate some future times for the slot
    start_time = (datetime.utcnow() + timedelta(days=1)).isoformat() + "Z"
    end_time = (datetime.utcnow() + timedelta(days=1, hours=1)).isoformat() + "Z"
    
    # Note: Ensure the "service" ID belongs to a service owned by the caregiver
    # associated with the AUTH_TOKEN, otherwise the API might reject it.
    payload = {
        "service": 3,  # Replace with a valid Service ID from your database
        "start_time": start_time,
        "end_time": end_time,
        "is_booked": False
    }

    try:
        response = requests.post(url, headers=get_headers(), json=payload)
        status = response.status_code
        
        if 200 <= status < 300:
            print(f"✅ [{status} CREATED] POST {url}")
        else:
            print(f"❌ [{status} ERROR] POST {url}")
            
        print(f"   ↳ Sent Payload: {json.dumps(payload)}")
        try:
            print(f"   ↳ Server Response: {json.dumps(response.json())}")
        except ValueError:
            print(f"   ↳ Server Response: {response.text}")

    except requests.exceptions.RequestException as e:
        print(f"❌ [ERROR] POST {url}")
        print(f"   ↳ Exception: {e}")
        
    print("-" * 54)

if __name__ == "__main__":
    test_all_get_apis()
    test_create_availability_slot()