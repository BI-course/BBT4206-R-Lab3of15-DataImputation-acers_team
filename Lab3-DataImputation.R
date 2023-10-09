# *****************************************************************************
# Lab 3: Data Imputation ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# Introduction ----
# Data imputation, also known as missing data imputation, is a technique used
# in data analysis and statistics to fill in missing values in a dataset.
# Missing data can occur due to various reasons, such as equipment malfunction,
# human error, or non-response in surveys.

# Imputing missing data is important because many statistical analysis methods
# and Machine Learning algorithms require complete datasets to produce accurate
# and reliable results. By filling in the missing values, data imputation helps
# to preserve the integrity and usefulness of the dataset.

## Data Imputation Methods ----

### 1. Mean/Median Imputation ----###Everyone getting the same average mark including those who did ot do the cats 

# This method involves replacing missing values with the mean or median value
# of the available data for that variable. It is a simple and quick approach
# but does not consider any relationships between variables.

# Unlike the recorded values, mean-imputed values do not include natural
# variance. Therefore, they are less “scattered” and would technically minimize
# the standard error in a linear regression. We would perceive our estimates to
# be more accurate than they actually are in real-life.

### 2. Regression Imputation ----
# In this approach, missing values are estimated by regressing the variable
# with missing values on other variables that are known. The estimated values
# are then used to fill in the missing values.

### 3. Multiple Imputation ----
# Multiple imputation involves creating several plausible imputations for each
# missing value based on statistical models that capture the relationships
# between variables. This technique recognizes the uncertainty associated with
# imputing missing values.

### 4. Machine Learning-Based Imputation ----
# Machine learning algorithms can be used to predict missing values based on
# the patterns and relationships present in the available data. Techniques such
# as K-Nearest Neighbours (KNN) imputation or decision tree-based imputation can
# be employed.

### 5. Hot Deck Imputation ----
# This method involves finding similar cases (referred to as donors) that have
# complete data and using their values to impute missing values in other cases
# (referred to as recipients).

### 6. Multiple Imputation by Chained Equations (MICE) ----
###It can input for categorical and numbers but ot statements or paragraphs for a respondent

# MICE is flexible and can handle different variable types at once (e.g.,
# continuous, binary, ordinal etc.). For each variable containing missing
# values, we can use the remaining information in the data to train a model
# that predicts what could have been recorded to fill in the blanks.
#Correlation of values in the case of missing values the same mark an individual got in cat 1 can correlate to the one an individual did not do in order to fill in the blanks 
# To account for the statistical uncertainty in the imputations, the MICE
# procedure goes through several rounds and computes replacements for missing
# values in each round. As the name suggests, we thus fill in the missing
# values multiple times and create several complete datasets before we pool the
# results to arrive at more realistic results.

## Types of Missing Data ----
### 1. Missing Not At Random (MNAR) ----
###One variable has missing data in the instance that an individual does not give a negative response rather they skip that question and go to the rest
# Locations of missing values in the dataset depend on the missing values
# themselves. For example, students submitting a course evaluation tend to
# report positive or neutral responses and skip questions that will result in a
# negative response. Such students may systematically leave the following
# question blank because they are uncomfortable giving a bad rating for their
# lecturer: “Classes started and ended on time”.

### 2. Missing At Random (MAR) ----
# Locations of missing values in the dataset depend on some other observed
# data. In the case of course evaluations, students who are not certain about a
# response may feel unable to give accurate responses on a numeric scale, for
# example, the question "I developed my oral and writing skills " may be
# difficult to measure on a scale of 1-5. Subsequently, if such questions are
# optional, they rarely get a response because it depends on another unobserved
# mechanism: in this case, the individual need for more precise
# self-assessments.

### 3. Missing Completely At Random (MCAR) ----
# In this case, the locations of missing values in the dataset are purely
# random and they do not depend on any other data.
#Various people not respond it but their is no specific reason why its not responded 

# In all the above cases, removing the entire response  because one question
# has missing data may distort the results.

# If the data are MAR or MNAR, imputing missing values is advisable.

# *** Initialization: Install and use renv ----
# The renv package helps you create reproducible environments for your R
# projects. This is helpful when working in teams because it makes your R
# projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# Install renv:
if (!is.element("renv", installed.packages()[, 1])) {
  install.packages("renv", dependencies = TRUE)
}
require("renv")

