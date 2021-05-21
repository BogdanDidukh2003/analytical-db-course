from config import COSMOS_DB_KEYSPACE

SELECT_DATA_COUNT_SCRIPT = "SELECT COUNT(*) FROM revenues"

INSERT_DATA_SCRIPT = """
INSERT INTO revenues
    (id, bfy, ftyp, fundtype, dpt, department, rsrc, revenue_source, budget, actuals)
VALUES
    (uuid(), {bfy}, '{ftyp}', '{fundtype}', '{dpt}', '{department}', '{rsrc}', '{revenue_source}', {budget}, {actuals})
"""

CREATE_TABLE_SCRIPT = """
CREATE TABLE IF NOT EXISTS revenues (
    id uuid PRIMARY KEY,
    bfy int,
    ftyp text,
    fundtype text,
    dpt text,
    department text,
    rsrc text,
    revenue_source text,
    budget int,
    actuals int
)
"""

DELETE_TABLE_SCRIPT = "DROP TABLE IF EXISTS revenues"

CREATE_KEYSPACE_SCRIPT = """
CREATE KEYSPACE IF NOT EXISTS %s
    WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter' : '1'}
""" % COSMOS_DB_KEYSPACE
