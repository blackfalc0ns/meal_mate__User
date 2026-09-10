import json

with open('scratch/figma_1836_21945.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

node = data['nodes']['1836:21945']['document']

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
    if 'paddingTop' in n:
        layout += f' pad(T:{n.get("paddingTop",0)},R:{n.get("paddingRight",0)},B:{n.get("paddingBottom",0)},L:{n.get("paddingLeft",0)})'
    
    # Check fills
    fills = n.get('fills', [])
    fills_info = []
    for fill in fills:
        if fill.get('type') == 'SOLID' and 'color' in fill:
            c = fill['color']
            r, g, b = int(c.get('r', 0)*255), int(c.get('g', 0)*255), int(c.get('b', 0)*255)
            a = fill.get('opacity', c.get('a', 1))
            fills_info.append(f'#{r:02x}{g:02x}{b:02x}({a:.2f})')
    fill_str = f' [fills: {", ".join(fills_info)}]' if fills_info else ''
    
    cr = n.get('cornerRadius', '')
    cr_str = f' [radius: {cr}]' if cr else ''

    print(f'{indent}- {name} ({ntype}, {w:.1f}x{h:.1f}){text_info}{fill_str}{cr_str}{layout}')
    for c in n.get('children', []):
        walk(c, depth + 1)

with open('scratch/node_tree.txt', 'w', encoding='utf-8') as out:
    import sys
    orig = sys.stdout
    sys.stdout = out
    walk(node)
    sys.stdout = orig

print("Tree written to scratch/node_tree.txt")
