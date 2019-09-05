### Morph2019 (Practical Two): The application of elliptic Fourier analysis in understanding biface shape and symmetry through the British Acheulean
### Author: Dr. Christian Steven Hoggard (University of Southampton)

### This is a copy of the Hoggard et al. (2019) script modified for the Morph2019 workshop

### Please ensure all necessary packages are installed into your RStudio software, either manually or through the Setup.R file (see GitHub)
### Also ensure that all files from GitHub are in a specific folder and set the working directory to that folder. 

### Stage One: Set working directory and load packages --------------------------

library(Momocs) #Momocs 1.2.9. (Package for outline analysis)
library(tidyverse) #tidyverse 1.2.1 (Suite of packages for data manipulation and visualisation)
library(cowplot) #cowplot 1.0.0 (Package for the presentation of graphics)

### Stage Two: Import and screen all data ---------------------------------------

database <- read.csv("practical_two.csv", header = TRUE, row.names = "ID") ### .csv table containing metadata
tpsfile <- import_tps("practical_two.tps", curves = TRUE) ### .tps file containing the outline data for all bifaces
View(database) ### view database (observational screening)
print(tpsfile) ### print tpsfile (observational screening)

database$MIS = factor(database$MIS, c("MIS 13", "MIS 11", "MIS 9", "MIS 7", "MIS 4/3")) ### reorder factor according to Marine Isotope Stage (MIS)
database$Context = factor(database$Context, c("Warren Hill", "Boxgrove", "Bowman's Lodge", "Elveden", "Swanscombe", "Broom", "Furze Platt", "Cuxton", "Pontnewydd", "Lynford")) ### reorder factor according to context
summary(database$MIS) ### count data for the different MISs
summary(database$Context) ### count data for the different archaeological contexts


### Stage Three: Convert tps file to 'Out' class (see Momocs guide) -------------

outlinefile <- Out(tpsfile$coo, fac = database) ### creation of an outline file with the database supplying metadata
outlinefile ### call the outline file


### Stage Four: Standardise specimens prior EFA ---------------------------------

### Note: While this is unnecessary it provides greater control

outlinefile <- coo_close(outlinefile) ### ensure all outlines are closed
stack(outlinefile, title="") ### view outlines
outlinefile <- coo_center(outlinefile) ### centre outlines to a common centroid (0,0)
stack(outlinefile, title="") ### view outlines
outlinefile <- coo_scale(outlinefile) ### scale outlines to a common centroid size
stack(outlinefile, title="") ### stack for visual examination (see ?pile for further information)
panel(outlinefile, fac = "MIS") ### visual examination through MIS factor (chronological order)


### Stage Five: Create the EFA class  -------------------------------------------

### Now we have the outlines we can perform the EFA process. We first need to know how many harmonics are necessary
### for the level of detail we require. Here we are using 99% harmonic power (a good detail of handaxe shape).

calibrate_harmonicpower_efourier(outlinefile) ### confirm how many harmonics equate to 99% harmonic power (may take some time!)
calibrate_reconstructions_efourier(outlinefile, range=1:20) ### confirm through reconstruction (of a random example)
calibrate_deviations_efourier(outlinefile) ### confirm through analysis of centroid deviations
efourierfile <- efourier(outlinefile, nb.h = 13, smooth.it = 0, norm = TRUE, start = FALSE) ### creation of EFA class (13 harmonics); normalisation is suitable in this instance given previous procedures.
efourierfile ### calls the file detailing the created OutCoe object (data and factors)


### Stage Six: Extraction of symmetry values -----------------------------------

### Now we have the shape data (through the EFA creation) we can extract the symmetry values through the created coefficients

symmetry_1 <- symmetry(efourierfile) ### extraction of symmetry values (the ratio of AD and BC coefficients)
symmetry_1 ### calls the table of coefficients
symmetry_1 <- symmetry_1[match(rownames(database),rownames(symmetry_1)),] ### order to match database
database<-cbind(database,symmetry_1) ### binds columns to the main database
rm(symmetry_1) ### removes this file (no longer necessary)
View(database) ### views the main database


