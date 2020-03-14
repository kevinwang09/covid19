shinyUI(fluidPage(
    titlePanel("Kevin's example nCov app"),
    sidebarLayout(
        sidebarPanel(
            selectizeInput(inputId = "country",
                          label = "Select some countries",
                          choices = all_data['global']$country %>% unique,
                          multiple = TRUE)
        ),
        mainPanel(
            shiny::plotOutput(outputId = "cum_confirm_plot")
        )
    )
))
