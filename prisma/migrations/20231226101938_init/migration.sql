-- CreateTable
CREATE TABLE "address_book" (
    "id" SERIAL NOT NULL,
    "address" VARCHAR NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "device_id" VARCHAR,

    CONSTRAINT "address_book_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "block" (
    "name" VARCHAR NOT NULL,
    "processed_block" INTEGER,

    CONSTRAINT "block_pkey" PRIMARY KEY ("name")
);

-- CreateTable
CREATE TABLE "device" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pubkey" VARCHAR NOT NULL,
    "device_id" VARCHAR NOT NULL,

    CONSTRAINT "device_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "normal_wallet" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" VARCHAR NOT NULL,
    "address" VARCHAR NOT NULL,

    CONSTRAINT "normal_wallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plugin_managers" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "manager_name" VARCHAR NOT NULL,

    CONSTRAINT "plugin_managers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plugins" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" VARCHAR NOT NULL,
    "description" TEXT NOT NULL,
    "version" VARCHAR NOT NULL,
    "contract_address" VARCHAR NOT NULL,
    "admin_address" VARCHAR NOT NULL,

    CONSTRAINT "plugins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plugins_registration" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "smart_wallet_id" INTEGER NOT NULL,
    "plugin_id" INTEGER NOT NULL,

    CONSTRAINT "plugins_registration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recovery_account" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" VARCHAR,
    "wallet_address" VARCHAR NOT NULL,
    "recover_wallet" VARCHAR,

    CONSTRAINT "recovery_account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "smart_wallet" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" VARCHAR,
    "address" VARCHAR NOT NULL,
    "contract_info" JSONB NOT NULL,
    "pubkey" VARCHAR,

    CONSTRAINT "smart_wallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BlockCheckpoint" (
    "id" SERIAL NOT NULL,
    "height" INTEGER NOT NULL,
    "job_name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BlockCheckpoint_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "normal_wallet_address_key" ON "normal_wallet"("address");

-- CreateIndex
CREATE UNIQUE INDEX "smart_wallet_address_key" ON "smart_wallet"("address");
