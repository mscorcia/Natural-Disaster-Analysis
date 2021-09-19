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
- Can we predict whether or not a disaster will occur?
- Can we predict future Earth temperatures in a specific location based on historical data alone?

## Description of data exploration phase

### Database
The two CSV files were exported as tables, stored in the RDS database using Amazon Web Services (AWS) and joined using SQL.
Reference tables for state abbreviations and FPIS codes are also included. The ERD schematic is included in the Images folder. All files are included in the Data folder.

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


### Description feature engineering and preliminary feature selection, including their decision-making process

The Prophet model uses a datetime and numerical values only to generate future predicts of the numerical value at later dates.  We choose to look at the number of diasters in the state of Texas at a given date.  Texas was chosen because this state as the most number of recorded disaster, discovered from our exploratory analysis. The second prophet model uses the average temperature in New York at the first of every month.   The model then predict the future average temperature at the first day of the month.  The logisitic model goal is to explore if a model can predict is a Hurricane occrued (0 or 1, no or yes) based on recorded statistics of the diaster.  Hurricane is a popular disaster type and the logsitic regression can show if recorded statistics such as year, state, declartion type, and postal code are common in hurrican declaration. Our X inputs arer state	declaration_type, fy_declared,	fips, place_code, designated_area, and declaration_request_number.  Our Y target variable is incident_type_hurricane.

###  Description of how data was split into training and testing sets 

The Prophet model uses historical datetime and a numerical values as inputs, instead of training and testing sets.  The first prophet model uses the number of total diaster counts at a given date for the state of Texas.  This dataframe will then be fit to the model to see if it can predict a future count of disasters at a future date.  The incident begin date column was converted to the datetime value.  The dataframe was filtered to the state of texas, grouped by incident begin date by counting the number of diaster by date.  The incident begin date and count of disasters by date wherer used at the inputs in the model.  The second prophet model uses the average temperature in New York at the first of every month.  The date column was converted to datetime and the entire datafame was filtered to the state of New York.  The date and average tempeature columns were used as the inputs for the model.  Our logisitc regression model was prepped by taking the disaster table and dropping unnessesary columns.  Incident type was encoded with the get dummies functions.  We only kept the encoded Hurrican incident type column since we are looking at is the occurance of a hurricane could be predicted.  String columns were also encoded with Label Encoder.  The X and Y values were split with train_test_split. The data was then scaled and fit to the model.  

### Explanation of model choice, including limitations and benefits

The Prophet model was used because of the incident occurance dates provides in our raw data.  Since this information was available, prophet allows us to use this date to predict numerical values in the future.  The benefit of prophet is that it's a straightforward model that can easily predict future outcomes.  However, a limitation is that it only predicts future values based on patterns of the values at certain dates and assumes value change based on that date.  This can be helpful for temperature data since temperature normally changes based on time of year, however is does not take into consideration environmental factors that affect why something occurs.  The logistic regression model was used because we know the previous data, which called for us to use a suprevised learning model.  The logistic model was beneficial because we know is a diaster already occured.  The accuracy score resulted in about 78%, which seems be an OK model, but therr is a limitationthat our model may be prone to overfitting.


Perform ETL on CSV file using Python to clean and store data in PostgreSQL.

## Dashboard
- https://docs.google.com/presentation/d/1KbGC60bf2T-NjHcynDzvxeJ6VsphRRBOGLUToSgOKZg/edit#slide=id.gef310afd0e_0_12
- Link to Dashboard: https://public.tableau.com/app/profile/emma5832/viz/USNaturalDiasters/U_S_NatualDisasters?publish=yes

### Description of the tool(s) that will be used to create final dashboard
- Tableau will be used to create the visualizations for the dashboard

### Description of interactive element(s)
- Dashboard will use a Tableau Action to join a Natural Disasters by Year graph and Natural Diasters by State map. Users will be able to filter by Disaster type as well as filter by a particular state or year 
