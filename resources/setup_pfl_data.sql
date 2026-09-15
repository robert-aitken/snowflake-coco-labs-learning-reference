-- ============================================================================
-- PFL Dataset — DDL for Cortex Code in Snowsight Lab
-- Tables: 12 base tables + 2 views (subset of full PFL schema)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS PFL_DB;
USE DATABASE PFL_DB;

CREATE SCHEMA IF NOT EXISTS STATS_AND_INFO;
USE SCHEMA STATS_AND_INFO;

CREATE OR REPLACE TABLE conferences (
    conference_id       VARCHAR(2) PRIMARY KEY,
    conference_name     VARCHAR(50) NOT NULL,
    conference_abbrev   VARCHAR(2) NOT NULL,
    founded_year        INTEGER NOT NULL
);

CREATE OR REPLACE TABLE divisions (
    division_id         VARCHAR(10) PRIMARY KEY,
    conference_id       VARCHAR(2) NOT NULL,
    division_name       VARCHAR(50) NOT NULL,
    division_abbrev     VARCHAR(10) NOT NULL
);

CREATE OR REPLACE TABLE teams (
    team_id             VARCHAR(3) PRIMARY KEY,
    division_id         VARCHAR(10) NOT NULL,
    city                VARCHAR(50) NOT NULL,
    team_name           VARCHAR(50) NOT NULL,
    full_name           VARCHAR(100) NOT NULL,
    abbreviation        VARCHAR(3) NOT NULL,
    founded_year        INTEGER NOT NULL,
    stadium_name        VARCHAR(100) NOT NULL,
    stadium_capacity    INTEGER NOT NULL,
    primary_color       VARCHAR(7) NOT NULL,
    secondary_color     VARCHAR(7) NOT NULL
);

CREATE OR REPLACE TABLE positions (
    position_id         VARCHAR(5) PRIMARY KEY,
    position_name       VARCHAR(50) NOT NULL,
    position_group      VARCHAR(20) NOT NULL,
    position_category   VARCHAR(30) NOT NULL,
    typical_roster_count INTEGER NOT NULL
);

CREATE OR REPLACE TABLE seasons (
    season_id           INTEGER PRIMARY KEY,
    season_year         INTEGER NOT NULL,
    preseason_start     DATE NOT NULL,
    preseason_end       DATE NOT NULL,
    regular_season_start DATE NOT NULL,
    regular_season_end  DATE NOT NULL,
    postseason_start    DATE NOT NULL,
    postseason_end      DATE NOT NULL,
    super_bowl_date     DATE NOT NULL
);

CREATE OR REPLACE TABLE players (
    player_id           VARCHAR(10) PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    date_of_birth       DATE NOT NULL,
    height_inches       INTEGER NOT NULL,
    weight_lbs          INTEGER NOT NULL,
    college             VARCHAR(100) NOT NULL,
    draft_year          INTEGER,
    draft_round         INTEGER,
    draft_pick          INTEGER,
    primary_position_id VARCHAR(5) NOT NULL,
    years_pro           INTEGER DEFAULT 0,
    status              VARCHAR(20) DEFAULT 'Active'
);

CREATE OR REPLACE TABLE player_contracts (
    contract_id         VARCHAR(15) PRIMARY KEY,
    player_id           VARCHAR(10) NOT NULL,
    team_id             VARCHAR(3) NOT NULL,
    contract_start_date DATE NOT NULL,
    contract_end_date   DATE NOT NULL,
    total_value         DECIMAL(15,2) NOT NULL,
    guaranteed_money    DECIMAL(15,2) NOT NULL,
    signing_bonus       DECIMAL(15,2) DEFAULT 0,
    annual_salary       DECIMAL(15,2) NOT NULL,
    contract_type       VARCHAR(30) NOT NULL,
    is_active           BOOLEAN DEFAULT TRUE
);

CREATE OR REPLACE TABLE team_season_stats (
    stat_id             VARCHAR(15) PRIMARY KEY,
    team_id             VARCHAR(3) NOT NULL,
    season_id           INTEGER NOT NULL,
    wins                INTEGER DEFAULT 0,
    losses              INTEGER DEFAULT 0,
    ties                INTEGER DEFAULT 0,
    division_rank       INTEGER,
    made_playoffs       BOOLEAN DEFAULT FALSE,
    playoff_result      VARCHAR(30),
    points_scored       INTEGER DEFAULT 0,
    total_yards         INTEGER DEFAULT 0,
    passing_yards       INTEGER DEFAULT 0,
    rushing_yards       INTEGER DEFAULT 0,
    turnovers_committed INTEGER DEFAULT 0,
    points_allowed      INTEGER DEFAULT 0,
    yards_allowed       INTEGER DEFAULT 0,
    sacks               INTEGER DEFAULT 0,
    interceptions       INTEGER DEFAULT 0,
    turnovers_forced    INTEGER DEFAULT 0,
    offense_rank        INTEGER,
    defense_rank        INTEGER
);

CREATE OR REPLACE TABLE player_season_stats (
    stat_id             VARCHAR(20) PRIMARY KEY,
    player_id           VARCHAR(10) NOT NULL,
    team_id             VARCHAR(3) NOT NULL,
    season_id           INTEGER NOT NULL,
    games_played        INTEGER DEFAULT 0,
    games_started       INTEGER DEFAULT 0,
    pass_attempts       INTEGER DEFAULT 0,
    pass_completions    INTEGER DEFAULT 0,
    pass_yards          INTEGER DEFAULT 0,
    pass_touchdowns     INTEGER DEFAULT 0,
    pass_interceptions  INTEGER DEFAULT 0,
    passer_rating       DECIMAL(5,1),
    rush_attempts       INTEGER DEFAULT 0,
    rush_yards          INTEGER DEFAULT 0,
    rush_touchdowns     INTEGER DEFAULT 0,
    rush_fumbles        INTEGER DEFAULT 0,
    targets             INTEGER DEFAULT 0,
    receptions          INTEGER DEFAULT 0,
    receiving_yards     INTEGER DEFAULT 0,
    receiving_touchdowns INTEGER DEFAULT 0,
    tackles_total       INTEGER DEFAULT 0,
    sacks               DECIMAL(4,1) DEFAULT 0,
    interceptions       INTEGER DEFAULT 0,
    passes_defended     INTEGER DEFAULT 0,
    forced_fumbles      INTEGER DEFAULT 0,
    fumble_recoveries   INTEGER DEFAULT 0,
    fg_made             INTEGER DEFAULT 0,
    fg_attempts         INTEGER DEFAULT 0,
    xp_made             INTEGER DEFAULT 0,
    xp_attempts         INTEGER DEFAULT 0,
    punts               INTEGER DEFAULT 0,
    punt_yards          INTEGER DEFAULT 0,
    punt_avg            DECIMAL(4,1)
);

CREATE OR REPLACE TABLE games (
    game_id             VARCHAR(15) PRIMARY KEY,
    season_id           INTEGER NOT NULL,
    game_type           VARCHAR(20) NOT NULL,
    week_number         INTEGER,
    game_date           DATE NOT NULL,
    game_time           TIME NOT NULL,
    home_team_id        VARCHAR(3) NOT NULL,
    away_team_id        VARCHAR(3) NOT NULL,
    stadium_id          VARCHAR(10) NOT NULL,
    home_score          INTEGER,
    away_score          INTEGER,
    attendance          INTEGER,
    weather_temp_f      INTEGER,
    weather_condition   VARCHAR(30),
    weather_wind_mph    INTEGER,
    is_overtime         BOOLEAN DEFAULT FALSE,
    is_completed        BOOLEAN DEFAULT FALSE,
    broadcast_network   VARCHAR(20)
);

CREATE OR REPLACE TABLE game_team_stats (
    game_team_stat_id   VARCHAR(20) PRIMARY KEY,
    game_id             VARCHAR(15) NOT NULL,
    team_id             VARCHAR(3) NOT NULL,
    is_home_team        BOOLEAN NOT NULL,
    total_yards         INTEGER DEFAULT 0,
    passing_yards       INTEGER DEFAULT 0,
    rushing_yards       INTEGER DEFAULT 0,
    first_downs         INTEGER DEFAULT 0,
    third_down_attempts INTEGER DEFAULT 0,
    third_down_converts INTEGER DEFAULT 0,
    total_plays         INTEGER DEFAULT 0,
    possession_seconds  INTEGER DEFAULT 0,
    fumbles             INTEGER DEFAULT 0,
    fumbles_lost        INTEGER DEFAULT 0,
    interceptions_thrown INTEGER DEFAULT 0,
    penalties           INTEGER DEFAULT 0,
    penalty_yards       INTEGER DEFAULT 0,
    touchdowns          INTEGER DEFAULT 0,
    field_goals_made    INTEGER DEFAULT 0,
    field_goals_attempted INTEGER DEFAULT 0,
    sacks               INTEGER DEFAULT 0,
    interceptions_caught INTEGER DEFAULT 0,
    forced_fumbles      INTEGER DEFAULT 0
);

