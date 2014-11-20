#!/bin/bash
if [ "`ps ax | grep -v grep | grep -c 'spamcop.pl'`" -eq 0 ]; then
  cd /your/spamcop/path && ./spamcop.pl >> spamcop_log 2>&1
else
  echo "!! Spamcop.pl is already active" >> spamcop_log 2>&1
fi
