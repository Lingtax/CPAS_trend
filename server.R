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
  
  # Recieve inputs from the UI ------------------------------------------
  # First value must be 1 (intercept) followed by
  # the inputs in the order they appear in the model weights table
  inputs <- reactive({
    c(1, input$depr, input$covidpsy, input$covidrisk)
    })

  # Candidate variable input formats below.
  # 
  # input$page
  # input$pgender
  # input$cage
  # input$cgender
  # input$childno
  # input$lote
  # input$atsi
  # input$nopartner
  # input$city
  # input$deprinput$homesatisfy
  # input$bedrooms
  # input$educ
  # input$renting
  # input$introvert
  # input$chroncond
  # input$mentalcond
  # input$adhdasdinput$covidpsy
  # input$covidrisk
  # input$media
  # input$plonely
  # input$clonely
  # input$alcohol
  # input$conflict
  # input$childbehv
  # input$child_home
    
  # Contain  pre-modelled parameter weights -----------------------------
  # use the datapasta Add-in, paste table as tribble (excluding row labels)
  
  # Parent outcomes
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
  #nv_anx <-  
  #v_anx <-  
  #nv_stress <-  
  #v_stress <-  
  
  # Child outcomes
  
  #nv_cdep <-  
  #v_cdep <-  
  #nv_canx <-  
  #v_canx <-  


  
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
    # lockdown period
    geom_rect(aes(xmin = date(dmy("8th april, 2020") + 90), 
                  xmax = date(dmy("8th April, 2020") + 201), 
                  ymin = -Inf, ymax = Inf),
              fill = "grey", alpha = 0.2,  data = tibble(x= 0:209), inherit.aes = FALSE) +
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
      #lockdown period
      geom_rect(aes(xmin =  90, 
                    xmax = 201, 
                    ymin = -Inf, ymax = Inf), 
                fill = "grey", alpha = 0.1) +
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
            panel.grid.major.y = element_line(colour = "grey80", size = .3),
            # Force 
            panel.background = element_rect(fill = NA),
            panel.ontop = TRUE) + 
      labs(y = "Parent depression", x = "Date", color = "Legend", 
           title = "Modelled Parent Depression over time", 
           caption = "Shaded region represents Melbourne lockdown")  +
      # Model
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
      annotate("text", x = mean(c(90, 201)), y = 18, hjust = 0.5,
                        label = "Melbourne lockdown", colour = "white", 
               fontface = "bold")
      
      #experimental annotation layers Lockdown 7th July to 26th October
      
      # geom_vline(xintercept = 90, colour = 'red') + 
      # annotate("text", x = 93, y = 12, hjust = 0,
      #          label = "Melbourne enters \nsecond lockdown") + 
      # geom_vline(xintercept = 201, colour = 'red') + 
      # annotate("text", x = 198, y = 12, hjust = 1,
      #          label = "Melbourne exits \nsecond lockdown") 

    
    (p1 / refplot) + plot_layout(heights = c(2, 1))
    


  }, height = 600)
  

}
