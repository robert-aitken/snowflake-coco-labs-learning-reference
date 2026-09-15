def setup_pfl ():
    import snowflake.snowpark.context as ctx
    session = ctx.get_active_session()
    with open("resources/setup_pfl_data.sql") as f:
        sql = f.read()
    for stmt in [s.strip() for s in sql.split(";") if s.strip()]:
        session.sql(stmt).collect()
    print("Setup complete — all tables loaded.")