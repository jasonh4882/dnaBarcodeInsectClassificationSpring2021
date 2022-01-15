# Data Mining Insect DNA Barcode Classification

## Description

*Enter Description here*
    
## Software

*Remove if not necessary*

## Installation

*Enter how to install here*

## Imagery

### Media 1 ###

![imageName1](imagePath1)

### Media 2 ###

![imageName2](imagePath2)

### Media N ###

![imageNameN](imagePathN)

## Roadmap

Since this project was completed as a part of the CSCI 48100 coursework, 
there are no plans to continue after the end of the Spring 2021 semester.

## Project Results & Analysis

### Submission Accuracy: ###

#### C1KNN1: ####

- **Unseen**: 61.08% 
- **Seen**:   97.66%

#### C2KNN2: ####

- **Unseen**: 72.84% 
- **Seen**:   93.57%

#### C3RandomForest: ####

- **Unseen**: 57.77% 
- **Seen**:   97.63%

### Analysis ###

After a short time analysis of the token generation script used for C3RandomForest, 
the script was found to be very inefficient.
Three nested for loops increased the time complexity to n^3;
 the extractBetween() MATLAB function was found to be painfully slow, 
 almost two thirds of the script time was spent on running that function.
If I were to continue on this assignment and spent some time optimizing the generation script,
 I have no doubt I could have ended with a much higher accuracy.

## Authors & Acknowledgments

- Initial guidelines and MATLAB files provided as part of IUPUI's CSCI 48100 coursework
- All workspaces and scripts (other than ones provided by course) were created by Jason Hampshire
- Special Thanks to Murat Dundar for being a valuable resource in the Data Mining and Machine Learning field.

## Project Status

This project is **Completed** and will see no further work