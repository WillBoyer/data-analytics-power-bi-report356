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

![Data Model]()

## Customer Detail Page
### Headline Card Visuals
Card visuals were created to show the number of unique customers, and the average revenue generated per customer. These visuals were created by selecting "Card" from the "Build" pane, and then dragging-and-dropping the corresponding measure to the card.

### Summary Charts
The "Unique Customers by Country" donut chart was created by selecting "Donut chart" from the "Build" pane, and setting the Legend to "Country" from the "Customers" table, with "Values" set to the "Unique Customers" measure.

The "Unique Customers by Product Category" bar chart was created by selecting "Stacked column chart" from the "Build" pane, and setting the X-axis to "Category" from the "Products" table, with "Y-axis" set to the "Unique Customers" measure.

### Line Charts
The "Unique Customers by Start of Year" line chart was created by selecting "Line chart" from the "Build" pane, and setting the X-axis to "Start of Year/Quarter/Month" from the "Dates" table's Date Hierarchy, with "Y-axis" set to the "Unique Customers" measure.

### Top 20 Customers Table
This table was created by selecting "Table" from the "Build" pane, and then selecting the following fields:
- Full Name (from the Customers table)
- Total Revenue (from the Measures table)
- Total Orders (from the Measures table)

The table is filtered to the top 20 customers in terms of revenue, by selecting the "Full Name" field in the "Filters" pane, changing the "Filter type" drop-down menu to "Top N", setting "Show items" to top 20, and selecting "Total Revenue" for the "By value" setting.

### Top Customer Cards
A new measure was created to return the "Full Name" field of the top customer in terms of revenue. The formula for the measure is:

`Top Customer = CALCULATE(SELECTEDVALUE(Customers[Full Name]), TOPN(1, ALL(Customers), [Total Revenue], DESC))`

Three card visuals were created to display aspects of this "Top Customer":
- Full Name
- Total Orders
- Total Revenue

The "Full Name" field is show by simply dragging-and-dropping the "Top Customer" measure to a new card. The other two fields are created by setting cards to display the corresponding measures, but with a filter. This filter is et similarly to the "Top 20 Customers Table" above, but with the Top 1 instead of Top 20.

### Date Slicer
A new date slicer was created by selecting the "Slicer" option from the "Build" pane, and setting the field to "Year" from the "Dates" table. In "Format" > "Sicer settings" > "Options", "Style" was set to "Between", which allows for a minimum and maximum year to be selected by the user.

![Customer Detail Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Customers.PNG)

## Executive Summary Page
### Card Visuals
Card visuals were created for the following measures:
- Total Orders
- Total Revenue
- Total Profit
- Unique Customers
- Total Quantity
- Revenue YTD
- Profit YTD

These card visuals were created using the same method as the visuals in the "Customer Detail" page.

### Revenue Trending Line Chart
This line chart was created similarly to the line chart on the "Customer Detail" page, with the exception that the Y-axis is set to "Total Revenue" instead of "Unique Customers". Additionally, a trend-line was created with "Format" > "Trend Line" set to "On".

### Donut Charts
The "Total Revenue by Store Type" and "Total Revenue by Country" donut charts were created by selecting "Donut chart" from the "Build" pane, and setting the Legend to "Store Type" and "Country" from the "Stores" table, with "Values" set to the "Total Revenue" measure.

### Bar Chart
The "Total Orders by Product Category" bar chart was created by selecting the "Stacked Bar Chart" option from the "Build" pane. The Y-axis was set to "Category" from the "Products" table, and the X-axis was set to the "Total Orders" measure.

### KPI Visuals
Three KPI visuals were created, to show quarterly performance of Revenue, Profit, and Orders against a target of 5% quarter-on-quarter. These were created by selecting "KPI" from the "Build" pane, and setting the Value to the corresponding Total measure, the Target to the corresponding Quarterly Target, and the Trend axis to "Start of Quarter" from the "Dates" table's Date Hierarchy.

![Executive Summary Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Executive%20Summary.PNG)

## Product Detail Page
### Gauge Visuals
Three Gauge visuals were created to display Total Profit, Revenue, and Orders from the current quarter, compared to a Quarterly target of 10% more than the previous quarter. The Current Quarter performance was set as the Value in each case, while the Quarterly Target was set as the Maximum Value.

Additionally, in Format > Visual > Callout value > Values Color, Conditional Formatting was selected and the following rules were added:
- If value >= Min and < 0 then [Red]
- If value >= 0 and <= Max then [Black]

The values being tracked are the Quarterly Profit/Revenue/Orders Performance measures, which are calculated by subtracting the Current Quarter measure from the corresponding Quarterly Target measure. As a result, if the value is positive, then the quarterly performance exceeds the target, the callout value will be black. Otherwise, the callout value will be red.

