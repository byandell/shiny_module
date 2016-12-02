library(shiny)

createLink <- function(val) {
  sprintf('<a href="https://www.google.com/#q=%s" target="_blank" class="btn btn-primary">Info</a>',val)
}

ui <- fluidPage(
  titlePanel("Table with Links!"),
  sidebarLayout(
    sidebarPanel(
      h4("Click the link in the table to see
         a google search for the car.")
      ),
    mainPanel(
      dataTableOutput('table1')
    )
    )
  )

server <- function(input, output) {

  output$table1 <- renderDataTable({

    my_table <- cbind(rownames(mtcars), mtcars)
    colnames(my_table)[1] <- 'car'
    my_table$link <- createLink(my_table$car)
    return(my_table)

  }, escape = FALSE)
}

shinyApp(ui, server)
