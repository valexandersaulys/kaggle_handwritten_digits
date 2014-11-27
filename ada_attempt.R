library(ada)
library(caret)

tryer <- createDataPartition(set$label,p=0.01,list=FALSE)[, 1]
ada_tempt <- backup[tryer,]

modelFit_ada <- train(
  x=little_try[,2:253],
  y=as.factor(little_try[,1]),
  method='ada',
  preProcess=NULL,
  tuneGrid=data.frame(iter=1000,maxdepth=1000,nu=0.1),
  tuneLength= 3          # 
    )

modelFit_ada <- ada(
  x=little_try[,2:253],
  y=as.factor(little_try[,1]),
  )