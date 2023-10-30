
#*********************************************OLS Calculations**********************************************************

#import packages
import pandas as pd
import statsmodels.api as sm
from statsmodels.iolib.summary2 import summary_col


# Step 1: Convert numeric columns to appropriate data types
numeric_columns = ['hourly_wage', 'year', 'wage', 'hours', 'emp', 'treat', 'female', 'IQ', 'KWW', 'educ', 'exper', 'tenure',
                   'age', 'married', 'black', 'south', 'urban', 'sibs', 'brthord', 'meduc', 'feduc']

final_data[numeric_columns] = final_data[numeric_columns].astype(float)  # Convert to float or appropriate numeric type

# Step 2: OLS for Year 2005 and female Workers (female=1)
# Filter the data for year 2005 and female workers (female=1)
data_2005_female = final_data[(final_data['year'] == 2005) & (final_data['female'] == 1)]

# Drop the columns 'year', 'emp', 'female', 'hourly_wage', and 'id' from the independent variables
independent_vars_2005_female = data_2005_female.drop(columns=['year', 'emp', 'hourly_wage', 'female', 'id', 'wage'])

# Add a constant term for the intercept in the regression
independent_vars_2005_female = sm.add_constant(independent_vars_2005_female)

# Define the OLS model for wages with year=2005 and independent variables for female workers
wage_model_2005_female = sm.OLS(data_2005_female['hourly_wage'], independent_vars_2005_female)

# Fit the wage model for year=2005 and female workers
results_2005_female = wage_model_2005_female.fit()

# Step 3: Print the OLS results for Year 2005 and female workers
print("OLS Results for Year 2005 and female Workers (female=1):")
print(results_2005_female.summary())

# Step 4: Create a custom summary table with asterisks for significant p-values for female workers
custom_summary_2005_female = summary_col([results_2005_female], stars=True, float_format='%0.3f', model_names=['hourly_wage'])

# Step 5: Print the modified summary with asterisks for Year 2005 and female workers
print("Summary Table with Asterisks for Year 2005 and female Workers (female=1):")
print(custom_summary_2005_female)

# Step 6: Create a list of statistically significant variable names for Year 2005 and female workers
p_values_2005_female = results_2005_female.pvalues
significant_2005_vars_female = [var for var in independent_vars_2005_female.columns if p_values_2005_female[var] < 0.05]

# Step 7: Print the list of significant variable names for Year 2005 and female workers
print("Statistically Significant Variables for Year 2005 and female Workers (female=1):")
print(significant_2005_vars_female)

#**********************************************************************************************************************#

# Step 8: OLS for Year 2005 and male Workers (female=0)
# Filter the data for year 2005 and male workers (female=0)
data_2005_male = final_data[(final_data['year'] == 2005) & (final_data['female'] == 0)]

# Drop the columns 'year', 'emp', 'female', 'hourly_wage', and 'id' from the independent variables
independent_vars_2005_male = data_2005_male.drop(columns=['year', 'emp', 'hourly_wage', 'female', 'id', 'wage'])

# Add a constant term for the intercept in the regression
independent_vars_2005_male = sm.add_constant(independent_vars_2005_male)

# Define the OLS model for wages with year=2005 and independent variables for male workers
wage_model_2005_male = sm.OLS(data_2005_male['hourly_wage'], independent_vars_2005_male)

# Fit the wage model for year=2005 and male workers
results_2005_male = wage_model_2005_male.fit()

# Step 9: Print the OLS results for Year 2005 and male workers
print("OLS Results for Year 2005 and male Workers (female=0):")
print(results_2005_male.summary())

# Step 10: Create a custom summary table with asterisks for significant p-values for male workers
custom_summary_2005_male = summary_col([results_2005_male], stars=True, float_format='%0.3f', model_names=['hourly_wage'])

# Step 11: Print the modified summary with asterisks for Year 2005 and male workers
print("Summary Table with Asterisks for Year 2005 and male Workers (female=0):")
print(custom_summary_2005_male)

# Step 12: Create a list of statistically significant variable names for Year 2005 and male workers
p_values_2005_male = results_2005_male.pvalues
significant_2005_vars_male = [var for var in independent_vars_2005_male.columns if p_values_2005_male[var] < 0.05]

# Step 13: Print the list of significant variable names for Year 2005 and female workers
print("Statistically Significant Variables for Year 2005 and male Workers (female=0):")
print(significant_2005_vars_male)

#**********************************************************************************************************************#

