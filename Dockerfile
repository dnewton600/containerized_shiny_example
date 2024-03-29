FROM rocker/shiny:4.3.1

RUN apt-get update -y 
    
WORKDIR /srv/shiny-server/

RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('lme4')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('rmarkdown')"

COPY . /srv/shiny-server

RUN chmod -R 775 /srv/shiny-server
RUN chgrp -R shiny /srv/shiny-server

EXPOSE 3838
