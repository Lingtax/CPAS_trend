library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(shinyjs)
library(here)
library(patchwork)

# function to calculate the slope parameter values for the graph 
calc_weights <- function(inputs, weights) {
  colSums(inputs * weights) * c(1, 1/10, 1/1000, 1/10, 1/1000, 1/100000)
}

# Core server functionality -----------------------------------------------

server <- function(input, output) {

  # Reset button controls
  observeEvent(input$reset, {
    reset("sidebar")
  })
  
  # recieves inputs from the UI
  inputs <- reactive({
    c(1, input$depr, input$covidpsy, input$covidrisk)
    })
  
  # contains  pre-modelled parameter weights
  nv_depr <-  tibble::tribble(
        ~i,   ~s1,    ~q1,    ~s2,    ~q2,    ~c2,
     4.446, 2.027, -2.257,   0.26,   0.02, -0.136,
     0.956, 0.475, -0.532,   0.37, -0.568,  0.256,
      0.35, 0.232, -0.203,  0.004,   0.13, -0.105,
     0.908, 0.241, -0.224, -0.269,  0.654, -0.362
     )
  
  v_depr <- tibble::tribble(
                    ~i,   ~s1,    ~q1,    ~s2,    ~q2,    ~c2,
                 4.494,  2.43, -2.844,  1.963, -2.435,  0.818,
                 0.915, 0.287,  -0.31, -0.372,  0.852, -0.463,
                  0.64, 0.235,  -0.27,  0.255, -0.407,  0.184,
                 0.682, 0.337, -0.475,  0.448, -0.827,  0.406
                 )


  
# calculates weights given input parameters------
  
     
  depr_nv <-  reactive({
        calc_weights(inputs(), nv_depr)
    })
  
  depr_v <-  reactive({
        calc_weights(inputs(), v_depr)
    })
  
  
# Generates dignostic outputs for display------
  #output$inputs <- renderTable(t(inputs()))
  #output$v_params <- renderTable(t(v()))
  #output$nv_params <- renderTable(t(nv()))


# Reference plot of daily cases -------------------------------------------

  refdat <- readRDS(here::here("data", "refdata.RDS"))
  refplot <- refdat %>% ggplot(aes(date, positives, colour = state_abbrev)) +
    geom_line() +
    theme_classic() +
    theme(line = element_line(size = 1.5),
          text = element_text(size = 16),
          panel.grid.major.y = element_line(colour = "grey80", size = .3)) + 
    labs(Title = "Daily COVID-19 positive tests",  y = "Positive tests", x = "Date", colour = "State")
  


# Generate and composite plots per page -----------------------------------

  # x =  time  0 == April 8th
  output$deprPlot <- renderPlot({

    p1 <-  ggplot(data.frame(x = 0:209), aes(x)) +
      geom_function(fun = function(x) 
        depr_nv()[1] +
          depr_nv()[2]*ifelse(x>74, 74, x) +
          depr_nv()[3]*ifelse(x>74, 74, x)^2 +
          depr_nv()[4]*ifelse(x<75, 0, x-75) +
          depr_nv()[5]*ifelse(x<75, 0, x-75)^2 +
          depr_nv()[6]*ifelse(x<75, 0, x-75)^3,
                    aes(color = "Non-Victoria")
      ) +
      geom_function(fun = function(x) 
        depr_v()[1] +
          depr_v()[2]*ifelse(x>74, 74, x) +
          depr_v()[3]*ifelse(x>74, 74, x)^2 +
          depr_v()[4]*ifelse(x<75, 0, x-75) +
          depr_v()[5]*ifelse(x<75, 0, x-75)^2 +
          depr_v()[6]*ifelse(x<75, 0, x-75)^3,
                    aes(color = "Victoria")
      ) +
      coord_cartesian(xlim = c(0, 209), ylim = c(0, 18)) +
      theme_classic() +
      scale_color_manual(name = "Group",
                         values = c("Non-Victoria" = "Gold",
                                    "Victoria" = "DarkBlue")
      ) +
      scale_x_continuous(breaks = c(0, 50, 100, 150, 200),
      labels = as.character(lubridate::dmy("8th April, 2020") + 0:209)[(c(0, 50, 100, 150, 200)+1)]
      ) +
      theme(line = element_line(size = 1.5),
            text = element_text(size = 16),
            panel.grid.major.y = element_line(colour = "grey80", size = .3)) + 
      labs(y = "Depression", x = "Date", color = "Legend") +
      
      #experimental annotation layers Lockdown 7th July to 26th October
      geom_vline(xintercept = 90, colour = 'red') + 
      annotate("text", x = 93, y = 12, hjust = 0,
               label = "Melbourne enters \nsecond lockdown") + 
      geom_vline(xintercept = 201, colour = 'red') + 
      annotate("text", x = 198, y = 12, hjust = 1,
               label = "Melbourne exits \nsecond lockdown") 

    
    p1 / refplot


  })
  

}
