## 1.0.0
### Updated

- **Dart SDK** updated to `3.8.1` to support latest language improvements and toolchain stability.
- **Flutter SDK** updated to `3.32.8`.
- Updated package dependencies in `pubspec.yaml` to latest compatible versions

### Added
- `onError` callback for handling Payfast-related errors:

#### Example Usage
```dart
PayFast(
    ...
    onError: (errorMessage) {
        print('Payfast Error: $errorMessage');
    },
);

## 0.0.2+1

### Added
- Introduced `RouteGenerator` class to manage route URL generation with optional hash routing.

## 0.0.2

* Rename PayFastWeb to PayFast
* Minor bug fixes

## 0.0.1

* Initial release.
