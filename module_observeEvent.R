library(shiny)

## Module with observeEvent(). 
## Module uses observeEvent() to reset slider value after actionButton().

sliderTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(ns("slider"), "Slide me", 0, 100, 5),
    textOutput(ns("number"))
  )
}

sliderText <- function(input, output, session, show, reset) {
  output$number <- renderText({
    if(show())
      input$slider
    else
      NULL
  })
  observeEvent(reset(), {
    updateSliderInput(session, "slider", value=0)
  })
  reactive({input$slider + 5})
}

ui <- fluidPage(
  actionButton("reset", "Reset Value"),
  checkboxInput("display", "Show Value"),
  sliderTextUI("module"),
  h2(textOutput("value"))
)

server <- function(input, output) {
  reset <- reactive({input$reset})
  display <- reactive({input$display})
  num <- callModule(sliderText, "module", display, reset)
  output$value <- renderText({paste0("slider1+5: ", num())})
}
shinyApp(ui, server)
