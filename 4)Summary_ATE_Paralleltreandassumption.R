# estimate the gender wage gap on data and explore heterogeneity

library(hdm)
library(glmnet)
library(readxl)
library(ggplot2)
library(patchwork)

# ------------ Double LASSO for estimation of gender wage gap

# (1) prepare data

# load data


final_data <- read_excel("final_data.xlsx")

data <- final_data


# Create a new data frame 'data' based on the given conditions for female
female_pre_treatment <- data[data$female == 1 & data$treat == 1 & data$year == 2005, ]
female_post_treatment <- data[data$female == 1 & data$treat == 1 & data$year == 2010, ]
female_pre_control <- data[data$female == 1 & data$treat == 0 & data$year == 2005, ]
female_post_control <- data[data$female == 1 & data$treat == 0 & data$year == 2010, ]

# Create a new data frame 'data' based on the given conditions for male
male_pre_treatment <- data[data$female == 0 & data$treat == 1 & data$year == 2005, ]
male_post_treatment <- data[data$female == 0 & data$treat == 1 & data$year == 2010, ]
male_pre_control <- data[data$female == 0 & data$treat == 0 & data$year == 2005, ]
male_post_control <- data[data$female == 0 & data$treat == 0 & data$year == 2010, ]



#*******************************************************************************#
# Summary Statistics

summary_stats_female_pre_treatment <- summary(female_pre_treatment)
summary_stats_female_post_treatment <- summary(female_post_treatment)
summary_stats_female_pre_control <- summary(female_pre_control)
summary_stats_female_post_control <- summary(female_post_control)
summary_stats_male_pre_treatment <- summary(male_pre_treatment)
summary_stats_male_post_treatment <- summary(male_post_treatment)
summary_stats_male_pre_control <- summary(male_pre_control)
summary_stats_male_post_control <- summary(male_post_control)

# Print summary statistics for each data frame separately
print(summary_stats_female_pre_treatment)
print(summary_stats_female_post_treatment)
print(summary_stats_female_pre_control)
print(summary_stats_female_post_control)
print(summary_stats_male_pre_treatment)
print(summary_stats_male_post_treatment)
print(summary_stats_male_pre_control)
print(summary_stats_male_post_control)


 
#*******************************************************************************#
 
# Calculate the mean wages for female and male pre groups
female_pre_treatment_mean_wage <- mean(female_pre_treatment$wage)
female_pre_control_mean_wage <- mean(female_pre_control$wage)
male_pre_treatment_mean_wage <- mean(male_pre_treatment$wage)
male_pre_control_mean_wage <- mean(male_pre_control$wage)

# Calculate the mean wages for female and male post groups
female_post_treatment_mean_wage <- mean(female_post_treatment$wage)
female_post_control_mean_wage <- mean(female_post_control$wage)
male_post_treatment_mean_wage <- mean(male_post_treatment$wage)
male_post_control_mean_wage <- mean(male_post_control$wage)

# Calculate the mean hours for female and male pre groups
female_pre_treatment_mean_hours <- mean(female_pre_treatment$hours)
female_pre_control_mean_hours <- mean(female_pre_control$hours)
male_pre_treatment_mean_hours <- mean(male_pre_treatment$hours)
male_pre_control_mean_hours <- mean(male_pre_control$hours)

# Calculate the mean hours for female and male post groups
female_post_treatment_mean_hours <- mean(female_post_treatment$hours)
female_post_control_mean_hours <- mean(female_post_control$hours)
male_post_treatment_mean_hours <- mean(male_post_treatment$hours)
male_post_control_mean_hours<- mean(male_post_control$hours)

# Calculate the mean wage/hours for female and male pre groups
female_pre_treatment_mean_wage_hours <- female_pre_treatment_mean_wage/female_pre_treatment_mean_hours
female_pre_control_mean_wage_hours <- female_pre_control_mean_wage/female_pre_control_mean_hours
male_pre_treatment_mean_wage_hours <- male_pre_treatment_mean_wage/male_pre_treatment_mean_hours
male_pre_control_mean_wage_hours <- male_pre_control_mean_wage/male_pre_control_mean_hours

