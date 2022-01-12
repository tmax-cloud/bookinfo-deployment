# bookinfo-deployment
## 소개 및 시연 관련 설명
* GitOps 기반 ArgoCD를 통해 마이크로서비스 <U>core, order, rating</U>을 배포 및 운영. 
* 해당 Repository에 있는 각 서비스들의 manifest들로부터 ArgoCD의 커스텀리소스인 `Application`을 생성해야 함. 
* 해당 Repository 내에서 Manifest를 수정하면, ArgoCD에 자동으로 반영되는 시스템

## 구성 요소
### App of apps를 위한 매니페스트
* apps
  * 아래 나열된 다른 application을 포함한 application
* helm-core-rollouts
  * Helm 배포가 적용된 Core Rollout 서비스  
* helm-order-rollouts
  * Helm 배포가 적용된 Order Rollout 서비스
* helm-rating-rollouts
  * Helm 배포가 적용된 Rating Rollout 서비스
* helm-kafka
  * Helm 배포가 적용된 Kafka 서비스
* helm-istio
  * Istio Service mesh 구성을 위한 리소스 모음

### 개별 배포용 매니페스트 
* core, order, rating
  * Plain YAML로 작성된 manifest.
* helm-core, helm-order, helm-rating
  * Helm으로 작성된 manifest.
* third-party
  * Plain YAML로 작성된 payment, jaeger, kafka, db, nexus, zookeeper의 manifest.

## Prerequisites
1. ArgoCD
    * install 가이드 : https://github.com/tmax-cloud/install-argocd
2. Argo Rollouts 
    * install 가이드 : 준비 예정
3. 서드 파티 설치
   * 클러스터에 Istio 및 아래 링크를 통해 플러그인 설치
     * https://istio.io/latest/docs/ops/integrations/kiali/
     * https://istio.io/latest/docs/ops/integrations/jaeger/
     * https://istio.io/latest/docs/ops/integrations/prometheus/

## 시나리오
### 1. App of apps
1. ArgoCD 서버에 접속한다. 
2. 왼쪽 상단에 "+ NEW APP" 버튼을 눌러 각 Micro Service들의 Application을 생성.

![image](https://user-images.githubusercontent.com/36444454/147192193-e2614f3d-4343-4893-98a9-5cf65e1bf7fe.png)

3. 각 항목을 다음 처럼 채우고, 왼쪽 상단에 Create을 클릭한다. 

![image](https://user-images.githubusercontent.com/36444454/147192376-ee98fe0a-0517-4e8c-9462-11236c825321.png)

* GENERAL
  * Application Name : apps
  * Project: default
  * SYNC POLICY: AUTOMATIC
    * 유의 : AUTOMATIC을 선택해도, manifest가 바뀔 시 바로 sync가 맞춰지지는 않음. repo pull 방식으로 3분 마다 맞춰짐. 즉시 반영을 원한다면 사용자가 직접 git 웹훅을 등록하는 방법도 있음.

* SOURCE
  * Repository URL: https://github.com/tmax-cloud/bookinfo-deployment.git
  * Revision : main
  * Path : apps
    
* DESTINATION
  * Cluster URL: https://kubernetes.default.svc
  * Namespace: staging, 혹은 ops
    * 이미 해당 클러스터에 동일한 네임스페이스가 존재해야 함
    * `kubectl label namespace <name> istio-injection=enabled`을 통해 해당 네임스페이스에서 istio 활성화
  
4. 생성된 apps를 sync
5. 생성된 다른 애플리케이션들을 sync

### 2. 개별 `Application` 배포
상기 `Application` 생성 과정을 다른 매니페스트를 기준으로 각각 생성
