-- IPL CRICKET ANALYTICS --


SET GLOBAL local_infile = 1;

-- CREATE DATABASE

 DROP DATABASE IF EXISTS ipl_db;

CREATE DATABASE IF NOT EXISTS ipl_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE ipl_db;


-- CREATING TABLE STRUCTURES

-- TABLE 1: matches_clean

DROP TABLE IF EXISTS matches_clean;

CREATE TABLE matches_clean (
    id               INT            NOT NULL,
    season           VARCHAR(10)    NOT NULL,
    city             VARCHAR(60),            
    match_date       DATE           NOT NULL,   
    match_type       VARCHAR(30)    NOT NULL,
    player_of_match  VARCHAR(60),
    venue            VARCHAR(120)   NOT NULL,   
    team1            VARCHAR(60)    NOT NULL,   
    team2            VARCHAR(60)    NOT NULL,   
    toss_winner      VARCHAR(60)    NOT NULL,
    toss_decision    VARCHAR(10)    NOT NULL,
    winner           VARCHAR(60),            
    result           VARCHAR(20)    NOT NULL,
    result_margin    FLOAT,
    target_runs      FLOAT,  
    target_overs     FLOAT,
    super_over       VARCHAR(2)     NOT NULL,
    method           VARCHAR(10),
    umpire1          VARCHAR(60)    NOT NULL,
    umpire2          VARCHAR(60)    NOT NULL,
    season_year      SMALLINT       NOT NULL,   
    is_playoff       TEXT     NOT NULL,
    PRIMARY KEY (id)
);


-- TABLE 2: deliveries_clean

DROP TABLE IF EXISTS deliveries_clean;

CREATE TABLE deliveries_clean (
    row_id           BIGINT         NOT NULL AUTO_INCREMENT,
    match_id         INT            NOT NULL,
    inning           TINYINT        NOT NULL,
    batting_team     VARCHAR(60)    NOT NULL,
    bowling_team     VARCHAR(60)    NOT NULL,
    over_num         TINYINT        NOT NULL,
    ball_num         TINYINT        NOT NULL,
    batter           VARCHAR(60)    NOT NULL,
    bowler           VARCHAR(60)    NOT NULL,
    non_striker      VARCHAR(60)    NOT NULL,
    batsman_runs     TINYINT        NOT NULL,
    extra_runs       TINYINT        NOT NULL,
    total_runs       TINYINT        NOT NULL,
    extras_type      VARCHAR(20),
    is_wicket        TINYINT(1)     NOT NULL, 
    player_dismissed VARCHAR(60),
    dismissal_kind   VARCHAR(40),
    fielder          VARCHAR(60),
    PRIMARY KEY (row_id),
    INDEX idx_dc_match_id (match_id),
    INDEX idx_dc_batter   (batter),
    INDEX idx_dc_bowler   (bowler),
    FOREIGN KEY (match_id) REFERENCES matches_clean(id)
);


-- TABLE 3: master

DROP TABLE IF EXISTS master;

CREATE TABLE master (
    -- original delivery columns
    match_id         INT            NOT NULL,
    inning           TINYINT        NOT NULL,
    batting_team     VARCHAR(60)    NOT NULL,
    bowling_team     VARCHAR(60)    NOT NULL,
    over_num         TINYINT        NOT NULL,
    ball_num         TINYINT        NOT NULL,
    batter           VARCHAR(60)    NOT NULL,
    bowler           VARCHAR(60)    NOT NULL,
    non_striker      VARCHAR(60)    NOT NULL,
    batsman_runs     TINYINT        NOT NULL,
    extra_runs       TINYINT        NOT NULL,
    total_runs       TINYINT        NOT NULL,
    extras_type      VARCHAR(20),
    is_wicket        TINYINT(1)     NOT NULL,
    player_dismissed VARCHAR(60),
    dismissal_kind   VARCHAR(40),
    fielder          VARCHAR(60),
    -- Below are match data joined from matches in Python
    id               INT,
    season_year      SMALLINT       NOT NULL,
    city             VARCHAR(60),
    match_date       DATE,
    venue            VARCHAR(120),
    toss_winner      VARCHAR(60),
    toss_decision    VARCHAR(10),
    winner           VARCHAR(60),
    player_of_match  VARCHAR(60),
    result           VARCHAR(20),
    match_type       VARCHAR(30),
    super_over       VARCHAR(2),
    -- Below are the feature engineering columns created in Python
    phase            VARCHAR(25)    NOT NULL,
    is_boundary      TINYINT(1)     NOT NULL,
    is_six           TINYINT(1)     NOT NULL,
    is_four          TINYINT(1)     NOT NULL,
    is_dot_ball      TINYINT(1)     NOT NULL,
    INDEX idx_master_match_id (match_id),
    INDEX idx_master_batter   (batter),
    INDEX idx_master_bowler   (bowler),
    INDEX idx_master_season   (season_year),
    INDEX idx_master_phase    (phase),
    INDEX idx_master_team     (batting_team)
);


