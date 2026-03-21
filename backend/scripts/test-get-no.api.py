import requests
import json

BASE_URL = "http://127.0.0.1:8000/api"

# ==========================================
# 🛑 CONFIGURE THESE WITH REAL DATABASE DATA
# ==========================================
CWSN_TOKEN = "33cf7867f97b2fcc8103c78aa067795f3b075325"
CAREGIVER_TOKEN = "86ff339b0119b92a6c616d298c07196338151d0e"

CAREGIVER_PROFILE_ID = 1  
SERVICE_ID = 1            
CHILD_ID = 1              
# ==========================================

def get_headers(token=None):
    headers = {'Content-Type': 'application/json'}
    if token:
        headers['Authorization'] = f'Token {token}'
    return headers

def fetch_and_check_contact(scenario_name, token, profile_id, expected_status):
    """Helper to fetch profile and print the contact number status."""
    url = f"{BASE_URL}/users/caregiver-profiles/{profile_id}/"
    response = requests.get(url, headers=get_headers(token))
    
    if response.status_code == 200:
        contact = response.json().get('contact_no', 'MISSING_FIELD')
        print(f"[{scenario_name}] Contact output: '{contact}'")
        if expected_status in contact:
            print("   ✅ PASS: Behaved exactly as expected.")
        elif contact != "Hidden (Login required)" and contact != "Hidden (Send request to view)":
             print("   ✅ PASS: Actual number is visible!")
        else:
            print(f"   ❌ FAIL: Expected '{expected_status}' logic, got '{contact}'")
    else:
        print(f"[{scenario_name}] ❌ API Error {response.status_code}: {response.text}")

def run_interaction_test():
    print("======================================================")
    print("🕵️‍♂️ Starting End-to-End Contact Visibility Test")
    print("======================================================\n")

    # ---------------------------------------------------------
    # EDGE CASE 1: Guest User
    # ---------------------------------------------------------
    print("➡️ STEP 1: Guest views profile")
    fetch_and_check_contact("GUEST", None, CAREGIVER_PROFILE_ID, "Login required")
    print("-" * 54)

    # ---------------------------------------------------------
    # EDGE CASE 2: Logged-in Parent (No Request Sent Yet)
    # ---------------------------------------------------------
    print("➡️ STEP 2: Parent views profile (No request)")
    fetch_and_check_contact("PARENT (NO REQUEST)", CWSN_TOKEN, CAREGIVER_PROFILE_ID, "Send request to view")
    print("-" * 54)

    # ---------------------------------------------------------
    # EDGE CASE 3: Parent Sends a Request (Status: Pending)
    # ---------------------------------------------------------
    print("➡️ STEP 3: Parent sends a service request")
    req_url = f"{BASE_URL}/interactions/requests/"
    payload = {"service": SERVICE_ID, "child": CHILD_ID}
    
    response = requests.post(req_url, headers=get_headers(CWSN_TOKEN), json=payload)
    request_id = None
    
    if response.status_code == 201:
        request_id = response.json().get('id')
        print(f"   ✅ Request created successfully! (ID: {request_id})")
    elif response.status_code == 400 and "non_field_errors" in response.text:
        # Handling the unique_together constraint gracefully
        print("   ⚠️ Request already exists for this child/service combination.")
        print("   Fetching existing request to continue testing...")
        
        # We find the existing request ID to continue the test
        get_req = requests.get(req_url, headers=get_headers(CWSN_TOKEN))
        for req in get_req.json():
            if req['service'] == SERVICE_ID and req['child'] == CHILD_ID:
                request_id = req['id']
                # Reset status to Pending just in case it was accepted/rejected from a previous run
                # (Note: standard API doesn't have a direct "reset to pending" endpoint, 
                # but we will proceed with the ID we found).
                break
        if not request_id:
            print("   ❌ Fatal Error: Could not find the existing request ID. Aborting.")
            return
    else:
        print(f"   ❌ Failed to create request: {response.status_code} {response.text}")
        return

    print("\n➡️ STEP 3b: Parent views profile (Request is Pending)")
    fetch_and_check_contact("PARENT (PENDING)", CWSN_TOKEN, CAREGIVER_PROFILE_ID, "Send request to view")
    print("-" * 54)

    # ---------------------------------------------------------
    # EDGE CASE 4: Caregiver Accepts the Request
    # ---------------------------------------------------------
    print("➡️ STEP 4: Caregiver accepts the request")
    accept_url = f"{BASE_URL}/interactions/requests/{request_id}/accept/"
    accept_res = requests.post(accept_url, headers=get_headers(CAREGIVER_TOKEN))
    
    if accept_res.status_code == 200:
        print("   ✅ Request accepted by Caregiver.")
    else:
        print(f"   ❌ Failed to accept: {accept_res.status_code} {accept_res.text}")
        return

    print("\n➡️ STEP 4b: Parent views profile (Request is ACCEPTED)")
    # THIS IS THE MAGIC MOMENT - The number should be visible!
    fetch_and_check_contact("PARENT (ACCEPTED)", CWSN_TOKEN, CAREGIVER_PROFILE_ID, "Visible")
    print("-" * 54)

    # ---------------------------------------------------------
    # EDGE CASE 5: Caregiver Rejects the Request
    # ---------------------------------------------------------
    print("➡️ STEP 5: Caregiver changes mind and rejects the request")
    reject_url = f"{BASE_URL}/interactions/requests/{request_id}/reject/"
    reject_res = requests.post(reject_url, headers=get_headers(CAREGIVER_TOKEN))
    
    if reject_res.status_code == 200:
        print("   ✅ Request rejected by Caregiver.")
    else:
        print(f"   ❌ Failed to reject: {reject_res.status_code} {reject_res.text}")

    print("\n➡️ STEP 5b: Parent views profile (Request is REJECTED)")
    # It should hide the number again
    fetch_and_check_contact("PARENT (REJECTED)", CWSN_TOKEN, CAREGIVER_PROFILE_ID, "Send request to view")
    print("-" * 54)

    # ---------------------------------------------------------
    # EDGE CASE 6: Caregiver views their own profile
    # ---------------------------------------------------------
    print("➡️ STEP 6: Caregiver views their own profile")
    fetch_and_check_contact("CAREGIVER (OWNER)", CAREGIVER_TOKEN, CAREGIVER_PROFILE_ID, "Visible")
    print("======================================================")

if __name__ == "__main__":
    run_interaction_test()