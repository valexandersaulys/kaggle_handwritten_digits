rm(list = ls())  # clear workspace
h2o.shutdown(localH2O, prompt = FALSE)

library(h2o)
library(caret)
set.seed(2094)

# Setup the h2o server
localH2O <- h2o.init(max_mem_size='6g',min_mem_size='2g')

# First to import and look at the data
set <- read.csv('train.csv')
dataPartition <- createDataPartition(set$label, p = 0.75, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

train.h2o <- as.h2o(localH2O, training, key='train.hex')
validate.h2o <- as.h2o(localH2O, validate, key='valid.hex')

# Setup variables for computation
indy <- names(train.h2o)[!names(train.h2o) %in% c('label')]
depy <- names(train.h2o[,1])

modelFit_kmeans <- h2o.kmeans(
                      data=train.h2o,
                      centers=10000,
                      cols=c('label'),
                      #normalize=TRUE,
                      #init='furthest',
                      #dropNACols=TRUE,
                      seed=123054831252319
                      )

prediction.h2o <- h2o.predict(object=modelFit_kmeans, newdata=validate.h2o)
preds_nn <- as.data.frame(prediction.h2o)
confusionMatrix(preds_nn$predict, validate$label)

# Close up the h2o server
h2o.shutdown(localH2O, prompt = FALSE)
