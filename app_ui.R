library(shinythemes)

# Intro Tab ------------------------------------------------------------------

intro_main_panel <- column(
  9,
  h1("Global CO2 Emisions & Economic Growth From 1950 to 2018"),
  h3(em("The Impact of Economic Growth on Carbon Dioxide Emisions Around the
     World")),
  hr(),
  h3("Introduction"),
  p(
    "Since the Industrial revolution, anthropogenic Carbon Dioxide (CO2)
    emissions have been increasing globally. From 1950 to 2018 CO2 emissions
    have gone up by",
    textOutput(outputId = "change_co2_emisions", container = span),
    "megatons Annually. That is an",
    textOutput(outputId = "percent_change_co2_emisions", container = span),
    "increase in CO2 emissions. CO2 is a potent greenhouse gas and is
    responsible for global warming and climate change. For this report I will
    be looking at the impact of Economic Growth on Carbon Dioxide emissions
    around the world from the 1950 to 2018. I will be looking at both Economic
    Growth and Economic Development."
  ),
  h4(em("Variables")),
  p("The main variables I will be looking at are:"),
  tags$ul(
    tags$li(strong("CO2 Emissions:"), "Annual production-based emissions of
            carbon dioxide (CO2), measured in megatons and is based on
            territorial emissions and as such do not account for emissions
            embedded in traded goods."),
    tags$li(strong("CO2 Emissions Per Capita:"), "A countries Annual CO2
    Emisions devided by its population, measured in tonnes per person"),
    tags$li(strong("GDP:"), "Gross Domestic Product in international-$
            using 2011 prices"),
    tags$li(strong("GDP Per Capita:"), "GDP divided by population"),
    tags$li(strong("Population"))
  ),
  h3("Findings"),
  p(
    "From the data we can see that the average CO2 emissions per person is
    around",
    textOutput(outputId = "avg_co2_per_captia", container = span),
    "tons per person. However in",
    textOutput(outputId = "top_co2_emiter_per_capita", container = span),
    ", the nation with the highest CO2 emissions per capita, it is around",
    textOutput(outputId = "amnt_top_co2_emiter_per_capita", container = span),
    "tons per person."
  ),
  p(
    textOutput(outputId = "top_co2_emiter", container = span),
    "was the world biggest CO2 emitter in 2018 and emitted around",
    textOutput(outputId = "amnt_top_co2_emiter", container = span),
    "megatons of CO2. Between 2000 to 2018",
    textOutput(outputId = "top_co2_growth_2000_2018", container = span),
    "had the largest percent increase in CO2 emissions. Thier CO2 emissions
    increased by over",
    textOutput(outputId = "amnt_top_co2_growth_2000_2018", container = span)
  )
)

## Intro Tab Layout -----------------------------------------------------------

intro_tab <- tabPanel(
  "Intro",
  fluidRow(
    column(1),
    intro_main_panel,
    column(2)
  )
)


# Plot Tab ------------------------------------------------------------------

## Side Bar -----------------------------------------------------------------
plot_sidebar <- sidebarPanel(
  h3(strong("Filter")),
  # Data set Radio Button
  radioButtons(
    inputId = "var_select_radio",
    label = "Display Data By:",
    choices = list("Total" = 1, "Per Capita" = 2),
    selected = 1
  ),
  br(),
  # Number Countries Slider
  sliderInput(
    inputId = "num_country_slider",
    label = "Number of Countries",
    min = 2,
    max = 50,
    value = 30
  ),
  br(),
  # Countries Selector
  selectInput(
    inputId = "countries_select",
    label = "Select Countries By:",
    choices = list(
      "Largest Economies" = "gdp",
      "Largest Population" = "population",
      "Highest GDP Per Capita" = "gdp_per_capita",
      "Largest CO2 Emitters" = "co2"
    ),
    selected = "gdp",
    multiple = FALSE,
  ),
  width = 3
)

## Main Panel -----------------------------------------------------------------

### Render Plot ---------------------------------------------------------------

plot_main_panel <- mainPanel(
  plotlyOutput(outputId = "co2_chart", height = "800px"),
  p(em("Size of Bubble on Graph = Relative Size of The Total Population")),

  # Year Slider
  sliderInput(
    inputId = "year_selct",
    label = "Select Year",
    min = 1950,
    max = 2018,
    value = 2018,
    sep = "",
    step = 1,
    animate = animationOptions(interval = 300),
    width = "95%"
  ),

  ### Insight -----------------------------------------------------------------

  br(),
  h3("Insight"),
  hr(),
  p("This graph was included to show how CO2 emissions and economies are growing
    over time and to show how these two variables are related to one another.
    I also included to show from which countries CO2 emissions are coming and
    how certain nations are emitting more relative to their population size."),
  p("From this graph we can see that as nation's economy grows and its people
    get richer, shown by GDP and GDP per capita, their CO2 Emissions go also
    go up. This tells us that as poorer nations develop and grow their economy,
    we are likely to see major increases in CO2 emissions over time. From the
    graph we can also see that the US and China make up a large portion of the
    global greenhouse gas emissions and they are also the world's two largest
    economies."),
  br(),
  br(),
  width = 9
)

## Plot Tab Layout -----------------------------------------------------------
plot_tab <- tabPanel(
  "Graph",
  sidebarLayout(
    plot_sidebar,
    plot_main_panel
  )
)

# UI Set Up ------------------------------------------------------------------
ui <- navbarPage("CO2 Emissions and Economic Growth ",
  theme = shinytheme("sandstone"),
  intro_tab,
  plot_tab
)
