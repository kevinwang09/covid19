shinyServer(function(input, output) {
    
    filter_data = reactive({
        sub_data = all_data['global'] %>% 
            dplyr::filter(country %in% c("China", input$country))
        
        return(sub_data)
    })
    
    output$cum_confirm_plot = renderPlot({
        filter_data() %>% 
            ggplot(aes(x = time,
                       y = cum_confirm,
                       colour = country)) +
            geom_path(size = 1.2) +
            scale_y_log10(labels = scales::comma) +
            labs(x = "Time", 
                 y = "Cumulative confirmed cases",
                 title = "nCov-19 in selected countries") +
            scale_color_brewer(palette = "Set1")
    })
})
