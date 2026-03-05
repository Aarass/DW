import pandas as pd

# Generiši sve datume
datumi = pd.date_range(start="2000-01-01", end="2025-12-31", freq="D")

# Napravi DataFrame sa svim kolonama
df = pd.DataFrame({
    "Date": datumi,
    "Day": datumi.day,
    "Month": datumi.month,
    "Quarter": datumi.quarter,
    "Year": datumi.year
})

# Sačuvaj u CSV
df.to_csv("DateDim.csv", index=False, encoding="utf-8")