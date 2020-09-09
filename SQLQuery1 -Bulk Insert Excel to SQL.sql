
--- Bulk Insert Data into SQL Server

---Create a database with name "SalesRecords"

Create Database SalesRecords

--- Instruct the Database to use what you have created

Use SalesRecords

--- Create Table for the Database already created

CREATE TABLE [dbo].[Sales](
   [Region] [varchar](50) ,
   [Country] [varchar](50) ,
   [ItemType] [varchar](50) NULL,
   [SalesChannel] [varchar](50) NULL,
   [OrderPriority] [varchar](50) NULL,
   [OrderDate]  datetime,
   [OrderID] bigint NULL,
   [ShipDate] datetime,
   [UnitsSold]  float,
   [UnitPrice] float,
   [UnitCost] float,
   [TotalRevenue] float,
   [TotalCost]  float,
   [TotalProfit] float,
   [Created Date] datetime
)	

--- write the bulk insert script to import the data from excel to the SQL server

BULK INSERT Sales
FROM 'C:\Windows\Temp\Sales Record\1500000 Sales Records.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='\n',
    BATCHSIZE=250000,
	MAXERRORS= 2
    	);	

--- The script above will give error since there is a field/column will create that is not in the original dataset

--- We set maximum error to 2


--- let's create a view that has a schema identical to the source file, as shown below

--- I have named the view SalesView, 
--- so that during the load we can be sure that we are using the view to bulk load the data and not the actual table

CREATE VIEW SalesView
  AS SELECT
   Region, 
   Country,
   ItemType,
   SalesChannel,
   OrderPriority,
   OrderDate,
   OrderID,
   ShipDate,
   UnitsSold,
   UnitPrice,
   UnitCost,
   TotalRevenue,
   TotalCost,
   TotalProfit from Sales
   

--- After creating the view, run the same script again, but first change to the view name instead of the table name
--- Once you execute the script, it may take a few seconds and you will see the data getting loaded in increments of 250,000
--- This is an effect of the BATCHSIZE parameter that we specified while executing the BULK INSERT statement.

   BULK INSERT SalesView
   FROM 'C:\Windows\Temp\Sales Record\1500000 Sales Records.csv'
   WITH 
		 (FIRSTROW = 2,
         FIELDTERMINATOR = ',',
         ROWTERMINATOR='\n',
		 BATCHSIZE=250000,
	     MAXERRORS= 2
                  );

 SELECT * FROM Sales

 --- After the data is inserted you can select a few records and you will find that the data was loaded as expected and
 --- the created date field has empty values, as we neither provided a default value for it nor a computed formula.