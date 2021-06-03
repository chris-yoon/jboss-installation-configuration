# Spring Boot Application pom.xml

Spring Boot Aplication을 Spring Boot 내장 WAS tomcat을 사용하지 않고 JBOSS에 배포할 경우,
다음과 같이 tomcat의 의존성을 제거하고, servlet 추가한다.

JavaServlet dependency는 다음 URL에서 확인할 수 있다.

> https://mvnrepository.com/artifact/javax.servlet/servlet-api/2.5

```
	<dependencies>
    <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>

			<exclusions>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-tomcat</artifactId>
				</exclusion>
				<exclusion>
					<groupId>ch.gos.logback</groupId>
					<artifactId>logback-classic</artifactId>
				</exclusion>
			</exclusions>

		</dependency>
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>javax.servlet-api</artifactId>
			<scope>provided</scope>
		</dependency>
```
