# Treinamento PDAD

# Bibliotecas ------------------------------------------------------------------

install.packages("RODBC")
install.packages("DBI")
install.packages("survey")
install.packages("srvyr")
install.packages("sidrar")
install.packages("dplyr")
install.packages("scales")

library(RODBC)  # Conexão com servidor de banco de dados
library(DBI)    # Conexão com servidor de banco de dados
library(survey) # Desenho da amostra complexa da Pdad
library(srvyr)  # Desenho da amostra complexa da Pdad
library(sidrar) # Desenho da amostra complexa da Pdad
library(dplyr)  # Necessária para transformar variáveis
library(tidyverse) # Manipulação de dados
library(ggplot2) # Fazer uns grafícos maneiro

# Diretorio --------------------------------------------------------------------

getwd()
setwd("C:\\Users\\VD11740\\Downloads\\PDAD\\2018")


# Importando PDAD --------------------------------------------------------------

# Chama o servidor DB_CODEPLAN e atribui ao objeto 'db'
# uid = " Seu ID do ipedf "
# pwd = " senha "

#db <- RODBC::odbcConnect("DB_CODEPLAN", uid="codeplan", pwd="codeplan")
#tabelas <- RODBC::sqlTables(db)

# Importe as tabelas pelo 'Environment' no canto inferior esquerdo em 'import Dataset' ----

# arruamndo os nomes -----------------------------------------------------------

pdad_2018_moradores <- PDAD_2018.Moradores_33RAs
pdad_2018_domicilios <- PDAD_2018.Domicilios_33RAs
  
rm(PDAD_2018.Domicilios_33RAs, PDAD_2018.Moradores_33RAs)

# selecionando as colunas e filtrando RA ---------------------------------------
paranoa <- pdad_2018_moradores %>%
  select(A01ra, E03, E04) %>%
  filter(A01ra == 7)

# Renomeando as colunas --------------------------------------------------------
paranoa <- paranoa %>%
  rename(ra = A01ra,
         sexo = E03,
         raca = E04)

# isolando masculino e feminino ------------------------------------------------
# masculino
m <- paranoa %>%
  select(sexo, raca) %>%
  filter(sexo == 1)

# feminino
f <- paranoa %>%
  select(sexo, raca) %>%
  filter(sexo == 2)

# Masculino raça ---------------------------------------------------------------
M_branca <- m %>% 
 filter(raca == 1)
M_branca <- sum(M_branca$raca)

M_preto <- m %>% 
  filter(raca == 2)
M_preto <- sum(M_preto$raca)/2

M_amarela <- m %>% 
  filter(raca == 3)
M_amarela <- sum(M_amarela$raca)/3

M_parda <- m %>% 
  filter(raca == 4)
M_parda <- sum(M_parda$raca)/4

M_indigena <- m %>%
  filter(raca == 5)
M_indigena <- 2

# feminino raça ----------------------------------------------------------------

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
F_indigena <- 2

# datas frames------------------------------------------------------------------

# Vetor raça masculina
raca_m <- c(M_branca, M_preto, M_amarela, M_parda, M_indigena)
raca_m2 <- c("branca", "Preto", "Amarela", "Parda", "Indigena")

# Data.frame Maculino
xy <- data.frame(
  raca_masculina = raca_m2,
  qtd = raca_m)

# Vetor raça feminina
raca_f <- c("branca", "Preto", "Amarela", "Parda", "Indigena")
raca_f2 <- c(F_branca, F_preto, F_amarela, F_parda, F_indigena)

# Data.frame feminina
xx <- data.frame(
  raca_femininca = raca_f,
  qtd = raca_f2)

# exclui todas as variaveis que não precisa mais
rm(F_branca, F_preto, F_amarela, F_parda, F_indigena, M_branca, M_preto, 
   M_amarela, M_parda, M_indigena, raca_f, raca_f2, raca_m, raca_m2)

# Juntando as tabelas ----------------------------------------------------------

# tabela final
tabelafinal_racas <- data.frame(xy, xx)

# renomendo colunas quantidades
tabelafinal_racas <- tabelafinal_racas %>%
  rename(qtd_m = qtd,
         qtd_f = qtd.1)

# grafico ----------------------------------------------------------------------

# Raça Masculinha

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
  scale_x_continuous(
    breaks = NULL
  ) +
  theme_bw()

# visualizar grafico
print(grafico)

# Raça feminina

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
  scale_x_continuous(
    breaks = NULL
  ) +
  theme_bw()

# visualizar grafico
print(grafico2)

# Opcional: remover todos os dados desnecessarios

# rm(f, m, paranoa, xx, xy)







