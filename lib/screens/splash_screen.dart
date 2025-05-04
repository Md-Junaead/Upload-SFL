// import 'package:flutter/material.dart';

// /// Animated Splash Screen: fades in your GIF splash animation.
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

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
//     // Controller for 2-second fade animation
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward(); // Start fade-in animation
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose controller to free resources
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _animation,
//         child: SizedBox.expand(
//           // Makes the GIF expand to cover the full screen
//           child: Image.asset(
//             'assets/splash/sfl_splash.gif',
//             fit: BoxFit.cover, // Ensures the GIF covers the screen responsively
//           ),
//         ),
//       ),
//     );
//   }
// }

// File: lib/screens/splash_screen.dart
import 'package:flutter/material.dart';

/// Animated Splash Screen: fades in your GIF splash animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Controller for 5-second fade animation (changed from 2s to 5s)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // <-- duration updated to 5 seconds
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward(); // Start fade-in animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: SizedBox.expand(
          // Makes the GIF expand to cover the full screen
          child: Image.asset(
            'assets/splash/sfl_splash.gif',
            fit: BoxFit.cover, // Ensures the GIF covers the screen responsively
          ),
        ),
      ),
    );
  }
}
