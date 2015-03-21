# More info:
#   https://github.com/jcheng5/googleCharts
# Install:
#   devtools::install_github("jcheng5/googleCharts")
library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
# xlim <- list(
#   min = -10,
#   max =max(data$population)*1.5
#   
#   
# )
ylim <- list(
  min =-2,
  max = max(data$energy)*1.1
)

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  )
  ,
  
  
  h2("Energy Per Capita vs. Population G20"),
  fluidRow(checkboxGroupInput(inputId="continent", label="", choices=c('Africa',
                                                                     'Asia',
                                                                     'Australia',
                                                                     'Europe',
                                                                     'North America',
                                                                     'South America'), selected = 'Africa',inline=TRUE),
           
           textOutput("text1"), downloadLink('downloadData', 'Download'))
         
  ,
  googleBubbleChart("chart",
                    width="100%", height = "400px",
                    # Set the default options for this chart; they can be
                    # overridden in server.R on a per-update basis. See
                    # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                    # for option documentation.
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "Population [Millions]",
                        viewWindow = list(
                          min = -50,
                          max =max(data$population)*1.1
                          
                          
                        )
                      ),
                      vAxis = list(
                        title = "Energy per capita [toe]",
                        viewWindow = ylim
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "70%"
                      ),
                      # Allow pan/zoom
                      explorer = list(),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.4, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "black"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
  ),
  fluidRow(
    shiny::column(width=4,offset=4,
   
    sliderInput("year", "Year",
                              min = min(data$year), max = max(data$year),
                              value = min(data$year), animate = TRUE,step=1)
   )
)



)
)