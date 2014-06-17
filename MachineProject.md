Human Activity Recognition using Machine Learning
========================================================

We will create a Machine Learning model to distinguish between 

## Initial Processing

We load the training and testing data, fit a CART model (rpart) predicting the classe variable using 12.5% of the observations (due to memory limitations), using only the variables without missing data. We save the model in a file for later use, due to the great time spent in the calculation.

This was done beforehand twice (using the same code), getting two models, modRPART and modRPART2


```r
library(caret)
data <- read.csv("pml-training.csv")
data <- data[, which(colSums(is.na(data)) == 0)]

inTrain <- createDataPartition(data$classe, p = 1/8)[[1]]
training <- data[inTrain, ]

modRPART <- train(classe ~ ., data = training, method = "rpart")
save(modRPART, file = ".modRPART")
```


In order to check the model, we take a small sample (0.2%) and compare the prediction and the real classe. This allows us to cross-validate, and find that the accuracy of the model. 

In modRPART we cannot distinguish between C and D, but the prediction is perfect for the other classes.

We plot the confusion matrices of the model:

```r
load(".modRPART")
library(caret)
data <- read.csv("pml-training.csv")
data <- data[, which(colSums(is.na(data)) == 0)]

inTesting <- createDataPartition(data$classe, p = 1/500)[[1]]
testing <- data[inTesting, ]

pred <- predict(modRPART, testing)
```

```
## Warning: Reached total allocation of 3583Mb: see help(memory.size)
## Warning: Reached total allocation of 3583Mb: see help(memory.size)
## Warning: Reached total allocation of 3583Mb: see help(memory.size)
## Warning: Reached total allocation of 3583Mb: see help(memory.size)
```

```r
conf <- confusionMatrix(testing$classe, pred)

rm(modRPART)
conf
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction  A  B  C  D  E
##          A 12  0  0  0  0
##          B  0  8  0  0  0
##          C  0  0  7  0  0
##          D  0  0  7  0  0
##          E  0  0  0  0  8
## 
## Overall Statistics
##                                        
##                Accuracy : 0.833        
##                  95% CI : (0.686, 0.93)
##     No Information Rate : 0.333        
##     P-Value [Acc > NIR] : 3.49e-11     
##                                        
##                   Kappa : 0.789        
##  Mcnemar's Test P-Value : NA           
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             1.000     1.00    0.500       NA     1.00
## Specificity             1.000     1.00    1.000    0.833     1.00
## Pos Pred Value          1.000     1.00    1.000       NA     1.00
## Neg Pred Value          1.000     1.00    0.800       NA     1.00
## Prevalence              0.286     0.19    0.333    0.000     0.19
## Detection Rate          0.286     0.19    0.167    0.000     0.19
## Detection Prevalence    0.286     0.19    0.167    0.167     0.19
## Balanced Accuracy       1.000     1.00    0.750       NA     1.00
```


Thus, using cross validation, we therefore estimate the out-of-sample accuracy as 83%, just like the confusion matrix shows.