CREATE OR REPLACE TABLE draft_picks (
    pick_id             VARCHAR(15) PRIMARY KEY,
    season_id           INTEGER NOT NULL,
    round               INTEGER NOT NULL,
    pick_number         INTEGER NOT NULL,
    overall_pick        INTEGER NOT NULL,
    team_id             VARCHAR(3) NOT NULL,
    player_id           VARCHAR(10),
    player_name         VARCHAR(100) NOT NULL,
    position_id         VARCHAR(5) NOT NULL,
    college             VARCHAR(100) NOT NULL
);

-- ============================================================================
-- VIEWS
-- ============================================================================

CREATE OR REPLACE VIEW v_team_standings AS
SELECT
    s.season_year,
    c.conference_name,
    d.division_name,
    t.full_name AS team_name,
    ts.wins, ts.losses, ts.ties,
    ts.division_rank,
    ts.made_playoffs,
    ts.playoff_result,
    ts.points_scored,
    ts.points_allowed,
    ts.points_scored - ts.points_allowed AS point_differential
FROM team_season_stats ts
JOIN teams t ON ts.team_id = t.team_id
JOIN divisions d ON t.division_id = d.division_id
JOIN conferences c ON d.conference_id = c.conference_id
JOIN seasons s ON ts.season_id = s.season_id;

CREATE OR REPLACE VIEW v_passing_leaders AS
SELECT
    s.season_year,
    p.first_name || ' ' || p.last_name AS player_name,
    t.full_name AS team_name,
    pss.games_played,
    pss.pass_completions,
    pss.pass_attempts,
    ROUND(pss.pass_completions * 100.0 / NULLIF(pss.pass_attempts, 0), 1) AS completion_pct,
    pss.pass_yards,
    pss.pass_touchdowns,
    pss.pass_interceptions,
    pss.passer_rating
FROM player_season_stats pss
JOIN players p ON pss.player_id = p.player_id
JOIN teams t ON pss.team_id = t.team_id
JOIN seasons s ON pss.season_id = s.season_id
WHERE pss.pass_attempts >= 100;


-- ============================================================================
-- PFL Dataset — INSERT statements for Cortex Code in Snowsight Lab
-- Subset: 4 focal teams (NEM, KCR, DAL, CHI) + full reference data
-- ============================================================================

-- CONFERENCES
INSERT INTO conferences (conference_id, conference_name, conference_abbrev, founded_year) VALUES
('AU', 'American Union', 'AU', 1960),
('NA', 'National Alliance', 'NA', 1920);

-- DIVISIONS
INSERT INTO divisions (division_id, conference_id, division_name, division_abbrev) VALUES
('AU_EAST', 'AU', 'AU East', 'AU East'),
('AU_NORTH', 'AU', 'AU North', 'AU North'),
('AU_SOUTH', 'AU', 'AU South', 'AU South'),
('AU_WEST', 'AU', 'AU West', 'AU West'),
('NA_EAST', 'NA', 'NA East', 'NA East'),
('NA_NORTH', 'NA', 'NA North', 'NA North'),
('NA_SOUTH', 'NA', 'NA South', 'NA South'),
('NA_WEST', 'NA', 'NA West', 'NA West');

-- TEAMS (all 32)
INSERT INTO teams (team_id, division_id, city, team_name, full_name, abbreviation, founded_year, stadium_name, stadium_capacity, primary_color, secondary_color) VALUES
('BUF', 'AU_EAST', 'Buffalo', 'Bisons', 'Buffalo Bisons', 'BUF', 1960, 'Bison Stadium', 71608, '#00338D', '#C60C30'),
('MIA', 'AU_EAST', 'Miami', 'Sharks', 'Miami Sharks', 'MIA', 1966, 'Shark Tank', 65326, '#008E97', '#FC4C02'),
('NEM', 'AU_EAST', 'New England', 'Minutemen', 'New England Minutemen', 'NEM', 1960, 'Minuteman Field', 65878, '#002244', '#C60C30'),
('NYS', 'AU_EAST', 'New York', 'Skyscrapers', 'New York Skyscrapers', 'NYS', 1960, 'Skyscraper Stadium', 82500, '#003366', '#B0B7BC'),
('BAL', 'AU_NORTH', 'Baltimore', 'Poets', 'Baltimore Poets', 'BAL', 1996, 'Poets Arena', 71008, '#241773', '#9E7C0C'),
('CIN', 'AU_NORTH', 'Cincinnati', 'Tigers', 'Cincinnati Tigers', 'CIN', 1968, 'Tiger Stadium', 65515, '#FB4F14', '#000000'),
('CLE', 'AU_NORTH', 'Cleveland', 'Bridges', 'Cleveland Bridges', 'CLE', 1946, 'Bridge Field', 67431, '#311D00', '#FF3C00'),
('PIT', 'AU_NORTH', 'Pittsburgh', 'Blacksmiths', 'Pittsburgh Blacksmiths', 'PIT', 1933, 'Ironworks Field', 68400, '#FFB612', '#101820'),
('HOU', 'AU_SOUTH', 'Houston', 'Oilers', 'Houston Oilers', 'HOU', 2002, 'Petroleum Dome', 72220, '#03202F', '#A71930'),
('IND', 'AU_SOUTH', 'Indianapolis', 'Racers', 'Indianapolis Racers', 'IND', 1953, 'Raceway Dome', 67000, '#002C5F', '#A2AAAD'),
('JAX', 'AU_SOUTH', 'Jacksonville', 'Panthers', 'Jacksonville Panthers', 'JAX', 1995, 'Panther Stadium', 67814, '#006778', '#D7A22A'),
('TEN', 'AU_SOUTH', 'Tennessee', 'Volunteers', 'Tennessee Volunteers', 'TEN', 1960, 'Volunteer Field', 69143, '#4B92DB', '#C8102E'),
('DEN', 'AU_WEST', 'Denver', 'Miners', 'Denver Miners', 'DEN', 1960, 'Mile High Field', 76125, '#FB4F14', '#002244'),
('KCR', 'AU_WEST', 'Kansas City', 'Royals', 'Kansas City Royals', 'KCR', 1960, 'Royal Arena', 76416, '#E31837', '#FFB81C'),
('LVG', 'AU_WEST', 'Las Vegas', 'Gamblers', 'Las Vegas Gamblers', 'LVG', 1960, 'Casino Dome', 65000, '#A5ACAF', '#000000'),
('LAW', 'AU_WEST', 'Los Angeles', 'Waves', 'Los Angeles Waves', 'LAW', 1960, 'Wave Stadium', 70240, '#002244', '#FFA300'),
('DAL', 'NA_EAST', 'Dallas', 'Rangers', 'Dallas Rangers', 'DAL', 1960, 'Ranger Stadium', 80000, '#003594', '#869397'),
('NYG', 'NA_EAST', 'New York', 'Gothams', 'New York Gothams', 'NYG', 1925, 'Gotham Field', 82500, '#0B2265', '#A71930'),
('PHI', 'NA_EAST', 'Philadelphia', 'Hawks', 'Philadelphia Hawks', 'PHI', 1933, 'Hawk Stadium', 69176, '#004C54', '#A5ACAF'),
('WAS', 'NA_EAST', 'Washington', 'Federals', 'Washington Federals', 'WAS', 1932, 'Federal Field', 67617, '#5A1414', '#FFB612'),
('CHI', 'NA_NORTH', 'Chicago', 'Bruins', 'Chicago Bruins', 'CHI', 1920, 'Bruin Field', 61500, '#0B162A', '#C83803'),
('DET', 'NA_NORTH', 'Detroit', 'Tigers', 'Detroit Tigers', 'DET', 1930, 'Motor City Dome', 65000, '#0076B6', '#B0B7BC'),
('GBC', 'NA_NORTH', 'Green Bay', 'Cheeseheads', 'Green Bay Cheeseheads', 'GBC', 1919, 'Cheese Bowl', 81441, '#203731', '#FFB612'),
('MIN', 'NA_NORTH', 'Minnesota', 'Berzerkers', 'Minnesota Berzerkers', 'MIN', 1961, 'Viking Dome', 66860, '#4F2683', '#FFC62F'),
('ATL', 'NA_SOUTH', 'Atlanta', 'Firebirds', 'Atlanta Firebirds', 'ATL', 1966, 'Phoenix Dome', 71000, '#A71930', '#000000'),
('CAR', 'NA_SOUTH', 'Carolina', 'Wildcats', 'Carolina Wildcats', 'CAR', 1995, 'Wildcat Stadium', 74867, '#0085CA', '#101820'),
('NOR', 'NA_SOUTH', 'New Orleans', 'Jazz', 'New Orleans Jazz', 'NOR', 1967, 'Jazz Dome', 73208, '#D3BC8D', '#101820'),
('TBP', 'NA_SOUTH', 'Tampa Bay', 'Pirates', 'Tampa Bay Pirates', 'TBP', 1976, 'Pirate Cove', 65890, '#D50A0A', '#34302B'),
('ARI', 'NA_WEST', 'Arizona', 'Copperheads', 'Arizona Copperheads', 'ARI', 1920, 'Serpent Dome', 63400, '#97233F', '#000000'),
('LAS', 'NA_WEST', 'Los Angeles', 'Stars', 'Los Angeles Stars', 'LAS', 1946, 'Star Stadium', 70240, '#003594', '#FFA300'),
('SFP', 'NA_WEST', 'San Francisco', 'Prospectors', 'San Francisco Prospectors', 'SFP', 1946, 'Gold Rush Field', 68500, '#AA0000', '#B3995D'),
('SEA', 'NA_WEST', 'Seattle', 'Seagulls', 'Seattle Seagulls', 'SEA', 1976, 'Seagull Stadium', 68740, '#002244', '#69BE28');