-- TABLE 4: batting_stats

DROP TABLE IF EXISTS batting_stats;

CREATE TABLE batting_stats (
    batter           VARCHAR(60)    NOT NULL,
    total_runs       INT            NOT NULL,
    balls_faced      INT            NOT NULL,
    fours            INT            NOT NULL,
    sixes            INT            NOT NULL,
    innings          INT            NOT NULL,   
    strike_rate      DECIMAL(6,2)   NOT NULL,
    dismissals       INT            NOT NULL,
    batting_avg      DECIMAL(7,2)   NOT NULL,
    centuries        INT            NOT NULL,
    half_centuries   INT            NOT NULL,
    PRIMARY KEY (batter)
);


-- TABLE 5: bowling_stats

DROP TABLE IF EXISTS bowling_stats;

CREATE TABLE bowling_stats (
    bowler           VARCHAR(60)    NOT NULL,
    balls_bowled     INT            NOT NULL,
    runs_conceded    INT            NOT NULL,
    wickets          INT            NOT NULL,
    dot_balls        INT            NOT NULL,
    economy          DECIMAL(5,2)   NOT NULL,
    bowling_avg      DECIMAL(7,2),
    dot_ball_pct     DECIMAL(5,2)   NOT NULL,
    PRIMARY KEY (bowler)
);


-- TABLE 6: team_performance

DROP TABLE IF EXISTS team_performance;

CREATE TABLE team_performance (
    team             VARCHAR(60)    NOT NULL,
    total_played     INT            NOT NULL,
    wins             INT            NOT NULL,
    win_pct          DECIMAL(5,1)   NOT NULL,
    PRIMARY KEY (team)
);

-- TABLE 7: venue_stats

DROP TABLE IF EXISTS venue_stats;

CREATE TABLE venue_stats (
    venue            VARCHAR(120)   NOT NULL,
    avg_score        DECIMAL(6,2)   NOT NULL,
    matches          INT            NOT NULL,
    PRIMARY KEY (venue)
);

-- TABLE 8: partnerships

DROP TABLE IF EXISTS partnerships;

CREATE TABLE partnerships (
    pair             VARCHAR(130)   NOT NULL,
    partnership_runs INT            NOT NULL,
    PRIMARY KEY (pair)
);

-- TABLE 9: phase_stats

DROP TABLE IF EXISTS phase_stats;

CREATE TABLE phase_stats (
    batting_team     VARCHAR(60)    NOT NULL,
    phase            VARCHAR(25)    NOT NULL,
    runs             INT            NOT NULL,
    balls            INT            NOT NULL,
    run_rate         DECIMAL(5,2)   NOT NULL,
    PRIMARY KEY (batting_team, phase)
);

-- TABLE 10: mvp_scores

DROP TABLE IF EXISTS mvp_scores;

CREATE TABLE mvp_scores (
    batter           VARCHAR(60)    NOT NULL,
    total_runs       DECIMAL(10,2)  NOT NULL,
    strike_rate      DECIMAL(6,2)   NOT NULL,
    wickets          DECIMAL(6,2)   NOT NULL,
    economy          DECIMAL(5,2)   NOT NULL,
    mvp_score        DECIMAL(8,2)   NOT NULL,
    PRIMARY KEY (batter)
);

-- TABLE 11: clutch_factor

DROP TABLE IF EXISTS clutch_factor;

CREATE TABLE clutch_factor (
    batter                VARCHAR(60)    NOT NULL,
    playoff_innings_count INT            NOT NULL,
    playoff_runs          INT            NOT NULL,
    playoff_avg           DECIMAL(7,2)   NOT NULL,
    league_innings_count  INT            NOT NULL,
    league_runs           INT            NOT NULL,
    league_avg            DECIMAL(7,2)   NOT NULL,
    cfi                   DECIMAL(6,3)   NOT NULL,
    PRIMARY KEY (batter)
);

-- TABLE 12: season_leaders

DROP TABLE IF EXISTS season_leaders;

CREATE TABLE season_leaders (
    season_year         SMALLINT       NOT NULL,
    orange_cap_winner   VARCHAR(60),
    runs                INT,
    purple_cap_winner   VARCHAR(60),
    wickets             INT,
    champion            VARCHAR(60),
    PRIMARY KEY (season_year)
);

