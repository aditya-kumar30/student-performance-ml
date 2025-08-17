# 5-Level Classification

# REPLICATION CODE FOR NAIVE (NV) PREDICTOR 

#MATHEMATICS

data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels according to the Erasmus Scale
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the 5-level target variable from the final grade G3
data$grade_level_true <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

cat("Mathematics dataset loaded and 5-level target created.\n")


# Creating the Naive Vector and Calculating the PCC

# Setup A: Prediction is the 5-level version of the second period grade (G2)
# The rule: convert G2 into the 5-level system and use it as the prediction. [cite: 205]
predictions_A <- cut(data$G2, breaks = grade_breaks, labels = grade_labels)
PCC_A <- mean(data$grade_level_true == predictions_A, na.rm = TRUE) * 100


# Setup B: Prediction is the 5-level version of the first period grade (G1)
# The rule: convert G1 into the 5-level system and use it as the prediction. [cite: 206]
predictions_B <- cut(data$G1, breaks = grade_breaks, labels = grade_labels)
PCC_B <- mean(data$grade_level_true == predictions_B, na.rm = TRUE) * 100


# Setup C: Prediction is the most common class in the dataset
# The rule: find the most frequent class and use it for all predictions. [cite: 207]
most_common_class <- names(which.max(table(data$grade_level_true)))

# Creating the prediction factor, giving it the same levels as the true factor.
predictions_C <- factor(rep(most_common_class, nrow(data)), levels = levels(data$grade_level_true))
PCC_C <- mean(data$grade_level_true == predictions_C) * 100


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Mathematics, NV):\n")
cat("Setup A -> Paper: 78.5 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 60.5 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 32.9 | Replicated:", PCC_C, "\n")

#PORTUGUESE

data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels 
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the 5-level target variable from the final grade
data$grade_level_true <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

cat("Portuguese dataset loaded and 5-level target created.\n")


# Creating the Naive Vector and Calculating the PCC

# Setup A: Prediction is the 5-level version of the second period grade (G2) 
predictions_A <- cut(data$G2, breaks = grade_breaks, labels = grade_labels)
PCC_A <- mean(data$grade_level_true == predictions_A, na.rm = TRUE) * 100


# Setup B: Prediction is the 5-level version of the first period grade (G1)
predictions_B <- cut(data$G1, breaks = grade_breaks, labels = grade_labels)
PCC_B <- mean(data$grade_level_true == predictions_B, na.rm = TRUE) * 100


# Setup C: Prediction is the most common class in the dataset 
most_common_class <- names(which.max(table(data$grade_level_true)))

# Create the prediction factor, explicitly giving it the same levels as the true value factor.
predictions_C <- factor(rep(most_common_class, nrow(data)), levels = levels(data$grade_level_true))
PCC_C <- mean(data$grade_level_true == predictions_C) * 100


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Portuguese, NV):\n")
cat("Setup A -> Paper: 72.9 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 58.7 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 31.0 | Replicated:", PCC_C, "\n")

# SUPPORT VECTOR MACHINE REPLICATION CODE 

#MATHEMATICS

#Calling rminer and setting seed
library(rminer)
set.seed(123)

data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the new 5-level target variable
data$grade_level <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

# Remove the original G3 grade 
data$G3 <- NULL

cat("Mathematics dataset loaded and 5-level target created.\n")


# RUNNING ANALYSIS

# Defining the validation method 
K_fold <- c("kfold", 10, 20)

# Setup A: All variables
cat("\nRunning SVM 5-Level Classification for Setup A...\n")
SVM_A <- mining(grade_level ~ ., data=data, model="svm", Runs=20, method=K_fold)
ACC_A <- mmetric(SVM_A, metric="ACC")

