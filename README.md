# bookinfo-deployment
## 구성요소
---
* core, order, rating
  * Plain YAML로 작성된 manifest.
* helm-core, helm-order, helm-rating
  * Helm으로 작성된 manifest.
* helm-core-rollouts
  * Blue/Green 배포전략을 적용하여 Helm으로 작성된 core의 manifest
* helm-order-rollouts
  * Canary 배포전략을 적용하여 Helm으로 작성된 order의 manitest
* helm-rating-rollouts
  * rolling-update 배포전략을 적용하여 Helm으로 작성된 rating의 manifest
* third-party
  * Plain YAML로 작성된 jaeger, kafka, db, nexus, zookeeper의 manifest.

## Prerequisites
---
1. ArgoCD
    * install 가이드 : https://github.com/tmax-cloud/install-argocd
2. Argo Rollouts 
    * install 가이드 : 준비 예정

## 

