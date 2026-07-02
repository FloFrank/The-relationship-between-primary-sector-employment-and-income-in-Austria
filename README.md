# The Relationship Between Primary Sector Employment and Income in Austria

## Description

This project analyzes the relationship between employment in the primary sector (agriculture, forestry, fishing) and income levels in Austria. The analysis uses statistical methods in R to explore correlations and trends between primary sector employment rates and household or personal income.

## Project Structure

### Data Files
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

## License

This project is provided as-is for educational and research purposes.

## Author

Academic Analysis Project - Austria Economic Data

---

For questions or contributions, feel free to open an issue or submit a pull request.
