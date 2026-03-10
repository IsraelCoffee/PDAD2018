# Treinamento PDAD

# Bibliotecas ------------------------------------------------------------------

# Instalação dos pacotes necessários (só precisa rodar uma vez)
install.packages("RODBC")
install.packages("DBI")
install.packages("survey")
install.packages("srvyr")
install.packages("sidrar")
install.packages("dplyr")
install.packages("scales")

# Carregamento das bibliotecas que serão usadas no script
library(RODBC)    # Permite conexão com bancos de dados via ODBC
library(DBI)      # Interface mais moderna para conexão com bancos de dados
library(survey)   # Pacote para trabalhar com amostras complexas (usado na PDAD)
library(srvyr)    # Versão "tidy" do survey – facilita uso com dplyr
library(sidrar)   # Para baixar dados do SIDRA/IBGE (não usado neste script)
library(dplyr)    # Manipulação de dados no estilo "pipe" (%>%)
library(tidyverse)# Conjunto de pacotes para ciência de dados (inclui ggplot2, dplyr, etc.)
library(ggplot2)  # Criação de gráficos

# Diretorio --------------------------------------------------------------------

# Define o diretório onde estão os arquivos da PDAD 2018
setwd("C:\\seu caminho")

# Mostra qual é o diretório de trabalho atual
getwd()

# Importando PDAD --------------------------------------------------------------

# (As linhas abaixo estão comentadas – eram usadas para conectar ao banco de dados)
# db <- RODBC::odbcConnect("DB_CODEPLAN", uid="codeplan", pwd="codeplan")
# tabelas <- RODBC::sqlTables(db)

# Nota: os dados já foram importados manualmente pelo ambiente do R
# (provavelmente via "Import Dataset" no RStudio)
# Os objetos já existem no ambiente: PDAD_2018.Moradores_33RAs e PDAD_2018.Domicilios_33RAs


# arrumando os nomes -----------------------------------------------------------

# Renomeia os objetos longos para nomes mais curtos e práticos
pdad_2018_moradores <- PDAD_2018.Moradores_33RAs
pdad_2018_domicilios <- PDAD_2018.Domicilios_33RAs

# Remove os objetos originais com nomes grandes para liberar memória e organizar
rm(PDAD_2018.Domicilios_33RAs, PDAD_2018.Moradores_33RAs)


# selecionando as colunas e filtrando RA ---------------------------------------

# Filtra apenas os moradores da RA = 7 (Paranoá)
# e seleciona apenas as variáveis de interesse: RA, sexo e raça/cor
paranoa <- pdad_2018_moradores %>%
  select(A01ra, E03, E04) %>%
  filter(A01ra == 7)


# Renomeando as colunas --------------------------------------------------------

# Dá nomes mais claros e intuitivos às variáveis
paranoa <- paranoa %>%
  rename(ra   = A01ra,
         sexo = E03,
         raca = E04)


# isolando masculino e feminino ------------------------------------------------

# Cria base apenas com homens (sexo == 1)
m <- paranoa %>%
  select(sexo, raca) %>%
  filter(sexo == 1)

# Cria base apenas com mulheres (sexo == 2)
f <- paranoa %>%
  select(sexo, raca) %>%
  filter(sexo == 2)


# Masculino raça ---------------------------------------------------------------

# Conta quantos homens de cada cor/raça (usando um método manual e não ideal)

M_branca <- m %>% 
  filter(raca == 1)
M_branca <- sum(M_branca$raca)           # = número de brancos (cada 1 soma 1)

M_preto <- m %>% 
  filter(raca == 2)
M_preto <- sum(M_preto$raca)/2           # divide por 2 para "contar" (cada 2 vira 1)

M_amarela <- m %>% 
  filter(raca == 3)
M_amarela <- sum(M_amarela$raca)/3       # divide por 3

M_parda <- m %>% 
  filter(raca == 4)
