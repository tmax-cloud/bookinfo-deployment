# bookinfo-deployment
## 소개 및 시연 관련 설명
* GitOps 기반 ArgoCD를 통해 마이크로서비스 <U>core, order, rating</U>을 배포 및 운영. 
* 해당 Repository에 있는 각 서비스들의 manifest들로부터 ArgoCD의 커스텀리소스인 <U>Application</U>을 생성해야 함. 
* 해당 Repository 내에서 Manifest를 수정하면, ArgoCD에 자동으로 반영되는 시스템
* 시연 시, QA 환경을 의미하는 <U>staging</U>와 Prod 환경을 의미하는 <U>ops</U>에, 각 서비스들을 한벌씩 배포해야 함.
  * 시연 편의상 각 phase들을 네임스페이스로 구분하였지만 서로 완벽히 격리된 클러스터 환경이라고 가정

## 구성 요소
해당 Repository는 아래의 Manifest들이 있는 Manifest Repo이다. 
* core, order, rating
  * Plain YAML로 작성된 manifest.
* helm-core, helm-order, helm-rating
  * Helm으로 작성된 manifest.
* helm-core-rollouts
  * Blue/Green 배포전략을 적용하여 Helm으로 작성된 core의 manifest
* helm-order-rollouts
  * Canary 배포전략을 적용하여 Helm으로 작성된 order의 manitest
* helm-rating-rollouts
  * Rolling Update 배포전략을 적용하여 Helm으로 작성된 rating의 manifest
* third-party
  * Plain YAML로 작성된 payment, jaeger, kafka, db, nexus, zookeeper의 manifest.

## Prerequisites
1. ArgoCD
    * install 가이드 : https://github.com/tmax-cloud/install-argocd
2. Argo Rollouts 
    * install 가이드 : 준비 예정
3. 서드 파티들 설치 (더 쉽게 인스톨 할 수 있는 방법 고안할 예정)
    * 'third-party'안에 있는 manifest들을 "kubectl apply -f <manifest명>" 으로 staging, ops 네임스페이스에 각각 설치

## 가이드 (작성 중)
1. ArgoCD 서버에 접속한다. 
2. 각 Micro Service들의 Application을 생성한다
