#!/bin/bash
set -e

echo "🚀 Installing Flutter..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter
export PATH="/opt/flutter/bin:$PATH"

# Verify
flutter --version
flutter config --enable-web

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building web..."
flutter build web --release

echo "✅ Build complete!"
