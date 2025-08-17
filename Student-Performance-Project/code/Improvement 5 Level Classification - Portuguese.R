# TESTING SELECTED FEATURES ON 5 LEVEL CLASSIFICATION

## PORTUGUESE 

 


library(randomForest)
library(rminer)
set.seed(123)


data_orig <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the 5-level target variable
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V", "IV", "III", "II", "I")
data_orig$grade_level <- cut(data_orig$G3, breaks = grade_breaks, labels = grade_labels)

# Defining the Top 23 features found from the Portuguese regression analysis
top_23_features_por <- c("failures", "higher", "school", "Dalc", "Medu", 
                         "schoolsup", "studytime", "Walc", "Fedu", "sex", 
                         "age", "absences", "reason", "goout", "Fjob", 
                         "freetime", "traveltime", "health", "internet", "address", 
                         "famrel", "nursery", "famsup")

# RANDOM FOREST

# Creating the improved dataset for Setup C using these features
data_C_imp_rf <- data_orig[, c("grade_level", top_23_features_por)]

cat("Portuguese dataset prepared for 5-Level Classification, Setup C, using its specific top 23 regression features.\n")


# Defining our 20-run CV function for classification
run_rf_classification_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  predictions_df <- data.frame(
    true_value = dataset$grade_level,
    predicted_value = factor(rep(NA, nrow(dataset)), levels = levels(dataset$grade_level))
  )
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    
    # Training the model on the 'grade_level' target
    rf_model <- randomForest(grade_level ~ ., data = train_data, ntree = 500)
    fold_predictions <- predict(rf_model, newdata = test_data)
    predictions_df$predicted_value[test_indices] <- fold_predictions
  }
  
  # Calculating and returning the overall accuracy
  overall_accuracy <- mean(predictions_df$true_value == predictions_df$predicted_value, na.rm = TRUE)
  return(overall_accuracy * 100)
}

# Running the 20 replications on the improved dataset
cat("\nRunning 20 replications on the improved Random Forest model... (This may take some time)\n")
results_imp_rf <- replicate(20, run_rf_classification_cv(data_C_imp_rf))
PCC_imp_rf <- mean(results_imp_rf)


# FINAL RESULTS & COMPARISON
cat("\n\n RF Analysis Complete \n")
cat("Comparison for Portuguese, RF, 5-Level Classification, Setup C:\n")
# The paper's result for this specific case is 33.1% (from Table 4)
cat("  - Original RF (Paper): 33.1%\n")
cat("  - Improved RF (using Regression's Top 23 Features):", PCC_imp_rf, "%\n")


#SVM 

# Creating the improved dataset for Setup C for the SVM model
data_C_imp_svm <- data_orig[, c("grade_level", top_23_features_por)]

cat("\n\nPortuguese dataset prepared for 5-Level SVM Classification, Setup C, using its specific top 23 regression features.\n")

# Defining the validation method
K_fold <- c("kfold", 10, 20)

cat("\nRunning 20-run CV on the Improved SVM Model... (This may take some time)\n")
SVM_C_imp <- mining(grade_level ~ ., data=data_C_imp_svm, model="svm", Runs=20, method=K_fold)
PCC_C_imp <- mmetric(SVM_C_imp, metric="ACC")


# SVM RESULTS & COMPARISON 
cat("\n\n Final SVM Analysis Complete \n")
cat("Comparison for Portuguese, SVM, 5-Level Classification, Setup C:\n")
# The paper's result for this specific case is 32.8% (from Table 4)
cat("  - Original SVM (Paper's Result): 32.8%\n") 
cat("  - Improved SVM (using RF's Top 23 Features):", mean(PCC_C_imp[,1]), "%\n")