# Calculate the mean wage/hours for female and male post controls
female_post_treatment_mean_wage_hours <- female_post_treatment_mean_wage/female_post_treatment_mean_hours
female_post_control_mean_wage_hours <- female_post_control_mean_wage/female_post_control_mean_hours
male_post_treatment_mean_wage_hours <- male_post_treatment_mean_wage/male_post_treatment_mean_hours
male_post_control_mean_wage_hours <- male_post_control_mean_wage/male_post_control_mean_hours

#*******************************************************************************#

# Calculate the mean values for each groups' employment
female_pre_control_mean_emp <- mean(female_pre_control$emp)
female_pre_treatment_mean_emp <- mean(female_pre_treatment$emp)
female_post_control_mean_emp <- mean(female_post_control$emp)
female_post_treatment_mean_emp <- mean(female_post_treatment$emp)


male_pre_control_mean_emp <- mean(male_pre_control$emp)
male_pre_treatment_mean_emp <- mean(male_pre_treatment$emp)
male_post_control_mean_emp <- mean(male_post_control$emp)
male_post_treatment_mean_emp <- mean(male_post_treatment$emp)

#*******************************************************************************#

#Calculate Average Treatment effects on female and male hourly wages
ATE_female_hourly_wage <- (mean(female_post_treatment$wage)/mean(female_post_treatment$hours) - 
  mean(female_pre_treatment$wage)/mean(female_pre_treatment$hours)) - 
  (mean(female_post_control$wage)/mean(female_post_control$hours) - 
  mean(female_pre_control$wage)/mean(female_pre_control$hours))

ATE_male_hourly_wage <- (mean(male_post_treatment$wage)/mean(male_post_treatment$hours) - 
  mean(male_pre_treatment$wage)/mean(male_pre_treatment$hours)) - 
  (mean(male_post_control$wage)/mean(male_post_control$hours) - 
  mean(male_pre_control$wage)/mean(male_pre_control$hours))

#Calculate differences between Average Treatment effects on female and male employment
ATE_hourly_wage <- ATE_female_hourly_wage - ATE_male_hourly_wage
ATE_hourly_wage

#Calculate Average Treatment effects on female and male employment
ATE_female_emp <- (mean(female_post_treatment$emp) - mean(female_pre_treatment$emp)) - 
  (mean(female_post_control$emp - mean(female_pre_control$emp))) 
   
ATE_male_emp <- (mean(male_post_treatment$emp) - mean(male_pre_treatment$emp)) - 
  (mean(male_post_control$emp) - mean(male_pre_control$emp)) 

#Calculate differences between Average Treatment effects on female and male employment
ATE_emp <- ATE_female_emp - ATE_male_emp
ATE_emp

e1 <- mean(female_post_control$emp) - mean(female_pre_control$emp)
e2 <- mean(female_post_treatment$emp) - mean(female_pre_treatment$emp)
e3 <- mean(male_post_control$emp) - mean(male_pre_control$emp)
e4 <- mean(male_post_treatment$emp) - mean(male_pre_treatment$emp)


#*******************************************************************************#
#Tangents of control groups
female_t <- female_post_control_mean_wage_hours/female_pre_control_mean_wage_hours
male_t <- male_post_control_mean_wage_hours/male_pre_control_mean_wage_hours 


# Define the equation as a function of k to identify growth rate of control groups' wages
equation <- function(k, t) {
  (1 + k)^5 - t
}

# Find the root (value of 'k') for female_t using uni-root
result_female <- uniroot(equation, interval = c(-1, 1), t = female_t)

# Extract the value of 'k' for female_t from the result
k_female <- result_female$root

# Find the root (value of 'k') for male_t using uni-root
result_male <- uniroot(equation, interval = c(-1, 1), t = male_t)

# Extract the value of 'k' for male_t from the result
k_male <- result_male$root

# Print the results
cat("Female: k =", k_female, "\n")
cat("Male: k =", k_male, "\n")

#*******************************************************************************#