### Filter State Cards
Two Card visuals were created to display the Product Category and Country selections chosen from the Slicer Toolbar. The below DAX functions were used to make this possible:
- `Category Selection = IF(ISFILTERED(Products[Category]), SELECTEDVALUE(Products[Category], "No Selection"), "No Selection")`
- `Country Selection = IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country],"No Selection")`

### Area Charts
An area chart was created by selecting "Stacked Area Chart" from the "Build" pane. The X-axis is the "Dates" table's "Start of Quarter" column, the Y-axis is the "Total Revenue" measure, and the Legend is the "Category" column from the "Products" table.

### Top Products Table
The Top 10 Products table is created and filtered in a similar way to the "Top 20 Customers" table in the "Customer Detail" page.

### Scatter Graph
A Scatter Graph was created to show Profit per Item vs Quantity Sold of each Product, with a Legend set to Product Category.

![Product Detail Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Product.PNG)

## Stores Map Page
### Map Visual
The initial Map visual was created by selecting "Map" from the "Build" pane, and setting "Location" to use the "Geography Hierarchy" from the "Stores" table. The "Bubble size" was set to the "Profit YTD" measure.

Additional setting were configured in the Format(Visual) pane, including:
- Category labels > On
- Map settings > Controls > Auto zoom > On
- Map settings > Controls > Zoom buttons > Off
- Map settings > Controls > Lasso button > Off

### Country Slicer
A slicer was added to select country from Germany, UK, and USA, by selecting "Slicer" from the "Build" pane. The Field was set to "Country" from the "Stores" table, and the following formatting was configured in the "Format" pane:
- Slicer settings > Options > Style > Tile
- Slicer settings > Selection > Multi-select with Ctrl > On
- Slicer settings > Selection > Show "Select all" option > On

### Drillthrough Page
A new Drillthrough page was created to display information on any store selected from the Stores Map page.

#### Back Button
A back button to return to the Stores Map page was created using Insert > Elements > Buttons > Back.

#### Store Region Card
This card shows the region location of the store selected on the Stores Map page.

#### Performance Gauges
Two performance gauges display the Profit YTD vs. Profit Goal and Revenue YTD vs. Revenue Goal for the selected store. These have been set to use Profit/Revenue YTD as the Value, and Profit/Revenue Goal as the Target.

#### Bar Chart
A bar chart showing the Total Orders at the selected store, divided by Product Category, was created by selecting "Stacked Column Chart" from the "Build" pane. X-axis was set to "Category" from the "Products" table, and Y-axis was set to the Total Orders measure.

#### Top 5 Products
A table of the Top 5 products by Profit YTD was created in the same manner as the Top 20 Customers table from the Customer Detail page.

### Tooltip Page
A tooltip page was created, to display the Profit YTD vs. Profit Goal when mousing-over any store. This was achieved by clicking "+" at the bottom of the Power BI Desktop window, then selecting Page Information > Page type > Tooltip in the Format pane.

The "Profit YTD and Profit Goal" gauge visual from the Stores Drillthrough page was copied over to this new tooltip page.

Finally, returning to the Stores Map page, in the Format pane for the map visual, Properties > Tooltips > Options > Type > Report Page and Page > Store Tooltip were selected to attach tht new tooltip page.

![Stores Map Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Stores.PNG)

![Stores Drillthrough Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Stores%20Drillthrough.PNG)

![Stores Tooltip Page](https://github.com/WillBoyer/data-analytics-power-bi-report356/blob/main/screenshots/Stores%20Tooltip.PNG)

## Cross-Filtering
The following instances of cross-filtering between visuals were blocked:
- "Executive Summary" page: The "Product Category" bar chart was blocked from affecting all card visuals and KPI line graphs
- "Customer Detail" page:
    - The "Top 20 Customers" table was blocked from filtering all other visuals on the page
    - The "Total Customers by Product" chart was blocked from affecting the "Unique Customers" line graph
- "Products" page: The "Top 10 Products" table was blocked from affecting all card visuals on the page

Cross-filtering is adjusted by selecting the relevant visual in the "Report View", then selecting Format > Edit Interactions from the top ribbon. The cross-filtering settings will then appear for all other visuals on the page.

## The Navigation Bar
On the left-hand side of every page, a navigation bar has been added. The lower end of the navigation bar contains links to each of the other pages in the report.

This was achieved by creating 4 buttons using Insert > Buttons > Blank. The custom button icon was set using Format button > Button style > Icon, where "Icon type" was set to "Custom", and a PNG file was selected. This process was repeated with the setting state set to "Default" (for the button's normal appearance) and "Hover" (for when the user mouses-over the button).

The links betwen report pages were configured by setting Format button > Action > Action > Type to "Page Navigation", and setting "Destination" to each of the pages in the report.


## Database Queries
The connection to the database was made in Visual Studio Code's SQLTools Extension, using the SQLTools PostgreSQL driver.

The questions to be answered by each query, as well as the query itself, are stated in the relevant `.sql` file (e.g. `question_1.sql`). The resulting CSV files are similarly named (e.g. `question_1.csv`)
