setwd("~/work")
library(tidyverse) 
diabetes_data <- read_csv("./source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv")

#look at data 
head(diabetes_data)

# PCA 
pca_results <- prcomp(diabetes_data %>% select(-diabetes_data$Diabetes_binary) %>% as.matrix())
summary(pca_results)

#projection + logistic regression
diab_projection <- cbind(diabetes_data, pca_results$x %>% as_tibble() %>% select(PC1:PC3))


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

PC1_thresholded <- which(PC1_comps > 0.01 | PC1_comps < -0.4)
PC2_thresholded <- which(PC2_comps > 0.01 | PC2_comps < -0.4)
PC3_thresholded <- which(PC3_comps > 0.01 | PC3_comps < -0.4)

PC1_cats <- names(diabetes_data[PC1_thresholded+1])
PC2_cats <- names(diabetes_data[PC2_thresholded+1])
PC3_cats <- names(diabetes_data[PC3_thresholded+1])
PC1_cats
PC2_cats
PC3_cats


#PC1 - plot and save
ggplot(data=tibble(x=PC1_cats,y=PC1_comps[PC1_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete() + ggtitle("Main PC1 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC1_comp_analysis.png", plot = last_plot(), dpi=300)

#PC2 - plot and save
ggplot(data=tibble(x=PC2_cats,y=PC2_comps[PC2_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete()+ ggtitle("Main PC2 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC2_comp_analysis.png", plot = last_plot(), dpi=300)

#PC3 - plot and save
ggplot(data=tibble(x=PC3_cats,y=PC3_comps[PC3_thresholded]), aes(x,y)) + geom_point()+scale_x_discrete()+ ggtitle("Main PC3 Components") + ylab("Relative Influence") + xlab("Attribute")
ggsave(filename="figures/PC3_comp_analysis.png", plot = last_plot(), dpi=300)



# 75% train split and run model 
train <- runif(nrow(diabetes_data)) < 0.75
diab_train_data <- diab_projection %>% filter(train)
glm_model <- glm(diab_train_data$Diabetes_binary~PC1+PC2+PC3, family=binomial, data=diab_train_data)
summary(glm_model)

# GLM test 
diab_test_data <- diab_projection %>% filter(!train)
diab_test_data$diabetes_binary_p <- predict(glm_model, newdata=diab_test_data, type="response")
write.csv(diab_test_data,"derived_data/diabetes_binary_PCA-GLM_prediction.csv", row.names = FALSE)

# ROC Curve 
library(pROC)
roc_glm <- roc(diab_test_data$Diabetes_binary, diab_test_data$diabetes_binary_p)
roc_glm$auc
png(file="./figures/GLM-PCA_ROC.png")
plot(roc_glm)
dev.off()

# Confusion

# useful function ################################################
rates <- function(actual, predicted) { 
  positive_ii <- which(!!actual);
  negative_ii <- which(!actual);
  
  true_positive <- sum(predicted[positive_ii])/length(positive_ii);
  false_positive <- sum(predicted[negative_ii])/length(negative_ii);
  
  true_negative <- sum(!predicted[negative_ii])/length(negative_ii);
  false_negative <- sum(!predicted[positive_ii])/length(positive_ii);
  
  tibble(true_positive=true_positive,
         false_positive=false_positive,
         false_negative=false_negative,
         true_negative=true_negative,
         accuracy=sum(actual==predicted)/length(actual))
}
################################################

# confusion data 
scores <- do.call(rbind, Map(function(threshold) { 
  predicted <- diab_test_data$diabetes_binary_p > threshold;
  actual <- diab_test_data$Diabetes_binary;
  rt <- rates(actual, predicted);
  tpc <- sum((predicted==actual)[actual==1]);
  fpc <- sum((predicted==1)[actual==0]);
  fnc <- sum((predicted==0)[actual==1]);
  rt$precision <- tpc/(tpc+fpc);
  rt$recall <- tpc/(tpc+fnc)
  rt$f1 <- 2 * (rt$precision*rt$recall) / (rt$precision+rt$recall);
  rt$threshold <- threshold;
  rt; 
  
  
}, seq(0,1,length.out=100)));

scores <- pivot_longer(scores, cols=true_positive:f1)
print(scores)

ggplot(scores, aes(threshold, value)) + geom_line(aes(color=factor(name)))
ggsave("./figures/GLM-PCA_confusion.png", width=1800, height=1200, units = "px")


