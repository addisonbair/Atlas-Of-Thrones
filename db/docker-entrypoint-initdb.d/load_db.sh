#!/bin/sh

set -e

wget https://cdn.patricktriest.com/atlas-of-thrones/atlas_of_thrones.sql -O /tmp/atlas_of_thrones.sql
psql -U $POSTGRES_USER atlas_of_thrones < /tmp/atlas_of_thrones.sql