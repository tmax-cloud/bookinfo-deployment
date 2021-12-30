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
chart: {{ .Chart.Name }}
release: {{ .Release.Name }}
app: "{{ template "bookinfo.name" . }}"
{{- end }}

{{/* matchLabels */}}
{{- define "bookinfo.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "bookinfo.name" . }}"
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

{{- define "bookinfo.core" -}}
  {{- printf "%s-core" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.rating" -}}
  {{- printf "%s-rating" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.order" -}}
  {{- printf "%s-order" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.database" -}}
  {{- printf "%s-database" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.payment" -}}
  {{- printf "%s-payment" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.ingressGateway" -}}
  {{- printf "%s-ingressgateway" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.egressGateway" -}}
  {{- printf "%s-egressgateway" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.virtualService" -}}
  {{- printf "%s" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.destRule" -}}
  {{- printf "%s" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.istio.destRule.stableName" -}}
  {{- printf "%s" "stable" -}}
{{- end -}}

{{- define "bookinfo.istio.destRule.canaryName" -}}
  {{- printf "%s" "cannary" -}}
{{- end -}}

{{- define "bookinfo.database.url" -}}
  {{- printf "jdbc:postgresql://%s:5432" (include "bookinfo.database" .) -}}
{{- end -}}

{{- define "bookinfo.database.username" -}}
  {{- printf "%s" "postgres" -}}
{{- end -}}

{{- define "bookinfo.database.password" -}}
  {{- printf "%s" "password" -}}
{{- end -}}

{{- define "bookinfo.kafka" -}}
  {{- printf "%s-kafka" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.template" -}}
  {{- printf "%s-template" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.templateInstance" -}}
  {{- printf "%s-templateinstance" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.bootstrapServers" -}}
  {{- if eq .Values.eventing.type "internal" -}}
    {{- printf "%s:9092" (include "bookinfo.kafka" .) -}}
  {{- else -}}
    {{ .Values.eventing.external.kafka.bootstrapServers -}}
  {{- end -}}
{{- end -}}

{{- define "bookinfo.kafka.groupId" -}}
  {{- if eq .Values.eventing.type "internal" -}}
    {{- printf "%s" "book" -}}
  {{- else -}}
    {{ .Values.eventing.external.kafka.consumer.groupId -}}
  {{- end -}}
{{- end -}}

{{- define "bookinfo.component.scheme" -}}
  {{- printf "http" -}}
{{- end -}}

{{- define "bookinfo.core.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.core.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.rating.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.rating.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.order.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.order.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.coreURL" -}}
  {{- printf "%s://%s:%s" (include "bookinfo.component.scheme" .) (include "bookinfo.core" .) (include "bookinfo.core.servicePort" .) -}}
{{- end -}}

{{- define "bookinfo.ratingURL" -}}
  {{- printf "%s://%s:%s" (include "bookinfo.component.scheme" .) (include "bookinfo.rating" .) (include "bookinfo.rating.servicePort" .) -}}
{{- end -}}

{{- define "bookinfo.orderURL" -}}
  {{- printf "%s://%s:%s" (include "bookinfo.component.scheme" .) (include "bookinfo.order" .) (include "bookinfo.order.servicePort" .) -}}
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