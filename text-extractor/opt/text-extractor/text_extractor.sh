#!/bin/bash
# Temporary files for the screenshot and OCR output.
tmp_img=$(mktemp /tmp/screen-XXXXXX.png)
tmp_txt=$(mktemp /tmp/text-XXXXXX)

# Capture a selected screen area (the -s flag enables interactive selection).
maim -s "$tmp_img"

# Check if an image was captured.
if [ ! -s "$tmp_img" ]; then
    notify-send "Text Extractor" "No screenshot taken."
    exit 1
fi

# Run Tesseract OCR on the captured image.
# Tesseract outputs text to a file named <tmp_txt>.txt.
tesseract "$tmp_img" "$tmp_txt" > /dev/null 2>&1

# Define the OCR output file.
ocr_output="${tmp_txt}.txt"

# If OCR was successful, copy the text to the clipboard.
if [ -f "$ocr_output" ]; then
    xclip -selection clipboard < "$ocr_output"
    notify-send "Text Extractor" "Extracted text copied to clipboard."
else
    notify-send "Text Extractor" "OCR failed."
fi

# Clean up temporary files.
rm -f "$tmp_img" "$ocr_output"
