#!/usr/bin/env bash

set -euo pipefail

minimum_ios_version="${1:-16.4}"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
xcframework="$repo_root/IceCream/IposgoSDK.xcframework"
device_framework="$xcframework/ios-arm64/IposgoSDK.framework"
simulator_framework="$xcframework/ios-arm64_x86_64-simulator/IposgoSDK.framework"

patch_binary() {
  local platform="$1"
  local binary="$2"
  local framework_plist="$3"
  local current_minimum current_sdk sdk_version ld_version temporary

  current_minimum="$(xcrun vtool -show-build "$binary" | awk '$1 == "minos" { print $2; exit }')"
  current_sdk="$(xcrun vtool -show-build "$binary" | awk '$1 == "sdk" { print $2; exit }')"
  sdk_version="$(plutil -extract DTPlatformVersion raw "$framework_plist")"
  ld_version="$(xcrun vtool -show-build "$binary" | awk '$1 == "tool" && $2 == "LD" { getline; print $2; exit }')"

  if [[ "$current_minimum" == "$minimum_ios_version" && "$current_sdk" == "$sdk_version" ]]; then
    return
  fi

  temporary="${binary}.minimum-ios.tmp"
  xcrun vtool \
    -set-build-version "$platform" "$minimum_ios_version" "$sdk_version" \
    -tool ld "$ld_version" \
    -replace \
    -output "$temporary" \
    "$binary"
  chmod +x "$temporary"
  mv "$temporary" "$binary"
}

patch_binary ios "$device_framework/IposgoSDK" "$device_framework/Info.plist"
patch_binary iossim "$simulator_framework/IposgoSDK" "$simulator_framework/Info.plist"

for framework_plist in "$device_framework/Info.plist" "$simulator_framework/Info.plist"; do
  if [[ "$(plutil -extract MinimumOSVersion raw "$framework_plist")" != "$minimum_ios_version" ]]; then
    plutil -replace MinimumOSVersion -string "$minimum_ios_version" "$framework_plist"
  fi
done

# The interface target is part of the distributable module metadata and must
# agree with the framework binary. This replacement is intentionally limited
# to the generated swift-module-flags header.
find "$xcframework" -name '*.swiftinterface' -print0 | while IFS= read -r -d '' interface; do
  current_interface_minimum="$(sed -nE \
    's/.*swift-module-flags: -target [^ ]*-apple-ios([0-9]+(\.[0-9]+)*).*/\1/p' \
    "$interface")"
  if [[ "$current_interface_minimum" != "$minimum_ios_version" ]]; then
    sed -i '' -E \
      "s/(swift-module-flags: -target [^ ]*-apple-ios)[0-9]+(\\.[0-9]+)*/\\1${minimum_ios_version}/" \
      "$interface"
  fi
done

# The checked-in simulator framework is ad-hoc signed. Refresh its signature
# only when the executable or sealed Info.plist resource changed, keeping
# repeat runs deterministic.
if ! codesign --verify --deep --strict "$simulator_framework" 2>/dev/null; then
  codesign --force --sign - "$simulator_framework"
fi

echo "Updated IposgoSDK minimum iOS metadata to $minimum_ios_version"
xcrun vtool -show-build "$device_framework/IposgoSDK"
xcrun vtool -show-build "$simulator_framework/IposgoSDK"
