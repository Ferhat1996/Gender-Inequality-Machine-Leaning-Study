


#*************************************************************************************
# ------------ Double LASSO for estimation of gender wage gap

#install.packages("hdm")
#install.packages("glmnet")
library(hdm)
library(glmnet)


# load data

final_data <- read_excel("final_data.xlsx")
data <- final_data


# variable of interest

data$DID <- ifelse(data$treat == 1 & data$year == 2010, 1, 0)
data$Post <- ifelse(data$year == 2010, 1, 0)

DID <- data$DID
H_wage <- data$hourly_wage


#*************************************************************************************

# create predictors
gap_model <- model.matrix(~ -1 + (female + emp + educ + exper + KWW + IQ + married + age + black + south + urban + sibs + brthord + meduc + feduc), data = data)
gap_model <- gap_model[, which(apply(gap_model, 2, var) != 0)] # exclude all constant variables
demean <- function(x) { x - mean(x) }
gap_model <- apply(gap_model, 2, FUN = demean)

#gap_model <- scale(gap_model)

#*************************************************************************************

# (2) double LASSO estimator with cross-validation

# Define the number of folds for cross-validation
num_folds <- 8  # You can adjust this number based on the size of your dataset

# partial out gap_model from H_wage using cross-validation
fit.lasso.H_wage <- cv.glmnet(gap_model, H_wage, nfolds = num_folds)
lambda_min_H_wage <- fit.lasso.H_wage$lambda.min
fitted.lasso.H_wage <- predict(fit.lasso.H_wage, newx = gap_model, s = lambda_min_H_wage)
H_wagetilde <- H_wage - fitted.lasso.H_wage

# partial out gap_model from DID using cross-validation
fit.lasso.DID <- cv.glmnet(gap_model, DID, nfolds = num_folds)
lambda_min_DID <- fit.lasso.DID$lambda.min
fitted.lasso.DID <- predict(fit.lasso.DID, newx = gap_model, s = lambda_min_DID)
DIDtilde <- DID - fitted.lasso.DID

# run OLS of H_wagetilde on DIDtilde
fit.doubleLASSO <- lm(H_wagetilde ~ DIDtilde)
beta1hat <- coef(fit.doubleLASSO)[2]

print("DID of the Double LASSO model:")
print(beta1hat)

# Run OLS of H_wagetilde on DIDtilde
fit.doubleLASSO <- lm(H_wagetilde ~ DIDtilde)

# Summarize the model fit
DID_DLasso_summary_fit <- summary(fit.doubleLASSO)

# Calculate R-squared for the model
r_squared <- summary(fit.doubleLASSO)$r.squared

# Print the R-squared value
print("R-squared of the Double LASSO model:")
print(r_squared)


#*************************************************************************************

# *************Recovering Heterogeneity in Gender Wage Gap****************************
# ******************** Gainers and Losers of New Policies ****************************

# create predictors
X <- model.matrix(~ -1 + DID + DID:(female + emp + educ + exper + tenure + KWW + IQ + married + age + black + south + urban + sibs + brthord + meduc + feduc) + 
                    +                     (female + emp + educ + exper + KWW + IQ + married + age + black + south + urban + sibs + brthord + meduc + feduc),
                  data = data)

X <- X[, which(apply(X, 2, var) != 0)] # Exclude all constant variables
demean <- function (x) { x - mean(x) }
X <- apply(X, 2, FUN = demean)


# specify target parameters
index.gender <- grep("DID", colnames(X))

# compute one-by-one Double LASSO estimator
fit <- rlassoEffects(X, H_wage, index = index.gender)

# show results
Effects_summary <- print(summary(fit))


#*************************************************************************************
