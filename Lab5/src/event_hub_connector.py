from azure.eventhub import EventHubProducerClient, EventData
import json
import uuid

from src import constants
import config
import src.utils


class EventHubConnector(metaclass=src.utils.Singleton):
    def __init__(self):
        self.producer = EventHubProducerClient.from_connection_string(
            conn_str=config.EVENT_HUB_CONNECTION_STRING,
            eventhub_name=config.EVENT_HUB_NAME)
        self.producer.__enter__()

    def __del__(self):
        self.producer.__exit__()

    def save_data(self, data):
        data = self.__format_to_ndjson(data)
        self.__send_event_data(EventData(data))

    def __format_to_ndjson(self, data):
        request_content_list = []
        for entry in data:
            request_content_list.append(constants.NDJSON_ID_TEMPLATE % uuid.uuid4())
            request_content_list.append(json.dumps(entry))
        return '\n'.join(request_content_list) + '\n'

    def __send_event_data(self, event_data):
        event_data_batch = self.producer.create_batch()
        event_data_batch.add(event_data)
        self.producer.send_batch(event_data_batch)
