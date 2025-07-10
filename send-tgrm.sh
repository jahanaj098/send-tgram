#!/bin/bash

TELEGRAM_BOT_TOKEN="token-here"
TELEGRAM_CHAT_ID="id_here"

if [ -z "$1" ]; then
  echo "Usage: send_to_telegram <file>"
  exit 1
fi

FILE="$1"

RESPONSE=$(curl -s -F "chat_id=$TELEGRAM_CHAT_ID" \
                 -F document=@"$FILE" \
                 "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument")

if echo "$RESPONSE" | grep -q '"ok":true'; then
  echo "✅ $(basename "$FILE") sent"
else
  echo "❌ Failed to send $(basename "$FILE")"
fi
