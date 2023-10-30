#**************************************Triple_Differences*********************************#

# Load required libraries
#install.packages("hdm")
#install.packages("glmnet")
#install.packages("readxl")
#install.packages("patchwor")

library(hdm)
library(glmnet)
library(readxl)
library(patchwork)

# Load data from the file path
final_data <- read_excel("final_data.xlsx")

# Convert final_data to the data
data <- final_data

# Create a new data frame 'data' based on the given conditions for female and male groups
female_pre_treatment <- data[data$female == 1 & data$treat == 1 & data$year == 2005, ]
female_post_treatment <- data[data$female == 1 & data$treat == 1 & data$year == 2010, ]
female_pre_control <- data[data$female == 1 & data$treat == 0 & data$year == 2005, ]
female_post_control <- data[data$female == 1 & data$treat == 0 & data$year == 2010, ]

male_pre_treatment <- data[data$female == 0 & data$treat == 1 & data$year == 2005, ]
male_post_treatment <- data[data$female == 0 & data$treat == 1 & data$year == 2010, ]
male_pre_control <- data[data$female == 0 & data$treat == 0 & data$year == 2005, ]
male_post_control <- data[data$female == 0 & data$treat == 0 & data$year == 2010, ]

# Calculate the triple differences between treated and control groups for hourly_hourly_wages
TD_hourly_hourly_wages <- (mean(female_post_treatment$hourly_wage) - mean(female_pre_treatment$hourly_wage)) - 
  (mean(female_post_control$hourly_wage) - mean(female_pre_control$hourly_wage)) - 
  ((mean(male_post_treatment$hourly_wage) - mean(male_pre_treatment$hourly_wage)) - 
     (mean(male_post_control$hourly_wage) - mean(male_pre_control$hourly_wage)))



#Calculate change in hourly wage between treatment and control group in 2010
treatment_2010 <- data[data$treat == 1 & data$year == 2010, ]
control_2010 <- data[data$treat == 0 & data$year == 2010, ]
Actual_DID  <- mean(treatment_2010$hourly_wage) - mean(control_2010$hourly_wage) 





# Create a new data frame with treatment, year, and group dummies
data$DID <- ifelse(data$treat == 1 & data$year == 2010, 1, 0)
data$Post <- ifelse(data$year == 2010, 1, 0)


# Perform triple differences regression
model_hourly_wage <- lm(hourly_wage ~ DID + female + DID:female  + emp
                        + educ + exper + KWW + IQ + married + age + black + south + urban + sibs + brthord + meduc + feduc,
                        data = data)

# Print the regression summary
summary(model_hourly_wage)


# Perform triple differences regression
model_emp <- lm(emp ~ DID + female + DID:female + hours +hourly_wage
            + educ + exper + KWW + IQ + married + age + black + south + urban + sibs + brthord + meduc + feduc,
            data = data)

# Print the regression summary
summary(model_emp)



