# This caused a crash
modelFit_nnet <- train(label ~ ., data=set, method = 'nnet', tuneGrid=data.frame())

# data[row,column]
# This was an idea to balance out the grey areas but too entirely too fucking long
feature <- set
for (i in 2:785 ) { # columns
  if( max(set[[i]]) == 0 ) {   }
}
rm(feature)

feature <- set[, !colSums(set<2) == nrow(set)]
