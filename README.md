# sql-walkthrough-spotify

Hello! This is a SQL walkthrough using a Spotify database in Postgres. 

The walkthrough will show you how to access the Postgres database in a Jupyter Notebook using ipython-sql, sqlalchemy, and psycopg2. 

![Spotify Postgres ERD](Data/Spotify_Database_ERD.png)


## The Data
The data is coming from Yamac Eren Ay on Kaggle: 
https://www.kaggle.com/datasets/yamaerenay/spotify-dataset-19212020-600k-tracks

There are two csv files, artists and tracks. Before these can be added to a database, a little preprocessing is needed. This includes changing data types and filtering the results. To help reduce the file sizes, I will filter for artists with at least 5000 followers, and tracks from 2011 to now with at least a popularity of 50. Additionally, the artists and tracks files have columns that include lists. Relational databases don't work well with lists, so these should be expanded out to form their own tables that will have many-to-one relationships with the originals. 


## The Database

### QuickDBD

https://app.quickdatabasediagrams.com/#/

Make the ERD. Can also export the PostgreSQL file to create the tables in our database. 

### pgAdmin - CREATE, DROP, and BACKUP DATABASE

To create a new database in postgres you can use pgAdmin. Go to Object, Create, and Database. To drop a database in pgAdmin, right click on the database and select Delete/Drop. If you need to backup a database, then right click on it and select Backup. 

Once created, the sql file exported from QuickDBD can be loaded into the Query Editor and run to create the tables. The database can be viewed in pgAdmin, and under Schemas you can find the tables which show all of their information, including columns and constraints. Import the csv files created above into their respective tables by right clicking on the table name and going to import/export. Select import at the top, select the filename, format, encoding, whether it has a header, and which columns you want to import. Make sure to import the tables with primary keys first (top_artists, top_tracks), and then the tables with foreign keys connecting to them (artist_genre, artist_track). 

### Connecting to the Database

To start, you'll want to download (pip install):
- ipython-sql - to get the %sql and %%sql magic commands
- sqlalchemy - which is a python SQL toolkit
- Psycopg2 - communicates your SQL statements to your postgres database 
    
Next, load the ipython-sql extension and use the magic command to connect to the Postgres database
- The database URL for sqlalchemy is: dialect+driver://username:password@host:port/database 


## Table Queries

### CREATE TABLE Statement
Used to create a new table in a database.
- The table has a tablename, columns, and table constraints. 
- Each column has a column name, a data type, and column constraints.
- The data type is what values a column can hold like - INTEGER, REAL, DATE, VARCHAR(max lenght), TEXT, etc

#### Constraints
These can be specified when the table is made or altered
- NOT NULL - Ensures that a column cannot have a NULL value.
- UNIQUE - Ensures that all values in the column are different. 
- PRIMARY KEY - A combination of NOT NULL and UNIQUE. A table can only have one primary key, which can be made of multiple fields (composite key). 
- FOREIGN KEY - Uniquely identifies a row in another table, thus links two tables together. A table can have multiple foreign keys. 
    - ON DELETE SET NULL - If something is deleted, the foreign key associated will be set to null.
    - ON DELETE CASCADE - if we delete something the primary key rows associated will be deleted. 
- CHECK - Ensures that all values in a column satisfy a boolean expression condition. 
- DEFAULT - Sets a default value for a column when no value is specified. 
- INDEX - Used to create and retrieve data from the database very quickly. 
- AUTO_INCREMENT - Allows a unique number to be generated automatically when a new record is inserted into a table.

### DROP TABLE Statement
Used to drop an existing table. Be careful with this. 
- Alternatively, TRUNCATE TABLE tablename;  - To delete the info in the table. 

###  ALTER TABLE Statement
Used to add, delete, or modify columns in an existing table.
- Also used to add and drop various constraints on an existing table. 


## Querying the Database to Select Information from a Single Table

### SELECT & LIMIT
To look at one or more columns from a table. Use * to represent all of the columns.

