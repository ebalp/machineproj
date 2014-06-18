Human Activity Recognition using Machine Learning
========================================================

We will create a Machine Learning model to distinguish between classes (A, B, C, D, E) 

## Initial Processing

We load the training and testing data, fit a Random Forest model (rf) predicting the classe variable using 50% of the observations, using only the variables without missing data. We save the model in a file for later use, due to the great time spent in the calculation.



```r
library(caret)
data <- read.csv("pml-training.csv")
datest <- read.csv("pml-testing.csv")
removeIndex <- grep("timestamp|X|user_name|new_window", names(data))
data <- data[, -removeIndex]
datest <- datest[, -removeIndex]

data <- data[, which(colSums(is.na(datest)) == 0)]
datest <- datest[, which(colSums(is.na(datest)) == 0)]

inTrain <- createDataPartition(data$classe, p = 1/2)[[1]]
training <- data[inTrain, ]
testing <- data[-inTrain, ]
```


```r
modRF <- train(classe ~ ., data = training, method = "rf")
save(modRF, file = ".modRF")
```


In order to check the model, we take the testing data (50% of total) and compare the prediction and the real classe. This allows us to cross-validate, and find that the accuracy of the model. 

We compute the confusion matrices of the model with the out of sample data:

```r
load(".modRF")
pred <- predict(modRF, testing)
conf <- confusionMatrix(testing$classe, pred)

conf
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 2790    0    0    0    0
##          B    6 1888    4    0    0
##          C    0    8 1703    0    0
##          D    0    0    6 1602    0
##          E    0    2    0    5 1796
## 
## Overall Statistics
##                                         
##                Accuracy : 0.997         
##                  95% CI : (0.996, 0.998)
##     No Information Rate : 0.285         
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.996         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             0.998    0.995    0.994    0.997    1.000
## Specificity             1.000    0.999    0.999    0.999    0.999
## Pos Pred Value          1.000    0.995    0.995    0.996    0.996
## Neg Pred Value          0.999    0.999    0.999    0.999    1.000
## Prevalence              0.285    0.193    0.175    0.164    0.183
## Detection Rate          0.284    0.192    0.174    0.163    0.183
## Detection Prevalence    0.284    0.193    0.174    0.164    0.184
## Balanced Accuracy       0.999    0.997    0.997    0.998    1.000
```


Thus, using cross validation, we therefore estimate the out-of-sample accuracy as 99%, just like the confusion matrix shows.

