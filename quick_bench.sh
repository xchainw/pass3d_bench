#!/bin/bash

curl -sLO https://github.com/xchainw/pass3d_bench/releases/download/initial/objs.tar.gz
curl -sLO https://github.com/xchainw/pass3d_bench/releases/download/initial/pass3d.tar.gz
curl -sLO https://github.com/xchainw/pass3d_bench/raw/main/pass3d_bench.sh
tar zxvf objs.tar.gz && tar zxvf pass3d.tar.gz
bash pass3d_bench.sh