# IMPROVEMENT CODE - APPLYING FILTERED CORE PREDICTORS TO BINARY CLASSIFICATION 

## MATHEMATICS 

library(randomForest)
library(rminer)
set.seed(123)


data_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable
data_orig$pass_fail <- as.factor(ifelse(data_orig$G3 >= 10, "pass", "fail"))

# Defining the Top 9 "core" features we found from the regression analysis
top_9_core_features <- c("failures", "absences", "Medu", "schoolsup", 
                         "goout", "age", "sex", "guardian", "Mjob")

# Creating the improved dataset for Setup C using these features
# Valid for both RF and SVM
data_C_imp <- data_orig[, c("pass_fail", top_9_core_features)]

cat("Mathematics dataset prepared for Binary Classification, Setup C, using the 9 core features.\n")


# Running Random Forest 

# Defining a CV function for binary RF classification
run_rf_binary_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  correct_predictions <- 0
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    
    rf_model <- randomForest(pass_fail ~ ., data = train_data, ntree = 500)
    predictions <- predict(rf_model, newdata = test_data)
    correct_predictions <- correct_predictions + sum(predictions == test_data$pass_fail)
  }
  
  # Returning overall accuracy in percentage
  return((correct_predictions / nrow(dataset)) * 100)
}

# Running the 20 replications
cat("\nRunning 20 replications on the improved Random Forest model...\n")
results_rf_imp <- replicate(20, run_rf_binary_cv(data_C_imp))
PCC_rf_imp <- mean(results_rf_imp)


# Running SVM
cat("Running 20 replications on the improved SVM model...\n")

# Defining the validation method
K_fold <- c("kfold", 10, 20)

# Running the mining process
SVM_C_imp <- mining(pass_fail ~ ., data=data_C_imp, model="svm", Runs=20, method=K_fold)
PCC_svm_imp_raw <- mmetric(SVM_C_imp, metric="ACC")
PCC_svm_imp <- mean(PCC_svm_imp_raw[,1]) # Convert to percentage


# FINAL RESULTS & COMPARISON
cat("\n\n FINAL ANALYSIS COMPLETE \n")
cat("Comparison for Mathematics, Binary Classification, Setup C (Accuracy %)\n")
cat("---------------------------------------------------------------------\n")
cat("Model          | Paper's Result | Improved (Top 9 Features)\n")
cat("---------------------------------------------------------------------\n")
# The paper's results for this case are from Table 3
cat("Random Forest  |      70.5%     |", PCC_rf_imp, "%\n")
cat("SVM            |      70.6%     |", PCC_svm_imp, "%\n")
cat("---------------------------------------------------------------------\n")

