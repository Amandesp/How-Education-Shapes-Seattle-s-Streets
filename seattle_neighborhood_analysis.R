getwd()
setwd("~/Desktop/R Project")

library(tidyverse)
library(janitor)
library(lubridate)

# Import and standardize column names for the crime, education, and poverty data.
# Income data retains its original column names, so uppercase names are used below.
seattle <- read_csv("spd_crime.csv", show_col_types = FALSE) |>
  clean_names()

education <- read_csv("education_neighborhood.csv", show_col_types = FALSE) |>
  clean_names()

poverty <- read_csv("poverty_neighborhoods.csv", show_col_types = FALSE) |>
  clean_names()

income_data <- read_csv("incomes_neighborhoods.csv", show_col_types = FALSE)

# Use the same neighborhood set for the poverty and income comparisons.
neighborhoods <- c(
  "Arbor Heights",
  "Duwamish/SODO",
  "High Point",
  "Highland Park",
  "North Delridge",
  "Roxhill/Westwood",
  "South Park"
)


# ------------------------------------------------------
# Figure A: Violent crime by neighborhood, 2020–2025
# ------------------------------------------------------

# Parse the offense date, extract the year, and standardize neighborhood names.
# mdy_hm() converts date-time text in month/day/year hour:minute format to a date.
# year() extracts the calendar year; str_to_lower() and str_trim() standardize names.
crime_by_year <- seattle |>
  mutate(
    offense_date_parsed = mdy_hm(offense_date),
    year = year(offense_date_parsed),
    neighborhood_clean = str_to_lower(str_trim(neighborhood))
  ) |>
  # Keep violent-crime records from 2020 through 2025 and remove unknown areas.
  filter(
    offense_category == "VIOLENT CRIME",
    between(year, 2020, 2025),
    !neighborhood_clean %in% c("-", "unknown")
  ) |>
  # Create one group for each year-neighborhood combination.
  group_by(year, neighborhood_clean) |>
  # Count rows in each group; each row represents one crime record.
  summarise(violent_crimes = n(), .groups = "drop")

# Start Figure A. ggplot() defines the dataset and aesthetic mappings:
# year is on the x-axis, crime count is on the y-axis, and neighborhood controls color.
figure_a <- ggplot(
  crime_by_year,
  aes(
    x = year,
    y = violent_crimes,
    color = neighborhood_clean,
    group = neighborhood_clean
  )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_x_continuous(breaks = 2020:2025) +
  scale_color_discrete(labels = \(x) str_to_upper(x)) +
  labs(
    title = "Neighborhoods of Violent Crime",
    x = "Year",
    y = "Number of Violent Crimes",
    color = "Neighborhood"
  ) +
  # Apply a clean background and position/format chart elements.
  theme_minimal() +
  theme(
    legend.position = "right",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(figure_a)


# ------------------------------------------------------
# Figure B: Poverty ratio by neighborhood, 2024 ACS data
# ------------------------------------------------------

# Keep the 2024 ACS five-year estimates for Seattle Community Reporting Areas.
# The selected columns count people in each income-to-poverty ratio category;
# they are counts, not percentages or an overall neighborhood poverty rate.
poverty_plot_data <- poverty |>
  # Filter to the desired ACS vintage, geography type, and neighborhoods.
  filter(
    acs_vintage == "5Y24",
    neighborhood_type == "CRA",
    neighborhood_name %in% neighborhoods
  ) |>
  # Keep only the neighborhood name and the three ratio-category columns used in Figure B.
  select(
    neighborhood_name,
    people_with_income_to_poverty_ratio_under_50,
    people_with_income_to_poverty_50_to_99,
    people_with_income_to_poverty_1_00_to_1_24
  ) |>
  # Convert the three category columns into rows so ggplot can map them to bar colors.
  pivot_longer(
    cols = starts_with("people_with_income_to_poverty"),
    names_to = "poverty_category",
    values_to = "people"
  ) |>
  # Replace long source-column names with readable legend labels,
  # then set the category order and neighborhood order used in the chart.
  mutate(
    poverty_category = recode(
      poverty_category,
      people_with_income_to_poverty_ratio_under_50 = "<0.50",
      people_with_income_to_poverty_50_to_99 = "0.50–0.99",
      people_with_income_to_poverty_1_00_to_1_24 = "1.00–1.24"
    ),
    poverty_category = factor(
      poverty_category,
      levels = c("<0.50", "0.50–0.99", "1.00–1.24")
    ),
    neighborhood_name = factor(
      neighborhood_name,
      levels = neighborhoods
    )
  )

# Start Figure B. Each neighborhood has one bar per poverty-ratio category.
# The fill aesthetic assigns a separate color to each category.
figure_b <- ggplot(
  poverty_plot_data,
  aes(x = neighborhood_name, y = people, fill = poverty_category)
) +
  # Draw side-by-side bars using the counts in the "people" column.
  geom_col(position = "dodge") +
  # Set explicit colors so the legend colors remain consistent across runs.
  scale_fill_manual(
    values = c(
      "<0.50" = "#66C2A5",
      "0.50–0.99" = "#FC8D62",
      "1.00–1.24" = "#8DA0CB"
    )
  ) +
  # Add the title, data vintage, axis labels, and legend title.
  labs(
    title = "Poverty Ratio by Neighborhoods",
    subtitle = "2024 ACS 5-year estimates",
    x = "Neighborhood",
    y = "Number of People",
    fill = "Income-to-Poverty Ratio"
  ) +
  # Use a minimal theme, angle long neighborhood names, and place the legend on the right.
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )

# Display Figure B in the RStudio Plots pane.
print(figure_b)


# ------------------------------------------------------
# Figure C: Household income by neighborhood, 2024 ACS data
# ------------------------------------------------------

# Use total household income categories for the selected neighborhoods.
# Income ranges above $99,999 are excluded to match the seven brackets shown
# in the reconstructed poster.
income_plot_data <- income_data |>
  # Filter to 2024 ACS data, Community Reporting Areas, total households,
  # the seven selected neighborhoods, and the income brackets shown in the poster.
  filter(
    ACS_VINTAGE == "5Y24",
    NEIGH_TYPE == "CRA",
    Type == "Household",
    NEIGH_NAME %in% neighborhoods,
    Income_Range %in% c(
      "<$10k",
      "$10k-$14.9k",
      "$15k-$24.9k",
      "$25k-$34.9k",
      "$35k-$49.9k",
      "$50k-$74.9k",
      "$75k-$99.9k"
    )
  ) |>
  # Set the bracket order so bars and legend appear in a consistent sequence.
  mutate(
    Income_Range = factor(
      Income_Range,
      levels = c(
        "$10k-$14.9k",
        "$15k-$24.9k",
        "$25k-$34.9k",
        "$35k-$49.9k",
        "$50k-$74.9k",
        "$75k-$99.9k",
        "<$10k"
      )
    )
  )

# Start Figure C. The x-axis is neighborhood, the y-axis is household count,
# and fill color distinguishes each household-income bracket.
figure_c <- ggplot(
  income_plot_data,
  aes(x = NEIGH_NAME, y = Households, fill = Income_Range)
) +
  # Place income-bracket bars side by side instead of stacking them.
  geom_col(position = position_dodge(width = 0.85), width = 0.8) +
  # Choose fixed colors and readable legend labels for each income bracket.
  scale_fill_manual(
    values = c(
      "$10k-$14.9k" = "#F8766D",
      "$15k-$24.9k" = "#C49A00",
      "$25k-$34.9k" = "#53B400",
      "$35k-$49.9k" = "#00C094",
      "$50k-$74.9k" = "#00B6EB",
      "$75k-$99.9k" = "#A58AFF",
      "<$10k" = "#FB61D7"
    ),
    labels = c(
      "$10k-$14.9k" = "Household Income $10,000 to $14,999",
      "$15k-$24.9k" = "Household Income $15,000 to $24,999",
      "$25k-$34.9k" = "Household Income $25,000 to $34,999",
      "$35k-$49.9k" = "Household Income $35,000 to $49,999",
      "$50k-$74.9k" = "Household Income $50,000 to $74,999",
      "$75k-$99.9k" = "Household Income $75,000 to $99,999",
      "<$10k" = "Household Income Less than $10,000"
    )
  ) +
  # Label the chart and identify the ACS data period.
  labs(
    title = "Household Income by Neighborhoods",
    subtitle = "2024 ACS 5-year estimates",
    x = "Neighborhood",
    y = "Number of Households",
    fill = "Income Bracket"
  ) +
  # Format the chart; put the legend below the plot and split it across two rows.
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 8),
    legend.title = element_text(size = 9),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  ) +
  # Arrange legend entries across two rows, reading left to right.
  guides(fill = guide_legend(nrow = 2, byrow = TRUE))

