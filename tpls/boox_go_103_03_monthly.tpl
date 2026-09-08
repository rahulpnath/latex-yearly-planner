{{/* Monthly page: the calendar, then a block of checkboxes for what the month
     is actually for. The writing lines upstream puts here live on the month's
     own notes page instead, one link away. */}}
{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
{{- template "monthTabularV2.tpl" dict "Month" .Body.Month "Large" true -}}
\medskip

{{ template "boox_go_103_tasknotes.tpl" dict
      "Cfg" .Cfg
      "Heading" "Top priorities"
      "Todos" .Body.Todos
      "Notes" 0
      "MoreLink" (.Body.Month.LinkLeaf "More" "More notes") }}
\pagebreak
