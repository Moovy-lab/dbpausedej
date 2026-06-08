
CREATE DATABASE IF NOT EXISTS pause_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pause_manager;


CREATE TABLE clients (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255)        NOT NULL,
    contact     VARCHAR(255)        NOT NULL,
    email       VARCHAR(255)        NOT NULL,
    contract    VARCHAR(255)        NOT NULL,
    created_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(100)        NOT NULL,
    last_name   VARCHAR(100)        NOT NULL,
    email       VARCHAR(255)        NOT NULL UNIQUE,
    password    VARCHAR(255)        NOT NULL,
    role        ENUM('admin','user','client') NOT NULL DEFAULT 'user',
    client_id   INT UNSIGNED        NULL,
    created_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_users_client
        FOREIGN KEY (client_id) REFERENCES clients(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE contract_details (
    id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    client_id    INT UNSIGNED        NOT NULL,
    service_type ENUM('pauseCafe','pauseDejeuner','locationSalle','pauseCafeRenforce','cocktail') NOT NULL,
    quantity     INT UNSIGNED        NOT NULL DEFAULT 0,
    unit_price   DECIMAL(10,2)       NOT NULL DEFAULT 0.00,
    created_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_contract_client
        FOREIGN KEY (client_id) REFERENCES clients(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT uq_contract_client_service
        UNIQUE (client_id, service_type)
);

CREATE TABLE services (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255)        NOT NULL,
    category    ENUM('pauseCafe','pauseDejeuner','locationSalle','pauseCafeRenforce','cocktail') NOT NULL,
    price       DECIMAL(10,2)       NOT NULL,
    unit        VARCHAR(100)        NOT NULL,
    description TEXT                NULL,
    badge       VARCHAR(100)        NULL,
    status      ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE orders (
    id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    client_id    INT UNSIGNED        NOT NULL,
    service_type ENUM('pauseCafe','pauseDejeuner','locationSalle','pauseCafeRenforce','cocktail') NOT NULL,
    quantity     INT UNSIGNED        NOT NULL,
    unit_price   DECIMAL(10,2)       NOT NULL,   
    date         DATE                NOT NULL,
    created_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id) REFERENCES clients(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_orders_client_type ON orders (client_id, service_type);
CREATE INDEX idx_orders_date        ON orders (date);
CREATE INDEX idx_users_email        ON users  (email);
CREATE INDEX idx_users_client       ON users  (client_id);
