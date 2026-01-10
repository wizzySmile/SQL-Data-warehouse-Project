# Importing the neccessary python libary
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Setting a fixed figure size
%matplotlib inline
plt.rcParams['figure.figsize'] = (8,6)

from sqlalchemy import create_engine
import urllib

# Define connection parameters for SQL Server
server = r'DESKTOP-1IV1IS2\SQLEXPRESS'
database = 'DataWarehouse'

params = urllib.parse.quote_plus(
    f"DRIVER=ODBC Driver 17 for SQL Server;"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)
# Establish connection to SQL Server database
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

connection = engine.connect()
# Load data from gold.report_customers table into a DataFrame
df = pd.read_sql("SELECT * FROM gold.report_customers", connection)
df.head()
