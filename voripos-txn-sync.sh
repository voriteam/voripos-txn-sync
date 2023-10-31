#!/bin/bash

# This is needed to locate the litestream executable
export PATH="/opt/homebrew/bin:$PATH"

# Source
export VORIPOS_DATA_DIR="~/Library/Containers/com.vori.VoriPOS/Data/Library/Application Support"
export VORIPOS_TXN_DB_PATH=$VORIPOS_DATA_DIR/Transaction.sqlite3

# Sink
export VORIPOS_TXN_DB_BUCKET=$(defaults read com.vori.VoriPOS provisioned_txnDbBucket)
export VORIPOS_STORE_ID=$(defaults read com.vori.VoriPOS provisioned_storeID)
export VORIPOS_LANE_ID=$(defaults read com.vori.VoriPOS provisioned_laneID)
export GOOGLE_APPLICATION_CREDENTIALS=$(defaults read com.vori.VoriPOS provisioned_txnKeyPath)
export VORIPOS_TXN_DB_BUCKET_PATH=$VORIPOS_TXN_DB_BUCKET/stores/$VORIPOS_STORE_ID/lanes/$VORIPOS_LANE_ID/transactional-data

echo "Starting replication for Store ${VORIPOS_STORE_ID}, Lane ${VORIPOS_LANE_ID}"
echo "Data written to ${VORIPOS_TXN_DB_PATH} will be replicated to ${VORIPOS_TXN_DB_BUCKET_PATH}"
litestream replicate -config $( dirname -- "$0"; )/etc/litestream.yml
