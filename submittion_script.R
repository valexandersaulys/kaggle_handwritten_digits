library(h2o)
library(caret)
set.seed(20948432)

test <- read.csv('test.csv')

# Normalization of Data
  test <- (test/(max(test))) 

test.h2o <- as.h2o(localH2O, test, key='test.hex')

modelFinal <- train.rf

predictions <- as.data.frame(h2o.predict(modelFinal,newdata=test.h2o))
submit <- data.frame(ImageId = as.numeric(rownames(test)),
                       label = predictions$predict)

write.csv(submit, file = "submittion_112714_tres.csv", row.names = FALSE)
