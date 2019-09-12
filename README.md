## Morph2019 Workshop (Date: 13th September 2019)
### Instructor: Dr. Christian Steven Hoggard
### Location: Tohuku University (Sendai, Japan)


This repository holds all materials used throughout the Morph2019 workshop on *Geometric Morphometrics and Archaeology*. This includes the presentation used throughout the workshop and all material associated with the workshop.  


#### About the workshop

This workshop is designed to provide an introduction into the application and potential of geometric morphometric (GMM) methodologists for archaeologists, researchers and enthusiasts. The workshop first introduces participants to the mathematical underpinnings of statistical shape and form, before detailing the fundamentals of geometric morphometrics, emphasising its statistical power and converage in comparison to traditional morphometrics.

Through two practicals, one landmark-based and one outline-based, this workshop details the complete workflow from data acquisition to subsequent analysis and interpretation. While a high degree of technical knowledge is necessary, an incredible amount of analytical possibility can be harnessed through the adoption of two- and three-dimensional GMM methodologies.

Software: All data input, manipulation and analyses will be **performed in the R Environment through geomorph (BETA version) and Momocs**. **_Please ensure R/RStudio and all files are downloaded onto your computer/laptop before or at the beginning of the workshop_**. Run the **Setup.R** file in R/RStudio to ensure all packages are downloaded.  Other digitisation methods including tpsDig2 (https://life.bio.sunysb.edu/morph/soft-dataacq.html) and GUImorph (https://github.com/GUImorph/GUImorph) will also be showcased.

Alternatively, all workshop activities can also be performed in a RStudio.cloud web-browser (https://rstudio.cloud/project/513978). For first-time R users, this format is suggested.


#### Practical One (Landmark Analysis: Generalised Procrustes Analysis)

Using a sample cranial dataset this practical will explore some of the features used through geomorph, including digitisation, the GPA procedure, and the analysis of Procrustes coordinates for their location and sex.


#### Practical Two (Outline Analysis: Elliptic Fourier Analysis)

This is a modified R script from **The Application of Elliptic Fourier Analysis in Understanding Biface Shape and Symmetry Through the British Acheulean** in the *Journal of Palaeolithic Archaeology* (https://doi.org/10.1007/s41982-019-00024-6). Three files are required for this practical: 1) the script (**practical_two.r**), 2) the outline data created in the TpsSuite (**practical_two.tps**), and 3) the metadata in .csv format (**practical_two.csv**).

For any queries please contact C.S.Hoggard@soton.ac.uk 


#### Suggested Reading

Adams, D.C. and Otárola-Castillo, E. (2013). Geomorph: an r package for the collection and analysis of geometric morphometric shape data. *Methods of Ecology and Evolution* 4, 393-399. 

Adams, D.C., Rohlf, F.J. and Slice, D.E. (2004). Geometric morphometrics: ten years of progress following the ‘revolution’. *Italian Journal of Zoology*, 71, 5–16. 

Bonhomme, V., Picq, S., Gaucherel, C., and Claude, J. (2014). Momocs: Outline analysis using R. *Journal of
Statistical Software*, 56, 1–24.

Bookstein, F.L. (1991). *Morphometric Tools for Landmark Data: Geometry and Biology*. New York: Cambridge University Press. 

Kovarovic, K., Aiello, L. C., Cardini, A. and Lockwood, C. A. (2011). Discriminant function analyses in
archaeology: Are classification rates too good to be true? *Journal of Archaeological Science*, 38(11),
3006–3018.

MacLeod, N. (1999). Generalizing and extending the Eigenshape method of shape space visualization and
analysis. *Paleobiology*, 25 (1), 107–138.

Slice, D.E. (2007). Geometric Morphometrics, *Annual Review of Anthropology* 36(1), 261–281.  

Yoshioka, Y. (2004). Analysis of petal shape variation of Primula sieboldii by elliptic fourier descriptors and
principal component analysis. *Annals of Botany*, 94(5), 657–664.

Zelditch, M.L., Swiderski D.L., Sheets H.D. and Fink, W.L. (2004). *Geometric morphometrics for biologists: a primer*. San Diego (CA): Elsevier Academic Press.


