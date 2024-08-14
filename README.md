## Importing Data into Power BI
Orders is the fact table, while Products, Stores, and Customers are dimension tables.

### Orders
The Orders table was imported from an Azure SQL database using the 'Get Data' function in Power BI. Note that the credentials for the Azure DB did not work until the database name was omitted from the credentials window.

Both the `Order Date` and `Shipping Date` columns of the `Orders` table, which each show both date and time, were split into separate columns: `Order Date`, `Order Time`, `Shipping Date`, and `Shipping Time`.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Products
The Products table was imported from a CSV file using the 'Get Data' function in Power BI.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Stores
The Stores table was imported from Azure Blob Storage using the 'Get Data' function in Power BI. Similar to the Customers table below, the 'Combine and Transform' option must be selected during this process.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Customers
The customers table was imported from 3 CSV files, using the 'Get Data' function in Power BI. Similar to the Stores table above, the 'Combine and Transform' option must be selected during this process, to combine the 3 CSV files into one single Power BI table.

The First Name and Last Name columns were combined to create a Full Name column.

The column indicating the CSV source of each customer was deemed unueccesary, and removed.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

## Data Model

### Date Table
- Needed to add STARTOFYEAR and ENDOFYEAR Columns temporarily, to calculate a date-table

## Customer Detail Page

## Executive Summary Page

## Product Detail Page

## Stores Map Page

## Cross-Filtering and Navigation

### Cross-Filtering
The following instances of cross-filtering between visuals were blocked:
- 

### The Navigation Bar