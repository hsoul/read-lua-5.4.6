#!/bin/bash

./luac $1
xxd -p luac.out > $1.out
# ./lua tools/protodump/build_proto.lua $1.out > code_dump.lua
./lua tools/protodump/build_proto.lua $1.out
rm luac.out
rm $1.out
