---
title: "Shiny Module Learning"
author: "Brian S Yandell"
date: "May 19, 2016"
output: html_document
---

This project is about learning how to use Shiny modules. I developed these as my modules were crashing, and I wanted to break down into simple steps. See links below for official resources.

* [2016 Shiny Developer Conference](https://www.rstudio.com/resources/webinars/shiny-developer-conference/)
    + see talk by Garrett
    + [Conference Material](https://github.com/rstudio/ShinyDeveloperConference)
    + [Conference Material](https://github.com/rstudio/ShinyDeveloperConference/Modules)
* [Modularizing Shiny app code (Joe Cheng article)](http://shiny.rstudio.com/articles/modules.html)
* [Shiny Gallery](http://shiny.rstudio.com/gallery/progress-bar-example.html)
    + [Update Input](http://shiny.rstudio.com/gallery/update-input-demo.html)
    + [Dynamic UI](http://shiny.rstudio.com/gallery/dynamic-ui.html)
    + [Conditional Panel](http://shiny.rstudio.com/gallery/conditionalpanel-demo.html)
    + [Progress Bar](http://shiny.rstudio.com/gallery/progress-bar-example.html)

The folder has several R scripts.
Latest material is in the [oldfaithful](https://github.com/byandell/shiny_module/tree/master/oldfaithful) folder.
See also [Conference Material on Modules](https://github.com/rstudio/ShinyDeveloperConference/Modules). These were adapted from and inspired by Garrett's talk. Each file is a complete shiny app that can be run.

* `simple.R` simple Shiny script using sliderInput() and textOutput()
* `module.R` simple.R modified to have key components in Shiny module
* `nested.R` example nesting two modules
* `*_renderUI.R` examples using renderUI() in server and uiOutput() in ui 
* `*_observeEvent.R` examples using observeEvent() for actionButton()
* `*_observe.R` examples using observe() for checkboxInput()
* `*_renderUI_*.R` examples using renderUI and observe() or observeEvent()

Key things to notice about namespace use for modules:

* module UI and server must use same id
    + `sliderTextUI("module")` # in ui function
    + `callModule(sliderText, "module", ...)` # in server function
* module server needs `session` as third argument
* return argument from module server (if any) must be reactive()
* module UI needs two nameserver components
    + `ns <- NS(id)` # to create namespace ID function
    + `tagList(` # tag list to wrap UI entries
    + `sliderInput(ns("slider"), ...)` # to use namespace ID
    + `)` # ends tag list
* module server has no special arrangements *except* in use of renderUI()
    + `ns <- server$ns` # to access namespace ID function
    + `output$set_slider <- renderUI({`
    + `sliderInput(ns("slider"), ...)` # to use namespace Id
    + `})`
* module server has no special arrangements for `update*Input`
    + `updateSliderInput(server, "slider", ...)`
    + used in `observe()` and `observeEvent()` 
* `conditionalPanel` does not work as expected with modules
    + see worked examples in [oldfaithful](https://github.com/byandell/shiny_module/tree/master/oldfaithful) folder
    + `condition` argument is interpreted by javascript
    + `input` elements for a module namespace require care with JS
    + see [Rstudio Shiny issue](https://github.com/rstudio/shiny/issues/1586) or [TB Adams gist](https://gist.github.com/tbadams45/49c71a4314f6b4f299583f4ba96fee54) for helpful solutions 

