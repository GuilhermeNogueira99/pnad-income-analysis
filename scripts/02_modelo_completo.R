setwd("D:/Usuários/Guilherme/OneDrive/Documentos/economia-do-cuidado-renda-pnad")
source("scripts/01_preprocessamento.R")

# Carrega o pré-processamento
dados <- preprocessamento_pnad("dados/PNADC_012025.gz")

# Análise exploratória  
summary(dados$renda_efetiva)
hist(dados$renda_efetiva, breaks=100, xlim=c(0, 50000), main="Renda Efetiva (Zoom até 50k)")
boxplot(dados$renda_efetiva, main="Boxplot - Renda Efetiva")

# Definir limite superior de renda (outliers)
limite_superior <- quantile(dados$renda_efetiva[dados$renda_efetiva > 0], 0.995, na.rm = TRUE)

# Filtragem e transformação dos dados para o modelo
dados_modelo <- dados %>%
  filter(
    renda_efetiva > 0,
    renda_efetiva <= limite_superior,
    idade >= 15, idade <= 80,
    anos_de_estudo <= 25,
    horas_efetivas >= 0, horas_efetivas <= 80
  ) %>%
  na.omit() %>%
  mutate(
    log_renda = log(renda_efetiva),
    contrib_previdencia = factor(contrib_previdencia),
    UF = factor(UF),
    sexo = factor(sexo),
    raca_cor = factor(raca_cor),
    nivel_instrucao = factor(nivel_instrucao)
  )
  
# Remoção de níveis não utilizados
dados_modelo <- droplevels(dados_modelo)

# Verificação dos níveis após limpeza
sapply(dados_modelo[, sapply(dados_modelo, is.factor)], function(x) length(unique(x)))

# Modelo linear com log da renda como resposta
modelo_log <- lm(log_renda ~ idade + anos_de_estudo + horas_efetivas + sexo + raca_cor + nivel_instrucao + UF + contrib_previdencia,
                 data = dados_modelo)

# Sumário do modelo
summary(modelo_log)

# Diagnóstico de multicolinearidade
vif(modelo_log)

# Gráficos de diagnóstico do modelo
par(mfrow=c(2,2))
plot(modelo_log)
par(mfrow=c(1,1))


# Função para interpretar coeficientes logarítmicos (exceto intercepto)
interpretar_coeficientes <- function(modelo) {
  coefs <- summary(modelo)$coefficients
  coefs_df <- as.data.frame(coefs)
  coefs_df$Variavel <- rownames(coefs_df)
  colnames(coefs_df)[1] <- "Estimativa"
  
  coefs_df <- coefs_df[coefs_df$Variavel != "(Intercept)", ]
  
  coefs_df$Variacao_percentual <- round((exp(coefs_df$Estimativa) - 1) * 100, 1)
  
  coefs_df$Interpretacao <- ifelse(
    coefs_df$Variacao_percentual >= 0,
    paste0("+", coefs_df$Variacao_percentual, "% de renda em média"),
    paste0(coefs_df$Variacao_percentual, "% de renda em média")
  )
  
  return(coefs_df[, c("Variavel", "Estimativa", "Variacao_percentual", "Interpretacao")])
}

# Função no modelo
interpreta <- interpretar_coeficientes(modelo_log)

# Resultados
print(interpreta, row.names = FALSE)

# Ver os coeficientes diretamente
coef(modelo_log)

# Interpretar os coeficientes como variações percentuais
impacto_percentual <- exp(coef(modelo_log)) - 1
round(impacto_percentual * 100, 2)

# Função para interpretar
interpretar_coeficientes <- function(modelo) {
  coefs <- summary(modelo)$coefficients
  coefs_df <- as.data.frame(coefs)
  coefs_df$Variavel <- rownames(coefs_df)
  colnames(coefs_df)[1] <- "Estimativa"
  coefs_df <- coefs_df[coefs_df$Variavel != "(Intercept)", ]
  coefs_df$Variacao_percentual <- round((exp(coefs_df$Estimativa) - 1) * 100, 1)
  coefs_df$Interpretacao <- ifelse(
    coefs_df$Variacao_percentual >= 0,
    paste0("+", coefs_df$Variacao_percentual, "% de renda em média"),
    paste0(coefs_df$Variacao_percentual, "% de renda em média")
  )
  return(coefs_df[, c("Variavel", "Estimativa", "Variacao_percentual", "Interpretacao")])
}

# Verifica se a pasta existe e cria se não existir
if (!dir.exists("output")) {
  dir.create("output")
}

# Salva o arquivo dentro da pasta
write.csv(interpreta, "output/interpretacoes_modelo_log.csv", row.names = FALSE)
