{{/* Cal Newport style time-block page, one per day, reached by the TimeBlock
     link on that day's page.

     A narrow strip of hour labels down the left, then N equal columns to block
     the day out in -- one column per pass, so the day can be re-blocked as it
     falls apart without losing what was planned before.

     Drawn in TikZ rather than as a tabular because the column separators are
     continuous dashed rules running the full height, which tabular's \vline
     cannot do. Every dimension comes from the same registers as the rest of
     the planner, so a row here is one pitch unit and an hour is two, matching
     the schedule column on a non-timeblock daily page. */}}
{{ template "breadcrumb_00_header.tpl" dict "Cfg" .Cfg "Body" .Body }}
{{- $hours := .Body.Day.Hours .Cfg.Layout.Numbers.DailyBottomHour .Cfg.Layout.Numbers.DailyTopHour -}}
{{- $rows := len $hours -}}

% Rows are stretched to fill the column exactly rather than run at the
% planner's usual pitch: this page has no neighbouring column to stay in step
% with, and at 5.5mm a 16 hour day leaves about 16mm dead at the foot.
\setlength{\myLenTimeBlockAvail}{\remainingHeight}

\begin{tikzpicture}[x=1pt, y=-1pt]
  \pgfmathsetmacro{\tbWidth}{\linewidth}
  \pgfmathsetmacro{\tbRow}{\myLenTimeBlockAvail/(2*{{ $rows }})}
  \pgfmathsetmacro{\tbHourW}{\myLenTimeBlockHourWidth}
  \pgfmathsetmacro{\tbColW}{(\tbWidth-\tbHourW)/\myNumTimeBlockColumns}
  \pgfmathsetmacro{\tbBottom}{ {{- $rows -}} *2*\tbRow}

  % Column separators: solid where the hours end, dashed between the blocks.
  \draw[\myColorGray, line width=\myLenLineThicknessDefault]
    (\tbHourW,0) -- (\tbHourW,\tbBottom);
  \foreach \k in {1,...,{{ dec .Cfg.Layout.Numbers.TimeBlockColumns }}} {
    \draw[\myColorLightGray, line width=\myLenLineThicknessDefault,
          dash pattern=on 1mm off 1mm]
      ({\tbHourW+\k*\tbColW},0) -- ({\tbHourW+\k*\tbColW},\tbBottom);
  }

  % One solid rule on the hour, one dashed on the half hour, and the hour
  % label sitting just under its own rule as it does on the schedule column.
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
