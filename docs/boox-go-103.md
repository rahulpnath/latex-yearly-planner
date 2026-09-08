# Boox Go 10.3

Built with Docker — see [docs/docker.md](docker.md) for the build environment.

`cfg/boox_go_103.*.yaml` target the Onyx Boox Go 10.3: a 10.3" 4:3 E Ink panel,
1872x1404 at 227 ppi, which is **157 x 209 mm** of glass. That is the same
geometry as the reMarkable 2, so the vertical tuning in
`cfg/boox_go_103.base.yaml` is inherited from `cfg/rm2.base.yaml`.

Two deliberate differences from the rM2 config:

* Boox draws PDFs edge to edge with no permanent left-hand tool rail, so the
  page keeps even 0.5cm side margins instead of reserving 1.4cm on the left.
  The breadcrumb layout gets 14.7cm of text width rather than 13.9cm.
* No fixed top-right chrome either, so `cleartoprightcorner` is `false`.

The months-on-side layout still reserves a wide left margin — its month and
quarter rail is a rotated `marginnote` and has to live somewhere.

## Which planner to build

Two overlays, `lined` and `timeblock`, are independent of each other, so there
are four builds. Chain them after the preset, in this order, and set `NAME` to
whatever you want the file called.

| Build | Chain onto the base four | 2026 |
| --- | --- | --- |
| Dot grid, schedule on the day page | *nothing* | 975 |
| Ruled lines, schedule on the day page | `,cfg/boox_go_103.lined.yaml` | 975 |
| Dot grid, time blocking | `,cfg/boox_go_103.timeblock.yaml` | 1340 |
| Ruled lines, time blocking | `,cfg/boox_go_103.lined.yaml,cfg/boox_go_103.timeblock.yaml` | 1340 |

"the base four" being the chain every build starts with:

```
cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml
```

So the fullest build is:

```bash
docker run --rm -v "$PWD:/out" \
  -e PLANNER_YEAR=2026 \
  -e CFG="cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml,cfg/boox_go_103.lined.yaml,cfg/boox_go_103.timeblock.yaml" \
  -e NAME="boox_go_103.timeblock.lined.2026" \
  planner
```

Order matters: config files are applied left to right, and each one only
overrides the keys it mentions. `timeblock` must come last, because it
redefines the page list.

There are also `cfg/boox_go_103.mos.default.yaml` and
`cfg/boox_go_103.breadcrumb.default.yaml` — the Boox geometry with upstream's
stock page designs, months-on-side or breadcrumb, rather than this preset.
They take the panel fix without any of the layout opinions below.

## The `boox_go_103.breadcrumb.custom` preset

This is the default the Docker entrypoint builds. It is a breadcrumb planner
with these choices:

| Setting | Value | Config key |
| --- | --- | --- |
| Navigation | Breadcrumb — `2026 │ Q1 │ January │ Week 1 │ Thursday, 1` across the top | `cfg/template_breadcrumb.yaml` |
| Every period opens on tasks | Day, week, month and quarter all lead with a block of checkboxes | `tpls/boox_go_103_tasknotes.tpl` |
| Every period has a notes page | One "More notes" link away, a full page of writing surface | `*_notes` entries in `pages:` |
| Daily right column | Unbroken run of lines, links in a footer — stays in step with the schedule | `tpls/boox_go_103_05_daily.tpl` |
| Daily schedule | 4 AM – 7 PM, 16 hourly rows | `dailybottomhour: 4`, `dailytophour: 19` |
| Trailing half-hour tick | off — it would leave a 33rd rule dangling past the notes column | `addlasthalfhour: false` |
| Clock | 12-hour (`4 AM`, `7 PM`) | `ampmtime: true` |
| Week starts | Monday | `weekstart: 1` |
| Writing surface | 5.5mm dot grid | `dotted: true` |
| Mini calendar under the schedule | no | `calafterschedule: false` |
| Line spacing | 5.5mm everywhere — schedule, todo lines, ruled lines, dot grid, notes index | `lineheightbutline`, `dotgridpitch` |
| Top priorities | 16 lines — roughly the top half of the right-hand column | `dailytodos: 16` |
| Daily notes grid | 16 rows, what is left after the priorities block | `dailynotes: 16` |
| Weekly rail | Six blocks of five lines — Mon–Fri, then Sat and Sunday together | `weeklydaylines: 5`, `combineweekend: true` |
| Weekly right column | 16 priorities over 16 notes rows, same as the daily page | `weeklytodos: 16`, `weeklynotes: 16` |
| Monthly priorities | 13 lines under the calendar, 9 in a six-week month | `monthlytodos: 13` |
| Quarterly priorities | A full column, 32 lines | `quarterlytodos: 32` |
| Per-day reflect page | **omitted** | absent from `pages:` |

