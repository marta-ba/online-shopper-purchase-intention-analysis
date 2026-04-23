# Online Shopper Purchase Intention Analysis

### Predicting e-commerce purchase behavior using R, EDA, and machine learning

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Classification-blue?style=for-the-badge)
![EDA](https://img.shields.io/badge/EDA-Behavior%20Analysis-orange?style=for-the-badge)
![Random Forest](https://img.shields.io/badge/Best%20Model-Random%20Forest-green?style=for-the-badge)
![Imbalanced Data](https://img.shields.io/badge/Class%20Imbalance-SMOTE-red?style=for-the-badge)

---

## Overview

This project analyzes online shopper behavior using session-level data from **12,330 user sessions** collected over a one-year period. The goal is to predict whether a visitor will complete a purchase based on a combination of numerical and categorical features.

The analysis combines **exploratory data analysis (EDA)**, **data preprocessing**, **class imbalance handling**, and **machine learning classification models** to identify the most effective approach for predicting purchase intention in real time.

---

## Business Problem

In e-commerce, identifying which visitors are more likely to convert is essential for:

- improving conversion rates
- personalizing marketing actions
- optimizing the customer journey
- targeting high-intent visitors more effectively

This project addresses that challenge by building predictive models that classify whether an online session will end in a purchase.

---

## Project Goal

Develop and compare machine learning models to predict whether an online shopping session will result in a purchase.

---

## Dataset

The dataset contains **12,330 sessions**, with each session belonging to a different user over a one-year period. This design helps reduce bias associated with:

- specific campaigns
- special shopping days
- user profiles
- seasonal effects

### Dataset Snapshot

| Metric | Value |
|--------|-------|
| Total sessions | 12,330 |
| Positive class (Purchase) | 1,908 |
| Negative class (No Purchase) | 10,422 |
| Purchase rate | 15.5% |
| Numerical features | 10 |
| Categorical features | 8 |
| Target variable | `Revenue` |

> `Revenue = 1` indicates a purchase  
> `Revenue = 0` indicates no purchase

Because the dataset is highly imbalanced, careful preprocessing and model evaluation were necessary.

---

## Workflow

### 1. Data Preprocessing

The preprocessing pipeline included:

- loading required libraries
- identifying and handling missing values
- encoding categorical variables
- standardizing numerical features
- splitting the data into training and testing sets

### 2. Train-Test Split

The dataset was divided into:

- **80% training set**
- **20% testing set**

```r
set.seed(123)
trainIndex <- createDataPartition(df$Revenue, p = 0.8, list = FALSE)
trainData <- df[trainIndex, ]
testData <- df[-trainIndex, ]

### 3. Exploratory Data Analysis (EDA)

The EDA phase focused on:

- correlation analysis for numerical variables
- class distribution inspection
- feature importance exploration
- shopper behavior pattern detection

Example correlation plot:

```r
corrplot(cor(trainData[, sapply(trainData, is.numeric)]), method = "circle")
```

### 4. Class Imbalance Handling

Since only **15.5%** of sessions resulted in a purchase, imbalance handling was necessary.

Techniques used included:

- **SMOTE**
- weighting strategies

These methods improved the model’s ability to detect the minority class.

### 5. Model Training

The following classification models were tested:

- Logistic Regression
- Random Forest
- Gradient Boosting

Example Random Forest training:

```r
rf_model <- train(
  Revenue ~ .,
  data = trainData,
  method = "rf",
  trControl = trainControl(method = "cv", number = 5)
)
```

### 6. Model Evaluation

Models were compared using:

- Accuracy
- Precision
- Recall
- F1-score

Cross-validation was applied to ensure reliable performance comparison.

---

## Models Compared

| Model | Purpose |
|------|---------|
| Logistic Regression | Baseline interpretable classifier |
| Random Forest | Ensemble model for robust classification |
| Gradient Boosting | Boosted trees for improved predictive power |

---

## Results

### Best-Performing Model

**Random Forest** achieved the best overall performance.

### Performance Highlights

- **Accuracy:** ~87%
- strong precision across classes
- improved recall after handling class imbalance
- significant reduction in false negatives compared to Logistic Regression

### Why It Matters

Reducing false negatives is especially important in e-commerce, since it helps detect users with real purchase intent more accurately and supports better conversion-focused actions.

---

## Key Insights

- Purchase intention can be predicted effectively using session-level behavioral data.
- Handling class imbalance is critical when modeling conversion behavior.
- Ensemble methods such as Random Forest outperform simpler baseline models in this problem.
- Accuracy alone is not enough; **recall** and **F1-score** are especially important in imbalanced datasets.

---

## Challenges Addressed

During the project, the following issues were handled successfully:

- missing value treatment
- categorical variable encoding
- class imbalance correction using SMOTE and weighting
- model comparison through cross-validation

---

## Tech Stack

### Language

- **R**

### Main Libraries

- `DataExplorer`
- `knitr`
- `kableExtra`
- `magrittr`
- `tidyverse`
- `caret`
- `dlookr`
- `naniar`
- `rpart`
- `randomForest`
- `gbm`
- `corrplot`
- `ggplot2`
- `doParallel`
- `GGally`

---

## Project Structure

```bash
.
├── data/          # Raw and processed data
├── notebooks/     # Analysis notebooks or RMarkdown files
├── src/           # Data preparation and modeling scripts
├── results/       # Charts, metrics, and exported outputs
└── README.md      # Project documentation
```

---

## How to Run the Project

### 1. Clone the Repository

```bash
git clone <repo-url>
cd <repo-folder>
```

### 2. Install the Required Packages in R

```r
install.packages(c(
  "DataExplorer", "knitr", "kableExtra", "magrittr", "tidyverse",
  "caret", "dlookr", "naniar", "rpart", "randomForest",
  "gbm", "corrplot", "ggplot2", "doParallel", "GGally"
))
```

### 3. Open the Project in RStudio

Open the main notebook or `.Rmd` file containing the preprocessing, EDA, and model training workflow.

### 4. Run the Analysis

Execute the code step by step or render the `.Rmd` file to reproduce the final report.

---

## Skills Demonstrated

This project highlights experience in:

- exploratory data analysis
- data preprocessing
- feature engineering
- classification modeling
- class imbalance handling
- model evaluation and comparison
- business-oriented interpretation of results
- reproducible analytical workflows in R

---

## Future Improvements

Possible next steps include:

- hyperparameter tuning for better optimization
- additional feature engineering to capture session-level behavior
- deeper experimentation with boosting models
- testing deep learning approaches
- deploying the best-performing model for real-time prediction

---

## Business Value

This project shows how machine learning can support e-commerce decision-making by helping businesses:

- identify high-intent visitors
- improve conversion-focused marketing strategies
- reduce missed opportunities
- enhance personalization and user experience

---

## Conclusion

This analysis demonstrates how machine learning can be used to understand online shopper behavior and predict purchase intention. Among the tested models, **Random Forest** delivered the strongest performance, offering a solid balance between predictive accuracy and business value.

The project also reinforces the importance of data-driven decision-making in e-commerce, particularly for conversion optimization and customer behavior analysis.
