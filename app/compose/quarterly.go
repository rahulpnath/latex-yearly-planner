package compose

import (
	"github.com/kudrykv/latex-yearly-planner/app/components/cal"
	"github.com/kudrykv/latex-yearly-planner/app/components/header"
	"github.com/kudrykv/latex-yearly-planner/app/components/page"
	"github.com/kudrykv/latex-yearly-planner/app/config"
)

var Quarterly = QuarterlyStuff("", "")
var QuarterlyNotes = QuarterlyStuff("More", "Notes")

func QuarterlyStuff(prefix, leaf string) func(cfg config.Config, tpls []string) (page.Modules, error) {
	return func(cfg config.Config, tpls []string) (page.Modules, error) {
		modules := make(page.Modules, 0, 4)
		year := cal.NewYear(cfg.WeekStart, cfg.Year)

		hRight := header.Items{
			header.NewTextItem("Notes").RefText("Notes Index"),
		}

		for _, quarter := range year.Quarters {
			extra := hRight
			if len(leaf) > 0 {
				extra = quarter.PrevNext(prefix)
			}

			modules = append(modules, page.Module{
				Cfg: cfg,
				Tpl: tpls[0],
				Body: map[string]interface{}{
					"Year":         year,
					"Quarter":      quarter,
					"Todos":        cfg.Layout.Numbers.QuarterlyTodos,
					"Breadcrumb":   quarter.Breadcrumb(prefix, leaf),
					"HeadingMOS":   quarter.HeadingMOS(),
					"SideQuarters": year.SideQuarters(quarter.Number),
					"SideMonths":   year.SideMonths(0),
					"Extra":        extra.WithTopRightCorner(cfg.ClearTopRightCorner),
					"Extra2":       extra2(cfg.ClearTopRightCorner, false, false, nil, 0),
				},
			})
		}

		return modules, nil
	}
}
