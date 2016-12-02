library(shiny)

## Nested modules with observe(). 
## Both modules use observe() to reset slider value after checkboxInput().
## But here no need to pass argument about reset.

sliderTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("set_slider")),
    checkboxInput(ns("check"), "Check reset to rest slider", FALSE),
    textOutput(ns("number"))
  )
}

sliderText <- function(input, output, session, show) {
  ns <- session$ns
  output$set_slider <- renderUI({
    sliderInput(ns("slider"), "Slide me", 0, 100, 5)
  })
  output$number <- renderText({
    if(show())
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
  reactive({input$slider + 5})
}

sliderNestUI <- function(id) {
  ns <- NS(id)
  tagList(
    sliderTextUI(ns("inner1"))
  )
}

sliderNest <- function(input, output, session, show) {
  out <- callModule(sliderText, "inner1", show)
  reactive({out() + 10})
}

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  sliderTextUI("module"),
  h2(textOutput("value")),
  sliderNestUI("nester"),
  h2(textOutput("value2"))
)

server <- function(input, output) {
  display <- reactive({input$display})
  num2 <- callModule(sliderNest, "nester", display)
  num <- callModule(sliderText, "module", display)
  output$value <- renderText({paste0("slider1+5: ", num())})
  output$value2 <- renderText({paste0("slider2+5+10: ", num2())})
}
shinyApp(ui, server)
