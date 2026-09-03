import 'package:flutter/material.dart';

void main() {
  runApp(const EventFlowApp());
}

class EventFlowApp extends StatelessWidget {
  const EventFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventFlow AI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075BEA),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// COMMON COLORS
// ============================================================

const Color blue = Color(0xFF075BEA);
const Color darkBlue = Color(0xFF07113D);
const Color lightBlue = Color(0xFFEAF3FF);
const Color grey = Color(0xFF68738A);

// ============================================================
// SCREEN 1 - SPLASH
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -70,
            child: _purpleShape(230),
          ),

          Positioned(
            bottom: -100,
            right: -80,
            child: _purpleShape(260),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue.withOpacity(.12),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 105,
                      color: Color(0xFF08BFFF),
                    ),
                  ),

                  const SizedBox(height: 35),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Event',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Flow',
                          style: TextStyle(color: Color(0xFF08BFFF)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: 160,
                    height: 2,
                    color: blue,
                  ),

                  const SizedBox(height: 18),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45),
                    child: Text(
                      'An intelligent college event\nmanagement and\nregistration system',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _purpleShape(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3515FF),
            Color(0xFFE000A8),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 2 - ONBOARDING
// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'title': 'Your Campus Events\nNow Smarter!',
      'description':
      'Discover, register, and participate in\nevents happening around your campus.',
      'icon': Icons.event_available,
    },
    {
      'title': 'Discover Amazing Events',
      'description':
      'Explore events, workshops and activities\ntailored for you.',
      'icon': Icons.search,
    },
    {
      'title': 'Participate & Make an Impact',
      'description':
      'Join, engage, and make your campus\nexperience more meaningful.',
      'icon': Icons.emoji_events,
    },
  ];

  void nextPage() {
    if (currentPage < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  top: 15,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 310,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Icon(
                              page['icon'],
                              size: 150,
                              color: blue,
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        Text(
                          page['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          page['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: index == currentPage ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == currentPage
                        ? blue
                        : const Color(0xFFC9D9F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    currentPage == 2
                        ? 'Get Started  →'
                        : 'Next  →',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 3 - LOGIN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            _topBackground(),
            _bottomBackground(),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                50,
                70,
                50,
                35,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    color: blue,
                    size: 90,
                  ),

                  const SizedBox(height: 25),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: TextStyle(color: darkBlue),
                        ),
                        TextSpan(
                          text: 'Back! 👋',
                          style: TextStyle(color: blue),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Log in to your account',
                    style: TextStyle(
                      color: grey,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _input(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    hint: 'Email',
                  ),

                  const SizedBox(height: 20),

                  _passwordInput(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _blueButton(
                    text: 'Login',
                    onPressed: () {},
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: grey),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: hidePassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black,
          ),
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: grey,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 4 - SIGN UP
// ============================================================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            58,
            25,
            58,
            30,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),

              const SizedBox(height: 5),

              const Icon(
                Icons.school,
                color: blue,
                size: 75,
              ),

              const SizedBox(height: 15),

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Create Your ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Account',
                      style: TextStyle(color: blue),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Join EventFlow AI Today!',
                style: TextStyle(
                  color: grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 28),

              _field(Icons.person_outline, 'Full Name'),
              _field(Icons.email_outlined, 'Email'),
              _field(Icons.badge_outlined, 'Student ID'),
              _field(Icons.account_balance_outlined, 'College'),

              _field(
                Icons.school_outlined,
                'Department',
                suffix: Icons.keyboard_arrow_down,
              ),

              _field(
                Icons.lock_outline,
                'Password',
                suffix: Icons.visibility_outlined,
              ),

              _field(
                Icons.lock_outline,
                'Confirm Password',
                suffix: Icons.visibility_outlined,
              ),

              Row(
                children: [
                  Checkbox(
                    value: agree,
                    activeColor: blue,
                    onChanged: (value) {
                      setState(() {
                        agree = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'I agree to '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              _blueButton(
                text: 'Create Account',
                onPressed: () {},
              ),

              const SizedBox(height: 22),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      IconData icon,
      String hint, {
        IconData? suffix,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          suffixIcon: suffix == null
              ? null
              : Icon(
            suffix,
            color: Colors.black,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: grey,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 5 - FORGOT PASSWORD
// ============================================================

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top blue wave
            Positioned(
              top: -80,
              left: -100,
              child: Container(
                width: 330,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCEBFF),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(180),
                  ),
                ),
              ),
            ),

            // Bottom blue wave
            Positioned(
              bottom: -80,
              left: -70,
              right: -70,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF0A63FF),
                      Color(0xFFDCEBFF),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(180),
                    topRight: Radius.circular(180),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  58,
                  15,
                  58,
                  150,
                ),
                child: Column(
                  children: [
                    // Back arrow
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 31,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 45),

                    // Lock illustration
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF0F5FF),
                        boxShadow: [
                          BoxShadow(
                            color: blue.withOpacity(.08),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.lock,
                            size: 105,
                            color: blue,
                          ),

                          Positioned(
                            top: 35,
                            right: 38,
                            child: _star(),
                          ),

                          Positioned(
                            top: 48,
                            left: 35,
                            child: _star(small: true),
                          ),

                          Positioned(
                            bottom: 40,
                            right: 30,
                            child: _star(small: true),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Heading
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Forgot ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Password?',
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Enter your email address and we'll\n"
                          "send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: grey,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // Email label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email field
                    Container(
                      height: 62,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType:
                        TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: grey,
                            fontSize: 17,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(
                            vertical: 19,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Send Reset Link
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailController
                              .text
                              .trim()
                              .isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your email address',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password reset link sent!',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.send_outlined,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 45),

                    // OR divider
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFD9DDE5),
                            thickness: 1.2,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFD9DDE5),
                            thickness: 1.2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Back to Login
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: blue,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.arrow_back,
                              size: 27,
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Back to Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Remember password
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: blue,
                          size: 24,
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text.rich(
                              TextSpan(
                                text:
                                'Remember your password? ',
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: blue,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _star({bool small = false}) {
    return Icon(
      Icons.star,
      size: small ? 13 : 18,
      color: const Color(0xFF7EA7FF),
    );
  }
}

// ============================================================
// COMMON BUTTON
// ============================================================

Widget _blueButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ============================================================
// BACKGROUND SHAPES
// ============================================================

Widget _topBackground() {
  return Positioned(
    top: -100,
    left: -100,
    child: Container(
      width: 330,
      height: 280,
      decoration: const BoxDecoration(
        color: Color(0xFFDCEBFF),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(180),
        ),
      ),
    ),
  );
}

Widget _bottomBackground() {
  return Positioned(
    bottom: -90,
    left: -70,
    right: -70,
    child: Container(
      height: 190,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF0A63FF),
            Color(0xFFEAF3FF),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(180),
          topRight: Radius.circular(180),
        ),
      ),
    ),
  );
}