-- POSITIONS
INSERT INTO positions (position_id, position_name, position_group, position_category, typical_roster_count) VALUES
('QB', 'Quarterback', 'Offense', 'Quarterback', 3),
('RB', 'Running Back', 'Offense', 'Running Back', 4),
('FB', 'Fullback', 'Offense', 'Running Back', 1),
('WR', 'Wide Receiver', 'Offense', 'Wide Receiver', 6),
('TE', 'Tight End', 'Offense', 'Tight End', 3),
('LT', 'Left Tackle', 'Offense', 'Offensive Line', 2),
('LG', 'Left Guard', 'Offense', 'Offensive Line', 2),
('C', 'Center', 'Offense', 'Offensive Line', 2),
('RG', 'Right Guard', 'Offense', 'Offensive Line', 2),
('RT', 'Right Tackle', 'Offense', 'Offensive Line', 1),
('DE', 'Defensive End', 'Defense', 'Defensive Line', 4),
('DT', 'Defensive Tackle', 'Defense', 'Defensive Line', 4),
('OLB', 'Outside Linebacker', 'Defense', 'Linebacker', 4),
('ILB', 'Inside Linebacker', 'Defense', 'Linebacker', 3),
('CB', 'Cornerback', 'Defense', 'Defensive Back', 6),
('FS', 'Free Safety', 'Defense', 'Defensive Back', 2),
('SS', 'Strong Safety', 'Defense', 'Defensive Back', 3),
('K', 'Kicker', 'Special Teams', 'Specialists', 1),
('P', 'Punter', 'Special Teams', 'Specialists', 1),
('LS', 'Long Snapper', 'Special Teams', 'Specialists', 1);

-- SEASONS (2022-2024)
INSERT INTO seasons (season_id, season_year, preseason_start, preseason_end, regular_season_start, regular_season_end, postseason_start, postseason_end, super_bowl_date) VALUES
(2022, 2022, '2022-08-11', '2022-09-01', '2022-09-08', '2023-01-08', '2023-01-14', '2023-02-12', '2023-02-12'),
(2023, 2023, '2023-08-10', '2023-08-31', '2023-09-07', '2024-01-07', '2024-01-13', '2024-02-11', '2024-02-11'),
(2024, 2024, '2024-08-08', '2024-08-29', '2024-09-05', '2025-01-05', '2025-01-11', '2025-02-09', '2025-02-09');

-- PLAYERS (40 players — 10 per focal team: NEM, KCR, DAL, CHI)
INSERT INTO players (player_id, first_name, last_name, date_of_birth, height_inches, weight_lbs, college, draft_year, draft_round, draft_pick, primary_position_id, years_pro, status) VALUES
('P100001', 'Marcus', 'Webb', '1996-03-15', 75, 225, 'Michigan', 2018, 1, 3, 'QB', 7, 'Active'),
('P100002', 'DeAndre', 'Hayes', '1998-07-22', 70, 215, 'Alabama', 2020, 2, 14, 'RB', 5, 'Active'),
('P100003', 'Tyler', 'Grant', '1997-11-08', 73, 198, 'Ohio State', 2019, 1, 18, 'WR', 6, 'Active'),
('P100004', 'Jordan', 'Bishop', '1999-04-30', 74, 205, 'LSU', 2021, 3, 22, 'WR', 4, 'Active'),
('P100005', 'Cole', 'Franklin', '1997-09-14', 77, 252, 'Stanford', 2019, 2, 8, 'TE', 6, 'Active'),
('P100006', 'Ryan', 'Marsh', '1995-01-20', 78, 312, 'Notre Dame', 2017, 1, 10, 'LT', 8, 'Active'),
('P100007', 'Xavier', 'Stone', '1998-06-05', 76, 268, 'Georgia', 2020, 1, 5, 'DE', 5, 'Active'),
('P100008', 'Nathan', 'Cruz', '1999-02-17', 73, 238, 'Penn State', 2021, 2, 12, 'ILB', 4, 'Active'),
('P100009', 'Jaylen', 'Moore', '2000-08-11', 71, 192, 'Florida', 2022, 1, 8, 'CB', 3, 'Active'),
('P100010', 'Brett', 'Santos', '1996-12-03', 72, 198, 'UCLA', 2018, 5, 2, 'K', 7, 'Active'),
('P100011', 'Blake', 'Turner', '2000-05-19', 74, 218, 'Texas', 2022, 1, 2, 'QB', 3, 'Active'),
('P100012', 'Carlos', 'Vega', '1999-10-25', 69, 208, 'USC', 2021, 3, 28, 'RB', 4, 'Active'),
('P100013', 'Dante', 'Williams', '1998-03-07', 72, 195, 'Clemson', 2020, 2, 20, 'WR', 5, 'Active'),
('P100014', 'Tre', 'Jackson', '2001-01-14', 73, 200, 'Oregon', 2023, 2, 15, 'WR', 2, 'Active'),
('P100015', 'Luke', 'Simmons', '1997-08-30', 76, 248, 'Iowa', 2019, 4, 5, 'TE', 6, 'Active'),
('P100016', 'Kyle', 'Norton', '1996-06-12', 75, 305, 'Wisconsin', 2018, 3, 10, 'C', 7, 'Active'),
('P100017', 'Andre', 'Brooks', '2000-11-28', 75, 295, 'Auburn', 2022, 2, 18, 'DT', 3, 'Active'),
('P100018', 'Troy', 'Barnes', '1999-07-09', 74, 245, 'Oklahoma', 2021, 3, 5, 'OLB', 4, 'Active'),
('P100019', 'Malik', 'Davis', '2001-04-22', 72, 210, 'Tennessee', 2023, 1, 8, 'SS', 2, 'Active'),
('P100020', 'Sam', 'Whitfield', '1998-09-16', 74, 215, 'BYU', 2020, 6, 1, 'P', 5, 'Active'),
('P100021', 'Jared', 'Cooper', '1997-02-28', 76, 230, 'Clemson', 2019, 1, 12, 'QB', 6, 'Active'),
('P100022', 'Terrence', 'Ford', '1999-12-10', 71, 220, 'Georgia', 2021, 1, 24, 'RB', 4, 'Active'),
('P100023', 'Chris', 'Palmer', '1998-05-03', 73, 200, 'Alabama', 2020, 1, 15, 'WR', 5, 'Active'),
('P100024', 'DeShawn', 'Harris', '2000-09-18', 74, 208, 'Michigan', 2022, 2, 22, 'WR', 3, 'Active'),
('P100025', 'Owen', 'Kelly', '1997-07-26', 77, 255, 'Michigan State', 2019, 3, 8, 'TE', 6, 'Active'),
('P100026', 'Ben', 'Wallace', '1996-04-08', 76, 318, 'Tennessee', 2018, 2, 5, 'RG', 7, 'Active'),
('P100027', 'Isaiah', 'Watts', '1999-01-31', 77, 275, 'Texas A&M', 2021, 1, 18, 'DE', 4, 'Active'),
('P100028', 'Marco', 'Rivera', '2000-06-14', 73, 240, 'Florida State', 2022, 2, 10, 'ILB', 3, 'Active'),
('P100029', 'Darius', 'Reed', '2001-03-25', 71, 188, 'LSU', 2023, 1, 14, 'CB', 2, 'Active'),
('P100030', 'Jake', 'Morrison', '1997-11-19', 72, 195, 'Oregon State', 2019, 4, 12, 'K', 6, 'Active'),
('P100031', 'Ethan', 'Shaw', '1998-08-04', 75, 222, 'Notre Dame', 2020, 1, 20, 'QB', 5, 'Active'),
('P100032', 'Marcus', 'Green', '2000-02-13', 70, 212, 'Wisconsin', 2022, 2, 6, 'RB', 3, 'Active'),
('P100033', 'Jamal', 'Porter', '1999-06-27', 74, 202, 'Oklahoma', 2021, 1, 22, 'WR', 4, 'Active'),
('P100034', 'Ryan', 'Collins', '2001-10-05', 72, 195, 'USC', 2023, 3, 18, 'WR', 2, 'Active'),
('P100035', 'Nate', 'Fischer', '1997-04-17', 76, 250, 'Stanford', 2019, 2, 16, 'TE', 6, 'Active'),
('P100036', 'David', 'Kim', '1996-09-22', 75, 310, 'Oregon', 2018, 3, 2, 'LG', 7, 'Active'),
('P100037', 'Caleb', 'Jefferson', '2000-07-11', 76, 298, 'Georgia', 2022, 1, 16, 'DT', 3, 'Active'),
('P100038', 'Sean', 'Murphy', '1999-12-30', 74, 242, 'Penn State', 2021, 2, 20, 'OLB', 4, 'Active'),
('P100039', 'Tyler', 'Adams', '2001-05-08', 72, 205, 'Florida', 2023, 2, 4, 'FS', 2, 'Active'),
('P100040', 'Alex', 'Chen', '1998-03-14', 71, 190, 'UCLA', 2020, 5, 8, 'K', 5, 'Active'),
('P100041', 'Caleb', 'Rivers', '1999-11-22', 74, 220, 'USC', 2021, 1, 5, 'QB', 4, 'Active');

