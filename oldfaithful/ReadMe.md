---
title: "Shiny Module Diagnostics"
author: "Brian S Yandell"
date: "May 9, 2017"
output: html_document
---

This is about diagnostics with the Old Faithful example.

- [ReactLog](http://shiny.rstudio.com/reference/shiny/latest/showReactLog.html)
    + options(shiny.reactlog=TRUE) # from command line
    + start fresh shiny session (with no modules)
    + Command-fn-F3 # during session
    + showReactLog(time=TRUE) # after session
- [Debugging](http://shiny.rstudio.com/articles/debugging.html)
    + cat(file=stderr(), …) # anywhere in server() logic
    + options(shiny.error=browser) # from command line
    + Web browser: right click inspect element
    + JavaScript Dev mode OSX
- [Sending data from client to server](https://ryouready.wordpress.com/2013/11/20/sending-data-from-client-to-server-and-back-using-shiny/) (this subverts input system)
    + Shiny Modules (DevConf talk by Garrett)
    + <https://github.com/byandell/shiny_module>
- [ShinyURL](https://gallery.shinyapps.io/shinyURL)

Inspecting input with modules using breakpoints or browser().
Put breakpoint at `hist(faithful$eruptions,` in `oldfaithful_sidepanel.R` and query `input`:

```
Browse[2]> names(input)
[1] "bw_adjust"      "density"        "individual_obs" "n_breaks"      
Browse[2]> ns("density")
[1] "faithful-density"
Browse[2]> input$density
[1] TRUE
Browse[2]> class(input)
[1] "reactivevalues"
Browse[2]> str(input)
```

Server logic order is arbitrary and tricky. Don't expect things to be done in any particular order. Run `oldfaithful_sidepanel_renderUI.R` and notice error messages printed on console as you click checkbox for `Show density estimate`.
