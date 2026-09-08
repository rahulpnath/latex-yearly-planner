\myUnderline{Schedule\textcolor{white}{g}}\vskip-\myLenLineThicknessDefault
{{- $hours := .Day.Hours .Cfg.Layout.Numbers.DailyBottomHour .Cfg.Layout.Numbers.DailyTopHour -}}
{{- $last := dec (len $hours) -}}
{{range $i, $hour := $hours -}}
\myLineHeightButLine%
{{if $.Cfg.AMPMTime -}}
\parbox{9mm}{\hfill\small {{- $hour.FormatHour $.Cfg.AMPMTime -}} }%
{{- else -}}
{\small {{- $hour.FormatHour $.Cfg.AMPMTime -}} }
{{- end}}
\myLineLightGray\vskip\myLenLineHeightButLine{{if eq $i $last}}\myLineThick{{else}}\myLineGray{{end}}
{{- end}}
{{if $.Cfg.AddLastHalfHour}}\vskip\myLenLineHeightButLine\vbox to 0pt{\myLineLightGray}{{end}}
