from config import MODE
from src.db_connector import CosmosDBConnector


def get_strategy():
    if MODE == 'LOCAL':
        return ConsoleOutputStrategy
    elif MODE == 'REMOTE':
        return CosmosDBSavingStrategy

    return ConsoleOutputStrategy  # default


class DataHandlerStrategy:
    def process_data(self, *args, **kwargs):
        pass


class ConsoleOutputStrategy(DataHandlerStrategy):
    def process_data(self, data, data_range=None):
        if data is dict:
            data = [data]
        if data_range is None:
            data_range = [1, len(data)]
        for entry in data:
            print(entry)
        print(f'Rows: {data_range[0]}-{data_range[1]}')


class CosmosDBSavingStrategy(DataHandlerStrategy):
    def __init__(self):
        self.db_connector = CosmosDBConnector()

    def process_data(self, data, data_range=None):
        if data is dict:
            data = [data]
        if data_range is None:
            data_range = [1, len(data)]
        self.db_connector.save_data(data)
        print(f'Rows: {data_range[0]}-{data_range[1]}')
