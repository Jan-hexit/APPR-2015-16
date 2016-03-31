library(shiny)
shinyUI(fluidPage(
  selectInput("x",label="x os",choices = c(colnames(profit[,-9]))),
  selectInput("y",label="y os",choices = c(colnames(profit[,-9]))),
  plotOutput("graf")
))

