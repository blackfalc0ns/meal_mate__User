import json

with open('scratch/figma_1836_25625.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

node = data['nodes']['1836:25625']['document']

def walk(n, depth=0):
    indent = '  ' * depth
    name = n.get('name', '')
    ntype = n.get('type', '')
    chars = n.get('characters', '')
    bbox = n.get('absoluteBoundingBox', {})
    w, h = bbox.get('width', 0), bbox.get('height', 0)
    text_info = f' text: "{chars}"' if chars else ''
    layout = ''
    if 'itemSpacing' in n:
        layout += f' gap:{n["itemSpacing"]}'
    
    print(f'{indent}- {name} ({ntype}, {w:.1f}x{h:.1f}){text_info}{layout}')
    for c in n.get('children', []):
        walk(c, depth + 1)

with open('scratch/access_node_tree.txt', 'w', encoding='utf-8') as out:
    import sys
    orig = sys.stdout
    sys.stdout = out
    walk(node)
    sys.stdout = orig

print('Saved scratch/access_node_tree.txt')
