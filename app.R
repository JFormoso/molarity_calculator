library(shiny)
library(webchem)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  
  tags$style(HTML("
  #result pre {
    color: #00ffcc;
    background-color: #222;
    border: 1px solid #00ffcc;
    border-radius: 5px;
    padding: 10px;
    font-weight: bold;
    font-size: 1.2em;
  }
")),
  
  titlePanel("Solutions Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("mode", "Select calculation:",
                  choices = c("Mass" = "mass",
                              "Volume" = "volume",
                              "Molarity" = "molarity")),
      textInput("compound", "Insert compound", value = ""),
      actionButton("search", "Search", class = "btn-primary"),
      verbatimTextOutput("molecular_weight", placeholder = TRUE)
    ),
    
    mainPanel(
      uiOutput("dynamic_inputs"),
      verbatimTextOutput("result", placeholder = TRUE)
    )
  )
)

server <- function(input, output, session) {
  
  # Obtener peso molecular desde PubChem
  mol_weight <- eventReactive(input$search, {
    tryCatch({
      cid_result <- get_cid(input$compound, from = "name")
      if (nrow(cid_result) == 0 || is.na(cid_result$cid[1])) return(NA)
      cid <- cid_result$cid[1]
      prop <- pc_prop(cid, properties = "MolecularWeight")
      if (nrow(prop) == 0 || is.na(prop$MolecularWeight[1])) return(NA)
      as.numeric(prop$MolecularWeight[1])
    }, error = function(e) {
      print(e)
      return(NA)
    })
  })
  
  # Mostrar el peso molecular
  output$molecular_weight <- renderText({
    mw <- mol_weight()
    if (is.na(mw)) "Error: Compound not found or no molecular weight available."
    else paste("Molecular weight:", mw, "g/mol")
  })
  
  # Mostrar inputs según el modo
  output$dynamic_inputs <- renderUI({
    switch(input$mode,
           
           "mass" = tagList(
             fluidRow(
               column(6, numericInput("concentration", "Concentration:", value = 1, min = 0)),
               column(6, selectInput("concentration_unit", "Unit", 
                                     choices = c("nM" = "nM", "µM" = "uM", "mM" = "mM", "M" = "M")))
             ),
             fluidRow(
               column(6, numericInput("volume", "Volume:", value = 1, min = 0)),
               column(6, selectInput("volume_unit", "Unit", 
                                     choices = c("µL" = "uL", "mL" = "mL", "L" = "L")))
             )
           ),
           
           "volume" = tagList(
             numericInput("mass", "Mass (g):", value = 1, min = 0),
             fluidRow(
               column(6, numericInput("concentration", "Concentration:", value = 1, min = 0)),
               column(6, selectInput("concentration_unit", "Unit", 
                                     choices = c("nM" = "nM", "µM" = "uM", "mM" = "mM", "M" = "M")))
             )
           ),
           
           "molarity" = tagList(
             numericInput("mass", "Mass (g):", value = 1, min = 0),
             fluidRow(
               column(6, numericInput("volume", "Volume:", value = 1, min = 0)),
               column(6, selectInput("volume_unit", "Unit", 
                                     choices = c("µL" = "uL", "mL" = "mL", "L" = "L")))
             )
           )
    )
  })
  
  # Calcular resultado
  output$result <- renderText({
    mw <- mol_weight()
    if (is.null(mw) || is.na(mw)) return("Please search for a valid compound first.")
    
    mode <- input$mode
    
    # Unidades
    conc_factor <- switch(input$concentration_unit,
                          "nM" = 1e-9, "uM" = 1e-6, "mM" = 1e-3, "M" = 1)
    
    vol_factor <- switch(input$volume_unit,
                         "uL" = 1e-6, "mL" = 1e-3, "L" = 1)
    
    if (mode == "mass") {
      c <- input$concentration * conc_factor
      v <- input$volume * vol_factor
      mass <- c * v * mw
      return(paste("Mass =", round(mass, 5), "g"))
      
    } else if (mode == "volume") {
      c <- input$concentration * conc_factor
      if (c == 0) return("Concentration must be greater than zero.")
      vol_L <- input$mass / (c * mw)
      return(paste("Volume =", round(vol_L * 1e3, 5), "mL"))  # muestra en mL
      
    } else if (mode == "molarity") {
      v <- input$volume * vol_factor
      if (v == 0) return("Volume must be greater than zero.")
      molarity <- input$mass / (v * mw)
      return(paste("Molarity =", signif(molarity, 5), "mol/L"))
    }
  })
}

shinyApp(ui, server)
