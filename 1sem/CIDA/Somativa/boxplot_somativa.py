import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Funções boxplot
def Q1(var):
    return np.percentile(var, 25, method="averaged_inverted_cdf")

def Q3(var):
    return np.percentile(var, 75, method="averaged_inverted_cdf")

def DQ(var):
    return Q3(var) - Q1(var)

def limInf(var):
    return max(min(var), Q1(var) - 1.5 * DQ(var))

def limSup(var):
    return min(max(var), Q3(var) + 1.5 * DQ(var))

# Lê o novo arquivo calculado
df = pd.read_csv('arquivos_csv/amostras_calculadas.csv')

# Lista de variáveis para análise
variaveis = ['Diâmetro', 'Altura', 'Massa', 'Res. Mecânica', 'T', 'Área', 'Volume', 'Densidade', 'Tensão Mec.']

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

# Exibe cálculos estatísticos
print("_" * 29)
print("=== CÁLCULOS ESTATÍSTICOS ===")
print("\u0305" * 29)

for var in variaveis:
    valores = df[var]
    unidade = unidades[var]
    if var != "Densidade":
        print(f"{var} {unidade}:")
        print(f"\u00B7 Q1: {round(Q1(valores), 2)}")
        print(f"\u00B7 Q3: {round(Q3(valores), 2)}")
        print(f"\u00B7 DQ: {round(DQ(valores), 2)}")
        print(f"\u00B7 Limite Inferior: {round(limInf(valores), 2)}")
        print(f"\u00B7 Limite Superior: {round(limSup(valores), 2)}")
        print("")
        print("\u0305" * 29)
    else:
        print(f"{var} {unidade}:")
        print(f"\u00B7 Q1: {round(Q1(valores), 6)}")
        print(f"\u00B7 Q3: {round(Q3(valores), 6)}")
        print(f"\u00B7 DQ: {DQ(valores):.6f}")
        print(f"\u00B7 Limite Inferior: {round(limInf(valores), 6)}")
        print(f"\u00B7 Limite Superior: {round(limSup(valores), 6)}")
        print("")
        print("\u0305" * 29)

# Plota boxplots
plt.figure(figsize=(10, 15))
plt.suptitle('Boxplots das Variáveis')

for i, var in enumerate(variaveis):
    plt.subplot(3, 3, i+1)
    plt.boxplot(df[var], vert=True)
    plt.title(var)
    plt.ylabel(unidades[var])
    plt.xticks([])
    if var == 'Densidade':
        plt.tick_params(axis='y', labelsize=8)

plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1, hspace=0.4, wspace=0.4)
plt.show()

#Plota os histogramas
plt.figure(figsize=(15, 30))
plt.suptitle('Histogramas das Variáveis')

for i, var in enumerate(variaveis):
    plt.subplot(3, 3, i+1)
    plt.hist(df[var], bins=20, color='orange', edgecolor='black')
    plt.title(var)
    plt.ylabel(unidades[var])
    if var == 'Densidade':
        plt.tick_params(axis='x', labelsize=8)

plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1, hspace=0.25, wspace=0.3)
plt.show()

#Plota os gráficos de dispersão
plt.figure(figsize=(15, 30))
plt.suptitle('Dispersão das Variáveis')

for i, var in enumerate(variaveis):
    plt.subplot(3, 3, i+1)
    plt.scatter(range(len(df)), df[var], color='green', s=8)
    plt.title(var)
    plt.ylabel(unidades[var])
    plt.xticks([])
    if var == 'Densidade':
        plt.tick_params(axis='y', labelsize=8)

plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1, hspace=0.25, wspace=0.3)
plt.show()