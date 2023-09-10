# Database migration: Convert SQL Server Table Schemas To Liquibase Changelog

This project is intended to aid migrating existing database table schemas to a new database engine.

It uses ingests the SQL Server information schema to produce a change log file for Liquibase to deploy to your target database.

As Liquibase can deploy to many database engines this tool is currenlty one to many, of SQL Server to all SQL engines Liquibase can work with.

If you have the information schema exported already with the filename `schema.csv`, run:

```bash
python3 -m venv .venv
pip3 install --requirement requirements.txt
source .venv/bin/activate 
python3 convert.py
```

And the Liquibase changelog file will be generated.

To test end to end, run the docker container below, create a few tables and then export the information schema. Note you will need sqlcmd CLI installed to your machine.


[Here're the MS docs on containerized SQL Server if you get stuck](
https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&pivots=cs1-bash)

Download, start and exec in to the container:

```bash
docker compose up -d
```

If you have installed sqlcmd, run the setup script to create the rest database and tables:

```bash
sqlcmd -S localhost -U SA -P Migrationmaster0 -d TestDB -i setup.sql
```

Export the `INFORMATION_SCHEMA` to `schema.csv` with:

```bash
sqlcmd -S localhost -U SA -P Migrationmaster0 -d TestDB -Q "SET NOCOUNT ON; SELECT * FROM INFORMATION_SCHEMA.COLUMNS" -o "schema.csv" -s","
```

Annoyingly SQL Server exports an additional row to separate the header from actual data, we want to remove that second delimiting row with:

```bash
sed -i '' '2d' schema.csv
```

At this point you should have the information schema in a useable format, run the python scrip as above.