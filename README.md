# Database migration: Convert SQL Server Table Schemas To Liquibase Changelog

This project is intended to aid migrating existing database table schemas to a new database engine.

It ingests the SQL Server information schema to produce a change log file for Liquibase to deploy to your target database.

As Liquibase can deploy to many database engines this tool is currenlty one to many, of SQL Server to all SQL engines Liquibase can work with. An example has been included to migrate and deploy to a containerised postgres instance.

## Requirements

Python 3
Liquibase
cmdsql CLI
psql CLI

## Acquiring the information schema

The conversion tool requires the output of `export_information_schema.sql`, I would suggest you follow the example below with the containerised SQL Server instance, if you wish to run it directly against your database, export the response of the query as a csv file and if there is a delimiting line between the header and rows, remove it. If you have the information schema exported with the filename `schema.csv`, run:

## Generating the ChangeLog file

```bash
python3 -m venv .venv
pip3 install --requirement requirements.txt
source .venv/bin/activate 
python3 convert.py
```

And the Liquibase changelog file will be generated. If you need to generate `schema.csv` continue on.

To test end to end, run the docker container below, create a few tables and then export the information schema. Note you will need sqlcmd CLI installed to your machine.


[Here're the MS docs on containerized SQL Server if you get stuck](
https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&pivots=cs1-bash)

Download, start and exec in to the container:

```bash
docker compose up -d
```

If you have installed sqlcmd, run the setup script to create the rest database and tables:

```bash
sqlcmd -S localhost -U SA -P Migrationmaster0 -i setup.sql
```

Export the `INFORMATION_SCHEMA` to `schema.csv` with:

```bash
sqlcmd -S localhost -U SA -P Migrationmaster0 -d TestDB -i export_information_schema.sql -o "schema.csv" -s "," \
&& sed -i '' '2d' schema.csv
```

Annoyingly SQL Server exports an additional row to separate the header from actual data, we want removed that second delimiting row using sed.

At this point you should have the information schema in a useable format, run the python scrip as above.

To test deploying liquibase we will connect to the containerised postgres instance:

```bash
psql postgresql://postgres:postgres@localhost:5432/postgres
create database "TestDB";
 \c "TestDB"
 \dt
 exit
```

Deploy Liquibase:

```bash
liquibase update
```

Back in Postgres you can see the new tables using:

```bash
psql postgresql://postgres:postgres@localhost:5432/postgres
 \c "TestDB"
 \dt
```
