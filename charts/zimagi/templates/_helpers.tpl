{{/*
Expand the name of the chart.
*/}}
{{- define "zimagi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zimagi.fullname" -}}
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
{{- define "zimagi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zimagi.labels" -}}
helm.sh/chart: {{ include "zimagi.chart" . }}
{{ include "zimagi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zimagi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zimagi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a default fully qualified PostgreSQL name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.postgresql.secretName" -}}
{{- printf "%s" (include "zimagi.postgresql.fullname" .) -}}
{{- end -}}

{{- define "zimagi.database.existingsecret.key" -}}
{{- printf "%s" "password" -}}
{{- end -}}

{{/*
Create a default fully qualified Redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.redisMaster.fullname" -}}
{{- $name := default "redis-master" .Values.redis.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.redis.fullname" -}}
{{- $name := default "redis" .Values.redis.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.redis.secretName" -}}
{{- printf "%s" (include "zimagi.redis.fullname" .) -}}
{{- end -}}

{{- define "zimagi.redis.existingsecret.key" -}}
{{- printf "%s" "redis-password" -}}
{{- end -}}

{{/*
Create a default fully qualified Zimagi Command API name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.commandApi.fullname" -}}
{{- printf "%s-command-api" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.commandApi.serviceAccountName" -}}
{{- if .Values.commandApi.serviceAccount.create -}}
    {{ default (include "zimagi.commandApi.fullname" .) .Values.commandApi.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.commandApi.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified Zimagi Data API name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.dataApi.fullname" -}}
{{- printf "%s-data-api" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.dataApi.serviceAccountName" -}}
{{- if .Values.commandApi.serviceAccount.create -}}
    {{ default (include "zimagi.dataApi.fullname" .) .Values.commandApi.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.commandApi.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified Zimagi Scheduler name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.scheduler.fullname" -}}
{{- printf "%s-scheduler" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.scheduler.serviceAccountName" -}}
{{- if .Values.commandApi.serviceAccount.create -}}
    {{ default (include "zimagi.scheduler.fullname" .) .Values.commandApi.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.commandApi.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified Zimagi Worker name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zimagi.worker.fullname" -}}
{{- printf "%s-worker" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zimagi.worker.serviceAccountName" -}}
{{- if .Values.commandApi.serviceAccount.create -}}
    {{ default (include "zimagi.worker.fullname" .) .Values.commandApi.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.commandApi.serviceAccount.name -}}
{{- end -}}
{{- end -}}


{{- define "zimagi.pvc.fullname" -}}
{{- printf "%s-lib" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
