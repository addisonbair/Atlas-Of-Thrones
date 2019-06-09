#!/bin/bash
gsutil rsync -d -x '.*\.DS_Store$' -r ./frontend/public gs://atlasofthrones.com
