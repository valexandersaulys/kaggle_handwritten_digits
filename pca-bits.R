pca_r_model <- prcomp(training[,2:785], retx=TRUE, tol=0.01)
analy <- as.data.frame(pca_r_model$x)
analy[,'label'] <- training$label

pca_r_valida <- prcomp(validate[,2:785], retx=TRUE, tol=0.01)
final <- as.data.frame(pca_r_valida$x)
final[,'label'] <- validate$label