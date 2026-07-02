
## Description

The objective of this project is to examine whether a relationship exists between the proportion of employees in the primary sector and annual gross income across Austrian municipalities. To investigate this research question, spatial statistical methods are implemented in R and applied to analyze the data.

## Project Structure

### Data Files
- `STATISTIK_AUSTRIA_GEM_20260101.shp` Austrian Gemeinden (municipalities) (Gliederung Österreich 2026)
- `sector_1.csv` - Share of employment in the primary sector in 2020 (Anteil der Beschäftigten im Sektor I 2020)
- `income.csv` - Annual gross salary 2011 (Jahresbruttobezug 2011)
- `population.csv` - Population statistics 2020 (Bevölkerungs 2020)
- `apprenticeship.csv` - Apprenticeship (Anteil der Bevölkerung mit Lehrlabschluss 2020)
- `compulsory_education.csv` - Compulsory education attainment (Anteil der Bevölkerung mit Pflichtschulabschluss 2020)
- `secondary_school.csv` - Secondary school completion rates (Anteil der Bevölkerung mit BMS Abschluss 2020)
- `academic_secondary.csv` - Academic secondary education rates (Anteil der Bevölkerung mit AHS Abschluss 2020)
- `higher_vocational_education.csv` - Higher vocational training data (Anteil der Bevölkerung mit BHS Abschluss 2020)
- `higher_education.csv` - Higher education attainment (Anteil der Bevölkerung mit Hochschulabschluss 2020)
- `bland.csv` - Federal states (Bundesländer von Österreich) 

### Code
- `austrian_income_sector_analysis.R` - Main R script for statistical analysis and visualization

## Requirements

- R (version 3.6.0 or higher)
- Required R packages:
  - `tidyverse` (for data manipulation and visualization)
  - `ggplot2` (for plotting)
  - `dplyr` (for data wrangling)
  - `corrplot` (for correlation analysis)
  - `sf` (for handling spatial vector data)
  - `spatialreg` (for spatial regression models)
  - `spdep` (for spatial dependence analysis)
  - `purrr` (for functional programming)
  - `scales` (for axis and legend formatting)
  - `stargazer` (for regression tables)
  - `here` (for reproducible file paths)
  - `rstudioapi` (for interacting with the RStudio IDE)

## Installation & Usage

1. Clone the repository:
```bash
git clone <repository-url>
cd The-relationship-between-primary-sector-employment-and-income-in-Austria
```

2. Open R and set your working directory:
```r
setwd("path/to/project")
```

3. Install required packages (if not already installed):
```r
install.packages(c("tidyverse", "ggplot2", "dplyr", "corrplot"))
```

4. Run the analysis:
```r
source("austrian_income_sector_analysis.R")
```

## Analysis Overview

This project investigates:
- Correlation between primary sector employment and income levels
- Educational attainment patterns in Austria
- Demographic trends related to sector employment
- Statistical significance of relationships

## Results

### Key Findings
- Kurze Zusammenfassung der Hauptergebnisse
- Korrelation zwischen Sektor I Beschäftigung und Einkommenshöhe: [Wert]
- Räumliche Muster: [Befunde]

### Visualizations

| |
|---|
| <img width="942" height="944" alt="boxplott_bundesland" src="https://github.com/user-attachments/assets/d009b3b4-75e2-4b44-b4d6-9d4d81725aec" /> |
| **Figure 1:** The boxplot shows the distribution of annual gross income across Austrian municipalities, grouped by federal state. |

| |
|---|
|<img width="874" height="454" alt="einkommen" src="https://github.com/user-attachments/assets/01e7adfb-c7e1-46a5-a5d0-9a779e3aae65" /> |
| **Figure 2:** Average annual gross earnings of employees per the year (Euro) |
The income map at the municipal level shows clear differences between urban agglomerations such as Vienna and its surrounding areas, where higher incomes prevail, and rural municipalities, which tend to have lower income levels.

| |
|---|
| <img width="871" height="427" alt="sektor1" src="https://github.com/user-attachments/assets/440347b8-e2a1-41b0-894f-28e5f468a696" /> |
| **Figure 3:** Proportion of employees in Sector I (Agriculture and Forestry) in % |
The opposite pattern is observed in the distribution of the share of employees in the primary sector in Austria. Here, the proportion of people employed in the primary sector is higher in rural areas than in urban regions. This raises the question of whether the share of employment in the primary sector has an impact on wage levels.

| |
|---|
| <img width="929" height="884" alt="moran" src="https://github.com/user-attachments/assets/44ad1d4c-c70e-4844-9a88-d08d862df448" /> |
| **Figure 4:** Moran's I |

**Spatial Autocorrelation: Moran's I Test**

The spatial autocorrelation of the income data was evaluated using a Moran's I test under the assumption of randomization, utilizing a **Queen contiguity** weights matrix.

| Parameter | Value |
| :--- | :--- |
| **Data** | `data$income` |
| **Weights Matrix** | Queen |
| **Moran I Statistic ($I$)** | `0.6273237850` |
| **Expectation ($E[I]$)** | `-0.0004748338` |
| **Variance ($Var[I]$)** | `0.0001739132` |
| **Standard Deviate ($z$)** | `47.605` |
| **p-value** | `< 2.2e-16` |
| **Alternative Hypothesis** | Greater (Positive Spatial Autocorrelation) |

For the calculation of Moran’s I, a Queen contiguity matrix was constructed and applied to the income data. The Moran’s I statistic yields a value of 0.627 with a p-value below 0.05, indicating a statistically significant positive spatial autocorrelation.



**Spatial Autocorrelation: Geary's C Test**

The local/spatial dissimilarity of the income data was evaluated using a Geary's C test under the assumption of randomization, utilizing a **Queen contiguity** weights matrix.

| Parameter | Value |
| :--- | :--- |
| **Data** | `data$income` |
| **Weights Matrix** | Queen |
| **Geary C Statistic ($C$)** | `0.351749677` |
| **Expectation ($E[C]$)** | `1.000000000` |
| **Variance ($Var[C]$)** | `0.000312162` |
| **Standard Deviate ($z$)** | `36.69` |
| **p-value** | `< 2.2e-16` |
In contrast to Moran’s I, Geary’s C captures local spatial differences. The results indicate variations in income and suggest the presence of spatial clustering.


| |
|---|
| <img width="947" height="595" alt="getisord" src="https://github.com/user-attachments/assets/b78d273a-b632-4872-a8f6-e25acce35270" /> |
| **Figure 5:** Local Getis-Ord's G |


The analysis produces several outputs:
- Correlation matrices and heat maps
- Spatial autocorrelation results (Moran's I, Geary's C)
- Regression model comparisons (OLS, SAR, SEM, SDM)
- Regional maps showing primary sector employment patterns

### Model Summary
| Model | Coefficient | R² | Spatial Significance |
|-------|-------------|-----|----------------------|
| OLS | ... | ... | ... |
| SAR | ... | ... | ... |
| SEM | ... | ... | ... |
| SDM | ... | ... | ... |

## License

This project is provided as-is for educational and research purposes.

## Author

Academic Analysis Project - Austria Economic Data

---

For questions or contributions, feel free to open an issue or submit a pull request.