-- LOADING DATA INTO TABLES

-- matches_clean
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/matches_clean.csv'
INTO TABLE matches_clean
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, season, @city, @dt, match_type, @pom, venue, team1, team2,
 toss_winner, toss_decision, @winner, result, @rm, @tr, @to,
 super_over, @method, umpire1, umpire2, season_year, is_playoff)
SET match_date      = STR_TO_DATE(@dt, '%Y-%m-%d'),
    city            = NULLIF(@city,   ''),
    player_of_match = NULLIF(@pom,    ''),
    winner          = NULLIF(@winner, ''),
    result_margin   = NULLIF(@rm,     ''),
    target_runs     = NULLIF(@tr,     ''),
    target_overs    = NULLIF(@to,     ''),
    method          = NULLIF(@method, '');

-- deliveries_clean
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/deliveries_clean.csv'
INTO TABLE deliveries_clean
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(match_id, inning, batting_team, bowling_team, over_num, ball_num,
 batter, bowler, non_striker, batsman_runs, extra_runs, total_runs,
 @xt, is_wicket, @pd, @dk, @fld)
SET extras_type      = NULLIF(@xt,  ''),
    player_dismissed = NULLIF(@pd,  ''),
    dismissal_kind   = NULLIF(@dk,  ''),
    fielder          = NULLIF(@fld, '');

-- master (large file, may take 1-2 minutes)
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/master.csv'
INTO TABLE master
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(match_id, inning, batting_team, bowling_team, over_num, ball_num,
 batter, bowler, non_striker, batsman_runs, extra_runs, total_runs,
 @xt, is_wicket, @pd, @dk, @fld,
 @id, season_year, @city, @dt, @venue, @tw, @td, @winner, @pom,
 @result, @match_type, @so, phase, is_boundary, is_six, is_four, is_dot_ball)
SET id               = NULLIF(@id,    ''),
    city             = NULLIF(@city,  ''),
    match_date       = NULLIF(STR_TO_DATE(@dt, '%Y-%m-%d'), NULL),
    venue            = NULLIF(@venue, ''),
    toss_winner      = NULLIF(@tw,   ''),
    toss_decision    = NULLIF(@td,   ''),
    winner           = NULLIF(@winner,''),
    player_of_match  = NULLIF(@pom,  ''),
    result           = NULLIF(@result,''),
    match_type       = NULLIF(@match_type,''),
    super_over       = NULLIF(@so,   ''),
    extras_type      = NULLIF(@xt,   ''),
    player_dismissed = NULLIF(@pd,   ''),
    dismissal_kind   = NULLIF(@dk,   ''),
    fielder          = NULLIF(@fld,  '');

-- batting_stats
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/batting_stats.csv'
INTO TABLE batting_stats
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- bowling_stats
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/bowling_stats.csv'
INTO TABLE bowling_stats
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(bowler, balls_bowled, runs_conceded, wickets, dot_balls, economy, @bavg, dot_ball_pct)
SET bowling_avg = NULLIF(@bavg, '');

-- team_performance
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/team_performance.csv'
INTO TABLE team_performance
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- venue_stats
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/venue_stats.csv'
INTO TABLE venue_stats
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- partnerships
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/partnerships.csv'
INTO TABLE partnerships
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- phase_stats
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/phase_stats.csv'
INTO TABLE phase_stats
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- mvp_scores
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/mvp_scores.csv'
INTO TABLE mvp_scores
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- clutch_factor
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/clutch_factor.csv'
INTO TABLE clutch_factor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- season_leaders
LOAD DATA LOCAL INFILE 'C:/Users/hp/batch 367/AI framed Interview Questions/Resume Projects/data analytics/project 4 ipl/ipl/ipl analysis/ipl_sql_data/season_leaders.csv'
INTO TABLE season_leaders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(season_year, @oc, @r, @pc, @w, @ch)
SET orange_cap_winner = NULLIF(@oc, ''),
    runs              = NULLIF(@r,  ''),
    purple_cap_winner = NULLIF(@pc, ''),
    wickets           = NULLIF(@w,  ''),
    champion          = NULLIF(@ch, '');


