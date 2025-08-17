# REPLICATION CODE FOR NAIVE (NV) PREDICTOR IN BINARY
# rminer is not used for this 

##MATHEMATICS

# Loading the data set and creating the binary target variable 
data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail_true <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

cat("Mathematics dataset loaded and bnary target created.\n")


# Finding the Naive Vector and Calculating PCC 

#  Setup A: Prediction is based on the second period grade (G2) 
predictions_A <- as.factor(ifelse(data$G2 >= 10, "pass", "fail"))
PCC_A <- mean(data$pass_fail_true == predictions_A) * 100


# Setup B: Prediction is based on the first period grade (G1)
predictions_B <- as.factor(ifelse(data$G1 >= 10, "pass", "fail"))
PCC_B <- mean(data$pass_fail_true == predictions_B) * 100


# Setup C: Prediction is the most common class in the dataset 
most_common_class <- names(which.max(table(data$pass_fail_true)))

# Creating the prediction factor,  giving it the same levels as the true value
predictions_C <- factor(rep(most_common_class, nrow(data)), levels = levels(data$pass_fail_true))
PCC_C <- mean(data$pass_fail_true == predictions_C) * 100


# FINAL RESULTS 
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Mathematics, NV):\n")
cat("Setup A -> Paper: 91.9 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 83.8 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 67.1 | Replicated:", PCC_C, "\n")

##PORTUGUESE

# Loading the data set and creating the binary target variable 

data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail_true <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

cat("Portuguese dataset loaded and binary target created.\n")


# Finding the Naive Vector and Calculating PCC 

# Setup A: Prediction is based on the second period grade (G2)
predictions_A <- as.factor(ifelse(data$G2 >= 10, "pass", "fail"))
PCC_A <- mean(data$pass_fail_true == predictions_A) * 100


# Setup B: Prediction is based on the first period grade (G1)
predictions_B <- as.factor(ifelse(data$G1 >= 10, "pass", "fail"))
PCC_B <- mean(data$pass_fail_true == predictions_B) * 100


# Setup C: Prediction is the most common class in the dataset 
most_common_class <- names(which.max(table(data$pass_fail_true)))

# Creating the prediction factor,  giving it the same levels as the true value
predictions_C <- factor(rep(most_common_class, nrow(data)), levels = levels(data$pass_fail_true))
PCC_C <- mean(data$pass_fail_true == predictions_C) * 100


#  FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Portuguese, NV):\n")
cat("Setup A -> Paper: 89.7 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 87.5 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 84.6 | Replicated:", PCC_C, "\n")

##################################################################################################

# SUPPOT VECTOR MACHINE REPLICATION CODE 
#MATHEMATICS DATASET 

# Calling rminer library and setting seed
library(rminer)
set.seed(123)


# Loading the data set and creating the binary target variable 

data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

# Removing the original G3 grade 
data$G3 <- NULL

cat("Mathematics dataset loaded and binary target created.\n")


#  RUNNING ANALYSIS 
K_fold <- c("kfold", 10, 20)

# Setup A: All variables 
cat("\nRunning SVM Classification for Setup A...\n")
SVM_A <- mining(pass_fail ~ ., data=data, model="svm", Runs=20, method=K_fold)
ACC_A <- mmetric(SVM_A, metric="ACC")

