rm(list = ls())  # clear workspace

library(h2o)
library(caret)
set.seed(2094)

# Setup the h2o server
localH2O <- h2o.init(Xmx='6g')

# First to import and look at the data
set <- read.csv('train.csv')
dataPartition <- createDataPartition(set$label, p = 0.6, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

train.h2o <- as.h2o(localH2O, training, key='train.hex')
validate.h2o <- as.h2o(localH2O, validate, key='valid.hex')

train2.hex = h2o.importFile(localH2O, path = '/Users/VASaulys/Documents/workspace/R/Kaggle_Handwritten_Digits/train.csv', key = "train2.hex")
summary(train2.hex)


# Setup variables for computation
indy <- names(train.h2o)[!names(train.h2o) %in% c('label')]
depy <- names(train.h2o[,1])



# RANDOMFOREST METHOD =========================
#
#    Accuracy : 0.9574          
# 95% CI : (0.9542, 0.9604)
# No Information Rate : 0.1124          
# P-Value [Acc > NIR] : < 2.2e-16       
# Kappa : 0.9526          
# Mcnemar's Test P-Value : NA  
#
# Important to note that x & y must be names not vectors/values/atoms/etc.
train.rf = h2o.randomForest(x=indy,y=depy, 
                             data=train.h2o, 
                             classification=TRUE)

predict.h2o.rf <- h2o.predict(object=train.rf, newdata=validate.h2o)
preds_rf <- as.data.frame(predict.h2o.rf)
confusionMatrix(preds$predict, validate$label)


# NEURAL NETS METHOD ===============
# First has two layers of 60 nodes with an accuracy of 0.9574
# Second has five layers of 20 nodes with an accuracy of 0.6807 
# Third has three layers of 784 nodes with an accuracy of 0.9665

train.nn <- h2o.deeplearning(x=indy, y=depy, 
                             data=train.h2o,
                             classification=TRUE,
                             hidden=c(60,60)
                              )

predict.h2o.nn <- h2o.predict(object=train.nn, newdata=validate.h2o)
preds_nn <- as.data.frame(predict.h2o.nn)
confusionMatrix(preds_nn$predict, validate$label)


train.nn.2 <- h2o.deeplearning(x=indy, y=depy, 
                               data=train.h2o,
                               classification=TRUE,
                               hidden=c(20,20,20,20,20)
                                )

predict.h2o.nn <- h2o.predict(object=train.nn.2, newdata=validate.h2o)
preds_nn <- as.data.frame(predict.h2o.nn)
confusionMatrix(preds_nn$predict, validate$label)


train.nn.3 <- h2o.deeplearning(x=indy, y=depy, 
                               data=train.h2o,
                               classification=TRUE,
                               hidden=c(784,784,784)
                                )

predict.h2o.nn <- h2o.predict(object=train.nn.3, newdata=validate.h2o)
preds_nn <- as.data.frame(predict.h2o.nn)
confusionMatrix(preds_nn$predict, validate$label)


train.nn.4 <- h2o.deeplearning(x=indy, y=depy, 
                               data=train.h2o,
                               classification=TRUE,
                               activation='Rectifier',
                               hidden=c(784,784,784,784),
                               adaptive_rate=TRUE,
                               #rho=0.999,
                               epsilon=1e-6
                               #,rate_decay=
                               #,epoch=
                                )

predict.h2o.nn <- h2o.predict(object=train.nn.4, newdata=validate.h2o)
preds_nn <- as.data.frame(predict.h2o.nn)
confusionMatrix(preds_nn$predict, validate$label)

train.nn.5 <- h2o.deeplearning(x=indy, y=depy, 
                               data=train.h2o,
                               classification=TRUE,
                               activation = "TanhWithDropout", # or 'Tanh'
                               input_dropout_ratio = 0.2, # % of inputs dropout
                               hidden_dropout_ratios = c(0.5,0.5,0.5), # % for nodes dropout
                               balance_classes = TRUE, 
                               hidden = c(784,784,784),
                               epochs = 100) 
                            )

predict.h2o.nn <- h2o.predict(object=train.nn.5, newdata=validate.h2o)
preds_nn <- as.data.frame(predict.h2o.nn)
confusionMatrix(preds_nn$predict, validate$label)



# Close up the h2o server
h2o.shutdown(localH2O, prompt = FALSE)
