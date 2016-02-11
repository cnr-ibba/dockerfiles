shinyServer(function(input, output) {
    
    # =========================================================================
    # Server outputs : Datatables
    # =========================================================================
    output$crimes_datatable <- renderDataTable({
        return(dataframes$crimes)
    }, options=list(pageLength=10, autoWidth=FALSE))
    
    
    
    # =========================================================================
    # Server outputs : Plots
    # =========================================================================
    output$state_time_heatmap <- renderPlot({
        # get data from dataframe
        df <- dataframes$crimes %>%  # subset/filter df based on user selections
            filter(crime == input$state_time_crimes,
                   state %in% input$state_time_states,
                   year >= input$state_time_years[1],
                   year <= input$state_time_years[2])
        
        # plotting
        plot <- ggplot(df, aes(x=year, y=state_name, fill=value)) +
            geom_tile(color=ifelse(df$year %in% recessions, "blue", "gray80")) + 
            scale_fill_gradient2(midpoint=mean(df$value), low="steelblue", mid="white", high="tomato") + 
            labs(title=sprintf("%s", input$state_time_crimes),
                 x="Year",
                 y="States") + 
            theme(panel.background=element_blank(),
                  axis.text.x=element_text(angle=45, hjust=1),
                  axis.ticks.y=element_blank())
        return(plot)
    })
    
    
    output$state_crime_heatmap <- renderPlot({
        # get data from dataframe
        df <- dataframes$crimes  %>% # subset/filter df based on user selections
            filter(state_name == input$state_crime_states,
                   crime %in% input$state_crime_crimes,
                   year >= input$state_crime_years[1],
                   year <= input$state_crime_years[2])
        
        # plotting
        plot <- ggplot(df, aes(x=year, y=crime, fill=value)) +
            geom_tile(color=ifelse(df$year %in% recessions, "blue", "gray80")) + 
            scale_fill_gradient2(midpoint=mean(df$value), low="steelblue", mid="white", high="tomato") + 
            labs(title=sprintf("%s Crime Rates", input$state_crime_states),
                 x="Year",
                 y="Crimes") + 
            theme(panel.background=element_blank(),
                  axis.text.x=element_text(angle=45, hjust=1),
                  axis.ticks.y=element_blank())
        
        if(input$show_labels) {
            plot <- plot + 
                geom_text(aes(label=value), size=3, angle=90, fontface="italic", alpha=0.6)
        }
        return(plot)
    })
    
    output$crime_correlations <- renderPlot({
        # get data from dataframe
        df <- dataframes$crimes  %>% # subset/filter df based on user selections
            filter(state_name == input$correlation_states,
                   year >= input$correlation_years[1],
                   year <= input$correlation_years[2]) %>%
            select(-state) %>%  # remove non-numeric for calculating correlation matrix
            dcast(year ~ crime) %>% # dcast from long to wide format
            select(-year)
        
        # plotting
        plot <- ggplot(melt(cor(df)), aes(x=Var1, y=Var2, fill=value)) + 
            geom_tile() + 
            geom_text(aes(label=formatC(value, digits=2, format="f")), size=3.5, fontface="italic") + 
            scale_fill_gradient2(low="tomato", mid="white", high="steelblue") + 
            labs(title=sprintf("%s Crimes Correlation Matrix (%s to %s)",
                               input$correlation_states,
                               input$correlation_years_min,
                               input$correlation_years_max),
                 x="",
                 y="") + 
            theme(panel.background=element_blank(),
                  axis.text.x=element_text(angle=45, hjust=1))
        return(plot)
    })
    
    
    # =========================================================================
    # Server outputs : Downloads
    # =========================================================================
    output$crimes_download <- downloadHandler(
        filename <- function() {
            return("crimes.csv")
        },
        content <- function(filename) {
            df <- dataframes$crimes
            write.csv(df, file=filename, row.names=FALSE)
        }
    )    
})