#  Setup B: G2 is excluded 
cat("Running SVM Classification for Setup B...\n")
SVM_B <- mining(pass_fail ~ . - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_B <- mmetric(SVM_B, metric="ACC")

#  Setup C: G1 and G2 are excluded 
cat("Running SVM Classification for Setup C...\n")
SVM_C <- mining(pass_fail ~ . - G1 - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_C <- mmetric(SVM_C, metric="ACC")


#   FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Mathematics, SVM):\n")
# mmetric's "ACC" is a decimal, so we multiply by 100 to get the PCC value.
cat("Setup A -> Paper: 86.3 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 80.5 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 70.6 | Replicated:", mean(ACC_C[,1]), "\n")

#PORTUGUESE DATASET

# Calling rminer library and setting seed
library(rminer)
set.seed(123)


# Loading the data set and creating the binary target variable 

data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

# Removing the original G3 grade 
data$G3 <- NULL

cat("Portuguese dataset loaded and binary target created.\n")


# RUNNING ANALYSIS
K_fold <- c("kfold", 10, 20)

# Setup A: All variables
cat("\nRunning SVM Classification for Setup A...\n")
SVM_A <- mining(pass_fail ~ ., data=data, model="svm", Runs=20, method=K_fold)
ACC_A <- mmetric(SVM_A, metric="ACC")

# Setup B: G2 is excluded
cat("Running SVM Classification for Setup B...\n")
SVM_B <- mining(pass_fail ~ . - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_B <- mmetric(SVM_B, metric="ACC")

# Setup C: G1 and G2 are excluded
cat("Running SVM Classification for Setup C...\n")
SVM_C <- mining(pass_fail ~ . - G1 - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_C <- mmetric(SVM_C, metric="ACC")


# FINAL RESULTS 
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Portuguese, SVM):\n")
# mmetric's "ACC" is a decimal, so we multiply by 100 to get the PCC value.
cat("Setup A -> Paper: 91.4 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 88.0 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 84.8 | Replicated:", mean(ACC_C[,1]), "\n")

##########################################################################################

# DECISION TREE REPLICATION CODE FOR BINARY CLASSIFICATION
#MATHEMATICS

# Calling rminer library and setting seed
library(rminer)
set.seed(123)


# Loading the data set and creating the binary target variable 

data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

# Removing the original G3 grade 
data$G3 <- NULL

cat("Mathematics dataset loaded and binary target created.\n")


# RUNNING ANALYSIS
# [cite_start]Define the validation method as described in the paper [cite: 200]
K_fold <- c("kfold", 10, 20)

# Setup A: All variables
cat("\nRunning Decision Tree Classification for Setup A...\n")
# The model is now "dt" for Decision Tree
DT_A <- mining(pass_fail ~ ., data=data, model="dt", Runs=20, method=K_fold)
ACC_A <- mmetric(DT_A, metric="ACC")

# Setup B: G2 is excluded 
cat("Running Decision Tree Classification for Setup B...\n")
DT_B <- mining(pass_fail ~ . - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_B <- mmetric(DT_B, metric="ACC")

# Setup C: G1 and G2 are excluded
cat("Running Decision Tree Classification for Setup C...\n")
DT_C <- mining(pass_fail ~ . - G1 - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_C <- mmetric(DT_C, metric="ACC")


# FINAL RESULTS 
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Mathematics, DT):\n")
# The reference values below are updated for the Decision Tree results from the paper.
cat("Setup A -> Paper: 90.7 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 83.1 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 65.3 | Replicated:", mean(ACC_C[,1]), "\n")

# PORTUGUESE

# Calling rminer library and setting seed
library(rminer)
set.seed(123)


# Loading the data set and creating the binary target variable 

data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable from the final grade G3.
data$pass_fail <- as.factor(ifelse(data$G3 >= 10, "pass", "fail"))

# Removing the original G3 grade
data$G3 <- NULL

cat("Portuguese dataset loaded and binary target created.\n")


# RUNNING ANALYSIS
# Define the validation method: 20 runs of 10-fold cross-validation [cite: 200]
K_fold <- c("kfold", 10, 20)

# Setup A: All variables 
cat("\nRunning Decision Tree Classification for Setup A...\n")
# The model is "dt" for Decision Tree
DT_A <- mining(pass_fail ~ ., data=data, model="dt", Runs=20, method=K_fold)
ACC_A <- mmetric(DT_A, metric="ACC")

# Setup B: G2 is excluded 
cat("Running Decision Tree Classification for Setup B...\n")
DT_B <- mining(pass_fail ~ . - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_B <- mmetric(DT_B, metric="ACC")

# Setup C: G1 and G2 are excluded 
cat("Running Decision Tree Classification for Setup C...\n")
DT_C <- mining(pass_fail ~ . - G1 - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_C <- mmetric(DT_C, metric="ACC")


# FINAL RESULTS 
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Portuguese, DT):\n")
# The reference values below are updated for the Decision Tree results from the paper [cite: 224]
cat("Setup A -> Paper: 93.0 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 88.4 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 84.4 | Replicated:", mean(ACC_C[,1]), "\n")

#################################################################################################

# RANDOM FOREST REPLICATION CODE FOR BINARY CLASSIFICATION 

#MATHEMATICS

# Calling rminer library and setting seed
# install.packages("randomForest") # Run this once if needed
library(randomForest)
set.seed(123)


#Loading the dataset
data_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Creating the binary pass/fail target variable 
data_orig$pass_fail <- as.factor(ifelse(data_orig$G3 >= 10, "pass", "fail"))

# Removing the original G3 grade
data_orig$G3 <- NULL

cat("Mathematics dataset loaded and binary target created.\n")


# Creating data for each set up 
data_A <- data_orig
data_B <- subset(data_orig, select = -G2)
data_C <- subset(data_orig, select = -c(G1, G2))

# Performing a single run of 10-fold cross-validation
run_single_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  
  predictions_df <- data.frame(
    true_value = dataset$pass_fail,
    predicted_value = factor(rep(NA, nrow(dataset)), levels = levels(dataset$pass_fail))
  )
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    
    rf_model <- randomForest(pass_fail ~ ., data = train_data, ntree = 500)
    fold_predictions <- predict(rf_model, newdata = test_data)
    predictions_df$predicted_value[test_indices] <- fold_predictions
  }
  
  overall_accuracy <- mean(predictions_df$true_value == predictions_df$predicted_value, na.rm = TRUE)
  return(overall_accuracy * 100)
}


# RUNNING ALL 20-RUN ANALYSIS FOR EACH SETUP 

cat("\nRunning 20 replications for Setup A... (This may take some time)\n")
results_A <- replicate(20, run_single_cv(data_A))
PCC_A <- mean(results_A)

cat("Running 20 replications for Setup B... (This may take some time)\n")
results_B <- replicate(20, run_single_cv(data_B))
PCC_B <- mean(results_B)

cat("Running 20 replications for Setup C... (This may take some time)\n")
results_C <- replicate(20, run_single_cv(data_C))
PCC_C <- mean(results_C)


#  FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Mathematics, RF):\n")
# Reference values updated for the Mathematics RF model
cat("Setup A -> Paper: 91.2 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 83.0 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 70.5 | Replicated:", PCC_C, "\n")

# PORTUGUESE

# Calling rminer library and setting seed
library(randomForest)
set.seed(123)


#Loading the dataset and creating the binary pass/fail variable
data_orig <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)
data_orig$pass_fail <- as.factor(ifelse(data_orig$G3 >= 10, "pass", "fail"))
data_orig$G3 <- NULL
cat("Portuguese dataset loaded and binary target created.\n")


# Creating data for each setup 
data_A <- data_orig
data_B <- subset(data_orig, select = -G2)
data_C <- subset(data_orig, select = -c(G1, G2))

run_single_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  predictions_df <- data.frame(
    true_value = dataset$pass_fail,
    predicted_value = factor(rep(NA, nrow(dataset)), levels = levels(dataset$pass_fail))
  )
  
  for (i in 1:K) {
    test_indices <- which(folds == i)
    train_data <- dataset[-test_indices, ]
    test_data  <- dataset[test_indices, ]
    
    rf_model <- randomForest(pass_fail ~ ., data = train_data, ntree = 500)
    fold_predictions <- predict(rf_model, newdata = test_data)
    predictions_df$predicted_value[test_indices] <- fold_predictions
  }
  
  overall_accuracy <- mean(predictions_df$true_value == predictions_df$predicted_value, na.rm = TRUE)
  return(overall_accuracy * 100)
}


# RUNNING ALL 20-RUN ANALYSIS FOR EACH SETUP

cat("\nRunning 20 replications for Setup A... (This may take some time)\n")
results_A <- replicate(20, run_single_cv(data_A))
PCC_A <- mean(results_A)

cat("Running 20 replications for Setup B... (This may take some time)\n")
results_B <- replicate(20, run_single_cv(data_B))
PCC_B <- mean(results_B)

cat("Running 20 replications for Setup C... (This may take some time)\n")
results_C <- replicate(20, run_single_cv(data_C))
PCC_C <- mean(results_C)


# FINAL RESULTS 
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 3 (Portuguese, RF):\n")
cat("Setup A -> Paper: 92.6 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 90.1 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 85 | Replicated:", PCC_C, "\n")
