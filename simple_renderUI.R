library(shiny)

## Simple shiny page with sliderInput() and textOutput().

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  uiOutput("set_slider"),
  textOutput("number")
)

server <- function(input, output) {
  display <- reactive({input$display})
  output$set_slider <- renderUI({
    sliderInput("slider", "Slide me", 0, 100, 5)
  })
  output$number <- renderText({
    if(display())
      input$slider
    else
      NULL
  })
}

shinyApp(ui, server)
