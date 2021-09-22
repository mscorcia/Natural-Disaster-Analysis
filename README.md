# Group-7

## Topic: Natural Disasters and Earth Surface Temperature Data
Google slides link: https://docs.google.com/presentation/d/1TlmPHNqpeHwBpQ29GSwozfTvQFlbCuyCH9ntdjvDxmw/edit#slide=id.gea57dcc218_1_0

## Description of the Communication Protocols:

- Square - Michael Scorcia
- Triangle - Kelly Rice/Candice Gurbatri
- Circle - Jeferson Stabille
- X - Emma Wallace

## Software
- pgAdmin 4
- Python -version 3.7
- Jupyter notebook -version 6.1.4

## Description of source of data

**Description**:
* CSV file including natural disasters (1953-2016)
* CSV file including Climate Change: Earth Surface Temperature Data 

## Outline of Project

**Motivation**: 
Better preparation for natural disasters can minimize destruction and improve response strategy

**Major Questions**:
- Is there a correlation between disaster type and location?
- Does the frequency and type of disasters change over time?
- Can the number of disasters in a specified year be predicted based off of historial data alone? 
- Can we predict whether or not a specific disaster will occur in a specific location?
- Can we predict future Earth temperatures in a specific location based on historical data alone?

## Description of data exploration phase

### Database
Our database comprises four tables and stores all information used on our model. We selected PostgreSQL as our database and stored it at Amazon Web Services (AWS) RDS cloud services. 

All data manipulation was performed in pandas, and the output was exported using a csv files format to an AWS S3 bucket. The files stored at the S3 bucket served as input to the Machine Learning (ML) model.

#### Database information: 

- FIPS Table: Accommodates Federal Information Processing System (FIPS) Codes for - States and Counties. FIPS codes are numbers that uniquely identify geographic areas.
- Temperature Table: Contains the average temperature for a particular state during a specific period.
- US States Table: Includes state description and its respective abbreviation.
- Disasters Table: This contains a high-level summary of all federally declared disasters since 1953.

#### ERD schematic diagram:
Here is the entity-relationship diagram of those tables and datasets.

<img src="/Images/diaster_db_erd.png" width="700" height="700">

Note: you will be able to find all database-related information in /data folder .

### Description of preliminary pre-processing 
Preliminary data exploration included cleaning the dataframes to remove null values and columns were dropped and excluded from analysis because they had multiple NaN values, duplicated information present in other columns or did not appear to affect temperature or disaster forecasts. Some of these US_Disaster Table columns dropped include:
- fema_declaration_string
- ih_program_declared
- ia_program_declared
- pa_program_declared
- hm_program declared
- hash
- last_refresh

Regarding the Temperatures table, the original dataset contained global temperature averages spanning years not included in our US_Disasters dataframe. Therefore, we filtered the table to only include temperatures in the US between 1953 and 2013.

Due to our focus on time, we extracted out month and year from the incident_dates column in the US_Disasters dataframe and the DATE column in the US_Temperature dataframe. Furthermore, this enabled more streamlined downstream analysis because for every disaster date, we did not have a temperature; instead the temperature was only recorded on the first day of the month. Extracting out the month and date from the date columns in both tables allowed for the tables to be joined on these parameters and for both temperature and disaster frequency to be plotted at either a monthly or yearly resolution. Specifically, the tables were joined on "month_year" and "STATE" using an "inner" join. The CSV file of the merged table (temp_disaster_merge_new.csv)is stored in an S3 bucket on AWS.


### Description of analysis phase 

Preliminary analysis focused on uncovering the variables, if any, that would influence US natural disasters. Since we had a plethora of historical data, we focused on how features of natural disasters (type, number) changed over time and how temperature over time could also influence the event(s).

Preliminary data visualization included graphing the following relationships:
* number of disasters by state (**Fig. 1**)
* number of disasters over time (**Fig. 2**)
* total count per natural disaster (**Fig. 3**)