-- Quick row count verification after loading all tables
SELECT 'matches_clean'    AS table_name, COUNT(*) AS ROWSS FROM matches_clean  UNION ALL
SELECT 'deliveries_clean',COUNT(*) FROM deliveries_clean UNION ALL
SELECT 'master', COUNT(*) FROM master UNION ALL
SELECT 'batting_stats', COUNT(*) FROM batting_stats UNION ALL
SELECT 'bowling_stats', COUNT(*) FROM bowling_stats UNION ALL
SELECT 'team_performance',COUNT(*) FROM team_performance UNION ALL
SELECT 'venue_stats', COUNT(*) FROM venue_stats UNION ALL
SELECT 'partnerships', COUNT(*) FROM partnerships UNION ALL
SELECT 'phase_stats', COUNT(*) FROM phase_stats UNION ALL
SELECT 'mvp_scores', COUNT(*) FROM mvp_scores UNION ALL
SELECT 'clutch_factor',COUNT(*) FROM clutch_factor UNION ALL
SELECT 'season_leaders',COUNT(*) FROM season_leaders;


--  ANALYTICAL QUERIES

-- Q01. How many matches were played in each IPL season?
-- Business question: Did the tournament grow over 17 years?

SELECT season_year,COUNT(*) AS total_matches
FROM matches_clean
GROUP BY season_year
ORDER BY season_year;

-- Q02. What percentage of matches were decided by runs vs wickets?
-- Business question: Is IPL a defender's game or a chaser's game?

SELECT result, COUNT(*) AS matches, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)  AS percentage
FROM matches_clean
WHERE result IN ('runs', 'wickets')
GROUP BY result;

-- Q03. Which team has won the most IPL titles?
-- Business question: Who are the most consistently excellent franchises?

SELECT winner AS champion_team, COUNT(*) AS titles_won
FROM matches_clean
WHERE match_type = 'Final'
AND winner IS NOT NULL
GROUP BY winner
ORDER BY titles_won DESC;

-- Q04. Which venues had the highest average first innings score?
-- Business question: Where should batsmen expect a batting paradise?

SELECT venue, ROUND(avg_score, 0) AS avg_first_innings,
matches AS times_hosted
FROM venue_stats
ORDER BY avg_score DESC
LIMIT 10;

-- Q05. How many sixes were hit in each IPL season?
-- Business question: Is T20 batting becoming more aggressive over time?

SELECT season_year,
SUM(is_six) AS total_sixes,
SUM(is_four) AS total_fours,
SUM(is_boundary) AS total_boundaries,
COUNT(*) AS total_balls,
ROUND(SUM(is_six) * 100.0 / COUNT(*), 2) AS six_pct_per_ball
FROM master
GROUP BY season_year
ORDER BY season_year;


-- Q06. Who has won the most Player of the Match awards in their career?
-- Business question: Who consistently produces match-winning individual performances?

SELECT player_of_match AS player,
COUNT(*) AS pom_awards
FROM matches_clean
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY pom_awards DESC
LIMIT 15;


-- Q07. Top 20 batting partnerships by total runs across all seasons
-- Business question: Which player combinations have the most batting chemistry?

SELECT pair,partnership_runs,
RANK() OVER (ORDER BY partnership_runs DESC) AS pair_rank
FROM partnerships
ORDER BY partnership_runs DESC
LIMIT 20;


-- Q08. Complete career batting profile for the top 20 run scorers
-- Business question: Give me every batting stat in one place for comparison

SELECT batter,total_runs,innings,balls_faced,
ROUND(strike_rate, 1) AS strike_rate,
ROUND(batting_avg, 1) AS batting_avg,
centuries,
half_centuries,
fours,
sixes,
ROUND((fours + sixes) * 100.0 / balls_faced, 1) AS boundary_pct
FROM batting_stats
ORDER BY total_runs DESC
LIMIT 20;


-- Q09. Complete career bowling profile for the top 20 wicket takers
-- Business question: Who are the most economical AND wicket-taking bowlers?

SELECT
bowler,
wickets,
ROUND(balls_bowled / 6.0, 1)  AS overs_bowled,
runs_conceded,
ROUND(economy, 2) AS economy_rate,
ROUND(bowling_avg, 1) AS bowling_avg,
dot_balls,
ROUND(dot_ball_pct, 1) AS dot_ball_pct
FROM bowling_stats
ORDER BY wickets DESC
LIMIT 20;


-- Q10. Phase-wise run rates for every team
-- Business question: Which phase does each team dominate or struggle in?

SELECT
batting_team,
MAX(CASE WHEN phase = 'Power Play (1-6)' THEN run_rate END)  AS powerplay_run_rate,
MAX(CASE WHEN phase = 'Middle (7-15)'    THEN run_rate END)  AS middle_run_rate,
MAX(CASE WHEN phase = 'Death (16-20)'    THEN run_rate END)  AS death_run_rate
FROM phase_stats
GROUP BY batting_team
ORDER BY powerplay_run_rate DESC;


-- Q11. Which players rank highly in BOTH batting AND bowling stats?
-- Business question: Who are the true all-rounders worth a premium?

