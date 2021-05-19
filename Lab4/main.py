import redis

from config import DATA_URL, REDIS_HOSTNAME, REDIS_PORT, REDIS_KEY
from src.data_processor import DataProcessor
from src.strategies import get_strategy
from src.db_connector import CosmosDBConnector


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

    db_connector = CosmosDBConnector()
    db_connector.close()


if __name__ == '__main__':
    main()
