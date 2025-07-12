#!/bin/bash

# Script to update all localization files with Rauland keys
# Run from the Resources directory

# Essential Rauland keys to add to all language files
RAULAND_KEYS='
// MARK: - Rauland Responder 5 Integration
"rauland_connection_title" = "Responder 5 Connection";
"rauland_status_disconnected" = "Disconnected";
"rauland_status_connecting" = "Connecting";
"rauland_status_connected" = "Connected";
"rauland_connect" = "Connect";
"rauland_disconnect" = "Disconnect";
"rauland_configured" = "Rauland system configured";
"rauland_not_connected" = "Not connected to Rauland system";
"rauland_connection_successful" = "Connected to Rauland system";
"rauland_disconnected" = "Disconnected from Rauland system";
"rauland_call_emergency" = "Emergency";
"rauland_call_nurse" = "Nurse Call";
"rauland_call_general" = "General Assistance";
"rauland_error_network" = "Network unavailable. Please check internet connection.";
"rauland_error_call_failed" = "Call request failed. Please try again.";
"rauland_configuration_title" = "Rauland Configuration";
"double_tap_to_open_settings" = "Double tap to open settings";'

# Languages to update (skip en and es as they're already done)
LANGUAGES=("fr" "de" "pt" "it" "ja" "zh" "ru" "nl" "ar" "ko" "hi")

for lang in "${LANGUAGES[@]}"; do
    if [ -f "${lang}.lproj/Localizable.strings" ]; then
        echo "Updating ${lang}.lproj/Localizable.strings..."
        
        # Add Rauland keys to the end of the file
        echo "$RAULAND_KEYS" >> "${lang}.lproj/Localizable.strings"
        
        echo "Updated ${lang} localization file"
    else
        echo "Warning: ${lang}.lproj/Localizable.strings not found"
    fi
done

echo "Batch update completed for all language files"
