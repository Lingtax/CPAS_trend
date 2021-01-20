library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(shinyjs)
library(here)
library(patchwork)

# function to calculate the slope parameter values for the graph 
calc_weights <- function(inputs, means, weights) {
  colSums(t(inputs + means) * weights) * c(1, 1/10, 1/1000, 1/100000, 1/10000000)
}

# function to calculate postdictions
postdict <-  function(.xx, weights) {
  weights()["i"] +
  weights()["s"] * (.xx-64) +
  weights()["q"] * (.xx-64)^2 +
  weights()["c"] * (.xx-64)^3 +
  weights()["p4"]* (.xx-64)^4 
  
 }
 
 # Core graph 
 coreplot <-  function(){
   ggplot(data.frame(x = 0:180), aes(x)) +
     #lockdown period - 7th July to 26th October
     geom_rect(aes(xmin =  90, 
                   xmax = 180, 
                   ymin = -Inf, ymax = Inf), 
               fill = "grey", alpha = 0.1) +
     coord_cartesian(xlim = c(0, 180), ylim = c(0, 18)) +
     theme_classic() +
     scale_color_manual(name = "Group",
                        values = c("Non-Victoria" = "Gold",
                                   "Victoria" = "DarkBlue")
     ) +
     scale_x_continuous(breaks = c(0, 30, 60, 90, 120, 150, 180),
                        labels = as.character(lubridate::dmy("8th April, 2020") + 0:180)[(c(0, 30, 60, 90, 120, 150, 180)+1)]
     ) +
     theme(line = element_line(size = 1.5),
           text = element_text(size = 16),
           panel.grid.major.y = element_line(colour = "grey80", size = .3),
           # Force 
           panel.background = element_rect(fill = NA),
           panel.ontop = TRUE) +
     annotate("text", x = mean(c(90, 180)), y = 18, hjust = 0.5,
              label = "Melbourne lockdown", colour = "white", 
              fontface = "bold") + 
     labs(x = "Date", color = "Legend")
 } 

