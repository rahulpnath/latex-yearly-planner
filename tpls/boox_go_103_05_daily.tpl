{{/* Daily page, in two shapes.

     Normally: the schedule down the left, tasks and notes opposite.

     With timeblock set, the schedule moves off this page onto the day's own
     time-block page, and tasks and notes take the full width. The footer then
     carries three links -- TimeBlock on the left, the two notes links on the
     right -- instead of two. */}}
{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
{{- $today := .Body.Day -}}

{{ if .Cfg.TimeBlock -}}
{{- template "boox_go_103_tasknotes.tpl" dict
      "Cfg" .Cfg
      "Heading" "Top priorities"
      "Todos" .Cfg.Layout.Numbers.DailyTodos
      "Notes" .Cfg.Layout.Numbers.DailyNotes
      "DotWidth" "\\myNumDotWidthFull"
      "LeftLink" ($today.LinkLeaf "TimeBlock" "TimeBlock")
      "MoreLink" ($today.LinkLeaf "More" "More notes") }}
{{- else -}}
\begin{minipage}[t]{\myLenTriCol}
{{template "boox_go_103_schedule.tpl" dict "Cfg" .Cfg "Day" .Body.Day}}
  \vspace{\dimexpr4mm+.3pt}

{{- if .Cfg.CalAfterSchedule -}}
{{- template "monthTabularV2.tpl" dict "Month" .Body.Month "Today" $today -}}
{{- end -}}
\end{minipage}%
\hspace{\myLenTriColSep}%
\begin{minipage}[t]{\dimexpr2\myLenTriCol+\myLenTriColSep}
{{- template "boox_go_103_tasknotes.tpl" dict
      "Cfg" .Cfg
      "Heading" "Top priorities"
      "Todos" .Cfg.Layout.Numbers.DailyTodos
      "Notes" .Cfg.Layout.Numbers.DailyNotes
      "MoreLink" ($today.LinkLeaf "More" "More notes") }}
\end{minipage}
{{- end }}
\par\pagebreak
