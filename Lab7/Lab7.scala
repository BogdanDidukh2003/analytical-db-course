import org.apache.spark.eventhubs._
import com.microsoft.azure.eventhubs._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import spark.implicits._

// Compose connection string to Event Hubs
val namespaceName = "iot-lab5-event-hubs-namespace"
val eventHubName = "revenues-data-event-hub"
val sasKeyName = "RootManageAccessKey"
val sasKey = "<EVENT_HUB_KEY_HERE>"
val connStr = new com.microsoft.azure.eventhubs.ConnectionStringBuilder()
            .setNamespaceName(namespaceName)
            .setEventHubName(eventHubName)
            .setSasKeyName(sasKeyName)
            .setSasKey(sasKey)

// Connect to Event Hub
val customEventhubParameters =
  EventHubsConf(connStr.toString())
  .setMaxEventsPerTrigger(1)

// Init data stream
val incomingStream = spark.readStream.format("eventhubs").options(customEventhubParameters.toMap).load()

incomingStream.printSchema

// Convert content of messages to string
val messages =
  incomingStream
  .withColumn("Body", $"body".cast(StringType))
  .select($"Body".as("body"))

messages.printSchema

// Convert input string as ndjson to necessary fields

val parsed_lines = messages.withColumn("body", explode(split($"body", "\\n")))
val filtered_lines = parsed_lines.filter(!$"body".startsWith("{\"index") && ($"body" !== ""))
val selected_columns = filtered_lines.select(
  get_json_object($"body", "$.bfy").alias("year"),
  get_json_object($"body", "$.fundtype").alias("fundtype"),
  get_json_object($"body", "$.department").alias("department"),
  get_json_object($"body", "$.revenue_source").alias("revenue_source"),
)
val result = selected_columns

result.printSchema

// Stream result data to console
// result.writeStream.outputMode("append").format("console").option("truncate", false)
//   .start().awaitTermination()

// Stream result data to data lake
result.writeStream
  .format("com.databricks.spark.csv")
  .outputMode("append")
  .option("checkpointLocation", "/mnt/revenues_data")
  .start("/mnt/revenues_data")
