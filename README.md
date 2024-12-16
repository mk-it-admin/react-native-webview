# React Native WebView - a Modern, Cross-Platform WebView for React Native

[![star this repo](http://githubbadges.com/star.svg?user=react-native-webview&repo=react-native-webview&style=flat)](https://github.com/react-native-webview/react-native-webview)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![All Contributors](https://img.shields.io/badge/all_contributors-16-orange.svg?style=flat-square)](#contributors)
[![Known Vulnerabilities](https://snyk.io/test/github/react-native-webview/react-native-webview/badge.svg?style=flat-square)](https://snyk.io/test/github/react-native-webview/react-native-webview)
[![NPM Version](https://img.shields.io/npm/v/react-native-webview.svg?style=flat-square)](https://www.npmjs.com/package/react-native-webview)
[![Lean Core Extracted](https://img.shields.io/badge/Lean%20Core-Extracted-brightgreen.svg?style=flat-square)][lean-core-issue]

NOTE: This is a customized fork of the [react-native-webview](https://github.com/react-native-webview/react-native-webview) library.

To use this fork remove the original react-native-webview dependency from your package.json, then install the forked package as

```jsx
npm install --save @mk-it-admin/react-native-webview
```

## Core Maintainers - Sponsoring companies

_This project is maintained for free by these people using both their free time and their company work time._

- [Thibault Malbranche](https://github.com/Titozzz) ([Twitter @titozzz](https://twitter.com/titozzz)) from [Brigad](https://www.brigad.co/en-gb/about-us)
- [Jamon Holmgren](https://github.com/jamonholmgren) ([Twitter @jamonholmgren](https://twitter.com/jamonholmgren)) from [Infinite Red](https://infinite.red/react-native)
- [Alexander Sklar](https://github.com/asklar) ([Twitter @alexsklar](https://twitter.com/alexsklar)) from [React Native Windows @ Microsoft](https://microsoft.github.io/react-native-windows/)
- [Chiara Mooney](https://github.com/chiaramooney) from [React Native Windows @ Microsoft](https://microsoft.github.io/react-native-windows/)

## Platforms Supported

- [x] iOS
- [x] Android
- [x] macOS
- [x] Windows
- [x] Expo (Android, iOS)

## Getting Started

Read our [Getting Started Guide](docs/Getting-Started.md). If any step seems unclear, please create a detailed issue.

## Usage

Import the `WebView` component from `react-native-webview` and use it like so:

```jsx
import React, { Component } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { WebView } from 'react-native-webview';

// ...
class MyWebComponent extends Component {
  render() {
    return <WebView source={{ uri: 'https://reactnative.dev/' }} />;
  }
}
```

For more, read the [API Reference](./docs/Reference.md) and [Guide](./docs/Guide.md). If you're interested in contributing, check out the [Contributing Guide](./docs/Contributing.md).

## Common issues

- If you're getting `Invariant Violation: Native component for "RNCWebView does not exist"` it likely means you forgot to run `react-native link` or there was some error with the linking process
- If you encounter a build error during the task `:app:mergeDexRelease`, you need to enable multidex support in `android/app/build.gradle` as discussed in [this issue](https://github.com/react-native-webview/react-native-webview/issues/1344#issuecomment-650544648)

## Contributing

See [Contributing.md](https://github.com/react-native-webview/react-native-webview/blob/master/docs/Contributing.md)

## License

MIT

## Translations

This readme is available in:

- [Brazilian portuguese](docs/README.portuguese.md)
- [French](docs/README.french.md)

[lean-core-issue]: https://github.com/facebook/react-native/issues/23313
