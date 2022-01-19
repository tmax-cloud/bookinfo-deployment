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

{{- define "bookinfo.order" -}}
  {{- printf "%s" (include "bookinfo.fullname" .) -}}
{{- end -}}

{{- define "bookinfo.database" -}}
  {{- printf "%s-db" (include "bookinfo.order" .) -}}
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

{{- define "bookinfo.order.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.order.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "bookinfo.database.containerPort" -}}
  {{- printf "5432" -}}
{{- end -}}

{{- define "bookinfo.database.servicePort" -}}
  {{- printf "5432" -}}
{{- end -}}

{{- define "bookinfo.order.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.order" .) -}}
{{- end -}}

{{- define "bookinfo.database.virtualservice" -}}
  {{- printf "%s-vs" (include "bookinfo.database" .) -}}
{{- end -}}
