setwd("~/work")
library(tidyverse) 
diabetes_data <- read_csv("./source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv")

#look at data 
head(diabetes_data)
hist(diabetes_data$BMI)

# attempt a PCA 
pca_results <- prcomp(diabetes_data %>% select(-diabetes_data$Diabetes_binary) %>% as.matrix())
summary(pca_results)

#projection + logistic regression
diab_projection <- cbind(diabetes_data, pca_results$x %>% as_tibble() %>% select(PC1:PC3))

train <- runif(nrow(diabetes_data)) < 0.75
diab_train_data <- diab_projection %>% filter(train)
glm_model <- glm(diab_train_data$Diabetes_binary~PC1+PC2+PC3, family=binomial, data=diab_train_data)
summary(glm_model)

diab_test_data <- diab_projection %>% filter(!train)
diab_test_data$diabetes_binary_p <- predict(glm_model, newdata=diab_test_data, type="response")

#visualize PCs - full spectrums 

PC1_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC1)
ggplot(data=tibble(x=1:length(PC1_comps), y=PC1_comps), aes(x,y)) + geom_line() + ggtitle("PC1")
ggsave(filename="figures/PC1_comp_full-spectrum.png", plot = last_plot(), dpi=300)


PC2_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC2)
ggplot(data=tibble(x=1:length(PC2_comps), y=PC2_comps), aes(x,y)) + geom_line() + ggtitle("PC2")
ggsave(filename="figures/PC2_comp_full-spectrum.png", plot = last_plot(), dpi=300)

PC3_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC3)
ggplot(data=tibble(x=1:length(PC3_comps), y=PC3_comps), aes(x,y)) + geom_line() + ggtitle("PC3")
ggsave(filename="figures/PC3_comp_full-spectrum.png", plot = last_plot(), dpi=300)

## Make and Save Thresholded plots 

PC1_thresholded <- which(PC1_comps > 0.01)
PC2_thresholded <- which(PC2_comps > 0.01)
PC3_thresholded <- which(PC3_comps > 0.01)

PC1_cats <- names(diab_test_data[PC1_thresholded+1])
PC2_cats <- names(diab_test_data[PC2_thresholded+1])
PC3_cats <- names(diab_test_data[PC3_thresholded+1])


#PC1 - plot and save
ggplot(data=tibble(x=PC1_cats,y=PC1_comps[PC1_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete() + ggtitle("Main PC1 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC1_comp_analysis.png", plot = last_plot(), dpi=300)

#PC2 - plot and save
ggplot(data=tibble(x=PC2_cats,y=PC2_comps[PC2_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete()+ ggtitle("Main PC2 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC2_comp_analysis.png", plot = last_plot(), dpi=300)

#PC3 - plot and save
ggplot(data=tibble(x=PC3_cats,y=PC3_comps[PC3_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete()+ ggtitle("Main PC3 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC3_comp_analysis.png", plot = last_plot(), dpi=300)


write.csv(diab_test_data,"derived_data/diabetes_binary_PCA-GLM_prediction.csv", row.names = FALSE)