-- PLAYER CONTRACTS (40 — one per player)
INSERT INTO player_contracts (contract_id, player_id, team_id, contract_start_date, contract_end_date, total_value, guaranteed_money, signing_bonus, annual_salary, contract_type, is_active) VALUES
('CON100001', 'P100001', 'NEM', '2023-03-15', '2027-03-14', 160000000.00, 100000000.00, 25000000.00, 40000000.00, 'Extension', TRUE),
('CON100002', 'P100002', 'NEM', '2022-05-10', '2025-05-09', 18000000.00, 10000000.00, 3000000.00, 6000000.00, 'Veteran', TRUE),
('CON100003', 'P100003', 'NEM', '2023-03-20', '2027-03-19', 72000000.00, 45000000.00, 12000000.00, 18000000.00, 'Extension', TRUE),
('CON100004', 'P100004', 'NEM', '2021-07-01', '2025-06-30', 6800000.00, 3200000.00, 1200000.00, 1700000.00, 'Rookie', TRUE),
('CON100005', 'P100005', 'NEM', '2022-03-18', '2026-03-17', 44000000.00, 28000000.00, 8000000.00, 11000000.00, 'Extension', TRUE),
('CON100006', 'P100006', 'NEM', '2021-03-15', '2025-03-14', 64000000.00, 40000000.00, 10000000.00, 16000000.00, 'Extension', TRUE),
('CON100007', 'P100007', 'NEM', '2024-04-01', '2028-03-31', 80000000.00, 55000000.00, 15000000.00, 20000000.00, 'Extension', TRUE),
('CON100008', 'P100008', 'NEM', '2021-07-01', '2025-06-30', 7600000.00, 4000000.00, 1500000.00, 1900000.00, 'Rookie', TRUE),
('CON100009', 'P100009', 'NEM', '2022-07-01', '2026-06-30', 16400000.00, 10800000.00, 4000000.00, 4100000.00, 'Rookie', TRUE),
('CON100010', 'P100010', 'NEM', '2022-03-10', '2025-03-09', 12000000.00, 7000000.00, 2000000.00, 4000000.00, 'Veteran', TRUE),
('CON100011', 'P100011', 'KCR', '2022-07-01', '2026-06-30', 24000000.00, 15600000.00, 6000000.00, 6000000.00, 'Rookie', TRUE),
('CON100012', 'P100012', 'KCR', '2021-07-01', '2025-06-30', 5200000.00, 2400000.00, 800000.00, 1300000.00, 'Rookie', TRUE),
('CON100013', 'P100013', 'KCR', '2020-05-15', '2024-05-14', 8000000.00, 4000000.00, 1500000.00, 2000000.00, 'Rookie', TRUE),
('CON100014', 'P100014', 'KCR', '2023-07-01', '2027-06-30', 7200000.00, 3800000.00, 1400000.00, 1800000.00, 'Rookie', TRUE),
('CON100015', 'P100015', 'KCR', '2023-03-12', '2026-03-11', 15000000.00, 8000000.00, 2500000.00, 5000000.00, 'Veteran', TRUE),
('CON100016', 'P100016', 'KCR', '2022-03-08', '2025-03-07', 18000000.00, 10000000.00, 3000000.00, 6000000.00, 'Veteran', TRUE),
('CON100017', 'P100017', 'KCR', '2022-07-01', '2026-06-30', 9200000.00, 5600000.00, 2000000.00, 2300000.00, 'Rookie', TRUE),
('CON100018', 'P100018', 'KCR', '2021-07-01', '2025-06-30', 5600000.00, 2800000.00, 1000000.00, 1400000.00, 'Rookie', TRUE),
('CON100019', 'P100019', 'KCR', '2023-07-01', '2027-06-30', 12800000.00, 8000000.00, 3000000.00, 3200000.00, 'Rookie', TRUE),
('CON100020', 'P100020', 'KCR', '2020-05-10', '2024-05-09', 3200000.00, 1200000.00, 400000.00, 800000.00, 'Rookie', TRUE),
('CON100021', 'P100021', 'DAL', '2023-03-20', '2028-03-19', 200000000.00, 130000000.00, 30000000.00, 40000000.00, 'Extension', TRUE),
('CON100022', 'P100022', 'DAL', '2024-03-15', '2028-03-14', 48000000.00, 30000000.00, 8000000.00, 12000000.00, 'Extension', TRUE),
('CON100023', 'P100023', 'DAL', '2023-03-18', '2027-03-17', 80000000.00, 52000000.00, 14000000.00, 20000000.00, 'Extension', TRUE),
('CON100024', 'P100024', 'DAL', '2022-07-01', '2026-06-30', 8800000.00, 5200000.00, 1800000.00, 2200000.00, 'Rookie', TRUE),
('CON100025', 'P100025', 'DAL', '2022-03-12', '2025-03-11', 24000000.00, 14000000.00, 4000000.00, 8000000.00, 'Veteran', TRUE),
('CON100026', 'P100026', 'DAL', '2022-03-10', '2026-03-09', 52000000.00, 32000000.00, 8000000.00, 13000000.00, 'Extension', TRUE),
('CON100027', 'P100027', 'DAL', '2024-04-05', '2028-04-04', 68000000.00, 45000000.00, 12000000.00, 17000000.00, 'Extension', TRUE),
('CON100028', 'P100028', 'DAL', '2022-07-01', '2026-06-30', 10400000.00, 6400000.00, 2200000.00, 2600000.00, 'Rookie', TRUE),
('CON100029', 'P100029', 'DAL', '2023-07-01', '2027-06-30', 14400000.00, 9200000.00, 3400000.00, 3600000.00, 'Rookie', TRUE),
('CON100030', 'P100030', 'DAL', '2022-03-08', '2025-03-07', 10500000.00, 6000000.00, 1500000.00, 3500000.00, 'Veteran', TRUE),
('CON100031', 'P100031', 'CHI', '2024-03-20', '2028-03-19', 120000000.00, 75000000.00, 20000000.00, 30000000.00, 'Extension', TRUE),
('CON100032', 'P100032', 'CHI', '2022-07-01', '2026-06-30', 8400000.00, 5000000.00, 1600000.00, 2100000.00, 'Rookie', TRUE),
('CON100033', 'P100033', 'CHI', '2024-03-18', '2028-03-17', 64000000.00, 40000000.00, 10000000.00, 16000000.00, 'Extension', TRUE),
('CON100034', 'P100034', 'CHI', '2023-07-01', '2027-06-30', 6000000.00, 3000000.00, 1000000.00, 1500000.00, 'Rookie', TRUE),
('CON100035', 'P100035', 'CHI', '2022-03-15', '2025-03-14', 30000000.00, 18000000.00, 5000000.00, 10000000.00, 'Veteran', TRUE),
('CON100036', 'P100036', 'CHI', '2021-03-10', '2025-03-09', 40000000.00, 24000000.00, 6000000.00, 10000000.00, 'Veteran', TRUE),
('CON100037', 'P100037', 'CHI', '2022-07-01', '2026-06-30', 18000000.00, 12000000.00, 4000000.00, 4500000.00, 'Rookie', TRUE),
('CON100038', 'P100038', 'CHI', '2021-07-01', '2025-06-30', 6400000.00, 3200000.00, 1200000.00, 1600000.00, 'Rookie', TRUE),
('CON100039', 'P100039', 'CHI', '2023-07-01', '2027-06-30', 9600000.00, 6000000.00, 2000000.00, 2400000.00, 'Rookie', TRUE),
('CON100040', 'P100040', 'CHI', '2020-05-12', '2024-05-11', 7500000.00, 4000000.00, 1000000.00, 2500000.00, 'Veteran', TRUE),
('CON100041', 'P100041', 'SEA', '2024-03-10', '2029-03-09', 175000000.00, 110000000.00, 28000000.00, 35000000.00, 'Extension', TRUE);

