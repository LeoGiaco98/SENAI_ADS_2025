from rich.console import Console
from rich.table import Table
import pandas as pd

console = Console(width=200)
table = Table(title="Amostras Temperadas", show_lines=True)

arquivo = pd.read_csv('arquivos_csv/amostras.csv')
arquivo["Amostra"] = arquivo["Amostra"].astype(str)
arquivo.rename(columns={"Amostra": "ID"}, inplace=True)

variaveis = ['ID', 'Diâmetro', 'Altura', 'Massa', 'Res. Mecânica', 'T', 'Área', 'Volume', 'Densidade', 'Tensão Mec.']
unidades = {
    "Diâmetro" : "(mm)",
    "Altura" : "(mm)",
    "Massa" : "(g)",
    "Res. Mecânica" : "(kgf)",
    "T" : "(Área / Altura)",
    "Área" : "(mm²)",
    "Volume" : "(mm³)",
    "Densidade" : "(g/mm³)",
    "Tensão Mec." : "(kgf/mm²)"
}
for var in variaveis:
    unidade = unidades.get(var, "")
    table.add_column(f"{var} {unidade}".strip(),justify="center", min_width=10)
for _, linha in arquivo.iterrows():
    valores = []
    for var in variaveis:
        valor = linha[var]
        if isinstance(valor, float):
            if var == "Densidade":
                valor = round(valor, 6)
            else:
                valor = round(valor, 2)
        valores.append(str(valor))
    table.add_row(*valores)

console.print(table)