# Configuration

### Server

+ **`@EnableConfigServer`**
+ application:
```properties
spring.cloud.config.server.git.uri=https://github.com/yoga1290/test-microservices-config
#spring.cloud.config.server.git.uri.searchPaths=
#server.port=8001
```
+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-config-server</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```

### Client

+ bootstrap:
```properties
spring.application.name=name
spring.cloud.config.uri=http://localhost:8001
```

+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-config</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```


# Eureka Service Discovery

### Server

+ **`@EnableEurekaServer`**
+ application:
```properties
#server.port=8010
```
+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```

### Service:

+ **`@EnableDiscoveryClient`**

+ application
```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8010/eureka/
# server.port=${PORT:${SERVER_PORT:0}}
```
+ bootstrap
```properties
spring.application.name=MY-SERVICE-NAME
```

+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```

### Client 

+ **`@EnableDiscoveryClient`**

+ Controller:
```java
@Autowired
DiscoveryClient client;
//...
List<ServiceInstance> list = client.getInstances("MY-SERVICE-NAME");
if (list != null && list.size() > 0 ) {
    URI uri = list.get(0).getUri();
    if (uri !=null ) {
        return (new RestTemplate()).getForObject(uri, MY_OBJECT_CLASS.class);
    }
}
```

+ application
```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8010/eureka/
```

+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```
+ [Ribbon LoadBalancerClient](#ribbon-loadbalancerclient) can be used instead of **DiscoveryClient**


# Ribbon LoadBalancerClient

+ Controller:
```java
@Autowired
LoadBalancerClient client;

//...
ServiceInstance instance = client.choose("MY-SERVICE-NAME");
URI uri = URI.create(String.format("http://%s:%s", instance.getHost(), instance.getPort()));
if (uri !=null ) {
    return (new RestTemplate()).getForObject(uri, MY_OBJECT_CLASS.class);
}
```

+ application
```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8010/eureka/
```

+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-ribbon</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```

# Feign Client

+ Interface to the [service](#service) controller:
```java
@FeignClient("MY-SERVICE-NAME")
public interface MyServiceClient {
    @RequestMapping(method = RequestMethod.GET, value = "/")
    String abc();
}

//...
//@Autowired
//MyServiceClient myServiceClient;
// myServiceClient.abc()
```

+ POM:
```xml
<project>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-ribbon</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-feign</artifactId>
    </dependency>
  </dependencies>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Dalston.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
```
