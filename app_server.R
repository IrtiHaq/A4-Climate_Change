source("analysis.R")

server <- function(input, output) {
# Stats -------------------------------------------------------------------
  output$amnt_top_co2_emiter <- renderText({
    amnt_top_co2_emiter
  })
  output$amnt_top_co2_emiter_per_capita <- renderText({
    amnt_top_co2_emiter_per_capita
  })
  output$amnt_top_co2_growth_2000_2018 <- renderText({
    amnt_top_co2_growth_2000_2018
  })
  output$avg_co2_per_captia <- renderText({
    avg_co2_per_captia
  })
  output$change_co2_emisions <- renderText({
    change_co2_emisions
  })
  output$percent_change_co2_emisions <- renderText({
    percent_change_co2_emisions
  })
  output$top_co2_emiter <- renderText({
    top_co2_emiter
  })
  output$top_co2_emiter_per_capita <- renderText({
    top_co2_emiter_per_capita
  })
  output$top_co2_growth_2000_2018 <- renderText({
    top_co2_growth_2000_2018
  })


# CO2 Plot----------------------------------------------------------------
  output$co2_chart <- renderPlotly({
    co2_plot_int <- get_co2_plot(
      input$num_country_slider,
      input$countries_select,
      input$var_select_radio,
      input$year_selct
    )

    # Return
    co2_plot_int
  })
}
