{{- define "webserver.fullname" -}}
{{- $name := default .Values.metadata.name .Chart.Name -}}
{{- printf"%s" $name | trunc63 -}}
{{- end -}}

{{- define "webstore.fullname" -}}
{{- $name := default .Values.label .Chart.Name -}}
{{- printf"%s" $name | trunc63 -}}
{{- end -}}