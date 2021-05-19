from config import MODE
from src import constants
from src.db_connector import CosmosDBConnector
from src.log_connector import RedisConnector


def get_strategy():
    if MODE == 'LOCAL':
        return ConsoleOutputStrategy, ConsoleLoggingStrategy
    elif MODE == 'REMOTE':
        return CosmosDBSavingStrategy, RedisLoggingStrategy

    return ConsoleOutputStrategy, ConsoleLoggingStrategy  # default


class DataHandlerStrategy:
    def process_data(self, *args, **kwargs):
        pass


class ConsoleOutputStrategy(DataHandlerStrategy):
    def process_data(self, data, data_range=None):
        if data is dict:
            data = [data]
        for entry in data:
            print(entry)


class CosmosDBSavingStrategy(DataHandlerStrategy):
    def __init__(self):
        self.db_connector = CosmosDBConnector()

    def process_data(self, data, data_range=None):
        if data is dict:
            data = [data]
        self.db_connector.save_data(data)


class LoggerStrategy:
    def get_status(self, resource_name):
        pass

    def get_logged_rows_number(self, resource_name):
        pass

    def log_start(self, resource_name):
        pass

    def log_completed(self, resource_name):
        pass

    def log_progress(self, resource_name, data_range):
        pass

    def log_already_exists(self, resource_name):
        pass

    def clear_logs(self, resource_name):
        pass


class ConsoleLoggingStrategy(LoggerStrategy):
    def get_status(self, resource_name):
        return None

    def get_logged_rows_number(self, resource_name):
        return 0

    def log_start(self, resource_name):
        print(f'[LOG] {resource_name} - START')

    def log_completed(self, resource_name):
        print(f'[LOG] {resource_name} - COMPLETED')

    def log_progress(self, resource_name, data_range):
        start, end = data_range
        print(f'[LOG] Rows: {start}-{end}\t(from {resource_name})')

    def log_already_exists(self, resource_name):
        print(f'[LOG] {resource_name} ignored. Data already exists!')

    def clear_logs(self, resource_name):
        pass


class RedisLoggingStrategy(LoggerStrategy):
    def __init__(self):
        self.log_connector = RedisConnector()

    def get_status(self, resource_name):
        return self.log_connector.read_log(
            resource_name + constants.LOG_STATUS_KEY)

    def get_logged_rows_number(self, resource_name):
        data_range = self.log_connector.read_log(
            resource_name + constants.LOG_ROWS_NUMBER_KEY)
        _, end = data_range.split('-')
        end = int(end)
        return end

    def log_start(self, resource_name):
        self.log_connector.save_log(
            resource_name + constants.LOG_STATUS_KEY,
            constants.LOG_STATUS_START)

    def log_completed(self, resource_name):
        self.log_connector.save_log(
            resource_name + constants.LOG_STATUS_KEY,
            constants.LOG_STATUS_COMPLETED)

    def log_progress(self, resource_name, data_range):
        start, end = data_range
        self.log_connector.save_log(
            resource_name + constants.LOG_ROWS_NUMBER_KEY,
            f'{start}-{end}')

    def log_already_exists(self, resource_name):
        self.log_connector.save_log(
            resource_name + constants.LOG_WARNING_KEY,
            'Ignored. Data already exists!')

    def clear_logs(self, resource_name):
        self.log_connector.delete_log(resource_name + constants.LOG_STATUS_KEY)
        self.log_connector.delete_log(resource_name + constants.LOG_ROWS_NUMBER_KEY)
        self.log_connector.delete_log(resource_name + constants.LOG_WARNING_KEY)
