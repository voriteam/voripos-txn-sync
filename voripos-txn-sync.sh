#!/bin/bash

# This is needed to locate the litestream executable
export PATH="/opt/homebrew/bin:$PATH"

# Source
VORIPOS_DATA_DIR="${HOME}/Library/Containers/com.vori.VoriPOS/Data/Library/Application Support"
export VORIPOS_TXN_DB_PATH=$VORIPOS_DATA_DIR/Transaction.sqlite3

# Sink
VORIPOS_LITESTREAM_TYPE=$(defaults read com.vori.VoriPOS provisioned_litestreamType)
VORIPOS_LITESTREAM_ENDPOINT=$(defaults read com.vori.VoriPOS provisioned_litestreamEndpoint)
VORIPOS_LITESTREAM_REGION=$(defaults read com.vori.VoriPOS provisioned_litestreamRegion)
VORIPOS_LITESTREAM_BUCKET=$(defaults read com.vori.VoriPOS provisioned_litestreamBucket)
VORIPOS_LITESTREAM_PATH=$(defaults read com.vori.VoriPOS provisioned_litestreamPath)
VORIPOS_LITESTREAM_ACCESS_KEY_ID=$(defaults read com.vori.VoriPOS provisioned_oidcClientID)
VORIPOS_LITESTREAM_SECRET_ACCESS_KEY=$(defaults read com.vori.VoriPOS provisioned_oidcClientSecret)
export VORIPOS_LITESTREAM_TYPE
export VORIPOS_LITESTREAM_ENDPOINT
export VORIPOS_LITESTREAM_REGION
export VORIPOS_LITESTREAM_BUCKET
export VORIPOS_LITESTREAM_PATH
export VORIPOS_LITESTREAM_ACCESS_KEY_ID
export VORIPOS_LITESTREAM_SECRET_ACCESS_KEY

VORIPOS_STORE_ID=$(defaults read com.vori.VoriPOS provisioned_storeID)
VORIPOS_LANE_ID=$(defaults read com.vori.VoriPOS provisioned_laneID)
export VORIPOS_STORE_ID
export VORIPOS_LANE_ID

echo "Starting replication for Store ${VORIPOS_STORE_ID}, Lane ${VORIPOS_LANE_ID}"
echo "Data written to ${VORIPOS_TXN_DB_PATH} will be replicated to ${VORIPOS_LITESTREAM_TYPE} endpoint ${VORIPOS_LITESTREAM_ENDPOINT}, bucket ${VORIPOS_LITESTREAM_BUCKET}, path ${VORIPOS_LITESTREAM_PATH}"
litestream replicate -config "$( dirname -- "$0"; )/etc/litestream.yml"
