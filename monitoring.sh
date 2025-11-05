#!/bin/bash
while true; do
  PROC=test
  pgrep -a $PROC > /dev/null
  if [ $? -eq 0 ]; then
    HTTP_STATUS=$(curl --connect-timeout 3 -s -o /dev/null -w "%{http_code}" https://test.com/monitoring/test/api)
    if [[ "$HTTP_STATUS" != 200 ]]; then
      echo "$(date) : monitoring is not available" >> /var/log/monitoring.log
    fi
    ETIME=$(ps --no-headers -o etimes $(pgrep $PROC))
    if [[ "$ETIME" -le 60 ]]; then
      echo "$(date) : proces $PROC restart" >> /var/log/monitoring.log
    fi
  fi
  echo ====== >> /var/log/monitoring.log
  sleep 60
done
