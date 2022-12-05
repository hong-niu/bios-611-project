.PHONY: clean
.PHONY: GBM
.PHONY: PCA
.PHONY: all

clean: 
	rm -rf models 
	rm -rf figures
	rm -rf derived_data
	rm -rf .created-dirs #add this for any directories that are created through src code 
	rm -f Rplots.pdf
	rm -f Writeup-Midterm.pdf
	rm -f Writeup-Midterm.log
	rm -f Writeup-Midterm.synctex.gz
	rm -f Writeup-Midterm.aux
	rm -f Writeup-rmd.log
	rm -f Writeup-rmd.pdf
	rm -f Writeup-rmd.tex
	rm -f Writeup-rmd.html
	
	rm -f BIOS611_Report_Final.aux
	rm -f BIOS611_Report_Final.log
	rm -f BIOS611_Report_Final.out
	rm -f BIOS611_Report_Final.tex
	rm -f BIOS611_Report_Final.pdf
	rm -f BIOS611_Report_Final_html.html
	
	
	rm -f scripts/.Rhistory
	rm -f .Rhistory
	rm -f scripts/texput.log

	
.created-dirs: 
	mkdir -p models
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs
	
# Perform PCA and do logistic regression
figures/PC1_comp_analysis.png \
figures/PC1_comp_full-spectrum.png \
figures/PC2_comp_analysis.png \
figures/PC2_comp_full-spectrum.png \
figures/PC3_comp_analysis.png \
figures/PC3_comp_full-spectrum.png \
figures/GLM-PCA_ROC.png \
figures/GLM-PCA_confusion.png \
derived_data/diabetes_binary_PCA-GLM_prediction.csv: \
	.created-dirs \
	scripts/PCA_diabetes_binary.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/PCA_diabetes_binary.R


# Train a GBM classifier to predict binary diabetes status 
figures/GBM_confusion.png \
figures/GBM_ROC.png \
figures/GBM_Rel_Influence.png \
derived_data/diabetes_binary_GBM_prediction.csv: \
	.created-dirs \
	scripts/GBM_diabetes_binary.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/GBM_diabetes_binary.R


# Perform the GBM for testing purposes 
GBM: derived_data/diabetes_binary_GBM_prediction.csv

# Perform the PCA steps for testing purposes 
PCA: derived_data/diabetes_binary_PCA-GLM_prediction.csv

# Run all steps in the Makefile for testing purposes 
all: derived_data/diabetes_binary_GBM_prediction.csv \
		derived_data/diabetes_binary_PCA-GLM_prediction.csv
		
# Generate final report 
#Writeup-Midterm.pdf: figures/PC1_comp_analysis.png WriteUp-Midterm.tex
	#pdflatex Writeup-Midterm.tex

BIOS611_Report_Final_html.html: figures/PC1_comp_analysis.png figures/GBM_ROC.png BIOS611_Report_Final_html.Rmd 
	Rscript --no-restore --no-save -e  "rmarkdown::render('BIOS611_Report_Final_html.Rmd', output_format='html_document')"



### Old attempts at building report - leave in for now 


#Writeup-Rmd.pdf: figures/PC1_comp_analysis.png WriteUp-rmd.Rmd
#	Rscript --no-restore --no-save -e  "rmarkdown::render('Writeup-rmd.Rmd', output_format='pdf_document')"

#Writeup-Rmd.html: figures/PC1_comp_analysis.png WriteUp-rmd.Rmd 
#	Rscript --no-restore --no-save -e "tinytex::install_tinytex(force=TRUE); rmarkdown::render('Writeup-rmd.Rmd', output_format='html_document')"

## build html 
## can convert pandoc to convert html -> pdf 
#example.html: a b c 
 #Rscript -e "rmarkdown::render('doc.Rmd',output_format='pdf_document');"

#example.html: a b c 
# Rscript -e "tinytex::install_tinytex(force=TRUE); rmarkdown::render('Writeup-rmd.Rmd', output_format='html_document')"
#example.html: a b c 
 #Rscript -e "rmarkdown::render('doc.Rmd',output_format='pdf_document');"



