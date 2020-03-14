shinyUI(fluidPage(
    titlePanel("Kevin's example nCov app"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "country",
                          label = "Select some countries",
                          choices = all_data['global']$country %>% unique,
                          multiple = FALSE)
        ),
        mainPanel(
            shiny::plotOutput(outputId = "cum_confirm_plot"),
            shiny::plotOutput(outputId = "added_plots")
        )
    )
))
