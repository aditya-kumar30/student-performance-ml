# Regression ##

# NAIVE VECTOR

#MATHEMATICS

cat(" Running Analysis for Mathematics Dataset \n")
data_mat <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# The true value is G3
true_grades_mat <- data_mat$G3

# Setup A 
predictions_A_mat <- data_mat$G2
RMSE_A_mat <- sqrt(mean((true_grades_mat - predictions_A_mat)^2)) # Direct calculation

# Setup B 
predictions_B_mat <- data_mat$G1
RMSE_B_mat <- sqrt(mean((true_grades_mat - predictions_B_mat)^2)) # Direct calculation

# Setup C
predictions_C_mat <- mean(data_mat$G3)
RMSE_C_mat <- sqrt(mean((true_grades_mat - predictions_C_mat)^2)) # Direct calculation

#PORTUGUESE

cat("\n Running Analysis for Portuguese Dataset \n")
data_por <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# The true value is G3
true_grades_por <- data_por$G3

# Setup A
predictions_A_por <- data_por$G2
RMSE_A_por <- sqrt(mean((true_grades_por - predictions_A_por)^2)) # Direct calculation

# Setup B 
predictions_B_por <- data_por$G1
RMSE_B_por <- sqrt(mean((true_grades_por - predictions_B_por)^2)) # Direct calculation

# Setup C 
predictions_C_por <- mean(data_por$G3)
RMSE_C_por <- sqrt(mean((true_grades_por - predictions_C_por)^2)) # Direct calculation


# FINAL RESULTS 
cat("\n\n Replication Complete \n")
cat("Comparison of replicated RMSE with Paper's Table 5 (Mathematics, NV):\n")
cat("Setup A -> Paper: 2.01 | Replicated:", RMSE_A_mat, "\n")
cat("Setup B -> Paper: 2.80 | Replicated:", RMSE_B_mat, "\n")
cat("Setup C -> Paper: 4.59 | Replicated:", RMSE_C_mat, "\n")

cat("\nComparison of replicated RMSE with Paper's Table 5 (Portuguese, NV):\n")
cat("Setup A -> Paper: 1.32 | Replicated:", RMSE_A_por, "\n")
cat("Setup B -> Paper: 1.89 | Replicated:", RMSE_B_por, "\n")
cat("Setup C -> Paper: 3.23 | Replicated:", RMSE_C_por, "\n")


#SUPPORT VECTOR MACHINES

# Calling rminer and setting seed
library(rminer)
set.seed(123)

#MATHEMATICS
cat(" Running Analysis for Mathematics Dataset \n")
data_mat <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the validation method
K_fold <- c("kfold", 10, 20)

# Setup A
cat("Running SVM Regression for Setup A...\n")
SVM_A_mat <- mining(G3 ~ ., data=data_mat, model="svm", Runs=20, method=K_fold)
RMSE_A_mat <- mmetric(SVM_A_mat, metric="RMSE")

# Setup B
cat("Running SVM Regression for Setup B...\n")
SVM_B_mat <- mining(G3 ~ . - G2, data=data_mat, model="svm", Runs=20, method=K_fold)
RMSE_B_mat <- mmetric(SVM_B_mat, metric="RMSE")

# Setup C 
cat("Running SVM Regression for Setup C...\n")
SVM_C_mat <- mining(G3 ~ . - G1 - G2, data=data_mat, model="svm", Runs=20, method=K_fold)
RMSE_C_mat <- mmetric(SVM_C_mat, metric="RMSE")


#PORTUGUESE

cat("\n Running Analysis for Portuguese Dataset \n")
data_por <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Setup A 
cat("Running SVM Regression for Setup A...\n")
SVM_A_por <- mining(G3 ~ ., data=data_por, model="svm", Runs=20, method=K_fold)
RMSE_A_por <- mmetric(SVM_A_por, metric="RMSE")

# Setup B 
cat("Running SVM Regression for Setup B...\n")
SVM_B_por <- mining(G3 ~ . - G2, data=data_por, model="svm", Runs=20, method=K_fold)
RMSE_B_por <- mmetric(SVM_B_por, metric="RMSE")

