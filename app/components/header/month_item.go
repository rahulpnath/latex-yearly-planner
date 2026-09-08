package header

import (
	"time"

	"github.com/kudrykv/latex-yearly-planner/app/components/hyper"
)

type MonthItem struct {
	Val       time.Month
	ref       bool
	shorten   bool
	refPrefix string
}

func (m MonthItem) Display() string {
	ref := m.refPrefix + m.Val.String()
	text := m.Val.String()

	if m.shorten {
		text = text[:3]
	}

	if m.ref {
		return hyper.Target(ref, text)
	}

	return hyper.Link(ref, text)
}

func (m MonthItem) Ref() MonthItem {
	m.ref = true

	return m
}

// RefPrefix points the link at a leaf page of the month -- "More" for the
// month's notes page -- rather than at the month page itself.
func (m MonthItem) RefPrefix(prefix string) MonthItem {
	m.refPrefix = prefix

	return m
}

func (m MonthItem) Shorten(f bool) MonthItem {
	m.shorten = f

	return m
}

func NewMonthItem(m time.Month) MonthItem {
	return MonthItem{Val: m}
}