SELECT
b.batter AS player,
b.total_runs,
b.strike_rate,
bw.wickets,
bw.economy,
m.mvp_score,
RANK() OVER (ORDER BY m.mvp_score DESC) AS mvp_rank
FROM batting_stats b
JOIN bowling_stats bw ON b.batter = bw.bowler
JOIN mvp_scores    m  ON b.batter = m.batter
WHERE b.total_runs >= 1500
AND bw.wickets   >= 50
ORDER BY m.mvp_score DESC;


-- Q12. Head-to-head win rates between major rivalry teams
-- Business question: Which team has the psychological edge in key rivalries?

SELECT
team1,team2,
COUNT(*) AS total_matches,
SUM(winner = team1) AS team1_wins,
SUM(winner = team2) AS team2_wins,
ROUND(SUM(winner = team1) * 100.0 / COUNT(*), 1) AS team1_win_pct
FROM matches_clean
WHERE winner IS NOT NULL
GROUP BY team1, team2
HAVING total_matches >= 8
ORDER BY total_matches DESC
LIMIT 15;




-- ── LEVEL 3: ADVANCED (CTEs + Window Functions) ─────────────────

-- Q13. Orange Cap race — season-by-season top run scorer using RANK()
-- Business question: Who dominated the batting charts each season?

WITH batting_per_season AS (
    -- step 1: total runs per player per season
SELECT
season_year, batter,
SUM(batsman_runs) AS season_runs
FROM master
GROUP BY season_year, batter
),
ranked_batters AS (
    -- step 2: rank within each season using RANK()
SELECT
season_year,batter,season_runs,
RANK() OVER (PARTITION BY season_year ORDER BY season_runs DESC) AS season_rank
FROM batting_per_season
)
-- step 3: keep only rank 1 per season (the Orange Cap winner)
SELECT
season_year,
batter AS orange_cap_winner,
season_runs AS runs_scored
FROM ranked_batters
WHERE season_rank = 1
ORDER BY season_year;


-- Q14. Purple Cap race — season-by-season top wicket taker using RANK()
-- Business question: Which bowlers dominated each season?

WITH wickets_per_season AS (
    -- step 1: count only bowler-credited wickets (not run outs)
SELECT
season_year, bowler,
SUM(CASE WHEN dismissal_kind IN('caught','bowled','lbw','stumped','caught and bowled','hit wicket') THEN 1 ELSE 0 END) AS season_wickets
FROM master
GROUP BY season_year, bowler
),
ranked_bowlers AS (
    -- step 2: rank bowlers within each season
SELECT
season_year,bowler,season_wickets,
RANK() OVER (PARTITION BY season_year ORDER BY season_wickets DESC) AS season_rank
FROM wickets_per_season
)
-- step 3: keep only rank 1 (Purple Cap winner)
SELECT
season_year,
bowler AS purple_cap_winner,
season_wickets AS wickets
FROM ranked_bowlers
WHERE season_rank = 1
ORDER BY season_year;


-- Q15. YoY rank change for batsmen — who is rising vs falling?
-- Uses LAG() window function to compare consecutive seasons

WITH season_runs AS (
    -- step 1: runs per player per season (min 100 runs to be ranked)
SELECT
season_year, 
batter,
SUM(batsman_runs) AS runs
FROM master
GROUP BY season_year, batter
HAVING runs >= 100
),
season_rank AS (
    -- step 2: rank within each season
SELECT
season_year,
batter,
runs,
RANK() OVER (PARTITION BY season_year ORDER BY runs DESC) AS curr_rank
FROM season_runs
),
with_prev AS (
    -- step 3: use LAG() to get the same player's rank in the previous season
SELECT
season_year,
batter,
runs,
curr_rank,
LAG(curr_rank) OVER (PARTITION BY batter ORDER BY season_year) AS prev_rank
FROM season_rank
)
-- step 4: calculate the rank change using CAST to allow negative numbers
SELECT
season_year, 
batter, 
runs, 
curr_rank, 
prev_rank,
(CAST(curr_rank AS SIGNED) - CAST(prev_rank AS SIGNED)) AS rank_change
FROM with_prev
WHERE prev_rank IS NOT NULL
ORDER BY ABS(CAST(curr_rank AS SIGNED) - CAST(prev_rank AS SIGNED)) DESC
LIMIT 25;


-- Q16. Clutch Factor Index — who performs better in playoffs vs league?
-- Business question: Which players show up when the trophy is on the line?