# Setup C 
cat("Running SVM Regression for Setup C...\n")
SVM_C_por <- mining(G3 ~ . - G1 - G2, data=data_por, model="svm", Runs=20, method=K_fold)
RMSE_C_por <- mmetric(SVM_C_por, metric="RMSE")


# FINAL RESULTS
cat("\n\n Replication Complete \n")
cat("Comparison of replicated RMSE with Paper's Table 5 (Mathematics, SVM):\n")
cat("Setup A -> Paper: 2.09 | Replicated:", mean(RMSE_A_mat[,1]), "\n")
cat("Setup B -> Paper: 2.90 | Replicated:", mean(RMSE_B_mat[,1]), "\n")
cat("Setup C -> Paper: 4.37 | Replicated:", mean(RMSE_C_mat[,1]), "\n")

cat("\nComparison of replicated RMSE with Paper's Table 5 (Portuguese, SVM):\n")
cat("Setup A -> Paper: 1.35 | Replicated:", mean(RMSE_A_por[,1]), "\n") ##need to mention why we are off
cat("Setup B -> Paper: 1.87 | Replicated:", mean(RMSE_B_por[,1]), "\n")
cat("Setup C -> Paper: 2.76 | Replicated:", mean(RMSE_C_por[,1]), "\n")


# DECISION TREE

#Calling rminer
library(rminer)
set.seed(123)


#MATHEMATICS

cat(" Running Analysis for Mathematics Dataset \n")
data_mat <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the validation method
K_fold <- c("kfold", 10, 20)

# Setup A 
cat("Running Decision Tree Regression for Setup A...\n")
DT_A_mat <- mining(G3 ~ ., data=data_mat, model="dt", Runs=20, method=K_fold)
RMSE_A_mat <- mmetric(DT_A_mat, metric="RMSE")

# Setup B 
cat("Running Decision Tree Regression for Setup B...\n")
DT_B_mat <- mining(G3 ~ . - G2, data=data_mat, model="dt", Runs=20, method=K_fold)
RMSE_B_mat <- mmetric(DT_B_mat, metric="RMSE")

# Setup C 
cat("Running Decision Tree Regression for Setup C...\n")
DT_C_mat <- mining(G3 ~ . - G1 - G2, data=data_mat, model="dt", Runs=20, method=K_fold)
RMSE_C_mat <- mmetric(DT_C_mat, metric="RMSE")


# PORTUGUESE

cat("\n Running Analysis for Portuguese Dataset \n")
data_por <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Setup A
cat("Running Decision Tree Regression for Setup A...\n")
DT_A_por <- mining(G3 ~ ., data=data_por, model="dt", Runs=20, method=K_fold)
RMSE_A_por <- mmetric(DT_A_por, metric="RMSE")

# Setup B
cat("Running Decision Tree Regression for Setup B...\n")
DT_B_por <- mining(G3 ~ . - G2, data=data_por, model="dt", Runs=20, method=K_fold)
RMSE_B_por <- mmetric(DT_B_por, metric="RMSE")

# Setup C 
cat("Running Decision Tree Regression for Setup C...\n")
DT_C_por <- mining(G3 ~ . - G1 - G2, data=data_por, model="dt", Runs=20, method=K_fold)
RMSE_C_por <- mmetric(DT_C_por, metric="RMSE")


# FINAL RESULTS 
cat("\n\n Replication Complete \n")
cat("Comparison of replicated RMSE with Paper's Table 5 (Mathematics, DT):\n")
cat("Setup A -> Paper: 1.94 | Replicated:", mean(RMSE_A_mat[,1]), "\n")
cat("Setup B -> Paper: 2.67 | Replicated:", mean(RMSE_B_mat[,1]), "\n")
cat("Setup C -> Paper: 4.46 | Replicated:", mean(RMSE_C_mat[,1]), "\n")