-- TEAM SEASON STATS (32 teams x 2 seasons: 2023, 2024)
INSERT INTO team_season_stats (stat_id, team_id, season_id, wins, losses, ties, division_rank, made_playoffs, playoff_result, points_scored, total_yards, passing_yards, rushing_yards, turnovers_committed, points_allowed, yards_allowed, sacks, interceptions, turnovers_forced, offense_rank, defense_rank) VALUES
('TSS2301', 'NEM', 2023, 13, 4, 0, 1, TRUE, 'Conference Loss', 428, 6280, 4120, 2160, 18, 295, 5100, 48, 18, 32, 2, 4),
('TSS2302', 'BUF', 2023, 11, 6, 0, 2, TRUE, 'Wild Card Loss', 398, 5980, 3850, 2130, 22, 320, 5300, 42, 15, 28, 5, 8),
('TSS2303', 'MIA', 2023, 9, 8, 0, 3, FALSE, NULL, 365, 5750, 3680, 2070, 24, 348, 5500, 35, 12, 24, 10, 14),
('TSS2304', 'NYS', 2023, 6, 11, 0, 4, FALSE, NULL, 310, 5200, 3300, 1900, 28, 390, 5800, 30, 10, 20, 22, 20),
('TSS2305', 'BAL', 2023, 12, 5, 0, 1, TRUE, 'Divisional Loss', 420, 6150, 3700, 2450, 16, 305, 5200, 45, 16, 30, 3, 6),
('TSS2306', 'PIT', 2023, 10, 7, 0, 2, TRUE, 'Wild Card Loss', 378, 5850, 3600, 2250, 20, 330, 5350, 40, 14, 26, 8, 10),
('TSS2307', 'CIN', 2023, 8, 9, 0, 3, FALSE, NULL, 350, 5650, 3750, 1900, 23, 355, 5550, 38, 13, 25, 12, 12),
('TSS2308', 'CLE', 2023, 5, 12, 0, 4, FALSE, NULL, 290, 5050, 3100, 1950, 30, 405, 5900, 28, 9, 18, 26, 24),
('TSS2309', 'HOU', 2023, 10, 7, 0, 1, TRUE, 'Divisional Loss', 385, 5900, 3800, 2100, 19, 325, 5280, 43, 17, 29, 6, 7),
('TSS2310', 'IND', 2023, 9, 8, 0, 2, FALSE, NULL, 360, 5700, 3500, 2200, 21, 340, 5400, 36, 11, 22, 11, 15),
('TSS2311', 'TEN', 2023, 7, 10, 0, 3, FALSE, NULL, 325, 5400, 3300, 2100, 26, 370, 5650, 33, 10, 21, 18, 18),
('TSS2312', 'JAX', 2023, 6, 11, 0, 4, FALSE, NULL, 305, 5150, 3200, 1950, 27, 385, 5750, 31, 11, 23, 24, 22),
('TSS2313', 'DEN', 2023, 8, 9, 0, 2, FALSE, NULL, 345, 5600, 3450, 2150, 22, 350, 5500, 37, 13, 26, 14, 13),
('TSS2314', 'KCR', 2023, 4, 13, 0, 4, FALSE, NULL, 275, 4900, 3000, 1900, 32, 420, 6050, 25, 8, 16, 30, 28),
('TSS2315', 'LVG', 2023, 7, 10, 0, 3, FALSE, NULL, 330, 5350, 3400, 1950, 25, 365, 5600, 34, 12, 23, 16, 16),
('TSS2316', 'LAW', 2023, 10, 7, 0, 1, TRUE, 'Wild Card Loss', 390, 5950, 3900, 2050, 18, 318, 5250, 44, 16, 30, 4, 5),
('TSS2317', 'DAL', 2023, 11, 6, 0, 1, TRUE, 'Divisional Loss', 410, 6100, 4000, 2100, 17, 310, 5180, 46, 17, 31, 3, 5),
('TSS2318', 'PHI', 2023, 10, 7, 0, 2, TRUE, 'Wild Card Loss', 388, 5920, 3750, 2170, 20, 328, 5320, 41, 15, 27, 7, 9),
('TSS2319', 'NYG', 2023, 7, 10, 0, 3, FALSE, NULL, 320, 5300, 3350, 1950, 26, 375, 5680, 32, 11, 22, 20, 19),
('TSS2320', 'WAS', 2023, 5, 12, 0, 4, FALSE, NULL, 295, 5100, 3150, 1950, 29, 398, 5850, 29, 9, 19, 25, 23),
('TSS2321', 'CHI', 2023, 9, 8, 0, 2, FALSE, NULL, 370, 5780, 3650, 2130, 21, 342, 5420, 39, 14, 27, 9, 11),
('TSS2322', 'GBC', 2023, 10, 7, 0, 1, TRUE, 'Conference Loss', 395, 5940, 3820, 2120, 19, 315, 5220, 43, 16, 30, 5, 6),
('TSS2323', 'DET', 2023, 8, 9, 0, 3, FALSE, NULL, 348, 5620, 3500, 2120, 23, 358, 5550, 36, 12, 24, 13, 13),
('TSS2324', 'MIN', 2023, 7, 10, 0, 4, FALSE, NULL, 328, 5380, 3400, 1980, 25, 368, 5620, 34, 11, 22, 17, 17),
('TSS2325', 'ATL', 2023, 9, 8, 0, 2, FALSE, NULL, 362, 5720, 3600, 2120, 22, 345, 5450, 38, 13, 25, 11, 12),
('TSS2326', 'NOR', 2023, 11, 6, 0, 1, TRUE, 'Super Bowl Loss', 415, 6080, 3950, 2130, 16, 300, 5150, 47, 18, 33, 2, 3),
('TSS2327', 'CAR', 2023, 6, 11, 0, 3, FALSE, NULL, 308, 5180, 3250, 1930, 27, 382, 5720, 31, 10, 21, 23, 21),
('TSS2328', 'TBP', 2023, 5, 12, 0, 4, FALSE, NULL, 288, 5020, 3100, 1920, 30, 410, 5950, 27, 8, 17, 28, 26),
('TSS2329', 'SFP', 2023, 13, 4, 0, 1, TRUE, 'Champion', 435, 6320, 4050, 2270, 14, 288, 5050, 50, 20, 35, 1, 1),
('TSS2330', 'SEA', 2023, 8, 9, 0, 2, FALSE, NULL, 352, 5680, 3550, 2130, 23, 352, 5480, 37, 13, 25, 12, 13),
('TSS2331', 'ARI', 2023, 5, 12, 0, 4, FALSE, NULL, 292, 5080, 3100, 1980, 29, 400, 5880, 28, 9, 18, 27, 25),
('TSS2332', 'LAS', 2023, 7, 10, 0, 3, FALSE, NULL, 335, 5420, 3450, 1970, 24, 362, 5580, 35, 12, 24, 15, 15),
('TSS2401', 'NEM', 2024, 12, 5, 0, 1, TRUE, 'Champion', 440, 6350, 4200, 2150, 15, 290, 5020, 50, 20, 36, 1, 2),
('TSS2402', 'BUF', 2024, 10, 7, 0, 2, TRUE, 'Wild Card Loss', 385, 5900, 3800, 2100, 21, 328, 5320, 40, 14, 26, 6, 9),
('TSS2403', 'MIA', 2024, 8, 9, 0, 3, FALSE, NULL, 355, 5680, 3620, 2060, 25, 360, 5560, 34, 11, 22, 12, 16),
('TSS2404', 'NYS', 2024, 7, 10, 0, 4, FALSE, NULL, 322, 5280, 3350, 1930, 27, 378, 5720, 31, 10, 20, 20, 20),
('TSS2405', 'BAL', 2024, 11, 6, 0, 1, TRUE, 'Conference Loss', 415, 6100, 3650, 2450, 17, 308, 5180, 46, 17, 31, 4, 5),
('TSS2406', 'PIT', 2024, 9, 8, 0, 2, FALSE, NULL, 368, 5780, 3550, 2230, 22, 342, 5400, 38, 13, 25, 9, 12),
('TSS2407', 'CIN', 2024, 10, 7, 0, 3, TRUE, 'Wild Card Loss', 392, 5950, 3850, 2100, 19, 325, 5280, 42, 15, 28, 5, 7),
('TSS2408', 'CLE', 2024, 6, 11, 0, 4, FALSE, NULL, 305, 5120, 3150, 1970, 28, 395, 5850, 30, 10, 19, 24, 23),
('TSS2409', 'HOU', 2024, 11, 6, 0, 1, TRUE, 'Super Bowl Loss', 408, 6050, 3900, 2150, 18, 312, 5200, 45, 18, 32, 3, 4),
('TSS2410', 'IND', 2024, 8, 9, 0, 2, FALSE, NULL, 350, 5650, 3450, 2200, 23, 355, 5480, 35, 12, 23, 13, 14),
('TSS2411', 'TEN', 2024, 7, 10, 0, 3, FALSE, NULL, 330, 5420, 3300, 2120, 25, 368, 5620, 33, 11, 22, 17, 17),
('TSS2412', 'JAX', 2024, 5, 12, 0, 4, FALSE, NULL, 298, 5100, 3150, 1950, 29, 398, 5800, 29, 9, 18, 26, 24),
('TSS2413', 'DEN', 2024, 9, 8, 0, 2, FALSE, NULL, 362, 5720, 3500, 2220, 21, 345, 5420, 39, 14, 27, 10, 11),
('TSS2414', 'KCR', 2024, 5, 12, 0, 4, FALSE, NULL, 285, 4950, 3050, 1900, 31, 415, 6000, 26, 8, 17, 29, 27),
('TSS2415', 'LVG', 2024, 8, 9, 0, 3, FALSE, NULL, 342, 5580, 3450, 2130, 24, 358, 5520, 36, 13, 25, 14, 14),
('TSS2416', 'LAW', 2024, 11, 6, 0, 1, TRUE, 'Divisional Loss', 400, 6000, 3920, 2080, 17, 315, 5200, 44, 16, 30, 4, 5),
('TSS2417', 'DAL', 2024, 10, 7, 0, 1, TRUE, 'Conference Loss', 402, 6020, 3950, 2070, 18, 318, 5240, 44, 16, 30, 4, 6),
('TSS2418', 'PHI', 2024, 9, 8, 0, 2, TRUE, 'Wild Card Loss', 375, 5820, 3700, 2120, 22, 340, 5380, 40, 14, 26, 8, 10),
('TSS2419', 'NYG', 2024, 6, 11, 0, 3, FALSE, NULL, 315, 5250, 3300, 1950, 27, 382, 5700, 31, 10, 21, 22, 21),
('TSS2420', 'WAS', 2024, 4, 13, 0, 4, FALSE, NULL, 288, 5050, 3100, 1950, 30, 408, 5900, 28, 8, 17, 28, 26),
('TSS2421', 'CHI', 2024, 10, 7, 0, 2, TRUE, 'Divisional Loss', 388, 5900, 3750, 2150, 19, 330, 5300, 42, 15, 28, 6, 8),
('TSS2422', 'GBC', 2024, 11, 6, 0, 1, TRUE, 'Divisional Loss', 405, 6020, 3880, 2140, 18, 310, 5180, 45, 17, 31, 3, 5),
('TSS2423', 'DET', 2024, 9, 8, 0, 3, FALSE, NULL, 358, 5700, 3550, 2150, 22, 350, 5450, 37, 13, 25, 11, 12),
('TSS2424', 'MIN', 2024, 6, 11, 0, 4, FALSE, NULL, 318, 5300, 3350, 1950, 26, 375, 5680, 32, 10, 21, 21, 19),
('TSS2425', 'ATL', 2024, 8, 9, 0, 2, FALSE, NULL, 355, 5680, 3550, 2130, 23, 350, 5480, 37, 13, 25, 12, 13),
('TSS2426', 'NOR', 2024, 10, 7, 0, 1, TRUE, 'Divisional Loss', 395, 5960, 3850, 2110, 18, 320, 5250, 43, 16, 30, 5, 6),
('TSS2427', 'CAR', 2024, 7, 10, 0, 3, FALSE, NULL, 325, 5350, 3300, 2050, 26, 370, 5650, 33, 11, 22, 19, 18),
('TSS2428', 'TBP', 2024, 4, 13, 0, 4, FALSE, NULL, 280, 4980, 3050, 1930, 31, 418, 5980, 26, 7, 16, 30, 28),
('TSS2429', 'SFP', 2024, 11, 6, 0, 1, TRUE, 'Divisional Loss', 410, 6120, 3950, 2170, 16, 302, 5120, 47, 18, 33, 2, 3),
('TSS2430', 'SEA', 2024, 9, 8, 0, 2, FALSE, NULL, 362, 5720, 3600, 2120, 22, 348, 5450, 38, 14, 26, 10, 12),
('TSS2431', 'ARI', 2024, 6, 11, 0, 4, FALSE, NULL, 302, 5150, 3150, 2000, 28, 392, 5820, 29, 9, 19, 25, 24),
('TSS2432', 'LAS', 2024, 8, 9, 0, 3, FALSE, NULL, 345, 5550, 3480, 2070, 23, 355, 5520, 36, 13, 25, 15, 14);

