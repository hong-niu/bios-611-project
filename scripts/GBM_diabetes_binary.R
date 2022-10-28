#setwd("~/work")
library(tidyverse) 
diabetes_data <- read_csv("./source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv")

#look at data 
head(diabetes_data)
hist(diabetes_data$BMI)

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

