from cassandra.auth import PlainTextAuthProvider
from cassandra.cluster import Cluster
from ssl import PROTOCOL_TLSv1_2, CERT_NONE, SSLContext
import redis

from config import DATA_URL, REDIS_HOSTNAME, REDIS_PORT, REDIS_KEY
from src.data_processor import DataProcessor
from src.strategies import get_strategy
from src.cql_templates import (
    CREATE_TABLE_SCRIPT, INSERT_DATA_SCRIPT, DELETE_TABLE_SCRIPT, SELECT_ALL_DATA_SCRIPT)
import config

test_data = [
    {'id': 1, 'bfy': 2016, 'ftyp': 'EFOP', 'fundtype': 'Enterprise Operating Fund',
     'dpt': 'DWU', 'department': 'Water Utilities', 'rsrc': '8416',
     'revenue_source': 'Misc-Proceeds Fr Sale Of Land', 'budget': 2500, 'actuals': 0},
    {'id': 2, 'bfy': '2016', 'ftyp': 'EFOP', 'fundtype': 'Enterprise Operating Fund',
     'dpt': 'DWU', 'department': 'Water Utilities', 'rsrc': '8458',
     'revenue_source': 'Misc-Water Special Assessments', 'budget': 25300, 'actuals': 0}]


def main():
    print('\tLab 4')
    r = redis.StrictRedis(host=REDIS_HOSTNAME, port=REDIS_PORT, password=REDIS_KEY, ssl=True)
    is_working = r.ping()
    if not is_working:
        print('[ERROR] Redis connection failed!')
    else:
        print('[INFO] Successfully connected to Redis.')
        # r.set('try 1', 'data pcs')
        # print(r.get('try 1').decode('utf-8'))

    dp = DataProcessor(url_template=DATA_URL, data_handler_strategy=get_strategy(),
                       step=5, limit=20)
    dp.process_data()

    ssl_context = SSLContext(PROTOCOL_TLSv1_2)
    ssl_context.verify_mode = CERT_NONE

    auth_provider = PlainTextAuthProvider(
        username=config.COSMOS_DB_USERNAME,
        password=config.COSMOS_DB_PASSWORD)
    cluster = Cluster([config.COSMOS_DB_CONTACT_POINT], port=config.COSMOS_DB_PORT,
                      auth_provider=auth_provider, ssl_context=ssl_context)
    session = cluster.connect(config.COSMOS_DB_KEYSPACE)

    print('Deleting Table...')
    session.execute(DELETE_TABLE_SCRIPT)
    print('Creating Table...')
    session.execute(CREATE_TABLE_SCRIPT)
    print('Inserting Test Data...')
    session.execute(INSERT_DATA_SCRIPT.format(**test_data[0]))
    session.execute(INSERT_DATA_SCRIPT.format(**test_data[1]))
    rows = session.execute(SELECT_ALL_DATA_SCRIPT)
    print('DATA:')
    print(rows.all())


if __name__ == '__main__':
    main()
