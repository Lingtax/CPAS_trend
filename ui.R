
# Define UI
ui <- navbarPage("CPAS explorer",
    
                 # Main Panel
    tabPanel("Dashboard",
             # Sidebar  
             fluidRow(
               column(3, 
                      div(id = "sidebar",
                      # sliderInput("time",
                      #             "Timepoint:",
                      #             min = -1,
                      #             max = +1,
                      #             value = 0),
                      sliderInput("depr",
                                  "Relative Deprivation:",
                                  min = -1,
                                  max = +1,
                                  value = 0),
                      sliderInput("covidpsy",
                                  "COVID Psychological stressors:",
                                  min = -1,
                                  max = +1,
                                  value = 0),
                      sliderInput("covidrisk",
                                  "COVID Environmental Stressors:",
                                  min = -1,
                                  max = +1,
                                  value = 0),
                      
                      useShinyjs(), # Include shinyjs in the UI
                      actionButton("reset", "Reset variables")
                      )
               ),
               
               # Show a plot of the generated distribution
               column(9,
                      tabsetPanel( 
                          tabPanel("Depression",
                      "Demonstration text", 
                      tableOutput("inputs"),
                      #tableOutput("nv_params"),
                      #tableOutput("v_params"),
                      plotOutput("deprPlot")
                          ),
                      tabPanel("Other outcome")
               
                      )
               )
             )
             ),
    
    # about panel
    tabPanel("About",
             fluidPage(
               fluidRow(
                 column(12,
                        "This is an experimental dashboard for displaying model outputs from the CPAS project.",
                        br(),
                        br(), 
                        "Authors: ",
                        br(),
                        "This app was developed in Shiny by", a(href = "http://twitter.com/Lingtax", "Mathew Ling")
                 )
               )
             )
    )
    
    
    
)