That comes to 975 pages for 2026: 1 title, 1 annual, 4 quarterly, 4
quarterly-notes, 12 monthly, 12 monthly-notes, 53 weekly, 53 weekly-notes, 365
daily, 365 daily-notes, 3 notes index, 102 notes.

### The daily page

The preset points the daily page at `tpls/boox_go_103_05_daily.tpl`, a local
rewrite of `tpls/_common_05_daily.tpl`. It differs in two ways.

**No Reflect link.** The reflect pages are not built, and upstream's daily
template hardcodes a link to them, so all 365 daily pages would otherwise carry
a link to a page that does not exist.

**One unbroken run of writing lines.** Upstream splits the right-hand column
with a `Notes │ More … All notes` heading partway down. That heading is not a
whole number of pitch units tall, so every line below it sits out of step with
the schedule lines opposite. Here the todo lines run straight into the notes
area with nothing between them, and the two links sit below the closing rule:

```
Schedule                     Top priorities
 4 AM ─────────────          □ ─────────────────────────
      ─────────────          □ ─────────────────────────
 5 AM ─────────────          □ ─────────────────────────
      ─────────────            ─────────────────────────
 7 PM ─────────────            ─────────────────────────
━━━━━━━━━━━━━━━━━━━          ━━━━━━━━━━━━━━━━━━━━━━━━━━━
                             More notes       All notes
```

**The last rule of each column is thick, and it is the only thick rule.** Both
sit at the same height, so the page closes on one bold line straight across.
That needs a local copy of the schedule template,
`tpls/boox_go_103_schedule.tpl`, which draws its final hour rule with
`\myLineThick` instead of `\myLineGray`; the notes column draws
`dailynotes - 1` ordinary rows and closes with the thick rule as row *n*.

Both writing surfaces respect `dotted`, so the same structure gives ruled lines
or a dot grid. The dotted branch needs one extra step: `\myDotGrid` builds its
rows out of `\put`, whose natural height does not match the rows it draws, so
the grid is boxed to `dailynotes × dotgridpitch` — exactly the span the ruled
branch occupies. Without that box the daily page grows by about 60mm and
quietly reflows onto a second sheet.

The two columns are also made to **end on the same rule**. The schedule draws
two rules per hour, so 4 AM to 7 PM is 32 of them — exactly the 16 todo lines
plus 16 notes lines opposite. `addlasthalfhour` would add a 33rd, leaving one
line hanging below the notes column and level with the footer text, so it is
turned off. Change the hour range or either row count and that pairing has to
be redone: `2 x (dailytophour - dailybottomhour + 1) == dailytodos + dailynotes`.

That right-hand column is not specific to the daily page. It lives in
`tpls/boox_go_103_tasknotes.tpl` and takes a heading, a checkbox count, a notes
count and a link, so the weekly, monthly and quarterly pages draw the same
thing at their own size. `todos + notes` is the column's height in pitch units,
and the last of those units *is* the thick rule — which is the whole trick
behind pairing it with a schedule, a weekday rail or a calendar: give the two
columns the same total and they close level. A notes count of zero gives a
column of nothing but checkboxes, closed by a thick-ruled checkbox row
(`\myTodoLineThick`) instead.

### The weekly page

