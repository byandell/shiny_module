suppressPackageStartupMessages({
  #  library(doqtl2)
  library(shiny)
  library(dplyr)
})

dirpath <- "~/Documents/Research/attie_alan/DO/data"
datapath <- file.path(dirpath, "DerivedData")

peaks <- readRDS(file.path(datapath, "peaks.rds"))
peak_info <- peaks$output
analyses_tbl <- readRDS(file.path(datapath, "analyses.rds")) %>%
  filter(output %in% peak_info)
rm(peak_info)

pheno_type <- c(sort(unique(analyses_tbl$pheno_type)), "all")

library(shiny)

## Basic module with observe().
## Note that update*Input do not use ns().

sliderTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("set_slider")),
    checkboxInput(ns("check"), "Flip slider", FALSE),
    textOutput(ns("number")),
    uiOutput(ns("choose_dataset")),
    uiOutput(ns("choose_phenoanal"))
  )
}

sliderText <- function(input, output, session, show) {
  ns <- session$ns
  # Drop-down selection box for which phenotype set
  output$choose_dataset <- renderUI({
    selectInput(ns("dataset"), "Phenotype Group",
                choices = c("bile acid","clinical"))
  })
  ## Set up analyses data frame.
  analyses_df <- reactive({
    dataset <- req(input$dataset)

    ## Filter by dataset.
    dat <- analyses_tbl
    if(dataset != "all") {
      dat <- dat %>%
        filter(pheno_type == dataset)
    }
    dat
  })
  # Check boxes for phenotypes.
  output$choose_phenoanal <- renderUI({
    phenames <- sort(analyses_df()$output)
    choices_set <- phenames

    checkboxGroupInput(ns("columns"), "Choose phenotypes",
                       choices = choices_set, inline=TRUE)
  })

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
    browser()
    check <- req(input$check)
    slider <- input$slider
    if(check) {
      updateSliderInput(session, "slider", value=100-slider)
      updateCheckboxInput(session, "check", value=FALSE)
    }
  })
  observe({
    browser()
    ## columns from analyses_df().
    phenames <- sort(analyses_df()$output)

    ## Selected from most recent input.
    selected_set <- input$columns
    phenames <- unique(c(selected_set, phenames))

    ## Now update list of phenotypes.
    updateCheckboxGroupInput(session, "columns",
                             choices=phenames,
                             selected=selected_set,
                             inline=TRUE)
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
