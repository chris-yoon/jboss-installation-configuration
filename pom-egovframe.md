# 전자정부 표준프레임워크 pom.xml

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

## jboss-web.xml 추가

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
