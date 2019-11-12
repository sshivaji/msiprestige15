#!/usr/bin/env python

import os
import sys

EC_IO_FILE="/sys/kernel/debug/ec/ec0/io"

if not os.path.exists(EC_IO_FILE):
        os.system("modprobe ec_sys write_support=1")

def ec_write(addr,value):
    with open(EC_IO_FILE,"rb") as f:
        f.seek(addr)
        old_value=ord(f.read(1))
    if (value != old_value):
        print("                %3d => %3d" % (old_value, value))
        with open(EC_IO_FILE,"wb") as f:
            f.seek(addr)
            f.write(bytearray([value]))
    else:
        print("                     = %3d" % value)

for line in open(sys.argv[1]).readlines():
    print(line.strip())
    if line.startswith(">WEC "):
        addr,value=line.split()[1:3]
        ec_write(int(addr,0), int(value,0))
