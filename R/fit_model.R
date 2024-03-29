fit_lmer_model = function(data) {
  
  data$groups = factor(data$groups)
  
  res = lmer(y ~ (1|groups), 
             data = data)
  
  return(res)
  
}