# Example

[From the MS docs](
https://learn.micr)osoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&pivots=cs1-bash

Download and start the container:

```bash
docker compose up
```

```bash
docker exec -it sql-server-db "bash" 
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Migrationmaster0
```

CREATE DATABASE TestDB;
SELECT Name from sys.databases;
USE TestDB;
GO

CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT);
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
SELECT * FROM Inventory ;
GO

CREATE TABLE Books(Id INT PRIMARY KEY IDENTITY(1,1), Name VARCHAR (50) NOT NULL, Price INT);
GO

sqlcmd -S localhost -U SA -P Migrationmaster0 -d TestDB -Q "SET NOCOUNT ON; SELECT * FROM INFORMATION_SCHEMA.COLUMNS" -o "schema.csv" -s","
sed -i '' '2d' schema.csv

python3 -m venv .venv
pip3 install --requirement requirements.txt
source .venv/bin/activate 
