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
    
    cum_data_wide = reactive({
        cum_data() %>% 
            dplyr::select(time, country, cum_confirm) %>% 
            ungroup() %>% 
            pivot_wider(names_from = country, 
                        values_from = cum_confirm)
    })
    
    added_data_wide = reactive({
        added_data() %>% 
            ungroup() %>% 
            pivot_wider(names_from = country, 
                        values_from = added_cases)
    })
    
    output$cum_confirm_plot = renderPlot({
        
        cum_data = cum_data()
        
        cum_shift_data = cum_data %>% 
            dplyr::filter(country == input$country) %>% 
            dplyr::mutate(shift_time = time - input$lag)
        
        cum_data %>% 
            ggplot(aes(x = time,
                       y = cum_confirm,
                       colour = country)) +
            geom_path(size = 1.2) +
            geom_path(data = cum_shift_data, 
                      aes(x = shift_time,
                          y = cum_confirm), linetype = "dashed", size = 1.2) +
            geom_vline(xintercept = as.Date("2020-01-23"), colour = "black") +
            annotate(geom = "text", label = "Wuhan \n lockdown",
                     x = as.Date("2020-01-21"), y = 3e4, angle = 90) +
            scale_color_brewer(palette = "Set1") +
            scale_y_continuous(trans = "log1p", 
                               breaks = c(10^c(0:5), 5*(10^c(0:4))), 
                               labels = scales::comma_format(accuracy = 1)) +
            labs(x = "Time", 
                 y = "Cumulative confirmed cases \n (log-scale)",
                 title = "Cumulative confirmed cases of COVID-19",
                 subtitle = paste0("Dashed line shows the selected country lagged ", 
                                   input$lag, " days")) +
            theme(panel.grid.minor.y = element_blank())
    })
    
    output$added_plot = renderPlot({
        long_data = added_data()
        
        added_shift_data = long_data %>% 
            dplyr::filter(country == input$country) %>% 
            dplyr::mutate(shift_time = time - input$lag)

        long_data %>% 
            ggplot(aes(x = time, y = added_cases,
                       colour = country)) +
            geom_path(size = 1.2) +
            geom_path(data = added_shift_data, 
                      aes(x = shift_time,
                          y = added_cases), linetype = "dashed", size = 1.2) +
            geom_vline(xintercept = as.Date("2020-01-23"), colour = "black") +
            annotate(geom = "text", label = "Wuhan \n lockdown",
                     x = as.Date("2020-01-21"), y = 2e3, angle = 90) +
            scale_color_brewer(palette = "Set1") +
            scale_y_continuous(trans = "log1p", 
                               breaks = c(10^c(0:5), 5*(10^c(0:4))),
                               labels = scales::comma_format(accuracy = 1)) + 
            labs(title = "Added cases through time",
                 subtitle = paste0("Dashed line shows the selected country lagged ", 
                                   input$lag, " days"),
                 x = "Time", 
                 y = "Added cases \n (log-scale)") +
            theme(panel.grid.major.y = element_blank())
    })
    
    output$added_crosscorr_plot = renderPlot({
        added_wide_data = added_data_wide()
        
        ggCcf(added_wide_data %>% pull(China), 
              added_wide_data %>% pull(input$country), 
              lag.max = 60) +
            scale_x_continuous(limits = c(NA, 0)) +
            labs(title = paste0("Cross-correlation between added cases in China and ", input$country),
                 subtitle = "Only lags behind China are shown") +
            plot_layout(nrow = 2)
    })
    
    output$cum_crosscorr_plot = renderPlot({
        cum_data_wide = cum_data_wide()
        
        ggCcf(cum_data_wide %>% pull(China), 
              cum_data_wide %>% pull(input$country), 
              lag.max = 60) +
            scale_x_continuous(limits = c(NA, 0)) +
            labs(title = paste0("Cross-correlation between cumulative cases in China and ", input$country),
                 subtitle = "Only lags behind China are shown") +
            plot_layout(nrow = 2)
    })
    
})
