#!/bin/bash

# iControlBell App Icon Setup Script
# This script helps set up the app icon structure after you provide the 1024x1024 master icon

echo "🎨 iControlBell App Icon Setup"
echo "================================"

ICON_DIR="/workspaces/iControlBell-new/Assets.xcassets/AppIcon.appiconset"

echo "📁 Icon directory: $ICON_DIR"
echo ""

# Check if directory exists
if [ ! -d "$ICON_DIR" ]; then
    echo "❌ Error: Icon directory not found!"
    exit 1
fi

# List current files
echo "📋 Current files in AppIcon.appiconset:"
ls -la "$ICON_DIR"
echo ""

# Check for master 1024x1024 icon
if [ -f "$ICON_DIR/AppIcon-1024.png" ]; then
    echo "✅ Master icon found: AppIcon-1024.png"
    
    # Check dimensions
    if command -v identify &> /dev/null; then
        DIMENSIONS=$(identify "$ICON_DIR/AppIcon-1024.png" | awk '{print $3}')
        echo "📐 Dimensions: $DIMENSIONS"
        
        if [ "$DIMENSIONS" = "1024x1024" ]; then
            echo "✅ Dimensions are correct!"
        else
            echo "⚠️  Warning: Icon should be 1024x1024, found: $DIMENSIONS"
        fi
    fi
else
    echo "📋 Master icon needed: AppIcon-1024.png (1024×1024 pixels)"
    echo ""
    echo "🎯 Next steps:"
    echo "1. Save your blue bell+phone icon as 1024×1024 PNG"
    echo "2. Name it 'AppIcon-1024.png'"
    echo "3. Copy to: $ICON_DIR/"
    echo "4. Use appicon.co to generate all other sizes"
fi

echo ""
echo "📱 Required icon sizes for App Store:"
echo "- AppIcon-1024.png (1024×1024) - App Store Marketing"
echo "- AppIcon-60@3x.png (180×180) - iPhone App Icon"
echo "- AppIcon-76@2x.png (152×152) - iPad App Icon"
echo "- AppIcon-40@3x.png (120×120) - iPhone Spotlight"
echo "- And 14 other sizes for various UI contexts"

echo ""
echo "🔗 Icon Generator Tool: https://appicon.co"
echo "   Upload your 1024px master → Download iOS set → Extract to AppIcon.appiconset/"

echo ""
echo "✅ Contents.json is already updated and ready for all icon sizes!"
