## istio 

---

### 바로가기

1. [VirtualService 예시](#VirtualService)
2. [DestinationRule 예시](#DestinationRule)
3. [Gateway 예시](#Gateway)
4. [ServiceEntry 예시](#ServiceEntry)

---

## BOOKINFO-istio 설정

### virtualService:

- [bookinfo-core](link), [bookinfo-rating](link), [bookinfo-order](link), [bookinfo-payment](link), [bookinfo-db(postgresSQL)](link), [kafka](link)

### destinationRule

- [bookinfo-rating서비스에 대한 트레픽 정책 설정](https://github.com/tmax-cloud/BookManagementSystem/blob/master/make/kustomize/base/service-mesh/destination-rule.yaml)

### gatway:

- [bookinfo-gateway](https://github.com/tmax-cloud/BookManagementSystem/blob/master/make/kustomize/base/service-mesh/gateways.yaml)

### ServiceEntry

- [payment 외부 서비스를 위한 serviceEntry](https://github.com/tmax-cloud/BookManagementSystem/blob/master/make/kustomize/base/service-mesh/service-entry.yaml)

### EgressGateway

- [payment외부 서비스를 위한 EgressGateway](link)



---



### VirtualService

- 트레픽에 대한 서비스 라우팅 경로 설정 

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo # VirtualService 이름
spec:
  hosts:
   - "bookinfo.172.22.11.21.nip.io" # ex)  서비스 주소: 서비스명.NAMESAPCE명.svc.cluster.local / www.tmaxcloud.org 
  gateways:
  - bookinfo-gateway # "설정한 게이트웨이"
  http:  # Routing 규칙
    - name: rating
        match:
        - uri:
            prefix: /api/rating
        route:
        # 카나리 배포 설정 (50대 50)
        - destination:
            host: bookinfo-rating
            port:
              number: 8080
            subset: v1 # DestinationRule.subsets 참조
          weight: 50 
        - destination:
            host: bookinfo-rating
            port:
              number: 8080
            subset: v2
          weight: 50
```

---

### DestinationRule

- VirtualService에서 사용될 트레픽 정책 수립 
  - rating을 v1과 v2로 분리, 50 대 50으로 loadbalancing

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: ratings
spec:
  host: bookinfo-rating
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

---

### Gateway

- 외부로부터 트래픽 받는 최전선. 
  - 트래픽을 받을 host이름과 포트번호, 프로토콜 정의

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
spec:
  selector:
    app: istio-ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "bookinfo.172.22.11.21.nip.io"
```



---

### [ServiceEntry](https://istio.io/latest/docs/reference/config/networking/service-entry/)

- 외부 서비스 등록하기

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: external-payment
spec:
  hosts:
  - bookinfo-payment.bookinfo-ext.svc.cluster.local
  location: MESH_EXTERNAL
  ports:
  - name: http
    number: 8080
    protocol: HTTP
  resolution: DNS
```



