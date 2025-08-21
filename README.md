# React Native WebView

![star this repo](https://img.shields.io/github/stars/react-native-webview/react-native-webview?style=flat-square)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![NPM Version](https://img.shields.io/npm/v/react-native-webview.svg?style=flat-square)](https://www.npmjs.com/package/react-native-webview)
![Npm Downloads](https://img.shields.io/npm/dm/react-native-webview.svg)

NOTE: This is a customized fork of the [react-native-webview](https://github.com/react-native-webview/react-native-webview) library.

To use this fork remove the original react-native-webview dependency from your package.json, then install the forked package as

```jsx
npm install --save https://github.com/mk-it-admin/react-native-webview.git#mk2fa_v13150
```


### Platform compatibility

This project is compatible with **iOS**,  **Android**, **Windows** and **macOS**.  
This project supports both **the old** (paper) **and the new architecture** (fabric).  
This project is compatible with [expo](https://docs.expo.dev/versions/latest/sdk/webview/).

### Getting Started

Read our [Getting Started Guide](docs/Getting-Started.md). If any step seems unclear, please create a pull request.

### Versioning

This project follows [semantic versioning](https://semver.org/). We do not hesitate to release breaking changes but they will be in a major version.

### Usage

Import the `WebView` component from `react-native-webview` and use it like so:

```tsx
import React, { Component } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { WebView } from 'react-native-webview';

// ...
const MyWebComponent = () => {
  return <WebView source={{ uri: 'https://reactnative.dev/' }} style={{ flex: 1 }} />;
}
```

For more, read the [API Reference](./docs/Reference.md) and [Guide](./docs/Guide.md). If you're interested in contributing, check out the [Contributing Guide](./docs/Contributing.md).

### Common issues

- If you're getting `Invariant Violation: Native component for "RNCWebView does not exist"` it likely means you forgot to run `react-native link` or there was some error with the linking process
- If you encounter a build error during the task `:app:mergeDexRelease`, you need to enable multidex support in `android/app/build.gradle` as discussed in [this issue](https://github.com/react-native-webview/react-native-webview/issues/1344#issuecomment-650544648)


### License

MIT

