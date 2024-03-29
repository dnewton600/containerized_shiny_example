
input_ui = function(id) {
  
  tagList(
    "Raw Data",
    br(),
    plotOutput('boxplot'),
    br(),
    uiOutput('model_fit_finished')
  )
  
}

input_server = function() {
  
  moduleServer(
    id,
    function(input,output,session) {
      
      
      
    }
    
  )
  
}
