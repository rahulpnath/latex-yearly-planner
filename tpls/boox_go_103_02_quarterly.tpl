{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
\begin{minipage}[t][\remainingHeight]{\myLenTriCol}
{{- range $j, $month := .Body.Quarter.Months -}}
{\noindent\renewcommand{\arraystretch}{0}%
{{- template "monthTabularV2.tpl" dict "Month" $month "TableType" "tabular" -}}
{{- if ne $j 2 -}} \vfill {{- end -}}
{{- end -}}
\end{minipage}%
\hspace{\myLenTriColSep}%
\begin{minipage}[t]{\dimexpr2\myLenTriCol+\myLenTriColSep}
{{- template "boox_go_103_tasknotes.tpl" dict
      "Cfg" .Cfg
      "Heading" "Top priorities"
      "Todos" .Body.Todos
      "Notes" 0
      "MoreLink" (.Body.Quarter.LinkLeaf "More" "More notes") }}
\end{minipage}
\par\pagebreak
