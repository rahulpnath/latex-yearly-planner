package compose

import (
	"github.com/kudrykv/latex-yearly-planner/app/components/cal"
	"github.com/kudrykv/latex-yearly-planner/app/components/page"
	"github.com/kudrykv/latex-yearly-planner/app/config"
)

var Monthly = MonthlyStuff("", "")
var MonthlyNotes = MonthlyStuff("More", "Notes")

const monthlySixthWeekRows = 4

func MonthlyStuff(prefix, leaf string) func(cfg config.Config, tpls []string) (page.Modules, error) {
	return func(cfg config.Config, tpls []string) (page.Modules, error) {
		year := cal.NewYear(cfg.WeekStart, cfg.Year)
		modules := make(page.Modules, 0, 12)

		for _, quarter := range year.Quarters {
			for _, month := range quarter.Months {
				todos := cfg.Layout.Numbers.MonthlyTodos + (5-len(month.Weeks))*monthlySixthWeekRows
				if todos < 0 {
					todos = 0
				}

				modules = append(modules, page.Module{
					Cfg: cfg,
					Tpl: tpls[0],
					Body: map[string]interface{}{
						"Year":         year,
						"Quarter":      quarter,
						"Month":        month,
						"Todos":        todos,
						"Breadcrumb":   month.Breadcrumb(prefix, leaf),
						"HeadingMOS":   month.HeadingMOS(),
						"SideQuarters": year.SideQuarters(quarter.Number),
						"SideMonths":   year.SideMonths(month.Month),
						"Extra":        month.PrevNext(prefix).WithTopRightCorner(cfg.ClearTopRightCorner),
						"Extra2":       extra2(cfg.ClearTopRightCorner, false, false, nil, 0),
					},
				})
			}
		}

		return modules, nil
	}
}
