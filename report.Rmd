Practical Machine Learning Course Project Report
========================================================

This document is structured as follows: In the first section, it is described the pre-processing and data division; In the second section, some tests with different models are described; By the end, the conclusions.

Pre-processing
--------------------------

The available data was extracted using the `read.csv` function, creating two data frames, one with the labeled data and another with the test set, as follows:

```
# Reads the data from the CSV file
data <- read.csv("pml-training.csv", header = TRUE, sep = ",")
testData <- read.csv("pml-testing.csv", header = TRUE, sep = ",")
```

With a quick overview on the training set using the `summary` function, it was noticed that many variables consisted mostly of "invalid" values, such as "#DIV/0!", NA and "". The following script was written to eliminate those variables, more precisely, the ones which contained more than 70% of such values:

```
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
```

Furthermore, the first seven variables were also removed due to the first analysis with the `summary` function. 
Other pre-processing transformations (standardization and PCA) were applied within the `train` function. 
The data set division was made using the `createFolds` function regarding the `classe` variable, dividing it into five parts, with which, two training and validation sets were built in the following manner: Let D1, D2, D3, D4 and D5 be the 5 parts dividing the data set; The first training set consisted of the parts D1, D2 and D3 and the first validation set consisted of the D4 and D5 parts; The second training set was built with the D3, D4 and D5 parts, while the second validation set was built with the D1 and D2 parts.

Tests
-------------------

Many different models were tested, applied to the first training and validation sets. They are listed below:
- Boosting with Trees ('`ada`', '`bstTree`');
- Boosting with Logistic Model ('`logitBoost`');
- K-Nearest Neighbours ('`knn`');
- Linear Discriminant Analys ('`lda`', '`Linda`');
- Logistic Model Trees ('`LMT`');
- Support Vector Machine ('`svmRadial`');

From these methods, the Logistic Model Trees achieved the highest accuracy (~97%), as well as the best sensibility and precision. Then, this method was applied to the second training and validation sets, achieving similar results, suggesting that this model would perform well in the out-of-sample case. Then it was chosen to be applied to the test set. The default tunning parameters' values were used to fit the LMT. Pre-processing using the '`scale`', '`center`' and '`pca`' parameters were tested, but no significant improvement was noticed with the LMT. They were also tested with others models, but none achieved better results than the LMT.

Conclusions
---------------------

Unfortunately it wasn't possible to apply a better descriptor analysis and also to make use of the whole cross-validation process due to the lack of time. However, it was shown that the chosen model produces good results, since it predicted correctly all test samples.
