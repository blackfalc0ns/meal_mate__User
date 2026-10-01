import urllib.request
import json
import sys

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'
url = f'https://api.figma.com/v1/files/{file_key}/nodes?ids=3338:6830,3338:7142'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

for nid, ndata in data.get('nodes', {}).items():
    doc = ndata.get('document', {})
    print(nid, 'Name:', doc.get('name'), 'Type:', doc.get('type'))

img_url = f'https://api.figma.com/v1/images/{file_key}?ids=3338:6830,3338:7142&scale=1&format=png'
req2 = urllib.request.Request(img_url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req2) as resp2:
    img_data = json.loads(resp2.read().decode('utf-8'))

for nid, iurl in img_data.get('images', {}).items():
    print(nid, '->', iurl)
    if iurl:
        fname = f"scratch/figma_{nid.replace(':', '_')}.png"
        urllib.request.urlretrieve(iurl, fname)
        print('Saved', fname)
