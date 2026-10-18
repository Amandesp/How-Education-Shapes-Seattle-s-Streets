
# How Education Shapes Seattle's Streets

## Executive Summary

This project explores the relationship between education, household income, and violent crime across Seattle neighborhoods. Using Seattle crime data and neighborhood-level American Community Survey (ACS) estimates, we created visualizations to examine socioeconomic patterns and differences across selected neighborhoods.

The goal was to better understand how education and economic conditions relate to neighborhood crime patterns through data analysis and visualization.

## Research Question

**How do household income and education levels relate to violent crime across Seattle neighborhoods?**

## Visualizations

### Figure A: Seattle Crime Trends (2020–2025)

Examines reported crime categories in Seattle from 2020 through 2025, with a focus on violent crime and comparisons with property crime and other offenses.

### Figure B: Poverty Levels Across Seattle Neighborhoods

Compares the number of residents within selected income-to-poverty-ratio categories across seven Seattle neighborhoods using 2024 ACS five-year estimates.

### Figure C: Household Income Distribution

Compares household counts across income brackets below $100,000 in seven Seattle neighborhoods using 2024 ACS five-year estimates.

### Figure D: Education Levels Across Seattle Neighborhoods

Explores educational attainment across selected Seattle neighborhoods using neighborhood-level ACS data.

## Key Findings

- **Crime data includes multiple offense categories.** The analysis distinguishes violent crime from property crime and other offenses to provide context for reported crime patterns between 2020 and 2025.
- **Poverty patterns differ across neighborhoods.** The 2024 ACS estimates show differences in the number of residents within the selected income-to-poverty-ratio categories. For example, High Point has 841 people in the category with an income-to-poverty ratio below 0.50.
- **Household income distributions vary.** Comparing income brackets across neighborhoods helps reveal differences in the number of households within lower income ranges.
- **Educational attainment provides additional socioeconomic context.** Comparing education levels across neighborhoods allows educational patterns to be considered alongside income and crime data.

These findings are descriptive. The visualizations help identify differences and patterns, but they do not establish that income or education causes changes in crime rates.

## Data Sources

The project uses publicly available Seattle neighborhood and crime datasets.

- **Crime Data:** [Seattle Police Department Crime Data (2008–Present)](https://data.seattle.gov/Public-Safety/SPD-Crime-Data-2008-Present/tazs-3rd5/about_data)
- **Education Data:** [Education – Seattle Neighborhoods](https://data-seattlecitygis.opendata.arcgis.com/datasets/SeattleCityGIS::education-seattle-neighborhoods/explore)
- **Poverty Data:** [Poverty and Employment Status – Seattle Neighborhoods](https://data-seattlecitygis.opendata.arcgis.com/datasets/SeattleCityGIS::poverty-and-employment-status-seattle-neighborhoods/explore)
- **Income Data:** [Seattle City GIS Open Data](https://data-seattlecitygis.opendata.arcgis.com/search?collection=dataset)

## Methodology

The project involved cleaning and preparing datasets, selecting relevant variables and neighborhoods, and creating visualizations in R.

Key steps included:

- Cleaning column names and preparing datasets for analysis.
- Filtering crime records to examine the 2020–2025 period and removing records with missing or unknown neighborhood labels.
- Selecting relevant income, poverty, and education variables.
- Comparing selected neighborhoods using bar charts and other visualizations.
- Using `ggplot2` to communicate patterns with clear labels, legends, and color schemes.

## Tools and Skills

- **R and RStudio** — data cleaning, transformation, and analysis
- **tidyverse** — data manipulation and visualization
- **ggplot2** — chart creation and customization
- **janitor** — consistent column-name formatting
- **lubridate** — date parsing and handling
- **Data storytelling** — communicating patterns through visualizations
- **Collaborative research** — coordinating analysis and presentation work

## What This Project Demonstrates

This project demonstrates the ability to work with multiple public datasets, clean and transform data, compare neighborhood-level indicators, and communicate findings through visualizations. It also highlights the importance of choosing appropriate comparisons and recognizing limitations when interpreting real-world data.

## My Contributions

My contributions included data analysis, data preparation, and visualization development. I worked with crime data, helped determine neighborhood selections for the analysis, contributed to the methodology and R code, and created and refined visualizations, particularly the household income distribution chart (Figure C).

I also contributed to project updates, reviewing the presentation, and improving how the analysis and findings were communicated. The project was completed collaboratively with the other group members.

## Limitations

- **Different data vintages:** The poverty and income charts use 2024 ACS five-year estimates, while the education dataset uses a different vintage. The datasets may not represent exactly the same period.
- **Neighborhood differences:** Neighborhoods vary in population and household counts, which affects comparisons based on raw totals.
- **Counts versus rates:** The visualizations primarily compare counts, not population-adjusted crime rates. Higher counts do not necessarily indicate a higher individual risk of experiencing crime.
- **Correlation versus causation:** The analysis is descriptive and cannot establish that education or income causes crime patterns.
- **Crime reporting:** Recorded crime data reflects reported and documented incidents and may not capture every incident that occurs.

## Project Information

- **Course:** B DATA 200
- **Institution:** University of Washington Bothell
- **Original Poster Date:** May 28, 2025
- **Project Type:** Collaborative Data Analysis and Visualization
