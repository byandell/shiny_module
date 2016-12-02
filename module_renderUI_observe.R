library(shiny)

## Basic module with observe().
## Note that update*Input do not use ns().

sliderTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("set_slider")),
    checkboxInput(ns("check"), "Flip slider", FALSE),
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
    slider <- input$slider
    if(check) {
      updateSliderInput(session, "slider", value=100-slider)
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