# Use renv::init() to initialize renv in a new or existing project.

# The prompt received after executing renv::init() is as shown below:

# This project already has a lockfile. What would you like to do?
# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
renv::init()

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open that project.

# This can also be configured using the RStudio GUI when you click the project
# file, e.g., "BBT4206-R.Rproj" in the case of this project. Then
# navigate to the "Environments" tab and select "Use renv with this project".

# As you continue to work on your project, you can install and upgrade
# packages, using either:
# install.packages() and update.packages or
# renv::install() and renv::update()
renv::update()
renv::install()

# You can also clean up a project by removing unused packages using the
# following command: renv::clean()

# After you have confirmed that your code works as expected, use
# renv::snapshot() to record the packages and their
# sources in the lockfile.
renv::snapshot()

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# Execute the following code to reinstall the specific package versions
# recorded in the lockfile:
renv::restore()

# One of the packages required to use R in VS Code is the "languageserver"
# package. It can be installed manually as follows if you are not using the
# renv::restore() command.
if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

# STEP 1. Load the Required Dataset ----
# The dataset we will use (for educational purposes) is the US National Health
# and Nutrition Examination Study (NHANES) dataset created from 1999 to 2004.

# Documentation of NHANES:
#   https://cran.r-project.org/package=NHANES or
#   https://cran.r-project.org/web/packages/NHANES/NHANES.pdf or
#   http://www.cdc.gov/nchs/nhanes.htm

# This requires the "NHANES" package available in R

if (!is.element("NHANES", installed.packages()[, 1])) {
  install.packages("NHANES", dependencies = TRUE)
}
require("NHANES")

## The "dplyr" Package ----
# We will also require the "dplyr" package

# "dplyr" is a grammar of *data manipulation*, providing a consistent set of
# verbs that help you solve the most common data manipulation challenges:
#   mutate() adds new variables that are functions of existing variables
#   select() picks variables based on their names.
#   filter() picks cases based on their values.
#   summarise() reduces multiple values down to a single summary.
#   arrange() changes the ordering of the rows.

# Documentation of "dplyr":
#   https://cran.r-project.org/package=dplyr or
#   https://github.com/tidyverse/dplyr

if (!is.element("dplyr", installed.packages()[, 1])) {
  install.packages("dplyr", dependencies = TRUE)
}
require("dplyr")

## The Pipe Operator in the "dplyr" Package ----
# In R, the %>% symbol represents the pipe operator.
# The pipe operator is used for chaining or piping operations together in a
# way that enhances the readability and maintainability of code. It is
# useful when working with data manipulation and data transformation tasks.

# The %>% operator takes the result of the expression on its left and passes it
# as the first argument to the function on its right. This allows you to chain
# together a sequence of operations on a data set or object.

# For example:
# Example 1:
# library(dplyr) # Load the dplyr package (which uses %>%) # nolint

# result <- df %>%
#   filter(age > 30) %>%   # Filter rows where age is greater than 30
#   group_by(gender) %>%  # Group the data by gender
#   summarize(mean_salary = mean(salary))  # Calculate the mean salary for each group # nolint

# # 'result' now contains the result of these operations

# Example 2:
# nhanes_dataset <- nhanes_dataset %>%
#   mutate(MAP = BPDiaAve + (1 / 3) * (BPSysAve - BPDiaAve)) # nolint

### Subset of variables/features ----
# We select only the following 13 features to be included in the dataset:
nhanes_long_dataset <- NHANES %>%
  select(Age, AgeDecade, Education, Poverty, Work, LittleInterest, Depressed,
         BMI, Pulse, BPSysAve, BPDiaAve, DaysPhysHlthBad, PhysActiveDays)

### Subset of rows ----
# We then select 500 random observations to be included in the dataset
rand_ind <- sample(seq_len(nrow(nhanes_long_dataset)), 500)
nhanes_dataset <- nhanes_long_dataset[rand_ind, ]

# STEP 2. Confirm the "missingness" in the Initial Dataset ----
# We require the "naniar" package
# Documentation:
#   https://cran.r-project.org/package=naniar or
#   https://www.rdocumentation.org/packages/naniar/versions/1.0.0

