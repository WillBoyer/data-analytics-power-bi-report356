## Importing Data into Power BI
Orders is the fact table, while Products, Stores, and Customers are dimension tables.

### Orders
The Orders table was imported from an Azure SQL database using the 'Get Data' function in Power BI. Note that the credentials for the Azure DB did not work until the database name was omitted from the credentials window.

Both the `Order Date` and `Shipping Date` columns of the `Orders` table, which each show both date and time, were split into separate columns: `Order Date`, `Order Time`, `Shipping Date`, and `Shipping Time`.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Products
The `Products` table was imported from a CSV file using the 'Get Data' function in Power BI.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Stores
The `Stores` table was imported from Azure Blob Storage using the 'Get Data' function in Power BI. Similar to the Customers table below, the 'Combine and Transform' option must be selected during this process.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

### Customers
The `Customers` table was imported from 3 CSV files, using the 'Get Data' function in Power BI. Similar to the Stores table above, the 'Combine and Transform' option must be selected during this process, to combine the 3 CSV files into one single Power BI table.

The `First Name` and `Last Name` columns were combined to create a `Full Name` column.

The column indicating the CSV source of each customer was deemed unueccesary, and removed.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'. Columns were also renamed to match existing naming conventions.

## Data Model

### Date Table
The Dates table needed to span the earliest and latest dates in the `Orders` table. Generally, the `Order Date` is before the `Shipping Date`. Therefore, the date range must start at the earliest `Order Date` value, and finish at the latest `Shipping Date` value. The following DAX function was used to initialise the Dates table:

Dates = DATESBETWEEN(Orders[Order Date], [Overall Start of Year of Orders], [Overall End of Year of Shipping])

The columns `Order Start of Year` and `Shipping End of Year` were added to the `Orders` table, to facilitate this calculation.

The following columns were also generated:
- Day of Week = FORMAT(WEEKDAY(Dates[Date], 2), "DDDD")
- Month Number = MONTH(Dates[Date])
- Month Name = FORMAT(Dates[Date], "MMMM")
- Quarter = QUARTER(Dates[Date])
- Year = YEAR(Dates[Date])
- Start of Year = STARTOFYEAR(Dates[Date])
- Start of Quarter = STARTOFQUARTER(Dates[Date])
- Start of Month = STARTOFMONTH(Dates[Date])
- Start of Week = Dates[Date]+1-WEEKDAY(Dates[Date]-1)

### Data Model
The data model is visible below:
[Screenshot of Data Model]

As shown in the above screenshot, the star data model is used, with the `Orders` table as the fact table, and `Customers`, `Products`, and `Stores` as dimension tables. The following one-to-many relationships were modeled:
- (One) Products[product_code] > (Many) Orders[product_code]
- (One) Stores[store code] > (Many) Orders[Store Code]
- (One) Customers[User UUID] > (Many) Orders[User ID]
- (One) Date[date] > (Many) Orders[Order Date]
- (One) Date[date] > (Many) Orders[Shipping Date]

### Measures
A `Measures` table was created to hold all measures that would be created for this project. The following measures were created at the beginning of the project:
- Total Orders = COUNT(Orders[Order Date])
- Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
- Total Profit = SUMX(Orders, Orders[Product Quantity] * (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])))
- Total Customers = DISTINCTCOUNT(Orders[User ID])
- Total Quantity = SUM(Orders[Product Quantity])
- Profit YTD = TOTALYTD('Measures Table'[Total Profit], Orders[Order Date])
- Revenue YTD = TOTALYTD('Measures Table'[Total Revenue], Orders[Order Date])

### Hierarchies
The `Dates` hierarchy (part of the `Dates` table) is as follows:
- `Start of Year`
- `Start of Quarter`
- `Start of Month`
- `Start of Week`

The `Geography` hierarchy (part of the `Stores` table) is as follows:
- `World Region`
- `Country`
- `Country Region`

## Customer Detail Page

## Executive Summary Page

## Product Detail Page

## Stores Map Page

## Cross-Filtering and Navigation

### Cross-Filtering
The following instances of cross-filtering between visuals were blocked:
- 

### The Navigation Bar
