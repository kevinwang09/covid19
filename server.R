shinyServer(function(input, output) {
    
    cum_data = reactive({
        all_data['global'] %>% 
            dplyr::filter(country %in% c("China", input$country))
    })
    
    added_data = reactive({
        cum_data() %>% 
            group_by(country) %>% 
            dplyr::mutate(added_cases = cum_confirm - lag(cum_confirm, 1)) %>%
            dplyr::select(time, country, added_cases)
    })
    
    added_data_wide = reactive({
        added_data() %>% 
            ungroup() %>% 
            pivot_wider(names_from = country, 
                        values_from = added_cases)
    })
    
    output$cum_confirm_plot = renderPlot({
        cum_data() %>% 
            ggplot(aes(x = time,
                       y = cum_confirm,
                       colour = country)) +
            geom_path(size = 1.2) +
            scale_y_log10(labels = scales::comma) +
            labs(x = "Time", 
                 y = "Cumulative confirmed cases",
                 title = "Cumulative confirmed cases of COVID-19") +
            scale_color_brewer(palette = "Set1")
    })
    
    output$added_plots = renderPlot({
        long_data = added_data()
        wide_data = added_data_wide()
        
        long_data %>% 
            ggplot(aes(x = time, y = added_cases,
                       colour = country)) +
            geom_path() +
            scale_y_log10() +
            labs(title = "Added cases through time") + 
            scale_color_brewer(palette = "Set1") +
            ggCcf(wide_data %>% pull(China), 
                  wide_data %>% pull(input$country), 
                  lag.max = 20) +
            scale_x_continuous(limits = c(NA, 0)) +
            labs(title = paste0("Cross-correlation between added cases in China and ", input$country),
                 subtitle = "Only lags behind China are shown") +
            plot_layout(nrow = 2)
    })
    
})
