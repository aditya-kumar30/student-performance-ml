##### FINDING THE BEST NUMBER OF FEATURES FOR REGRESSION CASE (PORTUGESE DATA)
library(randomForest)
set.seed(123)


# DATA PREPARATION & FEATURE RANKING
data_orig_por <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)
data_C_por <- subset(data_orig_por, select = -c(G1, G2))

# Training a single RF model to get importance scores
rf_model_descriptive_por <- randomForest(G3 ~ ., 
                                         data = data_C_por, 
                                         ntree = 500, 
                                         importance = TRUE)

# Extracting and sorting the importance scores
raw_importance_por <- importance(rf_model_descriptive_por, type = 1, scale = FALSE)
sorted_importance_por <- sort(raw_importance_por[,1], decreasing = TRUE)
ranked_features_por <- names(sorted_importance_por) # GetTING the full list of features, ranked

cat("All features have been ranked by importance for the Portuguese dataset.\n")


# TESTING ALL POSSIBLE SUBSET SIZES

run_rf_regression_cv <- function(dataset) {
  K <- 10 
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  predictions_df <- data.frame(true_value = dataset$G3, predicted_value = NA_real_)
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    rf_model <- randomForest(G3 ~ ., data = train_data, ntree = 500)
    fold_predictions <- predict(rf_model, newdata = test_data)
    predictions_df$predicted_value[test_indices] <- fold_predictions
  }
  
  rmse <- sqrt(mean((predictions_df$true_value - predictions_df$predicted_value)^2, na.rm = TRUE))
  return(rmse)
}

# testing every subset size, from 1 up to the total number of features.
subset_sizes_to_test_por <- 1:length(ranked_features_por) 
results_by_size_por <- data.frame(num_features = integer(), rmse = double())

for (n in subset_sizes_to_test_por) {
  cat("  Testing model with Top", n, "features...\n")
  
  top_n_features_por <- head(ranked_features_por, n)
  
  data_subset_por <- data_C_por[, c("G3", top_n_features_por)]
  
  mean_rmse_por <- mean(replicate(20, run_rf_regression_cv(data_subset_por)))
  
  results_by_size_por <- rbind(results_by_size_por, data.frame(num_features = n, rmse = mean_rmse_por))
}


# DISPLAYING FINAL RESULTS
cat("\n\n--- Final Results for Portuguese Dataset ---\n")
print(results_by_size_por)

# Finding and reporting the best number of features
best_result_por <- results_by_size_por[which.min(results_by_size_por$rmse), ]
cat("\nOptimal number of features found:", best_result_por$num_features, "\n")
cat("Best RMSE achieved:", best_result_por$rmse, "\n")
cat("Compare to the original All-Features model (Paper): 2.67\n")


# Plotting the results to visualize the performance curve
plot(results_by_size_por$num_features, results_by_size_por$rmse, 
     type = "b", 
     xlab = "Number of Top Features Used", 
     ylab = "Cross-Validated RMSE",
     main = "Finding the Optimal Number of Features (Portuguese)")

# Getting the names of the best features
top_features_por <- head(ranked_features_por, best_result_por$num_features)
cat("\nThe optimal features for the Portuguese dataset are:\n")
print(top_features_por)

# EVALUATING THE SVM MODEL USING THE OPTIMAL FEATURE SET (PORTUGUESE) 

library(rminer)

optimal_n_por <- best_result_por$num_features
top_optimal_features_por <- head(ranked_features_por, optimal_n_por)

cat("\nUsing the optimal set of", optimal_n_por, "features to test the SVM model for the Portuguese dataset.\n")
print(top_optimal_features_por)

data_C_imp_por <- data_C_por[, c("G3", top_optimal_features_por)]

cat("\nImproved dataset for Portuguese Setup C has been created.\n")


# Running the final evaluation for the SVM model
K_fold <- c("kfold", 10, 20)

cat("\nRunning 20-run CV on the Improved SVM Model... (This may take some time)\n")
SVM_C_imp_por <- mining(G3 ~ ., data=data_C_imp_por, model="svm", Runs=20, method=K_fold)
RMSE_C_imp_por <- mmetric(SVM_C_imp_por, metric="RMSE")


# DISPLAYING FINAL RESULTS & COMPARISON 
cat("\n\n--- Final SVM Analysis Complete ---\n")
cat("Comparison for Portuguese, SVM, Setup C:\n")
cat("  - Original SVM (Paper's Result): 2.76\n")
cat("  - Improved SVM (Optimal Features):", mean(RMSE_C_imp_por[,1]), "\n")