`tpls/boox_go_103_04_weekly.tpl` is the daily page with the days where the
hours are. Upstream's weekly page is a 3 × 3 patchwork of day boxes plus a
notes box; this one is two columns:

```
5–11 January                 Top priorities
Mon 5 ─────────────          □ ─────────────────────────
      ─────────────          □ ─────────────────────────
Tue 6 ─────────────            ─────────────────────────
      ─────────────            ─────────────────────────
Sat 10 / Sun 11 ───          
━━━━━━━━━━━━━━━━━━━          ━━━━━━━━━━━━━━━━━━━━━━━━━━━
                             More notes       All notes
```

Each day is a label — a link to that day's own page — over `weeklydaylines`
rules, the last of them darker, which is what separates one day from the next.
The heading is the week's date range, `29 Dec–4 Jan` when it straddles a month.

Seven days at that pitch do not fit beside a 32-unit column: 7 × 5 is 35. So
`combineweekend` gives Saturday and Sunday one shared block, which is six
blocks of five and buys every weekday a fifth line. Turn it off and
`weeklydaylines` has to come down to 4.

Six blocks of five is 30 units against the column's 32, and rather than leave
that slack at the bottom the rail is **boxed to the column's height with
`\vfill` between the days**, so the two units spread out as the gaps between
one day and the next. The bottom rules still line up, and — unlike the daily
page — re-cutting the rail needs no arithmetic: any rail shorter than
`weeklytodos + weeklynotes` simply spaces itself out. A rail *taller* than that
overflows, and LaTeX will say so as an overfull `\vbox`.

### The monthly and quarterly pages

Both open on tasks — what the month or quarter is actually for — and neither
has writing lines any more; those moved to the notes page. `Top priorities`
sits under the calendar on `tpls/boox_go_103_03_monthly.tpl`, and beside the
three month calendars on `tpls/boox_go_103_02_quarterly.tpl`. Each closes on
the same thick rule and the same two links as every other page.

The quarterly page gets a full column, `quarterlytodos: 32`. The monthly page
gets whatever the calendar leaves, which is not a constant: a **six-week month**
— August and November in 2026 — has one more calendar row, worth about four
lines. Rather than sizing every month for the worst case, `compose.MonthlyStuff`
takes four lines off those months on its own (`monthlySixthWeekRows`), so
`monthlytodos` means "lines under a five-week calendar" and each page fills
itself. That constant is tied to `monthlycellheight` (55pt over a 5.5mm pitch,
rounded up); change one and check the other.

### The notes pages

`monthly_notes`, `quarterly_notes` and `weekly_notes` are the daily "More
notes" page applied to the other three periods: a breadcrumb ending in `Notes`,
and the rest of the sheet a writing surface. They need no template of their own
— `tpls/breadcrumb_07_daily_notes.tpl` is a header and a full-page grid with
nothing day-specific in it, so all four page types share it.

What they did need is Go. `cal.Month`, `cal.Quarter` and `cal.Week` grew the
`Breadcrumb(prefix, leaf)` / `LinkLeaf(prefix, leaf)` pair `cal.Day` already
had: with a leaf the breadcrumb appends it as a further crumb and moves the
page's hypertarget onto it, and `LinkLeaf` is the link on the other side.
`More` is the prefix, so January's notes page is `MoreJanuary`, Q1's is
`MoreQ1`. The composers are the existing ones parameterised the same way
`compose.Daily` / `compose.DailyNotes` already were, and `app.ComposerMap` gains
the three new `funcname`s.

## Changing the options

Config files are applied left to right and merged field by field, so a later
file only overrides the keys it actually mentions. Edit
`cfg/boox_go_103.breadcrumb.custom.yaml`, or add another file after it in `CFG`.

