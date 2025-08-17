###### FINDING THE BEST NUMBER OF FEATURES FOR REGRESSION CASE (MATH DATA) #######

# SETUP & REPRODUCIBILITY 
library(randomForest)
set.seed(123)


# DATA PREPARATION & FEATURE RANKING 
data_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)
data_C <- subset(data_orig, select = -c(G1, G2))

# Training a single RF model to get importance scores
rf_model_descriptive <- randomForest(G3 ~ ., 
                                     data = data_C, 
                                     ntree = 500, 
                                     importance = TRUE)

# Extracting and sorting the importance scores
raw_importance <- importance(rf_model_descriptive, type = 1, scale = FALSE)
sorted_importance <- sort(raw_importance[,1], decreasing = TRUE)
ranked_features <- names(sorted_importance) # Getting the full list of features, ranked

cat("All features have been ranked by importance.\n")


# TESTING ALL POSSIBLE SUBSET SIZES IN REGRESSION CASE

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
subset_sizes_to_test <- 1:length(ranked_features) 
results_by_size <- data.frame(num_features = integer(), rmse = double())

for (n in subset_sizes_to_test) {
  cat("  Testing model with Top", n, "features...\n")
  
  top_n_features <- head(ranked_features, n)
  
  data_subset <- data_C[, c("G3", top_n_features)]
  
  mean_rmse <- mean(replicate(20, run_rf_regression_cv(data_subset)))
  
  results_by_size <- rbind(results_by_size, data.frame(num_features = n, rmse = mean_rmse))
}


# DISPLAYING FINAL RESULTS
cat("\n\n--- Final Results ---\n")
print(results_by_size)

# Finding and reporting the best number of features
best_result <- results_by_size[which.min(results_by_size$rmse), ]
cat("\nOptimal number of features found:", best_result$num_features, "\n")
cat("Best RMSE achieved:", best_result$rmse, "\n")
cat("Compare to the original All-Features model (Paper): 3.90\n")


# Plotting the results to visualize the performance curve
plot(results_by_size$num_features, results_by_size$rmse, 
     type = "b", 
     xlab = "Number of Top Features Used", 
     ylab = "Cross-Validated RMSE",
     main = "Finding the Optimal Number of Features")

top_features <- head(ranked_features, best_result$num_features)
print(top_features)


# EVALUATING THE SVM MODEL USING THE OPTIMAL FEATURE SET 
library(rminer)

optimal_n <- best_result$num_features
top_optimal_features <- head(ranked_features, optimal_n)

cat("\nUsing the optimal set of", optimal_n, "features to test the SVM model.\n")
print(top_optimal_features)

data_C_imp <- data_C[, c("G3", top_optimal_features)]

cat("\nImproved dataset for Setup C has been created.\n")


# Running the final evaluation for the SVM model 
K_fold <- c("kfold", 10, 20)

cat("\nRunning 20-run CV on the Improved SVM Model... (This may take some time)\n")
SVM_C_imp <- mining(G3 ~ ., data=data_C_imp, model="svm", Runs=20, method=K_fold)
RMSE_C_imp <- mmetric(SVM_C_imp, metric="RMSE")


# DISPLAYING FINAL RESULTS & COMPARISON 
cat("\n\n--- Final SVM Analysis Complete ---\n")
cat("Comparison for Mathematics, SVM, Setup C:\n")
cat("  - Original SVM (Paper's Result): 4.37\n")
cat("  - Improved SVM (Top 9 Features):", mean(RMSE_C_imp[,1]), "\n")