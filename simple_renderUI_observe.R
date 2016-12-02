library(shiny)

## Simple shiny page with sliderInput() and textOutput().

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  uiOutput("set_slider"),
  checkboxInput("check", "Check reset to rest slider", FALSE),
  textOutput("number")
)

server <- function(input, output, session) {
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
  observe({
    check <- req(input$check)
    if(check) {
      updateSliderInput(session, "slider", value=0)
      updateCheckboxInput(session, "check", value=FALSE)
    }
  })
}

shinyApp(ui, server)
