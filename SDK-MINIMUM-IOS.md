# IposgoSDK minimum iOS metadata

The checked-in `IposgoSDK.xcframework` was produced with iOS `16.9` as its
deployment target. There is no public iOS 16.9 release, and the framework's
public Swift interface marks `IposgoReader` as available from iOS 15.4.

Run the following command from the repository root to align the checked-in
binary, framework property lists, and generated Swift interfaces with the
sample application's iOS 16.4 deployment target:

```sh
./scripts/set_minimum_ios.sh 16.4
```

The script uses Apple's `vtool` to update `LC_BUILD_VERSION` for every device
and simulator architecture. Editing only `MinimumOSVersion` in the framework
property lists is insufficient because the Mach-O load command is the linker's
source of truth.

This metadata repair makes the public binary consumable by applications whose
deployment target is iOS 16.4. Dejavoo should still rebuild the XCFramework
from its original SDK sources with `IPHONEOS_DEPLOYMENT_TARGET = 16.4` and run
its device test matrix before treating that artifact as a production release.

The root `Package.swift` exposes the repaired XCFramework as an `IposgoSDK`
binary Swift package product so consuming applications can pin an audited
repository revision instead of copying the binary by hand.
