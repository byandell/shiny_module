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
    selectInput("letter", "Letter", c("Choose one or more" = "", LETTERS),
                multiple=TRUE),
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
  observeEvent(req(input$check), {
    if(input$check) {
      browser()
      updateCheckboxInput(session, "check", value=FALSE)
      updateCheckboxInput(session, "ck1", value=!input$ck1)
      selecti <- req(input$letter)
      selecti <- unique(c("A",selecti))
      updateSelectInput(session, "letter",
                        choices=c("Choose one or more" = "", LETTERS),
                        selected=selecti)
    }
  })
  observe({
    select <- req(input$ckgp)
    not_select <- (1:5)[-match(select,1:5)]
    choice <- c(select,not_select)
    updateCheckboxGroupInput(session, "ckgp", selected=select,
                             choices=choice,
                             inline=TRUE)
  })
}

ui <- fluidPage(
  checkboxGroupUI("module")
)
server <- function(input, output) {
  callModule(checkboxGroup, "module")
}
shinyApp(ui, server)
