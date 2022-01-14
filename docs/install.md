# Installation

## Prerequisites
1. [Install Istio](https://github.com/tmax-cloud/install-istio)
2. [Install ArgoCD](https://github.com/tmax-cloud/install-argocd)
3. [Install Argo Rollouts](https://github.com/tmax-cloud/install-argo-rollouts)

## 1. 배포

1. Fork git repository 

   https://github.com/tmax-cloud/bookinfo-deployment 에 접속 후 레포를 fork한다.

2. 배포 설정

    1. 아래 폴더 목록의 포함된 values-XXX.yaml을 참고하여 환경에 맞게 수정한다.

       * apps
       * helm-core-rollouts
       * helm-rating-rollouts
       * helm-payment-rollouts
       * helm-kafka
       * helm-istio

    2. 수정된 파일들을 commit & push 한다.

3. Service mesh 배포
   1. ArgoCD 서버에 접속한다.
   2. 왼쪽 상단에 "+ NEW APP" 버튼을 눌러 각 Micro Service들의 Application을 생성.
   3. 각 항목을 다음 처럼 채우고, 왼쪽 상단에 Create을 클릭한다.
   
       * GENERAL
           * Application Name : apps
           * Project: default
           * SYNC POLICY: Manual
    
       * SOURCE
           * Repository URL: https://github.com/tmax-cloud/bookinfo-deployment.git
           * Revision : main
           * Path : apps
    
       * DESTINATION
           * Cluster URL: https://kubernetes.default.svc
           * Namespace: staging, 혹은 ops
               * 이미 해당 클러스터에 동일한 네임스페이스가 존재해야 함
               * `kubectl label namespace <name> istio-injection=enabled`을 통해 해당 네임스페이스에서 istio 활성화

   4. 생성된 apps를 Sync
   
      ![image](https://github.com/tmax-cloud/bookinfo-deployment/blob/main/img/1.png)
   
      ![image](https://github.com/tmax-cloud/bookinfo-deployment/blob/main/img/2.png)
   
   5. apps를 통해 생성된 다른 애플리케이션들 Sync
   
      ![image](https://github.com/tmax-cloud/bookinfo-deployment/blob/main/img/3.png)
                                                
   6. 모든 서비스가 정상적으로 배포되었는지 확인
   
      ![image](https://github.com/tmax-cloud/bookinfo-deployment/blob/main/img/4.png)

4. Payment 서비스 기동 (External 서비스)

    ```bash
    docker run -d -p 80:8080 -e UPSTREAM_ORDER=<bookinfo_ingress_gateway_url> tmaxcloudck/bookinfo-payment
    ```
   
5. API 호출을 통해 서비스 잘 되는지 확인