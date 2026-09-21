import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')
token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'
url = f'https://api.figma.com/v1/files/{file_key}/nodes?ids=1836:24330&depth=6'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

def dump_texts(node, depth=0):
    if node.get('type') == 'TEXT':
        print(f"{'  '*depth}{node.get('name')}: '{node.get('characters', '')}'")
    for c in node.get('children', []):
        dump_texts(c, depth+1)

dump_texts(data['nodes']['1836:24330']['document'])
