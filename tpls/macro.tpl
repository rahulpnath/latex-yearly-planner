\ExplSyntaxOn
\cs_new_eq:NN \Repeat \prg_replicate:nn
\ExplSyntaxOff

\newcommand{\myMinLineHeight}[1]{\parbox{0pt}{\vskip#1}}
\newcommand{\myDummyQ}{\textcolor{white}{Q}}

{{- $numbers := .Cfg.Layout.Numbers -}}
\newcommand{\myNumArrayStretch}{ {{- $numbers.ArrayStretch -}} }
\newcommand{\myNumQuarterlyLines}{ {{- $numbers.QuarterlyLines -}} }
\newcommand{\myNumDotHeightFull}{ {{- $numbers.DotHeightFull -}} }
\newcommand{\myNumDotWidthFull}{ {{- $numbers.DotWidthFull -}} }
\newcommand{\myNumDotWidthTwoThirds}{ {{- $numbers.DotWidthTwoThirds -}} }
\newcommand{\myNumWeeklyLines}{ {{- $numbers.WeeklyLines -}} }
\newcommand{\myNumDailyTodos}{ {{- $numbers.DailyTodos -}} }
\newcommand{\myNumDailyNotes}{ {{- $numbers.DailyNotes -}} }
\newcommand{\myNumMonthlyNotes}{ {{- if $numbers.MonthlyNotes -}} {{- $numbers.MonthlyNotes -}} {{- else -}} 20 {{- end -}} }
\newcommand{\myNumDailyBottomHour}{ {{- $numbers.DailyBottomHour -}} }
\newcommand{\myNumDailyTopHour}{ {{- $numbers.DailyTopHour -}} }
\newcommand{\myNumDailyDiaryGoals}{ {{- $numbers.DailyDiaryGoals -}} }
\newcommand{\myNumDailyDiaryGrateful}{ {{- $numbers.DailyDiaryGrateful -}} }
\newcommand{\myNumDailyDiaryBest}{ {{- $numbers.DailyDiaryBest -}} }
\newcommand{\myNumDailyDiaryLog}{ {{- $numbers.DailyDiaryLog -}} }
\newcommand{\myNumDailyPersonal}{ {{- $numbers.DailyPersonal -}} }
\newcommand{\myNumTodoLinesInTodoPage}{ {{- $numbers.TodoLinesInTodoPage -}} }

\newlength{\myLenTabColSep}
\newlength{\myLenLineThicknessDefault}
\newlength{\myLenLineThicknessThick}
\newlength{\myLenLineHeightButLine}
\newlength{\myLenDailyTodoLineHeight}
\newlength{\myLenDotGridPitch}
\newlength{\myLenTwoColSep}
\newlength{\myLenTwoCol}
\newlength{\myLenTriColSep}
\newlength{\myLenTriCol}
\newlength{\myLenFiveColSep}
\newlength{\myLenFiveCol}
\newlength{\myLenMonthlyCellHeight}
\newlength{\myLenNotesIndexCellHeight}
\newlength{\myLenHeaderResizeBox}
\newlength{\myLenHeaderSideQuartersWidth}
\newlength{\myLenHeaderSideMonthsWidth}

{{- $lengths := .Cfg.Layout.Lengths -}}
\setlength{\myLenTabColSep}{ {{- $lengths.TabColSep -}} }
\setlength{\myLenLineThicknessDefault}{ {{- $lengths.LineThicknessDefault -}} }
\setlength{\myLenLineThicknessThick}{ {{- $lengths.LineThicknessThick -}} }
\setlength{\myLenLineHeightButLine}{ {{- $lengths.LineHeightButLine -}} }
% Pitch of the "Top priorities" lines. Defaults to the standard line height,
% so configs that do not set it are unaffected.
\setlength{\myLenDailyTodoLineHeight}{ {{- if $lengths.DailyTodoLineHeight -}} {{- $lengths.DailyTodoLineHeight -}} {{- else -}} \myLenLineHeightButLine {{- end -}} }
\setlength{\myLenTwoColSep}{ {{- $lengths.TwoColSep -}} }
\setlength{\myLenTwoCol}{\dimexpr.5\linewidth-.5\myLenTwoColSep}
\setlength{\myLenFiveColSep}{ {{- $lengths.FiveColSep -}} }
\setlength{\myLenFiveCol}{\dimexpr.2\linewidth-\myLenFiveColSep}
\setlength{\myLenMonthlyCellHeight}{ {{- $lengths.MonthlyCellHeight -}} }
\setlength{\myLenTriColSep}{ {{- $lengths.TriColSep -}} }
\setlength{\myLenTriCol}{\dimexpr.333\linewidth-.667\myLenTriColSep}
\setlength{\myLenNotesIndexCellHeight}{ {{- $lengths.NotesIndexCellHeight -}} }
\setlength{\myLenHeaderResizeBox}{ {{- $lengths.HeaderResizeBox -}} }
\setlength{\myLenHeaderSideQuartersWidth}{ {{- $lengths.HeaderSideQuartersWidth -}} }
\setlength{\myLenHeaderSideMonthsWidth}{ {{- $lengths.HeaderSideMonthsWidth -}} }

\newcommand{\myQuarterlySpring}{ {{- $lengths.QuarterlySpring -}} }
\newcommand{\myMonthlySpring}{ {{- $lengths.MonthlySpring -}} }
\newcommand{\myDailySpring}{ {{- $lengths.DailySpring -}} }
\newcommand{\myColorGray}{ {{- .Cfg.Layout.Colors.Gray -}} }
\newcommand{\myColorLightGray}{ {{- .Cfg.Layout.Colors.LightGray -}} }

\newcommand{\myLinePlain}{\hrule width \linewidth height \myLenLineThicknessDefault}
\newcommand{\myLineThick}{\hrule width \linewidth height \myLenLineThicknessThick}

\newcommand{\myLineHeightButLine}{\myMinLineHeight{\myLenLineHeightButLine}}
\newcommand{\myUnderline}[1]{#1\vskip1mm\myLineThick\par}
\newcommand{\myLineColor}[1]{\textcolor{#1}{\myLinePlain}}
\newcommand{\myLineGray}{\myLineColor{\myColorGray}}
\newcommand{\myLineLightGray}{\myLineColor{\myColorLightGray}}
\newcommand{\myLineGrayVskipBottom}{\myLineGray\vskip\myLenLineHeightButLine}
\newcommand{\myLineGrayVskipTop}{\vskip\myLenLineHeightButLine\myLineGray}

\newcommand{\myTodo}{\myLineHeightButLine$\square$\myLinePlain}
% Checkbox sits centred in its cell, as \myMinLineHeight places it.
\newcommand{\myTodoLineGray}{\myMinLineHeight{\myLenDailyTodoLineHeight}$\square$\myLineGray}
% The same row closing a column: thick rule instead of a thin one, so a column
% of nothing but checkboxes still ends on the bold line the others do.
\newcommand{\myTodoLineThick}{\myMinLineHeight{\myLenDailyTodoLineHeight}$\square$\myLineThick}

\setlength{\myLenDotGridPitch}{ {{- if $lengths.DotGridPitch -}} {{- $lengths.DotGridPitch -}} {{- else -}} 5mm {{- end -}} }
% Dot spacing. multido needs a literal dimension, so it is substituted rather
% than read from a length register. Keep it in step with lineheightbutline.
\newcommand{\myDotGrid}[2]{\leavevmode\multido{\dC=0mm+{{ if $lengths.DotGridPitch }}{{ $lengths.DotGridPitch }}{{ else }}5mm{{ end }}}{#1}{\multido{\dR=0mm+{{ if $lengths.DotGridPitch }}{{ $lengths.DotGridPitch }}{{ else }}5mm{{ end }}}{#2}{\put(\dR,\dC){\circle*{0.1}}}}}

\newcommand{\myMash}[3][]{
  {{- if $.Cfg.Dotted -}} \vskip\myLenLineHeightButLine#1\myDotGrid{#2}{#3} {{- else -}} \Repeat{#2}{\myLineGrayVskipTop} {{- end -}}
}

\newcommand{\remainingHeight}{%
  \ifdim\pagegoal=\maxdimen
  \dimexpr\textheight-9.4pt\relax
  \else
  \dimexpr\pagegoal-\pagetotal-\lineskip-9.4pt\relax
  \fi%
}