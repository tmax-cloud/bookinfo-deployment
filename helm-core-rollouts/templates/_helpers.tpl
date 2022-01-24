{{/*
Expand the name of the chart.
*/}}
{{- define "core.name" -}}
{{- default "core" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "core.fullname" -}}
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
{{- define "core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "core.labels" -}}
chart: "{{ template "core.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{/* matchLabels */}}
{{- define "core.matchLabels" -}}
chart: "{{ template "core.chart" . }}"
release: "{{ .Release.Name }}"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "core.app" -}}
  {{- printf "%s" (include "core.name" .) -}}
{{- end -}}

{{- define "core.database" -}}
  {{- printf "%s-db" (include "core.app" .) -}}
{{- end -}}

{{- define "core.app.containerPort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "core.app.servicePort" -}}
  {{- printf "8080" -}}
{{- end -}}

{{- define "core.database.containerPort" -}}
  {{- printf "5432" -}}
{{- end -}}

{{- define "core.database.servicePort" -}}
  {{- printf "5432" -}}
{{- end -}}

{{- define "core.database.url" -}}
  {{- printf "jdbc:postgresql://%s:5432" (include "core.database" .) -}}
{{- end -}}

{{- define "core.database.username" -}}
  {{- printf "%s" "postgres" -}}
{{- end -}}

{{- define "core.database.password" -}}
  {{- printf "%s" "password" -}}
{{- end -}}