# Step 14: OLS for Year 2010 and female Workers (female=1)
# Filter the data for year 2010 and female workers (female=1)
data_2010_female = final_data[(final_data['year'] == 2010) & (final_data['female'] == 1)]

# Drop the columns 'year', 'emp', 'female', 'hourly_wage', and 'id' from the independent variables
independent_vars_2010_female = data_2010_female.drop(columns=['year', 'emp', 'hourly_wage', 'female', 'id', 'wage'])

# Add a constant term for the intercept in the regression
independent_vars_2010_female = sm.add_constant(independent_vars_2010_female)

# Define the OLS model for wages with year=2010 and independent variables for female workers
wage_model_2010_female = sm.OLS(data_2010_female['hourly_wage'], independent_vars_2010_female)

# Fit the wage model for year=2010 and female workers
results_2010_female = wage_model_2010_female.fit()

# Step 15: Print the OLS results for Year 2010 and female workers
print("OLS Results for Year 2010 and female Workers (female=1):")
print(results_2010_female.summary())

# Step 16: Create a custom summary table with asterisks for significant p-values for female workers
custom_summary_2010_female = summary_col([results_2010_female], stars=True, float_format='%0.3f', model_names=['hourly_wage'])

# Step 17: Print the modified summary with asterisks for Year 2010 and female workers
print("Summary Table with Asterisks for Year 2010 and female Workers (female=1):")
print(custom_summary_2010_female)

# Step 18: Create a list of statistically significant variable names for Year 2010 and female workers
p_values_2010_female = results_2010_female.pvalues
significant_2010_vars_female = [var for var in independent_vars_2010_female.columns if p_values_2010_female[var] < 0.05]

# Step 19: Print the list of significant variable names for Year 2010 and female workers
print("Statistically Significant Variables for Year 2010 and female Workers (female=1):")
print(significant_2010_vars_female)

#**********************************************************************************************************************#

# Step 20: OLS for Year 2010 and male Workers (female=0)
# Filter the data for year 2010 and male workers (female=0)
data_2010_male = final_data[(final_data['year'] == 2010) & (final_data['female'] == 0)]

# Drop the columns 'year', 'emp', 'female', 'hourly_wage', and 'id' from the independent variables
independent_vars_2010_male = data_2010_male.drop(columns=['year', 'emp','hourly_wage', 'female', 'id', 'wage'])

# Add a constant term for the intercept in the regression
independent_vars_2010_male = sm.add_constant(independent_vars_2010_male)

# Define the OLS model for wages with year=2010 and independent variables for male workers
wage_model_2010_male = sm.OLS(data_2010_male['hourly_wage'], independent_vars_2010_male)

# Fit the wage model for year=2010 and male workers
results_2010_male = wage_model_2010_male.fit()

# Step 21: Print the OLS results for Year 2010 and male workers
print("OLS Results for Year 2010 and male Workers (female=0):")
print(results_2010_male.summary())

# Step 22: Create a custom summary table with asterisks for significant p-values for male workers
custom_summary_2010_male = summary_col([results_2010_male], stars=True, float_format='%0.3f', model_names=['hourly_wage'])

# Step 23: Print the modified summary with asterisks for Year 2010 and male workers
print("Summary Table with Asterisks for Year 2010 and male Workers (female=0):")
print(custom_summary_2010_male)

# Step 24: Create a list of statistically significant variable names for Year 2010 and male workers
p_values_2010_male = results_2010_male.pvalues
significant_2010_vars_male = [var for var in independent_vars_2010_male.columns if p_values_2010_male[var] < 0.05]

# Step 25: Print the list of significant variable names for Year 2010 and female workers
print("Statistically Significant Variables for Year 2010 and male Workers (female=0):")
print(significant_2010_vars_male)

# Convert summary tables to DataFrames
df_custom_summary_2005_female = custom_summary_2005_female.tables[0]
df_custom_summary_2005_male = custom_summary_2005_male.tables[0]
df_custom_summary_2010_female = custom_summary_2010_female.tables[0]
df_custom_summary_2010_male = custom_summary_2010_male.tables[0]

# Concatenate DataFrames horizontally
result_df = pd.concat([df_custom_summary_2005_female, df_custom_summary_2005_male, df_custom_summary_2010_female, df_custom_summary_2010_male], axis=1)

# Rename the columns
result_df.columns = ['Year 2005 (female)', 'Year 2005 (male)', 'Year 2010 (female)', 'Year 2010 (male)']

# Print the resulting DataFrame
print(result_df)

# Save the resulting DataFrame as .xlsx
result_df.to_excel("OLS_result_summary.xlsx", index=False)