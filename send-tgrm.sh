#!/bin/bash

TELEGRAM_BOT_TOKEN="tokenhere"
TELEGRAM_CHAT_ID="idhere"
MAX_SIZE_MB=48
PART_SIZE=$((MAX_SIZE_MB * 1024 * 1024))

send_file() {
    local file="$1"
    curl -s -F "chat_id=$TELEGRAM_CHAT_ID" -F document=@"$file" \
        "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" > /dev/null && \
        echo "✅ Sent: $(basename "$file")"
}

handle_large_file() {
    local file="$1"
    split -b $PART_SIZE "$file" "${file}.part_"
    rm "$file"
    for part in ${file}.part_*; do
        send_file "$part"
        rm "$part"
    done
}

main() {
    input="$1"

    if [[ -z "$input" ]]; then
        echo "Usage: $0 <file_or_folder>"
        exit 1
    fi

    if [[ -d "$input" ]]; then
        zip_name="/tmp/$(basename "$input").zip"
        zip -r -q "$zip_name" "$input"
        input="$zip_name"
    fi

    size=$(stat -c %s "$input")
    if (( size > PART_SIZE )); then
        handle_large_file "$input"
    else
        send_file "$input"
    fi
}

main "$@"
