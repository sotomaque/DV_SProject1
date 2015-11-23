require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(extrafont)

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from SOCIALMEDIADATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_es29937', PASS='orcl_es29937', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_wrap(~variable) +
  labs(title='Presidential Candidates Following Throughout Semester') +
  labs(x=paste("Candidate"), y=paste("Likes")) +
  layer(data=bar_chart, 
        mapping=aes(x=Name_, y=value), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue", fill="white"), 
        position=position_dodge()
  ) + coord_flip() + 
  
  layer(data=bar_chart, 
        mapping=aes(x=, y=value, label=round(WINDOW_AVG_MPG, 2)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=2), 
        position=position_identity()
  ) +
  
  layer(data=bar_chart, 
        mapping=aes(yintercept = WINDOW_AVG_MPG), 
        geom="hline",
        geom_params=list(colour="red")
  ) +
  
  layer(data=bar_chart, 
        mapping=aes(x=TRANY, y=value, label=round(value, 2)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=0), 
        position=position_identity()
  )

#Code to generate Bar Chart Plot
output$barchartPlot <- renderPlot({
  bar_chart <- df %>% select(NAME_, FACEBOOK, TWITTER) %>% #subset(NAME_ %in% names_filter()) %>%
    group_by(NAME_) %>% summarise(avg_fb_likes = mean(FACEBOOK), avg_twitter_likes = mean(TWITTER))
  #Plot Function to generate bar chart with reference line and values
  #plot <- 
})
