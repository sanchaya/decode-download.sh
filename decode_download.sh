#!/bin/bash

# Function to decode URL-encoded strings
urldecode() {
  local url="${1//+/ }"
  printf -v decoded '%b' "${url//%/\\x}"
  echo "$decoded"
}

# Function to check if URL is valid
is_valid_url() {
  if curl --output /dev/null --silent --head --fail "$1"; then
    return 0
  else
    return 1
  fi
}

# Specify the input CSV file
input="hin.csv"

# Read the CSV file line by line
while IFS=',' read -r url
do
  # Check if the URL is not empty
  if [ -n "$url" ]; then
    # Decode the URL
    decoded_url=$(urldecode "$url")
    # Check if decoded URL is valid
    if is_valid_url "$decoded_url"; then
      # Use curl to download the file from the decoded URL
      curl -O "$decoded_url"
    elif is_valid_url "$url"; then
      # If decoded URL is not valid, use the original URL
      curl -O "$url"
    else
      echo "Invalid URL: $url"
    fi
  fi
done < "$input"
