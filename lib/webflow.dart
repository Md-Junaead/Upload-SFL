// // main.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// // ----------------------------------------
// // Firebase Options (replace with real values)
// // ----------------------------------------
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     return const FirebaseOptions(
//       apiKey: 'YOUR_API_KEY',
//       appId: 'YOUR_APP_ID',
//       messagingSenderId: 'YOUR_SENDER_ID',
//       projectId: 'YOUR_PROJECT_ID',
//     );
//   }
// }

// // ----------------------------------------
// // Background Message Handler
// // ----------------------------------------
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   debugPrint('Handling a background message: \${message.messageId}');
// }

// // ----------------------------------------
// // Notification Service
// // ----------------------------------------
// class NotificationService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;

//   static Future<void> initialize() async {
//     await FirebaseMessaging.instance.requestPermission();

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint(
//         'Received push notification (foreground): \${message.notification?.title}',
//       );
//     });

//     // Handle notification tapped when app is in background or terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('Notification opened: \${message.data}');
//       final String? url = message.data['url'];
//       if (url != null && url.isNotEmpty) {
//         WebViewNavigator.openUrl(url);
//       }
//     });

//     String? token = await _firebaseMessaging.getToken();
//     debugPrint('Firebase Messaging Token: \$token');
//   }
// }

// // ----------------------------------------
// // WebView Navigator for deep linking
// // ----------------------------------------
// class WebViewNavigator {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static void openUrl(String url) {
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(builder: (_) => WebViewScreen(initialUrl: url)),
//     );
//   }
// }

// // ----------------------------------------
// // MVVM: ViewModel for WebView
// // ----------------------------------------
// class WebViewViewModel extends ChangeNotifier {
//   late InAppWebViewController _webViewController;
//   bool isLoading = true;
//   bool hasError = false;
//   String errorMessage = '';
//   double progress = 0;

//   void setWebViewController(InAppWebViewController controller) {
//     _webViewController = controller;
//     debugPrint('WebViewController initialized');
//   }

//   void onPageStarted() {
//     isLoading = true;
//     hasError = false;
//     notifyListeners();
//     debugPrint('Page started loading');
//   }

//   void onPageFinished() {
//     isLoading = false;
//     notifyListeners();
//     debugPrint('Page finished loading');
//   }

//   void onWebResourceError(WebResourceError error) {
//     isLoading = false;
//     hasError = true;
//     errorMessage = error.description;
//     notifyListeners();
//     debugPrint('Web resource error: \$errorMessage');
//   }

//   void onProgressChanged(int value) {
//     progress = value / 100;
//     notifyListeners();
//   }

//   Future<void> reloadWebView() async {
//     await _webViewController.reload();
//     onPageStarted();
//   }

//   Future<bool> handleBackButton() async {
//     if (await _webViewController.canGoBack()) {
//       await _webViewController.goBack();
//       debugPrint('Navigated back in WebView history');
//       return false; // Do not exit app
//     }
//     return true; // Exit app
//   }
// }

// // ----------------------------------------
// // Animated Splash Screen
// // ----------------------------------------
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _animation,
//         child: Center(child: Image.asset('assets/logo.png', height: 150)),
//       ),
//     );
//   }
// }

// // ----------------------------------------
// // SplashDecider
// // ----------------------------------------
// class SplashDecider extends StatefulWidget {
//   const SplashDecider({Key? key}) : super(key: key);

//   @override
//   State<SplashDecider> createState() => _SplashDeciderState();
// }

// class _SplashDeciderState extends State<SplashDecider> {
//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 3));
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const WebViewScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SplashScreen();
//   }
// }

// // ----------------------------------------
// // WebView Screen (View)
// // ----------------------------------------
// class WebViewScreen extends StatefulWidget {
//   final String? initialUrl;
//   const WebViewScreen({Key? key, this.initialUrl}) : super(key: key);

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final WebViewViewModel viewModel = WebViewViewModel();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('SaverFavor'), centerTitle: true),
//       body: ChangeNotifierProvider<WebViewViewModel>(
//         // Provider for ViewModel
//         create: (_) => viewModel,
//         child: Consumer<WebViewViewModel>(
//           builder:
//               (context, vm, _) => WillPopScope(
//                 onWillPop: vm.handleBackButton,
//                 child: Stack(
//                   children: [
//                     InAppWebView(
//                       initialUrlRequest: URLRequest(
//                         url: Uri.parse(
//                           widget.initialUrl ?? 'https://saverfavor.com/',
//                         ),
//                       ),
//                       initialOptions: InAppWebViewGroupOptions(
//                         crossPlatform: InAppWebViewOptions(
//                           javaScriptEnabled: true,
//                           cacheEnabled: true,
//                           useOnLoadResource: true,
//                           clearCache: false,
//                         ),
//                       ),
//                       onWebViewCreated: viewModel.setWebViewController,
//                       onLoadStart: (controller, _) => viewModel.onPageStarted(),
//                       onLoadStop: (controller, _) => viewModel.onPageFinished(),
//                       onLoadError:
//                           (controller, _, code, message) =>
//                               viewModel.onWebResourceError(
//                                 WebResourceError(
//                                   description: message,
//                                   errorCode: code,
//                                   domain: '',
//                                   errorType: WebResourceErrorType.OTHER,
//                                   isForMainFrame: true,
//                                 ),
//                               ),
//                       onProgressChanged:
//                           (controller, progress) =>
//                               viewModel.onProgressChanged(progress),
//                     ),
//                     // Top loading progress bar
//                     if (vm.progress < 1.0)
//                       LinearProgressIndicator(value: vm.progress, minHeight: 3),
//                     // Error screen
//                     if (vm.hasError)
//                       Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.wifi_off,
//                               size: 100,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(height: 20),
//                             const Text(
//                               'Oops! Something went wrong.',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             Text(vm.errorMessage, textAlign: TextAlign.center),
//                             const SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: viewModel.reloadWebView,
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
//   }
// }

// // ----------------------------------------
// // Main App
// // ----------------------------------------
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await NotificationService.initialize();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: WebViewNavigator.navigatorKey,
//       title: 'SaverFavor',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.deepPurple),
//       home: const SplashDecider(),
//     );
//   }
// }

// <uses-permission android:name="android.permission.INTERNET"/>
// <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