- The LIMIT command will determine how many entries are shown, which is important for large datasets
- Leave it out if you want to see all of the entries

### Comments
SQL comments are used if you ever need to explain a SQL statement, or to prevent execution of a statement
- -- Single line comments, anything from it to the end of the line will be ignored
- /* multi line comments */ can be used to comment out multiple lines or part of a line

### WHERE
Used to select records that fulfill some condition 
- Uses =, >, <, >=, <=, <>, IN, BETWEEN, LIKE
- Can be combined with AND, OR, and NOT operators, which can be combined: WHERE NOT, AND NOT, OR NOT
- The IN operator allows you to specify multiple values in the WHERE clause.
- The BETWEEN operator allows you to select values within a given range. Values can be numbers, text, or dates. 
- The LIKE operator allows you to search for a specified pattern in a column by using wildcards. 
    - Wildcards are used to substitute one or more characters in a string. 
    - Two or more wildcards are often used and can be used in combination.
    - %  Represents zero, one, or multiple characters.
    - _  Represents a single character. 

### ORDER BY
Allows for sorting the results by a specified column
- Sort by ascending (default) - ASC, and descending - DESC
- Can order by multiple columns if there are two results with the same value

### Aliases
Can be used to give a table or a column a temporary name. This can make them more readable, and only exists during that query. 
- To do this write the column or table and then write AS new_name
- Can combine multiple columns using CONCAT(column, column2) AS new_name
- Can also add the table name in front of the column name to make them more clear when querying mult tables - table.column

### Aggregate Functions
Can be used on a column in a table to perform some additional computation and return a single value.
- MIN()  Returns the smallest value of the selected column.
- MAX()  Returns the largest value of the selected column.
- COUNT()  Returns the number of rows that matches a specified criteria - NULL not counted. 
- AVG()  Returns the average value of a numeric column - NULL values ignored.
- SUM()  Returns the total sum of a numeric column - NULL values ignored. 
- ROUND(,2) Can be combined with other aggregate functions. Rounds to the specified number of places.

### GROUP BY
Groups rows that have the same values into summary rows, like average loudness per genre.
- It's often used with aggregate functions (MIN, MAX, COUNT, AVG, SUM) to group the result-set by one or more columns.

### HAVING Clause 
Added because the WHERE keyword can not take aggregate functions


## Querying Information from Multiple Tables and Combining the Results
Thus far we have only queried information from one table at a time, but there are multiple tables in a dataset. To query information from multiple tables and combine the results there are a few options: 
- Use information from one table to search in another, using the same column.
- Combine rows and columns from two or more tables, based on a shared column.
- Combine the result-set of tables if they have the same number of columns, similar datatypes, and are in the same order.

### NESTED QUERIES
Uses WHERE and IN with a query from one table in order to use that information to search the same column in another table.

### JOIN Clause 
Used to combine rows from two or more tables, based on a shared column

- (INNER) JOIN - Returns records that have matching values in both tables.
- LEFT (OUTER) JOIN - Returns all records from the left table, and matching records from the right table.
- RIGHT (OUTER) JOIN - Returns all records from the right table, and matching records from the left table.
- FULL (OUTER) JOIN - Returns all records when there is a match in either left or right table. 

### UNION Operator
Used to combine the result-set of two or more SELECT statements.
- Must have the same number of columns and similar data types, and be in the same order.


## Change the Contents of a Table

### INSERT INTO
Inserts new records into a table. May need to insert some values as null when creating your table if a value that's referenced hasn't been made yet. 

Can also copy data from one table and insert it into another table. This can be useful when creating a new table to extract a file from.
- This requires that the data types in source and target tables match. 
- The existing records are unaffected. 

### UPDATE
Used to modify existing records in a table. 
- It's important to be careful about which records are updated in the WHERE clause. If this is missing, then all the values will be updated.

### DELETE
Used to delete existing records in a table. 
