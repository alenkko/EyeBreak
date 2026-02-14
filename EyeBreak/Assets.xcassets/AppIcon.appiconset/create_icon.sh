#!/bin/bash

# Create a simple icon using SF Symbols
# Generate different sizes needed for macOS app icon

sizes=(16 32 64 128 256 512 1024)

for size in "${sizes[@]}"; do
    # Use sips to create placeholder images
    # We'll use SF Symbols to create proper icons
    sf symbols --export "eye.fill" --size $size --output "icon_${size}.png" 2>/dev/null || true
done

echo "Icon generation attempted. If sf symbols command not found, use manual method."