if (!is.element("naniar", installed.packages()[, 1])) {
  install.packages("naniar", dependencies = TRUE)
}
require("naniar")

# Are there missing values in the dataset?
any_na(nhanes_dataset)

# How many?
n_miss(nhanes_dataset)

# What is the percentage of missing data in the entire dataset?
prop_miss(nhanes_dataset)

# How many missing values does each variable have?
nhanes_dataset %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(nhanes_dataset)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(nhanes_dataset)

# Which variables contain the most missing values?
gg_miss_var(nhanes_dataset)

# We require the "ggplot2" package to create more appealing visualizations

if (!is.element("ggplot2", installed.packages()[, 1])) {
  install.packages("ggplot2", dependencies = TRUE)
}
require("ggplot2")

# Where are missing values located (the shaded regions in the plot)?
vis_miss(nhanes_dataset) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables are missing together?
gg_miss_upset(nhanes_dataset)

# Create a heatmap of "missingness" broken down by "AgeDecade"
# First, confirm that the "AgeDecade" variable is a categorical variable
is.factor(nhanes_dataset$AgeDecade)
# Second, create the visualization
gg_miss_fct(nhanes_dataset, fct = AgeDecade)

# We can also create a heatmap of "missingness" broken down by "Depressed"
# First, confirm that the "Depressed" variable is a categorical variable
is.factor(nhanes_dataset$Depressed)
# Second, create the visualization
gg_miss_fct(nhanes_dataset, fct = Depressed)


# STEP 3. Use the MICE package to perform data imputation ----

if (!is.element("mice", installed.packages()[, 1])) {
  install.packages("mice", dependencies = TRUE)
}
require("mice")

# The "dplyr" package is known as "A Grammar of Data Manipulation". Think of
# the DML sub-language of SQL.

# We can use the dplyr::mutate() function inside the dplyr package to add new
# variables that are functions of existing variables

# In this case, it is used to create a new variable called,
# "Median Arterial Pressure (MAP)"
# Further reading:
#   https://en.wikipedia.org/wiki/Mean_arterial_pressure

nhanes_dataset <- nhanes_dataset %>%
  mutate(MAP = BPDiaAve + (1 / 3) * (BPSysAve - BPDiaAve))

# MAP can be positively correlated with "BMI", unfortunately, BMI was reported
# to have approximately 4.8% missing values.

# MAP can also be negatively correlated with "PhysActiveDays" which had
# approximately 55% missing data.

# We finally begin to make use of Multivariate Imputation by Chained
# Equations (MICE). We use 11 multiple imputations.

# To arrive at good predictions for each variable containing missing values, we
# save the variables that are at least "somewhat correlated" (r > 0.3).
somewhat_correlated_variables <- quickpred(nhanes_dataset, mincor = 0.3) # nolint

# m = 11 Specifies that the imputation (filling in the missing data) will be
#         performed 11 times (multiple times) to create several complete
#         datasets before we pool the results to arrive at a more realistic
#         final result. The larger the value of "m" and the larger the dataset,
#         longer the data imputation will take.
# seed = 7 Specifies that number 7 will be used to offset the random number
#         generator used by mice. This is so that we get the same results
#         each time we run MICE.
# meth = "pmm" Specifies the imputation method. "pmm" stands for "Predictive
#         Mean Matching" and it can be used for numeric data.# Used when the various intregers,observations ad statements are implemented or evaluated all together 
#         Other methods include:
#         1. "logreg": logistic regression imputation; used
#            for binary categorical data
#         2. "polyreg": Polytomous Regression Imputation for unordered
#            categorical data with more than 2 categories, and
#         3. "polr": Proportional Odds model for ordered categorical
#            data with more than 2 categories.
nhanes_dataset_mice <- mice(nhanes_dataset, m = 11, method = "pmm",
                            seed = 7,
                            predictorMatrix = somewhat_correlated_variables)

# One can then train a model to predict MAP using BMI and PhysActiveDays or to
# identify the p-Value and confidence intervals between MAP and BMI and
# PhysActiveDays

# We can use multiple scatter plots (a.k.a. strip-plots) to visualize how
# random the imputed data is in each of the 11 datasets.#Blue dots is the existing data 
stripplot(nhanes_dataset_mice,
          MAP ~ BMI | .imp,
          pch = 20, cex = 1)

