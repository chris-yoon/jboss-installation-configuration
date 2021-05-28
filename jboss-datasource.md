# Add datasource via jboss-cli

## 1. Connect CLI

In JBoss EAP 6.4 we use port 9990 for HTTP management (web-based management console) and port 9999 for native management (management CLI)

```
./jboss-cli.sh --connect controller=127.0.0.1:9999

[standalone@172.0.0.1:9999 /]
```

JBoss EAP 7.x uses port 9990 for both native management, used by the management CLI, and HTTP management, used by the web-based management console

```
./jboss-cli.sh --connect controller=127.0.0.1:9990

[standalone@172.0.0.1:9990 /]
```

## 2. Install jdbc.jar

```
module add --name=MODULE_NAME --resources=PATH_TO_RESOURCE --dependencies=DEPENDENCIES

-- Oracle (The 11g driver ojdbc6.jar certified for JDK6+, the 12c driver ojdbc7.jar certified with JDK7+)
module add --name=com.oracle --resources=/opt/ojdbc6.jar --dependencies=javax.api,javax.transaction.api
module add --name=com.oracle --resources=/opt/ojdbc7.jar --dependencies=javax.api,javax.transaction.api

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

> Configuration > Subsystems > Datasources > OracleDS click [Test Connection] button
> or, run this line in jboss-cli:

```
/subsystem=datasources/data-source=OracleDS:test-connection-in-pool
```
