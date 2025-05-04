// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'webview_screen.dart';
// import 'splash_screen.dart';

// class SplashDecider extends StatefulWidget {
//   const SplashDecider({super.key});

//   @override
//   State<SplashDecider> createState() => _SplashDeciderState();
// }

// class _SplashDeciderState extends State<SplashDecider> {
//   InAppWebViewController? _preloadedController;

//   @override
//   void initState() {
//     super.initState();

//     // After splash duration, navigate
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => WebViewScreen(
//               preloadedController: _preloadedController,
//             ),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // 1) Offstage WebView to preload content
//         Offstage(
//           offstage: true,
//           child: InAppWebView(
//             initialUrlRequest:
//                 URLRequest(url: WebUri('https://saverfavor.com/')),
//             // ignore: deprecated_member_use
//             initialOptions: InAppWebViewGroupOptions(
//               // ignore: deprecated_member_use
//               crossPlatform: InAppWebViewOptions(
//                 javaScriptEnabled: true,
//                 cacheEnabled: true,
//                 clearCache: false,
//               ),
//             ),
//             onWebViewCreated: (controller) {
//               _preloadedController = controller;
//               debugPrint('✅ Preloading WebView during splash');
//             },
//             onLoadStart: (controller, url) => debugPrint('Preload start: $url'),
//             onLoadStop: (controller, url) =>
//                 debugPrint('Preload finished: $url'),
//             onProgressChanged: (controller, progress) =>
//                 debugPrint('Preload progress: $progress'),
//           ),
//         ),

//         // 2) Your existing animated splash screen
//         const SplashScreen(),
//       ],
//     );
//   }
// }

// File: lib/screens/splash_decider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_screen.dart';
import 'splash_screen.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  InAppWebViewController? _preloadedController;
  bool _navigated = false; // <-- flag to prevent multiple navigations

  @override
  void initState() {
    super.initState();

    // Start both preload and navigation logic
    _startPreload();
    _waitForContentOrTimeout();
  }

  void _startPreload() {
    // Offstage WebView to preload content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri('https://saverfavor.com/')),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            cacheEnabled: true,
            clearCache: false,
          ),
        ),
        onWebViewCreated: (controller) {
          _preloadedController = controller;
          debugPrint('✅ Preloading WebView during splash');
        },
        onLoadStart: (controller, url) {
          debugPrint('Preload started: $url');
          _onContentReady(); // <-- navigate when content starts loading
        },
        onLoadStop: (controller, url) => debugPrint('Preload finished: $url'),
        onProgressChanged: (controller, progress) =>
            debugPrint('Preload progress: $progress'),
      );
    });
  }

  void _waitForContentOrTimeout() {
    Future.delayed(const Duration(seconds: 7), () {
      debugPrint('Max splash timeout reached');
      _onContentReady();
    });
  }

  void _onContentReady() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          preloadedController: _preloadedController,
        ),
      ),
    );
    debugPrint('Navigated to WebViewScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        SplashScreen(), // existing animated splash screen
      ],
    );
  }
}
