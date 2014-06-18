Machine Learning
========================================================


```{r}
library(caret)

training = read.csv("pml-training.csv")
testing = read.csv("pml-testing.csv")



```



```{r fig.width=7, fig.height=6}

modRF <- train(classe ~.,data=training,method="rf",prox=TRUE)

prRF <- predict(modRF,testing)
confRF <- confusionMatrix(testing$classe, predict(modRF,testing))

```

