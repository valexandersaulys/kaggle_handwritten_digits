rm(list = ls())  # clear workspace

library(h2o)
library(caret)
set.seed(2094)

# Setup the h2o server
localH2O <- h2o.init(Xmx='8g')

# First to import and look at the data
set <- read.csv('train.csv')
dataPartition <- createDataPartition(set$label, p = 0.6, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

# Normalizing the data between 
training[2:785] <- (training[2:785] / (max(training)*2)) - 1
validate[2:785] <- (validate[2:785] / (max(validate)*2)) - 1

train.h2o <- as.h2o(localH2O, training, key='train.hex')
validate.h2o <- as.h2o(localH2O, validate, key='valid.hex')

# Setup variables for computation
indy <- names(train.h2o)[!names(train.h2o) %in% c('label')]
depy <- names(train.h2o[,1])

train.rf = h2o.randomForest(x=indy,y=depy, 
                            data=train.h2o, 
                            classification=TRUE,
                            ntree=100,
                            depth=30,
                            sample.rate=2/3,
                            nbins=20,
                            nfolds=10,
                            nodesize=1
                            #,balance.classes=TRUE    # This appears useless now the data is normalized up top
)

predict.h2o.rf <- h2o.predict(object=train.rf, newdata=validate.h2o)
preds_rf <- as.data.frame(predict.h2o.rf)
confusionMatrix(preds_rf$predict, validate$label)

