import json
import sys

with open('scratch/figma_2300_9456.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

node = data['nodes']['2300:9456']['document']

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
    
    fills = n.get('fills', [])
    fills_info = []
    for fill in fills:
        if fill.get('type') == 'SOLID' and 'color' in fill:
            c = fill['color']
            r, g, b = int(c.get('r', 0)*255), int(c.get('g', 0)*255), int(c.get('b', 0)*255)
            a = fill.get('opacity', c.get('a', 1))
            fills_info.append(f'#{r:02x}{g:02x}{b:02x}({a:.2f})')
        elif fill.get('type') == 'IMAGE':
            fills_info.append('IMAGE')
    fill_str = f' [fills: {", ".join(fills_info)}]' if fills_info else ''
    
    strokes = n.get('strokes', [])
    strokes_info = []
    for s in strokes:
        if s.get('type') == 'SOLID' and 'color' in s:
            c = s['color']
            r, g, b = int(c.get('r', 0)*255), int(c.get('g', 0)*255), int(c.get('b', 0)*255)
            strokes_info.append(f'#{r:02x}{g:02x}{b:02x}')
    stroke_str = f' [strokes: {", ".join(strokes_info)}]' if strokes_info else ''

    cr = n.get('cornerRadius', '')
    cr_str = f' [radius: {cr}]' if cr else ''
    
    style = n.get('style', {})
    font_info = ''
    if style:
        font_info = f' [font: {style.get("fontFamily")}, size: {style.get("fontSize")}, weight: {style.get("fontWeight")}]'

    node_id = n.get('id', '')
    print(f'{indent}- [{node_id}] {name} ({ntype}, {w:.1f}x{h:.1f}){text_info}{fill_str}{stroke_str}{cr_str}{layout}{font_info}')
    for c in n.get('children', []):
        walk(c, depth + 1)

with open('scratch/social_connections_tree.txt', 'w', encoding='utf-8') as out:
    orig = sys.stdout
    sys.stdout = out
    walk(node)
    sys.stdout = orig

print('Saved scratch/social_connections_tree.txt')
