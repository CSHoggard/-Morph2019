### Morph2019 (Practical One): Folsom point examination
### Author: Dr. Christian Steven Hoggard (University of Southampton)

### Please ensure all necessary packages are installed into your RStudio software, either manually or through the Setup.R file (see GitHub)
### Also ensure that all files from GitHub are in a specific folder and set the working directory to that folder. 

### Stage One: Set working directory and load packages --------------------------

library(geomorph) #geomorph 3.1.2. (Package for landmark analysis)
library(tidyverse) #tidyverse 1.2.1 (Suite of packages for data manipulation and visualisation)
library(GUImorph) #GUImorph 1.0.2.05.19.20 (Developing package for landmarking)


### Stage Two (1): Landmarking in geomorph --------------------------------------

model <- read.ply("", ShowSpecimen = TRUE, addNormals = TRUE) ### importing a .ply model
digit.fixed(model, 4, index = FALSE, center = TRUE) ### digitising four landmarks on a model

#or...

GUImorph() ### GUI-based option: developmental pre-release (https://zenodo.org/record/1407792)


### Stage Two (2): Importing landmark data from .tps file -----------------------

lmdataset <- readland.tps(".tps", specID = "imageID") ### reading in a .tps file 
