{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
{{- $rows := .Body.Rows -}}
{{- $last := dec (len $rows) -}}

\begin{minipage}[t]{\myLenTriCol}
  \myUnderline{ {{- .Body.Week.RangeLabel -}} \myDummyQ}
  \vbox to \dimexpr{{ .Body.Height }}\myLenDotGridPitch\relax{%
{{- range $i, $row := $rows }}
{{ if $i }}  \vfill{{ end }}
  \myLineHeightButLine\parbox{\myLenTriCol}{\small {{ $row.Label }}}\myLineLightGray
{{- if gt $row.Lines 2 }}
  \Repeat{ {{- dec (dec $row.Lines) -}} }{\vskip\myLenLineHeightButLine\myLineLightGray}
{{- end }}
  \vskip\myLenLineHeightButLine{{ if eq $i $last }}\myLineThick{{ else }}\myLineGray{{ end }}
{{- end }}
  }
\end{minipage}%
\hspace{\myLenTriColSep}%
\begin{minipage}[t]{\dimexpr2\myLenTriCol+\myLenTriColSep}
{{- template "boox_go_103_tasknotes.tpl" dict
      "Cfg" .Cfg
      "Heading" "Top priorities"
      "Todos" .Body.Todos
      "Notes" .Body.Notes
      "MoreLink" (.Body.Week.LinkLeaf "More" "More notes") }}
\end{minipage}
\par\pagebreak
