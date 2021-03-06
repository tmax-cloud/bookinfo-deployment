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

{{- define "bookinfo.zookeeper.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.zookeeper" .) -}}
{{- end -}}

{{- define "bookinfo.kafka.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.kafka" .) -}}
{{- end -}}
