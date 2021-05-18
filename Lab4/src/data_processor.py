from urllib.request import urlopen
import json


class DataProcessor:
    def __init__(self, url_template, data_handler_strategy,
                 step=100, offset=0, limit=None):
        self.data_iterator = DataIterator(
            url_template=url_template, step=step, offset=offset, limit=limit)
        self.data_handler = data_handler_strategy()

    def process_data(self):
        for i, data in enumerate(self.data_iterator, start=1):
            self.data_handler.process_data(data)
            print(i)


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
            self.offset += self.step

        return result
