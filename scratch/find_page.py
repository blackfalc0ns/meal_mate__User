import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')
token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'

url = f'https://api.figma.com/v1/files/{file_key}/nodes?ids=2300:6242&depth=2'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

node = data['nodes']['2300:6242']['document']
for child in node.get('children', []):
    print(child.get('id'), ':', child.get('name'), child.get('type'))
