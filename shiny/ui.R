library(shiny)

ui <- fluidPage(
  selectInput("x",label="x os",choices = c(colnames(profit[,-9]))),
  selectInput("y",label="y os",choices = c(colnames(profit[,-9]))),
  plotOutput("graf")
)
server <- function(input, output) {
  output$graf <- renderPlot({
    ggplot(profit, aes_string(x=paste("profit$",input$x,sep=""), y=paste("profit$",input$y,sep=""))) + geom_point()+ geom_smooth(method = "lm", formula = y ~ x + I(x^2))
  })
}

shinyApp(ui = ui, server = server)