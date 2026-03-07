-- CUSTOMERS
CREATE TABLE customers (
  customer_id               VARCHAR2(50)  NOT NULL,
  customer_unique_id        VARCHAR2(50)  NOT NULL,
  customer_zip_code_prefix  VARCHAR2(50)  NOT NULL,
  customer_city             VARCHAR2(100) NOT NULL,
  customer_state            CHAR(2)       NOT NULL,
  name                      VARCHAR2(100) NOT NULL,
  gender                    CHAR(1)       NOT NULL,
  age                       NUMBER(10)    NOT NULL,
  phone                     VARCHAR2(30)  NOT NULL,

  CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

-- SELLERS
CREATE TABLE sellers (
  seller_id              VARCHAR2(50)  NOT NULL,
  seller_zip_code_prefix VARCHAR2(50)  NOT NULL,
  seller_city            VARCHAR2(100) NOT NULL,
  seller_state           CHAR(2)       NOT NULL,

  CONSTRAINT pk_sellers PRIMARY KEY (seller_id)
);

-- PRODUCTS
CREATE TABLE products (
  product_id                 VARCHAR2(50)  NOT NULL,
  product_category_name      VARCHAR2(100),
  product_name_lenght        NUMBER,
  product_description_lenght NUMBER,
  product_photos_qty         NUMBER,
  product_weight_g           NUMBER,
  product_length_cm          NUMBER,
  product_height_cm          NUMBER,
  product_width_cm           NUMBER,

  CONSTRAINT pk_products PRIMARY KEY (product_id),

  CONSTRAINT fk_products_category
    FOREIGN KEY (product_category_name)
    REFERENCES product_translation(product_category_name)
);

-- PRODUCT CATEGORY NAME TRANSLATION
CREATE TABLE product_translation (
  product_category_name         VARCHAR2(50) NOT NULL,
  product_category_name_english VARCHAR2(50) NOT NULL,

  CONSTRAINT pk_prod_cat_trans PRIMARY KEY (product_category_name)
);

-- ORDERS
CREATE TABLE orders (
  order_id                      VARCHAR2(50) NOT NULL,
  customer_id                   VARCHAR2(50) NOT NULL,
  order_status                  VARCHAR2(20) NOT NULL,
  order_purchase_timestamp      TIMESTAMP    NOT NULL,
  order_approved_at             TIMESTAMP    NULL,
  order_delivered_carrier_date  TIMESTAMP    NULL,
  order_delivered_customer_date TIMESTAMP    NULL,
  order_estimated_delivery_date TIMESTAMP    NULL,

  CONSTRAINT pk_orders PRIMARY KEY (order_id),

  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ORDER ITEMS
CREATE TABLE order_items (
  order_id            VARCHAR2(50) NOT NULL,
  order_item_id       NUMBER(10)   NOT NULL,
  product_id          VARCHAR2(50) NOT NULL,
  seller_id           VARCHAR2(50) NOT NULL,
  shipping_limit_date TIMESTAMP    NULL,
  price               NUMBER       NOT NULL,
  freight_value       NUMBER       NOT NULL,

  CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id),

  CONSTRAINT fk_items_order  FOREIGN KEY (order_id)  REFERENCES orders(order_id),
  CONSTRAINT fk_items_prod   FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_items_seller FOREIGN KEY (seller_id)  REFERENCES sellers(seller_id)
);