# JBOSS 6.4 Installation and Configuration

## JBOSS 6.4 Installation

```
-- installer
java -jar jboss-eap-6.4.0-installer.jar -console
-- installer automatic installation
java -jar jboss-eap-6.4.0-installer.jar auto.xml
java -jar jboss-eap-6.4.0-installer.jar http://network-host/auto.xml
java -jar jboss-eap-6.4.0-installer.jar ftp://network-host/auto.xml
-- unzip
unzip jboss-eap-6.4.0.zip
```

### Add user

Add a Management User (mgmt-users.properties)

```
./add-user.sh
```

### Multi instances

Copy the standalone folder and its contents

```
cp -r jboss-instance-1 jboss-instance-2
```

## JBOSS deletion

The JBoss Application Server may be uninstalled by simply deleting the JBoss Application Server's installation directory.

```
rm -rf [directory-name]
-- e.g.
rm -f jboss-eap-6.4

-- uninstaller
java -jar uninstaller.jar
```

## Starting JBOSS

Standalone mode로 Server를 실행하려면 $JBOSS_HOME/bin/standalone.sh를 실행한다.

```
-- standalone 외부에서 접속 가능한 IP 바인딩 (http://127.0.0.1:9990)
./standalone.sh -b=127.0.0.1 -bmanagement=127.0.0.1

-- standalone 여러개의 인스턴스 실행할 때
-- jboss-instance-2/bin 에서 다음 포트 충돌을 피하기 위해 port-offset=100 옵션으로 실행 (-> http://127.0.0.1:10090)
./standalone.sh -b=127.0.0.1 -bmanagement=127.0.0.1 -Djboss.socket.binding.port-offset=100

-- standalone-full-ha 로 프로파일 변경
./standalone.sh -c standalone-full-ha.xml -b=127.0.0.1 -bmanagement=127.0.0.1 -Djboss.socket.binding.port-offset=100
```

### Difference between standalone mode and domain mode

- standalone.xml: Support of Java EE Web-Profile plus some extensions like RESTFul Web Services and support for EJB3 remote invocations
- standalone-full.xml: Support of Java EE Full-Profile and all server capabilities without clustering
- standalone-ha.xml: Default profile with clustering capabilities
- standalone-full-ha.xml: Full profile with clustering capabilities

### Difference between standalone.xml and standalone-full.xml

- standalone.xml: Support of Java EE Web-Profile plus some extensions like RESTFul Web Services and support for EJB3 remote invocations
- standalone-full.xml: Support of Java EE Full-Profile and all server capabilities without clustering
- standalone-ha.xml: Default profile with clustering capabilities
- standalone-full-ha.xml: Full profile with clustering capabilities

## Stopping JBOSS

In JBoss EAP 6.4 we use port 9990 for HTTP management (web-based management console) and port 9999 for native management (management CLI)
JBoss EAP 7 uses port 9990 for both native management, used by the management CLI, and HTTP management, used by the web-based management console

```
-- Port 9999 should be used in JBOSS EAP 6.4
./jboss-cli.sh --connect --controller=127.0.0.1:9999 command=:shutdown

-- Port 9990 should be used in JBOSS EAP 7.x
./jboss-cli.sh --connect --controller=127.0.0.1:9990 command=:shutdown

```

## Shell Script 생성 (start, kill, tail)

```
-- start.sh
./standalone.sh -b=127.0.0.1 -bmanagement=127.0.0.1
-- start.sh (with port and port offset)
./standalone.sh -b=127.0.0.1 -bmanagement=127.0.0.1 -Djboss.http.port=8080 -Djboss.socket.binding.port-offset=100

-- kill.sh (JBOSS EAP 6.4)
./jboss-cli.sh --connect --controller=127.0.0.1:9999 command=:shutdown
-- kill.sh (JBOSS EAP 7.x)
./jboss-cli.sh --connect --controller=127.0.0.1:9990 command=:shutdown

-- tail.sh
tail -f $JBOSS_PATH/standalone/log/server.log

-- chmod
chmod +x *.sh
```

### start.sh

```
#!/bin/sh

JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
IP_ADDR=127.0.0.1
HTTP_PORT=80
PORT_OFFSET=0

# Starts the JBoss instance.
# Redirects console log to /dev/null to avoid spamming the shell.
start(){
  echo "Starting jboss..."
  $JBOSS_PATH/bin/standalone.sh -Djboss.bind.address=$IP_ADDR -Djboss.bind.address.management=$IP_ADDR -Djboss.http.port=$HTTP_PORT -Djboss.socket.binding.port-offset=$PORT_OFFSET> /dev/null 2>&1 &
}

start

exit 0
```

### kill.sh

