rm(list = ls())  # clear workspace
#
#   This is using the randomForest method
#   Time to Execute => 
#
#
library(caret)
library(e1071)
set.seed(2094)
set <- read.csv('train.csv')
backup <- set

# Columns were little variance are not helpful for prediction
set <- set[, -nearZeroVar(set)]

#dataPartition <- createDataPartition(set$label, p = 0.6, list = FALSE)[, 1]
#training <- set[dataPartition, ]
#validate <- set[-dataPartition, ]

tryer <- createDataPartition(set$label,p=0.01,list=FALSE)[, 1]
little_try <- set[tryer, ]
Big_try <- set[-tryer,]

little_try$label <- as.character(little_try$label)
little_try$label[little_try$label == "1"] <- "one"
little_try$label[little_try$label == "0"] <- "zero"
little_try$label[little_try$label == "2"] <- "two"
little_try$label[little_try$label == "3"] <- "three"
little_try$label[little_try$label == "4"] <- "four"
little_try$label[little_try$label == "5"] <- "five"
little_try$label[little_try$label == "6"] <- "six"
little_try$label[little_try$label == "7"] <- "seven"
little_try$label[little_try$label == "8"] <- "eight"
little_try$label[little_try$label == "9"] <- "nine"

MyTrainControl=trainControl(
  method = "repeatedcv",
  number=10,
  repeats=5,
  returnResamp = "all",
  classProbs = TRUE
) 

modelFit_svm <- train(
  x=little_try[,2:253],
  y=little_try[,1],
  method="svmRadial",
  preProc = c("scale"),
  tuneLength = 100,
  trControl=MyTrainControl,
  fit = FALSE,
  tuneGrid=data.frame(sigma=0.002214861,C=4)
  )

modelFit_svm <- svm(x=little_try[,2:253],
                    y=little_try[,1],
                    type='nu-classification',
                    nu=0.5,
                    degree=3,
                    cost=1,
                    scale=FALSE,
                    kernel="polynomial")

# Models
#modelFit_svm <- svm(x=little_try[,2:253],y=as.factor(little_try[,1]), scale=FALSE,type=NULL,kernel='linear',degree=3,coef0=0,cost=1,nu=0.5)
#modelFit_svm <- train(x=little_try[,2:253],y=as.factor(little_try[,1]), method='svmLinear', tuneGrid=data.frame(C=10))



#validate["pred1"] <- predict(modelFit_nnet, newdata=validate)
#validate["pred2"] <- predict(modelFit_avNNet, newdata=validate)
#confusionMatrix(validate$label,validate$pred1)

Big_try['pred1'] <- predict(modelFit_svm, newdata=Big_try)

little_try['pred1'] <- predict(modelFit_svm, newdata=little_try)



