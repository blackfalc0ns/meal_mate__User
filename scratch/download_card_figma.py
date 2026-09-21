import urllib.request, json, sys
sys.stdout.reconfigure(encoding='utf-8')

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'
url = f'https://api.figma.com/v1/images/{file_key}?ids=1836:6580,1836:6638&scale=2&format=png'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))
images = data.get('images', {})
for nid, img_url in images.items():
    print(nid, '->', img_url)
    if img_url:
        fname = f"scratch/figma_{nid.replace(':', '_')}.png"
        urllib.request.urlretrieve(img_url, fname)
        print('Downloaded', fname)
