
# Reads the data from the CSV file
data <- read.csv("pml-training.csv", header = TRUE, sep = ",")
testData <- read.csv("pml-testing.csv", header = TRUE, sep = ",")

# Finds the variables with more than 70% null values
predictors2remove <- c()
for(i in 1:159){
  
  divs <- which(sampling[,i] == "#DIV/0!")
  if(length(divs) > 0)
    sampling[divs,i] <- NA
  
  nos <- which(sampling[,i] == "")
  if(length(nos) > 0)
    sampling[nos,i] <- NA
  
  NAs <- which(is.na(sampling[,i]))
  if(length(NAs) > 0.7*500)
    predictors2remove <- c(predictors2remove, i)
  
  cat(i*100/159, "%\n")
}

# Removes those variables
newData <- data[,-predictors2remove]
newTestData <- testData[,-predictors2remove]

# creates the folds for cross-validation
folds <- createFolds(newData$classe, k=5)

# gets the first fold
training1 <- newData[c(folds[[1]], folds[[2]], folds[[3]]),]
testing1 <- newData[c(folds[[4]], folds[[5]]),]

# Fits a tree model
treeModel1 <- train(classe ~ ., data=training1[,- (1:7)], method = "LMT")
# gets the 1st accuracy
acc1 <- length(which(testing1[, 60] == predict(treeModel, testing1)))/length(testing1[,1])
# makes the 1st prediction
pred1 <- predict(treeModel, newTestData[,-60])

# gets the second fold
training2 <- newData[c(folds[[3]], folds[[4]], folds[[5]]),]
testing2 <- newData[c(folds[[1]], folds[[2]]),]

# Fits a tree model
treeModel2 <- train(classe ~ ., data=training2[,- (1:7)], method = "LMT")
# gets the 2nd accuracy
acc2 <- length(which(testing2[, 60] == predict(treeModel2, testing2)))/length(testing2[,1])
#makes the 2nd prediction
pred2 <- predict(treeModel2, newTestData[,-60])

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("output/problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