# Data for Female Treatment
a <- data.frame(year = c(2005, 2007, 2010), 
                wage = c(female_pre_treatment_mean_wage_hours, female_pre_treatment_mean_wage_hours*(1+k_female)^2, 
                         female_post_treatment_mean_wage_hours),
                group = "Female Treatment")

# Data for Female Treatment Parallel
a_paralel <- data.frame(year = c(2007, 2010), 
                wage = c(female_pre_treatment_mean_wage_hours*(1+k_female)^2, female_pre_treatment_mean_wage_hours*(1+k_female)^5),
                group = "Female Treatment Parallel")

# Data for Female Control
b <- data.frame(year = c(2005, 2010), 
                wage = c(female_pre_control_mean_wage_hours, female_post_control_mean_wage_hours),
                group = "Female Control")

# Data for Male Treatment
c <- data.frame(year = c(2005, 2007, 2010), 
                wage = c(male_pre_treatment_mean_wage_hours, male_pre_treatment_mean_wage_hours*(1+k_male)^2, 
                         male_post_treatment_mean_wage_hours),
                group = "Male Treatment")

# Data for Male Treatment Parallel
c_paralel <- data.frame(year = c(2007, 2010), 
                        wage = c(male_pre_treatment_mean_wage_hours*(1+k_male)^2, male_pre_treatment_mean_wage_hours*(1+k_male)^5),
                        group = "Male Treatment Parallel")

# Data for Male Control
d <- data.frame(year = c(2005, 2010), 
                wage = c(male_pre_control_mean_wage_hours, male_post_control_mean_wage_hours),
                group = "Male Control")

# Combine the data frames into a single data frame
combined_data <- rbind(a,a_paralel, b, c, c_paralel, d)

# Define custom colors for groups
custom_colors <- c("Female Treatment" = "blue", 
                   "Female Treatment Parallel" = "blue",
                   "Female Control" = "orange",
                   "Male Treatment" = "green", 
                   "Male Treatment Parallel" = "green",
                   "Male Control" = "red")

# Define the shaded region limits
shaded_start <- 2007
shaded_end <- 2010

# Create the plot using ggplot2 with a lighter shade of yellow and the label
ggplot(combined_data, aes(x = year, y = wage, color = group, linetype = group)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = ifelse(group %in% c("Female Treatment Parallel", 
                                               "Male Treatment Parallel"), "Parallel", "Normal"))) +
  geom_ribbon(data = combined_data %>%
                filter(year >= shaded_start & year <= shaded_end),
              aes(x = year, ymin = 10, ymax = 35),
              fill = "yellow", alpha = 0.1) +  # Adjust alpha to control the shade
  geom_text(aes(x = (shaded_start + shaded_end) / 2, y = 30, label = "Post Treatment"),
            vjust = -0.5, color = "black", size = 5) +  
  geom_text(aes(x = 2006, y = 30, label = "Pre Treatment"),
            vjust = -0.5, color = "black", size = 5) +  # Add the label text
  labs(title = "Wage Trends by Group",
       x = "Year", y = "Mean Hourly Wage",
       color = "Group", linetype = "Group") +
  scale_color_manual(values = custom_colors) +
  scale_linetype_manual(values = c("Normal" = "solid", "Parallel" = "dashed")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Center-align the plot title

#*******************************************************************************#

female_pre_treatment_parallel <- female_pre_treatment_mean_wage_hours*(1+k_female)^5
male_pre_treatment_parallel <-male_pre_treatment_mean_wage_hours*(1+k_male)^5

#*******************************************************************************#

# Create the data frame for the bar plot with the differences in mean employment
emp_data <- data.frame(
  group = c("Female Control Group", "Female Treatment Group", "Male Control", "Male Treatment"),
  dif_mean_emp = c(e1, e2, e3, e4))

ggplot(emp_data, aes(x = group, y = dif_mean_emp, fill = group)) +
  geom_bar(stat = "identity", width = 0.3) +
  labs(title = "Mean Difference in Employment by Group",
       x = "Group", y = "Mean Difference in Employment Status",
       fill = "Group") +
  ylim(-0.03, 0) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

#*******************************************************************************#



