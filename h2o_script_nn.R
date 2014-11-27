rm(list = ls())  # clear workspace
h2o.shutdown(localH2O, prompt = FALSE)

library(h2o)
library(caret)
set.seed(2094)

# Setup the h2o server
localH2O <- h2o.init(max_mem_size='8g',min_mem_size='2g')

# First to import and look at the data
set <- read.csv('train.csv')
# set <- set[, -nearZeroVar(set)]  # eliminate variables that don't do much
dataPartition <- createDataPartition(set$label, p = 0.75, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

train.h2o <- as.h2o(localH2O, training, key='train.hex')
validate.h2o <- as.h2o(localH2O, validate, key='valid.hex')

# Setup variables for computation
indy <- names(train.h2o)[!names(train.h2o) %in% c('label')]
depy <- names(train.h2o[,1])


modelFit_nn_tanh <- h2o.deeplearning(x=indy, y=depy, 
                               data=train.h2o,
                               classification=TRUE,
                               hidden=c(800,512,102),
                               activation='Rectifier',
                               validation=validate.h2o
                                )

predict.h2o.nn <- h2o.predict(object=modelFit_nn_tanh, newdata=validate.h2o)
predict.h2o.nn