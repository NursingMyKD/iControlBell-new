#!/bin/bash

# iControlBell Icon Verification Script
# Verifies that all required app icons are present and correctly sized

echo "🎨 iControlBell App Icon Verification"
echo "======================================"

ICON_DIR="/workspaces/iControlBell-new/Assets.xcassets/AppIcon.appiconset"

# Required icon files with their expected dimensions
declare -A REQUIRED_ICONS=(
    ["AppIcon-1024.png"]="1024x1024"
    ["AppIcon-20.png"]="20x20"
    ["AppIcon-20@2x.png"]="40x40"
    ["AppIcon-20@3x.png"]="60x60"
    ["AppIcon-29.png"]="29x29"
    ["AppIcon-29@2x.png"]="58x58"
    ["AppIcon-29@3x.png"]="87x87"
    ["AppIcon-40.png"]="40x40"
    ["AppIcon-40@2x.png"]="80x80"
    ["AppIcon-40@3x.png"]="120x120"
    ["AppIcon-60@2x.png"]="120x120"
    ["AppIcon-60@3x.png"]="180x180"
    ["AppIcon-76.png"]="76x76"
    ["AppIcon-76@2x.png"]="152x152"
    ["AppIcon-83.5@2x.png"]="167x167"
)

echo "📁 Checking directory: $ICON_DIR"
echo ""

# Count files
TOTAL_REQUIRED=15
FOUND_COUNT=0
MISSING_FILES=()
INCORRECT_SIZE=()

echo "📋 Icon File Status:"
echo "===================="

for icon_file in "${!REQUIRED_ICONS[@]}"; do
    EXPECTED_SIZE="${REQUIRED_ICONS[$icon_file]}"
    FULL_PATH="$ICON_DIR/$icon_file"
    
    if [ -f "$FULL_PATH" ]; then
        # Check if we have imagemagick to verify dimensions
        if command -v identify &> /dev/null; then
            ACTUAL_SIZE=$(identify "$FULL_PATH" 2>/dev/null | awk '{print $3}' | head -1)
            if [ "$ACTUAL_SIZE" = "$EXPECTED_SIZE" ]; then
                echo "✅ $icon_file ($ACTUAL_SIZE)"
                ((FOUND_COUNT++))
            else
                echo "⚠️  $icon_file (Expected: $EXPECTED_SIZE, Found: $ACTUAL_SIZE)"
                INCORRECT_SIZE+=("$icon_file")
                ((FOUND_COUNT++))
            fi
        else
            echo "✅ $icon_file (present - cannot verify size without imagemagick)"
            ((FOUND_COUNT++))
        fi
    else
        echo "❌ $icon_file (missing)"
        MISSING_FILES+=("$icon_file")
    fi
done

echo ""
echo "📊 Summary:"
echo "==========="
echo "Found: $FOUND_COUNT/$TOTAL_REQUIRED icons"

if [ $FOUND_COUNT -eq $TOTAL_REQUIRED ]; then
    echo "🎉 SUCCESS: All required icons are present!"
    
    if [ ${#INCORRECT_SIZE[@]} -eq 0 ]; then
        echo "✅ All icons have correct dimensions!"
        echo ""
        echo "🚀 Your app is ready for App Store submission (icon-wise)!"
        echo "📱 Next step: Build and test in Xcode"
    else
        echo "⚠️  Some icons have incorrect dimensions:"
        printf '%s\n' "${INCORRECT_SIZE[@]}"
    fi
else
    echo "❌ Missing ${#MISSING_FILES[@]} icons:"
    printf '%s\n' "${MISSING_FILES[@]}"
    echo ""
    echo "📋 Instructions:"
    echo "1. Copy your appicon.appiconset files to:"
    echo "   $ICON_DIR/"
    echo "2. Run this script again to verify"
fi

echo ""
echo "📁 Current files in AppIcon.appiconset:"
ls -la "$ICON_DIR"
