.PHONY: clean
.PHONY: visualization
.PHONY: PCA
.PHONY: all

clean: 
	rm -rf models 
	rm -rf figures
	rm -rf derived_data
	rm -rf .created-dirs #add this for any directories that are created through src code 
	

.created-dirs: 
	mkdir -p models
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs
	
	
# perform PCA and do logistic regression
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


# train a GBM classifier to predict binary diabetes status 
derived_data/diabetes_binary_GBM_prediction.csv: \
	.created-dirs \
	scripts/GBM_diabetes_binary.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/GBM_diabetes_binary.R

visualization: derived_data/diabetes_binary_GBM_prediction.csv
PCA: derived_data/diabetes_binary_PCA-GLM_prediction.csv

all: derived_data/diabetes_binary_GBM_prediction.csv \
		derived_data/diabetes_binary_PCA-GLM_prediction.csv