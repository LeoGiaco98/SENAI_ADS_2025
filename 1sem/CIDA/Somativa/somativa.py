import pandas as pd
import numpy as np

arquivo = pd.read_csv('amostras_csv/amostras.csv')
arquivo["ID"] = arquivo["ID"].astype(str)

def calc_t(h, d):
    return h / d

def calc_area(d, h):
    r = d / 2
    return np.pi * r ** 2

def calc_volume(d, h):
    r = d / 2
    return np.pi * r ** 2 * h

def calc_den(m, v):
    return m / v

def calc_tensao(f, a):
    return f / a

dados_brutos = []
dados_arredondados = []

for _, linha in arquivo.iterrows():
    d = linha["Diâmetro"]
    h = linha["Altura"]
    m = linha["Massa"]
    f = linha["Res. Mecânica"]

    t = calc_t(h, d)
    area = calc_area(d, h)
    volume = calc_volume(d, h)
    densidade = calc_den(m, volume)
    tensao = calc_tensao(f, area)

    unidades = {
        "Diâmetro": "(mm)",
        "Altura": "(mm)",
        "Massa": "(g)",
        "Res. Mecânica": "(kgf)",
        "T": "(Área/Altura)",
        "Área": "(mm²)",
        "Volume": "(mm³)",
        "Densidade": "(g/mm³)",
        "Tensão Mec.": "(kgf/mm²)"
    }

    registro_dados_brutos = {
        'Amostra': linha["ID"],
        'Diâmetro': d,
        'Altura': h,
        'Massa': m,
        'Res. Mecânica': f,
        'T': t,
        'Área': area,
        'Volume': volume,
        'Densidade': densidade,
        'Tensão Mec.': tensao
    }

    registro_dados_arredondados = {
        'Amostra': linha["ID"],
        'Diâmetro': round(d, 2),
        'Altura': round(h, 2),
        'Massa': round(m, 2),
        'Res. Mecânica': round(f, 2),
        'T': round(t, 2),
        'Área': round(area, 2),
        'Volume': round(volume, 2),
        'Densidade': round(densidade, 6),
        'Tensão Mec.': round(tensao, 2)
    }

    dados_brutos.append(registro_dados_brutos)
    dados_arredondados.append(registro_dados_arredondados)

df_amostras_print = pd.DataFrame(dados_arredondados)
df_amostras_csv = pd.DataFrame(dados_brutos)

pd.set_option('display.max_columns', None)
pd.set_option('display.colheader_justify', 'center')
df_amostras_print.rename(columns={col: f"{col} {unidades[col]}" for col in unidades}, inplace=True)
print(df_amostras_print.to_string(index=False, col_space=12))

# df_amostras_csv.to_csv('amostras_calculadas.csv', index=False)