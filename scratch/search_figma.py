import urllib.request
import json

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'

url = f'https://api.figma.com/v1/files/{file_key}?depth=2'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

import sys
sys.stdout.reconfigure(encoding='utf-8')
for page in data['document']['children']:
    print('Page:', page.get('name'))
    for child in page.get('children', []):
        name = child.get('name', '')
        if any(w in name.lower() for w in ['social', 'connect', 'influen']):
            print('  -', child.get('id'), ':', name, child.get('type'))
