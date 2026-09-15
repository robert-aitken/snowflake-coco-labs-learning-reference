import streamlit as st
import os

st.set_page_config(page_title="PFL Dashboard",
    layout="wide")

conn = st.connection("snowflake", ttl=os.getenv("SNOWFLAKE_CONNECTION_TTL"))
st.session_state["conn"] = conn

team_info = st.Page("app_pages/team_information.py",
    title="Team Information")
player_stats = st.Page("app_pages/player_statistics.py",
    title="Player Statistics")
salary_data = st.Page("app_pages/salary_data.py", title="Salary Data")
league_overview = st.Page("app_pages/league_overview.py", title="League Overview")

pg = st.navigation([team_info, player_stats, salary_data, league_overview])
pg.run()
