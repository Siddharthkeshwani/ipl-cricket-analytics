# 🏏 IPL Cricket Analytics — End-to-End Data Analyst Portfolio Project

<div align="center">

![IPL Analytics Banner](https://img.shields.io/badge/IPL%20Cricket-2008--2024-F0B80D?style=for-the-badge&logo=cricket&logoColor=black)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-2.0-150458?style=for-the-badge&logo=pandas&logoColor=white)

**A complete Python → SQL → Power BI analytics pipeline built on 17 seasons of IPL ball-by-ball data**

[📊 View Dashboard](#power-bi-dashboard) · [📓 View Notebook](#project-structure) · [🗄️ View SQL](#project-structure) · [📁 Dataset](#dataset)

</div>

---

## 📋 Table of Contents

- [Business Problem](#-business-problem)
- [Dataset](#-dataset)
- [Project Architecture](#-project-architecture)
- [Project Structure](#-project-structure)
- [Tech Stack](#-tech-stack)
- [Analytical Approach](#-analytical-approach)
- [Key Findings & Insights](#-key-findings--insights)
- [The Clutch Factor Index](#-the-clutch-factor-index--original-metric)
- [How to Run This Project](#-how-to-run-this-project)
- [Results & Business Impact](#-results--business-impact)
- [File Descriptions](#-file-descriptions)
- [License](#-license)

---

## 🎯 Business Problem

> **Industry:** Professional Sports — Indian Premier League (T20 Cricket)

IPL franchise owners spend **crores of rupees** every year at player auctions, often based on reputation, past league records, or gut instinct rather than structured data. There is no reliable, publicly available analytics platform that answers the questions that matter most at auction:

| Question | Why It Matters |
|----------|---------------|
| Which players perform better in playoffs than in league games? | Auction decisions are about knockout games, not dead rubbers |
| Which venues suit batsmen vs bowlers — and how should that change our XI? | Teams at flat-pitch venues need more power hitters |
| Does winning the toss actually help win the match? | Drives one of the most discussed pre-match decisions |
| Which phase (Powerplay / Middle / Death) is each team's weak point? | Helps coaching staff identify and plug specific gaps |

**What happens if this is NOT solved?**
Franchises continue overpaying for big names who underperform in knockouts, while undervalued clutch performers go unnoticed. This project builds the analytics infrastructure to fix that.

---

## 📦 Dataset

| Attribute | Detail |
|-----------|--------|
| **Source** | [Kaggle — IPL Dataset](https://www.kaggle.com/datasets/nowke9/ipldata) |
| **Files** | `matches.csv` + `deliveries.csv` |
| **Seasons** | 2008 – 2024 (17 IPL seasons) |
| **Matches** | 1,095 matches |
| **Deliveries** | 2,60,920 ball-by-ball rows |
| **Columns** | 20 (matches) + 17 (deliveries) |

### Data Quality Issues Found & Fixed

| Issue | How It Was Handled |
|-------|--------------------|
| Season format inconsistency (`'2007/08'`, `'2020/21'`) | Extracted correct year using date column cross-reference |
| Team name changes over seasons (e.g., Delhi Daredevils → Delhi Capitals) | Applied a standardisation dictionary across all columns |
| Super over deliveries mixed in (innings 3–6) | Filtered out — kept only innings 1 & 2 |
| `total_runs` integrity check | Validated: `batsman_runs + extra_runs = total_runs` for all 2,60,920 rows ✅ |
| Merge integrity | Confirmed row count unchanged after left join between tables ✅ |

---

## 🏗️ Project Architecture

```
Raw Data (Kaggle CSVs)
        │
        ▼
┌───────────────────────────────┐
│   LAYER 1 — Python (Jupyter)  │
│                               │
│  • Data Loading & Exploration │
│  • Data Cleaning              │
│  • Feature Engineering        │
│  • Batting Analysis           │
│  • Bowling Analysis           │
│  • Team & Venue Analysis      │
│  • Advanced Analysis          │
│  • Clutch Factor Index (CFI)  │
│  • Export 14 clean CSV files  │
└──────────────┬────────────────┘
               │ 14 clean CSV files
               ▼
┌───────────────────────────────┐
│   LAYER 2 — MySQL (SQL)       │
│                               │
│  • 12 Table Schema (DDL)      │
│  • Load clean CSVs            │
│  • 20 Analytical Queries      │
│    (Easy → Complex CTEs +     │
│     Window Functions)         │
│  • 10 Power BI Views          │
│  • Indexes for performance    │
└──────────────┬────────────────┘
               │ 10 pre-aggregated views
               ▼
┌───────────────────────────────┐
│   LAYER 3 — Power BI          │
│                               │
│  • 8-page interactive dashboard│
│  • Dark IPL-themed design     │
│  • Slicers, bookmarks, drills │
│  • Clutch Factor Index page   │
│  • MVP Scoring System         │
└───────────────────────────────┘
```

---

## 📁 Project Structure

```
ipl-cricket-analytics/
│
├── 📓 IPL_Cricket_Analysis.ipynb      ← Python notebook (main analysis)
├── 🗄️  IPL_Cricket_Analysis.sql       ← MySQL schema + queries + views
├── 📊 Ipl_Dashboard.pbix              ← Power BI dashboard file
├── 📄 README.md                       ← This file
│
├── 📂 raw_data/                       ← Original Kaggle datasets
│   ├── matches.csv                    (1,095 rows × 20 columns)
│   └── deliveries.csv                 (2,60,920 rows × 17 columns)
│
└── 📂 clean_data/                     ← Exported by Python, imported to SQL
    ├── matches_clean.csv              (1,095 rows × 22 cols — cleaned matches)
    ├── deliveries_clean.csv           (2,60,759 rows × 17 cols — super overs removed)
    ├── master.csv                     (2,60,759 rows × 34 cols — merged + features)
    ├── batting_stats.csv              (210 players — career batting summary)
    ├── bowling_stats.csv              (227 bowlers — career bowling summary)
    ├── team_performance.csv           (14 teams — win % and match records)
    ├── venue_stats.csv                (37 venues — avg first innings score)
    ├── partnerships.csv               (4,815 unique pairs — total runs together)
    ├── phase_stats.csv                (45 rows — run rate per team per phase)
    ├── mvp_scores.csv                 (362 players — composite MVP score)
    ├── clutch_factor.csv              (38 players — Clutch Factor Index)
    ├── season_leaders.csv             (17 seasons — Orange Cap + Purple Cap + Champion)
    ├── orange_cap.csv                 (17 rows — top run scorer per season)
    └── purple_cap.csv                 (17 rows — top wicket taker per season)
```

---

## 🛠️ Tech Stack

| Layer | Tools | Purpose |
|-------|-------|---------|
| **Analysis** | Python 3.12, Jupyter Notebook | EDA, cleaning, feature engineering, visualisation |
| **Libraries** | Pandas, NumPy, Matplotlib, Seaborn, SciPy | Data manipulation, statistical testing, charts |
| **Database** | MySQL 8.0, MySQL Workbench | Schema design, SQL queries, views, indexing |
| **Dashboard** | Microsoft Power BI Desktop | Interactive 8-page dashboard |
| **Data Source** | Kaggle (IPL Dataset 2008–2024) | Raw ball-by-ball cricket data |

---

## 🔍 Analytical Approach

### Step 1 — Data Loading & Exploration
- Loaded both CSVs with shape, dtype, and null checks
- Found season format inconsistency, super over rows, team name changes
- Documented all findings before touching any data

### Step 2 — Data Cleaning
- Standardised season year (cross-referenced with match date)
- Unified team names across all columns in both DataFrames
- Filtered super over deliveries (kept only innings 1 & 2)
- Validated `total_runs` integrity across all 2,60,920 rows

### Step 3 — Feature Engineering
- Added `phase` column: Powerplay (1–6) / Middle (7–15) / Death (16–20)
- Added `is_boundary`, `is_four`, `is_six`, `is_dot_ball` binary flags
- Added `season_year` (integer) extracted from raw season string
- Added `is_playoff` flag for Final, Qualifier, Eliminator matches

### Step 4 — Batting Analysis
- Career stats per player: runs, balls, SR, average, 50s, 100s, boundary %
- Top 20 by runs, strike rate, and batting average
- Orange Cap race season by season

### Step 5 — Bowling Analysis
- Career stats per bowler: wickets, economy, bowling average, dot ball %
- Top 20 wicket takers and economy rate leaders
- Purple Cap race, death over specialists, Powerplay specialists

### Step 6 — Team & Venue Analysis
- Win % per franchise (all-time)
- Toss impact analysis with **Chi-Square statistical test** (p > 0.05 → not significant)
- Venue scoring patterns (high vs low scoring grounds)
- First innings vs second innings win rate

### Step 7 — Advanced Analysis
- Top 20 batting partnerships by total runs
- Phase-wise run rate per team (heatmap)
- MVP Composite Score formula: `(runs/100) + (wickets×1.5) + (SR/100) - (economy/10)`

### Step 8 — Clutch Factor Index (Original Metric)
- Unique insight not available in any standard IPL stats platform
- See [dedicated section below](#-the-clutch-factor-index--original-metric)

---

## 📊 Key Findings & Insights

### 🏏 Batting
- **Virat Kohli** leads all-time IPL run charts with **8,004 runs** — 1,200+ runs ahead of second place
- High-volume run scorers cluster in the **130–145 strike rate zone** — they balance volume with aggression
- Very high strike rate (160+) players tend to have fewer total runs, confirming they are used as finishers (fewer balls to face)

### 🎳 Bowling
- **YS Chahal** is the all-time leading wicket taker with **205 wickets**
- **Dot ball % is highest among spinners** in middle overs — a 40%+ dot ball rate means every second ball creates pressure
- Death over specialists (overs 16–20) have higher economies (~9–10) but compensate with wicket-taking

### 🏟️ Team & Venue
- **Mumbai Indians** have the highest all-time win percentage among established franchises
- **Toss winner converts to match winner only ~50% of the time** — Chi-Square test confirms this is statistically insignificant (p > 0.05)
- **Teams opting to field after winning the toss win slightly more**, consistent with the modern T20 trend of chasing

### 📐 SQL Layer (Unique Insights)
- Head-to-head records reveal psychological edges in key rivalries (MI vs CSK is the most played: 30+ matches)
- Players who score **more in matches their team loses** (Lone Warrior analysis) — inflated stats with zero match impact
- Death choke index: teams that fail to score ≤30 runs in the last 3 overs when chasing

---

## 🔥 The Clutch Factor Index — Original Metric

> *"The measure of a player is not how they perform when it's easy — it's how they perform when it matters most."*

### What is it?

The **Clutch Factor Index (CFI)** is an original metric created for this project. It answers the most important question for franchise auction strategy:

**Does this player show up when the trophy is on the line?**

```
CFI = Playoff Average / League Average
```

| CFI Value | Label | Meaning |
|-----------|-------|---------|
| ≥ 1.2 | 🔥 Clutch Legend | Performs 20%+ better in playoffs |
| ≥ 1.0 | ✅ Clutch Performer | Maintains league-level performance |
| ≥ 0.85 | ⚠️ Slight Decline | Minor drop in big games |
| < 0.85 | ❌ Struggles in Playoffs | Reputation exceeds performance |

### Why this matters

Standard IPL leaderboards rank players by career totals. A player with 8,000 career runs sounds elite — but if their playoff average is 30% lower than their league average, a franchise paying a premium for them in a knockout tournament format is buying **reputation, not results**.

### Key Finding

> Several players with the **highest career run totals** have CFI < 1.0 — they perform noticeably WORSE when the tournament is at stake. Meanwhile, several moderate-profile players have CFI > 1.3 — their playoff average is 30%+ higher than their league average.

**Business recommendation:** A player with a league average of 28 and CFI of 1.4 (playoff average ~39) is worth more to a franchise in a knockout format than a player with a league average of 38 and CFI of 0.7 (playoff average ~27).

This single insight can influence **crore-level auction decisions**.

---

## ▶️ How to Run This Project

### Prerequisites

```bash
# Python packages
pip install pandas numpy matplotlib seaborn scipy jupyter

# MySQL 8.0 + MySQL Workbench (download from mysql.com)
# Power BI Desktop (free download from microsoft.com/powerbi)
```

### Step 1 — Run the Python Notebook

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/ipl-cricket-analytics.git
cd ipl-cricket-analytics

# Place the raw data files in the project root
# (matches.csv and deliveries.csv — already in raw_data/ folder)
cp raw_data/matches.csv .
cp raw_data/deliveries.csv .

# Launch Jupyter
jupyter notebook IPL_Cricket_Analysis.ipynb
```

Run all cells top to bottom. The notebook will:
- Perform the full analysis
- Generate all charts
- Export **14 clean CSV files** into an `ipl_sql_data/` folder automatically

### Step 2 — Run the SQL File

```sql
-- In MySQL Workbench:
-- 1. Open IPL_Cricket_Analysis.sql
-- 2. Update 'YOUR_PATH/' in all LOAD DATA statements
--    to the path of your ipl_sql_data/ folder
--    (OR use Table Data Import Wizard — right-click table → Import Wizard)
-- 3. Run the file top to bottom (Ctrl+Shift+Enter)
```

**Finding your MySQL file path:**
```sql
SHOW VARIABLES LIKE 'secure_file_priv';
-- Copy this path and place your CSV files there
```

### Step 3 — Open the Power BI Dashboard

1. Open `Ipl_Dashboard.pbix` in **Power BI Desktop**
2. Go to **Home → Transform Data → Data Source Settings**
3. Update the file paths to point to your local `clean_data/` folder
4. Click **Home → Refresh** — all 8 pages will load with your data

---

## 📈 Results & Business Impact

| Analysis | Finding | Business Value |
|----------|---------|----------------|
| Toss analysis (Chi-Square) | p > 0.05 → not significant | Teams should stop over-strategising around toss |
| Venue scoring patterns | Wankhede/Chinnaswamy = highest avg scores | Pick extra batting cover for these venues |
| Phase-wise run rate heatmap | Team-specific phase weaknesses identified | Coaching staff can target gap in squad |
| MVP composite score | All-rounders identified by combined contribution | Best value signings at auction (2 roles for 1 price) |
| **Clutch Factor Index** | Playoff performance ≠ league performance for many stars | Redefines auction valuation in knockout-format tournaments |

**If deployed by a franchise's analytics team**, the CFI metric alone could save 5–15 crore per auction cycle by identifying undervalued clutch players and avoiding overpaying for big names who underperform in knockouts.

---

## 🗄️ SQL File Overview

The SQL file (`IPL_Cricket_Analysis.sql`) is structured in 6 sections:

| Section | Contents |
|---------|----------|
| Section 1 | `CREATE DATABASE ipl_db` + `USE ipl_db` |
| Section 2 | 12 `CREATE TABLE` statements (DDL) matching each clean CSV |
| Section 3 | `LOAD DATA LOCAL INFILE` for all 12 tables + step-by-step Import Wizard instructions |
| Section 4 | **20 analytical queries** (Q01–Q20): 7 basic → 6 intermediate → 7 advanced with CTEs + Window Functions |
| Section 5 | **10 Power BI views** (`vw_batting_stats`, `vw_bowling_stats`, `vw_clutch_index`, etc.) |
| Section 6 | Performance indexes on all FK and commonly filtered columns |

**Advanced SQL concepts used:**
- `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` window functions
- `LAG()` for year-over-year comparisons
- CTEs (Common Table Expressions) for multi-step queries
- Running totals with `SUM() OVER (ROWS BETWEEN UNBOUNDED PRECEDING...)`
- Chi-Square equivalent logic in SQL
- Conditional aggregation with `CASE WHEN`

---

## 📊 Power BI Dashboard

The dashboard contains **8 interactive pages**:

| Page | Focus | Key Visual |
|------|-------|-----------|
| 🏠 Home | Overview + KPI cards + navigation | 8 KPI cards + mini charts |
| 🏏 Batting | Career batting stats per player | Scatter: Runs vs Strike Rate |
| 🎳 Bowling | Career bowling stats per bowler | Quadrant chart: Wickets vs Economy |
| 🏆 Season Leaders | Orange Cap, Purple Cap, Champions | Tile slicer by year |
| 🏟️ Team & Venue | Win %, venue scoring, toss analysis | Funnel chart by win % |
| 🤝 Partnerships & Phase | Top pairs + phase run rates | Radar/Spider chart per team |
| ⭐ MVP & All-Rounders | Composite MVP score + tiers | Tier-coloured bar chart |
| 🔥 Clutch Factor | CFI ranking with league vs playoff scatter | CFI bar + diagonal scatter |

**Theme:** Dark IPL-branded (`#0D1117` background, `#F0B80D` gold accent)

---

## 📝 File Descriptions

| File | Size | Description |
|------|------|-------------|
| `IPL_Cricket_Analysis.ipynb` | ~1.4 MB | Full Jupyter notebook — 91 cells covering all 8 analysis steps with charts and findings |
| `IPL_Cricket_Analysis.sql` | ~32 KB | MySQL file — 1,040 lines, 12 tables, 20 queries, 10 views, indexes |
| `Ipl_Dashboard.pbix` | ~5 MB | Power BI dashboard — 8 pages, dark theme, interactive |
| `raw_data/matches.csv` | ~234 KB | Original Kaggle matches data — unmodified |
| `raw_data/deliveries.csv` | ~24 MB | Original Kaggle deliveries data — unmodified |
| `clean_data/*.csv` | ~87 MB total | 14 clean CSVs exported by Python for MySQL import |

---

## 🤝 Connect

If you found this project useful or have feedback, feel free to connect:

- **LinkedIn:** https://www.linkedin.com/in/siddharthkeshwani/
- **Portfolio:** https://github.com/Siddharthkeshwani
- **Email:** siddharthkeshwani10@gmail.com/sidkeshwani16@gmail.com

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

The dataset is sourced from Kaggle under their public dataset terms. Original data credits to the IPL dataset maintainers.

---

<div align="center">

**⭐ If this project helped you, please give it a star — it helps others find it too.**

Made with 🏏 and a lot of data

</div>
