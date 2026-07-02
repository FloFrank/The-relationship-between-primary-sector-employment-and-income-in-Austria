
## Description

The objective of this project is to examine whether a relationship exists between the proportion of employees in the primary sector and annual gross income across Austrian municipalities. To investigate this research question, spatial statistical methods are implemented in R and applied to analyze the data.

![R](https://img.shields.io/badge/R-4.0+-276DC3?logo=r)
![Spatial](https://img.shields.io/badge/Analysis-Spatial%20Econometrics-blue)
![SAR/SEM](https://img.shields.io/badge/Models-SAR%20%7C%20SEM%20%7C%20SDM%20%7C%20SLX-blueviolet)
![Statistics](https://img.shields.io/badge/Tests-Moran%20%7C%20Geary%20%7C%20Getis--Ord-orange)
![Data](https://img.shields.io/badge/Data%20Source-Statistik%20Austria-green)
![License](https://img.shields.io/badge/License-CC0-red)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

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

## **Results and Visualizations**

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
The map shows the Local Getis-Ord Gi* statistics and reveals clear clustering patterns in income levels in Austria. In particular, the north-western surroundings of Vienna stand out as the area with the highest incomes in the country.


### **OLS-Model**

The OLS model was estimated using the following variables, where the dependent variable is income and the independent variables are sector_1, compulsory_education, apprenticeship, academic_secondary, higher_vocational_education, population_density, and higher_education.

## OLS Regression Results (Income Predictors)

The baseline Ordinary Least Squares (OLS) regression model analyzes the impact of socio-economic factors and education levels on income (`data$income`). 

### Model Summary Table

| Predictor (Variable) | Estimate ($\beta$) | Std. Error | t-value | p-value | Significance |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **(Intercept)** | 26,227.92 | 1,781.93 | 14.719 | $< 2\times 10^{-16}$ | *** |
| **sector_1** (Primary Sector) | -19.03 | 4.87 | -3.909 | $9.55\times 10^{-5}$ | *** |
| **compulsory_education** | 30.96 | 23.06 | 1.343 | 0.1795 | |
| **apprenticeship** | 80.38 | 22.57 | 3.562 | 0.0004 | *** |
| **academic_secondary** | 153.26 | 48.81 | 3.140 | 0.0017 | ** |
| **higher_vocational_education**| 533.29 | 37.22 | 14.328 | $< 2\times 10^{-16}$ | *** |
| **population_density** | -43.41 | 4.80 | -9.039 | $< 2\times 10^{-16}$ | *** |
| **higher_education** | 563.45 | 23.63 | 23.845 | $< 2\times 10^{-16}$ | *** |

*Significance codes: `0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1*

###  Model Diagnostics

*   **R-squared ($R^2$):** `0.6884` | **Adjusted $R^2$:** `0.6874`
    *   *Interpretation:* The model explains approximately **68.7%** of the variance in income.
*   **Residual Standard Error:** `2,487` on `2,099` degrees of freedom.
*   **F-statistic:** `662.4` ($p < 2.2\times 10^{-16}$) 
    *   *Interpretation:* The overall model is highly statistically significant.

The results clearly indicate that higher levels of education increase income, while factors such as high population density or a high share of employment in the primary sector tend to reduce it. Only compulsory education alone shows no statistically detectable effect on income.

## **Lagrange-Multiplier-Test**
| |
|---|
| <img width="642" height="395" alt="Screenshot 2026-07-02 134640" src="https://github.com/user-attachments/assets/6db23abb-d982-4e7f-94d4-b81c15debcf5" /> |
| **Figure 6:** RSerr (Spatial Error) and RSlag (Spatial Lag) |

| |
|---|
|<img width="659" height="386" alt="Screenshot 2026-07-02 134929" src="https://github.com/user-attachments/assets/3159b9b6-1094-4779-a564-4ee4321a9007" /> |
| **Figure 7:** adjRSerr (Adjusted Spatial Error) and adjRSlag (Adjusted Spatial Lag) |
As the tests show, at a high level of statistical significance, spatial autocorrelation is present in the OLS model, indicating that a spatial model needs to be applied.


## **Spatial modeling (spatial regression)**

**SAR-Model**

| |
|---|
| <img width="600" height="522" alt="Screenshot 2026-07-02 140141" src="https://github.com/user-attachments/assets/40a44c9f-408c-491f-a0e0-bf65ce7befb1" /> |
| **Figure 8:** SAR-Model |

| |
|---|
| <img width="555" height="179" alt="Screenshot 2026-07-02 140346" src="https://github.com/user-attachments/assets/24591869-763c-4112-af5a-78a1a0e58295" /> |
| **Figure 9:** SAR-Model Impacts |


**SEM-Model**
| |
|---|
| <img width="615" height="511" alt="Screenshot 2026-07-02 140553" src="https://github.com/user-attachments/assets/d191b692-265b-4123-bc18-9589ee2e9d8d" /> |
| **Figure 10:** SEM-Model |


**SDM-Model**
| |
|---|
| <img width="607" height="671" alt="Screenshot 2026-07-02 140739" src="https://github.com/user-attachments/assets/73f4cf96-93a6-4663-92e2-4a5ef83234d5" /> |
| **Figure 11:** SDM-Model |



**SLX-Model**
| |
|---|
| <img width="670" height="391" alt="Screenshot 2026-07-02 140920" src="https://github.com/user-attachments/assets/19485adf-159f-4ed8-a3fb-9026182e28de" /> |
| **Figure 11:** SLX-Model |


| |
|---|
| <img width="552" height="756" alt="Screenshot 2026-07-02 140939" src="https://github.com/user-attachments/assets/e3f147bf-6047-4ef9-8e30-820852788c0b" /> |
| **Figure 12:** SLX-Model |

## **Calculate and compare AIC values**
| |
|---|
| <img width="552" height="756" alt="Screenshot 2026-07-02 140939" src="https://github.com/user-attachments/assets/e3f147bf-6047-4ef9-8e30-820852788c0b" /> |
| **Figure 13:** Akaike information criterion (AIC)|
The AIC results show that the SAR model has the lowest value and is therefore the most suitable model.

## Data Sources

*   **Azizoglu, Bert Mustafa, und Edith Waltner.** (2008). *Branchen- und sektorspezifische Einkommensunterschiede in Österreich.*
*   **Statistik Austria.** (2011). *Jahresbruttobezug 2011.*
*   **Statistik Austria.** (2020). *Anteil der Beschäftigten im Sektor I 2020.*
*   **Statistik Austria.** (2020). *Anteil der Bevölkerung mit Pflichtschulabschluss 2020.*
*   **Statistik Austria.** (2020). *Anteil der Bevölkerung mit Lehrabschluss 2020.*
*   **Statistik Austria.** (2020). *Anteil der Bevölkerung mit BMS-Abschluss 2020.*
*   **Statistik Austria.** (2020). *Anteil der Bevölkerung mit AHS-Abschluss 2020.*
*   **Statistik Austria.** (2020). *Anteil der Bevölkerung mit Hochschulabschluss 2020.*
*   **Statistik Austria.** (2026). *Gliederung Österreich in Gemeinden 2026.*

## License

This project is provided as-is for educational and research purposes.

## Author

Florian Frank 2026 

---

For questions or contributions, feel free to open an issue or submit a pull request.
