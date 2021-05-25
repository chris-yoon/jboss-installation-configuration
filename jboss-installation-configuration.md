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

### multi instances

```
-- Copy the standalone folder and its contents
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

## JBOSS 실행

이 문서에서는 JBOSS 서버 아이피가 172.30.1.43 라고 가정한다.
Standalone mode로 Server를 실행하려면 $HOME/bin/standalone.sh를 실행한다.

```
-- standalone 외부에서 접속 가능한 IP 바인딩 (http://172.30.1.43:9990)
/bin/./standalone.sh -b=172.30.1.43 -bmanagement=172.30.1.43

-- standalone 여러개의 인스턴스 실행할 때
-- jboss-instance-2/bin 에서 다음 포트 충돌을 피하기 위해 port-offset=100 옵션으로 실행 (http://172.30.1.43:10090)
/bin/./standalone.sh -b=172.30.1.43 -bmanagement=172.30.1.43 -Djboss.socket.binding.port-offset=100

-- standalone-full-ha 로 프로파일 변경
/bin/./standalone.sh -c standalone-full-ha.xml -b=172.30.1.43 -bmanagement=172.30.1.43 -Djboss.socket.binding.port-offset=100
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

### Clustering Guide

> https://docs.jboss.org/jbossas/docs/Clustering_Guide/4/html-single/

### Start JBoss as a service

```
/bin/sudo service standalone.sh

```

## Shutdown

```
/bin/./jboss-cli.sh --connect --controller=172.30.1.43:9990 command=:shutdown

```

## Shell Script 생성 (start, kill, tail)

```
-- start.sh
/bin/./standalone.sh -b=172.30.1.43 -bmanagement=172.30.1.43

-- kill.sh
/bin/./jboss-cli.sh --connect --controller=172.30.1.43:9990 command=:shutdown

-- tail.sh

-- chmod
chmod +x *.sh

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
            <inet-address value="${jboss.bind.address.management:172.30.1.43}" />
        </interface>
        <interface name="public">
            <inet-address value="${jboss.bind.address:172.30.1.43}" />
        </interface>
    </interfaces>
```

### Port Setting

만약 JBOSS 인스턴스를 2개를 돌리려면 최소한 http, https, management-http, management-https 를 변경해야 한다.

```
-- standalone.xml
    <socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
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

웹애플리케이션을 JBoss 서버에 배포하는 방법은 2가지가 있다.

> 1. http://172.30.1.43:9990/ 관리자페이지에 접속하여 Deployments 탭에서 war 파일을 업로드한다.
> 2. war 파일을 직접 /standalone/deployments 폴더에 업로드한다. The standalone/deployments directory in the JBoss Application Server distribution is the location end users can place their deployment content (e.g. war, ear, jar, sar files) to have it automatically deployed into the server runtime.

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

위와 같이 설정된 애플리케이션은 http://172.30.1.43:8080/ 으로 접근할 수 있다.

```
<!-- jboss-web.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
	<context-root>/demo</context-root>
</jboss-web>
```

위와 같이 설정된 애플리케이션은 http://172.30.1.43:8080/demo 로 접근할 수 있다.
