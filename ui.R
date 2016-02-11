shinyUI(fluidPage(
    tags$head(tags$link(rel="stylesheet", type="text/css", href="app.css")),
    
    titlePanel("State Crime Rates Explorer"),
    
    mainPanel(
        p(class="text-small",
          a(href="http://chrisrzhou.datanaut.io/", target="_blank", "by chrisrzhou"),
          a(href="https://github.com/chrisrzhou/RShiny-StateCrimeRates", target="_blank", icon("github")), " | ",
          a(href="http://bl.ocks.org/chrisrzhou", target="_blank", icon("cubes")), " | ",
          a(href="https://www.linkedin.com/in/chrisrzhou", target="_blank", icon("linkedin"))),
        hr(),
        p(class="text-small", "State Crime Rates Visualizations.  All data is derived from the FBI's : ",
          a(href="http://www.fbi.gov/about-us/cjis/ucr/", target="_blank", "Uniform Crime Reports (UCR)"),
          " website.  Rates are measured in per 100,000 population."),
        hr(),
        tabsetPanel(id="tabset",
                    tabPanel("Heatmaps",
                             h2("Heatmaps"),
                             p(class="text-small", "Series of heatmaps visualizing crime rates in states.  Major recession periods are outlined in blue"),
                             p(class="text-small", "Three colors are used to display overall values of the data subset: blue (below average), red (above average), white (average)."),
                             hr(),
                             h3("State-Time Heatmap"),
                             p(class="text-small", "This section visualizes heatmap of crime rates of states over the years."),
                             fluidRow(
                                 column(3,
                                        selectInput(inputId="state_time_crimes", label="Select Crimes", choices=choices$crimes, selected=choices$crimes[[1]]),
                                        sliderInput(inputId="state_time_years", label="Filter Years", min=min(choices$years), max=max(choices$years),
                                                    value=c(min(choices$years), max(choices$years)), step=1, format="####"),
                                        checkboxGroupInput(inputId="state_time_states", label="Select States", choices=choices$states, selected=choices$states, inline=TRUE)
                                 ),
                                 column(9,
                                        plotOutput("state_time_heatmap", height=500, width="auto")
                                 )
                             ),
                             hr(),
                             
                             
                             h3("Crime-Time Heatmap"),
                             p(class="text-small", "This section visualizes heatmap of crime rates over time of a selected state."),
                             fluidRow(
                                 column(3,
                                        checkboxInput(inputId="show_labels", label="Show Labels", value=FALSE),
                                        selectInput(inputId="state_crime_states", label="Select State", choices=choices$state_names, selected=choices$state_names[[5]]),
                                        sliderInput(inputId="state_crime_years", label="Filter Years", min=min(choices$years), max=max(choices$years),
                                                    value=c(min(choices$years), max(choices$years)), step=1, format="####"),
                                        checkboxGroupInput(inputId="state_crime_crimes", label="Select Crimes", choices=choices$crimes, selected=choices$crimes)
                                 ),
                                 column(9,
                                        plotOutput("state_crime_heatmap", height=400, width="auto")     
                                 )
                             ),
                             hr()
                             
                    ),
                    
                    tabPanel("Correlations",
                             h2("Correlations"),
                             p(class="text-small", "Correlation matrix of various types of crimes.  Use the widgets to filter a data subset."),
                             p(class="text-small", "The number of years in the dataset provides a sample size for calculating correlation of crime rates."),
                             hr(),
                             fluidRow(
                                 column(3,
                                        selectInput(inputId="correlation_states", label="Select State", choices=choices$state_names, selected=choices$state_names[[5]]),
                                        sliderInput(inputId="correlation_years", label="Filter Years", min=min(choices$years), max=max(choices$years),
                                                    value=c(min(choices$years), max(choices$years)), step=1, format="####")
                                 ),
                                 column(9,
                                        plotOutput("crime_correlations", height=500, width="auto")
                                 )
                             ),
                             hr()
                    ),
                    
                    tabPanel("Data",
                             h2("Data", downloadButton("crimes_download", label="")),
                             p(class="text-small", "Tabular searchable data display similar to that found in the ",
                               a(href="http://www.ucrdatatool.gov/Search/Crime/State/StatebyState.cfm", target="_blank", "original source")),
                             p(class="text-small", "A convenient download sample of the data is provided ",
                               a(href="data.csv", target="_blank", "here.")),
                             p(class="text-small", "You can download the data with the download button above."),
                             dataTableOutput("crimes_datatable"),
                             hr()
                    )
        ),
        width=12
    )
))
