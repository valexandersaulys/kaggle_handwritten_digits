library(caret)
library(nnet)
set.seed(2094)
set <- read.csv('train.csv')
#testing_set <- read.csv('test.csv')

dataPartition <- createDataPartition (set$label, p = 0.05, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

elmGrid = data.frame(nhid = 5, actfun = "sin")
zeTrain <- trainControl(method='repeatedcv',number=10)
modelFit_elm <- train(label ~ ., data=training, method='elm')
modelFit_nnet <- train(label ~ ., data=training, method='nnet', trControl=zeTrain, MaxNWts=4000)

modelFit_svm <-train(label ~ ., data=training, method='svmLinear')
modelFit_svmPoly <-train(label ~ ., data=training, method='svmPoly', trControl=ctrl, tuneGrid=data.frame(C=2000, degree=3, scale=FALSE))

modelFit_lssvmPoly  <- train(label ~ ., data=training, method = 'lssvmPoly', trControl=ctrl, tuneGrid=data.frame(degree=2, scale=1))
validate["predicted_lssvmPoly"] <- predict(modelFit_lssvmPoly, newdata=validate)


validate["predicted_nnet"] <- predict(modelFit_nnet, newdata=validate)
validate["predicted_avNNet"] <- predict(modelFit_avNNet, newdata=validate)
confusionMatrix(validate$label,validate$predicted_avNNet)


# modelFit_nnet <- neuralnet(label~.,data=training, hidden=3, threshold=0.01)
# varImp(modelFit_gbm)  # Helps list the importance of the various variales
# Now we predict using out model on the test set
#pml_testing["predicted_gbm"] <- predict(modelFit_gbm, newdata=pml_testing)
#answers <- pml_testing$predicted_gbm