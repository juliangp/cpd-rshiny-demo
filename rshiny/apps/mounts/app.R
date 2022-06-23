library(shiny)

# Define UI for app that shows mounted directories ----
ui <- fluidPage(
  # App title ----
  titlePanel("Shiny Application Mounts"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: the directory to search for mounts ----
      textInput(
        inputId = "rootDirectory",
        label = "Mount directory:",
        value = "/mnts"
      )
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Directories",
          dataTableOutput('table')
        )
        #,
        #tabPanel(
        #  "Create file",
        #  textInput(
        #    inputId = "createFile",
        #    label = "File in /mnts:",
        #    value = ""
        #  )
        #)
      )
    )
  )
)

# Define server logic required to get the mount directories ----
server <- function(input, output) {
  output$table <- renderDataTable({
    files <- list.dirs(path = input$rootDirectory, full.names = FALSE, recursive = TRUE)
    df <- data.frame()
    for (f in files) {
      full <- paste0(input$rootDirectory, '/', f)
      info <- file.info(full)
      # print(info[3])
      mfiles <- list.dirs(path = full, full.names = FALSE, recursive = FALSE)
      newRow <- data.frame(Mount = full, Access = info[3], Files = length(mfiles))
      df <- rbind(df, newRow)
    }
    df
  })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
