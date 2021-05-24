configs = {"fs.azure.account.auth.type": "OAuth",
       "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
       "fs.azure.account.oauth2.client.id": "<CLIENT_ID>",
       "fs.azure.account.oauth2.client.secret": "<CLIENT_SECRET>",
       "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/<CLIENT_TENANT>/oauth2/token",
       "fs.azure.createRemoteFileSystemDuringInitialization": "true"}

dbutils.fs.mount(
  source = "abfss://revenues-container@<STORAGE_ACCOUNT>.dfs.core.windows.net/folder1",
  mount_point = "/mnt/revenues_data",
  extra_configs = configs)
