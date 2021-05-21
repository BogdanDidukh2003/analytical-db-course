import redis

import config
import src.utils


class RedisConnector(metaclass=src.utils.Singleton):
    def __init__(self):
        self.redis_connector = redis.StrictRedis(
            host=config.REDIS_HOSTNAME,
            port=config.REDIS_PORT,
            password=config.REDIS_KEY,
            ssl=True)
        is_working = self.redis_connector.ping()
        if not is_working:
            print('[ERROR] Redis connection failed!')
        else:
            print('[INFO] Successfully connected to Redis.')

    def save_log(self, key, value):
        self.redis_connector.set(key, value)

    def read_log(self, key):
        log = self.redis_connector.get(key)
        if log is None:
            return log
        return log.decode('utf-8')

    def delete_log(self, key):
        self.redis_connector.delete(key)
