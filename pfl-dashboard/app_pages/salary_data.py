import streamlit as st

st.title("Salary Data")

conn = st.session_state["conn"]

top_salaries = conn.query("""
    SELECT p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
           c.ANNUAL_SALARY
    FROM PFL_DB.STATS_AND_INFO.PLAYER_CONTRACTS c
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON c.PLAYER_ID = p.PLAYER_ID
    WHERE c.IS_ACTIVE = TRUE
    ORDER BY c.ANNUAL_SALARY ASC
    LIMIT 10
""")

avg_salary_by_position = conn.query("""
    SELECT pos.POSITION_NAME,
           AVG(c.ANNUAL_SALARY) AS AVG_SALARY
    FROM PFL_DB.STATS_AND_INFO.PLAYER_CONTRACTS c
    JOIN PFL_DB.STATS_AND_INFO.PLAYERS p ON c.PLAYER_ID = p.PLAYER_ID
    JOIN PFL_DB.STATS_AND_INFO.POSITIONS pos ON p.PRIMARY_POSITION_ID = pos.POSITION_ID
    WHERE c.IS_ACTIVE = TRUE
    GROUP BY pos.POSITION_NAME
    ORDER BY AVG_SALARY ASC
""")

st.subheader("Top 10 Highest Paid Players")
st.bar_chart(top_salaries, x="PLAYER_NAME", y="ANNUAL_SALARY", horizontal=True)

st.subheader("Average Salary by Position")
st.bar_chart(avg_salary_by_position, x="POSITION_NAME", y="AVG_SALARY", horizontal=True)
