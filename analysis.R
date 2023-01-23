# Load Libraries
library(tidyverse)
library(plotly)
library(viridis)
library(scales)


# Setup -----------------------------------------------------------------------
# Load Data
climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

# Process Data
climate_data_filtered <- climate_data %>%
  select(year, iso_code, country, co2, co2_per_capita, gdp, population) %>%
  filter(iso_code != "", iso_code != "OWID_WRL", iso_code != "ATA") %>%
  mutate(
    gdp_per_capita = gdp / population,
    gdp = gdp / (1e+09),
    population = population / (1e+06)
  )

# Summary Statistics --------------------------------------------------------

change_co2_emisions <- climate_data %>%
  filter(iso_code == "OWID_WRL", year %in%
    c(1950, 2018)) %>%
  select(year, cumulative_co2) %>%
  mutate(new_co2 = cumulative_co2 - lag(cumulative_co2)) %>%
  filter(year == 2018) %>%
  pull(new_co2) %>%
  round(digits = 0) %>%
  prettyNum(big.mark = ",", scientific = FALSE)

percent_change_co2_emisions <- climate_data %>%
  filter(iso_code == "OWID_WRL", year %in%
    c(1950, 2018)) %>%
  select(year, cumulative_co2) %>%
  mutate(change_co2 = ((cumulative_co2 -
    lag(cumulative_co2)) / lag(cumulative_co2)) * 100) %>%
  filter(year == 2018) %>%
  pull(change_co2) %>%
  round(digits = 0) %>%
  paste0("%")

avg_co2_per_captia <- climate_data_filtered %>%
  filter(year == 2018) %>%
  select(co2_per_capita) %>%
  summarise(mean = mean(co2_per_capita, na.rm = T)) %>%
  pull(mean) %>%
  round(digits = 2)

top_co2_emiter <- climate_data_filtered %>%
  filter(year == 2018) %>%
  filter(co2 == max(co2, na.rm = T)) %>%
  pull(country)

amnt_top_co2_emiter <- climate_data_filtered %>%
  filter(year == 2018) %>%
  filter(co2 == max(co2, na.rm = T)) %>%
  pull(co2) %>%
  round(digits = 0) %>%
  prettyNum(big.mark = ",", scientific = FALSE)

top_co2_emiter_per_capita <- climate_data_filtered %>%
  filter(year == 2018) %>%
  filter(co2_per_capita == max(co2_per_capita, na.rm = T)) %>%
  pull(country)

amnt_top_co2_emiter_per_capita <- climate_data_filtered %>%
  filter(year == 2018) %>%
  filter(co2_per_capita == max(co2_per_capita, na.rm = T)) %>%
  pull(co2) %>%
  round(digits = 2)

# Top CO2 Growth
country_co2_growth_2000_2018 <- climate_data_filtered %>%
  filter(year %in% c(2000, 2018)) %>%
  select(year, country, co2) %>%
  group_by(country) %>%
  arrange(year, .by_group = T) %>%
  summarise(change_co2 = ((last(co2) - first(co2)) / first(co2)) * 100) %>%
  filter(change_co2 == max(change_co2, na.rm = T))

top_co2_growth_2000_2018 <- country_co2_growth_2000_2018 %>% pull(country)

amnt_top_co2_growth_2000_2018 <- country_co2_growth_2000_2018 %>%
  pull(change_co2) %>%
  round(digits = 2) %>%
  paste0("%")


# Plot ---------------------------------------------------------------------

# Set Axis & Legends Size and Tooltip

total <- aes(
  x = gdp, y = co2, color = gdp_per_capita, size = population,

  # Tooltip Template
  text = paste0(
    "Country: ", country, "\n\nGDP: $",
    prettyNum(round(gdp, digits = 0),
      big.mark = ",", scientific = FALSE
    ),
    "B ",
    "\nGDP Per Capita: $",
    prettyNum(round(gdp_per_capita, digits = 0),
      big.mark = ",",
      scientific =
        FALSE
    ),
    "\nCO2 Emissions: ", prettyNum(co2,
      big.mark = ",",
      scientific =
        FALSE
    ),
    " Mt ",
    "\nTotal Population: ",
    prettyNum(round(population, digits = 0),
      big.mark = ",", scientific = FALSE
    ),
    "M "
  )
)


per_capita <- aes(
  x = gdp_per_capita, y = co2_per_capita,
  color = gdp, size = population,

  # Tooltip Template
  text = paste0(
    "Country: ", country, "\n\nGDP: $",
    prettyNum(round(gdp, digits = 0),
      big.mark = ",", scientific = FALSE
    ), "B ",
    "\nGDP Per Capita: $", prettyNum(round(gdp_per_capita,
      digits = 0
    ),
    big.mark = ",",
    scientific = FALSE
    ),
    "\nCO2 Per Capita: ", prettyNum(co2_per_capita,
      big.mark = ",",
      scientific = FALSE
    ),
    " t ",
    "\nTotal Population: ",
    prettyNum(round(population, digits = 0),
      big.mark = ",", scientific = FALSE
    ), "M "
  )
)


# Plot Variables

get_co2_plot <- function(get_num_country, get_country, get_dataset, get_year) {

  # Select AES
  selected_aes <- if (get_dataset == 1) {
    xlabel <<- "GDP, PPP (constant 2011 international $, Bil.)"
    ylabel <<- "Annual CO2 Emissions (Mt)"
    leg_label <- "GDP Per Capita"

    # Return Total
    total
  } else {
    xlabel <<- "GDP Per Capita, PPP (constant 2017 international $)"
    ylabel <<- "Annual CO2 Emissions Per Capita (t)"
    leg_label <- "GDP ($ Bil.)"

    # Return Per Capita
    per_capita
  }

  # Data Filtering
  co2_plot_data <- climate_data_filtered %>%
    filter(year == get_year) %>%
    arrange(desc(!!sym(get_country))) %>%
    head(get_num_country)

  # Static Plot
  co2_plot <- ggplot(data = co2_plot_data, selected_aes) +
    geom_point(alpha = 0.6) +
    scale_size(range = c(1, 20)) +
    theme_minimal() +
    ggtitle("Bubble Chart Showing CO2 Emisions and Economic Growth Over time") +
    labs(x = xlabel, y = ylabel, color = leg_label) +
    scale_x_continuous(labels = comma) +
    scale_y_continuous(labels = comma) +
    scale_color_viridis(discrete = F)

  # Convert to Interactive
  co2_plot_conv <- ggplotly(co2_plot, tooltip = "text")


  # Return Interactive Plot
  return(co2_plot_conv)
}