```
#!/bin/sh

JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
IP_ADDR=127.0.0.1
PORT_OFFSET=10

# calculate new management port
MGMT_PORT=`expr 9990 + $PORT_OFFSET`

# Gracefully stops JBoss instance via management CLI interface.
stop(){
  echo "Stopping jboss..."
  sh $JBOSS_PATH/bin/jboss-cli.sh --connect controller=$IP_ADDR:$MGMT_PORT command=:shutdown
  if [ $? -ne 0 ]
    then echo "Failed to gracefully stop JBoss."
  fi
}

stop

exit 0
```

### tail.sh

```
#!/bin/sh

JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance

# Tails JBoss log to console.
log(){
  echo "Tailing jboss log..."
  tail -f $JBOSS_PATH/standalone/log/server.log
}

log

exit 0
```

## JBOSS 설정

### IP Setting

```
-- Check IP Address
ifconfig -a
ifconfig eth0
ip addr show eth0

-- standalone.xml
    <interfaces>
        <interface name="management">
            <inet-address value="${jboss.bind.address.management:127.0.0.1}" />
        </interface>
        <interface name="public">
            <inet-address value="${jboss.bind.address:127.0.0.1}" />
        </interface>
    </interfaces>

-->

    <interfaces>
        <interface name="management">
            <inet-address value="${jboss.bind.address.management:127.0.0.1}" />
        </interface>
        <interface name="public">
            <inet-address value="${jboss.bind.address:127.0.0.1}" />
        </interface>
         <interface name="any">
            <!-- Use the wildcard address -->
            <any-address />
        </interface>
   </interfaces>
```

### Port Setting

default-interface 를 any로 한다.

```
-- standalone.xml
    <socket-binding-group name="standard-sockets" default-interface="any" port-offset="${jboss.socket.binding.port-offset:0}">
        <socket-binding name="ajp" port="${jboss.ajp.port:8009}" />
        <socket-binding name="http" port="${jboss.http.port:8080}" />
        <socket-binding name="https" port="${jboss.https.port:8443}" />
        <socket-binding name="management-http" interface="management" port="${jboss.management.http.port:9990}" />
        <socket-binding name="management-https" interface="management" port="${jboss.management.https.port:9993}" />
        <socket-binding name="txn-recovery-environment" port="4712" />
        <socket-binding name="txn-status-manager" port="4713" />
        <outbound-socket-binding name="mail-smtp">
            <remote-destination host="localhost" port="25" />
        </outbound-socket-binding>
    </socket-binding-group>
```

## Deployment

웹애플리케이션을 JBoss 서버에 배포하는 방법은 4가지가 있다.

> 1. http://127.0.0.1:9990/ 관리자페이지에 접속하여 Deployments 탭에서 war 파일을 업로드한다.
> 2. war 파일을 직접 /standalone/deployments 폴더에 업로드한다. The standalone/deployments directory in the JBoss Application Server distribution is the location end users can place their deployment content (e.g. war, ear, jar, sar files) to have it automatically deployed into the server runtime.
> 3. jboss-cli (recommended)

### Deploy via jboss-cli

Deploying applications via the Management CLI gives you the benefit of single command line interface with the ability to create and run deployment scripts.

```
jboss-cli.sh -c --force --controller=127.0.0.1:9990 --command="deploy /path/to/test-application.war"
```

### 전자정부 표준프레임워크 pom.xml

전자정부 표준프레임워크를 적용한 웹애플리케이션을 빌드할 때 spring-modules-validation 버전을 명시하도록 pom.xml을 수정한다.

```
	<dependencies>
		<!-- 표준프레임워크 실행환경 -->
    <dependency>
			<groupId>egovframework.rte</groupId>
			<artifactId>egovframework.rte.ptl.mvc</artifactId>
			<version>${egovframework.rte.version}</version>
			<exclusions>
				<exclusion>
					<artifactId>commons-logging</artifactId>
					<groupId>commons-logging</groupId>
				</exclusion>
				<exclusion>
					<artifactId>spring-modules-validation</artifactId>
					<groupId>org.springmodules</groupId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>egovframework.rte</groupId>
			<artifactId>spring-modules-validation</artifactId>
			<version>0.9</version>
		</dependency>
```

### jboss-web.xml 추가

/webapp/WEB-INF/jboss-web.xml 파일을 추가하여 빌드한다.

```
<!-- jboss-web.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
	<context-root>/</context-root>
</jboss-web>
```

위와 같이 설정된 애플리케이션은 http://127.0.0.1:8080/ 으로 접근할 수 있다.

```
<!-- jboss-web.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
	<context-root>/demo</context-root>
</jboss-web>
```

위와 같이 설정된 애플리케이션은 http://127.0.0.1:8080/demo 로 접근할 수 있다.
