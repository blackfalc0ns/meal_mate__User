import urllib.request
import json
import os

token = 'figd_AhdDuMzb5xv8f3_kbfa5OLdpOYK0QQtm2fBdRyTV'
file_key = 'OSfVgAwRxYbu8lJmpXOPXC'

# Nodes:
# YouTube: 2300:9519
# Snapchat: 2300:9533
# Safe lock: 2300:9547
# Also let's check TikTok: 2300:9463, Instagram: 2300:9478, WhatsApp: 2300:9493, Telegram: 2300:9507

icons = {
    '2300:9519': 'influencer_social_youtube.svg',
    '2300:9533': 'influencer_social_snapchat.svg',
    '2300:9547': 'influencer_privacy_shield.svg',
    '2300:9463': 'influencer_social_tiktok.svg',
    '2300:9478': 'influencer_social_instagram.svg',
    '2300:9493': 'influencer_social_whatsapp.svg',
    '2300:9507': 'influencer_social_telegram.svg',
}

ids_str = ','.join(icons.keys())
url = f'https://api.figma.com/v1/images/{file_key}?ids={ids_str}&format=svg'
req = urllib.request.Request(url, headers={'X-Figma-Token': token})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode('utf-8'))

images = data.get('images', {})
out_dir = 'assets/images/influencer/figma'
os.makedirs(out_dir, exist_ok=True)

for nid, filename in icons.items():
    img_url = images.get(nid)
    print(nid, filename, '->', img_url)
    if img_url:
        dl_req = urllib.request.Request(img_url, headers={'User-Agent': 'Mozilla/5.0'})
        target_path = os.path.join(out_dir, filename)
        with urllib.request.urlopen(dl_req) as dl_resp:
            content = dl_resp.read()
            with open(target_path, 'wb') as f:
                f.write(content)
        print(f'Saved {filename} ({len(content)} bytes)')
