# IMPROVEMENT CODE - APPLYING FILTERED CORE PREDICTORS TO BINARY CLASSIFICATION 

## PORTUGUESE

library(randomForest)
library(rminer)
set.seed(123)

data_orig <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable
data_orig$pass_fail <- as.factor(ifelse(data_orig$G3 >= 10, "pass", "fail"))

# Defining the Top 23 features we found from the Portuguese regression analysis
top_23_core_features_por <- c("failures", "higher", "school", "Dalc", "Medu", 
                              "schoolsup", "studytime", "Walc", "Fedu", "sex", 
                              "age", "absences", "reason", "goout", "Fjob", 
                              "freetime", "traveltime", "health", "internet", "address", 
                              "famrel", "nursery", "famsup")

# Creating the improved dataset for Setup C using these features
# Valid for both RF and SVM
data_C_imp <- data_orig[, c("pass_fail", top_23_core_features_por)]

cat("Portuguese dataset prepared for Binary Classification, Setup C, using the 23 core features.\n")


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


# RUnning SVM

cat("Running 20 replications on the improved SVM model...\n")

# Defining the validation method
K_fold <- c("kfold", 10, 20)

# Running the mining process
SVM_C_imp <- mining(pass_fail ~ ., data=data_C_imp, model="svm", Runs=20, method=K_fold)
PCC_svm_imp_raw <- mmetric(SVM_C_imp, metric="ACC")
PCC_svm_imp <- mean(PCC_svm_imp_raw[,1]) # Convert to percentage


# FINAL RESULTS & COMPARISON
cat("\n\n FINAL ANALYSIS COMPLETE \n")
cat("Comparison for Portuguese, Binary Classification, Setup C (Accuracy %)\n")
cat("---------------------------------------------------------------------\n")
cat("Model          | Paper's Result | Improved (Top 23 Features)\n")
cat("---------------------------------------------------------------------\n")
# The paper's results for this case are from Table 3
cat("Random Forest  |      85.0%     |", PCC_rf_imp, "%\n")
cat("SVM            |      84.8%     |", PCC_svm_imp, "%\n")
cat("---------------------------------------------------------------------\n")