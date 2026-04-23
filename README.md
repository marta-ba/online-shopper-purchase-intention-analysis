# Online Shopper Purchase Intention Analysis

## Overview
This project analyzes online shopper behavior using session-level data from **12,330 user sessions** collected over a one-year period. The objective is to predict whether a visitor will complete a purchase based on a combination of numerical and categorical features.

The project applies **exploratory data analysis, preprocessing, imbalance handling, and machine learning classification models** to identify the most effective method for predicting purchase intention in real time.

---

## Project Objective
Build and evaluate machine learning models to predict whether an online shopping session will result in a purchase.

---

## Dataset
The dataset contains **12,330 sessions**, where each session belongs to a different user across a one-year period. This structure helps reduce bias related to:

- specific campaigns
- special shopping days
- user profiles
- seasonal time periods

### Dataset composition
- **84.5%** negative sessions (**10,422**) with no purchase
- **15.5%** positive sessions (**1,908**) ending in a purchase

### Features
- **10 numerical attributes**
- **8 categorical attributes**
- **Target variable:** `Revenue`
  - `1` = Purchase
  - `0` = No Purchase

Because the dataset is imbalanced, appropriate preprocessing and evaluation strategies were necessary.

---

## Problem Statement
The goal of this project is to analyze online shopper behavior in real time and identify the most effective model for predicting purchase intention.

This type of analysis can support:

- personalized marketing strategies
- conversion optimization
- user behavior analysis
- more efficient targeting of high-intent visitors

---

## Methodology

### 1. Data Preprocessing
The preprocessing pipeline included:

- loading required libraries
- identifying and handling missing values
- encoding categorical variables
- standardizing numerical features
- splitting the dataset into training and testing sets

### 2. Train-Test Split
The data was divided into:

- **80% training set**
- **20% testing set**

```r
set.seed(123)
trainIndex <- createDataPartition(df$Revenue, p = 0.8, list = FALSE)
trainData <- df[trainIndex, ]
testData <- df[-trainIndex, ]