| Want | Change |
| --- | --- |
| Different schedule hours | `layout.numbers.dailybottomhour` / `dailytophour` (inclusive) |
| 24-hour clock | `ampmtime: false` |
| Week starting Sunday | `weekstart: 0` |
| Ruled lines instead of dots | chain `cfg/boox_go_103.lined.yaml` (see below) |
| Time-blocking daily layout | chain `cfg/boox_go_103.timeblock.yaml` (see below) |
| Mini month calendar under the schedule | `calafterschedule: true` |
| More or fewer "Top priorities" lines | `layout.numbers.dailytodos` (8 upstream, 16 here) |
| More or fewer note rows on the daily page | `layout.numbers.dailynotes` (27 upstream, 16 here) |
| Saturday and Sunday as separate days | `combineweekend: false`, and `weeklydaylines` down to 4 |
| Longer or shorter days on the weekly page | `layout.numbers.weeklydaylines` — keep `rows x weeklydaylines` under `weeklytodos + weeklynotes` |
| The weekly page's own two counts | `layout.numbers.weeklytodos` / `weeklynotes` (16 + 16, matching the daily page) |
| Monthly or quarterly task lines | `layout.numbers.monthlytodos` (13, minus 4 in a six-week month) / `quarterlytodos` (32) |
| Writing lines back on the monthly page | point `monthly` at `_common_03_monthly.tpl` and drop `monthly_notes` |
| Line spacing everywhere | `layout.lengths.lineheightbutline` **and** `dotgridpitch` — see below |
| Size of the notes section at the back | `notesindexpages` (3) x `notesonpage` (34) |
| Drop or restore a whole page type | add/remove an entry in the `pages:` list — the four `*_notes` pages are 434 of the 975 |
| The months-on-side rail instead of breadcrumbs | swap in `cfg/template_months_on_side.yaml` + `cfg/boox_go_103.mos.default.yaml` |

`pages:` is a list, so a config that defines it replaces the previous list
outright rather than merging into it.

### Lined instead of dotted

`cfg/boox_go_103.lined.yaml` is a one-key overlay — `dotted: false` — chained
after the custom config:

```bash
docker run --rm -v "$PWD:/out" \
  -e PLANNER_YEAR=2026 \
  -e CFG="cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml,cfg/boox_go_103.lined.yaml" \
  -e NAME="boox_go_103.lined.2026" \
  planner
```

`dotted` is global, so that single key turns every writing surface into 5.5mm
ruled lines: the daily notes block, the per-day "More" page, the notes section
at the back, and the weekly, monthly and quarterly pages. The weekly page swaps
to a dedicated template (`_common_04_weekly_lined.tpl`) rather than reusing the
dotted one.

Row counts carry over untouched — a ruled line and a dot row are both one
pitch unit — so the "Top priorities" split and the column alignment are
identical in both builds, and the full-page notes sheets ignore the counts
entirely and fill themselves with `\leaders`.

Nothing else changes shape. Upstream's monthly page does — one full-width dot
grid when dotted, two narrower ruled columns when lined — but that is
`tpls/_common_03_monthly.tpl`, which this preset no longer uses.

### Time blocking

`cfg/boox_go_103.timeblock.yaml` switches the daily page to a time-blocking
layout, after Cal Newport's Time-Block Planner. Chain it last:

```bash
docker run --rm -v "$PWD:/out" \
  -e PLANNER_YEAR=2026 \
  -e CFG="cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml,cfg/boox_go_103.timeblock.yaml" \
  -e NAME="boox_go_103.timeblock.2026" \
  planner
```

The schedule column comes off the day page and moves onto a sheet of its own,
one per day, so the day page becomes tasks and notes across the full width:

```
2026 | Q1 | January | Week 1 | Thursday, 1        Fri, 2
Top priorities ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ ───────────────────────────────────────────────────────
□ ───────────────────────────────────────────────────────
  ───────────────────────────────────────────────────────
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TimeBlock                            More notes  All notes
```

`TimeBlock` in the footer points at that day's sheet: an hour strip down the
left, then four equal columns of about 3.4cm to block the day out in — one
column per pass, so a day can be re-blocked as it falls apart without losing
what was planned before. Solid rule on the hour, dashed on the half hour,
continuous dashed rules between the columns.

It is drawn in TikZ rather than as a tabular, because those column separators
run the full height and `\vline` cannot dash.

