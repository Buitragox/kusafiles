#!/bin/bash

CONNECTION=$(nmcli -t -f CONNECTION,TYPE,STATE d | grep 'wifi:connected' | cut -d: -f1)

nmcli connection down "$CONNECTION"
nmcli connection up "$CONNECTION"