SELECT
batter AS player,
playoff_innings_count AS playoff_innings,
ROUND(league_avg, 1) AS league_avg,
ROUND(playoff_avg, 1) AS playoff_avg,
ROUND(cfi, 3) AS clutch_factor_index,
RANK() OVER (ORDER BY cfi DESC)  AS cfi_rank,
CASE
WHEN cfi >= 1.2  THEN 'Clutch Legend (CFI 1.2+)'
WHEN cfi >= 1.0  THEN 'Clutch Performer (CFI 1.0-1.2)'
WHEN cfi >= 0.85 THEN 'Slight Decline (CFI 0.85-1.0)'
ELSE                  'Struggles in Playoffs (CFI below 0.85)'
END  AS clutch_label
FROM clutch_factor
ORDER BY cfi DESC;


-- Q17. Most consistent batsmen — lowest score variance (std deviation)
-- Business question: Who can I rely on for steady contributions every game?

WITH per_innings AS (
    -- step 1: get each player's score in every innings
SELECT
batter,match_id,inning,
SUM(batsman_runs) AS innings_score
FROM master
GROUP BY batter, match_id, inning
),
stats AS (
    -- step 2: compute average and std deviation per player
SELECT
batter,
COUNT(*) AS innings_played,
ROUND(AVG(innings_score), 1) AS avg_score,
ROUND(STD(innings_score), 1) AS score_std_dev
FROM per_innings
GROUP BY batter
HAVING innings_played >= 50
AND avg_score >= 20
)
SELECT
batter, innings_played, avg_score, score_std_dev,
ROUND(score_std_dev / avg_score, 3)  AS consistency_ratio
FROM stats
ORDER BY consistency_ratio ASC
LIMIT 20;


-- Q18. Death over specialists — who bowls best in overs 16-20?
-- Business question: Which bowler should I use in the final 5 overs?

WITH death_stats AS (
    -- step 1: filter to death over deliveries only
SELECT
bowler,
COUNT(*) AS death_balls,
SUM(total_runs)  AS death_runs,
SUM(is_wicket)   AS death_wickets,
SUM(is_dot_ball) AS death_dots
FROM master
WHERE over_num BETWEEN 15 AND 19
GROUP BY bowler
HAVING death_balls >= 200 
)
SELECT
bowler,death_balls,
ROUND(death_balls / 6.0, 1) AS death_overs,
death_runs,
ROUND(death_runs * 6.0 / death_balls, 2) AS death_economy,
death_wickets,
ROUND(death_dots * 100.0 / death_balls, 1) AS death_dot_pct
FROM death_stats
ORDER BY death_economy ASC
LIMIT 15;


-- Q19. Season-by-season team win rate trend — who improved most?
-- Uses LAG() to compare win rates across consecutive seasons

WITH team_records AS (
    -- step 1: get wins and matches per team per season
SELECT
season_year,team_name,
COUNT(*) AS matches_played,
SUM(won) AS wins
FROM (
	-- teams appear as both team1 and team2 so we union both
SELECT season_year, team1 AS team_name, (winner = team1) AS won
FROM matches_clean WHERE winner IS NOT NULL
UNION ALL
SELECT season_year, team2 AS team_name, (winner = team2) AS won
FROM matches_clean WHERE winner IS NOT NULL
) AS all_records
GROUP BY season_year, team_name
HAVING matches_played >= 10
),
win_rates AS (
    -- step 2: calculate win rate per season
SELECT
season_year, team_name,
ROUND(wins * 100.0 / matches_played, 1) AS win_rate
FROM team_records
),
with_lag AS (
    -- step 3: use LAG() to get the previous season's win rate
SELECT
season_year, team_name, win_rate,
LAG(win_rate) OVER (PARTITION BY team_name ORDER BY season_year) AS prev_win_rate
FROM win_rates
)
-- step 4: calculate year-on-year change
SELECT
season_year,
team_name,
win_rate,
ROUND(prev_win_rate, 1) AS prev_season_win_rate,
ROUND(win_rate - prev_win_rate, 1) AS yoy_change
FROM with_lag
WHERE prev_win_rate IS NOT NULL
ORDER BY ABS(win_rate - prev_win_rate) DESC
LIMIT 20;


-- Q20. Complete player scorecard — batting + bowling + MVP + CFI combined
-- Business question: Give franchise owners one row per player with everything they need

