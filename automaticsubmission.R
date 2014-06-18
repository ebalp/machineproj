

pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}


library(caret)
data <- read.csv("pml-training.csv")
datest <- read.csv("pml-testing.csv")
data <- data[,which(colSums(is.na(datest))==0)]

inTrain <- createDataPartition(data$classe, p = 1)[[1]]
training <-  data[ inTrain,]

modRF <- train(classe ~.,data=training,method="rf")
save(modRF,file=".modRFCH")

load(".modRF")
library(caret)
datest <- datest[,which(colSums(is.na(datest))==0)]
datest <- datest[,-length(datest[1,])]

answers <- predict(modRF,datest)

pml_write_files(answers)




library(caret)
data <- read.csv("pml-training.csv")
datest <- read.csv("pml-testing.csv")
data <- data[,which(colSums(is.na(datest))==0)]

inTesting <- createDataPartition(data$classe, p = 1/1000)[[1]]
testing <-  data[ inTesting,]

pred <- predict(modRF,testing)
conf <- confusionMatrix(testing$classe, pred)

conf