library(dplyr)
library(tidyr)
library(survey)
library(ggplot2)
library(car)

# Define o diretório
getwd()
setwd("D:/Usuários/Guilherme/OneDrive/Documentos/economia-do-cuidado-renda-pnad")

# Função de diagnóstico das variáveis principais
preprocessamento_diagnostico <- function(arquivo_rds) {
  dados_brutos <- readRDS(file = arquivo_rds)
  cat("\n\n--- INICIANDO DIAGNÓSTICO DO ARQUIVO .RDS ---\n\n")
  
  variaveis <- c("V2007", "V2010", "VD3004", "VD4002")
  
  for (var in variaveis) {
    cat("### Análise da Coluna", var, ":\n")
    cat("Tipo de dado (class): ", class(dados_brutos[[var]]), "\n")
    cat("Primeiros 6 valores: \n")
    print(head(dados_brutos[[var]]))
    cat("Tabela de Frequência (incluindo NAs):\n")
    print(table(dados_brutos[[var]], useNA = "ifany"))
    cat("\n----------------------------------------\n\n")
  }
}

# Diagnóstico inicial
preprocessamento_diagnostico("dados/PNADC_012025.gz")

# Função de pré-processamento
preprocessamento_pnad <- function(arquivo_rds) {
  dados_brutos <- readRDS(file = arquivo_rds)
  dados_finais <- dados_brutos %>%
    transmute(
      peso = V1028,
      upa = UPA,
      estrato = Estrato,
      idade = as.integer(V2009),
      sexo = V2007,
      raca_cor = V2010,
      UF = UF,
      nivel_instrucao = VD3004,
      anos_de_estudo = as.integer(VD3005),
      horas_efetivas = as.numeric(VD4035),
      renda_efetiva = as.numeric(VD4020),
      contrib_previdencia = VD4012
    )
  cat("Pré-processamento concluído com sucesso!\n")
  return(dados_finais)
}