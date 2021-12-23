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

## ARGOCD UI 시연 가이드
1. ArgoCD 서버에 접속한다. 
2. 왼쪽 상단에 "+ NEW APP" 버튼을 눌러 각 Micro Service들의 Application을 생성.

![image](https://user-images.githubusercontent.com/36444454/147192193-e2614f3d-4343-4893-98a9-5cf65e1bf7fe.png)

3. 각 항목을 다음 처럼 채우고, 왼쪽 상단에 Create을 클릭한다. 

![image](https://user-images.githubusercontent.com/36444454/147192376-ee98fe0a-0517-4e8c-9462-11236c825321.png)

* GENERAL
  * Application Name : 각 서비스 이름과 phase를 조합해서 네이밍할 것
    * core-staging, core-ops, order-staging, order-ops ...
    * 유의 : Application 이름들이 중복될 수 없음
  * Project 
    * 시연 시, default 기입
  * SYNC POLICY
    * 시연 시, AUTOMATIC 선택
    * 유의 : AUTOMATIC을 선택해도, manifest가 바뀔 시 바로 sync가 맞춰지지는 않음. repo pull 방식으로 3분 마다 맞춰짐. 즉시 반영을 원한다면 사용자가 직접 git 웹훅을 등록하는 방법도 있음.

* SOURCE
  * Repository URL : manifest가 담긴 레포의 주소
    * 시연 시, https://github.com/tmax-cloud/bookinfo-deployment.git로 기입
  * Revision : repo의 브랜치나 태그, commit SHA
    * 시연 시, main으로 기입
  * Path : manifest 경로
    * 마우스로 빈칸을 클릭하면, 해당 repo에 있는 subdirectory들을 드롭다운 형식으로 보여줌
    * 시연하고자 하는 경로 클릭 or 기입

* DESTINATION
  * Cluster URL
    * 시연 시, https://kubernetes.default.svc
  * Namespace
    * 시연 시, staging, ops로 각각 한벌씩 만들 것
    * 유의 : 이미 해당 클러스터 내에 staging, ops라는 namespace가 존재해야 함. 없다면 "kubectl create ns staging", "kubectl create ns ops"로 만들 것

4. 정상적으로 작동되고 있는지 확인
