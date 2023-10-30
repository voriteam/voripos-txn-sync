# VoriPOS Transaction Sync

Transactional data (e.g., orders, refunds) is data created on the POS and pushed to Vori for ingestion. We use
[Litestream](https://litestream.io/) to replicate the local SQLite database to Google Cloud Storage. Data is pushed 
every second.

Litestream requires access to the file system, specifically the directory where the VoriPOS app stores its transactional 
database, so must be run directly on the POS machine. This database currently resides at the location below:

> ~/Library/Containers/com.vori.VoriPOS/Data/Library/Application Support/Transaction.sqlite3

Given this directory/data belongs to another application, Litestream should be granted access to data from other apps.

## Installation
This service is distributed via Homebrew.

```shell
brew tap voriteam/voripos
brew install voripos-txn-sync
brew services start voripos-txn-sync.sh
```

## Distribution 
The POS machines run a service installed via Homebrew. Create a release on GitHub, and follow the instructions at
https://github.com/voriteam/homebrew-voripos to update the tap with the latest version.
