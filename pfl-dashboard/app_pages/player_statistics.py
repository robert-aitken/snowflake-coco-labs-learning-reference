import streamlit as st

st.title("Player Statistics")

conn = st.session_state["conn"]

top_passers = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.PASS_YARDS
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024
    ORDER BY s.PASS_YARDS DESC
    LIMIT 5
""")

top_rushers = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.RUSH_YARDS
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024
    ORDER BY s.RUSH_YARDS DESC
    LIMIT 5
""")

top_receivers = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.RECEIVING_YARDS
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024
    ORDER BY s.RECEIVING_YARDS DESC
    LIMIT 5
""")

top_tacklers = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.TACKLES_TOTAL
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024 AND s.TACKLES_TOTAL > 0
    ORDER BY s.TACKLES_TOTAL DESC
    LIMIT 5
""")

top_sackers = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.SACKS
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024 AND s.SACKS > 0
    ORDER BY s.SACKS DESC
    LIMIT 5
""")

top_interceptors = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           t.TEAM_NAME, s.INTERCEPTIONS
    FROM PFL_DB.STATS_AND_INFO.PLAYER_SEASON_STATS s
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON s.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.TEAMS t ON s.TEAM_ID = t.TEAM_ID
    WHERE s.SEASON_ID = 2024 AND s.INTERCEPTIONS > 0
    ORDER BY s.INTERCEPTIONS DESC
    LIMIT 5
""")

st.subheader("Offense")
col1, col2, col3 = st.columns(3)
with col1:
    st.markdown("**Top 5 Passers**")
    st.dataframe(top_passers, use_container_width=True, hide_index=True)
with col2:
    st.markdown("**Top 5 Rushers**")
    st.dataframe(top_rushers, use_container_width=True, hide_index=True)
with col3:
    st.markdown("**Top 5 Receivers**")
    st.dataframe(top_receivers, use_container_width=True, hide_index=True)

st.subheader("Defense")
col4, col5, col6 = st.columns(3)
with col4:
    st.markdown("**Top 5 Tacklers**")
    st.dataframe(top_tacklers, use_container_width=True, hide_index=True)
with col5:
    st.markdown("**Top 5 Sack Leaders**")
    st.dataframe(top_sackers, use_container_width=True, hide_index=True)
with col6:
    st.markdown("**Top 5 Interceptions**")
    st.dataframe(top_interceptors, use_container_width=True, hide_index=True)
