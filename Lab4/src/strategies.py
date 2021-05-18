from config import MODE


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
    def process_data(self, data):
        print(data)


class CosmosDBSavingStrategy(DataHandlerStrategy):
    pass
