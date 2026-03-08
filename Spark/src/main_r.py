import os

os.environ["JAVA_HOME"] = r"C:\Program Files\Java\jdk-17"
os.environ["PATH"] = os.environ["JAVA_HOME"] + r"\bin;" + os.environ["PATH"]

import os
import pandas as pd

from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler, StandardScaler
from pyspark.ml.regression import LinearRegression
from pyspark.ml.evaluation import RegressionEvaluator
from pyspark.ml import Pipeline

spark = SparkSession.builder \
    .appName("WineQualityRegression") \
    .master("local[*]") \
    .getOrCreate()

df = spark.read.csv(
    "../data/winequality-red.csv",
    header=True,
    inferSchema=True,
    sep=";"
)


df = df.dropDuplicates()
df = df.na.drop()


feature_cols = [c for c in df.columns if c != "quality"]

assembler = VectorAssembler(
    inputCols=feature_cols,
    outputCol="features_raw"
)

scaler = StandardScaler(
    inputCol="features_raw",
    outputCol="features",
    withStd=True,
    withMean=True
)

lr = LinearRegression(
    featuresCol="features",
    labelCol="quality"
)

pipeline = Pipeline(stages=[assembler, scaler, lr])

# 80% uci
# 20% radi regresiju
train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)


model = pipeline.fit(train_df)

predictions = model.transform(test_df)

predictions.select("quality", "prediction").show(10, truncate=False)

rmse_evaluator = RegressionEvaluator(
    labelCol="quality",
    predictionCol="prediction",
    metricName="rmse"
)

mae_evaluator = RegressionEvaluator(
    labelCol="quality",
    predictionCol="prediction",
    metricName="mae"
)

r2_evaluator = RegressionEvaluator(
    labelCol="quality",
    predictionCol="prediction",
    metricName="r2"
)

rmse = rmse_evaluator.evaluate(predictions)
mae = mae_evaluator.evaluate(predictions)
r2 = r2_evaluator.evaluate(predictions)

os.makedirs("../output", exist_ok=True)

predictions.select("quality", "prediction") \
    .toPandas() \
    .to_csv("../output/regression_predictions.csv", index=False)

with open("output/regression_metrics.txt", "w", encoding="utf-8") as f:
    f.write(f"RMSE: {rmse}\n")
    f.write(f"MAE: {mae}\n")
    f.write(f"R2: {r2}\n")

print("Rezultati su sacuvani u output folder.")

spark.stop()