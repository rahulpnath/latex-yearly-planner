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
