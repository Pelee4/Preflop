import sys
import re

def rename_labels(input_file, output_file, prefix):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Lista de etiquetas a renombrar
    labels_to_rename = [
        'order_cnt', 'order1', 'order2', 'order3', 'order4',
        'duty_instruments', 'wave_instruments', 'noise_instruments',
        'routines', 'waves'
    ]
    
    # Renombrar etiquetas principales
    for label in labels_to_rename:
        content = re.sub(rf'\b{label}\b', f'{prefix}_{label}', content)
    
    # Renombrar patrones (P0-P99)
    content = re.sub(r'\bP(\d+)\b', rf'{prefix}_P\1', content)
    
    # Renombrar instrumentos
    content = re.sub(r'\bitSquare(inst\d+)\b', rf'{prefix}_itSquare\1', content)
    content = re.sub(r'\bitWave(inst\d+)\b', rf'{prefix}_itWave\1', content)
    content = re.sub(r'\bitSquare(SP\d+)\b', rf'{prefix}_itSquare\1', content)
    content = re.sub(r'\bitWave(SP\d+)\b', rf'{prefix}_itWave\1', content)
    
    # Renombrar rutinas hUGE
    content = re.sub(r'\b__hUGE_Routine_(\d+)\b', rf'{prefix}__hUGE_Routine_\1', content)
    content = re.sub(r'\b__end_hUGE_Routine_(\d+)\b', rf'{prefix}__end_hUGE_Routine_\1', content)
    
    # Renombrar waves
    content = re.sub(r'\bwave(\d+)\b', rf'{prefix}_wave\1', content)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✓ Archivo procesado: {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python rename_song.py <archivo_entrada> <archivo_salida> <prefijo>")
        print("Ejemplo: python rename_song.py dead_theme.asm dead_theme_fixed.asm dead_theme")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    prefix = sys.argv[3]
    
    rename_labels(input_file, output_file, prefix)