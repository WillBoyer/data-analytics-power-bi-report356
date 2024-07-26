## Importing Data into Power BI
### Orders
The Orders table was imported from an Azure SQL database using the 'Get Data' function in Power BI. Note that the credentials for the Azure DB did not work until the database name was omitted from the credentials window.

Both the `Order Date` and `Shipping Date` columns of the `Orders` table, which each show both date and time, were split into separate columns: `Order Date`, `Order Time`, `Shipping Date`, and `Shipping Time`.

Any rows with null or missing values were also removed, by entering the Power Query Editor and selecting 'Reduce Rows' > 'Remove Rows' > 'Remove Blank Rows'

### Products


### Stores


### Customers


## Creating the Data Model

### Creating a Date Table
- Needed to add STARTOFYEAR and ENDOFYEAR Columns temporarily, to calculate a date-table