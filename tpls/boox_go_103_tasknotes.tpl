{{- $notes := .Notes -}}
{{- /* Dot columns default to the two-thirds width this column normally has;
       the time-block daily page runs full width and passes its own. */ -}}
{{- $dots := "\\myNumDotWidthTwoThirds" -}}
{{- if .DotWidth }}{{ $dots = .DotWidth }}{{ end -}}
  \myUnderline{ {{- .Heading -}} \myDummyQ}
{{- if $notes }}
  \Repeat{ {{- .Todos -}} }{\myTodoLineGray}
{{ if $.Cfg.Dotted -}}
  \vbox to \dimexpr{{ $notes }}\myLenDotGridPitch\relax{%
    \myMash[\myDailySpring]{ {{- dec $notes -}} }{ {{- $dots -}} }\vss}%
{{- else -}}
  \Repeat{ {{- dec $notes -}} }{\myLineGrayVskipTop}%
  \vskip\myLenLineHeightButLine
{{- end }}
  \myLineThick
{{- else }}
  \Repeat{ {{- dec .Todos -}} }{\myTodoLineGray}\myTodoLineThick
{{- end }}
  \vskip2.5mm
{{- if .LeftLink }}
  {{ .LeftLink }}\hfill{}{{ .MoreLink }}\hspace{6mm}\hyperlink{Notes Index}{All notes}
{{- else }}
  {{ .MoreLink }}\hfill{}\hyperlink{Notes Index}{All notes}
{{- end }}
