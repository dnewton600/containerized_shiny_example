library(shiny)
library(ggplot2)
library(lme4)
library(rmarkdown)

source('R/plotting_functions.R')
source('R/fit_model.R')

ui <- fluidPage(

    titlePanel("Hierarchical Modeling App"),

    sidebarLayout(
        sidebarPanel(
          fileInput(inputId='file',label='Data Upload'),
          actionButton(inputId='submit',label="Submit")
        ),

        mainPanel(
          tabsetPanel(type='tabs',
                      
            tabPanel("Raw Data",
                     br(),
                     plotOutput('boxplot'),
                     br(),
                     uiOutput('model_fit_finished')
            ),
            
            tabPanel("Modeling Results",
                     br(),
                     # make column of size 8, otherwise plot looks too large
                     column(8,
                    plotOutput('results_plot')
                     )
            ),
            
            tabPanel("Dowload Report",
                     br(),
                     downloadButton("download_report","Download Report"),
                     br(),
                     br()
            )
          )
         
        )
    )
)

server <- function(input, output) {

  
    # process uploaded file
    input_data = reactive({
      
      if(is.null(input$file$datapath)) {
        return(NULL)
      }
      
      # read in data; probably a good idea to validate file is .csv...
      data = read.csv(input$file$datapath)
      
      # run validation and check that no errors came up
      validation_results = validate_data(data)
      
      shiny::validate(
        need(validation_results$is_valid,message=validation_results$err_msg)
      )
      
      return(data)
      
    })
    
    output$boxplot = renderPlot({
      
      data = input_data()
      
      if(is.null(data$y)) {
        return(NULL)
      }
      
      # generate plot from external non-interactive R code
      the_plot = raw_data_boxplot(data)
        
      return(the_plot)
      
    })
    
    model_fit = eventReactive(input$submit, {
      
      if(is.null(input_data()$y)) {
        return(NULL)
      }
      
      # run model-fitting procedure from external non-interactive R code
      
      withProgress(message = 'Running analysis...', value = .5, {
        Sys.sleep(1) # artificial wait time to simulate more complicated algorithms
        res = fit_lmer_model(input_data())
      })
      
      return(res)
      
    })
    
    observeEvent(model_fit, {
      # this model fitting text serves 2 purposes:
      # 1. Let's the user know the model fitting has completed
      # 2. Forces the fitting code to run by adding a dependency 
      #    on this page for the model fitting code to run, otherwise
      #    shiny 'lazily' waits to run the model until a plot/etc is 
      #    needed in the current view.
      
      output$model_fit_finished = renderUI({
        
        if(class(model_fit()) != 'lmerMod') {
          return(NULL)
          
        } else {
          return(h3(paste0("Model fitting complete. ",
                           "Please navigate to the next tab to view the results.")))
        }
        
      })
      
    })
    
    output$results_plot = renderPlot({
      
      lmer_res = model_fit()
      
      if(class(lmer_res) != 'lmerMod') {
        return(NULL)
      }
      
      # generate plot from external code
      withProgress(message = 'Loading plot...', value = .5, {
        the_plot = plot_results(lmer_res)
      })
      
      return(the_plot)
      
    })
      
    output$download_report <- downloadHandler(
      filename = "Results_from_example_app.html",
      content = function(file) {
        # Write the dataset to the `file` that will be downloaded
        
        withProgress(message = "Preparing file for download...", 
                     value = .5,
                     expr = {
                       
          rmarkdown::render("./R/report.Rmd",
                            params = list(variability_plot = plot_results(model_fit()))
          )
                       
        })
        
        file.copy('./R/report.html',file)
        
      })
        
    
}

# Run the application 
shinyApp(ui = ui, server = server)
