{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
{{- $hours := .Body.Day.Hours .Cfg.Layout.Numbers.DailyBottomHour .Cfg.Layout.Numbers.DailyTopHour -}}
{{- $rows := len $hours -}}

\setlength{\myLenTimeBlockAvail}{\remainingHeight}

\begin{tikzpicture}[x=1pt, y=-1pt]
  \pgfmathsetmacro{\tbWidth}{\linewidth}
  \pgfmathsetmacro{\tbRow}{\myLenTimeBlockAvail/(2*{{ $rows }})}
  \pgfmathsetmacro{\tbHourW}{\myLenTimeBlockHourWidth}
  \pgfmathsetmacro{\tbColW}{(\tbWidth-\tbHourW)/\myNumTimeBlockColumns}
  \pgfmathsetmacro{\tbBottom}{ {{- $rows -}} *2*\tbRow}

  \draw[\myColorGray, line width=\myLenLineThicknessDefault]
    (\tbHourW,0) -- (\tbHourW,\tbBottom);
  \foreach \k in {1,...,{{ dec .Cfg.Layout.Numbers.TimeBlockColumns }}} {
    \draw[\myColorLightGray, line width=\myLenLineThicknessDefault,
          dash pattern=on 1mm off 1mm]
      ({\tbHourW+\k*\tbColW},0) -- ({\tbHourW+\k*\tbColW},\tbBottom);
  }

  \foreach \lbl [count=\i from 0] in { {{ range $i, $h := $hours }}{{ if $i }}, {{ end }}{ {{- $h.FormatHour $.Cfg.AMPMTime -}} }{{ end }} } {
    \pgfmathsetmacro{\yhour}{2*\i*\tbRow}
    \pgfmathsetmacro{\yhalf}{(2*\i+1)*\tbRow}
    \draw[\myColorGray, line width=\myLenLineThicknessDefault]
      (0,\yhour) -- (\tbWidth,\yhour);
    \draw[\myColorLightGray, line width=\myLenLineThicknessDefault,
          dash pattern=on 1mm off 1mm]
      (0,\yhalf) -- (\tbWidth,\yhalf);
    \node[anchor=base east, font=\small, inner sep=0pt]
      at ({\tbHourW-2mm},{\yhour+0.72*\tbRow}) {\lbl};
  }

  \draw[\myColorGray, line width=\myLenLineThicknessThick]
    (0,\tbBottom) -- (\tbWidth,\tbBottom);
\end{tikzpicture}
\par\pagebreak
