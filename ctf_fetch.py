import re
import requests

URL = "http://amiable-citadel.picoctf.net:52204/"

resp = requests.get(URL, headers={"X-Dev-Access": "yes"})
print(f"Status: {resp.status_code}\n")
print(resp.text)

flags = re.findall(r"picoCTF\{[^}]+\}", resp.text)
if flags:
    print(f"\nFound flag(s): {flags}")
else:
    print("\nNo picoCTF{...} flag found in response.")
