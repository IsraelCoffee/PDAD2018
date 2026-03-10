# Análise de Distribuição de Raça/Cor por Sexo – Paranoá (PDAD 2018)

Mini-projeto de análise exploratória da **Pesquisa Distrital por Amostra de Domicílios (PDAD 2018)** focado na **Região Administrativa de Paranoá (RA 07)**, Distrito Federal.

O objetivo é calcular e visualizar a **distribuição de raça/cor** separada por sexo (masculino e feminino) entre os moradores da região.

## Contexto

- **Base de dados**: PDAD 2018 (Pesquisa Distrital por Amostra de Domicílios – Codeplan/IPEDF)
- **Âmbito geográfico**: Apenas moradores da RA Paranoá (código A01ra == 7)
- **Variáveis principais utilizadas**:
  - `E03` → Sexo (1 = Masculino, 2 = Feminino)
  - `E04` → Raça/Cor (1 = Branca, 2 = Preta, 3 = Amarela, 4 = Parda, 5 = Indígena)

> **Atenção**: Este script **não utiliza os pesos amostrais** nem considera o desenho complexo da amostra (variáveis de ponderação, estratos, conglomerados).  
> Portanto os números são **contagens brutas** e **não representam estimativas populacionais oficiais**.

## Resultado esperado

Dois gráficos de barras horizontais (um para cada sexo) mostrando a quantidade de pessoas por categoria de raça/cor na base filtrada.

Exemplo visual aproximado:

**Masculino**  
Branca    ██████████  x

Parda     ██████████████████  y

Preta     █████  z

etc.

**Feminino**  
(visual similar com outra cor)

## Estrutura do projeto

PDAD-2018-Paranoa-Raca-Sexo/
├── PDAD-2018-RA7.R     # Script principal (R)

├── README.md           # Este arquivo

└── (dados)             # Não incluídos no repositório por questões de tamanho/privacidade

├── PDAD_2018.Moradores_33RAs.*

└── PDAD_2018.Domicilios_33RAs.*


## Como executar

1. Tenha instalado o **R** e o **RStudio** (ou outro editor de sua preferência)
2. Instale os pacotes necessários (já listados no script):

```r
install.packages(c("dplyr", "ggplot2", "tidyverse"))
# os demais (RODBC, survey, srvyr, sidrar) são usados apenas no contexto original


## Como executar

1. Tenha instalado o **R** e o **RStudio** (ou outro editor de sua preferência)
2. Instale os pacotes necessários (já listados no script):

```r
install.packages(c("dplyr", "ggplot2", "tidyverse"))
# os demais (RODBC, survey, srvyr, sidrar) são usados apenas no contexto original
Coloque os arquivos da PDAD 2018 na pasta do projeto ou ajuste o caminho em setwd()
Abra o arquivo PDAD2018.R e execute o script inteiro (ou por partes)

# Licença
Este material é disponibilizado para fins didáticos e de aprendizado.
Os dados originais da PDAD pertencem ao IPEDF/Codeplan e estão sujeitos às regras de uso e citação da instituição.
Fonte oficial dos dados: IPEDF/PDAD 2018
Feito com 💜 e bastante dplyr + ggplot2
Qualquer dúvida/sugestão → Issues ou Pull Requests são bem-vindos!

Espero que goste!  
Se quiser deixar mais curto, mais técnico, mais descontraído ou adicionar alguma seção específica (ex: prints dos gráficos, tabela de resultados), é só falar que ajusto rapidinho. Boa sorte com o repositório!
