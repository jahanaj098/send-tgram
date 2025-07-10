#!/bin/bash

TELEGRAM_BOT_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="-100xxxxxxxxxx"  # Replace with your actual Chat ID
TMP_DIR="/tmp/tgsend"

mkdir -p "$TMP_DIR"

MAX_SIZE=$((48 * 1024 * 1024))  # 48MB

send_file() {
    local file="$1"
    local name=$(basename "$file")
    local size
    size=$(stat -c%s "$file")

    if [ "$size" -le "$MAX_SIZE" ]; then
        curl -s -F document=@"$file" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" \
            -F chat_id="$TELEGRAM_CHAT_ID" > /dev/null
        echo "✅ $name"
    else
        split -b $MAX_SIZE "$file" "$TMP_DIR/${name}."
        for part in "$TMP_DIR/${name}."*; do
            curl -s -F document=@"$part" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" \
                -F chat_id="$TELEGRAM_CHAT_ID" > /dev/null
            echo "✅ $(basename "$part")"
        done
        rm -f "$TMP_DIR/${name}."*
    fi
}

for path in "$@"; do
    if [ -f "$path" ]; then
        send_file "$path"
    elif [ -d "$path" ]; then
        zip_path="$TMP_DIR/$(basename "$path").zip"
        zip -r -q "$zip_path" "$path"
        send_file "$zip_path"
        rm -f "$zip_path"
    else
        echo "❌ Skipped invalid path: $path"
    fi
done

rm -rf "$TMP_DIR"
