package compose

import (
	"github.com/kudrykv/latex-yearly-planner/app/components/cal"
	"github.com/kudrykv/latex-yearly-planner/app/components/page"
	"github.com/kudrykv/latex-yearly-planner/app/config"
)

var Weekly = WeeklyStuff("", "")
var WeeklyNotes = WeeklyStuff("More", "Notes")

func WeeklyStuff(prefix, leaf string) func(cfg config.Config, tpls []string) (page.Modules, error) {
	return func(cfg config.Config, tpls []string) (page.Modules, error) {
		modules := make(page.Modules, 0, 53)
		year := cal.NewYear(cfg.WeekStart, cfg.Year)
		numbers := cfg.Layout.Numbers

		for _, week := range year.Weeks {
			modules = append(modules, page.Module{
				Cfg: cfg,
				Tpl: tpls[0],
				Body: map[string]interface{}{
					"Year":         year,
					"Week":         week,
					"Rows":         week.Rows(cfg.CombineWeekend, numbers.WeeklyDayLines),
					"Todos":        numbers.WeeklyTodos,
					"Notes":        numbers.WeeklyNotes,
					"Height":       numbers.WeeklyTodos + numbers.WeeklyNotes,
					"Breadcrumb":   week.Breadcrumb(prefix, leaf),
					"HeadingMOS":   week.HeadingMOS(),
					"SideQuarters": year.SideQuarters(week.Quarters.Numbers()...),
					"SideMonths":   year.SideMonths(week.Months.Months()...),
					"Extra":        week.PrevNext(prefix).WithTopRightCorner(cfg.ClearTopRightCorner),
					"Extra2":       extra2(cfg.ClearTopRightCorner, false, false, nil, 0),
				},
			})
		}

		return modules, nil
	}
}
