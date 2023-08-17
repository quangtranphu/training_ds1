library(mlflow)
library(dplyr)
library(rpart)
library(pROC)
library(ROCR)
library(ISLR)

data("Default")

set.seed(101) 
sample <- sample.int(n = nrow(Default), 
                     size = floor(.75*nrow(Default)), 
                     replace = F)
train <- Default[sample, ]
test  <- Default[-sample, ]

mlflow_set_tracking_uri("http://ec2-13-229-104-92.ap-southeast-1.compute.amazonaws.com:5000")
mlflow_set_experiment("Test1")

maxdepth <- mlflow_param('maxdepth', 20, 'numeric')
xval <- mlflow_param('xval', 8, 'numeric')
cp <- mlflow_param('cp', 0.05, 'numeric')
minsplit = mlflow_param('minsplit', 30, 'numeric')

with(mlflow_start_run(),{
  
  model <- rpart(default ~ ., data = Default,
                 control = rpart.control(maxdepth = maxdepth,
                                         xval = xval,
                                         cp = cp,
                                         minsplit = minsplit)
  )
  
  predict_ = predict(model, test, type = 'prob')[,2]
  prediction <- prediction(predict_, test$default)
  
  auc <- performance(prediction, measure = 'auc')@y.values[[1]] %>% 
    round(2)
  
  mlflow_log_param("maxdepth", maxdepth)
  mlflow_log_param("xval", xval)
  mlflow_log_param("cp", cp)
  mlflow_log_param('minsplit', minsplit)
  mlflow_log_metric('auc', auc)
  model %>% saveRDS('model.rds')
  mlflow_log_artifact('/home/rstudio/model.rds', "model")
  
})