WITH batting AS (
SELECT batter, total_runs, innings, strike_rate, batting_avg, centuries, half_centuries
FROM batting_stats),
bowling AS (
SELECT bowler, wickets, economy, bowling_avg, dot_ball_pct
FROM bowling_stats),
mvp AS (
SELECT batter, mvp_score,
RANK() OVER (ORDER BY mvp_score DESC) AS mvp_rank
FROM mvp_scores),
cfi AS (
SELECT batter, cfi,
RANK() OVER (ORDER BY cfi DESC) AS cfi_rank,
CASE
WHEN cfi >= 1.2  THEN 'Clutch Legend'
WHEN cfi >= 1.0  THEN 'Clutch Performer'
WHEN cfi >= 0.85 THEN 'Slight Decline'
ELSE 'Struggles in Playoffs'
END AS clutch_label
FROM clutch_factor)
-- final join: batting is the base, everything else joins to it
SELECT
bat.batter AS player,
bat.total_runs,
bat.innings,
ROUND(bat.strike_rate, 1) AS strike_rate,
ROUND(bat.batting_avg, 1) AS batting_avg,
bat.centuries,
bat.half_centuries,
bwl.wickets,
ROUND(bwl.economy, 2) AS economy_rate,
ROUND(bwl.bowling_avg, 1) AS bowling_avg,
ROUND(bwl.dot_ball_pct, 1) AS dot_ball_pct,
ROUND(mvp.mvp_score, 2) AS mvp_score,
mvp.mvp_rank,
ROUND(cfi.cfi, 3) AS clutch_factor_index,
cfi.cfi_rank,
cfi.clutch_label
FROM batting bat
LEFT JOIN bowling bwl ON bat.batter = bwl.bowler
LEFT JOIN mvp ON bat.batter = mvp.batter
LEFT JOIN cfi ON bat.batter = cfi.batter
ORDER BY mvp.mvp_score DESC
LIMIT 30;


-- CREATING VIEWS FOR POWER BI

-- Creating these views so Power BI can connect directly.
-- In Power BI: Home > Get Data > MySQL > Connect to ipl_db

-- View 1: Batting Stats (for Batting Dashboard tab in Power BI)
CREATE OR REPLACE VIEW vw_batting_stats AS
SELECT
batter,
total_runs,
innings,
balls_faced,
fours,
sixes,
ROUND(strike_rate, 1) AS strike_rate,
ROUND(batting_avg, 1) AS batting_avg,
centuries,
half_centuries,
ROUND((fours + sixes) * 100.0 / balls_faced, 1) AS boundary_pct
FROM batting_stats
ORDER BY total_runs DESC;

-- View 2: Bowling Stats (for Bowling Dashboard tab in Power BI)
CREATE OR REPLACE VIEW vw_bowling_stats AS
SELECT
bowler,
wickets,
ROUND(balls_bowled / 6.0, 1) AS overs_bowled,
runs_conceded,
ROUND(economy, 2) AS economy_rate,
ROUND(bowling_avg, 1) AS bowling_avg,
dot_balls,
ROUND(dot_ball_pct, 1) AS dot_ball_pct
FROM bowling_stats
ORDER BY wickets DESC;


-- View 3: Season Leaders (for Season Timeline tab in Power BI)
CREATE OR REPLACE VIEW vw_season_leaders AS
SELECT
season_year,
orange_cap_winner,
runs AS orange_cap_runs,
purple_cap_winner,
wickets AS purple_cap_wickets,
champion AS ipl_champion
FROM season_leaders
ORDER BY season_year;


-- View 4: Team Performance (for Team Comparison tab in Power BI)
CREATE OR REPLACE VIEW vw_team_performance AS
SELECT
team,
total_played,
wins,
ROUND(win_pct, 1) AS win_pct,
RANK() OVER (ORDER BY win_pct DESC) AS win_rank
FROM team_performance
ORDER BY win_pct DESC;


-- View 5: Venue Stats (for Venue Map tab in Power BI)
CREATE OR REPLACE VIEW vw_venue_stats AS
SELECT
venue,
ROUND(avg_score, 0) AS avg_first_innings,
matches AS matches_hosted,
RANK() OVER (ORDER BY avg_score DESC) AS scoring_rank
FROM venue_stats
ORDER BY avg_score DESC;


-- View 6: Phase Stats (for Phase Analysis tab in Power BI)
CREATE OR REPLACE VIEW vw_phase_stats AS
SELECT
batting_team,phase,runs,balls,
ROUND(run_rate, 2) AS run_rate,
RANK() OVER (PARTITION BY phase ORDER BY run_rate DESC) AS phase_rank
FROM phase_stats
ORDER BY batting_team, phase;


-- View 7: Top Partnerships (for Partnership tab in Power BI)
CREATE OR REPLACE VIEW vw_partnerships AS
SELECT
pair,partnership_runs,
RANK() OVER (ORDER BY partnership_runs DESC) AS partnership_rank
FROM partnerships
ORDER BY partnership_runs DESC
LIMIT 50;


