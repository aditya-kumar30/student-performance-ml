# TESTING SELECTED FEATURES ON 5 LEVEL CLASSIFICATION

## MATHEMATICS


library(randomForest)
set.seed(123)


data_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the 5-level target variable
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V", "IV", "III", "II", "I")
data_orig$grade_level <- cut(data_orig$G3, breaks = grade_breaks, labels = grade_labels)

# Defining the Top 9 features we found from the regression analysis
top_9_features_from_regression <- c("failures", "absences", "Medu", "schoolsup", 
                                    "goout", "age", "sex", "guardian", "Mjob")

## RANDOM FOREST 


# Creating the improved dataset for Setup C using these features
data_C_imp <- data_orig[, c("grade_level", top_9_features_from_regression)]

cat("Mathematics dataset prepared for 5-Level Classification, Setup C, using top regression features.\n")


# Defining the 20-run CV function for classification
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
cat("\nRunning 20 replications on the improved model... (This may take some time)\n")
results_imp <- replicate(20, run_rf_classification_cv(data_C_imp))
PCC_imp <- mean(results_imp)


# FINAL RESULTS & COMPARISON
cat("\n\n RF Analysis Complete \n")
cat("Comparison for Mathematics, RF, 5-Level Classification, Setup C:\n")
cat("  - Original RF (Paper): 33.5%\n")
cat("  - Improved RF (using Regression's Top 9 Features):", PCC_imp, "%\n")


#SVM 


library(rminer)

# Defining the 5-level target variable again for clarity.
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V", "IV", "III", "II", "I")
data_orig$grade_level <- cut(data_orig$G3, breaks = grade_breaks, labels = grade_labels)

# Defining the Top 9 features we found from the regression analysis
top_9_features_from_regression <- c("failures", "absences", "Medu", "schoolsup", 
                                    "goout", "age", "sex", "guardian", "Mjob")

# Creating the improved dataset for Setup C using these features
data_C_imp_svm <- data_orig[, c("grade_level", top_9_features_from_regression)]

cat("Mathematics dataset prepared for 5-Level SVM Classification, Setup C, using top regression features.\n")


# Defining the validation method
K_fold <- c("kfold", 10, 20)

cat("\nRunning 20-run CV on the Improved SVM Model... (This may take some time)\n")
SVM_C_imp <- mining(grade_level ~ ., data=data_C_imp_svm, model="svm", Runs=20, method=K_fold)
PCC_C_imp <- mmetric(SVM_C_imp, metric="ACC")


# FINAL RESULTS & COMPARISON 
cat("\n\n Final SVM Analysis Complete \n")
cat("Comparison for Mathematics, SVM, 5-Level Classification, Setup C:\n")
cat("  - Original SVM (Paper's Result): 31.0%\n")
cat("  - Improved SVM (using RF's Top 9 Features):", mean(PCC_C_imp[,1]), "%\n")