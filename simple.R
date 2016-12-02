library(shiny)

## Simple shiny page with sliderInput() and textOutput().

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  sliderInput("slider", "Slide me", 0, 100, 5),
  textOutput("number")
)

server <- function(input, output) {
  display <- reactive({input$display})
  output$number <- renderText({
    if(display())
      input$slider
    else
      NULL
  })
}

shinyApp(ui, server)
