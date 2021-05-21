from urllib.request import urlopen
import json

from src import constants
from src.utils import validate_data


class DataProcessor:
    def __init__(self, resource_name, url_template, data_handler_strategy, logger_strategy,
                 step=100, offset=0, limit=None):
        self.resource_name = resource_name
        self.data_iterator = DataIterator(
            url_template=url_template, step=step, offset=offset, limit=limit)
        self.data_handler = data_handler_strategy()
        self.logger = logger_strategy()

    def process_data(self):
        log_status = self.logger.get_status(self.resource_name)
        if log_status == constants.LOG_STATUS_COMPLETED:
            self.logger.log_already_exists(self.resource_name)
            return
        elif log_status == constants.LOG_STATUS_START:
            self.data_iterator.offset = self.logger.get_logged_rows_number(self.resource_name)
        else:
            self.logger.log_start(self.resource_name)

        for data in self.data_iterator:
            data_range = [
                self.data_iterator.offset - self.data_iterator.step + 1,
                min(self.data_iterator.offset,
                    self.data_iterator.offset - (self.data_iterator.step - len(data))
                    )]
            self.data_handler.process_data(data, data_range=data_range)
            self.logger.log_progress(self.resource_name, data_range=data_range)
        self.logger.log_completed(self.resource_name)


class DataIterator:
    def __init__(self, url_template, step=100, offset=0, limit=None):
        self.url_template = url_template
        self.step = step
        self.offset = offset
        self.limit = limit

    def __iter__(self):
        return self

    def __next__(self):
        if self.limit and self.offset >= self.limit:
            raise StopIteration
        result = self.query_data()
        if result:
            return result
        raise StopIteration

    def query_data(self):
        result = None
        with urlopen(self.url_template.format(
                step=self.step, offset=self.offset
        )) as data:
            result = json.loads(data.read().decode('utf-8'))
            validate_data(result)
            self.offset += self.step

        return result