# Core server functionality -----------------------------------------------
server <- function(input, output) {
  
  # Reset button controls
  # observeEvent(input$reset, {
  #   reset("sidebar")
  # })
  
  # Recieve inputs from the UI ------------------------------------------
  # First value must be 1 (intercept) followed by
  # the inputs in the order they appear in the model weights table
  inputs <- reactive({
    c(1, 
      as.numeric(input$pgender), 
      input$page,
      as.numeric(input$cgender),
      input$cage,
      input$childno,
      as.numeric(input$nopartner),
      as.numeric(input$lote),
      as.numeric(input$educ),
      as.numeric(input$depr), 
      as.numeric(input$city), 
      input$introvert,
      as.numeric(input$chroncond),
      as.numeric(input$mentalcond),
      as.numeric(input$adhdasd),
      input$covidpsy, 
      input$covidrisk,
      input$media,
      as.numeric(input$child_home),
      as.numeric(input$renting),
      input$outdoorsize,
      input$homesatisfy,
      input$bedrooms,
      input$plonely, # UCLALS
      input$clonely,
      input$alcohol,
      input$conflict #Argue V
      )
  })
  
  # Contain  pre-modelled parameter weights -----------------------------
  # use the datapasta Add-in, paste table as tribble (excluding row labels)
  
  # Parent outcomes

  nv_d_mean <- tibble::tribble(~mean,  0, 0.78, 0.184,  0.489, 0.146,  0.053, 
                               0.099,  0.028, 0.082,  -0.062,  0.298, 0.045,
                               0.361, 0.424,  0.151, -0.026, -0.005, 0.03, 0.82,
                               0.315,  0.023, -0.01,  0.03,  -0.022,  0.022,
                               0.014,  -0.054)
                                
  nv_depr <-  tibble::tribble(
         ~i,     ~s,     ~q,     ~c,    ~p4,
      6.208, -0.023,  0.262, -0.511,  0.286,
     -0.819, -0.187,  0.099,  0.389, -0.292,
      0.149,  0.107, -0.175, -0.191,  0.198,
      0.533,  0.179, -0.124, -0.132,  0.099,
     -0.113, -0.051,  0.129,  0.165, -0.148,
      0.192, -0.036,   0.08,  0.206, -0.267,
     -0.321, -0.155, -0.026,  0.331, -0.186,
     -2.237, -0.382,  0.741,  1.246, -1.383,
      2.342,   0.31, -0.405, -0.337,  0.573,
      0.794,  0.024,  0.173, -0.021, -0.149,
     -0.184, -0.155,   0.14,  0.389, -0.347,
      0.723, -0.011,  -0.08,  0.147,  -0.05,
      0.342,  0.008, -0.043, -0.232,  0.186,
      2.496,  0.011,  0.216,  0.285, -0.459,
       0.69, -0.105, -0.495,   0.03,  0.512,
      0.684,  0.057, -0.007, -0.022,  0.019,
      0.629, -0.087,  0.094,  0.169, -0.147,
      0.175, -0.014,  0.167,   0.09, -0.222,
      0.188,  0.007,  0.118,  0.062, -0.148,
      1.332,  0.033,  0.032,  0.104, -0.041,
     -0.562,  -0.01,  0.069, -0.011, -0.039,
      -0.45, -0.024, -0.071, -0.032,  0.145,
     -0.009, -0.064,  0.112,  0.313, -0.342,
      2.415, -0.069, -0.142, -0.106,  0.344,
      0.701, -0.047,  0.059, -0.046,  0.041,
      0.317, -0.053,  0.093,  0.141, -0.176,
      0.428,   0.12, -0.023,  -0.22,  0.102
     )

  v_d_mean <-   tibble::tribble(~mean,  0, 0.854,  -0.052,  0.498, -0.105, 
                                -0.047, 0.111,  0.046, 0.08, 0.001,  0.29,  
                                -0.053,  0.319, 0.408,  0.13,  -0.01, 0.01, 
                                -0.001, 0.88, 0.275,  -0.026,  0.016, -0.027, 
                                -0.008, -0.027, 0.002,  0.013)
  
  
  v_depr <- tibble::tribble(
         ~i,     ~s,     ~q,     ~c,    ~p4,
      9.127,  0.403,  0.081, -0.957,  0.573,
     -0.884, -0.238,  0.828,  0.884, -1.243,
     -0.273, -0.055,  0.082,  0.287, -0.264,
     -0.675, -0.115,   0.12,  0.254, -0.205,
      0.305,  0.041, -0.081, -0.222,  0.263,
      0.418, -0.075,    0.1,  0.351, -0.342,
     -1.385, -0.233,  0.417,  0.943, -1.189,
     -0.621,  0.118, -0.439, -1.146,  1.571,
      0.022,  0.013,  0.064, -0.398,  0.472,
      0.501,  0.027,  -0.11, -0.293,  0.355,
     -0.611, -0.196,  0.199,  0.372, -0.373,
      0.351,  0.016, -0.074, -0.148,   0.17,
      0.328, -0.059, -0.001,  0.251, -0.225,
      2.144,  0.049,  0.107, -0.088,  -0.11,
     -0.164, -0.231, -0.184,  0.803, -0.439,
      0.518,  0.073, -0.144, -0.285,  0.369,
      0.498, -0.074,  0.257,  0.194, -0.383,
     -0.577, -0.035,  0.255,  0.124, -0.292,
     -0.266, -0.011, -0.047,  0.034, -0.018,
      0.528, -0.019,   0.02,  0.261, -0.278,
     -0.058,  0.049, -0.312, -0.394,  0.607,
     -0.879, -0.002,  0.073, -0.097,  0.025,
      0.248, -0.029,  0.056, -0.003,  0.053,
      3.174, -0.024,  0.034,  0.116,  -0.05,
      0.371,   0.06,  0.128, -0.162,  0.007,
      0.096,  0.009,   0.05, -0.076, -0.027,
      0.876,  -0.07,  0.073,  0.274, -0.298
     )

  

  #nv_anx_mean <- 
  #nv_anx <-
  #v_anx_mean <-    
  #v_anx <-  

  #nv_stress_mean <-  
  #nv_stress <-  
  #v_stress_mean <-  
  #v_stress <-  
  
  # Child outcomes
  
  #nv_cdep_mean <-  
  #nv_cdep <-  
  #v_cdep_mean <-  
  #v_cdep <-  
  
  #nv_canx_mean <-  
  #nv_canx <-  
  #v_canx_mean <-  
  #v_canx <-  
  
  
  
  # calculates weights given input parameters------
  
  
  depr_nv <-  reactive({
    calc_weights(inputs(), nv_d_mean, nv_depr)
  })
  
  depr_v <-  reactive({
    calc_weights(inputs(), v_d_mean, v_depr)
  })
  
  
  # Generates dignostic outputs for display------
  # output$inputs <- renderTable((inputs()))
  # output$v_params <- renderTable(t(depr_v()))
  # output$nv_params <- renderTable(t(depr_nv()))
  
  
  # Reference plot of daily cases -------------------------------------------
  
  refdat <- readRDS(here::here("data", "refdata.RDS"))
  refplot <- refdat %>% ggplot(aes(date, positives, colour = state_abbrev)) +
    # lockdown period - 7th July to 26th October
    geom_rect(aes(xmin = date(dmy("8th april, 2020") + 90), 
                  xmax = date(dmy("8th April, 2020") + 180), 
                  ymin = -Inf, ymax = Inf),
              fill = "grey", alpha = 0.2,  data = tibble(x= 0:180), inherit.aes = FALSE) +
    geom_line() +
    theme_classic() +
    theme(line = element_line(size = 1.5),
          text = element_text(size = 16),
          panel.grid.major.y = element_line(colour = "grey80", size = .3)) + 
    labs(Title = "Daily COVID-19 positive tests",  y = "Positive tests", x = "Date", colour = "State")
  
  
  
  # Generate and composite plots per page -----------------------------------
  
  # x =  time  0 == April 8th
  output$deprPlot <- renderPlot({
    
    p1 <-  coreplot()  +
      # Model
      geom_function(fun = postdict, args = list(weights = depr_nv),
        aes(color = "Non-Victoria")
      ) +
      geom_function(fun = postdict, args = list(weights = depr_v),
        aes(color = "Victoria")
      ) + 
      labs(title = "Modelled Parent Depression over time", y = "Parent depression")
    
    
    (p1 / refplot) + plot_layout(heights = c(2, 1))
    
    
    
  }, height = 600)
  
  
}



