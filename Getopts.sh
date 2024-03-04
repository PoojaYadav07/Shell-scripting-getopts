#!/bin/bash

# Default values
component=""
scale=""
view=""
count=""

# Function to print usage information
usage() {
    echo "Usage: $(basename "$0") -c <component> -s <scale> -v <view> -n <count>"
    echo "Options:"
    echo "  -c  Component Name [INGESTOR,JOINER,WRANGLER,VALIDATOR]"
    echo "  -s  Scale [MID,HIGH,LOW]"
    echo "  -v  View [Auction,Bid]"
    echo "  -n  Count (single digit)"
    exit 1
}

# Parse command line options
while getopts "c:s:v:n:" opt; do
    case $opt in
        c)
            component=$OPTARG
            ;;
        s)
            scale=$OPTARG
            ;;
        v)
            view=$OPTARG
            ;;
        n)
            count=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done

# Check if all required options are provided
if [[ -z $component || -z $scale || -z $view || -z $count ]]; then
    echo "Error: Missing required options"
    usage
fi

# Validate input
valid_components="INGESTOR JOINER WRANGLER VALIDATOR"
valid_scales="MID HIGH LOW"
valid_views="Auction Bid"
valid_counts="0 1 2 3 4 5 6 7 8 9"

if ! [[ $valid_components =~ (^| )$component($| ) ]]; then
    echo "Error: Invalid component name"
    usage
fi

if ! [[ $valid_scales =~ (^| )$scale($| ) ]]; then
    echo "Error: Invalid scale"
    usage
fi

if ! [[ $valid_views =~ (^| )$view($| ) ]]; then
    echo "Error: Invalid view"
    usage
fi

if ! [[ $valid_counts =~ (^| )$count($| ) ]]; then
    echo "Error: Invalid count"
    usage
fi

# Replace view with appropriate values
if [ "$view" == "Auction" ]; then
    view="vdopiasample"
elif [ "$view" == "Bid" ]; then
    view="vdopiasample-bid"
fi

# Write to conf file
echo "$view ; $scale ; $component ; ETL ; vdopia-etl= $count" > sig2.conf

echo "Configuration updated successfully."