### Stage Seven: Examination of shape ------------------------------------------

### Now we can examine the relationship between shape and period and context, first through a PCA:

pca1 <- PCA(efourierfile, scale. = FALSE, center = TRUE, fac = Database) ### creation of PCA class
scores <- data.frame(pca1$x) ### creation of scores into a dataframe
scores <- scores[match(rownames(database),rownames(scores)),] ### match to row ID on database
database <- cbind(database, scores) ### column bind to database
rm(scores) ### removes scores (no longer necessary)
View(database) ### views the main database (again!)

scree(pca1) ### produces a tibble of the proportion and cumulative percentage for the PC inertia
PCcontrib(pca1) ### visualises the main shape changes among all handaxe (PCs)
pdf("Figure_1.pdf", width = 7, height = 7) ### produces a pdf of these contributions
plot(pca1, xax = 1, yax = 2, points = FALSE, center.origin = FALSE, zoom = 1, grid = TRUE, pos.shp = "xy", size.shp = 0.4, ellipses = FALSE, chull = FALSE, chull.filled = FALSE, eigen = FALSE, rug = FALSE, title = "Principal Component Analysis (PC1 vs. PC2): XY Warps", labelsgroups=FALSE) ### produces a principal component plot (first two axes)
plot(pca1, pca1$MIS, xax = 1, yax = 2, points = FALSE, center.origin = FALSE, zoom = 1, grid = TRUE, morphospace = FALSE, ellipses = TRUE, conf.ellipses = 0.99, chull = FALSE, chull.filled = FALSE, eigen = FALSE, rug = FALSE, title = "Principal Component Analysis (PC1 vs. PC2): Confidence Ellipses (99%)", labelsgroups=TRUE, cex.labelsgroups=1) ### produces a principal component plot (first two axes)
dev.off() ### halts the graphical production above

