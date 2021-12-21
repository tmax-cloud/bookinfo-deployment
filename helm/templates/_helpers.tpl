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

{{- define "bookinfo.istio-ingressgateway" -}}
  {{- printf "%s-gateway" (include "bookinfo.fullname" .) -}}
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

{{- define "bookinfo.kafka.bootstrapServers" -}}
 {{ .Values.kafka.bootstrapServers -}}
{{- end -}}

{{- define "bookinfo.kafka.groupId" -}}
  {{ .Values.kafka.groupId -}}
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