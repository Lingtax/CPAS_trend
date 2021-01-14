
# Define UI
ui <- tagList(#useShinyjs(), # Include shinyjs in the UI
    tags$style(HTML(".irs-bar {width: 100%; height: 5px;}")),
    tags$style(HTML(".irs-bar-edge {height: 5px;}")),
    tags$style(HTML(".irs-line {height: 5px;}")),
    tags$style(HTML(".irs-grid-text {font-family: 'arial'; font-size: 11px}")),
    tags$style(HTML(".irs-max {font-family: 'arial'; color: black;}")),
    tags$style(HTML(".irs-min {font-family: 'arial'; color: black;}")),
    tags$style(HTML(".irs-slider {width: 15px; height: 15px; top: 20px;}")), # slider ball controls
    
     tags$style(HTML("* {font-size: 12px;}")),
    #tags$style(HTML("p {font-size: 11px}")),
    navbarPage("CPAS explorer",
                 
    # Main Panel
    tabPanel("Dashboard",
             
               # Panel for output displays
               column(6,
                      
                      p("The current study investigated the association between the developing COVID-19 crisis in Australia and parent/child mental health outcomes in 2,365 families experiencing sustained lockdown in Victoria compared to the rest of Australia, from April to early November 2020."), 
                      p("Variables in the model can be varied with controls on the right to show postdictions of the trajectory for individuals under those conditions through the study period."),
                      
                      # This nested tabset panel lets the user switch between
                      # outcomes while preserving levels of the input variables
                      tabsetPanel(
                                  
                                  tabPanel("Parent depression",
                                   # Commented tables (for diagnostics)
                                #tableOutput("inputs"),
                                #tableOutput("nv_params"),
                                #tableOutput("v_params"),
                                    plotOutput("deprPlot")
                                    
                           ),
                           tabPanel("Parent anxiety",
                                    
                                    #plotOutput("anxPlot")
                                    
                           ),
                           tabPanel("Parent stress",
                                    
                                    #plotOutput("anxPlot")
                                    
                           ),
                           tabPanel("Child Depression",

                               # plotOutput("cdepPlot")

                      ),
                           tabPanel("Child anxiety",

                      #          plotOutput("canxPlot")

                      )
               )
             ),
             
             # Sidebar  
             fluidRow(
                 div(id = "sidebar",
                     column(2, 
                            sliderInput("page",
                                        "Reporting parent age:",
                                        min = -1,
                                        max = +1,
                                        value = 0
                                        ),
                            radioButtons("pgender", "Parent Gender:",
                                         c("Male" = 1,
                                           "Female" = 2,
                                           "Non-binary" = 3)
                            ),
                            sliderInput("cage",
                                        "Child age:",
                                        min = -1,
                                        max = +1,
                                        value = 0
                                        ),
                            radioButtons("cgender", "Child Gender:",
                                         c("Male" = 1,
                                           "Female" = 2,
                                           "Non-binary" = 3)
                            ),
                            sliderInput("childno",
                                        "Number of Children:",
                                        min = -1,
                                        max = +1,
                                        value = 0
                                        ),
                            radioButtons("lote", "Primary language other than English:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("atsi", "Aboriginal and Torres Strait Islander status:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("nopartner", "Single parent:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("city", "Major city:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            )
                            
                     ),
                     column(2,
                            
                            # socioeconomic disadvantage
                            sliderInput("depr",
                                        "Financial Deprivation:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("homesatisfy",
                                        "Satisfaction with home:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("bedrooms",
                                        "Number of bedrooms in home:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            radioButtons("educ", "Low education:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("renting", "Renting:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            #Individual Risk factors
                            hr(),
                            sliderInput("introvert",
                                        "Parent introversion:",
                                        min = -1,
                                        max = +1,
                                        value = 0
                                        ),
                            radioButtons("chroncond", "Parent chronic health condition:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("mentalcond", "Parent mental health diagnosis:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            radioButtons("adhdasd", "Child ADHD or ASD diagnosis:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            ),
                            
                            
                            ),
                     column(2, 
                            # Pandemic factors
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
                            sliderInput("media",
                                        "Use of news media:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("plonely",
                                        "Parent Loneliness:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("clonely",
                                        "Child Loneliness:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("alcohol",
                                        "Parent Alcohol use:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("conflict",
                                        "Couple verbal conflict:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            sliderInput("childbehv",
                                        "Child behaviour problems:",
                                        min = -1,
                                        max = +1,
                                        value = 0),
                            radioButtons("child_home", "Child at home while working:",
                                         c("No" = 0,
                                           "Yes" = 1)
                            )#,
                            
                            
                            #actionButton("reset", "Reset variables")
                     )
                     
                 ) # div end  - all controls must be inside for reset
             )
             ),
    
    # about panel
    tabPanel("About",
             fluidPage(
               fluidRow(
                 column(12,
                        h1("About the CPAS study"),
                        "The COVID-19 Pandemic Adjustment Survey (CPAS) is a longitudinal research study investigating how Australian families have been affected by the COVID-19 pandemic. Australia experienced early success after a nation-wide lockdown in April 2020. However, the state of Victoria went on to experience an outbreak and one of the longest and strictest lockdowns in the world over July-October 2020, while the rest of Australia had low infection rates and easing restrictions. In the current analysis, we investigated the association between the developing COVID-19 crisis and parent/child mental health outcomes in families experiencing sustained lockdown in Victoria compared to the rest of Australia, from April to early November 2020.",
                        br(),
                        br(),
                        "This is an experimental dashboard for displaying model outputs from the CPAS project.",
                        br(),
                        br(), 
                        "Authors: Elizabeth Westrupp, Christopher Greenwood, Mathew Ling, Gery Karantzas, Jacqui Macdonald, Emma Sciberras, Antonina Mikocka-Walus, Robert Cummins, Delyse Hutchinson, Glenn. A Melvin, Julian Fernando, Samantha Teague, Amanda Wood, John Toumbourou, Tomer S Berkowitz, Jake Linardon, Lisa Olive, Peter Gregory Enticott, Mark Andrew Stokes, Jane McGillivray, Craig Olsson, Matthew Fuller-Tyszkiewicz and George Youssef",
                        br(),
                        br(),
                        "The CPAS data are augmented by data from ", a(href = "www.covid19data.com.au",  "www.covid19data.com.au"), 
                        ". Support their work at ", a(href = "https://www.covid19data.com.au/about", "https://www.covid19data.com.au/about"), ".",
                        br(),
                        br(),
                        "This app was developed in Shiny by", a(href = "http://twitter.com/Lingtax", "Mathew Ling")
                 )
               )
             )
    )

)
)
