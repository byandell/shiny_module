library(shiny)

## Basic module with observe().
## Note that update*Input do not use ns().

sliderTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(ns("slider"), "Slide me", 0, 100, 5),
    checkboxInput(ns("check"), "Check reset to rest slider", FALSE),
    textOutput(ns("number"))
  )
}

sliderText <- function(input, output, session, show) {
  output$number <- renderText({
    if(show())
      input$slider
    else
      NULL
  })
  observe({
    check <- input$check
    if(check) {
      updateSliderInput(session, "slider", value=0)
      updateCheckboxInput(session, "check", value=FALSE)
    }
  })
  reactive({input$slider + 5})
}

ui <- fluidPage(
  checkboxInput("display", "Show Value"),
  sliderTextUI("module"),
  h2(textOutput("value"))
)

server <- function(input, output) {
  display <- reactive({input$display})
  num <- callModule(sliderText, "module", display)
  output$value <- renderText({paste0("slider1+5: ", num())})
}
shinyApp(ui, server)