-- View 8: MVP Scores (for Player Value tab in Power BI)
CREATE OR REPLACE VIEW vw_mvp_scores AS
SELECT
batter AS player,
ROUND(total_runs, 0) AS career_runs,
ROUND(wickets, 0) AS career_wickets,
ROUND(strike_rate, 1) AS strike_rate,
ROUND(economy, 2) AS economy,
ROUND(mvp_score, 2) AS mvp_score,
RANK() OVER (ORDER BY mvp_score DESC) AS mvp_rank,
CASE
WHEN mvp_score >= 100 THEN 'S-Tier (Elite All-Rounder)'
WHEN mvp_score >= 70  THEN 'A-Tier (Premium Player)'
WHEN mvp_score >= 50  THEN 'B-Tier (Reliable Contributor)'
ELSE 'C-Tier (Specialist Role)'
END AS player_tier
FROM mvp_scores
ORDER BY mvp_score DESC;


-- View 9: Clutch Factor Index (for Clutch Analysis tab in Power BI)
CREATE OR REPLACE VIEW vw_clutch_index AS
SELECT
batter AS player,
league_innings_count,
ROUND(league_avg, 1) AS league_avg,
playoff_innings_count,
ROUND(playoff_avg, 1) AS playoff_avg,
ROUND(cfi, 3) AS clutch_factor_index,
RANK() OVER (ORDER BY cfi DESC) AS cfi_rank,
CASE
WHEN cfi >= 1.2  THEN 'Clutch Legend'
WHEN cfi >= 1.0  THEN 'Clutch Performer'
WHEN cfi >= 0.85 THEN 'Slight Decline'
ELSE 'Struggles in Playoffs'
END AS clutch_label
FROM clutch_factor
ORDER BY cfi DESC;


-- View 10: Aggregated Master (for custom Power BI queries — avoids loading 260K rows)
CREATE OR REPLACE VIEW vw_master_summary AS
SELECT
season_year,batting_team,phase,
COUNT(*) AS total_balls,
SUM(batsman_runs) AS total_bat_runs,
SUM(total_runs) AS total_runs_incl_extras,
SUM(is_boundary) AS boundaries,
SUM(is_six) AS sixes,
SUM(is_four) AS fours,
SUM(is_dot_ball) AS dot_balls,
SUM(is_wicket) AS wickets_lost,
ROUND(SUM(total_runs) * 6.0 / COUNT(*), 2) AS run_rate
FROM master
GROUP BY season_year, batting_team, phase
ORDER BY season_year, batting_team, phase;


-- SECTION 6 — INDEXES (Performance Tuning)

-- Indexes speed up SELECT queries on large tables.
-- Create on columns used in WHERE, JOIN, GROUP BY, ORDER BY.

-- master table indexes
CREATE INDEX idx_m_season_team   ON master (season_year, batting_team);
CREATE INDEX  idx_m_batter_season ON master (batter, season_year);
CREATE INDEX idx_m_bowler_season ON master (bowler, season_year);
CREATE INDEX  idx_m_phase ON master (phase);
CREATE INDEX  idx_m_inning ON master (inning);

-- matches_clean indexes
CREATE INDEX idx_mc_season ON matches_clean (season_year);
CREATE INDEX  idx_mc_match_type ON matches_clean (match_type);
CREATE INDEX  idx_mc_venue ON matches_clean (venue);
CREATE INDEX  idx_mc_winner ON matches_clean (winner);

-- deliveries_clean indexes
CREATE INDEX idx_dc_batter ON deliveries_clean (batter);
CREATE INDEX  idx_dc_bowler ON deliveries_clean (bowler);
CREATE INDEX  idx_dc_match ON deliveries_clean (match_id);

-- analysis table indexes
CREATE INDEX idx_bat_runs ON batting_stats (total_runs);
CREATE INDEX idx_bwl_wickets ON bowling_stats (wickets);
CREATE INDEX  idx_mvp_score ON mvp_scores (mvp_score);
CREATE INDEX idx_cfi ON clutch_factor (cfi);

-- Show all tables created
SHOW TABLES;

-- Show all views created
SELECT TABLE_NAME AS view_name
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'ipl_db'
ORDER BY TABLE_NAME;

-- Final row count check
SELECT 'master'AS tbl, COUNT(*) AS loaded_rows FROM master UNION ALL
SELECT 'batting_stats', COUNT(*) FROM batting_stats    UNION ALL
SELECT 'bowling_stats', COUNT(*) FROM bowling_stats    UNION ALL
SELECT 'clutch_factor', COUNT(*) FROM clutch_factor    UNION ALL
SELECT 'season_leaders',COUNT(*) FROM season_leaders   UNION ALL
SELECT 'partnerships', COUNT(*) FROM partnerships;


