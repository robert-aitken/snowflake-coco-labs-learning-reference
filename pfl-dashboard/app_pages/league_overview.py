import streamlit as st
import pandas as pd

st.title("League Overview")

conn = st.session_state["conn"]

# --- Team Map ---
st.subheader("Team Locations")

CITY_COORDS = {
    "New England": (42.36, -71.06), "Buffalo": (42.88, -78.88),
    "Miami": (25.76, -80.19), "New York": (40.71, -74.01),
    "Baltimore": (39.28, -76.61), "Cincinnati": (39.10, -84.51),
    "Pittsburgh": (40.44, -79.99), "Cleveland": (41.50, -81.69),
    "Houston": (29.76, -95.37), "Indianapolis": (39.77, -86.16),
    "Tennessee": (36.16, -86.78), "Jacksonville": (30.33, -81.66),
    "Los Angeles": (34.05, -118.24), "Denver": (39.74, -104.99),
    "Las Vegas": (36.17, -115.14), "Kansas City": (39.10, -94.58),
    "Dallas": (32.78, -96.80), "Philadelphia": (39.95, -75.17),
    "Washington": (38.91, -77.04), "Green Bay": (44.51, -88.02),
    "Chicago": (41.88, -87.63), "Detroit": (42.33, -83.05),
    "Minnesota": (44.98, -93.27), "New Orleans": (29.95, -90.07),
    "Atlanta": (33.75, -84.39), "Carolina": (35.23, -80.84),
    "Tampa Bay": (27.95, -82.46), "San Francisco": (37.78, -122.42),
    "Seattle": (47.61, -122.33), "Arizona": (33.45, -112.07),
}

teams = conn.query("""
    SELECT t.CITY, t.TEAM_NAME, t.STADIUM_NAME, ts.WINS, ts.LOSSES
    FROM PFL_DB.STATS_AND_INFO.TEAMS t
    JOIN PFL_DB.STATS_AND_INFO.TEAM_SEASON_STATS ts ON t.TEAM_ID = ts.TEAM_ID AND ts.SEASON_ID = 2024
    ORDER BY t.TEAM_NAME
""")

map_data = []
for _, row in teams.iterrows():
    coords = CITY_COORDS.get(row["CITY"])
    if coords:
        map_data.append({
            "lat": coords[0],
            "lon": coords[1],
        })

if map_data:
    st.map(pd.DataFrame(map_data))

# --- Conference Standings ---
st.subheader("2024 Conference Standings")

standings = conn.query("""
    SELECT c.CONFERENCE_NAME, d.DIVISION_NAME, t.TEAM_NAME,
           ts.WINS, ts.LOSSES,
           ts.POINTS_SCORED AS PF, ts.POINTS_ALLOWED AS PA,
           ts.POINTS_SCORED - ts.POINTS_ALLOWED AS DIFF,
           ts.MADE_PLAYOFFS
    FROM PFL_DB.STATS_AND_INFO.TEAMS t
    JOIN PFL_DB.STATS_AND_INFO.DIVISIONS d ON t.DIVISION_ID = d.DIVISION_ID
    JOIN PFL_DB.STATS_AND_INFO.CONFERENCES c ON d.CONFERENCE_ID = c.CONFERENCE_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAM_SEASON_STATS ts ON t.TEAM_ID = ts.TEAM_ID AND ts.SEASON_ID = 2024
    ORDER BY c.CONFERENCE_NAME, d.DIVISION_NAME, ts.WINS DESC
""")

for conf in standings["CONFERENCE_NAME"].unique():
    st.markdown(f"#### {conf}")
    conf_data = standings[standings["CONFERENCE_NAME"] == conf]
    for div in conf_data["DIVISION_NAME"].unique():
        div_data = conf_data[conf_data["DIVISION_NAME"] == div][
            ["TEAM_NAME", "WINS", "LOSSES", "PF", "PA", "DIFF", "MADE_PLAYOFFS"]
        ].copy()
        div_data["MADE_PLAYOFFS"] = div_data["MADE_PLAYOFFS"].map({True: "Yes", False: ""})
        st.markdown(f"**{div}**")
        st.dataframe(div_data, use_container_width=True, hide_index=True)

# --- Point Differential Chart ---
st.subheader("Point Differential by Team")

diff_data = conn.query("""
    SELECT t.TEAM_NAME,
           ts.POINTS_SCORED - ts.POINTS_ALLOWED AS POINT_DIFF
    FROM PFL_DB.STATS_AND_INFO.TEAMS t
    JOIN PFL_DB.STATS_AND_INFO.TEAM_SEASON_STATS ts ON t.TEAM_ID = ts.TEAM_ID AND ts.SEASON_ID = 2024
    ORDER BY POINT_DIFF ASC
""")

st.bar_chart(diff_data, x="TEAM_NAME", y="POINT_DIFF", horizontal=True)
