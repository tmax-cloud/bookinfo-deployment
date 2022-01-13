## 스프링부트 설정

---

### 바로가기

1. [k8s 환경변수 설정](#k8s-환경변수-applicationproperties-설정)
2. [application.properties (application.yaml) 설정](#applicationproperties-applicationyaml-설정)
3. [다른 서비스 연결](#다른-서비스-연결)

---

### k8s 환경변수 (application.properties )설정

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bookinfo-core
spec:
  selector:
    matchLabels:
      app: bookinfo-core
  replicas: 1
  template:
    metadata:
      labels:
        app: bookinfo-core
    spec:
      containers:
        - name: bookinfo-core
          image:  tmaxcloudck/bookinfo-core
          imagePullPolicy: Always
          envFrom: 
          - configMapRef:
              name: bookinfo-core
          volumeMounts: 
          - name: app-properties
            mountPath: /app/application.properties
            subPath: application.properties
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
      volumes:
      - name: app-properties
        configMap:
          name: bookinfo-core-app-properties
```



---

### application.properties (application.yaml) 설정

```properties

logging.level.org.springframework.jdbc.core=DEBUG

# 서비스 명 
spring.application.name=bookinfo-core

# 연결된 다른 서비스 
upstream.rating=http://bookinfo-rating:8080

# DB config
spring.datasource.url=jdbc:postgresql://${DB_HOSTNAME}:${DB_PORT}/${DB_DATABASE}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASS}
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.generate-ddl=true
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=create-drop

# kafka config
spring.kafka.bootstrap-servers=${KAFKA_BOOTSTRAP_HOST}:${KAFKA_BOOTSTRAP_PORT}
spring.kafka.consumer.group-id=book
spring.kafka.consumer.auto-offset-reset=earliest
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer

# jaeger config
opentracing.jaeger.udp-sender.host=${JAEGER_AGENT_HOST}
opentracing.jaeger.udp-sender.port=${JAEGER_AGENT_PORT}
opentracing.jaeger.log-spans=true

```

---

### 다른 서비스 연결

```java
@RestController
@RequestMapping("/api")
public class BookController {

    private static final Logger log = LoggerFactory.getLogger(BookController.class);
    private final BookRepository repository;
    // @Value로 읽어오기
    @Value("${upstream.rating}")
    private String ratingSvcAddr;
    
     @GetMapping("/books/{id}")
    BookDetailDto one(@PathVariable Long id) {
        Book book = repository.findById(id)
                .orElseThrow(() -> new BookNotFoundException(id));

        ResponseEntity<RatingDto> response = restTemplate.getForEntity(ratingSvcAddr + "/api/rating/{id}", RatingDto.class, id);
        if (HttpStatus.OK != response.getStatusCode()) {
            log.error("failed to get rating");
        }
        return convertToDetailDto(book).setRating(response.getBody().getScore());
    }

}
```

