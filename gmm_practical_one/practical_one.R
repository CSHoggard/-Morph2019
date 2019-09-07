### Morph2019 (Practical One): Cranial Dataset
### Author: Dr. Christian Steven Hoggard (University of Southampton)

### This is a modified script from the Morph2017 workshop and was originally created by Dr. Sarah Y. Stark

### Please ensure all necessary packages are installed into your RStudio software, either manually or through the Setup.R file (see GitHub)
### Also ensure that all files from GitHub are in a specific folder and set the working directory to that folder.

### Stage One: Set working directory and load packages --------------------------

library(geomorph) ### geomorph v.3.1.3 (BETA) (Package for landmark analysis) 
library(tidyverse) ### tidyverse 1.2.1 (Suite of packages for data manipulation and visualisation)

### Stage Two: Building a template and digitising a sample ----------------------

SK1 <- read.ply("skull_1.ply", ShowSpecimen = FALSE, addNormals = FALSE) ### import .PLY file
plot3d(SK1) ### plots the 3d mesh model
buildtemplate(SK1, 23, 200) ### build a template using the first .PLY file (23 landmarks, 200 surface semilandmarks)

### The specimen you choose for your template is your most complete and definable specimen. 
### The order of the landmarks you make on this template will need to be replicated onto the rest of your sample. 
### The semilandmarks that are then used in the template will be projected onto the rest of the sample.

SK2 <- read.ply("skull_2.ply",ShowSpecimen = TRUE, addNormals = FALSE) ### import .PLY file
digitsurface(SK2, 23) ### digitising the surface (23 landmarks)

SK3 <- read.ply("skull_3.ply", ShowSpecimen = TRUE, addNormals = FALSE) ### import .PLY file
digitsurface(SK3, 23) ### digitising the surface (23 landmarks)

SK4 <- read.ply("skull_4.ply", ShowSpecimen = TRUE, addNormals = FALSE) ### import .PLY file
digitsurface(SK4, 23) ### digitising the surface (23 landmarks)

SK5 <- read.ply("skull_5.ply", ShowSpecimen = TRUE, addNormals = FALSE) ### import .PLY file
digitsurface(SK5, 23) ### digitising the surface (23 landmarks)

SK6 <- read.ply("skull_6.ply", ShowSpecimen = TRUE, addNormals = FALSE) ### import .PLY file
digitsurface(SK6, 23) ### digitising the surface (23 landmarks)

skull  <- readmulti.nts(c("SK1.nts","SK2.nts","SK3.nts","SK4.nts","SK5.nts","SK6.nts")) ### importing finished file
groups <- read.csv("skulls.csv", header=T, row.names=1) ### import the metadata
is.factor(groups$Sex) ### checks factor
is.factor(groups$Location) ### checks factor
is.character(groups$Code) ### checks character
groups$code <- as.character(groups$Code)
surfslide<-read.csv("surfslide.csv", header=TRUE) ### sliding surface semilandmarks
surfslide<-as.matrix(surfslide) ### convert to matrix

### Stage Three: Generalised Procrustes Analysis ----------------------------------

skullgpa <- gpagen(skull, Proj = TRUE, ProcD = TRUE, curves = NULL, surfaces = surfslide) ### generalised Procrustes Analysis
skullgpa ### calls the object
ref <- mshape(skullgpa$coords) ### calculates the mean shape of all skulls
ref ### calls the object
ref <- as.matrix(ref)	### converts the object to a matrix

### Stage Four: Statistical Framework ---------------------------------------------

pcasex <- plotTangentSpace(skullgpa$coords, axis1 = 1, axis2 = 2, warpgrids = TRUE, groups = groups$Sex, verbose = TRUE, label=groups$Code) ### principal component analysis
summary(pcasex) ### pca summary
pcasex$pc.shapes ### output (shape coordinates of the extreme ends of all PC axes)
pcasex$pc.shapes$PC1max ### e.g. PC1 max
pcasex$rotation ### rotation values

lmspecimensex <- procD.lm(two.d.array(skullgpa$coords) ~ groups$Sex, iter=99) ### Procrustes ANOVA (shape vs. sex)
lmspecimensex$aov.table ### anova table (summary)
lmspecimensex$call ### calls the code used
lmspecimensex$QR ### QR decompositions
lmspecimensex$fitted ### the fitted values
lmspecimensex$residuals ### the residuals (observed responses)
lmspecimensex$data ### the data frame for the model
?procD.lm ### calls the function (for further information)

pcalocation <- plotTangentSpace(skullgpa$coords, axis1 = 1, axis2 = 2, warpgrids = TRUE, groups = groups$Location, verbose = TRUE, label=groups$Code) ### principal component analysis
summary(pcalocation) ### pca summary
pcalocation$pc.shapes ### output (shape coordinates of the extreme ends of all PC axes)
pcalocation$pc.shapes$PC1max ### e.g. PC1 max
pcalocation$rotation ### rotation values

lmspecimenlocation <- procD.lm(two.d.array(skullgpa$coords) ~ groups$Location, iter=99) ### Procrustes ANOVA (shape vs. location)
lmspecimenlocation$aov.table ### anova table (summary)
lmspecimenlocation$call ### calls the code used
lmspecimenlocation$QR ### QR decompositions
lmspecimenlocation$fitted ### the fitted values
lmspecimenlocation$residuals ### the residuals (observed responses)
lmspecimenlocation$data ### the data frame for the model
?procD.lm ### calls the function (for further information)

### Stage Five: Visualisations

plotRefToTarget(ref, pcasex$pc.shapes$PC1max, method= "vector") ### shape change from mean shape (ref) to max PC1 (as vector)

