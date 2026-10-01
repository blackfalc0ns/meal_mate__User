import urllib.request
import json
import sys
sys.stdout.reconfigure(encoding='utf-8')

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'
url = f'https://api.figma.com/v1/files/{file_key}/nodes?ids=3338:6830,3338:7142'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

for nid, val in data.get('nodes', {}).items():
    doc = val.get('document', {})
    print('=== NODE:', nid, doc.get('name'), '===')
    def walk(n, depth=0):
        indent = '  ' * depth
        print(f"{indent}{n.get('id')}: {n.get('name')} [{n.get('type')}]")
        if depth < 4:
            for c in n.get('children', []):
                walk(c, depth + 1)
    walk(doc)
