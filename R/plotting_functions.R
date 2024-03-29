raw_data_boxplot = function(data) {
  
  theplot = ggplot(data,aes(group=groups,x=groups,y=y)) + 
    geom_boxplot() + 
    xlab("Experimental Replicate") +
    ylab("Measurement Value") +
    ggtitle("Raw Data Plot") +
    theme(plot.title = element_text(hjust = 0.5))
  
  return(theplot)
  
}

plot_results = function(lmer_res) {
  
  sres = summary(lmer_res)
  
  df_for_plot = as.data.frame(sres$varcor)
  df_for_plot = df_for_plot[,c('grp','sdcor')]
  
  confints = confint(lmer_res)
  df_for_plot$q025 = confints[1:2,1]
  df_for_plot$q975 = confints[1:2,2]
  
  
  plot_out = ggplot(df_for_plot,aes(x=sdcor,y=grp)) +
    geom_point() +
    geom_errorbarh(aes(xmin=q025,xmax=q975),height=0) +
    xlab("Estimate and 95% Confidence Interval") +
    ylab("Source of Variability") +
    ggtitle("Sources of Variability")

  return(plot_out)
}