cat("\nComparison of replicated RMSE with Paper's Table 5 (Portuguese, DT):\n")
cat("Setup A -> Paper: 1.46 | Replicated:", mean(RMSE_A_por[,1]), "\n")
cat("Setup B -> Paper: 1.78 | Replicated:", mean(RMSE_B_por[,1]), "\n")
cat("Setup C -> Paper: 2.93 | Replicated:", mean(RMSE_C_por[,1]), "\n")


# REGRESSION

# install.packages("randomForest") 
# Calling randomforest
library(randomForest)
set.seed(123)

# Defining CV for Regression
# Performing a single run of 10-fold CV 
run_rf_regression_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  
  # Initializing a data frame to store the predictions
  predictions_df <- data.frame(
    true_value = dataset$G3,
    predicted_value = NA_real_ # Use NA_real_ for numeric columns
  )
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    
    # Training a regression forest (target G3)
    rf_model <- randomForest(G3 ~ ., data = train_data, ntree = 500)
    fold_predictions <- predict(rf_model, newdata = test_data)
    predictions_df$predicted_value[test_indices] <- fold_predictions
  }
  
  # Calculating and returning the RMSE
  rmse <- sqrt(mean((predictions_df$true_value - predictions_df$predicted_value)^2, na.rm = TRUE))
  return(rmse)
}

#MATHEMATICS

cat(" Running Analysis for Mathematics Dataset \n")
data_mat_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating data subsets for each setup
data_mat_A <- data_mat_orig
data_mat_B <- subset(data_mat_orig, select = -G2)
data_mat_C <- subset(data_mat_orig, select = -c(G1, G2))

# Running the 20 replications for each setup
cat("Running 20 replications for Setup A... (This may take some time)\n")
results_A_mat <- replicate(20, run_rf_regression_cv(data_mat_A))
RMSE_A_mat <- mean(results_A_mat)

cat("Running 20 replications for Setup B... (This may take some time)\n")
results_B_mat <- replicate(20, run_rf_regression_cv(data_mat_B))
RMSE_B_mat <- mean(results_B_mat)

cat("Running 20 replications for Setup C... (This may take some time)\n")
results_C_mat <- replicate(20, run_rf_regression_cv(data_mat_C))
RMSE_C_mat <- mean(results_C_mat)

#PORTUGUESE

cat("\n Running Analysis for Portuguese Dataset \n")
data_por_orig <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the data subsets for each setup
data_por_A <- data_por_orig
data_por_B <- subset(data_por_orig, select = -G2)
data_por_C <- subset(data_por_orig, select = -c(G1, G2))

# Running the 20 replications for each setup
cat("Running 20 replications for Setup A... (This may take some time)\n")
results_A_por <- replicate(20, run_rf_regression_cv(data_por_A))
RMSE_A_por <- mean(results_A_por)

cat("Running 20 replications for Setup B... (This may take some time)\n")
results_B_por <- replicate(20, run_rf_regression_cv(data_por_B))
RMSE_B_por <- mean(results_B_por)

cat("Running 20 replications for Setup C... (This may take some time)\n")
results_C_por <- replicate(20, run_rf_regression_cv(data_por_C))
RMSE_C_por <- mean(results_C_por)


# FINAL RESULTS
cat("\n\n Replication Complete \n")
cat("Comparison of replicated RMSE with Paper's Table 5 (Mathematics, RF):\n")
cat("Setup A -> Paper: 1.75 | Replicated:", RMSE_A_mat, "\n")
cat("Setup B -> Paper: 2.46 | Replicated:", RMSE_B_mat, "\n")
cat("Setup C -> Paper: 3.90 | Replicated:", RMSE_C_mat, "\n")

cat("\nComparison of replicated RMSE with Paper's Table 5 (Portuguese, RF):\n")
cat("Setup A -> Paper: 1.32 | Replicated:", RMSE_A_por, "\n")
cat("Setup B -> Paper: 1.79 | Replicated:", RMSE_B_por, "\n")
cat("Setup C -> Paper: 2.67 | Replicated:", RMSE_C_por, "\n")
