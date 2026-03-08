CREATE TABLE dim_date (
  date_sk         INT PRIMARY KEY,
  full_date       DATE NOT NULL UNIQUE,

  year            SMALLINT NOT NULL,
  quarter         SMALLINT NOT NULL,
  month           SMALLINT NOT NULL,
  month_name      VARCHAR(20) NOT NULL,
  day_of_month    SMALLINT NOT NULL,
  day_of_week     SMALLINT NOT NULL,        -- 1-7
  day_name        VARCHAR(20) NOT NULL,
  week_of_year    SMALLINT NOT NULL,
  is_weekend      BOOLEAN NOT NULL,
);

CREATE TABLE dim_customer (
  customer_sk           BIGSERIAL PRIMARY KEY,
  customer_id           VARCHAR(50) NOT NULL,
  customer_unique_id    VARCHAR(50) NOT NULL,

  name                  VARCHAR(100),
  gender                CHAR(1),
  age                   INT,
  age_group             VARCHAR(20),      -- derived: npr 18-24, 25-34...
  phone                 VARCHAR(30),

  zip_code_prefix       VARCHAR(50),
  city                  VARCHAR(100),
  state                 CHAR(2),

  date_from             TIMESTAMP NOT NULL DEFAULT now(),
  date_to               TIMESTAMP NULL,
  is_current            BOOLEAN NOT NULL DEFAULT true,
);

CREATE TABLE dim_seller (
  seller_sk             BIGSERIAL PRIMARY KEY,
  seller_id             VARCHAR(50) NOT NULL UNIQUE,

  zip_code_prefix       VARCHAR(50),
  city                  VARCHAR(100),
  state                 CHAR(2),

  date_from             TIMESTAMP NOT NULL DEFAULT now(),
  date_to               TIMESTAMP NULL,
  is_current            BOOLEAN NOT NULL DEFAULT true,
);

CREATE TABLE dim_order (
  order_sk               BIGSERIAL PRIMARY KEY,
  order_id               VARCHAR(50) NOT NULL,

  purchase_date_key      INT NOT NULL REFERENCES dim_date(date_key),
  approved_date_key      INT NULL REFERENCES dim_date(date_key),
  carrier_date_key       INT NULL REFERENCES dim_date(date_key),
  delivered_date_key     INT NULL REFERENCES dim_date(date_key),
  estimated_date_key     INT NULL REFERENCES dim_date(date_key),

  order_status           VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dim_product (
  product_sk            BIGSERIAL PRIMARY KEY,
  product_id            VARCHAR(50) NOT NULL,

  product_category_name VARCHAR(100),
  product_category_name_english VARCHAR(100),
  product_weight_g      NUMERIC,
  product_length_cm     NUMERIC,
  product_height_cm     NUMERIC,
  product_width_cm      NUMERIC,
);

CREATE TABLE fact (
  order_item_sk          BIGSERIAL PRIMARY KEY,

  customer_sk            BIGINT NOT NULL REFERENCES dim_customer(customer_sk),
  product_sk             BIGINT NOT NULL REFERENCES dim_product(product_sk),
  seller_sk              BIGINT NOT NULL REFERENCES dim_seller(seller_sk),
  status_sk              SMALLINT NOT NULL REFERENCES dim_order_status(status_sk),

  price                  NUMERIC NOT NULL,
  price_bucket           VARCHAR(20),               -- derived: 0-50, 50-100...

  freight_value          NUMERIC NOT NULL,
  item_total_value       NUMERIC NOT NULL,          -- derived: price + freight_value

  is_weekend_purchase    BOOLEAN NOT NULL DEFAULT false,
  is_late_delivery       BOOLEAN NOT NULL DEFAULT false,

  CONSTRAINT uq_fact_order_item UNIQUE (order_sk, order_item_id)
);




