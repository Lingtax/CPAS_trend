
# Define UI
ui <- navbarPage("CPAS explorer",
    
                 # Main Panel
    tabPanel("Dashboard",
             # Sidebar  
             fluidRow(
                 div(id = "sidebar",
               column(2, 
                      
                      # sliderInput("time",
                      #             "Timepoint:",
                      #             min = -1,
                      #             max = +1,
                      #             value = 0),
                      sliderInput("depr",
                                  "Financial Deprivation:",
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
                      sliderInput("homesatisfy",
                                  "Satisfaction with home:",
                                  min = -1,
                                  max = +1,
                                  value = 0),
                      sliderInput("introvert",
                                  "Parent introversion:",
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
                                  value = 0)
                      
                      ),
               column(2,
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
                      sliderInput("childno",
                                  "Number of Children:",
                                  min = -1,
                                  max = +1,
                                  value = 0),
                      radioButtons("lote", "Primary language other than English:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      ),
                      radioButtons("atsi", "Aboriginal and Torres Strait Islander status:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      )),
               column(2, 
                      radioButtons("nopartner", "Single parent:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      ),
                      radioButtons("educ", "Low education:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      ),
                      radioButtons("city", "Major city:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      ),
                      radioButtons("renting", "Renting:",
                                   c("No" = 0,
                                     "Yes" = 1)
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
                      radioButtons("child_home", "Child at home while working:",
                                   c("No" = 0,
                                     "Yes" = 1)
                      ),
                      
                      useShinyjs(), # Include shinyjs in the UI
                      actionButton("reset", "Reset variables")
               )
               
               ), # div end  - all controls must be inside for reset
               
               # Show a plot of the generated distribution
               column(6,
                      
                      "The current study investigated the association between the developing COVID-19 crisis in Australia and parent/child mental health outcomes in 2,365 families experiencing sustained lockdown in Victoria compared to the rest of Australia, from April to early November 2020.", 
                      
                      br(), 
                      
                      tabsetPanel(
                                  
                                  tabPanel("Depression",
                                   # Commented tables (for diagnostics)
                                #tableOutput("inputs"),
                                #tableOutput("nv_params"),
                                #tableOutput("v_params"),
                                    plotOutput("deprPlot")
                                    
                           ),
                           tabPanel("Child anxiety",

                               # plotOutput("refPlot")

                      ),
                      tabPanel("Child Depression",

                      #          plotOutput("refPlot")

                      )
               )
             )
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

