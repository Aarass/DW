# import os
# import pandas as pd
# import oracledb
# from datetime import datetime

# COPY_COLS = {
#     "product_translation": ["product_category_name", "product_category_name_english"],
#     "customers": ["customer_id", "customer_unique_id", "customer_zip_code_prefix", "customer_city", "customer_state", "name", "gender", "age", "phone"],
#     "sellers": ["seller_id", "seller_zip_code_prefix", "seller_city", "seller_state"],
#     "products": ["product_id", "product_category_name", "product_name_lenght", "product_description_lenght",
#                  "product_photos_qty", "product_weight_g", "product_length_cm", "product_height_cm", "product_width_cm"],
#     "orders": ["order_id", "customer_id", "order_status", "order_purchase_timestamp", "order_approved_at",
#                "order_delivered_carrier_date", "order_delivered_customer_date", "order_estimated_delivery_date"],
#     "order_items": ["order_id", "order_item_id", "product_id", "seller_id", "shipping_limit_date", "price", "freight_value"],
#     "order_payments": ["order_id", "payment_sequential", "payment_type", "payment_installments", "payment_value"],
#     "order_reviews": ["review_id", "order_id", "review_score", "review_comment_title", "review_comment_message",
#                       "review_creation_date", "review_answer_timestamp"],
#     "geolocation": ["geolocation_zip_code_prefix", "geolocation_lat", "geolocation_lng", "geolocation_city", "geolocation_state"],
# }

# DATA_DIR = "./data"

# LOAD_ORDER = [
#     ("customers", "olist_customers_dataset2.csv"),
#     ("product_translation", "product_category_name_translation.csv"),
#     ("sellers", "olist_sellers_dataset.csv"),
#     ("products", "olist_products_dataset.csv"),
#     ("orders", "olist_orders_dataset.csv"),
#     ("order_items", "olist_order_items_dataset.csv"),
# ]


# TIMESTAMP_COLS = {
#     "orders": ["order_purchase_timestamp", "order_approved_at", "order_delivered_carrier_date",
#                "order_delivered_customer_date", "order_estimated_delivery_date"],
#     "order_items": ["shipping_limit_date"],
#     "order_reviews": ["review_creation_date", "review_answer_timestamp"],
# }

# def normalize_value(v):
#     """Pretvori NaN u None da Oracle ubaci NULL."""
#     if pd.isna(v):
#         return None
#     return v

# def copy_csv_oracle(conn, table, csv_path, batch_size=5000):
#     cols = COPY_COLS[table]
#     placeholders = ", ".join([f":{i+1}" for i in range(len(cols))])
#     cols_sql = ", ".join(cols)

#     sql = f"INSERT INTO {table} ({cols_sql}) VALUES ({placeholders})"

#     df = pd.read_csv(csv_path)

#     # Opcionalno: pokušaj konverzije timestamp kolona u Python datetime (sigurnije)
#     # Ako format u CSV-u bude drugačiji, javi i prilagodiću.
#     for c in TIMESTAMP_COLS.get(table, []):
#         if c in df.columns:
#             df[c] = pd.to_datetime(df[c], errors="coerce")  # NaN/invalid -> NaT

#     rows = []
#     cur = conn.cursor()
#     try:
#         for _, r in df.iterrows():
#             row = [normalize_value(r[c]) for c in cols]
#             rows.append(row)

#             if len(rows) >= batch_size:
#                 cur.executemany(sql, rows)
#                 rows.clear()

#         if rows:
#             cur.executemany(sql, rows)

#     finally:
#         cur.close()

# def main():
#     conn = oracledb.connect(
#         user="IPZ18855",
#         password="IPZ18855",
#         dsn="160.99.12.92:1521/GISLAB_PD"
#     )
#     conn.autocommit = False

#     try:
#         for table, file in LOAD_ORDER:
#             path = os.path.join(DATA_DIR, file)
#             print(f"Loading {table} from {path} ...")
#             copy_csv_oracle(conn, table, path)
#             conn.commit()
#         print("DONE ✅")
#     except Exception as e:
#         conn.rollback()
#         print("FAILED ❌", e)
#         raise
#     finally:
#         conn.close()

# if __name__ == "__main__":
#     main()