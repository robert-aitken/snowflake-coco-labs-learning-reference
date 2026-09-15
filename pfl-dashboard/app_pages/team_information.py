import streamlit as st

st.title("Team Information")

conn = st.session_state["conn"]

df = conn.query("""
    SELECT t.TEAM_NAME, t.CITY, t.FOUNDED_YEAR, t.STADIUM_NAME, t.STADIUM_CAPACITY,
           s.WINS, s.LOSSES, s.MADE_PLAYOFFS, s.PLAYOFF_RESULT,
           s.POINTS_SCORED, s.POINTS_ALLOWED
    FROM PFL_DB.STATS_AND_INFO.TEAMS t
    JOIN PFL_DB.STATS_AND_INFO.TEAM_SEASON_STATS s
        ON t.TEAM_ID = s.TEAM_ID
    WHERE s.SEASON_ID = 2024
    ORDER BY t.TEAM_NAME
""")

for _, row in df.iterrows():
    with st.expander(row["TEAM_NAME"]):
        col1, col2 = st.columns(2)
        with col1:
            st.write(f"**City:** {row['CITY']}")
            st.write(f"**Founded:** {row['FOUNDED_YEAR']}")
            st.write(f"**Stadium:** {row['STADIUM_NAME']} ({row['STADIUM_CAPACITY']:,} seats)")
        with col2:
            st.write(f"**2024 Record:** {row['WINS']}W - {row['LOSSES']}L")
            st.write(f"**Points Scored:** {row['POINTS_SCORED']}  |  **Allowed:** {row['POINTS_ALLOWED']}")
            if row["MADE_PLAYOFFS"]:
                st.write(f"**Playoffs:** :green[{row['PLAYOFF_RESULT']}]")
            else:
                st.write("**Playoffs:** :red[Did not qualify]")
