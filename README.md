# send-tgram
A simple bash script to send files or folders to a Telegram chat using a bot.

## Features
- Send any file or folder directly from the terminal
- Automatically zips folders
- Splits files if size > 48MB (Telegram upload limit)
- Sends file name only (no verbose output)

## Usage
Place the script in `/usr/local/bin/tgsend`, then run:  
dont forgot to add permission to the script `chmod +x tgsend`
```bash
tgsend myfile.txt  
tgsend myfolder/
