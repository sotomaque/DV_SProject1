# server.R
require(jsonlite)
require(RCurl)
require(ggplot2)
require(dplyr)
require(reshape2)
require(shiny)

shinyServer(function(input, output) {
  #Code to generate data frame
  df <- eventReactive(c(input$refreshData), {
    df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from SOCIALMEDIADATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_es29937', PASS='orcl_es29937', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  }, ignoreNULL = FALSE)
  
  options(scipen=999)
  
  #Code that generates reactive transmission filter for the Scatter chart.
  names_filter <- eventReactive(c(input$refreshAll, input$ScatterPlot), {
    if (input$NameS == "All"){
      names_filter = c("All", "Ben Carson", "Bernie Sanders","Bobby Jindal","Carly Fiorina", "Chris Christie", "Donald Trump", "George Pataki", "Hillary Clinton", "Jeb Bush", "Jim Gilmore",  "Jim Webb", "John Kasich", "Lincoln Chafee", "Lindsey Graham", "Marco Rubio", "Mark Everson",   "Martin OMalley", "Mike Huckabee", "Rand Paul", "Rick Santorum", "Ted Cruz")
    }
    else {
      names_filter = input$NameS
    }
    }, ignoreNULL = FALSE)
  
  #Code that generate reactive year selector for the scatter plot.
  #year_range <- eventReactive(c(input$refreshAll, ), {
  #  if (input$BEG_YEAR <= input$END_YEAR){
#      year_range = input$BEG_YEAR:input$END_YEAR
#    }
#    else {
#      year_range = 1985:2016
#    }
#  }, ignoreNULL = FALSE)
  

  
  #Code to generate the scatter plot
  output$ScatterPlot <- renderPlot({
    scatterplot <- df() %>% select(NAME_) %>% subset(NAME_ %in% names_filter())
    
    plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous() +
      labs(title='Scatter Plot, Likes by Politicians, 9-19-15 - 10-20-15') +
      labs(x="TWITTER", y=paste("FACEBOOK")) +
      layer(data=df, 
            mapping=aes(x=TWITTER, y=as.numeric(as.character(FACEBOOK))), 
            stat="identity", 
            stat_params=list(), 
            geom="point",
            geom_params=list(), 
            #position=position_identity()
            position=position_jitter(width=0.3, height=0)
      )
    return(plot)
  })
})
