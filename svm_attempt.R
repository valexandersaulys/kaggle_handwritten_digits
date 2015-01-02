rm(list = ls())  # clear workspace
#
#   To be run in Bash before --> $ ulimit -v 12000000
#
#   This is using the SVM method
#   Time to Execute => 
#
#
library(caret)
library(e1071)
library(kernlab)
set.seed(2094)
set = read.csv('train.csv')
set$label <- as.factor(set$label)
backup <- set

# Register the Multiple Cores
library(doMC)
registerDoMC(7)   # I keep one open to run the systm stuff

##########################
########## Doing Pre-Processing
set <- set[, -nearZeroVar(set)]
#prepped_set <- preProcess(x=set[,2:785], 
#                          method = c("center", "scale"), 
 #                         #thresh = 0.95, #overridden with pcaComp
  #                        pcaComp = 256,   # For a 16x16 image, thats the idea anyway
   #                       na.remove = TRUE,
    #                      k = 5,
     #                     knnSummary = mean,
      #                    outcome = NULL,
       #                   fudge = .2,
        #                  numUnique = 3,
         #                 verbose = FALSE
          #              )
#set <- prepped_set$rotation

dataPartition <- createDataPartition(set$label, p = 0.6, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

#tryer <- createDataPartition(set$label,p=0.01,list=FALSE)[, 1]
#little_try <- set[tryer, ]
#big_try <- set[-tryer,]

###########################
########## Setting up Train Control
MyTrainControl <- trainControl(
  method = "repeatedcv",
  number=10,
  repeats=5,
  returnResamp = "all",
  classProbs = TRUE
) 

##########################
########## Doing the model fit
system.time( modelFit_svm <- train(
  x=training[,2:253],
  y=training[,1],
  method="svmRadial",
  #preProcess = c("center", "scale"),
  #tuneLength = 10,
  trControl=MyTrainControl,
  #scale = FALSE,
  #probability=TRUE,
  tuneGrid=data.frame(sigma=0.1, C=1)
  ) )     # the system.time estimates the time of completion

training['pred1'] <- predict(modelFit_svm, newdata=training)
confusionMatrix(data=training$pred1,reference=training$label)
validation['pred1'] <- predict(modelFit_svm, newdata=validation)
confusionMatrix(data=validation$pred1,reference=validation$label)


