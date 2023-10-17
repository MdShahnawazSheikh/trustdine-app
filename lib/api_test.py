import requests

api = requests.get("https://asia-south1-trustdine.cloudfunctions.net/api")

print(api.content)