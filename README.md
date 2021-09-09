# Group-7

## Topic: Natural Disasters

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
- Can the number of disasters in a specified year be predicted based off of historial data? 
- Can we predict whether or not a disaster will occur?

## Description of data exploration phase

### Database
The two CSV files were exported as tables, stored in the RDS database using Amazon Web Services (AWS) and joined using SQL.
Reference tables for state abbreviations and FPIS codes are also included. The ERD schematic is included in the Images folder. All files are included in the Data folder.

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

These graphs are also included in the Images folder.

Pending:
disaster type and location
which disaster is the most frequent in each state (Tableu visualization)


### Description of preliminary pre-processing 
Preliminary data exploration included cleaning the dataframes to remove null values and columns including XXX

### Description of analysis phase 


## Machine Learning Model

Facebook Prophet uses the sklearn model API. We create an instance of the Prophet class and then call its fit and predict methods to predict the number of natural disasters at a given time.

### Description feature engineering and preliminary feature selection, including their decision-making process

###  Description of how data was split into training and testing sets 

### Explanation of model choice, including limitations and benefits



Perform ETL on CSV file using Python to clean and store data in PostgreSQL.

## Visualization

- Tableau
- Javascript Leaflet

### Description of the tool(s) that will be used to create final dashboard

### Description of interactive element(s)

