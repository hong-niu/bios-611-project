setwd("~/work")
library(tidyverse) 
diabetes_data <- read_csv("./source_data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv")
#diabetes_data <- read_csv("diabetes_012_health_indicators_BRFSS2015.csv")

set.seed(100)

#look at data 
head(diabetes_data)
#hist(diabetes_data$BMI)



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
#gbm
library(gbm)
f <- formula(sprintf("Diabetes_binary ~ %s", 
                     diabetes_data %>% select(HighBP:Income) %>% 
                       names() %>% paste(collapse=" + ")))
train <- runif(nrow(diabetes_data)) < 0.75
#test train split 
diabetes_data_train <- diabetes_data %>% dplyr::filter(train) #%>% select(-train)
diabetes_data_test <- diabetes_data %>% dplyr::filter(!train) #%>% select(-train)

#build model 
#gbm_model <- gbm(f, data=diabetes_data %>% dplyr::filter(train))
gbm_model <- gbm(f, data=diabetes_data_train)
summary_gbm <- summary(gbm_model)
png(file="./figures/GBM_Rel_Influence.png")
barplot(summary_gbm$rel.inf[1:6], horiz=TRUE, names.arg=c(summary_gbm$var[1:6]), col="blue", xlab="Relative Influence", main="GBM Summary")
dev.off()
summary_gbm

#compute ROC 
library(pROC)
diabetes_data_test$diab_p <- predict(gbm_model, newdata=diabetes_data_test, type="response")
roc_class <- roc(diabetes_data_test$Diabetes_binary, diabetes_data_test$diab_p)
roc_class$auc
png(file="./figures/GBM_ROC.png")
plot(roc_class)
dev.off()

test <- diabetes_data %>% filter(!train)
test$Diabetes_binary_p <- predict(gbm_model, newdata=test)
write.csv(test,"derived_data/diabetes_binary_GBM_prediction.csv", row.names = FALSE)

# check ROC + confusion data 
scores <- do.call(rbind, Map(function(threshold) { 
  predicted <- diabetes_data_test$diab_p > threshold;
  actual <- diabetes_data_test$Diabetes_binary;
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
ggsave("./figures/GBM_confusion.png", width=1800, height=1200, units = "px")




