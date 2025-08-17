**Predicting Student Performance: A Replication and Extension** 
This project is a comprehensive replication and extension of the 2008 paper by P. Cortez and A. Silva, "Using Data Mining to Predict Secondary School Student Performance." The analysis was conducted in R and is divided into two main phases: a faithful replication of the original study's results and an extension that implements a systematic feature selection process to build simpler, more powerful predictive models.

**Key Findings & Improvements**
Our extension work, which focused on the most challenging real-world scenario (Setup C, where no prior grades are available), yielded significant improvements:

Identified Core Predictors: Through a Random Forest-based feature ranking, we identified an optimal subset of 9 core predictors for the Mathematics dataset and 23 for the Portuguese dataset.

Improved Model Performance: By training models on these refined feature sets, we consistently achieved better performance. The most notable result was a 5.1% increase in accuracy for the SVM classifier on the 5-level Portuguese classification task.

Enhanced Model Simplicity & Interpretability: For the Mathematics dataset, our final model achieved comparable performance to the original using 70% fewer features (9 vs. 30+), resulting in a much simpler and more interpretable model.

Solved the Precision Problem: Our feature selection process significantly increased the precision of the Random Forest model on the binary classification task, creating a more reliable and confident predictor.

📊 Data
The two datasets used in this analysis (student-mat.csv and student-por.csv) were sourced from the UCI Machine Learning Repository. They contain student grades, demographic, social, and school-related features.

Link to the dataset at UCI Repository

📂 Repository Structure
.
├── 📄 Final_Report.pdf
├── 📄 README.md
├── 📁 code
│   ├── 📄 Replication Regression.R
│   ├── 📄 Replication Binary Classification.R
│   ├── 📄 Replication 5-level Classification.R
│   ├── 📄 Improvement Regression and Variable selection - Mathematics.R
│   ├── 📄 Improvement Regression and Variable selection - Portuguese.R
│   ├── 📄 Improvement Binary Classification - Mathematics.R
│   ├── 📄 Improvement Binary Classification - Portuguese.R
│   ├── 📄 Improvement 5 Level Classficiation - Mathematics.R
│   └── 📄 Improvement 5 Level Classification - Portuguese.R
└── 📁 data
    ├── 📄 student-mat.csv
    └── 📄 student-por.csv

🛠️ How to Run the Code
Prerequisites
R: You must have a recent version of R installed.

R Packages: You need to install the following packages. You can do so by running this command in your R console:

install.packages(c("randomForest", "rminer"))

Execution Order
The scripts are numbered implicitly by their purpose. It is recommended to run them in the following logical order:

Replication Scripts:

Replication Regression.R

Replication Binary Classification.R

Replication 5-level Classification.R
These scripts will reproduce the baseline results from the original paper.

Feature Selection Scripts:

Improvement Regression and Variable selection - Mathematics.R

Improvement Regression and Variable selection - Portuguese.R
These scripts perform the core feature ranking and search to find the optimal number of predictors for each dataset.

Improved Model Scripts:

Improvement Binary Classification - Mathematics.R / ... - Portuguese.R

Improvement 5 Level Classficiation - Mathematics.R / ... - Portuguese.R
These scripts take the optimal feature sets found in the previous step and evaluate the final, improved models.

Note: Ensure that the student-mat.csv and student-por.csv files from the /data directory are in your R working directory when you run the scripts.

📜 Citation
This work is based on the following paper:

P. Cortez and A. Silva. "Using Data Mining to Predict Secondary School Student Performance." In Proceedings of 5th Annual Future Business Technology Conference, pp. 5-12, Porto, Portugal, April, 2008.
