# Installation

## Prerequisites
1. [Install Istio](https://github.com/tmax-cloud/install-istio)
2. [Install ArgoCD](https://github.com/tmax-cloud/install-argocd)
3. [Install Argo Rollouts](https://github.com/tmax-cloud/install-argo-rollouts)

## Application 배포하기
### 한 번에 배포(App of apps)
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

### 개별 `Application` 배포
상기 `Application` 생성 과정을 다른 매니페스트를 기준으로 각각 생성
