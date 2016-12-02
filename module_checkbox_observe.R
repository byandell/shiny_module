library(shiny)

## Somehow I am not using updateCheckboxGroupInput() correctly.
## The `Flip checks` checkboxInputs are supposed to do the following
## based on an steps in an observe():
## 1. Reset the checkbox for that `Flip checks` to FALSE.
## 2. Flip the `Check one` checkbox (TRUE to FALSE or FALSE to TRUE)
## 3. Select 1:2 for `Check group` and unselect 3:5.
## None of the three `Flip checks` accomplishes task 3.
## They each set selected to NULL for the checkboxGroupInput.
## `Flip checks 1` accomplishes task 1 & 2 only.
## `Flip checks 2` accomplishes taks 1 only.
## `Flip checks 3` accomplishes none of the tasks.
## The only difference is order placement in observe() of updateCheckboxGroupInput().
## Thanks for any feedback. Brian.Yandell@wisc.edu.

checkboxGroupUI <- function(id) {
  ns <- NS(id)
  tagList(
    checkboxInput(ns("check"), "Flip checks 1", FALSE),
    checkboxInput(ns("check2"), "Flip checks 2", FALSE),
    checkboxInput(ns("check3"), "Flip checks 3", FALSE),
    uiOutput(ns("check_one")),
    uiOutput(ns("check_group"))
  )
}

checkboxGroup <- function(input, output, session) {
  ns <- session$ns
  output$check_group <- renderUI({
    checkboxGroupInput(ns("ckgp"), "Check group", choices=1:5, inline=TRUE)
  })
  output$check_one <- renderUI({
    checkboxInput(ns("ck1"), "Check one", FALSE)
  })
  observe({
    check <- req(input$check)
    if(check) {
      updateCheckboxInput(session, "check", value=FALSE)
      updateCheckboxInput(session, "ck1", value=!input$ck1)
      updateCheckboxGroupInput(session, "ckgp", selected=1:2, choices=1:5,
                               inline=TRUE)
    }
  })
  observeEvent(input$ckgp, {
    browser()
    select <- input$ckgp
    not_select <- (1:5)[-select]
    choice <- c(select,not_select)
    updateCheckboxGroupInput(session, "ckgp", selected=select,
                             choices=choice,
                             inline=TRUE)
  })
  observe({
    check2 <- req(input$check2)
    if(check2) {
      updateCheckboxInput(session, "check2", value=FALSE)
      updateCheckboxGroupInput(session, "ckgp", selected=1:2, choices=1:5,
                               inline=TRUE)
      updateCheckboxInput(session, "ck1", value=!input$ck1)
    }
  })
  observe({
    check3 <- req(input$check3)
    if(check3) {
      updateCheckboxGroupInput(session, "ckgp", selected=1:2, choices=1:5,
                               inline=TRUE)
      updateCheckboxInput(session, "check3", value=FALSE)
      updateCheckboxInput(session, "ck1", value=!input$ck1)
    }
  })
}

ui <- fluidPage(
  checkboxGroupUI("module")
)
server <- function(input, output) {
  callModule(checkboxGroup, "module")
}
shinyApp(ui, server)