# Display Figure C in the RStudio Plots pane.
print(figure_c)


# ------------------------------------------------------
# Figure D: Educational attainment by neighborhood
# ------------------------------------------------------

# Keep the selected Community Reporting Areas and reshape the education
# categories into a long format so they can be shown as grouped bars.
education_plot_data <- education |>
  # Standardize neighborhood names before filtering.
  mutate(neighborhood_clean = str_to_lower(str_trim(neighborhood_name))) |>
  # Keep only the selected areas and Community Reporting Area records.
  filter(
    neighborhood_type == "CRA",
    neighborhood_clean %in% c(
      "arbor heights",
      "high point",
      "highland park",
      "north delridge",
      "roxhill/westwood",
      "south park"
    )
  ) |>
  # Select the neighborhood label and the seven education-attainment count columns.
  select(
    neighborhood_name,
    less_than_9th_grade,
    x9th_to_12th_grade_no_diploma,
    high_school_graduate_includes_equivalency,
    some_college_no_degree,
    associate_degree,
    bachelor_degree,
    graduate_or_professional_degree
  ) |>
  # Reshape the data: one row per neighborhood and education category.
  # The category name goes into education_level; its count goes into residents.
  pivot_longer(
    cols = -neighborhood_name,
    names_to = "education_level",
    values_to = "residents"
  ) |>
  # Replace source column names with labels suitable for the chart legend.
  mutate(
    education_level = recode(
      education_level,
      less_than_9th_grade = "Less than 9th grade",
      x9th_to_12th_grade_no_diploma = "9th–12th grade, no diploma",
      high_school_graduate_includes_equivalency = "High school graduate",
      some_college_no_degree = "Some college, no degree",
      associate_degree = "Associate degree",
      bachelor_degree = "Bachelor degree",
      graduate_or_professional_degree = "Graduate or professional degree"
    )
  )

# Start Figure D. Each neighborhood has one bar for every education category.
figure_d <- ggplot(
  education_plot_data,
  aes(x = neighborhood_name, y = residents, fill = education_level)
) +
  # Draw grouped bars so education categories can be compared within neighborhoods.
  geom_col(position = "dodge") +
  # Add a title, axis labels, and a legend title.
  labs(
    title = "Education Level by Neighborhood",
    subtitle = "ACS 5-year estimates (vintage in source data)",
    x = "Neighborhood",
    y = "Number of Residents",
    fill = "Education Level"
  ) +
  # Keep the styling consistent with the other figures and place the legend below.
  theme_minimal() +
  theme(
    legend.position = "bottom",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Display Figure D in the RStudio Plots pane.
print(figure_d)