stripplot(nhanes_dataset_mice,#to confirm whether the existing data is randomized enough
          MAP ~ PhysActiveDays | .imp,
          pch = 20, cex = 1)
#Disadvantage of data imputation-- The data should be randomized  but has to be realistic or accurate #
## Impute the missing data ----
# We then create imputed data for the final dataset using the mice::complete()
# function in the mice package to fill in the missing data.
nhanes_dataset_imputed <- mice::complete(nhanes_dataset_mice, 1)

# STEP 4. Confirm the "missingness" in the Imputed Dataset ----
# A textual confirmation that the dataset has no more missing values in any
# feature:
miss_var_summary(nhanes_dataset_imputed)

# A visual confirmation that the dataset has no more missing values in any
# feature:
if (!is.element("Amelia", installed.packages()[, 1])) {
  install.packages("Amelia", dependencies = TRUE)
}
require("Amelia")
Amelia::missmap(nhanes_dataset_imputed)

#########################
# Are there missing values in the dataset?
any_na(nhanes_dataset_imputed)

# How many?
n_miss(nhanes_dataset_imputed)

# What is the percentage of missing data in the entire dataset?
prop_miss(nhanes_dataset_imputed)

# How many missing values does each variable have?
nhanes_dataset_imputed %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(nhanes_dataset_imputed)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(nhanes_dataset_imputed)

# Which variables contain the most missing values?
gg_miss_var(nhanes_dataset_imputed)

# We require the "ggplot2" package to create more appealing visualizations

# Where are missing values located (the shaded regions in the plot)?
vis_miss(nhanes_dataset_imputed) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables are missing together?

# Note: The following command should give you an error stating that at least 2
# variables should have missing data for the plot to be created.
gg_miss_upset(nhanes_dataset_imputed)

# Create a heatmap of "missingness" broken down by "AgeDecade"
# First, confirm that the "AgeDecade" variable is a categorical variable
is.factor(nhanes_dataset_imputed$AgeDecade)
# Second, create the visualization
gg_miss_fct(nhanes_dataset_imputed, fct = AgeDecade)

# We can also create a heatmap of "missingness" broken down by "Depressed"
# First, confirm that the "Depressed" variable is a categorical variable
is.factor(nhanes_dataset_imputed$Depressed)
# Second, create the visualization
gg_miss_fct(nhanes_dataset_imputed, fct = Depressed)

# Additional Dataset for Practice (the Soybean dataset) ----
# An additional dataset that you can use to practice data imputation is the
# "Soybean" dataset for agriculture. It is available in the mlbench package.
# You can load it by executing the following code:

# if (!is.element("mlbench", installed.packages()[, 1])) {
#   install.packages("mlbench", dependencies = TRUE) # nolint
# }
# require("mlbench") # nolint
# data(Soybean) # nolint

# *** Deinitialization: Create a snapshot of the R environment ----
# Lastly, as a follow-up to the initialization step, record the packages
# installed and their sources in the lockfile so that other team-members can
# use renv::restore() to re-install the same package version in their local
# machine during their initialization step.
renv::snapshot()

# References ----
## United States National Center for Health Statistics (NCHS). (2015). The United States National Health and Nutrition Examination Study (NHANES) (2.1.0) [Dataset]. The Comprehensive R Archive Network [CRAN]. https://cran.r-project.org/package=NHANES # nolint ----

# **Required Lab Work Submission** ----

## Part A ----
# Create a new file called
# "Lab3-Submission-DataImputation.R".
# Provide all the code you have used to perform data imputation on the
# "BI1 Class Performance" dataset provided in class. Perform ALL the data
# imputation steps that have been used in the
# "Lab3-DataImputation.R" file.

## Part B ----
# Upload *the link* to your
# "Lab3-Submission-DataImputation.R" hosted
# on Github (do not upload the .R file itself) through the submission link
# provided on eLearning.

## Part C ----
# Create a markdown file called
# "Lab3-Submission-DataImputation.Rmd"
# and place it inside the folder called "markdown".

## Part D ----
# Knit the R markdown file using knitR in R Studio.
# Upload *the link* to
# "Lab3-Submission-DataImputation.md"
# (not .Rmd) markdown file hosted on Github (do not upload the .Rmd or .md
# markdown files) through the submission link
# provided on eLearning.