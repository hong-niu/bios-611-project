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

#visualize PCs
PC1_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC1)
ggplot(data=tibble(x=1:length(PC1_comps), y=PC1_comps), aes(x,y)) + geom_line()

PC2_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC2)
ggplot(data=tibble(x=1:length(PC2_comps), y=PC2_comps), aes(x,y)) + geom_line()

PC3_comps <- pca_results$rotation %>% as_tibble() %>% pull(PC3)
ggplot(data=tibble(x=1:length(PC3_comps), y=PC3_comps), aes(x,y)) + geom_line()


#gbm
library(gbm)
f <- formula(sprintf("Diabetes_binary ~ %s", 
                     diabetes_data %>% select(HighBP:Income) %>% 
                       names() %>% paste(collapse=" + ")))
train <- runif(nrow(diabetes_data)) < 0.75
gbm_model <- gbm(f, data=diabetes_data %>% dplyr::filter(train))
summary(gbm_model)[1:10,]

test <- diabetes_data %>% filter(!train)
test$Diabetes_binary_p <- predict(gbm_model, newdata=test)

write.csv(test,"derived_data/diabetes_binary_GBM_prediction.csv", row.names = FALSE)