M_parda <- sum(M_parda$raca)/4           # divide por 4

M_indigena <- m %>%
  filter(raca == 5)
M_indigena <- 2                          # valor fixo (dado real pequeno)


# feminino raça ----------------------------------------------------------------

# Mesma lógica para mulheres

F_branca <- f %>% 
  filter(raca == 1)
F_branca <- sum(F_branca$raca)

F_preto <- f %>% 
  filter(raca == 2)
F_preto <- sum(F_preto$raca)/2

F_amarela <- f %>% 
  filter(raca == 3)
F_amarela <- sum(F_amarela$raca)/3

F_parda <- f %>% 
  filter(raca == 4)
F_parda <- sum(F_parda$raca)/4

F_indigena <- f %>% 
  filter(raca == 5)
F_indigena <- 2                          # novamente valor fixo


# datas frames------------------------------------------------------------------

# Cria vetor com as quantidades de homens por raça
raca_m <- c(M_branca, M_preto, M_amarela, M_parda, M_indigena)
raca_m2 <- c("branca", "Preto", "Amarela", "Parda", "Indigena")

# Cria data.frame para homens
xy <- data.frame(
  raca_masculina = raca_m2,
  qtd = raca_m
)

# Cria vetor com nomes e quantidades para mulheres
raca_f <- c("branca", "Preto", "Amarela", "Parda", "Indigena")
raca_f2 <- c(F_branca, F_preto, F_amarela, F_parda, F_indigena)

# Cria data.frame para mulheres
xx <- data.frame(
  raca_femininca = raca_f,
  qtd = raca_f2
)


# exclui todas as variaveis que não precisa mais
rm(F_branca, F_preto, F_amarela, F_parda, F_indigena, M_branca, M_preto, 
   M_amarela, M_parda, M_indigena, raca_f, raca_f2, raca_m, raca_m2)


# Juntando as tabelas ----------------------------------------------------------

# Junta as duas tabelas (masculino e feminino) lado a lado
tabelafinal_racas <- data.frame(xy, xx)

# Renomeia as colunas de quantidade para ficar mais claro
tabelafinal_racas <- tabelafinal_racas %>%
  rename(qtd_m = qtd,
         qtd_f = qtd.1)


# grafico ----------------------------------------------------------------------

# Gráfico de barras horizontal – Homens
grafico <- tabelafinal_racas %>%
  ggplot(aes(x = qtd_m, y = raca_masculina)) +
  geom_col(fill = "#4e79a7", width = 0.7, stat = "identity", position = "dodge") +
  geom_text(aes(x = qtd_m, y = raca_masculina, label = qtd_m),
            position = position_dodge(width = 1), size = 2.5,
            vjust = 0.4, hjust = -0.1, angle = 0) +
  labs(
    title = "Masculino",
    y = NULL,
    x = NULL,
    caption = "fonte: IPEDF/PDAD-2018"
  ) +
  scale_x_continuous(breaks = NULL) +
  theme_bw()

# Exibe o gráfico
print(grafico)


# Gráfico de barras horizontal – Mulheres
grafico2 <- tabelafinal_racas %>%
  ggplot(aes(x = qtd_f, y = raca_femininca)) +
  geom_col(fill = "#ff7ea7", width = 0.7, stat = "identity", position = "dodge") +
  geom_text(aes(x = qtd_f, y = raca_femininca, label = qtd_f),
            position = position_dodge(width = 1), size = 2.5,
            vjust = 0.4, hjust = -0.1, angle = 0) +
  labs(
    title = "Feminino",
    y = NULL,
    x = NULL,
    caption = "fonte: IPEDF/PDAD-2018"
  ) +
  scale_x_continuous(breaks = NULL) +
  theme_bw()

# Exibe o gráfico
print(grafico2)


# Opcional: remover todos os dados desnecessarios
# rm(f, m, paranoa, xx, xy)

