# R Module Lesson Plan - Fall 2022

---

Each week should cover two things:

1. Statistics and Quantitative/Qualitative Methods
2. Concepts in R and R Studio

Students should learn not only concepts in statistics, but also intermediate and somewhat-advanced concepts in R, such as manipulating and visualizing data.

Some concepts to change from previous labs

- More focus on manipulation with `dplyr`
- Changing `rgdal` to `sf` to comply with modern standards
- Focus heavily on good RStudio practices, such as working with scripts, projects, and R Markdown.

## Week 1

- Introductions and Framework for the course

### R Module 1: Working with R and R Studio

- R Studio Basics
  - [x] Downloading / installing R and R Studio
  - [x] Working in console/terminal

- Basic tasks in R
  - [x] "Hello World"-type script
  - [x] Saving files
  - [x] "Environment" -- save for RM2?
  - [x] Basic plots with `plot()`, `hist()`, etc.
  - [x] Built-in data sets (MASS, mtcars, etc.)

## Week 2

- Introduction into Quantitative Geography and R
  - Measures of Central Tendency (Mean, median, mode)
  - Measures of Dispersion (Range, Variance, SD, CoV)

### R Module 2: Visualizing and Importing Quantitative data in R

- Working in an Organized Manner
  - [x] Creating Scripts
  - [x] Staying organized with projects
- [x] Introduction to `ggplot2`
- [x] Introductory Statistics
  - [x] Measures of Central Tendency

## Week 3

- [ ] File Management
- [ ] Importing a CSV with GUI
  - [ ] `readr` / functional approach
- [ ] Working Directory
- Descriptive Statistics and Data Display
- Probability and Probability Distributions
  - Mapping Techniques
  - Discrete (Uniform, Binomial, and Poisson distributions)
  - Continuous Distributions
- R Module 3
  - Mapping with `sf` and `ggplot2`
  - Choropleth mapping
  - Importing and exporting shapefiles

## Week 4

- Survey Development, Sampling, and Statistical Tests
  - Statistical Tests for Surveys
  - Sampling Techniques
- R Module 4
  - Factor Data and Levels
  - Recoding with `dplyr`
  - Visualizing qualitative data with `ggplot2`

## Week 5

- Probability and Confidence Intervals
  - Central Limit Theorem
  - Confidence Intervals
- R Module 5
  - Graphing confidence intervals
  - Mutating data with `dplyr::mutate()`
    - Adding columns programatically

## Week 6

- Inferential Statistics: Hypothesis Testing and Difference Testing
  - Two-sample T-Test
  - Matched Pairs T-Test
- R Module 6
  - T-Tests in R
  - Interpreting results
  - **R Markdown?!**
    - Maybe introduce in RM5?
    - Having tables saved as `kables`

## Week 7

- Comparative Statistics
  - ANOVA
- R Module 7
  - ANOVA and variance testing in R
  - *expand rm7*

## Week 8

- Statistical Relationships: Bivariate Regression
  - Principles of OLS Regression
  - Form and Strength of Relationships
  - Autocorrelation
  - Analysis of Residuals
  - Non-linear Forms
- R Module 8
  - Intro to Regression
  - Correlation matrices
  - More mapping with `ggplot2`

## Week 9

- Statistical Relationships: Multiple Regression
  - Elements of a good model
  - Regression Diagnostics
- R Module 9
  - Introductory Spatial regression and autocorrelation
  - Working more with `sf`
  - Manipulating *simple features* objects in R
  - Mapping spatial residuals

## Week 10

- Advanced Spatial Relationships
  - Spatial Regression
- R Module 10
  - Spatial regression and autocorrelation
  - LISA
