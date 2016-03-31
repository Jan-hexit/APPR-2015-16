library(shiny)
library(ggplot2)
if ("server.R" %in% dir()) {
  setwd("..")
}
shinyServer(function(input, output) {
  output$graf <- renderPlot({
    ggplot(profit, aes_string(x=paste("profit$",input$x,sep=""), y=paste("profit$",input$y,sep=""))) + geom_point()+ geom_smooth(method = "lm", formula = y ~ x + I(x^2))+labs(title=paste("Profit ",input$y," od odvisnosti od ",input$x,sep=""),x=input$x,y=input$y)
  })
})