from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("TestSpark") \
    .master("local[*]") \
    .getOrCreate()

print("Spark radi.")
print("Spark version:", spark.version)

spark.stop()