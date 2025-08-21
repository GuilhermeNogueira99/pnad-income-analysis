# PNAD Income Regression

**Status do Projeto:** 🚧 *Em desenvolvimento*

Este projeto tem como objetivo analisar os fatores associados à renda efetiva total dos brasileiros a partir dos microdados da PNAD Contínua (IBGE). Foi utilizado um modelo de regressão linear múltipla com transformação logarítmica para explicar a variação da renda a partir de variáveis sociodemográficas e características do trabalho.

## 📊 Base de Dados

- **Fonte**: PNAD Contínua – IBGE
- **Amostra**: Indivíduos ocupados no mercado de trabalho
- **Variável dependente**: Renda efetiva total (log transformada)

## 🛠️ Pré-processamento

- Filtragem de observações válidas
- Criação de variáveis categóricas com rótulos
- Exclusão de valores inconsistentes
- Aplicação de transformação logarítmica na renda

## 📈 Variáveis utilizadas no modelo

- Sexo
- Raça/Cor
- UF (Unidade da Federação)
- Nível de Instrução
- Formalização no emprego
- Contribuição para a Previdência

## 📉 Análises realizadas

- Análise Exploratória dos dados
- Ajuste de modelo de regressão log-linear
- Interpretação dos coeficientes
- Verificação de multicolinearidade (VIF)
- Análise dos resíduos

## 📁 Estrutura do Projeto (parcial)
📦pnad-income-regression
┣ 📜PNAD_Modelo_Completo.Rmd
┣ 📜PNAD_Modelo_Q2_Q3.R
┣ 📊/data/
┃ ┗ 📄pnad_data.csv
┣ 📈/outputs/
┃ ┗ 📄graficos_residuos.png
┗ 📄README.md

> ⚠️ **Nota**: O projeto está em desenvolvimento e receberá novos commits em breve, incluindo melhorias no modelo, refatoração de código e adição de análises complementares.

## 🚀 Como executar

1. Instale os pacotes necessários (veja no início do `.Rmd`)
2. Execute o RMarkdown `PNAD_Modelo_Completo.Rmd` para gerar o relatório
3. Execute o script `PNAD_Modelo_Q2_Q3.R` para os testes de robustez por quartis

## 📚 Tecnologias Utilizadas

- R
- R Markdown
- Tidyverse
- GGPlot2
- Car (para VIF)

## 🎓 Objetivo Educacional

Este projeto foi desenvolvido com fins educacionais, como parte da formação prática em análise de dados e estatística aplicada com microdados oficiais.

## 👤 Autor

**Guilherme Nogueira**  
Estudante de Estatística | Bolsista de pesquisa FUNCAP  

---

