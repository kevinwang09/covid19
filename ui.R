shinyUI(fluidPage(
    titlePanel("COVID-19: visualising added cases in selected countries"),
    # sidebarLayout(
    # sidebarPanel(
    selectInput(inputId = "country",
                label = "Select some countries",
                choices = all_data['global']$country %>% unique,
                multiple = FALSE),
    sliderInput(inputId = "lag",
                label = "Select lagged days", 
                min = 0, max = 60, value = 0),
    # ),
    # mainPanel(
    shiny::plotOutput(outputId = "cum_confirm_plot", height = "400px"),
    shiny::plotOutput(outputId = "added_plot", height = "400px"),
    shiny::plotOutput(outputId = "crosscorr_plot", height = "800px")
    # )
    # )
))
