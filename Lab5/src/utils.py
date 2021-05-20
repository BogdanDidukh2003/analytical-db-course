class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


def validate_data(data):
    if data is dict:
        data = [data]
    for entry in data:
        for key in entry.keys():
            entry[key] = entry[key].replace('\'', '"')
        entry['bfy'] = int(entry['bfy'])
        entry['budget'] = int(float(entry['budget']))
        entry['actuals'] = int(float(entry['actuals']))
