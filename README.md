# Data Mining Insect DNA Barcode Classification

## Description

This project was done as an end-of-term assignment for 
CSCI 48100 offered at IUPUI in the Spring of 2021.
All of the project guidlines can be found in the 
[CSCI_481_Project_Guidelines](CSCI_481_Project_Guidelines.pdf) PDF Document.
The goal of this project was to analize a set of test data
and make prediction on what insect species/genus the sequence belonged to.

The predictions were to be made off of the following variables:

- *gtrain*: genus level labels
- *ytrain*: species level labels
- *nuc_train*: nucleotide sequences of training data
- *emb_train*: embeddings of training data
- *nuc_test*: nucleotide sequences of test data
- *emb_test*: embeddings of test data

More detailed descriptions of these variables can be found in the
[CSCI_481_Project_Guidelines](CSCI_481_Project_Guidelines.pdf) 
PDF Document mentioned above.
   
## Software

[Mathworks MATLAB](https://www.mathworks.com/products/matlab.html) 
was used to write and run all of the scripts. 

All writeups were done on [Overleaf](www.overleaf.com) browser LaTeX editor

An unarchiving software will be needed to unpack the models. 
[WinRAR](https://www.win-rar.com/start.html?&L=0) was used in the case of creating the archive.

## Installation

1. Download and install Mathworks MATLAB  
programming and numeric computing platform R2021a or later. 
*(Please note that this is a paid software, but a free trial is available)*
1. 
1. to import the data, click the *Import Data* option located in 
**Home>Variable**
1. select all desired data. please note that due to their size,
the actual models could not be included on github in their uncompressed form.
1. To unpack and load in the actual models, 
download the models archive and unpack it with an archiving software.
1. To run any of the scripts, select it in the main work area and select 
*Run* located in the center of the top navigation menu.


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
- The data set is obtained from the Barcode of Life Data System (BOLD)
- Special Thanks to Murat Dundar for being a valuable resource in the Data Mining and Machine Learning field.

## Project Status

This project is **Completed** and will see no further work