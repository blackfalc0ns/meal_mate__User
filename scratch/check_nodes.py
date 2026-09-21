import urllib.request, json, sys
sys.stdout.reconfigure(encoding='utf-8')

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'
url = f'https://api.figma.com/v1/files/{file_key}/nodes?ids=1836:6608&depth=5'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))
doc = data['nodes']['1836:6608']['document']
def walk(n, d=0):
    name = n.get('name', '')
    t = n.get('type', '')
    chars = n.get('characters', '')
    c_info = f': "{chars}"' if chars else ''
    box = n.get('absoluteBoundingBox', {})
    print('  '*d + f'{name} ({t}){c_info} bbox:{box}')
    for c in n.get('children', []):
        walk(c, d+1)
walk(doc)

url_img = f'https://api.figma.com/v1/images/{file_key}?ids=1836:6608&scale=2&format=png'
req_img = urllib.request.Request(url_img, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req_img) as resp:
    data_img = json.loads(resp.read().decode('utf-8'))
img_url = data_img['images'].get('1836:6608')
if img_url:
    urllib.request.urlretrieve(img_url, 'scratch/figma_1836_6608.png')
    print('Downloaded scratch/figma_1836_6608.png')