**Fig. 1**
![incident_counts_by_state](https://user-images.githubusercontent.com/45336910/132601880-49945f70-8853-4f02-9cb6-5b4a41a6c1d3.png)

**Fig. 2**
![incident_counts_over_time](https://user-images.githubusercontent.com/45336910/132601919-6fa9ffdd-2335-49ce-ac28-1f8586b2fcdc.png)

**Fig. 3**
![incident_counts](https://user-images.githubusercontent.com/45336910/132602012-1f561a2a-1770-4ca8-a6e3-7af45dbc8c9f.png)


## Machine Learning Model

Facebook Prophet and Logisitic Regression are used for machine learning models. Facebook Prophet uses the sklearn model API. We create an instance of the Prophet class and then call its fit and predict methods to predict the number of natural disasters at a given time.  Logisitic Regression is also used from sklearn.  We encode and split the data in training and testing objects, scale the data, fit the scaled data to the model, and check the accuracy score.


### Description of data preprocessing 

***Prophet Model - Disaster Prediction:***

In this model, we changed "incident_begin_date" column to date time, filtered to only show disasters that occurred in the state of Texas, and filtered out any biological disaster types.  Biological disasters were excluded  because the impacts of Covid-19 were included in the data as biological. The count of covid -19 data skews the  timeline of overall disasters since there were so many cases within a short time range.

***Prophet Model - Average Temperature Prediction:***

Our data preprocessing in this model included changing the "DATE"  column to datetime, filtered to show average temperatures for state of New York only, and sorted the data in ascending order by date.  Our model would be using one temperature per date only, so we had to focus on one date for our inputs.  

***Logistic Regression - Hurricane Occurrence Prediction:***

In this model, we imported a csv file from an AWS S3 bucket.   This csv file is a join of two tables from our database that allows us to look at disaster and temperature data together.  We then checked for null values and removed columns we won't use in the model.  Our next step was encoding the "incident _type" column with pd.get_dummies.  Our goal is to predict the occurrence of a hurricane, so we only kept the encoded column with hurricane data.  Next, we used LabelEncoder to encoded the string object columns to integers.  After the data was in correct format, our last step of preprocessing was to scale the X and Y variables using Standard Scaler.


### Description of feature engineering and the feature selection, including their decision making process 

***Prophet Model - Disaster Prediction:***

This model uses two columns in a dataframe, one with a datetime value and one with a numerical value.  The columns we used fro this model are date, and total disaster count at the corresponding date.  This dataframe is fit in the model to generate predictions of disaster counts at a future date. We choose to look at the number of disasters that occurred in the state of Texas from 1956-2021. Texas was chosen because this state has the most number of recorded disasters, discovered from our exploratory analysis, so we were able to work with more data in the model.

***Prophet Model - Average Temperature Prediction:***

Similarly to the first prophet model, we also input a dataframe with two columns, one datetime column and one numerical value column.  In this model, we used the date, and the average temperature at that  corresponding date.  The dates in this model we the first of every month, so the model was fit to show monthly seasonality.  The we looked at the average temperatures in New York only because fitting the model with multiple states would not produce accurate analysis. The model can then  attempt to predict the future average temperature at the first day of the month.

***Logistic Regression - Hurricane Occurrence Prediction:***

The logistic model goal is to explore if a model can predict if a Hurricane occurred based on recorded statistics of the disaster that occurred.  The Hurricane disaster column was created from encoded the disaster type column, which produced a column of 0 or 1 values, 0 indicating a hurricane did not occur and 1 indicating that a hurricane did occur.  We choose to look at hurricane data due to it being a popular disaster type.  We can gain insights from the logistic regression model to see if recorded statistics are common in hurricane declaration.  Our X inputs are "disaster_number", "STATE", "declaration_type" ,"fips", "place_code", "designated_area" , "declaration_request_number" ,"year_x", "month_x" ,"AverageTemperatureF". Our Y target variable is incident_type_hurricane.


### Description of how data was split into training and testing sets 

***Prophet Models - Disaster Prediction and Average Temperature Prediction:***

The prophet models do not use training and testing sets.  Instead, the models uses historical datetime and a numerical values as inputs in a 2 column dataframe.  The dataframe is fit in the model and used to generate predictions of a value at a future date.  Our first prophet model uses the number of total disaster counts at a given date for the state of Texas from 1953-2021. The second prophet model uses the average temperatures in New York at the first day of every month from 1953-2013.

***Logistic Regression - Hurricane Occurrence Prediction:***

The logistic regression model uses the X inputs of"disaster_number", "STATE", "declaration_type" ,"fips", "place_code", "designated_area" , "declaration_request_number" ,"year_x", "month_x" ,"AverageTemperatureF". Our Y target variable is incident_type_hurricane.  The X and Y variables were split with train_test_split. The data was then scaled and fit to the logistic regression model.

### Explanation of model choice, including limitations and benefits 

***Prophet Models - Disaster Prediction and Average Temperature Prediction:***

The goal of the prophet models was to predicts the number or disasters occurring in Texas and the average temperature of each month in New York at a future date.  We decided to use the prophet models because the raw data included details date columns, which is needed to run the prophet model.  Prophet allows us to use historical dates and corresponding numerical values to predict future numerical values. The benefit of prophet is that it's a straightforward model that can easily predict future outcomes. However, a limitation is that it only predicts future values based on patterns of the values at certain dates.  This can be helpful for temperature data since temperature normally changes based on time of year, however is does not take into consideration environmental factors that can effect why something occurs. 

***Logistic Regression - Hurricane Occurrence Prediction:*** 

We choose the logistic regression model because we have a large amount of historical data with known outcomes of when a hurricane occurred, which is used in supervised learning models. The logistic model is beneficial because the ability to predict when a disaster occurs can tell us some of the common characteristics that a hurricane has, such as the time of year they likely occur or common areas that typically have hurricane occurrences.  However, a limitation to the logisitic model is that it can be prone to over fitting.


### Description of how they have trained the model thus far, and any additional training that will take place

***Prophet Model - Disaster Prediction:***

This prophet model predicted the number of disasters that will occur in Texas on a daily occurrence until 2022 and we used an interactive plotly graph to display the results. Most of the occurrences seem to fall in the range of 1-100, however there are some predicted negative occurrences that would be considered an inaccurate prediction.

***Prophet Model - Average Temperature Prediction:***

This model attempted to predict average temperatures in New York from 2014-2023.  
After analyzing the interactive model, I would not consider this model to be accurate because most of the predicted temperatures were not following seasonality trends.  The raw data with be reanalyzed to see if it needs to be further manipulated and scaled to get more accurate results.

***Logistic Regression - Hurricane Occurrence Prediction: ***
 
The model was trained using sklearn.linear_model's LogisticRegression. An instance of the model was created and split into training and testing sets using the train_test_split.  X_train_scaled and y_train variables were used to fit the model.  Predictions were then stored in y_predict variable by using the X_test_scaled variable to make the new predictions.  


### Description of current accuracy score 

Our logistic regression resulted in an accuracy score of 89%, indicating the model is good way of predicting hurricane data and it predicted 89% of the Results accurately.  Additionally, our logistic model resulted in the below confusion matrix.

![confusion_matrix](/Images/confusion_matrix.png)




Perform ETL on CSV file using Python to clean and store data in PostgreSQL.

## Dashboard
- https://docs.google.com/presentation/d/1KbGC60bf2T-NjHcynDzvxeJ6VsphRRBOGLUToSgOKZg/edit#slide=id.gef310afd0e_0_12
- Link to Dashboard: https://public.tableau.com/app/profile/emma5832/viz/USNaturalDiasters/U_S_NatualDisasters?publish=yes

### Description of the tool(s) that will be used to create final dashboard
- Tableau will be used to create the visualizations for the dashboard

### Description of interactive element(s)
- Users can filter the dashboard by disaster type via a dropdown menu or by year using a silder. They can also click on a specific state on the map to filter the data as well. Any type filter will automatically filter the bar graph, pie chart and map accordingly. 