This is the one page that does **not** run at the planner's shared pitch. It
has no neighbouring column to stay in step with, and at 5.5mm a 16 hour day
leaves about 16mm dead at the foot, so the rows are stretched to fill the
column exactly — `\remainingHeight` divided by twice the hour count, which
comes out near 6.0mm for a 4 AM to 7 PM day. Change the hour range and the
rows re-fit themselves; nothing needs re-tuning by hand.

Two knobs, both with defaults, in `cfg/boox_go_103.timeblock.yaml`:

| Key | Default | Meaning |
| --- | --- | --- |
| `layout.numbers.timeblockcolumns` | 4 | Blocking columns on the sheet |
| `layout.lengths.timeblockhourwidth` | 12mm | Width of the hour strip |

The sheet adds 365 pages, taking 2026 to 1340. It is independent of `dotted`,
so it combines with the lined overlay — chain both.

### Line spacing

Every writing surface in this preset sits on one 5.5mm pitch: the schedule
rows, the "Top priorities" lines, the ruled lines in the lined build, the dot
grid in the dotted build, and the notes index rows. Upstream uses 5mm, which is
tight on a 10.3" panel. The one exception is the time-block sheet, which
stretches its rows to fill the page — see above.

It takes two keys, because they feed different machinery:

```yaml
layout:
  lengths:
    lineheightbutline: \dimexpr5.5mm-.4pt   # a LaTeX length register
    dotgridpitch: 5.5mm                     # a literal, substituted into the template
```

`dotgridpitch` has to repeat the value rather than read the register, because
the dot grid is drawn by `multido`, which needs a literal dimension in its
increment. Keep the two in step or the dots and the lines drift apart.
`dotgridpitch` defaults to 5mm when unset, so stock configs are unaffected.

**5.5mm is close to the ceiling for this preset, not an arbitrary pick.** A
schedule hour costs *two* pitch units — the hour line and its half-hour line —
so a 4 AM to 7 PM day is 32 units tall. Above about 5.75mm that no longer fits
the column, and the daily page silently reflows onto a second sheet rather than
reporting an error. If you raise the pitch, either narrow the hour range or
check the page count: 975 for 2026 is correct, and 1340 means every daily page
has split in two.

Changing the pitch means re-tuning every row count, since they are counts and
not fractions of the page: `dailytodos`, `dailynotes`, `weeklydaylines`,
`weeklytodos`, `weeklynotes`, `monthlytodos`, `quarterlytodos`, `notesonpage`
(which is also the notes-index row count), `dotheightfull`, and the
`dotwidthfull` / `dotwidthtwothirds` column counts. `weeklylines`,
`quarterlylines` and `monthlynotes` only matter if you put the upstream weekly,
quarterly or monthly templates back.

These knobs do not exist upstream and were added here:

* `layout.numbers.monthlynotes` — the monthly page's notes rows, hardcoded to
  20 in `tpls/_common_03_monthly.tpl`. Defaults to 20 when unset. Unused by
  this preset, whose monthly page carries checkboxes instead.
* `layout.numbers.monthlytodos`, `quarterlytodos`, `weeklytodos`,
  `weeklynotes`, `weeklydaylines` — the counts the pages above are cut to.
* `combineweekend` — Saturday and Sunday share one block on the weekly page.
* `layout.lengths.dotgridpitch` — described above.

There is also `layout.lengths.dailytodolineheight`, which gives the "Top
priorities" lines a pitch of their own. This preset deliberately leaves it
unset so the spacing stays uniform; set it only if you want that block to break
step with the rest of the page. It defaults to `lineheightbutline`.

The row counts were re-derived for the 5.5mm pitch rather than inherited from
the reMarkable 2, and every page type was checked at render time to confirm it
fills its column without spilling past the bottom margin.

## Rebuilding it

```bash
docker run --rm -v "$PWD:/out" -e PLANNER_YEAR=2027 planner
```

or, with the repo checked out:

```bash
docker compose run --rm -e PLANNER_YEAR=2027 planner
```
