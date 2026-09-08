{{/* The task-and-notes column, shared by the daily, weekly, monthly and
     quarterly pages of this preset.

     Checkbox lines at the top, writing rows under them, one thick rule closing
     the column, and the two notes links below it. Todos + Notes is the height
     of the column in line-pitch units and the last of those units is the thick
     rule, so this column ends level with any other column of the same total --
     which is how it stays in step with the schedule opposite it on the daily
     page, and with the weekday rail on the weekly page.

     Notes 0 gives a column of nothing but checkboxes. That is what the monthly
     and quarterly pages use: their writing goes on their own notes page. */}}
{{- $notes := .Notes -}}
  \myUnderline{ {{- .Heading -}} \myDummyQ}
{{- if $notes }}
  \Repeat{ {{- .Todos -}} }{\myTodoLineGray}
{{ if $.Cfg.Dotted -}}
  % \put gives the grid an awkward natural height, so box it to exactly the
  % same span the ruled branch below occupies: one pitch per notes row.
  \vbox to \dimexpr{{ $notes }}\myLenDotGridPitch\relax{%
    \myMash[\myDailySpring]{ {{- dec $notes -}} }{\myNumDotWidthTwoThirds}\vss}%
{{- else -}}
  \Repeat{ {{- dec $notes -}} }{\myLineGrayVskipTop}%
  \vskip\myLenLineHeightButLine
{{- end }}
  \myLineThick
{{- else }}
  \Repeat{ {{- dec .Todos -}} }{\myTodoLineGray}\myTodoLineThick
{{- end }}
  \vskip2.5mm
  {{ .MoreLink }}\hfill{}\hyperlink{Notes Index}{All notes}
