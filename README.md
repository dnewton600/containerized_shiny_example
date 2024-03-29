This repo is intended to demonstrate the following concepts:
 1. A statistical R shiny application with fundamental concepts (data upload, data validation, modeling, plot generation, report download)
 2. An example of isolation/modularity between backend logic and front end reactivity
 3. How to containerize an R shiny application for sharing or deployment

To run this application from Docker, one should first download Docker and this repository, and then navigate to the top level directory via command line (e.g., Git Bash for windows, Bash for Linux). Then, run the command
```
docker build -t shiny_example .
```
This tells Docker to build an image named `shiny_example` using the template Dockerfile found at the current working directory `.`. On Linux or mac, you may need to put `sudo` before the command if you get a permission denied message.

Once the image is built, you should be able to start a container using that image by running the following:
```
docker run -d -p 8080:3838 shiny_example
```
The `-d` flag runs the command in the background, and `-p 8080:3838` indicates the port mapping. For this example, since the `rocker/shiny` base image is used, the `3838` argument of the port needs to stay as `3838`, otherwise this won't work (unless you go into the configuration files and change the port accordingly). However, the `8080` port can be changed to any (open) port that you would like, e.g., `80` for the default HTTP port.