# Setup B: G2 is excluded
cat("Running SVM 5-Level Classification for Setup B...\n")
SVM_B <- mining(grade_level ~ . - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_B <- mmetric(SVM_B, metric="ACC")

# Setup C: G1 and G2 are excluded 
cat("Running SVM 5-Level Classification for Setup C...\n")
SVM_C <- mining(grade_level ~ . - G1 - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_C <- mmetric(SVM_C, metric="ACC")


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Mathematics, SVM):\n")
# The reference values below are updated for the 5-Level SVM results from the paper.
cat("Setup A -> Paper: 59.6 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 47.9 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 31.0 | Replicated:", mean(ACC_C[,1]), "\n")


#PORTUGUESE


# Calling rminer and setting seed 
library(rminer)
set.seed(123)


data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the new 5-level target variable
data$grade_level <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

# Removing the original G3 grade from the dataset
data$G3 <- NULL

cat("Portuguese dataset loaded and 5-level target created.\n")


# RUNNING ANALYSIS
# Defining the validation method 
K_fold <- c("kfold", 10, 20)

# Setup A: All variables
cat("\nRunning SVM 5-Level Classification for Setup A...\n")
SVM_A <- mining(grade_level ~ ., data=data, model="svm", Runs=20, method=K_fold)
ACC_A <- mmetric(SVM_A, metric="ACC")

# Setup B: G2 is excluded
cat("Running SVM 5-Level Classification for Setup B...\n")
SVM_B <- mining(grade_level ~ . - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_B <- mmetric(SVM_B, metric="ACC")

# Setup C: G1 and G2 are excluded
cat("Running SVM 5-Level Classification for Setup C...\n")
SVM_C <- mining(grade_level ~ . - G1 - G2, data=data, model="svm", Runs=20, method=K_fold)
ACC_C <- mmetric(SVM_C, metric="ACC")


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Portuguese, SVM):\n")
# The reference values below are updated for the 5-Level SVM results from the paper.
cat("Setup A -> Paper: 64.5 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 51.7 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 34.9 | Replicated:", mean(ACC_C[,1]), "\n")


# DECISION TREE REPLICATION CODE 

#MATHEMATICS

# Calling rminer and setting seed
library(rminer)
set.seed(123)


data <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the new 5-level target variable
data$grade_level <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

# Removing the original G3 grade from the dataset
data$G3 <- NULL

cat("Mathematics dataset loaded and 5-level target created.\n")


# RUNNING ANALYSIS
# Defining the validation method 
K_fold <- c("kfold", 10, 20)

# Setup A: All variables 
cat("\nRunning Decision Tree 5-Level Classification for Setup A...\n")
# The model is now "dt" for Decision Tree
DT_A <- mining(grade_level ~ ., data=data, model="dt", Runs=20, method=K_fold)
ACC_A <- mmetric(DT_A, metric="ACC")

# Setup B: G2 is excluded
cat("Running Decision Tree 5-Level Classification for Setup B...\n")
DT_B <- mining(grade_level ~ . - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_B <- mmetric(DT_B, metric="ACC")

# Setup C: G1 and G2 are excluded
cat("Running Decision Tree 5-Level Classification for Setup C...\n")
DT_C <- mining(grade_level ~ . - G1 - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_C <- mmetric(DT_C, metric="ACC")


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Mathematics, DT):\n")
# The reference values below are updated for the 5-Level DT results from the paper.
cat("Setup A -> Paper: 76.7 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 57.5 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 31.5 | Replicated:", mean(ACC_C[,1]), "\n")


# PORTUGUESE

# Calling rminer
library(rminer)
set.seed(123)

data <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the 5-level target variable 
data$grade_level <- cut(data$G3, breaks = grade_breaks, labels = grade_labels)

# Removing the original G3 grade 
data$G3 <- NULL

cat("Portuguese dataset loaded and 5-level target created.\n")


# RUNNING ANALYSIS 

# Defining the validation method 
K_fold <- c("kfold", 10, 20)

# Setup A: All variables 
cat("\nRunning Decision Tree 5-Level Classification for Setup A...\n")
# The model is "dt" for Decision Tree
DT_A <- mining(grade_level ~ ., data=data, model="dt", Runs=20, method=K_fold)
ACC_A <- mmetric(DT_A, metric="ACC")

# Setup B: G2 is excluded
cat("Running Decision Tree 5-Level Classification for Setup B...\n")
DT_B <- mining(grade_level ~ . - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_B <- mmetric(DT_B, metric="ACC")

# Setup C: G1 and G2 are excluded
cat("Running Decision Tree 5-Level Classification for Setup C...\n")
DT_C <- mining(grade_level ~ . - G1 - G2, data=data, model="dt", Runs=20, method=K_fold)
ACC_C <- mmetric(DT_C, metric="ACC")


# FINAL RESULTS
cat("\n Replication Complete \n")
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Portuguese, DT):\n")
# The reference values below are updated for the 5-Level DT results from the paper.
cat("Setup A -> Paper: 76.1 | Replicated:", mean(ACC_A[,1]), "\n")
cat("Setup B -> Paper: 62.9 | Replicated:", mean(ACC_B[,1]), "\n")
cat("Setup C -> Paper: 32.8 | Replicated:", mean(ACC_C[,1]), "\n")


# RANDOM FOREST REPLICATION CODE 

#MATHEMATICS

#Calling randomforest package
# install.packages("randomForest") if required
library(randomForest)
set.seed(123)

data_orig <- read.table("student-mat.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels according to Erasmus Convention
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the 5-level target variable
data_orig$grade_level <- cut(data_orig$G3, breaks = grade_breaks, labels = grade_labels)

# Removing the original G3 grade
data_orig$G3 <- NULL

cat("Mathematics dataset loaded and 5-level target created.\n")


# Creating the data for each setup 
data_A <- data_orig
data_B <- subset(data_orig, select = -G2)
data_C <- subset(data_orig, select = -c(G1, G2))

# Function to run a single run of 10-fold cross-validation
run_single_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  
  # Initializing a data frame to store predictions with correct levels
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
  
  # Calculating and returning the overall accuracy for this single run
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
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Mathematics, RF):\n")
cat("Setup A -> Paper: 72.4 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 52.7 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 33.5 | Replicated:", PCC_C, "\n")


#PORTUGUESE

# Setting up the needed library, randomforest

library(randomForest)
set.seed(123)

data_orig <- read.table("student-por.csv", sep=";", header=T, stringsAsFactors = TRUE)

# Defining the grade boundaries and labels 
grade_breaks <- c(-1, 9, 11, 13, 15, 20)
grade_labels <- c("V (fail)", "IV (sufficient)", "III (satisfactory)", "II (good)", "I (excellent)")

# Creating the 5-level target variable
data_orig$grade_level <- cut(data_orig$G3, breaks = grade_breaks, labels = grade_labels)

# Removing the original G3 grade
data_orig$G3 <- NULL

cat("Portuguese dataset loaded and 5-level target created.\n")


# Creating the data for each setup
data_A <- data_orig
data_B <- subset(data_orig, select = -G2)
data_C <- subset(data_orig, select = -c(G1, G2))

# Function to run a single run of 10-fold CV
run_single_cv <- function(dataset) {
  K <- 10 # Number of folds
  folds <- sample(1:K, nrow(dataset), replace = TRUE)
  
  # Initializing the data frame to store predictions
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
  
  # Calculating and returning the overall accuracy for this single run
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
cat("Comparison of replicated PCC (%) with Paper's Table 4 (Portuguese, RF):\n")
cat("Setup A -> Paper: 73.5 | Replicated:", PCC_A, "\n")
cat("Setup B -> Paper: 55.3 | Replicated:", PCC_B, "\n")
cat("Setup C -> Paper: 36.7 | Replicated:", PCC_C, "\n")