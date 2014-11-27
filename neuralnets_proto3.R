rm(list = ls())  # clear workspace

library(h2o)
library(caret)
set.seed(20948432)

# Setup the h2o server
localH2O <- h2o.init(max_mem_size='8g',min_mem_size='2g')

# First to import and look at the data
set <- read.csv('train.csv')
dataPartition <- createDataPartition(set$label, p = 0.7, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

train.h2o <- as.h2o(localH2O, training, key='train.hex')
validate.h2o <- as.h2o(localH2O, validate, key='valid.hex')

# Setup variables for computation
indy <- names(train.h2o)[!names(train.h2o) %in% c('label')]
depy <- names(train.h2o[,'label'])

NeuralNets_proto1 <- h2o.deeplearning(x=indy, y=depy, 
                                     data=train.h2o,
                                     classification=TRUE,
                                     nfolds=10, 
                                     epochs=10,
                                     hidden=c(800,512,102),
                                     activation='Rectifier'
                                    )

NeuralNets_proto2 <- h2o.deeplearning(x=indy, y=depy, 
                                      data=train.h2o,
                                      classification=TRUE,
                                      nfolds=10, 
                                     # epochs=10,
                                      hidden=c(800,512,102),
                                      activation='Rectifier'
)


predict.h2o.nn <- h2o.predict(object=NeuralNets_proto3_wpca, 
                              newdata=validate.h2o)
h2o.confusionMatrix(predict.h2o.nn$predict,validate.h2o$label)
