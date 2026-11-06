## UFC Fight Outcome Analysis Using SAS

##Project Overview

This project analyzes 6,855 UFC fights to identify fighter characteristics associated with winning a fight. Using SAS and logistic regression, our group examined how differences in fighter statistics, such as age, reach, striking ability, and takedown performance, relate to fight outcomes.

The goal was to use statistical analysis to provide insights that could help coaches and fighters better understand which characteristics are associated with success in the UFC.

## The Dataset

The dataset contains 6,855 UFC fights and includes fighter characteristics, performance statistics, and fight outcomes.

To compare fighters directly, we used differential variables calculated as:

Differential = Fighter 1 Statistic − Fighter 2 Statistic

For example, a positive reach differential indicates that Fighter 1 has a longer reach than Fighter 2.

The dependent variable was fight outcome, coded as:

1: Fighter 1 wins

0: Fighter 1 does not win

## Methodology

1. Data Preparation: Imported the cleaned UFC dataset into SAS and selected relevant variables for analysis.

2. Exploratory Analysis: Examined variable distributions, fighter stances, and relationships between predictors and fight outcomes.

3. Model Diagnostics: Investigated potential complete separation using frequency tables, scatterplots, and coefficient standard errors.

4. Logistic Regression: Developed a binary logistic regression model using fighter stance and 11 numerical differential variables.

5. Interpretation: Evaluated odds ratios and 95% confidence intervals to identify statistically significant predictors.

## Key Findings



##Model Results

* Statistical Method: Binary Logistic Regression
* Software: SAS
* Observations: 6,855 UFC fights
* Concordance (c-statistic): 0.708
* Likelihood Ratio Test: χ²(14) = 918.07, p < 0.0001

The c-statistic of 0.708 indicates moderate discrimination on the analyzed dataset. This is an in-sample result, not an independently validated prediction accuracy.


## Repository Contents

data/ — Cleaned UFC fight dataset

sas_code/ — SAS program for the statistical analysis

reports/ — Project presentation, SAS results, and AI-use documentation

Course: STAT 172 — Drake University

## Conclusion

This project provided hands-on experience applying statistical modeling to a real-world sports dataset. Through data preparation, exploratory analysis, logistic regression, and interpretation of model results, our group identified several fighter characteristics associated with UFC fight outcomes.

The project demonstrates how statistical analysis can turn raw sports data into meaningful insights that support informed decision-making.

