### Script for ALE-Plots for use in mini training

# Accumulated local effects31 describe how features influence the prediction of a machine learning model on average. 
# ALE plots are a faster and unbiased alternative to partial dependence plots (PDPs).
# Motivation: If features of a machine learning model are correlated, the partial dependence plot cannot be trusted.
# ALE plots solve this problem by calculating 
# – also based on the conditional distribution of the features – differences in predictions instead of averages



### Load the data 

setwd("C:/Users/Lorenz.Haller/Documents/Repo/interpretable-ml/data/raw")

X_train = read.csv("X_train.csv", header = T, sep = ",")
X_valid = read.csv("X_valid.csv", header = T, sep = ",")
y_train = read.csv("y_train.csv", header = F, sep = ",")
y_valid = read.csv("y_valid.csv", header = F, sep = ",")

colnames(y_train) = colnames(y_valid) = c("Id","CarInsurance")

train = cbind(X_train, y_train$CarInsurance)
colnames(train)[36] = "CarInsurance"
train = train[,-1]

library(iml)
library(randomForest)

train$CarInsurance <- as.factor(as.character(train$CarInsurance))
rf = randomForest(CarInsurance ~ ., data = train, ntree = 100)

X = train[which(names(train) != "CarInsurance")]
predictor = Predictor$new(rf, data = X, y = train$CarInsurance)

ale = FeatureEffect$new(predictor = predictor, feature = "Age" , method = "ale")
plot(ale) + xlim(0,75)

pdp = FeatureEffect$new(predictor = predictor, feature = "Age" , method = "pdp")
plot(pdp)


ale = FeatureEffect$new(predictor = predictor, feature = "Balance" , method = "ale")
plot(ale) + scale_x_continuous(limits=c(0,8000))

pdp = FeatureEffect$new(predictor = predictor, feature = "Balance" , method = "pdp")
plot(pdp) + scale_x_continuous(limits=c(0,8000))

