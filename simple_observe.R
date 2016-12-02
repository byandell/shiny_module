library(shiny)

## Simple shiny page with sliderInput() and textOutput().

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  sliderInput("slider", "Slide me", 0, 100, 5),
  checkboxInput("check", "Check reset to rest slider", FALSE),
  textOutput("number")
)

server <- function(input, output, session) {
  display <- reactive({input$display})
  output$number <- renderText({
    if(display())
      input$slider
    else
      NULL
  })
  observe({
    check <- req(input$check)
    if(check) {
      updateSliderInput(session, "slider", value=0)
      updateCheckboxInput(session, "check", value=FALSE)
    }
  })
}

shinyApp(ui, server)
