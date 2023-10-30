
#*******************************************Data Manupulation**********************************************************#


#import packages
import doubleml
import pandas as pd
import pip
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.impute import SimpleImputer
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder


#Fill the NA values in the 'brthord', 'meduc', 'feduc' variable with RandomForestRegressor

# Pull the data and separate it by years
data = pd.read_csv('genderinequality.csv')
data_2005 = data[data['year'] == 2005]
data_2010 = data[data['year'] == 2010]

# Sort the DataFrame by 'id'
data.sort_values(by='id', inplace=True)

# Separate the columns with missing values in data_2005 ('brthord', 'meduc', and 'feduc')
target_columns = ['brthord', 'meduc', 'feduc']
X = data_2005.drop(target_columns, axis=1)
y = data_2005[target_columns]

# Drop the target columns from data_2010 (data)
data_2010 = data_2010.drop(target_columns, axis=1)

# Use SimpleImputer to fill missing values in 'y'
imputer = SimpleImputer(strategy='mean')
y_imputed = pd.DataFrame(imputer.fit_transform(y), columns=target_columns, index=y.index)

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y_imputed, test_size=0.2, random_state=42)

# RandomForestRegressor
model = RandomForestRegressor()

# Fit the model on the non-missing data
model.fit(X_train, y_train)

# Predict the missing values in 'target_column' using the trained model
predicted_values = model.predict(X_test)

# Convert the predicted values to integers
predicted_values = predicted_values.astype(int)

# Create a DataFrame with the predicted values and the original index of the test set
predicted_df = pd.DataFrame(predicted_values, columns=target_columns, index=X_test.index)

# Combine the predicted DataFrame with the original test set to get the final DataFrame for the test set
final_test_df = pd.concat([X_test, predicted_df], axis=1)

# Convert y_train values to integers
y_train = y_train.astype(int)

# Combine the complete DataFrame with the original training set to get the final DataFrame for the training set
final_train_df = pd.concat([X_train, y_train], axis=1)

# Concatenate the final DataFrames for the training and test sets
final_2005_df = pd.concat([final_train_df, final_test_df], axis=0)

# Get the columns 'sibs', 'meduc', and 'feduc' from final_df
brthord_meduc_feduc = final_2005_df[['id', 'brthord', 'meduc', 'feduc']]

# Merge the columns with data_2010 based on their 'id'
data_2010 = data_2010.merge(brthord_meduc_feduc, on='id')

#*************************Add pre_treatment groups treatment Dummy*****************************************************#

# Drop the "treat" column from the final_2005_df dataframe
final_2005_df = final_2005_df.drop("treat", axis=1)

# Merge the data_2010 dataframe with the modified final_2005_df dataframe using the "id" column
final_2005_df = final_2005_df.merge(data_2010[["id", "treat"]], on='id')

# Sort the 'final_data' DataFrame by 'id'
final_2005_df = final_2005_df.sort_values(by='id')

# Concatenate final_df and data_2010 along the rows
final_data = pd.concat([final_2005_df, data_2010], ignore_index=True)


#****************************Change '0' hours with '1' to able to calculate 'hourly_wage'******************************#

final_data['hours'] = final_data['hours'].replace(0, 1)

#Calculate 'hourly_wage'
final_data['hourly_wage'] = final_data['wage'] / final_data['hours']

# Output the combined DataFrame
print(final_data)

# Save the final_data DataFrame as an Excel file
file_name = 'final_data.xlsx'
file_path = os.path.join(r"C:\Users\Lenovo\Desktop\ML", file_name)

try:
    final_data.to_excel(file_path, index=False)
    print(f"Final data saved as Excel file at '{file_path}'.")
except Exception as e:
    print("Error occurred while saving final data:", str(e))


#**********************************************************************************************************************#
# Compare Summary statistics for 'brthord', 'meduc', and 'feduc' between data and final data
# Select 'brthord', 'meduc', and 'feduc' columns from data
data_brthord_meduc_feduc = data[['brthord', 'meduc', 'feduc']]

# Select 'brthord', 'meduc', and 'feduc' columns from final_data
final_data_brthord_meduc_feduc = final_data[['brthord', 'meduc', 'feduc']]

# Summary statistics for 'brthord', 'meduc', and 'feduc' in data DataFrame
data_summary = data_brthord_meduc_feduc.describe()

# Summary statistics for 'brthord', 'meduc', and 'feduc' in final_data DataFrame
final_data_summary = final_data_brthord_meduc_feduc.describe()

# Output the summaries
print("Summary statistics for 'brthord', 'meduc', and 'feduc' in data DataFrame:")
print(data_summary)

print("\nSummary statistics for 'brthord', 'meduc', and 'feduc' in final_data DataFrame:")
print(final_data_summary)

# Visualize the summary statistics using Seaborn bar plots
plt.figure(figsize=(10, 6))

# Plot data DataFrame summary statistics
sns.barplot(data=data_summary, orient='h', palette='Set1')
plt.title("Summary Statistics of 'brthord', 'meduc', and 'feduc' in data DataFrame")
plt.xlabel("Values")
plt.ylabel("Statistics")
plt.show()

# Plot final_data DataFrame summary statistics
plt.figure(figsize=(10, 6))
sns.barplot(data=final_data_summary, orient='h', palette='Set2')
plt.title("Summary Statistics of 'brthord', 'meduc', and 'feduc' in final_data DataFrame")
plt.xlabel("Values")
plt.ylabel("Statistics")
plt.show()
#**********************************************************************************************************************#






