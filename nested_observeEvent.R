library(shiny)

## Nested modules with observeEvent(). 
## Both modules use observeEvent() to reset slider value after actionButton().

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

sliderNestUI <- function(id) {
  ns <- NS(id)
  tagList(
    sliderTextUI(ns("inner1")),
    actionButton(ns("reset2"), "Reset Nest Value")
  )
}

sliderNest <- function(input, output, session, show) {
  reset2 <- reactive({input$reset2})
  out <- callModule(sliderText, "inner1", show, reset2)
  reactive({out() + 10})
}

ui <- fluidPage(
  actionButton("reset", "Reset Value"),
  checkboxInput("display", "Show Value"),
  sliderTextUI("module"),
  h2(textOutput("value")),
  sliderNestUI("nester"),
  h2(textOutput("value2"))
)

server <- function(input, output) {
  reset <- reactive({input$reset})
  display <- reactive({input$display})
  num2 <- callModule(sliderNest, "nester", display)
  num <- callModule(sliderText, "module", display, reset)
  output$value <- renderText({paste0("slider1+5: ", num())})
  output$value2 <- renderText({paste0("slider2+5+10: ", num2())})
}
shinyApp(ui, server)
