{{/*
Expand the name of the chart.
*/}}
{{- define "order.name" -}}
{{- default "order" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "order.fullname" -}}
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
{{- define "order.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "order.labels" -}}
chart: "{{ template "order.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{/* matchLabels */}}
{{- define "order.matchLabels" -}}
chart: "{{ template "order.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "order.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "order.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "order.app" -}}
  {{- printf "%s" (include "order.name" .) -}}
{{- end -}}

{{- define "order.database" -}}
  {{- printf "%s-db" (include "order.app" .) -}}
{{- end -}}

{{- define "order.database.url" -}}
  {{- printf "jdbc:postgresql://%s-svc:5432" (include "order.database" .) -}}
{{- end -}}

{{- define "order.database.username" -}}
  {{- printf "%s" "postgres" -}}
{{- end -}}

{{- define "order.database.password" -}}
  {{- printf "%s" "password" -}}
{{- end -}}

{{- define "order.app.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "order.app.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "order.database.containerPort" -}}
  {{- printf "5432" -}}
{{- end -}}

{{- define "order.database.servicePort" -}}
  {{- printf "5432" -}}
{{- end -}}
