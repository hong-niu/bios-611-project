.PHONY: clean
.PHONY: visualization


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


#train a GBM classifier to predict binary diabetes status 
derived_data/diabetes_binary_GBM_prediction.csv: \
	.created-dirs \
	scripts/visualize_features.R \
	source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv 
		Rscript scripts/visualize_features.R

visualization: derived_data/diabetes_binary_GBM_prediction.csv