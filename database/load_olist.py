import os
import psycopg2
import pandas as pd
from io import StringIO

COPY_COLS = {
    "product_category_name_translation": ["product_category_name", "product_category_name_english"],
    "customers": ["customer_id", "customer_unique_id", "customer_zip_code_prefix", "customer_city", "customer_state", "name", "gender", "age", "phone"],
    "sellers": ["seller_id", "seller_zip_code_prefix", "seller_city", "seller_state"],
    "products": ["product_id", "product_category_name", "product_name_lenght", "product_description_lenght",
                 "product_photos_qty", "product_weight_g", "product_length_cm", "product_height_cm", "product_width_cm"],
    "orders": ["order_id", "customer_id", "order_status", "order_purchase_timestamp", "order_approved_at",
               "order_delivered_carrier_date", "order_delivered_customer_date", "order_estimated_delivery_date"],
    "order_items": ["order_id", "order_item_id", "product_id", "seller_id", "shipping_limit_date", "price", "freight_value"],
    "order_payments": ["order_id", "payment_sequential", "payment_type", "payment_installments", "payment_value"],
    "order_reviews": ["review_id", "order_id", "review_score", "review_comment_title", "review_comment_message",
                      "review_creation_date", "review_answer_timestamp"],
    "geolocation": ["geolocation_zip_code_prefix", "geolocation_lat", "geolocation_lng", "geolocation_city", "geolocation_state"],
}

CONN = "postgresql://neondb_owner:npg_Cf4k1wnBvEtz@ep-curly-poetry-aln62af7-pooler.c-3.eu-central-1.aws.neon.tech/ecommerce_oltp?sslmode=require&channel_binding=require"

DATA_DIR = "./data"


LOAD_ORDER = [
    ("customers", "olist_customers_dataset2.csv"),
    ("product_category_name_translation", "product_category_name_translation.csv"),
    ("sellers", "olist_sellers_dataset.csv"),
    ("products", "olist_products_dataset.csv"),
    ("orders", "olist_orders_dataset.csv"),
    ("order_items", "olist_order_items_dataset.csv"),
    ("order_payments", "olist_order_payments_dataset.csv"),
    ("order_reviews", "olist_order_reviews_dataset.csv"),
    ("geolocation", "olist_geolocation_dataset.csv"),
]

def copy_csv(conn, table, csv_path):
    df = pd.read_csv(csv_path)
    buffer = StringIO()
    df.to_csv(buffer, index=False, header=False)
    buffer.seek(0)

    cols = COPY_COLS[table]
    cols_sql = ", ".join(cols)

    with conn.cursor() as cur:
        cur.copy_expert(
            f"COPY {table} ({cols_sql}) FROM STDIN WITH (FORMAT csv, NULL '')",
            buffer
        )

def main():
    conn = psycopg2.connect(CONN)
    conn.autocommit = False
    try:
        for table, file in LOAD_ORDER:
            path = os.path.join(DATA_DIR, file)
            print(f"Loading {table} from {path} ...")
            copy_csv(conn, table, path)
            conn.commit()
        print("DONE ✅")
    except Exception as e:
        conn.rollback()
        print("FAILED ❌", e)
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    main()