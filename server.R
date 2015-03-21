library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  defaultColors <- c("#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
 
  
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$continent)
  )
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    df <- data %>%
      filter(year == input$year, continent %in% input$continent) %>%
      select(country, population,energy,continent,size=total_energy) %>%
      arrange(continent)

    })
  
  total_energy<- reactive({
  df <- data %>%
    filter(year == input$year, continent %in% input$continent) %>%
    select(total_energy) %>% summarise(sum(total_energy))
  
  
  })
  
  max_x<-function(){
    max <- data %>% filter(year == input$year,continent %in% input$continent) %>% select(population) %>% summarise(max(population)*1.1)
 
  }
  
  min_x<-function(){
    min <- data %>% filter(year == input$year,continent %in% input$continent) %>% select(population) %>% summarise(min(population)*1.1)
    
  }
       
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        hAxis = list(
                    viewWindow = list(
                    min = as.numeric(min_x())-20,
                    max =as.numeric(max_x())
                    
                    )
                    ),
       
          
        title = sprintf(
          "Energy consumption vs population year %s energy %s megatonne oil",
          input$year,round(total_energy(),0)),
        series = series
        

      )
    )
  })

output$downloadData <- downloadHandler(
  filename = function() {
    paste0('data-', Sys.Date(), '.csv')
  },
  content = function(file) {
    write.csv(data, file)
  }
)


})