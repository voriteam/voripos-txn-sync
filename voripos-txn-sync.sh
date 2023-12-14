#!/bin/bash

# This is needed to locate the litestream executable
export PATH="/opt/homebrew/bin:$PATH"

# Source
VORIPOS_DATA_DIR="${HOME}/Library/Containers/com.vori.VoriPOS/Data/Library/Application Support"
export VORIPOS_TXN_DB_PATH=$VORIPOS_DATA_DIR/Transaction.sqlite3

# Sink
VORIPOS_LITESTREAM_TYPE=
VORIPOS_LITESTREAM_ENDPOINT=
VORIPOS_LITESTREAM_REGION=
VORIPOS_LITESTREAM_BUCKET=
VORIPOS_LITESTREAM_PATH=
VORIPOS_LITESTREAM_ACCESS_KEY_ID=
VORIPOS_LITESTREAM_SECRET_ACCESS_KEY=

credentialsPath="$HOME/voripos/.credentials.json"
if test -f "$credentialsPath"; then
  echo "Reading from ${credentialsPath}..."
  content=$(cat "${credentialsPath}")
  VORIPOS_STORE_ID=$( jq -r  '.metadata.store.id | select( . != null )' <<< "${content}" )
  VORIPOS_LANE_ID=$( jq -r  '.metadata.lane.id | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_TYPE=$( jq -r  '.litestream_config.type | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_ENDPOINT=$( jq -r  '.litestream_config.endpoint | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_REGION=$( jq -r  '.litestream_config.region | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_BUCKET=$( jq -r  '.litestream_config.bucket | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_PATH=$( jq -r  '.litestream_config.path | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_ACCESS_KEY_ID=$( jq -r  '.oidc.client_id | select( . != null )' <<< "${content}" )
  VORIPOS_LITESTREAM_SECRET_ACCESS_KEY=$( jq -r  '.oidc.client_secret | select( . != null )' <<< "${content}" )
else
  echo "Reading from UserDefaults..."
  VORIPOS_STORE_ID=$(defaults read com.vori.VoriPOS provisioned_storeID)
  VORIPOS_LANE_ID=$(defaults read com.vori.VoriPOS provisioned_laneID)
  VORIPOS_LITESTREAM_TYPE=$(defaults read com.vori.VoriPOS provisioned_litestreamType)
  VORIPOS_LITESTREAM_ENDPOINT=$(defaults read com.vori.VoriPOS provisioned_litestreamEndpoint)
  VORIPOS_LITESTREAM_REGION=$(defaults read com.vori.VoriPOS provisioned_litestreamRegion)
  VORIPOS_LITESTREAM_BUCKET=$(defaults read com.vori.VoriPOS provisioned_litestreamBucket)
  VORIPOS_LITESTREAM_PATH=$(defaults read com.vori.VoriPOS provisioned_litestreamPath)
  VORIPOS_LITESTREAM_ACCESS_KEY_ID=$(defaults read com.vori.VoriPOS provisioned_oidcClientID)
  VORIPOS_LITESTREAM_SECRET_ACCESS_KEY=$(defaults read com.vori.VoriPOS provisioned_oidcClientSecret)
fi

export VORIPOS_STORE_ID
export VORIPOS_LANE_ID
export VORIPOS_LITESTREAM_TYPE
export VORIPOS_LITESTREAM_ENDPOINT
export VORIPOS_LITESTREAM_REGION
export VORIPOS_LITESTREAM_BUCKET
export VORIPOS_LITESTREAM_PATH
export VORIPOS_LITESTREAM_ACCESS_KEY_ID
export VORIPOS_LITESTREAM_SECRET_ACCESS_KEY


echo "Starting replication for Store ${VORIPOS_STORE_ID}, Lane ${VORIPOS_LANE_ID}"
echo "Data written to ${VORIPOS_TXN_DB_PATH} will be replicated to ${VORIPOS_LITESTREAM_TYPE} endpoint ${VORIPOS_LITESTREAM_ENDPOINT}, bucket ${VORIPOS_LITESTREAM_BUCKET}, path ${VORIPOS_LITESTREAM_PATH}"
litestream replicate -config "$( dirname -- "$0"; )/etc/litestream.yml"
