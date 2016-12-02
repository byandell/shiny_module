## app.R ##
suppressPackageStartupMessages({
  library(doqtl2)
  library(shiny)
  library(shinydashboard)
  library(GGally)
})

source(system.file("shiny/setup.R", package="doqtl2"))

#####################################################
ui <- navbarPage("Update",
                 tabPanel("settings",
                textOutput("num_pheno"),
                uiOutput("chr_pos")),
                tabPanel("window",
                shinyWindowUI("window")),
                tabPanel("phenos",
                shinyPhenosUI("phenos")),
                tabPanel("peaks",
                shinyPeaksInput("shinypeaks"),
                shinyPeaksOutput("shinypeaks"))
)

server <- function(input, output, session) {
  ## Reactives for testPhenos.
  pheno_typer <- reactive({pheno_type})
  peaks_tbl <- reactive({peaks})
  pmap_obj <- reactive({pmap})
  analyses_tblr <- reactive({analyses_tbl})

  hot_peak <- callModule(shinyPeaks, "shinypeaks",
                         pheno_typer, peaks_tbl, pmap_obj)

  ## Use peaks as input to shinyWindow.
  win_par <- callModule(shinyWindow, "window",
                        pmap_obj, hot_peak)

  ## Use window as input to shinyPhenos.
  pheno_anal <- callModule(shinyPhenos, "phenos",
                           pheno_typer, peaks_tbl, analyses_tblr,
                           hot_peak, win_par)

  output$chr_pos <- renderText({
    cat(file=stderr(), "chr_pos", win_par$chr_id, "pos",
        win_par$peak_Mbp, "\n")
    chr_id <- win_par$chr_id
    if(is.null(chr_id))
      chr_id <- "?"
    peak_Mbp <- win_par$peak_Mbp
    if(is.null(peak_Mbp))
      peak_Mbp <- "?"
    else
      peak_Mbp <- round(peak_Mbp, 2)
    window_Mbp <- win_par$window_Mbp
    if(is.null(window_Mbp))
      window_Mbp <- "?"
    paste0("Region: ", chr_id, "@", peak_Mbp,
           "  ", HTML("&plusmn;"), " ", window_Mbp, "Mbp")
  })
  hr_num <- function(x, digits_ct=0) {
    x <- gdata::humanReadable(x, digits=digits_ct, sep="",
                              standard="SI",
                              justify=c("right","right"))
    substring(x, 1, nchar(x) - 1)
  }
  output$num_pheno <- renderText({
    tot_pheno <- nrow(analyses_tbl %>% distinct(pheno))
    tot_pheno <- hr_num(tot_pheno, 2)
    paste("Phenotypes:", 0, "of", tot_pheno)

  })
  observeEvent(pheno_anal(), {
    output$num_pheno <- renderText({
      pheno <- pheno_anal()
      if(any(c("all","none") %in% pheno))
        return(NULL)
      num_pheno <- length(unique(pheno))
      tot_pheno <- nrow(analyses_tbl %>% distinct(pheno))
      ## Put in human-readable format
      num_pheno <- hr_num(num_pheno, 0)
      tot_pheno <- hr_num(tot_pheno, 2)
      paste("Phenotypes:", num_pheno, "of", tot_pheno)
    })
  })
}

shinyApp(ui, server)
