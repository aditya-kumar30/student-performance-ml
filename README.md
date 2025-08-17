# Predicting Student Performance: A Replication and Extension  

This project is a comprehensive **replication and extension** of the 2008 paper by **P. Cortez and A. Silva**, *"Using Data Mining to Predict Secondary School Student Performance."*  

The analysis was conducted in **R** and is divided into two main phases:  
1. A faithful replication of the original study's results.  
2. An extension that implements a systematic **feature selection process** to build simpler, more powerful predictive models.  

---

## Key Findings & Improvements  

The extension work, which focused on the most challenging real-world scenario (*Setup C*, where no prior grades are available), yielded significant improvements:  

- **Identified Core Predictors:** Using Random Forest-based feature ranking, we identified an optimal subset of **9 core predictors** for the Mathematics dataset and **23 for the Portuguese dataset**.  
- **Improved Model Performance:** Models trained on these refined feature sets consistently performed better, including a **5.1% increase in accuracy** for the SVM classifier on the 5-level Portuguese classification task.  
- **Enhanced Simplicity & Interpretability:** For Mathematics, the final model achieved comparable results with **70% fewer features** (9 vs. 30+), making it simpler and easier to interpret.  
- **Solved the Precision Problem:** The feature selection process significantly improved **Random Forest precision** on the binary classification task, producing a more reliable predictor.  

---

## Data  

The two datasets used in this analysis (**student-mat.csv** and **student-por.csv**) were sourced from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/student+performance).  

They contain student grades, demographic, social, and school-related features.  

---

## 📂 Repository Structure  
--> [Replication - Binary](./code/Replication%20Binary%20Classification.R)



---

## 🛠️ How to Run the Code  

### Prerequisites  
- **R**: Install a recent version (≥ 4.x).  
- **R Packages**: Install dependencies by running:

  ```R
  install.packages(c("randomForest", "rminer"))


Execution Order
Replication Scripts

Replication Regression.R

Replication Binary Classification.R

Replication 5-level Classification.R

These reproduce the baseline results from the original paper.

Feature Selection Scripts

Improvement Regression and Variable selection - Mathematics.R

Improvement Regression and Variable selection - Portuguese.R

Perform Random Forest-based feature ranking and search for optimal predictors.

Improved Model Scripts

Improvement Binary Classification - Mathematics.R / ...Portuguese.R

Improvement 5 Level Classification - Mathematics.R / ...Portuguese.R

Evaluate improved models using the optimal feature sets.

⚠️ Note: Ensure that student-mat.csv and student-por.csv (from /data) are in your R working directory when running the scripts.


