from config import RESOURCE_NAME, DATA_URL
from src.data_processor import DataProcessor
from src.strategies import get_strategy, CosmosDBSavingStrategy, RedisLoggingStrategy
from src.db_connector import CosmosDBConnector


def main():
    print('\tLab 4')

    # db_connector = CosmosDBConnector()
    # db_connector.delete_table()
    # db_connector.create_table()
    # redis_logger = RedisLoggingStrategy()
    # redis_logger.clear_logs(RESOURCE_NAME)

    writer_strategy, logger_strategy = get_strategy()
    dp = DataProcessor(resource_name=RESOURCE_NAME, url_template=DATA_URL,
                       data_handler_strategy=writer_strategy,
                       logger_strategy=logger_strategy)
    dp.process_data()

    # db_connector = CosmosDBConnector()
    # print(db_connector.get_data_count().all())

    if isinstance(writer_strategy, CosmosDBSavingStrategy):
        db_connector = CosmosDBConnector()
        db_connector.close()
    print('Done.')


if __name__ == '__main__':
    main()