ggplot(database, aes(MIS, PC1)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.4) +  coord_flip() + labs(x = "Marine Isotope Stage (MIS)", y = "Principal Component 1 (67.29%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC1 scores categorised by MIS
ggplot(database, aes(MIS, PC2)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.4) +  coord_flip() + labs(x = "Marine Isotope Stage (MIS)", y = "Principal Component 2 (11.46%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC1 scores categorised by context
ggplot(database, aes(Context, PC1)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.5) +  coord_flip() + labs(x = "Context", y = "Principal Component 1 (67.29%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC2 scores categorised by MIS
ggplot(database, aes(Context, PC2)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.5) +  coord_flip() + labs(x = "Context", y = "Principal Component 2 (11.46%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC2 scores categorised by context

figure2a <- ggplot(database, aes(MIS, PC1)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.4) +  coord_flip() + labs(x = "Marine Isotope Stage (MIS)", y = "Principal Component 1 (67.29%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC1 scores categorised by MIS
figure2b <- ggplot(database, aes(MIS, PC2)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.4) +  coord_flip() + labs(x = "Marine Isotope Stage (MIS)", y = "Principal Component 2 (11.46%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC1 scores categorised by context
figure2c <- ggplot(database, aes(Context, PC1)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.5) +  coord_flip() + labs(x = "Context", y = "Principal Component 1 (67.29%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC2 scores categorised by MIS
figure2d <- ggplot(database, aes(Context, PC2)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475", width = 0.5) +  coord_flip() + labs(x = "Context", y = "Principal Component 2 (11.46%)") + theme(text = element_text(size=9), axis.text.x = element_text(size=9), axis.text.y = element_text(size=9)) ### PC2 scores categorised by context
figure2 <- plot_grid(figure2a, figure2c, figure2b, figure2d, labels= "AUTO", ncol = 2, align = 'v') #synthesis of the four figures
plot(figure2) ### plots the figure
ggsave("Figure_2.tiff", plot = last_plot(), dpi = 400, units = "mm", height = 150, width = 250) ##saves the file

### And now through statistical testing...

MANOVA(pca1, "MIS", test = "Hotelling", retain = 0.99) ### MANOVA vs. MIS
mismanovapw <- MANOVA_PW(pca1, "MIS", retain = 0.99) ### pairwise values 
mismanovapw$stars.tab ### pairwise values represented by stars
MANOVA(pca1, "Context", test = "Hotelling", retain = 0.99) ### MANOVA against context
contextmanovapw <- MANOVA_PW(pca1, "Context", retain = 0.99) ### pairwise values
contextmanovapw$stars.tab ### pairwise values represented by stars

### And now through a discriminant analysis...

lda1 <- LDA(pca1, fac = "MIS") ### creation of a discriminant analysis by MIS
lda1 <- ### details of the discriminant analysis
plot(lda1, xax = 1, yax = 2, points = TRUE, pch = 20, cex = 0.6, center.origin = FALSE, zoom = 1.8, grid = TRUE, pos.shp = "circle", size.shp = 0.6, ellipses = TRUE, ellipsesax = FALSE, conf.ellipses = 2/3, chull = FALSE, chull.filled = FALSE, eigen = FALSE, rug = FALSE) ### plots an LDA


# Stage Eight: An Examination of symmetry ---------------------------------------

ggplot(database, aes(sym)) + geom_histogram(bins = 24, binwidth = 0.01, colour = "#E69F00", fill = "#ffd475") + xlim(0.75, 1) + ylim(0, 100) + geom_density(alpha=0.2, colour = "darkgrey") + labs(x = "symmetry (AD harmonic coefficients/amplitude)", y = "count (n=)") + theme_light() + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### creation of a histogram focusing on symmetry values
ggplot(database, aes(MIS, sym)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475") + coord_flip() + ylim(0.8, 1) + labs(y = "symmetry (AD harmonic coefficients/amplitude)") + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### box and whisker of symmetry values categorised by period
ggplot(database, aes(Context, sym)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475") + coord_flip() + ylim(0.8, 1) + labs(y = "symmetry (AD harmonic coefficients/amplitude)") + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### box and whsisker of symmetry values categorised by context

figure3a <- ggplot(database, aes(sym)) + geom_histogram(bins = 24, binwidth = 0.01, colour = "#E69F00", fill = "#ffd475") + xlim(0.8, 1) + ylim(0, 100) + geom_density(alpha=0.2, colour = "darkgrey") + labs(x = "symmetry (AD harmonic coefficients/amplitude)", y = "count (n=)") + theme_light() + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### creation of a histogram focusing on symmetry values
figure3b <- ggplot(database, aes(MIS, sym)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475") + coord_flip() + ylim(0.8, 1) + labs(y = "symmetry (AD harmonic coefficients/amplitude)") + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### box and whisker of symmetry values categorised by period
figure3c <- ggplot(database, aes(Context, sym)) + geom_boxplot(colour = "#E69F00", fill = "#ffd475") + coord_flip() + ylim(0.8, 1) + labs(y = "symmetry (AD harmonic coefficients/amplitude)") + theme(text = element_text(size=10), axis.text.x = element_text(size=11), axis.text.y = element_text(size=11)) ### box and whsisker of symmetry values categorised by context
figure3 <- plot_grid(figure3a, figure3b, figure3c, labels = c('A','B','C'), ncol = 1)
plot(figure3) ### plots the figure
ggsave("Figure_3.tiff", plot = last_plot(), dpi = 400, units = "mm", height = 250, width = 150) ### saves the figure

database %>%
  group_by(MIS) %>%
  summarise(
    count = n(),
    mean = mean(sym, na.rm = TRUE),
    sd = sd(sym, na.rm = TRUE),
    min = min(sym, na.rm = TRUE),
    max = max(sym, na.rm = TRUE),
    cv = sd(sym, na.rm = TRUE)/mean(sym, na.rm = TRUE)*100) ### symmetry summary statistics

kruskal.test(sym ~ MIS, data = database) ### Kruskal Wallis test
pairwise.wilcox.test(database$sym, database$MIS, p.adj = "bonf") ### Pairwise Wilcoxon rank sum test for MIS
kruskal.test(sym ~ Context, data = database)
pairwise.wilcox.test(database$sym, database$Context, p.adj = "bonf") ### Pairwise Wilcoxon rank sum test

### Symmetry vs. shape

ggplot(database, aes(sym, PC1)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 1 (67.29%)")

figure5a <- ggplot(database, aes(sym, PC1)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 1 (67.29%)")
figure5b <- ggplot(database, aes(sym, PC2)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 2 (11.46%)")
figure5c <- ggplot(database, aes(sym, PC3)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 3 (7.74%)")
figure5d <- ggplot(database, aes(sym, PC4)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 4 (2.82%)")
figure5e <- ggplot(database, aes(sym, PC5)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 5 (2.05%)")
figure5a <- ggplot(database, aes(sym, PC1)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 1 (67.29%)")
figure5b <- ggplot(database, aes(sym, PC2)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 2 (11.46%)")
figure5c <- ggplot(database, aes(sym, PC3)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 3 (7.74%)")
figure5d <- ggplot(database, aes(sym, PC4)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 4 (2.82%)")
figure5e <- ggplot(database, aes(sym, PC5)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Symmetry") + ylab("Principal Component 5 (2.05%)")
figure5 <- plot_grid(figure5a, figure5b, figure5c, figure5d, figure5e, labels = c('A','B','C', 'D', 'E'), nrow=2, ncol=3)
plot(figure5) ### plots the figure
ggsave("Figure_5.tiff", plot = last_plot(), dpi = 400, unit = "mm", width = 200, height = 130) ### saves the figure

cor(database$PC1, database$sym) #correlation (PC1 vs symmetry)
cor.test(database$PC1, database$sym) #correlation test

cor(database$PC2, database$sym) #correlation (PC2 vs symmetry)
cor.test(database$PC2, database$sym) #correlation test

cor(database$PC3, database$sym) #correlation (PC3 vs symmetry)
cor.test(database$PC3, database$sym) #correlation test

cor(database$PC4, database$sym) #correlation (PC4 vs symmetry)
cor.test(database$PC4, database$sym) #correlation test

cor(database$PC5, database$sym) #correlation (PC5 vs symmetry)
cor.test(database$PC5, database$sym) #correlation test


### Stage Nine: Size as a factor-------------------------------------------

cor(database$Length, database$sym) ### correlation (length vs. symmetry)
cor.test(database$Length, database$sym) ### correlation test
cor(database$Length, database$PC1) ### correlation (length vs. symmetry)
cor.test(database$Length, database$PC1) ### correlation test
cor(database$Length, database$PC2) ### correlation (length vs. symmetry)
cor.test(database$Length, database$PC2) ### correlation test
cor(database$Length, database$PC3) ### correlation (length vs. symmetry)
cor.test(database$Length, database$PC3) ### correlation test

pairwise.wilcox.test(database$Length, database$MIS, p.adj = "bonf") ### pairwise Wilcoxon rank sum test for MIS

ggplot(database, aes(Length, sym)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Symmetry")
ggplot(database, aes(Length, PC1)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 1 (67.29%)")
ggplot(database, aes(Length, PC2)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 2 (11.46%)")
ggplot(database, aes(Length, PC3)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 3 (7.74%)")

figure6a <- ggplot(database, aes(Length, sym)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Symmetry")
figure6b <- ggplot(database, aes(Length, PC1)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 1 (67.29%)")
figure6c <- ggplot(database, aes(Length, PC2)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 2 (11.46%)")
figure6d <- ggplot(database, aes(Length, PC3)) + geom_point(size = 1, pch = 16, alpha = 0.4, colour = "#E69F00", fill = "#ffd475") + geom_smooth(method = "lm", se = FALSE, colour = "grey") + theme(text = element_text(size=8), axis.text = element_text(size = 8)) + xlab("Length (mm)") + ylab("Principal Component 3 (7.74%)")
figure6 <- plot_grid(figure6a, figure6b, figure6c, figure6d, labels = c('A','B','C','D'), nrow=2, ncol=2)

plot(figure6) ### plots figure 6
ggsave("Figure_6.tiff", plot = last_plot(), dpi = 400, unit = "mm", width = 150, height = 130)
