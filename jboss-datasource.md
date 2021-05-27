# Add datasource via jboss-cli

## 1. Connect CLI

```
./jboss-cli.sh --connect controller=127.0.0.1:9990

[standalone@172.0.0.1:9000 /]
```

## 2. Install jdbc.jar

```
module add --name=MODULE_NAME --resources=PATH_TO_RESOURCE --dependencies=DEPENDENCIES

-- Oracle
module add --name=com.oracle --resources=/opt/ojdbc6.jar --dependencies=javax.api,javax.transaction.api

-- Postgresql
module add --name=org.postgres --resources=~/Downloads/postgresql-9.4-1201.jdbc4.jar --dependencies=javax.api,javax.transaction.api
```

## 3. Add the driver to the datasources subsystem

```
-- Oracle
/subsystem=datasources/jdbc-driver=oracle:add(driver-name=oracle,driver-module-name=com.oracle,driver-xa-datasource-class-name=oracle.jdbc.xa.client.OracleXADataSource)

-- Postgresql
/subsystem=datasources/jdbc-driver=postgres:add(driver-name=postgres,driver-module-name=org.postgres,driver-class-name=org.postgresql.Driver)
```

## 4. Create the datasource that uses the JDBC driver installed

```
data-source add --name=DATASOURCE_NAME --jndi-name=JNDI_NAME --driver-name=DRIVER_NAME  --connection-url=CONNECTION_URL

-- Oracle
data-source add --name=OracleDS --jndi-name=java:jboss/datasources/OracleDS --driver-name=oracle --connection-url=jdbc:oracle:thin:@localhost:1521:XE --enabled=true --user-name=admin --password=admin123 --min-pool-size=5 --max-pool-size=30 --use-java-context=true

-- Postgresql
data-source add --name=PostgresPool --jndi-name=java:/PostgresDS --driver-name=postgres --connection-url=jdbc:postgresql://localhost:32770/demo1 --user-name=postgres --password=postgres123
```

## 5.Test

We can test it by going into the management console for Jboss

> Configuration > Subsystems > Datasources > click [View] button
