from security_config import *

RESOURCE_NAME = "www.dallasopendata.com/resource/wkxp-wnc2.json"
DATA_URL = "https://" + RESOURCE_NAME + "?$limit={step}&$offset={offset}"
MODE = "LOCAL"  # "LOCAL" or "REMOTE"
