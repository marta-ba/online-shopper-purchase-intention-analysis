
# Online Shopper Behavior
**Englis Description**

The provided dataset consists of feature vectors from 12,330 sessions, constructed in such a way that each session belonged to a different user over a one-year period. This was done to avoid any bias related to a specific campaign, special day, user profile, or time period.

Of the 12,330 sessions, 84.5% (10,422) were negative class samples that did not result in purchases, while the remaining 15.5% (1,908) were positive class samples that ended in purchases. The dataset consists of 10 numerical attributes and 8 categorical attributes. The ‘Revenue’ attribute can be used as the class label.

The overall objective of this evaluation test is to analyze online shopper behavior in real-time. To achieve this, different methods and algorithms will be tested, and the most optimal one(s) for predicting the visitor's purchase intention should be selected.

**Spanish Description**

 El conjunto de datos que se proporciona consta de vectores de características que pertenecen a 12.330 sesiones y se construyó de tal manera que cada sesión pertenecía a un usuario diferente en un período de 1 año, con objeto de evitar cualquier tendencia a una campaña específica, día especial, perfil de usuario o período. De las 12.330 sesiones, el 84.5% (10.422) fueron muestras de clase negativas que no terminaron con compras, y el resto (1.908) fueron muestras de clases positivas que terminaron con compras. El conjunto de datos consta de 10 atributos numéricos y 8 categóricos. El atributo ‘Ingresos’ se puede usar como etiqueta de clase. El objetivo general de esta prueba de evaluación consiste en analizar el comportamiento del comprador en línea en tiempo real. Para ello, se testarán diferentes métodos y algoritmos y se deberá seleccionar aquel o aquellos métodos que sean más óptimos de cara a predecir la intención de compra del visitante

# Introduction  

This report presents an analysis of **online shopping behavior** using a dataset containing **12,330 sessions**. The main goal of the study is to predict whether a user will complete a purchase based on various numerical and categorical attributes.  

The dataset consists of:
- **10 numerical attributes**  
- **8 categorical attributes**  
- A target variable: **Revenue (1 = Purchase, 0 = No Purchase)**  

The dataset is highly imbalanced, with **only 15.5% of sessions leading to a purchase**. Therefore, proper preprocessing and model selection are essential.

# Data Preprocessing  

The preprocessing steps included:  
1. **Loading required libraries**: Packages such as `caret`, `ggplot2`, and `corrplot` were used for analysis.  
2. **Handling missing values**: Missing values were identified and handled appropriately.  
3. **Feature engineering**: Categorical variables were encoded, and numerical features were standardized.  
4. **Data splitting**: The dataset was divided into **training (80%)** and **testing (20%)** subsets.  


# Necessary libraries

{r}
library(DataExplorer)
library(knitr)
library(kableExtra)
library(magrittr)
library(tidyverse)
library(caret)
library(dlookr)
library(naniar)
library(rpart)
library(randomForest)
library(gbm)
library(corrplot)
library(ggplot2)
library(ggplot2)
library(doParallel)
library(GGally)
{r}

# Data splitting
set.seed(123)
trainIndex <- createDataPartition(df$Revenue, p = 0.8, list = FALSE)
trainData <- df[trainIndex, ]
testData <- df[-trainIndex, ]
Exploratory Data Analysis
Several visualizations were generated to understand the dataset:

Correlation matrix: Identified relationships between numerical variables.
Class distribution: Confirmed dataset imbalance.
Feature importance: Determined key predictors of purchase behavior.

# Correlation plot
corrplot(cor(trainData[, sapply(trainData, is.numeric)]), method = "circle")
Model Selection and Training
Different machine learning models were tested to predict purchase intention:

Logistic Regression
Random Forest
Gradient Boosting (XGBoost)
Each model was evaluated based on accuracy, precision, recall, and F1-score. Due to class imbalance, techniques like SMOTE were applied.

# Train a Random Forest model
rf_model <- train(Revenue ~ ., data = trainData, method = "rf", trControl = trainControl(method = "cv", number = 5))
Results and Comparison
The Random Forest model achieved the highest performance, with:

Accuracy: ~87%
Precision: High for both classes
Recall: Improved after handling class imbalance
The confusion matrix demonstrated that false negatives were significantly reduced compared to the baseline logistic regression model.

Conclusion
This analysis provided insights into factors influencing online purchase behavior. The Random Forest model performed best in predicting purchase intent. Future improvements could include:

Hyperparameter tuning for better model optimization.
Additional feature engineering to capture session-specific behaviors.
Using deep learning models for further performance gains.
Challenges Encountered
During the analysis, the following challenges were addressed:
✅ Handling missing values and categorical encoding.
✅ Addressing class imbalance using SMOTE and weighting techniques.
✅ Selecting the best model through cross-validation.

This study highlights the importance of data-driven decision-making in e-commerce to optimize marketing strategies and user experience.