-- PLAYER SEASON STATS (40 players x 2 seasons = 80 rows)
-- NEM players
INSERT INTO player_season_stats (stat_id, player_id, team_id, season_id, games_played, games_started, pass_attempts, pass_completions, pass_yards, pass_touchdowns, pass_interceptions, passer_rating, rush_attempts, rush_yards, rush_touchdowns, rush_fumbles, targets, receptions, receiving_yards, receiving_touchdowns, tackles_total, sacks, interceptions, passes_defended, forced_fumbles, fumble_recoveries, fg_made, fg_attempts, xp_made, xp_attempts, punts, punt_yards, punt_avg) VALUES
('PSS100001', 'P100001', 'NEM', 2023, 17, 17, 542, 368, 4520, 35, 10, 102.5, 28, 145, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100002', 'P100002', 'NEM', 2023, 16, 15, 0, 0, 0, 0, 0, NULL, 245, 1180, 10, 3, 42, 35, 280, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100003', 'P100003', 'NEM', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 145, 98, 1320, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100004', 'P100004', 'NEM', 2023, 16, 14, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 110, 72, 890, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100005', 'P100005', 'NEM', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 85, 62, 720, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100007', 'P100007', 'NEM', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 65, 14.0, 0, 8, 4, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100008', 'P100008', 'NEM', 2023, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 118, 2.0, 3, 6, 1, 2, 0, 0, 0, 0, 0, 0, NULL),
('PSS100009', 'P100009', 'NEM', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 5, 18, 1, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100010', 'P100010', 'NEM', 2023, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 34, 42, 43, 0, 0, NULL),
('PSS100041', 'P100001', 'NEM', 2024, 17, 17, 558, 385, 4780, 38, 8, 108.2, 32, 165, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100042', 'P100002', 'NEM', 2024, 17, 16, 0, 0, 0, 0, 0, NULL, 260, 1250, 12, 2, 48, 38, 310, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100043', 'P100003', 'NEM', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 152, 105, 1420, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100044', 'P100004', 'NEM', 2024, 17, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 118, 78, 950, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100045', 'P100005', 'NEM', 2024, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 80, 58, 680, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100047', 'P100007', 'NEM', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 72, 16.5, 1, 10, 5, 2, 0, 0, 0, 0, 0, 0, NULL),
('PSS100048', 'P100008', 'NEM', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 125, 3.0, 4, 7, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100049', 'P100009', 'NEM', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 52, 0, 6, 20, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100050', 'P100010', 'NEM', 2024, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 35, 45, 46, 0, 0, NULL),
-- KCR players
('PSS100011', 'P100011', 'KCR', 2023, 17, 17, 510, 310, 3450, 18, 16, 78.2, 35, 180, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100012', 'P100012', 'KCR', 2023, 15, 12, 0, 0, 0, 0, 0, NULL, 185, 780, 5, 4, 30, 22, 165, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100013', 'P100013', 'KCR', 2023, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 120, 68, 820, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100014', 'P100014', 'KCR', 2023, 14, 10, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 75, 42, 480, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100015', 'P100015', 'KCR', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 65, 45, 520, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100017', 'P100017', 'KCR', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 55, 6.0, 0, 5, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100018', 'P100018', 'KCR', 2023, 16, 14, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 80, 4.5, 1, 4, 1, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100019', 'P100019', 'KCR', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 72, 1.0, 2, 8, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100051', 'P100011', 'KCR', 2024, 16, 16, 525, 325, 3680, 22, 14, 82.8, 30, 155, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100052', 'P100012', 'KCR', 2024, 16, 14, 0, 0, 0, 0, 0, NULL, 200, 850, 6, 3, 35, 25, 190, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100053', 'P100013', 'KCR', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 130, 75, 880, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100054', 'P100014', 'KCR', 2024, 16, 14, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 90, 52, 580, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100055', 'P100015', 'KCR', 2024, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 70, 48, 550, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100057', 'P100017', 'KCR', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 60, 7.5, 0, 6, 3, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100058', 'P100018', 'KCR', 2024, 17, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 85, 5.0, 2, 5, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100059', 'P100019', 'KCR', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 78, 1.5, 3, 10, 2, 0, 0, 0, 0, 0, 0, 0, NULL),
-- DAL players
('PSS100021', 'P100021', 'DAL', 2023, 17, 17, 560, 372, 4650, 32, 12, 98.5, 22, 120, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100022', 'P100022', 'DAL', 2023, 17, 16, 0, 0, 0, 0, 0, NULL, 270, 1320, 11, 2, 45, 38, 300, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100023', 'P100023', 'DAL', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 150, 100, 1350, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100024', 'P100024', 'DAL', 2023, 16, 12, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 95, 60, 750, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100025', 'P100025', 'DAL', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 78, 55, 640, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100027', 'P100027', 'DAL', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 70, 12.0, 0, 9, 3, 2, 0, 0, 0, 0, 0, 0, NULL),
('PSS100028', 'P100028', 'DAL', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 110, 2.5, 2, 5, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100029', 'P100029', 'DAL', 2023, 15, 15, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 45, 0, 4, 15, 1, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100030', 'P100030', 'DAL', 2023, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 32, 40, 41, 0, 0, NULL),
('PSS100061', 'P100021', 'DAL', 2024, 17, 17, 548, 365, 4480, 30, 10, 100.2, 25, 130, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100062', 'P100022', 'DAL', 2024, 16, 16, 0, 0, 0, 0, 0, NULL, 255, 1280, 10, 1, 50, 40, 320, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100063', 'P100023', 'DAL', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 148, 98, 1280, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100064', 'P100024', 'DAL', 2024, 17, 15, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 105, 68, 820, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100065', 'P100025', 'DAL', 2024, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 72, 50, 600, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100067', 'P100027', 'DAL', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 75, 13.5, 1, 11, 4, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100068', 'P100028', 'DAL', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 115, 3.0, 3, 6, 1, 2, 0, 0, 0, 0, 0, 0, NULL),
('PSS100069', 'P100029', 'DAL', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 5, 17, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100070', 'P100030', 'DAL', 2024, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 33, 42, 43, 0, 0, NULL),
-- CHI players
('PSS100031', 'P100031', 'CHI', 2023, 17, 17, 535, 348, 4180, 28, 13, 92.4, 30, 160, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100032', 'P100032', 'CHI', 2023, 16, 14, 0, 0, 0, 0, 0, NULL, 220, 1020, 8, 3, 38, 30, 240, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100033', 'P100033', 'CHI', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 135, 88, 1150, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100034', 'P100034', 'CHI', 2023, 14, 8, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 65, 38, 420, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100035', 'P100035', 'CHI', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 75, 52, 610, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100037', 'P100037', 'CHI', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 58, 8.0, 0, 6, 3, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100038', 'P100038', 'CHI', 2023, 16, 15, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 88, 5.5, 1, 4, 2, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100039', 'P100039', 'CHI', 2023, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 68, 1.0, 3, 12, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100040', 'P100040', 'CHI', 2023, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 30, 38, 39, 0, 0, NULL),
('PSS100071', 'P100031', 'CHI', 2024, 17, 17, 550, 362, 4350, 31, 11, 96.8, 28, 150, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100072', 'P100032', 'CHI', 2024, 17, 16, 0, 0, 0, 0, 0, NULL, 240, 1100, 9, 2, 42, 34, 270, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100073', 'P100033', 'CHI', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 140, 92, 1220, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100074', 'P100034', 'CHI', 2024, 17, 14, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 88, 55, 620, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100075', 'P100035', 'CHI', 2024, 16, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 70, 50, 580, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100077', 'P100037', 'CHI', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 62, 9.5, 1, 7, 2, 2, 0, 0, 0, 0, 0, 0, NULL),
('PSS100078', 'P100038', 'CHI', 2024, 17, 16, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 92, 6.0, 2, 5, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
('PSS100079', 'P100039', 'CHI', 2024, 17, 17, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 72, 1.5, 4, 14, 2, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100080', 'P100040', 'CHI', 2024, 17, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 31, 40, 41, 0, 0, NULL),

('PSS100081', 'P100041', 'SEA', 2023, 16, 16, 510, 340, 4150, 30, 12, 96.8, 45, 210, 2, 1, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
('PSS100082', 'P100041', 'SEA', 2024, 17, 17, 545, 372, 4480, 34, 9, 103.1, 52, 280, 3, 2, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);

-- DRAFT PICKS (20 picks from 2023-2024 for focal teams)
INSERT INTO draft_picks (pick_id, season_id, round, pick_number, overall_pick, team_id, player_id, player_name, position_id, college) VALUES
('DP2301', 2023, 1, 2, 2, 'KCR', 'P100019', 'Malik Davis', 'SS', 'Tennessee'),
('DP2302', 2023, 1, 14, 14, 'DAL', 'P100029', 'Darius Reed', 'CB', 'LSU'),
('DP2303', 2023, 2, 4, 36, 'CHI', 'P100039', 'Tyler Adams', 'FS', 'Florida'),
('DP2304', 2023, 2, 15, 47, 'KCR', 'P100014', 'Tre Jackson', 'WR', 'Oregon'),
('DP2305', 2023, 3, 18, 82, 'CHI', 'P100034', 'Ryan Collins', 'WR', 'USC'),
('DP2306', 2023, 1, 8, 8, 'NEM', NULL, 'Derek Simms', 'OLB', 'Miami'),
('DP2307', 2023, 2, 22, 54, 'DAL', NULL, 'Andre Washington', 'DT', 'Georgia'),
('DP2308', 2023, 3, 5, 69, 'NEM', NULL, 'Tyler West', 'RB', 'Oregon State'),
('DP2309', 2023, 4, 12, 112, 'KCR', NULL, 'Sam Patterson', 'TE', 'Michigan State'),
('DP2310', 2023, 5, 1, 137, 'CHI', NULL, 'Kevin Lewis', 'C', 'Iowa'),
('DP2401', 2024, 1, 3, 3, 'KCR', NULL, 'Jaylen Carter', 'DE', 'Alabama'),
('DP2402', 2024, 1, 10, 10, 'CHI', NULL, 'Marcus Thompson', 'LT', 'Ohio State'),
('DP2403', 2024, 1, 18, 18, 'DAL', NULL, 'Chris Mitchell', 'WR', 'Texas'),
('DP2404', 2024, 2, 2, 34, 'NEM', NULL, 'Brandon Scott', 'SS', 'Clemson'),
('DP2405', 2024, 2, 15, 47, 'KCR', NULL, 'Devon Harris', 'RB', 'Wisconsin'),
('DP2406', 2024, 3, 8, 72, 'DAL', NULL, 'Jason Park', 'ILB', 'Penn State'),
('DP2407', 2024, 3, 20, 84, 'CHI', NULL, 'Mike Santos', 'CB', 'Florida State'),
('DP2408', 2024, 4, 5, 105, 'NEM', NULL, 'Aaron Bell', 'WR', 'Michigan'),
('DP2409', 2024, 5, 12, 152, 'KCR', NULL, 'Travis Young', 'DT', 'Auburn'),
('DP2410', 2024, 6, 8, 188, 'CHI', NULL, 'Luke Martinez', 'K', 'UCLA');

-- GAMES (16 games from 2024 season weeks 1-4 involving focal teams)
INSERT INTO games (game_id, season_id, game_type, week_number, game_date, game_time, home_team_id, away_team_id, stadium_id, home_score, away_score, attendance, weather_temp_f, weather_condition, weather_wind_mph, is_overtime, is_completed, broadcast_network) VALUES
('REG20240101', 2024, 'Regular', 1, '2024-09-08', '13:00:00', 'NEM', 'KCR', 'NEM', 31, 14, 65500, 72, 'Clear', 8, FALSE, TRUE, 'CBS'),
('REG20240102', 2024, 'Regular', 1, '2024-09-08', '16:25:00', 'DAL', 'CHI', 'DAL', 27, 24, 78200, 88, 'Clear', 5, FALSE, TRUE, 'FOX'),
('REG20240201', 2024, 'Regular', 2, '2024-09-15', '13:00:00', 'CHI', 'NEM', 'CHI', 20, 28, 61200, 68, 'Cloudy', 12, FALSE, TRUE, 'CBS'),
('REG20240202', 2024, 'Regular', 2, '2024-09-15', '16:25:00', 'KCR', 'DAL', 'KCR', 17, 35, 74800, 78, 'Clear', 6, FALSE, TRUE, 'FOX'),
('REG20240301', 2024, 'Regular', 3, '2024-09-22', '13:00:00', 'NEM', 'BUF', 'NEM', 24, 21, 65700, 65, 'Rain', 15, TRUE, TRUE, 'CBS'),
('REG20240302', 2024, 'Regular', 3, '2024-09-22', '13:00:00', 'DAL', 'PHI', 'DAL', 30, 28, 79500, 82, 'Clear', 4, FALSE, TRUE, 'FOX'),
('REG20240303', 2024, 'Regular', 3, '2024-09-22', '16:25:00', 'CHI', 'GBC', 'CHI', 21, 24, 61000, 62, 'Cloudy', 18, FALSE, TRUE, 'FOX'),
('REG20240304', 2024, 'Regular', 3, '2024-09-22', '20:20:00', 'KCR', 'DEN', 'KCR', 10, 27, 72500, 74, 'Clear', 8, FALSE, TRUE, 'NBC'),
('REG20240401', 2024, 'Regular', 4, '2024-09-29', '13:00:00', 'BAL', 'NEM', 'BAL', 28, 31, 70200, 70, 'Clear', 10, FALSE, TRUE, 'CBS'),
('REG20240402', 2024, 'Regular', 4, '2024-09-29', '13:00:00', 'CHI', 'DET', 'CHI', 27, 20, 61300, 58, 'Cloudy', 14, FALSE, TRUE, 'FOX'),
('REG20240403', 2024, 'Regular', 4, '2024-09-29', '16:25:00', 'DAL', 'NYG', 'DAL', 38, 17, 80000, 85, 'Clear', 3, FALSE, TRUE, 'FOX'),
('REG20240404', 2024, 'Regular', 4, '2024-09-29', '13:00:00', 'LVG', 'KCR', 'LVG', 28, 13, 64800, 95, 'Clear', 5, FALSE, TRUE, 'CBS'),
('REG20240501', 2024, 'Regular', 5, '2024-10-06', '20:20:00', 'NEM', 'DAL', 'NEM', 24, 27, 65800, 55, 'Rain', 20, FALSE, TRUE, 'NBC'),
('REG20240502', 2024, 'Regular', 5, '2024-10-06', '13:00:00', 'KCR', 'CHI', 'KCR', 14, 31, 71500, 68, 'Clear', 10, FALSE, TRUE, 'CBS'),
('REG20240601', 2024, 'Regular', 6, '2024-10-13', '13:00:00', 'DAL', 'WAS', 'DAL', 42, 18, 79800, 78, 'Clear', 6, FALSE, TRUE, 'FOX'),
('REG20240602', 2024, 'Regular', 6, '2024-10-13', '16:25:00', 'NEM', 'MIA', 'NEM', 35, 20, 65600, 60, 'Clear', 12, FALSE, TRUE, 'CBS');

-- GAME TEAM STATS (2 rows per game = 32 rows)
INSERT INTO game_team_stats (game_team_stat_id, game_id, team_id, is_home_team, total_yards, passing_yards, rushing_yards, first_downs, third_down_attempts, third_down_converts, total_plays, possession_seconds, fumbles, fumbles_lost, interceptions_thrown, penalties, penalty_yards, touchdowns, field_goals_made, field_goals_attempted, sacks, interceptions_caught, forced_fumbles) VALUES
('GTS2401H', 'REG20240101', 'NEM', TRUE, 410, 280, 130, 24, 14, 7, 68, 1920, 1, 0, 0, 5, 45, 4, 1, 1, 3, 2, 1),
('GTS2401A', 'REG20240101', 'KCR', FALSE, 265, 175, 90, 15, 13, 4, 58, 1680, 2, 1, 2, 7, 65, 2, 0, 1, 1, 0, 0),
('GTS2402H', 'REG20240102', 'DAL', TRUE, 385, 260, 125, 22, 12, 6, 65, 1850, 0, 0, 1, 4, 35, 3, 2, 2, 2, 1, 0),
('GTS2402A', 'REG20240102', 'CHI', FALSE, 370, 245, 125, 21, 13, 6, 64, 1750, 1, 0, 1, 6, 50, 3, 1, 2, 2, 1, 1),
('GTS2403H', 'REG20240201', 'CHI', TRUE, 320, 210, 110, 18, 12, 5, 60, 1700, 1, 1, 1, 5, 40, 2, 2, 3, 1, 1, 0),
('GTS2403A', 'REG20240201', 'NEM', FALSE, 395, 275, 120, 23, 14, 7, 66, 1900, 0, 0, 1, 3, 25, 4, 0, 0, 3, 1, 1),
('GTS2404H', 'REG20240202', 'KCR', TRUE, 250, 165, 85, 14, 12, 3, 55, 1600, 2, 2, 1, 8, 72, 2, 1, 2, 0, 0, 0),
('GTS2404A', 'REG20240202', 'DAL', FALSE, 425, 290, 135, 25, 13, 8, 70, 2000, 0, 0, 0, 4, 30, 5, 0, 0, 4, 1, 2),
('GTS2405H', 'REG20240301', 'NEM', TRUE, 365, 250, 115, 21, 14, 6, 64, 1850, 1, 0, 1, 4, 35, 3, 1, 2, 2, 1, 0),
('GTS2405A', 'REG20240301', 'BUF', FALSE, 350, 235, 115, 20, 13, 5, 62, 1750, 0, 0, 1, 5, 45, 3, 0, 1, 2, 1, 0),
('GTS2406H', 'REG20240302', 'DAL', TRUE, 400, 270, 130, 23, 13, 7, 67, 1880, 0, 0, 0, 5, 40, 4, 1, 1, 3, 1, 1),
('GTS2406A', 'REG20240302', 'PHI', FALSE, 380, 255, 125, 22, 14, 6, 65, 1720, 1, 1, 1, 6, 55, 4, 0, 1, 1, 0, 0),
('GTS2407H', 'REG20240303', 'CHI', TRUE, 335, 220, 115, 19, 13, 5, 62, 1780, 1, 1, 0, 4, 30, 3, 0, 1, 2, 0, 0),
('GTS2407A', 'REG20240303', 'GBC', FALSE, 360, 240, 120, 21, 14, 7, 64, 1820, 0, 0, 0, 3, 25, 3, 1, 1, 3, 1, 1),
('GTS2408H', 'REG20240304', 'KCR', TRUE, 220, 140, 80, 12, 11, 3, 52, 1550, 2, 1, 2, 9, 80, 1, 1, 2, 0, 0, 0),
('GTS2408A', 'REG20240304', 'DEN', FALSE, 380, 245, 135, 22, 12, 7, 66, 2050, 0, 0, 0, 4, 35, 3, 2, 2, 4, 2, 2),
('GTS2409H', 'REG20240401', 'BAL', TRUE, 375, 230, 145, 22, 13, 6, 65, 1820, 0, 0, 1, 5, 45, 4, 0, 1, 2, 0, 0),
('GTS2409A', 'REG20240401', 'NEM', FALSE, 395, 285, 110, 24, 14, 8, 68, 1780, 1, 0, 0, 3, 20, 4, 1, 1, 3, 1, 1),
('GTS2410H', 'REG20240402', 'CHI', TRUE, 370, 250, 120, 22, 13, 7, 66, 1900, 0, 0, 0, 4, 30, 3, 2, 2, 3, 1, 1),
('GTS2410A', 'REG20240402', 'DET', FALSE, 310, 200, 110, 17, 12, 4, 58, 1700, 1, 1, 1, 6, 55, 2, 2, 3, 1, 0, 0),
('GTS2411H', 'REG20240403', 'DAL', TRUE, 440, 300, 140, 26, 12, 8, 70, 1950, 0, 0, 0, 3, 25, 5, 1, 1, 4, 2, 1),
('GTS2411A', 'REG20240403', 'NYG', FALSE, 280, 185, 95, 15, 13, 4, 56, 1650, 2, 1, 2, 7, 60, 2, 1, 2, 0, 0, 0),
('GTS2412H', 'REG20240404', 'LVG', TRUE, 365, 240, 125, 21, 13, 6, 64, 1850, 0, 0, 0, 4, 35, 4, 0, 0, 3, 1, 1),
('GTS2412A', 'REG20240404', 'KCR', FALSE, 240, 155, 85, 13, 12, 3, 54, 1750, 1, 1, 1, 8, 70, 1, 2, 3, 1, 0, 0),
('GTS2413H', 'REG20240501', 'NEM', TRUE, 355, 250, 105, 20, 13, 5, 63, 1780, 1, 1, 1, 5, 40, 3, 1, 2, 2, 0, 0),
('GTS2413A', 'REG20240501', 'DAL', FALSE, 380, 265, 115, 22, 14, 7, 66, 1820, 0, 0, 0, 4, 30, 3, 2, 2, 3, 1, 1),
('GTS2414H', 'REG20240502', 'KCR', TRUE, 235, 150, 85, 13, 12, 3, 53, 1600, 2, 1, 2, 7, 65, 2, 0, 1, 0, 0, 0),
('GTS2414A', 'REG20240502', 'CHI', FALSE, 405, 270, 135, 24, 12, 8, 68, 2000, 0, 0, 0, 3, 20, 4, 1, 1, 4, 2, 2),
('GTS2415H', 'REG20240601', 'DAL', TRUE, 450, 310, 140, 27, 11, 8, 72, 1980, 0, 0, 0, 3, 25, 6, 0, 0, 4, 2, 1),
('GTS2415A', 'REG20240601', 'WAS', FALSE, 275, 180, 95, 15, 13, 4, 57, 1620, 2, 1, 2, 8, 72, 2, 2, 3, 0, 0, 0),
('GTS2416H', 'REG20240602', 'NEM', TRUE, 420, 290, 130, 25, 13, 8, 69, 1920, 0, 0, 0, 4, 30, 5, 0, 0, 3, 1, 1),
('GTS2416A', 'REG20240602', 'MIA', FALSE, 310, 210, 100, 18, 14, 5, 60, 1680, 1, 0, 1, 5, 45, 2, 2, 3, 1, 0, 0);
