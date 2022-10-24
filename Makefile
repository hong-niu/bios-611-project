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
	rm -f WriteUp-Midterm.pdf
	rm -f WriteUp-Midterm.log
	rm -f WriteUp-Midterm.synctex.gz
	rm -f WriteUp-Midterm.aux
	
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
derived_data/diabetes_binary_PCA-GLM_prediction.csv: \
	.created-dirs \
	scripts/PCA_diabetes_binary.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/PCA_diabetes_binary.R


# Train a GBM classifier to predict binary diabetes status 
derived_data/diabetes_binary_GBM_prediction.csv: \
	.created-dirs \
	scripts/GBM_diabetes_binary.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/GBM_diabetes_binary.R


# Perform the GBM
GBM: derived_data/diabetes_binary_GBM_prediction.csv

# Perform the PCA steps 	
PCA: derived_data/diabetes_binary_PCA-GLM_prediction.csv

# Run all steps in the Makefile 
all: derived_data/diabetes_binary_GBM_prediction.csv \
		derived_data/diabetes_binary_PCA-GLM_prediction.csv
		
# Generate final report 
WriteUp-Midterm.pdf: figures/PC1_comp_analysis.png WriteUp-Midterm.tex
	pdflatex WriteUp-Midterm.tex
