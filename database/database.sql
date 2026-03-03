CREATE TABLE customers (
  customer_id VARCHAR(50) PRIMARY KEY,
  customer_unique_id VARCHAR(50) NOT NULL,
  customer_zip_code_prefix VARCHAR(50) NOT NULL,
  customer_city VARCHAR(100) NOT NULL,
  customer_state CHAR(2) NOT NULL,
  name VARCHAR(100) NOT NULL,
  gender CHAR(1) NOT NULL,
  age INT NOT NULL,
  phone VARCHAR(30) NOT NULL
);
CREATE TABLE sellers (
  seller_id                VARCHAR(50) PRIMARY KEY,
  seller_zip_code_prefix   VARCHAR(50) NOT NULL,
  seller_city              VARCHAR(100) NOT NULL,
  seller_state             CHAR(2) NOT NULL
);
CREATE TABLE products (
  product_id                 VARCHAR(50) PRIMARY KEY,
  product_category_name      VARCHAR(100),
  product_name_lenght        NUMERIC,
  product_description_lenght NUMERIC,
  product_photos_qty         NUMERIC,
  product_weight_g           NUMERIC,
  product_length_cm          NUMERIC,
  product_height_cm          NUMERIC,
  product_width_cm           NUMERIC
);
CREATE TABLE product_category_name_translation (
  product_category_name          VARCHAR(100) PRIMARY KEY,
  product_category_name_english  VARCHAR(100) NOT NULL
);
CREATE TABLE orders (
  order_id                       VARCHAR(50) PRIMARY KEY,
  customer_id                    VARCHAR(50) NOT NULL,
  order_status                   VARCHAR(20) NOT NULL,
  order_purchase_timestamp       TIMESTAMP NOT NULL,
  order_approved_at              TIMESTAMP NULL,
  order_delivered_carrier_date   TIMESTAMP NULL,
  order_delivered_customer_date  TIMESTAMP NULL,
  order_estimated_delivery_date  TIMESTAMP NULL,

  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
  order_id             VARCHAR(50) NOT NULL,
  order_item_id        INT NOT NULL,
  product_id           VARCHAR(50) NOT NULL,
  seller_id            VARCHAR(50) NOT NULL,
  shipping_limit_date  TIMESTAMP,
  price                NUMERIC NOT NULL,
  freight_value        NUMERIC NOT NULL,

  CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id),

  CONSTRAINT fk_items_order  FOREIGN KEY (order_id)  REFERENCES orders(order_id),
  CONSTRAINT fk_items_prod   FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_items_seller FOREIGN KEY (seller_id)  REFERENCES sellers(seller_id)
);
CREATE TABLE geolocation (
  geo_id                   BIGSERIAL PRIMARY KEY,
  geolocation_zip_code_prefix  VARCHAR(100) NOT NULL,
  geolocation_lat          NUMERIC NOT NULL,
  geolocation_lng          NUMERIC NOT NULL,
  geolocation_city         VARCHAR(100) NOT NULL,
  geolocation_state        CHAR(2) NOT NULL
);

CREATE INDEX ix_geolocation_zip ON geolocation(geolocation_zip_code_prefix);