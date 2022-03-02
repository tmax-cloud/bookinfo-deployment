{{/*
Expand the name of the chart.
*/}}
{{- define "bookinfo.name" -}}
{{- default "bookinfo" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bookinfo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bookinfo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bookinfo.labels" -}}
chart: "{{ template "bookinfo.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{/* matchLabels */}}
{{- define "bookinfo.matchLabels" -}}
chart: "{{ template "bookinfo.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{- define "bookinfo.istio.ingressGatwayMatchLabels" -}}
  {{ printf "%s: %s" .Values.istio.ingressGateway.selector.key .Values.istio.ingressGateway.selector.value }}
{{- end }}

{{- define "bookinfo.istio.egressGatwayMatchLabels" -}}
  {{ printf "%s: %s" .Values.istio.egressGateway.selector.key .Values.istio.egressGateway.selector.value }}
{{- end }}

{{- define "bookinfo.upstream.payment" -}}
{{- if regexMatch "//.*:" ( .Values.upstream.paymentURL | toString ) }}
  {{- .Values.upstream.paymentURL | toString | regexFind "//.*:" | trimAll "/:" -}}
{{- else if regexMatch "//.*" ( .Values.upstream.paymentURL | toString ) }}
  {{- .Values.upstream.paymentURL | toString | regexFind "//.*" | trimAll "/" -}}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bookinfo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bookinfo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "bookinfo.istio.ingressGateway" -}}
  {{- printf "%s-ingressgateway" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.egressGateway" -}}
  {{- printf "%s-egressgateway" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.ingressVirtualService" -}}
  {{- printf "%s-ingress-vs" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.egressVirtualService" -}}
  {{- printf "%s-egress-vs" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.destRule" -}}
  {{- printf "%s" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.destRule.stableName" -}}
  {{- printf "%s" "stable" -}}
{{- end -}}

{{- define "bookinfo.istio.destRule.canaryName" -}}
  {{- printf "%s" "canary" -}}
{{- end -}}

{{- define "bookinfo.core" -}}
  {{- printf "%s-core" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.rating" -}}
  {{- printf "%s-rating" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.order" -}}
  {{- printf "%s-order" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.payment" -}}
  {{- printf "%s-payment" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.core.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.core" .) -}}
{{- end -}}

{{- define "bookinfo.rating.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.rating" .) -}}
{{- end -}}

{{- define "bookinfo.order.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.order" .) -}}
{{- end -}}

{{- define "bookinfo.payment.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.payment" .) -}}
{{- end -}}

{{- define "bookinfo.database.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.database" .) -}}
{{- end -}}

{{- define "bookinfo.zookeeper.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.zookeeper" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.kafka" .) -}}
{{- end -}}

{{- define "bookinfo.core.destinationRule" -}}
  {{- printf "%s-dest-rule" (include "bookinfo.core" .) -}}
{{- end -}}

{{- define "bookinfo.rating.destinationRule" -}}
  {{- printf "%s-dest-rule" (include "bookinfo.rating" .) -}}
{{- end -}}

{{- define "bookinfo.order.destinationRule" -}}
  {{- printf "%s-dest-rule" (include "bookinfo.order" .) -}}
{{- end -}}

{{- define "bookinfo.payment.destinationRule" -}}
  {{- printf "%s-dest-rule" (include "bookinfo.payment" .) -}}
{{- end -}}

{{- define "bookinfo.zookeeper" -}}
  {{- printf "%s-zookeeper" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.kafka" -}}
  {{- printf "%s-kafka" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.zookeeper.containerPort" -}}
  {{- printf "2181" -}}
{{- end -}}

{{- define "bookinfo.zookeeper.servicePort" -}}
  {{- printf "2181" -}}
{{- end -}}

{{- define "bookinfo.kafka.containerPort" -}}
  {{- printf "9092" -}}
{{- end -}}

{{- define "bookinfo.kafka.servicePort" -}}
  {{- printf "9092" -}}
{{- end -}}

{{- define "bookinfo.kafka.advertisedListners" -}}
  {{- printf "INSIDE://%s:%s" (include "bookinfo.kafka" .) (include "bookinfo.kafka.containerPort" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.listners" -}}
  {{- printf "INSIDE://0.0.0.0:%s"  (include "bookinfo.kafka.containerPort" .) -}}
{{- end -}}

{{- define "bookinfo.zookeeperURL" -}}
  {{- printf "%s:%s" (include "bookinfo.zookeeper" .) (include "bookinfo.zookeeper.containerPort" .) -}}
{{- end -}}
