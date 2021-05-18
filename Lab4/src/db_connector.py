from cassandra.auth import PlainTextAuthProvider
from cassandra.cluster import Cluster
from ssl import PROTOCOL_TLSv1_2, CERT_NONE, SSLContext

from src import cql_templates
import config


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class CosmosDBConnector(metaclass=Singleton):
    def __init__(self):
        ssl_context = SSLContext(PROTOCOL_TLSv1_2)
        ssl_context.verify_mode = CERT_NONE

        auth_provider = PlainTextAuthProvider(
            username=config.COSMOS_DB_USERNAME,
            password=config.COSMOS_DB_PASSWORD)
        self.cluster = Cluster([config.COSMOS_DB_CONTACT_POINT], port=config.COSMOS_DB_PORT,
                               auth_provider=auth_provider, ssl_context=ssl_context)
        self.session = self.cluster.connect(config.COSMOS_DB_KEYSPACE)

    def close(self):
        self.cluster.shutdown()

    def delete_table(self):
        self.session.execute(cql_templates.DELETE_TABLE_SCRIPT)

    def create_table(self):
        self.session.execute(cql_templates.CREATE_TABLE_SCRIPT)

    def save_data(self, data):
        if data is dict:
            data = [data]
        for record in data:
            self.session.execute(cql_templates.INSERT_DATA_SCRIPT.format(**record))

    def get_all_data(self):
        return self.session.execute(cql_templates.SELECT_ALL_DATA_SCRIPT)
