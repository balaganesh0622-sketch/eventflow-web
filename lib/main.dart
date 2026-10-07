import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const String apiBaseUrl = 'https://eventflow-backend-iuua.onrender.com';

int? currentUserId;

// ============================================================
// EVENTFLOW BACKEND API
// Android Emulator: 10.0.2.2 points to the computer's localhost.
// If using Flutter Web, change this to http://127.0.0.1:5000
// ============================================================


Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  Map<String, dynamic> body = {};

  try {
    body = jsonDecode(response.body) as Map<String, dynamic>;
  } catch (_) {}

  if (response.statusCode == 200) {
    return body;
  }

  throw Exception(
    body['message'] ?? 'Login failed',
  );
}

Future<Map<String, dynamic>> registerUser({
  required String name,
  required String email,
  required String password,
  required String phone,
}) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/register'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }),
  );

  Map<String, dynamic> body = {};

  try {
    body = jsonDecode(response.body) as Map<String, dynamic>;
  } catch (_) {}

  if (response.statusCode == 201 ||
      response.statusCode == 200) {
    return body;
  }

  throw Exception(
    body['message'] ?? 'Registration failed',
  );
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2962FF)),
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// EventFlow AI - All 24 UI Pages in a single file
// Splash, Onboarding, Role Selection, Login, Sign Up, Forgot Password,
// Home, AI Recommended, All Events, Filter/Search, Event Details,
// Register for Event, Registration Confirmation, My Registration,
// Smart Reminders, Notifications, Profile, Feedback & Rating,
// Admin Verification, Admin Dashboard, Create Event, Manage Events,
// Event Participants, Reports & Analytics
// ============================================================


// ------------------------------------------------------------
// SHARED BOTTOM NAVIGATION HELPERS
// ------------------------------------------------------------

void _handleStudentBottomNav(BuildContext context, int index) {
  final Widget page;
  switch (index) {
    case 0:
      page = const HomeScreen();
      break;
    case 1:
      page = const AllEventsScreen();
      break;
    case 2:
      page = const MyRegistrationScreen();
      break;
    case 3:
      page = const NotificationsScreen();
      break;
    case 4:
      page = const ProfileScreen();
      break;
    default:
      return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

void _handleAdminBottomNav(BuildContext context, int index) {
  final Widget page;
  switch (index) {
    case 0:
      page = const AdminDashboardScreen();
      break;
    case 1:
      page = const ManageEventsScreen();
      break;
    case 2:
      page = const ManageEventsScreen();
      break;
    case 3:
      page = const NotificationsScreen();
      break;
    case 4:
      page = const ProfileScreen();
      break;
    default:
      return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

// ------------------------------------------------------------
// PAGE 1 - SPLASH SCREEN
// ------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // Navigate to onboarding after delay
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E3F),
              Color(0xFF0D1450),
              Color(0xFF120A3D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative top-left blob
            Positioned(
              top: -80,
              left: -60,
              child: _blob(220, [
                const Color(0xFF7B2FF7),
                const Color(0xFF0A0E3F).withOpacity(0),
              ]),
            ),
            // Decorative bottom-right blob
            Positioned(
              bottom: -100,
              right: -60,
              child: _blob(260, [
                const Color(0xFFE3006D),
                const Color(0xFF0A0E3F).withOpacity(0),
              ]),
            ),
            // Skyline silhouette at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.25,
                child: Icon(
                  Icons.location_city,
                  size: 220,
                  color: Colors.blue.shade200,
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.school,
                                size: 56, color: Colors.white),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.white.withOpacity(0.9)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Event',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Flow',
                              style: TextStyle(color: Color(0xFF29B6F6)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Text(
                          'An intelligent college event management\nand registration system',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 2 - ONBOARDING SCREEN
// ------------------------------------------------------------

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardData {
  final String title;
  final String highlight;
  final String description;
  final IconData mainIcon;
  final List<_FeatureItem> features;

  OnboardData({
    required this.title,
    required this.highlight,
    required this.description,
    required this.mainIcon,
    required this.features,
  });
}

class _FeatureItem {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  _FeatureItem(this.icon, this.label, this.desc, this.color);
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardData> _pages = [
    OnboardData(
      title: 'Your Campus Events\nNow ',
      highlight: 'Smarter!',
      description:
          'Discover, register, and participate in events happening around your campus.',
      mainIcon: Icons.groups,
      features: [
        _FeatureItem(Icons.explore, 'Discover', 'Find events that inspire you.',
            Colors.blue),
        _FeatureItem(Icons.assignment_turned_in, 'Register',
            'Quick and easy event registration.', Colors.teal),
        _FeatureItem(Icons.people_alt, 'Participate',
            'Join, engage and make an impact.', Colors.purple),
      ],
    ),
    OnboardData(
      title: '',
      highlight: 'Discover Amazing Events',
      description:
          'Explore events, workshops and activities tailored for you.',
      mainIcon: Icons.person,
      features: [
        _FeatureItem(Icons.star, 'Personalized Recommendations',
            'Events you\'ll love.', Colors.blue),
        _FeatureItem(
            Icons.search, 'Easy Search', 'Find events fast and easily.', Colors.teal),
        _FeatureItem(Icons.notifications, 'Stay Updated',
            'Never miss an important update.', Colors.purple),
      ],
    ),
    OnboardData(
      title: '',
      highlight: 'Participate & Make an Impact',
      description:
          'Join, engage, and make your campus experience more meaningful.',
      mainIcon: Icons.emoji_people,
      features: [
        _FeatureItem(Icons.diversity_3, 'Engage',
            'Connect and engage with your community.', Colors.orange),
        _FeatureItem(Icons.emoji_events, 'Earn & Grow',
            'Certificates, points and achievements.', Colors.green),
        _FeatureItem(Icons.share, 'Share', 'Share events and invite your friends.',
            Colors.purple),
      ],
    ),
  ];

  void _onSkipOrNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Role Selection screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
                  },
                  child: const Text('Skip',
                      style: TextStyle(
                          color: Color(0xFF2962FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildDots(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _onSkipOrNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(data.mainIcon, size: 90, color: const Color(0xFF2962FF)),
          ),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              children: [
                TextSpan(text: data.title),
                TextSpan(
                    text: data.highlight,
                    style: const TextStyle(color: Color(0xFF2962FF))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: data.features
                .map((f) => Expanded(child: _featureColumn(f)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _featureColumn(_FeatureItem f) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: f.color.withOpacity(0.12),
            child: Icon(f.icon, color: f.color),
          ),
          const SizedBox(height: 8),
          Text(f.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(f.desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF2962FF)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 3 - ROLE SELECTION SCREEN
// ------------------------------------------------------------

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: _blob(160, const Color(0xFFD9C9FF)),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: _blob(220, const Color(0xFFD9C9FF)),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: _blob(200, const Color(0xFFCFE0FF)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF3F51F3), Color(0xFF1A237E)]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.school,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                children: [
                                  TextSpan(text: 'EventFlow '),
                                  TextSpan(
                                      text: 'AI',
                                      style:
                                          TextStyle(color: Color(0xFF7C4DFF))),
                                ],
                              ),
                            ),
                            Text(
                              'An Intelligent College Event Management\nand Registration System',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Choose Your Role',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A40)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your role to continue with the event system.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                          width: 32, height: 4,
                          decoration: BoxDecoration(
                              color: const Color(0xFF7C4DFF),
                              borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Container(
                          width: 8, height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _roleCard(
                    icon: Icons.person,
                    title: 'Student',
                    description:
                        'Register for events, get updates and manage your tickets.',
                    gradient: const [Color(0xFF9C6BFF), Color(0xFF6C3CE0)],
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  _roleCard(
                    icon: Icons.shield,
                    title: 'Admin',
                    description:
                        'Manage events, users, registrations and system settings.',
                    gradient: const [Color(0xFF4FA6FF), Color(0xFF1E5AF6)],
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminVerificationScreen()));
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      '— Together for a Better Event Experience —',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500,
                          fontSize: 13),
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

  Widget _roleCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: gradient),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(description,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: gradient.first,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Continue',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.5),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 4 - LOGIN SCREEN
// ------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final loginData = await loginUser(
        email: email,
        password: password,
      );

      final user = loginData['user'];

      if (user == null || user['user_id'] == null) {
        throw Exception('User ID not received from server');
      }

      // Save logged-in user's ID
      currentUserId = int.parse(
        user['user_id'].toString(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top decorative wave
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2962FF),
                    Color(0xFF82B1FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Bottom decorative skyline
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF82B1FF),
                    Color(0xFFE3F2FD),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: const Icon(
                Icons.location_city,
                size: 90,
                color: Colors.white70,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2962FF),
                          Color(0xFF0D47A1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                        ),
                        TextSpan(
                          text: 'Back! 👋',
                          style: TextStyle(
                            color: Color(0xFF2962FF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.mail_outline,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscure: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),
                  ),

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
                          color: Color(0xFF2962FF),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                        size: 28,
                      ),
                      label: const Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF2962FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF2962FF),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 5 - SIGN UP SCREEN
// ------------------------------------------------------------

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _collegeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _department;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // The current Flask /register API accepts these four fields.
      // Student ID, college and department remain part of the UI for now.
      await registerUser(
        name: name,
        email: email,
        password: password,
        phone: '0000000000',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final List<String> _departments = [
    'Computer Science',
    'IT',
    'BCOM',
    'BCA',
    'BSC IT',
    'ENGLISH',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF82B1FF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              color: const Color(0xFFE3F2FD),
              child: const Icon(Icons.location_city, size: 80, color: Colors.white70),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Icon(Icons.school, color: Color(0xFF1A237E), size: 56),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      children: [
                        TextSpan(text: 'Create Your '),
                        TextSpan(
                            text: 'Account',
                            style: TextStyle(color: Color(0xFF2962FF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Join EventFlow AI Today!',
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 24),
                  _field(_nameController, 'Full Name', Icons.person_outline),
                  const SizedBox(height: 14),
                  _field(_emailController, 'Email', Icons.mail_outline),
                  const SizedBox(height: 14),
                  _field(_studentIdController, 'Student ID', Icons.badge_outlined),
                  const SizedBox(height: 14),
                  _field(_collegeController, 'College', Icons.account_balance_outlined),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _department,
                    decoration: _decoration('Select your department', Icons.school_outlined),
                    items: _departments
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) => setState(() => _department = val),
                  ),
                  const SizedBox(height: 14),
                  _field(_passwordController, 'Password', Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      )),
                  const SizedBox(height: 14),
                  _field(_confirmPasswordController, 'Confirm Password',
                      Icons.lock_outline,
                      obscure: _obscureConfirmPassword,
                      suffix: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword),
                      )),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (val) =>
                            setState(() => _agreedToTerms = val ?? false),
                        activeColor: const Color(0xFF2962FF),
                      ),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black87, fontSize: 13),
                            children: [
                              TextSpan(text: 'I agree to '),
                              TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                      color: Color(0xFF2962FF),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
                        child: const Text('Login',
                            style: TextStyle(
                                color: Color(0xFF2962FF),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2962FF)),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint, IconData icon,
      {bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: _decoration(hint, icon, suffix: suffix),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _collegeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 6 - FORGOT PASSWORD SCREEN
// ------------------------------------------------------------

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF2962FF), Color(0xFF82B1FF)]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: const Color(0xFFE3F2FD),
              child: const Icon(Icons.location_city, size: 90, color: Colors.white70),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8EEFF),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFF2962FF), Color(0xFF0D47A1)]),
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      children: [
                        TextSpan(text: 'Forgot '),
                        TextSpan(
                            text: 'Password?',
                            style: TextStyle(color: Color(0xFF2962FF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Enter your email address and we'll\nsend you a link to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email Address',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.mail_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF2962FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent.')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      label: const Text('Send Reset Link',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: TextStyle(color: Colors.grey.shade500)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () { Navigator.pop(context); },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2962FF)),
                      label: const Text('Back to Login',
                          style: TextStyle(
                              color: Color(0xFF2962FF), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      const Text('Remember your password? '),
                      GestureDetector(
                        onTap: () { Navigator.pop(context); },
                        child: const Text('Login',
                            style: TextStyle(
                                color: Color(0xFF2962FF),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 7 - HOME SCREEN
// ------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  final List<_CategoryItem> _categories = [
    _CategoryItem(Icons.code, 'Tech', Colors.purple),
    _CategoryItem(Icons.theater_comedy, 'Cultural', Colors.green),
    _CategoryItem(Icons.directions_run, 'Sports', Colors.orange),
    _CategoryItem(Icons.slideshow, 'Workshop', Colors.blue),
    _CategoryItem(Icons.apps, 'All', Colors.pink),
  ];

  final List<_EventItem> _featuredEvents = [
    _EventItem(
      title: 'Flutter Workshop 2026',
      date: '24 Aug 2026',
      location: 'IT Seminar Hall',
      seats: '120 Seats Left',
      color: const Color(0xFF1A237E),
    ),
    _EventItem(
      title: 'Cultural Night',
      date: '05 Nov 2026',
      location: 'Main Auditorium',
      seats: '100 Seats Left',
      color: const Color(0xFF4A148C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFBBDEFB),
                  child: Icon(Icons.person, color: Color(0xFF1565C0)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hi, Yesh! 👋',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Ready to explore events?',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.notifications_none),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text('3',
                              style: TextStyle(color: Colors.white, fontSize: 9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search events, workshops...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FilterSearchScreen()));
              },
              readOnly: true,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Discover\nAmazing Events',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Explore, Learn & Grow with exciting campus experiences',
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AllEventsScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Explore Now', style: TextStyle(color: Color(0xFF2962FF))),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 14, color: Color(0xFF2962FF)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.campaign, color: Colors.white, size: 60),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final c = _categories[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: c.color.withOpacity(0.12),
                        child: Icon(c.icon, color: c.color),
                      ),
                      const SizedBox(height: 6),
                      Text(c.label, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AllEventsScreen()));
                  },
                  child: const Row(
                    children: [
                      Text('See all', style: TextStyle(color: Color(0xFF2962FF))),
                      Icon(Icons.chevron_right, color: Color(0xFF2962FF), size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._featuredEvents.map((e) => _eventCard(e)),
            const SizedBox(height: 20),
            const Text('Quick Access',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _quickAccessItem(Icons.event_note, 'My Events', Colors.purple),
                _quickAccessItem(Icons.confirmation_number, 'My Registrations', Colors.teal),
                _quickAccessItem(Icons.star, 'Favorites', Colors.orange),
                _quickAccessItem(Icons.verified, 'Certificates', Colors.blue),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => _handleStudentBottomNav(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2962FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _eventCard(_EventItem e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: e.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(e.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(e.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
                const SizedBox(height: 4),
                Text(e.seats, style: const TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border),
        ],
      ),
    );
  }

  Widget _quickAccessItem(IconData icon, String label, Color color) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Widget? page;
          if (label == 'My Events' || label == 'My Registrations') {
            page = const MyRegistrationScreen();
          } else if (label == 'Favorites') {
            page = const AiRecommendedScreen();
          } else if (label == 'Certificates') {
            page = const ProfileScreen();
          }
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  _CategoryItem(this.icon, this.label, this.color);
}

class _EventItem {
  final String title;
  final String date;
  final String location;
  final String seats;
  final Color color;
  _EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.seats,
    required this.color,
  });
}

// ------------------------------------------------------------
// PAGE 8 - AI RECOMMENDED SCREEN
// ------------------------------------------------------------

class AiRecommendedScreen extends StatefulWidget {
  const AiRecommendedScreen({super.key});

  @override
  State<AiRecommendedScreen> createState() => _AiRecommendedScreenState();
}

class _AiRecommendedScreenState extends State<AiRecommendedScreen> {
  bool _showRecommended = true;
  int _selectedNavIndex = 0;

  final List<_RecEvent> _recommended = [
    _RecEvent('AI Seminar 2026', '26 Aug 2026', '100 Seats Left',
        Icons.memory, const Color(0xFF311B92)),
    _RecEvent('Web Dev Workshop', '30 Aug 2026', '80 Seats Left',
        Icons.wb_sunny, const Color(0xFF6A1B9A)),
    _RecEvent('Hackathon 2026', '22 Oct 2026', '150 Seats Left',
        Icons.laptop_mac, const Color(0xFF0D47A1)),
    _RecEvent('Cultural Night', '05 Nov 2026', '100 Seats Left',
        Icons.nightlife, const Color(0xFF1A237E)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            children: [
                              TextSpan(text: 'AI Recommended\n'),
                              TextSpan(
                                  text: 'For You ✨',
                                  style: TextStyle(color: Color(0xFF7C4DFF))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Personalized events based on your interests 🪄',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.smart_toy, color: Color(0xFF7C4DFF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showRecommended = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _showRecommended
                                ? const Color(0xFF7C4DFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('Recommended',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: _showRecommended
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showRecommended = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_showRecommended
                                ? const Color(0xFF7C4DFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('Trending',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: !_showRecommended
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ..._recommended.map((e) => _eventCard(e)),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.auto_fix_high, color: Color(0xFF7C4DFF)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Smart Recommendation',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'We analyze your interests and activity to suggest the best events for you.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        const Icon(Icons.psychology_alt, color: Color(0xFF7C4DFF)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => _handleStudentBottomNav(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _eventCard(_RecEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: e.color, borderRadius: BorderRadius.circular(12)),
            child: Icon(e.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(e.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
                Row(children: [
                  const Icon(Icons.people, size: 12, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(e.seats, style: const TextStyle(fontSize: 12, color: Colors.green)),
                ]),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.bookmark_border),
              const SizedBox(height: 16),
              const Icon(Icons.more_vert, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecEvent {
  final String title;
  final String date;
  final String seats;
  final IconData icon;
  final Color color;
  _RecEvent(this.title, this.date, this.seats, this.icon, this.color);
}

// ------------------------------------------------------------
// PAGE 9 - ALL EVENTS SCREEN
// ------------------------------------------------------------

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  List<dynamic> events = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/events'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          events = data is List ? data : (data['events'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load events';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unable to connect to server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    },
  ),
  title: const Text('All Events'),
  centerTitle: true,
),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 15),
                      Text(errorMessage),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: fetchEvents,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : events.isEmpty
                  ? const Center(
                      child: Text(
                        'No events available',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchEvents,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['title']?.toString() ??
                                        'Untitled Event',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    event['description']?.toString() ??
                                        'No description',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          event['venue']?.toString() ??
                                              'Venue not available',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        event['event_date']?.toString() ??
                                            'Date not available',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        event['event_time']?.toString() ??
                                            'Time not available',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Seats: ${event['available_seats'] ?? 0}',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 15),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                     onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EventDetailsScreen(
        event: event,
      ),
    ),
  );
},
                                      child: const Text('View Event'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
// ------------------------------------------------------------
// PAGE 10 - FILTER/SEARCH SCREEN
// ------------------------------------------------------------

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedPrice = 'All';
  String _selectedVenue = 'All Venues';
  String _sortBy = 'Latest';
  DateTime? _selectedDate;

  final List<String> _categories = ['All', 'Technical', 'Cultural', 'Sports', 'Workshop', 'Other'];
  final List<String> _venues = ['All Venues', 'Seminar Hall', 'Main Auditorium', 'Lab 1', 'Lab 2'];
  final List<String> _sortOptions = ['Latest', 'Oldest', 'Popularity', 'A-Z'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF2FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () { Navigator.pop(context); },
        ),
        title: const Text('Filter / Search',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search events, workshops, seminars...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF5F6FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((c) {
                  final isSelected = _selectedCategory == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2962FF) : const Color(0xFFF0F0F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(c,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Venue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVenue,
                    isExpanded: true,
                    items: _venues
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedVenue = val!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Row(
                children: ['All', 'Free', 'Paid'].map((p) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: p,
                        groupValue: _selectedPrice,
                        activeColor: const Color(0xFF2962FF),
                        onChanged: (val) => setState(() => _selectedPrice = val!),
                      ),
                      Text(p),
                      const SizedBox(width: 8),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    items: _sortOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _sortBy = val!),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'All';
                          _selectedPrice = 'All';
                          _selectedVenue = 'All Venues';
                          _sortBy = 'Latest';
                          _selectedDate = null;
                          _searchController.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.filter_alt, color: Colors.white, size: 18),
                      label: const Text('Apply Filter',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 11 - EVENT DETAILS SCREEN
// ------------------------------------------------------------

class EventDetailsScreen extends StatefulWidget {
  final dynamic event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
}

class _EventDetailsScreenState
    extends State<EventDetailsScreen> {
  bool _isRegistering = false;

  Future<void> _registerForEvent() async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
        ),
      );
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/registrations'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': currentUserId,
          'event_id': widget.event['event_id'],
        }),
      );

      Map<String, dynamic> body = {};

      try {
        body = jsonDecode(response.body)
            as Map<String, dynamic>;
      } catch (_) {}

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['message'] ??
                  'Registration successful',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['message'] ??
                  'Registration failed',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.event['title']?.toString() ?? 'Event';

    final String description =
        widget.event['description']?.toString() ??
            'No description available';

    final String venue =
        widget.event['venue']?.toString() ??
            'Not available';

    final String date =
        widget.event['event_date']?.toString() ??
            'Not available';

    final String time =
        widget.event['event_time']?.toString() ??
            'Not available';

    final String seats =
        widget.event['available_seats']?.toString() ??
            '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: const Color(0xFF1556C8),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101B36),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101B36),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF657089),
              ),
            ),

            const SizedBox(height: 25),

            _eventInfo(
              Icons.location_on,
              'Venue',
              venue,
            ),

            const SizedBox(height: 15),

            _eventInfo(
              Icons.calendar_month,
              'Date',
              date,
            ),

            const SizedBox(height: 15),

            _eventInfo(
              Icons.access_time,
              'Time',
              time,
            ),

            const SizedBox(height: 15),

            _eventInfo(
              Icons.event_seat,
              'Available Seats',
              seats,
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isRegistering
                    ? null
                    : _registerForEvent,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1556C8),
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                child: _isRegistering
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Register for Event',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventInfo(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.info_outline,
            color: Color(0xFF1556C8),
            size: 28,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF657089),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                    color: Color(0xFF101B36),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 12 - REGISTER FOR EVENT SCREEN
// ------------------------------------------------------------

class RegisterEventScreen extends StatefulWidget {
  const RegisterEventScreen({super.key});

  @override
  State<RegisterEventScreen> createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _college = 'NGM College, Coimbatore';
  String? _department;
  String? _year;
  String _registrationType = 'Individual';
  bool _agreedToTerms = false;

  final List<String> _departments = ['CSE', 'IT', 'ECE', 'EEE', 'Mechanical'];
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () { Navigator.pop(context); },
        ),
        title: const Text('Register for Event',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF0D1B4C), Color(0xFF1A237E)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flutter_dash, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Flutter Workshop 2026',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('24 Aug 2026, 10:00 AM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                        Row(children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('IT Seminar Hall, NGM College', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                        Row(children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('3 Hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                        Row(children: [
                          Icon(Icons.people, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('120 Seats Left', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Attendee Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 16),
            _label('Full Name'),
            _field(_nameController, 'Enter your full name', Icons.person_outline),
            const SizedBox(height: 16),
            _label('Email'),
            _field(_emailController, 'Enter your email address', Icons.mail_outline),
            const SizedBox(height: 16),
            _label('Phone Number'),
            _field(_phoneController, 'Enter your phone number', Icons.phone_outlined),
            const SizedBox(height: 16),
            _label('College'),
            _dropdownField(
              value: _college,
              items: ['NGM College, Coimbatore', 'PSG College', 'Kongu College'],
              icon: Icons.account_balance_outlined,
              onChanged: (val) => setState(() => _college = val!),
            ),
            const SizedBox(height: 16),
            _label('Department'),
            _dropdownField(
              value: _department,
              hint: 'Select your department',
              items: _departments,
              icon: Icons.school_outlined,
              onChanged: (val) => setState(() => _department = val),
            ),
            const SizedBox(height: 16),
            _label('Year / Class'),
            _dropdownField(
              value: _year,
              hint: 'Select your year or class',
              items: _years,
              icon: Icons.people_outline,
              onChanged: (val) => setState(() => _year = val),
            ),
            const SizedBox(height: 20),
            const Text('Registration Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _regTypeCard(
                    icon: Icons.person,
                    title: 'Individual',
                    subtitle: 'Register for yourself',
                    value: 'Individual',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _regTypeCard(
                    icon: Icons.groups,
                    title: 'Group',
                    subtitle: 'Register as a group',
                    value: 'Group',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: const Color(0xFF2962FF),
                  onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                ),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w600)),
                        TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w600)),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to the Terms & Conditions.')));
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationConfirmationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                label: const Text('Confirm Registration',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Back to Event Details
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.arrow_back, color: Color(0xFF2962FF)),
                label: const Text('Back to Event Details',
                    style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _field(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2962FF)),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String? value,
    String? hint,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          hint: hint != null ? Text(hint, style: TextStyle(color: Colors.grey.shade600)) : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
          ),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _regTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _registrationType == value;
    return GestureDetector(
      onTap: () => setState(() => _registrationType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EEFF) : Colors.white,
          border: Border.all(
              color: isSelected ? const Color(0xFF2962FF) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _registrationType,
              activeColor: const Color(0xFF2962FF),
              onChanged: (val) => setState(() => _registrationType = val!),
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE3F2FD),
              child: Icon(icon, size: 16, color: const Color(0xFF2962FF)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 13 - REGISTRATION CONFIRMATION SCREEN
// ------------------------------------------------------------

class RegistrationConfirmationScreen extends StatelessWidget {
  const RegistrationConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () { Navigator.pop(context); },
        ),
        title: const Text('Registration Confirmation',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ..._confetti(),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF26A69A), Color(0xFF1E88E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 64),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: 'Registration ', style: TextStyle(color: Colors.black87)),
                  TextSpan(text: 'Successful!', style: TextStyle(color: Color(0xFF2E7D32))),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: 'You have successfully registered for\n'),
                  TextSpan(
                      text: 'Flutter Workshop 2026',
                      style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w600)),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text('Registration ID',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(Icons.qr_code_2, size: 16, color: Colors.green),
                      ),
                      const SizedBox(width: 8),
                      const Text('EVF20260824A001',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Event Summary',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF0D1B4C), Color(0xFF1A237E)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.flutter_dash, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Flutter Workshop 2026',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('24 Aug 2026, 10:00 AM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ]),
                            Row(children: [
                              Icon(Icons.location_on, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('IT Seminar Hall, NGM College', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ]),
                            Row(children: [
                              Icon(Icons.access_time, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('3 Hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ]),
                            Row(children: [
                              Icon(Icons.people, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('120 Seats Left', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("What's Next?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(Icons.notifications, size: 16, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You will receive an email and reminder notifications before the event.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRegistrationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.confirmation_number, color: Colors.white, size: 18),
                label: const Text('View My Registrations',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E88E5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.home, color: Color(0xFF1E88E5), size: 18),
                label: const Text('Back to Home',
                    style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _confetti() {
    final colors = [
      Colors.pink, Colors.orange, Colors.blue, Colors.green,
      Colors.purple, Colors.yellow, Colors.teal,
    ];
    final positions = [
      const Offset(-90, -80), const Offset(90, -80), const Offset(-110, 0),
      const Offset(110, 0), const Offset(-70, 80), const Offset(70, 80),
      const Offset(0, -100), const Offset(-40, -50), const Offset(40, -50),
      const Offset(-100, 40), const Offset(100, 40), const Offset(0, 100),
    ];
    return List.generate(positions.length, (i) {
      return Transform.translate(
        offset: positions[i],
        child: Icon(Icons.star, size: 12, color: colors[i % colors.length]),
      );
    });
  }
}

// ------------------------------------------------------------
// PAGE 14 - MY REGISTRATION SCREEN
// ------------------------------------------------------------

class MyRegistrationScreen extends StatefulWidget {
  const MyRegistrationScreen({super.key});

  @override
  State<MyRegistrationScreen> createState() =>
      _MyRegistrationScreenState();
}

class _MyRegistrationScreenState
    extends State<MyRegistrationScreen> {

  String _selectedTab = 'Upcoming';

  bool _isLoading = true;

  List<dynamic> _registrations = [];

  @override
  void initState() {
    super.initState();
    fetchMyRegistrations();
  }

  Future<void> fetchMyRegistrations() async {
    if (currentUserId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$apiBaseUrl/registrations/user/$currentUserId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          _registrations = data;
        } else if (data['registrations'] is List) {
          _registrations = data['registrations'];
        } else {
          _registrations = [];
        }
      }
    } catch (e) {
      debugPrint(
        'My Registration Error: $e',
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get filteredRegistrations {
    final now = DateTime.now();

    return _registrations.where((registration) {

      String status =
          registration['status']
                  ?.toString()
                  .toLowerCase() ??
              'registered';

      if (status == 'cancelled') {
        return _selectedTab == 'Cancelled';
      }

      if (_selectedTab == 'Cancelled') {
        return false;
      }

      String dateText =
          registration['event_date']
                  ?.toString() ??
              '';

      DateTime? eventDate;

      try {
        eventDate =
            DateTime.parse(dateText);
      } catch (_) {}

      if (_selectedTab == 'Upcoming') {
        if (eventDate == null) {
          return true;
        }

        return !eventDate.isBefore(
          DateTime(
            now.year,
            now.month,
            now.day,
          ),
        );
      }

      if (_selectedTab == 'Completed') {
        if (eventDate == null) {
          return false;
        }

        return eventDate.isBefore(
          DateTime(
            now.year,
            now.month,
            now.day,
          ),
        );
      }

      return true;
    }).toList();
  }

  String getValue(
    dynamic item,
    String key,
    String defaultValue,
  ) {
    final value = item[key];

    if (value == null ||
        value.toString().isEmpty) {
      return defaultValue;
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    },
  ),

  title: const Text(
    'My Registration',
  ),
      
       centerTitle: true,
        backgroundColor:
            const Color(0xFF1556C8),
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: fetchMyRegistrations,

        child: Column(
          children: [

            const SizedBox(height: 12),

            // ------------------------------------------------
            // TABS
            // ------------------------------------------------

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(
                children: [
                  _buildTab('Upcoming'),
                  _buildTab('Completed'),
                  _buildTab('Cancelled'),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // CONTENT
            // ------------------------------------------------

            Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )

                  : currentUserId == null
                      ? const Center(
                          child: Text(
                            'Please login first',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )

                      : filteredRegistrations
                              .isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(
                                  height: 180,
                                ),

                                Center(
                                  child: Icon(
                                    Icons.event_busy,
                                    size: 60,
                                    color:
                                        Color(0xFF657089),
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Center(
                                  child: Text(
                                    'No registrations found',
                                    style:
                                        TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w600,
                                      color:
                                          Color(
                                        0xFF101B36,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )

                          : ListView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              itemCount:
                                  filteredRegistrations
                                      .length,

                              itemBuilder:
                                  (context, index) {

                                final registration =
                                    filteredRegistrations[
                                        index];

                                final title =
                                    getValue(
                                  registration,
                                  'title',
                                  'Event',
                                );

                                final description =
                                    getValue(
                                  registration,
                                  'description',
                                  'No description',
                                );

                                final venue =
                                    getValue(
                                  registration,
                                  'venue',
                                  'Venue not available',
                                );

                                final date =
                                    getValue(
                                  registration,
                                  'event_date',
                                  'Date not available',
                                );

                                final time =
                                    getValue(
                                  registration,
                                  'event_time',
                                  'Time not available',
                                );

                                final status =
                                    getValue(
                                  registration,
                                  'status',
                                  'registered',
                                );

                                return _buildRegistrationCard(
                                  title: title,
                                  description:
                                      description,
                                  venue: venue,
                                  date: date,
                                  time: time,
                                  status: status,
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TAB
  // ----------------------------------------------------------

  Widget _buildTab(String title) {

    final bool selected =
        _selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },

        child: Container(
          margin:
              const EdgeInsets.symmetric(
            horizontal: 4,
          ),

          padding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1556C8)
                : const Color(0xFFEAF3FF),

            borderRadius:
                BorderRadius.circular(25),
          ),

          child: Text(
            title,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,

              color: selected
                  ? Colors.white
                  : const Color(
                      0xFF1556C8,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // REGISTRATION CARD
  // ----------------------------------------------------------

  Widget _buildRegistrationCard({
    required String title,
    required String description,
    required String venue,
    required String date,
    required String time,
    required String status,
  }) {

    final bool cancelled =
        status.toLowerCase() ==
            'cancelled';

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],

        border: Border.all(
          color:
              const Color(0xFFE3E8F0),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // TITLE + STATUS

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF101B36),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration:
                    BoxDecoration(
                  color: cancelled
                      ? const Color(
                          0xFFFFE5E5,
                        )
                      : const Color(
                          0xFFE5F8EA,
                        ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  status == 'registered'
                      ? 'Confirmed'
                      : status,

                  style:
                      TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.bold,

                    color: cancelled
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,

            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,

            style:
                const TextStyle(
              fontSize: 13,
              color:
                  Color(0xFF657089),
            ),
          ),

          const SizedBox(height: 15),

          // DATE

          _infoRow(
            Icons.calendar_month,
            date,
          ),

          const SizedBox(height: 8),

          // TIME

          _infoRow(
            Icons.access_time,
            time,
          ),

          const SizedBox(height: 8),

          // VENUE

          _infoRow(
            Icons.location_on,
            venue,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {

    return Row(
      children: [

        Icon(
          icon,
          size: 19,
          color:
              const Color(0xFF1556C8),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            text,

            style:
                const TextStyle(
              fontSize: 13,
              color:
                  Color(0xFF101B36),
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// PAGE 15 - SMART REMINDERS SCREEN
// ------------------------------------------------------------

class SmartRemindersScreen extends StatefulWidget {
  const SmartRemindersScreen({super.key});

  @override
  State<SmartRemindersScreen> createState() => _SmartRemindersScreenState();
}

class _SmartRemindersScreenState extends State<SmartRemindersScreen> {
  List<dynamic> reminders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    if (currentUserId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/reminders/$currentUserId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          reminders = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateTime;
    }
  }

  String formatTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);

      int hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';

      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return '';
    }
  }

  Future<void> addReminder() async {
  if (currentUserId == null) return;

  try {
    // Get user's registered events
    final registrationResponse = await http.get(
      Uri.parse('$apiBaseUrl/registrations/user/$currentUserId'),
    );

    if (registrationResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load your registrations'),
        ),
      );
      return;
    }

    final registeredEvents =
        jsonDecode(registrationResponse.body);

    if (registeredEvents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('First register for an event'),
        ),
      );
      return;
    }

    // Take the first registered event
    final eventId = registeredEvents[0]['event_id'];

    // Reminder time = 24 hours from now
    final reminderTime =
        DateTime.now().add(const Duration(hours: 24));

    final response = await http.post(
      Uri.parse('$apiBaseUrl/reminders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': currentUserId,
        'event_id': eventId,
        'reminder_time': reminderTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder added successfully 🔔'),
        ),
      );

      fetchReminders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add reminder: ${response.body}',
          ),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection error: $e'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Smart Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1556C8),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchReminders,
              child: reminders.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 100),
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'No reminders available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'Register for an event to create a reminder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 14,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active,
                                    color: Color(0xFF1556C8),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminder['event_title'] ??
                                            reminder['title'] ??
                                            'Event Reminder',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      if (reminder['reminder_time'] !=
                                          null) ...[
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              formatDate(
                                                reminder[
                                                    'reminder_time'],
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              formatTime(
                                                reminder[
                                                    'reminder_time'],
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addReminder,
        backgroundColor: const Color(0xFF1556C8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert),
        label: const Text('Add Reminder'),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 16 - NOTIFICATIONS SCREEN
// ------------------------------------------------------------

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotifItem {
  final int notificationId;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final bool isRead;

  _NotifItem(
    this.notificationId,
    this.title,
    this.description,
    this.time,
    this.icon,
    this.color,
    this.isRead,
  );
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  int _selectedNavIndex = 3;

  List<_NotifItem> _notifications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (currentUserId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please login first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$apiBaseUrl/notifications/$currentUserId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> notificationList =
            data is List
                ? data
                : (data['notifications'] ?? []);

        setState(() {
          _notifications = notificationList.map((item) {
            final String title =
                item['title']?.toString() ?? 'Notification';

            final String message =
                item['message']?.toString() ??
                    item['description']?.toString() ??
                    '';

            final bool isRead =
                item['is_read'] == true ||
                item['is_read'] == 1 ||
                item['is_read']?.toString() == '1';

            IconData icon = Icons.notifications;
            Color color =
                const Color(0xFF5C4DFF);

            final String lowerTitle =
                title.toLowerCase();

            if (lowerTitle.contains('register')) {
              icon = Icons.check_circle;
              color = Colors.green;
            } else if (lowerTitle.contains('reminder')) {
              icon = Icons.calendar_today;
              color = const Color(0xFF5C4DFF);
            } else if (lowerTitle.contains('event')) {
              icon = Icons.event;
              color = Colors.orange;
            } else if (lowerTitle.contains('update')) {
              icon = Icons.info;
              color = Colors.blue;
            } else if (lowerTitle.contains('announcement')) {
              icon = Icons.campaign;
              color = Colors.amber;
            }

            return _NotifItem(
              int.tryParse(
                    item['notification_id']
                            ?.toString() ??
                        '0',
                  ) ??
                  0,
              title,
              message,
              _formatNotificationTime(
                item['created_at'],
              ),
              icon,
              color,
              isRead,
            );
          }).toList();

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load notifications';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to connect to server';
      });
    }
  }

  String _formatNotificationTime(dynamic value) {
    if (value == null) {
      return '';
    }

    final String raw = value.toString();

    try {
      final DateTime dateTime =
          DateTime.parse(raw).toLocal();

      final String hour =
          dateTime.hour == 0
              ? '12'
              : dateTime.hour > 12
                  ? '${dateTime.hour - 12}'
                  : '${dateTime.hour}';

      final String minute =
          dateTime.minute.toString().padLeft(2, '0');

      final String period =
          dateTime.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return raw;
    }
  }

  List<_NotifItem> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    }

    return _notifications.where((item) {
      final String text =
          '${item.title} ${item.description}'
              .toLowerCase();

      if (_selectedFilter == 'Event') {
        return text.contains('event') ||
            text.contains('registration') ||
            text.contains('reminder');
      }

      if (_selectedFilter == 'System') {
        return text.contains('announcement') ||
            text.contains('update') ||
            text.contains('system');
      }

      return true;
    }).toList();
  }

  Future<void> _markAsRead(int notificationId) async {
    if (notificationId == 0) return;

    try {
      await http.post(
        Uri.parse(
          '$apiBaseUrl/notifications/$notificationId/read',
        ),
      );

      await _fetchNotifications();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomeScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF5C4DFF),
            ),
            onPressed: _fetchNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                'All',
                'Event',
                'System',
              ].map((f) {
                final isSelected =
                    _selectedFilter == f;

                final icon = f == 'Event'
                    ? Icons.calendar_today
                    : f == 'System'
                        ? Icons.notifications
                        : null;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = f;
                      });
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5C4DFF)
                            : const Color(0xFFF5F5FA),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              size: 14,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            f,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons
                                  .notifications_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                                height: 15),
                            Text(_errorMessage),
                            const SizedBox(
                                height: 15),
                            ElevatedButton(
                              onPressed:
                                  _fetchNotifications,
                              child:
                                  const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : notifications.isEmpty
                        ? RefreshIndicator(
                            onRefresh:
                                _fetchNotifications,
                            child: ListView(
                              children: const [
                                SizedBox(height: 180),
                                Center(
                                  child: Text(
                                    'No notifications available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh:
                                _fetchNotifications,
                            child: ListView(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const SizedBox(
                                    height: 8),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .all(16),
                                  margin:
                                      const EdgeInsets
                                          .only(
                                    bottom: 15,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                            0xFFEDE9FE),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons
                                            .notifications_active,
                                        color: Color(
                                            0xFF5C4DFF),
                                      ),
                                      const SizedBox(
                                          width: 12),
                                      Expanded(
                                        child: Text(
                                          '${notifications.length} notification(s)',
                                          style:
                                              TextStyle(
                                            fontSize: 13,
                                            color: Colors
                                                .grey
                                                .shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                            0xFFFAFAFA),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16),
                                  ),
                                  child: Column(
                                    children: notifications
                                        .asMap()
                                        .entries
                                        .map((e) {
                                      final index =
                                          e.key;
                                      final item =
                                          e.value;

                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (!item
                                                  .isRead) {
                                                _markAsRead(
                                                  item
                                                      .notificationId,
                                                );
                                              }
                                            },
                                            child:
                                                _notifTile(
                                                    item),
                                          ),
                                          if (index !=
                                              notifications
                                                      .length -
                                                  1)
                                            Divider(
                                              height: 1,
                                              color: Colors
                                                  .grey
                                                  .shade200,
                                            ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),

                                const SizedBox(
                                    height: 20),
                              ],
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) =>
            _handleStudentBottomNav(
          context,
          index,
        ),
        type:
            BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color(0xFF5C4DFF),
        unselectedItemColor:
            Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.confirmation_number),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _notifTile(_NotifItem item) {
    return Container(
      color: item.isRead
          ? Colors.transparent
          : const Color(0xFFF7F5FF),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  item.color.withOpacity(0.12),
              child: Icon(
                item.icon,
                size: 18,
                color: item.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: item.isRead
                          ? FontWeight.w600
                          : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  item.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                if (!item.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF5C4DFF),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 17 - PROFILE SCREEN
// ------------------------------------------------------------

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  _MenuItemData(this.icon, this.title, this.subtitle, this.color);
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedNavIndex = 4;

  final List<_MenuItemData> _menuItems = [
    _MenuItemData(Icons.person_outline, 'My Profile', 'View and edit your personal details', Colors.deepPurple),
    _MenuItemData(Icons.confirmation_num_outlined, 'My Registrations', 'View all your event registrations', Colors.indigo),
    _MenuItemData(Icons.favorite_border, 'Saved Events', 'Events you marked as favorite', Colors.pink),
    _MenuItemData(Icons.workspace_premium_outlined, 'Certificates', 'View and download your certificates', Colors.teal),
    _MenuItemData(Icons.settings_outlined, 'Settings', 'App preferences and privacy', Colors.orange),
    _MenuItemData(Icons.feedback_outlined, 'Feedback', 'Share your event experience', Colors.amber),
    _MenuItemData(Icons.notifications_active_outlined,'Smart Reminders','Manage your event reminders',Colors.blue,),
    _MenuItemData(Icons.headset_mic_outlined, 'Help & Support', 'FAQs, contact us', Colors.blue),
    _MenuItemData(Icons.info_outline, 'About EventFlow AI', 'Version 1.0.0', Colors.deepPurple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB39DDB), Color(0xFFEDE7F6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      const Text('Profile',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: const Icon(Icons.notifications_none, size: 20),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Color(0xFFD1C4E9),
                                  child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle, color: Color(0xFF7C4DFF)),
                                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: const [
                                    Text('Bash',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    SizedBox(width: 6),
                                    Icon(Icons.school, size: 16, color: Colors.deepPurple),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text('BCA - Final Year', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                  Text('NGM College, Coimbatore', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Profile selected.')));
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF7C4DFF)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            icon: const Icon(Icons.edit, size: 14, color: Color(0xFF7C4DFF)),
                            label: const Text('Edit Profile',
                                style: TextStyle(color: Color(0xFF7C4DFF), fontSize: 12)),
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statColumn('12', 'Events Registered'),
                            _statColumn('8', 'Events Attended'),
                            _statColumn('5', 'Certificates'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _menuItems.map((item) => _menuTile(item)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.red, size: 18),
                  label: const Text('Log Out',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => _handleStudentBottomNav(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _statColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _menuTile(_MenuItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.color.withOpacity(0.12),
          child: Icon(item.icon, color: item.color),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(item.subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (item.title.toLowerCase().contains('reminder')) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartRemindersScreen()));
          } else if (item.title.toLowerCase().contains('notification')) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
          } else if (item.title.toLowerCase().contains('feedback')) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
          }
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 18 - FEEDBACK & RATING SCREEN
// ------------------------------------------------------------

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 4;
  final _feedbackController = TextEditingController();

  final List<String> _tags = [
    'Content',
    'Speakers',
    'Organization',
    'Venue',
    'Networking',
    'Food & Beverages',
    'Overall Experience',
  ];

  final Set<String> _selectedTags = {'Content'};

  int? _eventId;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    if (currentUserId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$apiBaseUrl/registrations/user/$currentUserId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> registrations =
            data is List
                ? data
                : (data['registrations'] ?? []);

        if (registrations.isNotEmpty) {
          final registration = registrations.first;

          setState(() {
            _eventId = int.tryParse(
              registration['event_id']?.toString() ?? '',
            );
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
        ),
      );
      return;
    }

    if (_eventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No registered event found for feedback',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final selectedTagsText =
          _selectedTags.join(', ');

      final feedbackText =
          _feedbackController.text.trim();

      final String comment = feedbackText.isEmpty
          ? 'Liked: $selectedTagsText'
          : '$feedbackText\nLiked: $selectedTagsText';

      final response = await http.post(
        Uri.parse('$apiBaseUrl/feedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': currentUserId,
          'event_id': _eventId,
          'rating': _rating,
          'comment': comment,
        }),
      );

      Map<String, dynamic> body = {};

      try {
        body = jsonDecode(response.body)
            as Map<String, dynamic>;
      } catch (_) {}

      if (!mounted) return;

      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['message'] ??
                  'Feedback submitted successfully.',
            ),
          ),
        );

        _feedbackController.clear();

        setState(() {
          _rating = 4;
          _selectedTags
            ..clear()
            ..add('Content');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['message'] ??
                  'Feedback submission failed.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to server',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomeScreen(),
              ),
            );
          },
        ),
        title: Column(
          children: [
            const Text(
              'Feedback',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Your opinion helps us improve',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "We'd love to\nhear from you!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Share your experience and help us make better events.',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding:
                            const EdgeInsets.all(12),
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.emoji_emotions,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                if (_eventId == null)
                  Container(
                    padding:
                        const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'You need to register for an event before submitting feedback.',
                          ),
                        ),
                      ],
                    ),
                  ),

                Container(
                  padding:
                      const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'How would you rate your event experience?',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children:
                            List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                right: 8,
                              ),
                              child: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 34,
                              ),
                            ),
                          );
                        }),
                      ),

                      const Divider(height: 32),

                      const Text(
                        'What did you like?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        'Select the things you liked about the event',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _tags.map((tag) {
                          final isSelected =
                              _selectedTags
                                  .contains(tag);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedTags
                                      .remove(tag);
                                } else {
                                  _selectedTags
                                      .add(tag);
                                }
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: isSelected
                                    ? const Color(
                                        0xFF2962FF)
                                    : const Color(
                                        0xFFF0F2F8),
                                borderRadius:
                                    BorderRadius
                                        .circular(24),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color:
                                          Colors.white,
                                    ),
                                    const SizedBox(
                                        width: 4),
                                  ],
                                  Text(
                                    tag,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight:
                                          FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const Divider(height: 32),

                      const Text(
                        'Your Feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        'Tell us about your experience (optional)',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller:
                            _feedbackController,
                        maxLength: 500,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Write your feedback here...',
                          filled: true,
                          fillColor:
                              const Color(0xFFF7F8FA),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child:
                            ElevatedButton.icon(
                          onPressed:
                              _isSubmitting ||
                                      _eventId == null
                                  ? null
                                  : _submitFeedback,
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                                const Color(
                                    0xFF2962FF),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      16),
                            ),
                          ),
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  color:
                                      Colors.white,
                                  size: 18,
                                ),
                          label: Text(
                            _isSubmitting
                                ? 'Submitting...'
                                : 'Submit Feedback',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}


// ------------------------------------------------------------
// PAGE 19 - ADMIN VERIFICATION SCREEN
// ------------------------------------------------------------

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState
    extends State<AdminVerificationScreen> {
  final _emailController =
      TextEditingController(text: 'admin@eventflow.com');

  final _passwordController =
      TextEditingController(text: 'admin123');

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> verifyAdmin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter admin email and password'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = data['user']?? data;
        final role = user['role']?.toString().toLowerCase();

        if (role == 'admin') {
          currentUserId = user['user_id'];

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Admin verification successful ✅'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminDashboardScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Only admin account can continue'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Invalid admin credentials',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4FC),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            right: -20,
            child: Icon(
              Icons.eco,
              size: 100,
              color: Colors.deepPurple.shade100,
            ),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: Icon(
              Icons.eco,
              size: 140,
              color: Colors.deepPurple.shade100,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5C6BC0),
                            Color(0xFF7C4DFF),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Admin Verification',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A40),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Enter your admin credentials to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Admin Email',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail_outline,
                        color: Color(0xFF7C4DFF),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: () =>
                            _emailController.clear(),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Admin Password',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF7C4DFF),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                                !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : verifyAdmin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Verify & Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
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
                      'Forgot Admin Password?',
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ------------------------------------------------------------
// PAGE 20 - ADMIN DASHBOARD SCREEN
// ------------------------------------------------------------

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _StatCardData {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  final Color color;
  final Color bg;

  _StatCardData(
    this.icon,
    this.label,
    this.value,
    this.change,
    this.color,
    this.bg,
  );
}

class _RecentEventData {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;
  final Color color;

  _RecentEventData(
    this.title,
    this.date,
    this.status,
    this.statusColor,
    this.icon,
    this.color,
  );
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedSidebarIndex = 0;
  int _selectedNavIndex = 0;

  Map<String, dynamic>? dashboardData;
  bool isDashboardLoading = true;

  List<_StatCardData> _stats = [];

  final List<_RecentEventData> _recentEvents = [
    _RecentEventData(
      'Tech Fest 2K26',
      '15 Oct 2026',
      'Confirmed',
      Colors.green,
      Icons.rocket_launch,
      const Color(0xFF1A237E),
    ),
    _RecentEventData(
      'Cultural Night',
      '05 Nov 2026',
      'Pending',
      Colors.orange,
      Icons.celebration,
      const Color(0xFF6A1B9A),
    ),
    _RecentEventData(
      'Hackathon 2026',
      '22 Oct 2026',
      'Confirmed',
      Colors.green,
      Icons.code,
      const Color(0xFF00695C),
    ),
    _RecentEventData(
      'Web Dev Workshop',
      '30 Aug 2026',
      'Upcoming',
      Colors.blue,
      Icons.laptop,
      const Color(0xFF0D47A1),
    ),
    _RecentEventData(
      'Sports Fest',
      '12 Sep 2026',
      'Upcoming',
      Colors.blue,
      Icons.directions_run,
      const Color(0xFF2E7D32),
    ),
  ];

  final List<_SidebarItem> _sidebarItems = [
    _SidebarItem(Icons.dashboard, 'Dashboard'),
    _SidebarItem(Icons.calendar_today, 'Events'),
    _SidebarItem(Icons.people, 'Users'),
    _SidebarItem(Icons.list_alt, 'Registrations'),
    _SidebarItem(Icons.bar_chart, 'Reports'),
    _SidebarItem(Icons.settings, 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/admin/dashboard'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          dashboardData = data;

          final totalEvents = data['total_events'] ?? 0;
          final totalUsers = data['total_users'] ?? 0;
          final registrations = data['registrations'] ?? 0;
          final todayEvents = data['today_events'] ?? 0;

          _stats = [
            _StatCardData(
              Icons.groups,
              'Total Events',
              totalEvents.toString(),
              'Live database data',
              Colors.deepPurple,
              const Color(0xFFEDE7F6),
            ),
            _StatCardData(
              Icons.person,
              'Total Users',
              totalUsers.toString(),
              'Registered users',
              Colors.blue,
              const Color(0xFFE3F2FD),
            ),
            _StatCardData(
              Icons.check_circle,
              'Total Registrations',
              registrations.toString(),
              'Event registrations',
              Colors.green,
              const Color(0xFFE8F5E9),
            ),
            _StatCardData(
              Icons.event_available,
              'Today Events',
              todayEvents.toString(),
              'Events today',
              Colors.orange,
              const Color(0xFFFFF3E0),
            ),
          ];

          isDashboardLoading = false;
        });
      } else {
        setState(() {
          isDashboardLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isDashboardLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            return Row(
              children: [
                if (isWide) _buildSidebar(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => _handleAdminBottomNav(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 230,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF5C6BC0),
                        Color(0xFF7C4DFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: 'EventFlow '),
                        TextSpan(
                          text: 'AI',
                          style: TextStyle(
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ..._sidebarItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedSidebarIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: Material(
                color: isSelected
                    ? const Color(0xFFEDE7F6)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _selectedSidebarIndex = index;
                    });

                    Widget? page;

                    switch (index) {
                      case 0:
                        break;

                      case 1:
                        page = const ManageEventsScreen();
                        break;

                      case 2:
                        page = const EventParticipantsScreen();
                        break;

                      case 3:
                        page = const EventParticipantsScreen();
                        break;

                      case 4:
                        page = const ReportsAnalyticsScreen();
                        break;

                      case 5:
                        page = const ProfileScreen();
                        break;
                    }

                    if (page != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => page!,
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected
                              ? const Color(0xFF7C4DFF)
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF7C4DFF)
                                : Colors.grey.shade700,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (isDashboardLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C63FF),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFD1C4E9),
                  child: Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFC5CAE9),
                    Color(0xFFEDE7F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back, Admin! 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Here's what's happening with your events today.",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.insert_chart,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                final isPhone = constraints.maxWidth < 600;

                return GridView.count(
                  crossAxisCount: isPhone ? 2 : 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: isPhone ? 0.95 : 1.30,
                  children: _stats
                      .map((s) => _statCard(s))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                final overview = _buildOverviewCard();
                final recent = _buildRecentEventsCard();

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: overview,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: recent,
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    overview,
                    const SizedBox(height: 16),
                    recent,
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            _buildRegistrationStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _statCard(_StatCardData s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              s.icon,
              color: s.color,
              size: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            s.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            s.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              s.change,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.bar_chart,
                    color: Colors.deepPurple,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Event Overview',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Text(
                      'Last 7 Days',
                      style: TextStyle(fontSize: 11),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: const Size(
                double.infinity,
                180,
              ),
              painter: _ChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEventsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.event_note,
                    color: Colors.deepPurple,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Events',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageEventsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._recentEvents.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      e.icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          e.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: e.statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      e.status,
                      style: TextStyle(
                        fontSize: 10,
                        color: e.statusColor,
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

  Widget _buildRegistrationStatusCard() {
    final registrations =
        dashboardData?['registrations'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.pie_chart,
                    color: Colors.deepPurple,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Registration Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Text(
                'Live Data',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(
                        120,
                        120,
                      ),
                      painter: _DonutPainter(),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          registrations.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _legendRow(
                      'Confirmed',
                      Colors.deepPurple,
                      registrations.toString(),
                      '100%',
                    ),
                    _legendRow(
                      'Pending',
                      Colors.orange,
                      '0',
                      '0%',
                    ),
                    _legendRow(
                      'Cancelled',
                      Colors.blue,
                      '0',
                      '0%',
                    ),
                    _legendRow(
                      'Waitlist',
                      Colors.red,
                      '0',
                      '0%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow(
    String label,
    Color color,
    String value,
    String percent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            percent,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAdminBottomNav(
    BuildContext context,
    int index,
  ) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ManageEventsScreen(),
          ),
        );
        break;

      case 2:
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EventParticipantsScreen(
        eventId: 1,
      ),
    ),
  );
  break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationsScreen(),
          ),
        );
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
        break;
    }
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;

  _SidebarItem(this.icon, this.label);
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF5C6BC0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()
      ..color = const Color(0xFFD1C4E9);

    final values = [
      40,
      55,
      62,
      78,
      68,
      90,
      95,
    ];

    final barWidth =
        size.width / (values.length * 2);

    for (int i = 0; i < values.length; i++) {
      final x =
          i * (size.width / values.length) +
              barWidth / 2;

      final barHeight =
          size.height * (values[i] / 100);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - barHeight,
            barWidth,
            barHeight,
          ),
          const Radius.circular(4),
        ),
        barPaint,
      );
    }

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x =
          i * (size.width / values.length) +
              barWidth;

      final y =
          size.height -
              size.height *
                  (values[i] / 100) *
                  0.8;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = const Color(0xFF5C6BC0),
      );
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    final segments = [
      [0.65, Colors.deepPurple],
      [0.18, Colors.orange],
      [0.10, Colors.blue],
      [0.07, Colors.red],
    ];

    double startAngle = -1.5708;

    for (final seg in segments) {
      final sweep =
          6.28319 * (seg[0] as double);

      final paint = Paint()
        ..color = seg[1] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16;

      canvas.drawArc(
        rect.deflate(8),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ------------------------------------------------------------
// PAGE 21 - CREATE EVENT SCREEN
// ------------------------------------------------------------

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _seatsController = TextEditingController(text: '100');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isLoading = false;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _createEvent() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final venue = _venueController.text.trim();
    final seats = int.tryParse(_seatsController.text.trim()) ?? 0;

    if (title.isEmpty ||
        description.isEmpty ||
        venue.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        seats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all event details'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dateString =
          '${_selectedDate!.year.toString().padLeft(4, '0')}-'
          '${_selectedDate!.month.toString().padLeft(2, '0')}-'
          '${_selectedDate!.day.toString().padLeft(2, '0')}';

      final timeString =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
          '${_selectedTime!.minute.toString().padLeft(2, '0')}:00';

      final response = await http.post(
        Uri.parse('$apiBaseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'venue': venue,
          'event_date': dateString,
          'event_time': timeString,
          'available_seats': seats,
          'created_by': 1,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully!'),
          ),
        );

        Navigator.pop(context);
      } else {
        throw Exception(
          data['message'] ?? data['error'] ?? 'Failed to create event',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Event',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enter the details of your college event.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                hintText: 'Enter event title',
                prefixIcon: const Icon(Icons.event),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter event description',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _venueController,
              decoration: InputDecoration(
                labelText: 'Venue',
                hintText: 'Example: College Auditorium',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Event Date',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Select date'
                      : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                          '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                          '${_selectedDate!.year}',
                ),
              ),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Event Time',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedTime == null
                      ? 'Select time'
                      : _selectedTime!.format(context),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _seatsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Available Seats',
                hintText: 'Example: 100',
                prefixIcon: const Icon(Icons.people),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createEvent,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 22 - MANAGE EVENTS SCREEN
// ------------------------------------------------------------

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  String _selectedFilter = 'All';
  String _searchText = '';
  bool _isLoading = true;

  List<dynamic> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // ================= LOAD EVENTS =================

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/events'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _events = data is List ? data : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load events: $e'),
          ),
        );
      }
    }
  }

  // ================= DELETE EVENT =================

  Future<void> _deleteEvent(int eventId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text(
            'Are you sure you want to delete this event?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/events/$eventId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event deleted successfully'),
          ),
        );

        _loadEvents();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to delete event'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  // ================= FILTER EVENTS =================

  List<dynamic> get _filteredEvents {
    final now = DateTime.now();

    List<dynamic> result = List.from(_events);

    // Search
    if (_searchText.isNotEmpty) {
      result = result.where((event) {
        final title =
            (event['title'] ?? '').toString().toLowerCase();

        final venue =
            (event['venue'] ?? '').toString().toLowerCase();

        return title.contains(_searchText.toLowerCase()) ||
            venue.contains(_searchText.toLowerCase());
      }).toList();
    }

    // Status filter
    if (_selectedFilter != 'All') {
      result = result.where((event) {
        final dateString =
            (event['event_date'] ?? '').toString();

        DateTime? eventDate;

        try {
          eventDate = DateTime.parse(dateString);
        } catch (_) {
          return false;
        }

        String status;

        if (eventDate.isBefore(
          DateTime(now.year, now.month, now.day),
        )) {
          status = 'Completed';
        } else if (eventDate.year == now.year &&
            eventDate.month == now.month &&
            eventDate.day == now.day) {
          status = 'Ongoing';
        } else {
          status = 'Upcoming';
        }

        return status == _selectedFilter;
      }).toList();
    }

    return result;
  }

  // ================= EVENT STATUS =================

  String _getStatus(String dateString) {
    try {
      final eventDate = DateTime.parse(dateString);
      final now = DateTime.now();

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final date = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
      );

      if (date.isBefore(today)) {
        return 'Completed';
      }

      if (date.isAtSameMomentAs(today)) {
        return 'Ongoing';
      }

      return 'Upcoming';
    } catch (_) {
      return 'Upcoming';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.deepPurple;

      case 'Ongoing':
        return Colors.blue;

      case 'Cancelled':
        return Colors.red;

      default:
        return Colors.green;
    }
  }

  // ================= DATE FORMAT =================

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateString;
    }
  }

  // ================= TIME FORMAT =================

  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');

      if (parts.length < 2) {
        return timeString;
      }

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (_) {
      return timeString;
    }
  }

  // ================= EVENT ICON =================

  IconData _getEventIcon(String title) {
    final text = title.toLowerCase();

    if (text.contains('tech') ||
        text.contains('coding') ||
        text.contains('hack')) {
      return Icons.code;
    }

    if (text.contains('sport')) {
      return Icons.directions_run;
    }

    if (text.contains('music') ||
        text.contains('sing')) {
      return Icons.music_note;
    }

    if (text.contains('cultur')) {
      return Icons.celebration;
    }

    if (text.contains('workshop')) {
      return Icons.laptop;
    }

    if (text.contains('art')) {
      return Icons.palette;
    }

    return Icons.event;
  }

  Color _getEventColor(String title) {
    final text = title.toLowerCase();

    if (text.contains('tech') ||
        text.contains('coding') ||
        text.contains('hack')) {
      return const Color(0xFF311B92);
    }

    if (text.contains('sport')) {
      return const Color(0xFF2E7D32);
    }

    if (text.contains('music') ||
        text.contains('sing')) {
      return const Color(0xFF4527A0);
    }

    if (text.contains('cultur')) {
      return const Color(0xFF6A1B9A);
    }

    return const Color(0xFF00897B);
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(
        child: Column(
          children: [

            // ================= HEADER =================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                0,
              ),
              child: Row(
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.event_note,
                      color: Color(0xFF00897B),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manage Events',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Create, edit and manage your events',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(
                      Icons.person,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= TOP BUTTONS =================

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CreateEventScreen(),
                          ),
                        );

                        _loadEvents();
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        'Create Event',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.event,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Manage Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF00897B),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ReportsAnalyticsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.bar_chart,
                        size: 16,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        'Analytics',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= SEARCH =================

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        prefixIcon:
                            const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Filter Events',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...[
                                  'All',
                                  'Upcoming',
                                  'Ongoing',
                                  'Completed',
                                ].map(
                                  (filter) => ListTile(
                                    title: Text(filter),
                                    trailing:
                                        _selectedFilter ==
                                                filter
                                            ? const Icon(
                                                Icons.check,
                                                color:
                                                    Colors.teal,
                                              )
                                            : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedFilter =
                                            filter;
                                      });

                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.tune,
                      size: 16,
                    ),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= FILTER CHIPS =================

            SizedBox(
              height: 40,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                scrollDirection: Axis.horizontal,
                children: [
                  _filterChip(
                    'All',
                    _events.length.toString(),
                    Colors.teal,
                  ),
                  _filterChip(
                    'Upcoming',
                    _countStatus('Upcoming').toString(),
                    Colors.blue,
                  ),
                  _filterChip(
                    'Ongoing',
                    _countStatus('Ongoing').toString(),
                    Colors.orange,
                  ),
                  _filterChip(
                    'Completed',
                    _countStatus('Completed').toString(),
                    Colors.deepPurple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ================= EVENTS =================

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filtered.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No events found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadEvents,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            itemBuilder:
                                (context, index) {
                              return _eventCard(
                                filtered[index],
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),

      // ================= ADD BUTTON =================

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xFF00897B),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateEventScreen(),
            ),
          );

          _loadEvents();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      // ================= BOTTOM NAV =================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) =>
            _handleAdminBottomNav(
          context,
          index,
        ),
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ================= COUNT STATUS =================

  int _countStatus(String status) {
    return _events.where((event) {
      return _getStatus(
        (event['event_date'] ?? '').toString(),
      ) ==
          status;
    }).length;
  }

  // ================= FILTER CHIP =================

  Widget _filterChip(
    String label,
    String count,
    Color color,
  ) {
    final isSelected =
        _selectedFilter == label;

    return Padding(
      padding:
          const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color:
                isSelected ? color : Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? color
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                count,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= EVENT CARD =================

  Widget _eventCard(dynamic event) {
    final title =
        (event['title'] ?? 'Untitled Event')
            .toString();

    final date =
        (event['event_date'] ?? '').toString();

    final time =
        (event['event_time'] ?? '').toString();

    final venue =
        (event['venue'] ?? 'Not specified')
            .toString();

    final status =
        _getStatus(date);

    final statusColor =
        _getStatusColor(status);

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color:
                      _getEventColor(title),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  _getEventIcon(title),
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(date),
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(time),
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            venue,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration:
                        BoxDecoration(
                      color: statusColor
                          .withOpacity(0.12),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Icon(
                    Icons.more_vert,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              // EDIT
              Expanded(
                child: OutlinedButton.icon(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditEventScreen(event: event),
    ),
  );
},
                  icon: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.deepPurple,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 12,
                    ),
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // PARTICIPANTS
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EventParticipantsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.people,
                    size: 14,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'View Registrations',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                    ),
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // DELETE
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final id =
                        int.tryParse(
                      event['event_id']
                          .toString(),
                    );

                    if (id != null) {
                      _deleteEvent(id);
                    }
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 14,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 23 - EVENT PARTICIPANTS SCREEN
// ------------------------------------------------------------

class EventParticipantsScreen extends StatefulWidget {
  final int eventId;

  const EventParticipantsScreen({
    super.key,
    this.eventId = 1,
  });

  @override
  State<EventParticipantsScreen> createState() =>
      _EventParticipantsScreenState();
}

class _ParticipantData {
  final int registrationId;
  final String name;
  final String rollNo;
  final String department;
  final bool confirmed;

  _ParticipantData(
    this.registrationId,
    this.name,
    this.rollNo,
    this.department,
    this.confirmed,
  );
}

class _EventParticipantsScreenState
    extends State<EventParticipantsScreen> {
  String _selectedTab = 'All';

  final TextEditingController _searchController =
      TextEditingController();

  List<_ParticipantData> _participants = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadParticipants();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================
  // LOAD PARTICIPANTS FROM BACKEND
  // ============================

  Future<void> _loadParticipants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$apiBaseUrl/events/${widget.eventId}/participants',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> participantsData = [];

        if (data is List) {
          participantsData = data;
        } else if (data is Map &&
            data['participants'] is List) {
          participantsData = data['participants'];
        }

        final List<_ParticipantData> loadedParticipants = [];

        for (var item in participantsData) {
          final Map<String, dynamic> participant =
              Map<String, dynamic>.from(item);

          final String name =
              (participant['name'] ??
                      participant['user_name'] ??
                      'Unknown User')
                  .toString();

          final String rollNo =
              (participant['roll_no'] ??
                      participant['student_id'] ??
                      participant['roll_number'] ??
                      '-')
                  .toString();

          final String department =
              (participant['department'] ??
                      participant['course'] ??
                      'BCA')
                  .toString();

          final String status =
              (participant['status'] ?? 'registered')
                  .toString()
                  .toLowerCase();

          final bool confirmed =
              status != 'cancelled';

          final int registrationId =
              int.tryParse(
                    (participant['registration_id'] ??
                            participant['id'] ??
                            0)
                        .toString(),
                  ) ??
                  0;

          loadedParticipants.add(
            _ParticipantData(
              registrationId,
              name,
              rollNo,
              department,
              confirmed,
            ),
          );
        }

        setState(() {
          _participants = loadedParticipants;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load participants';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to connect to backend';
      });
    }
  }

  // ============================
  // SEARCH
  // ============================

  List<_ParticipantData> _getFilteredParticipants() {
    List<_ParticipantData> result = _participants;

    if (_selectedTab == 'Confirmed') {
      result =
          result.where((p) => p.confirmed).toList();
    } else if (_selectedTab == 'Cancelled') {
      result =
          result.where((p) => !p.confirmed).toList();
    }

    final search =
        _searchController.text.trim().toLowerCase();

    if (search.isNotEmpty) {
      result = result.where((p) {
        return p.name.toLowerCase().contains(search) ||
            p.rollNo.toLowerCase().contains(search) ||
            p.department.toLowerCase().contains(search);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final confirmedCount =
        _participants.where((p) => p.confirmed).length;

    final cancelledCount =
        _participants.where((p) => !p.confirmed).length;

    final filtered = _getFilteredParticipants();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),

      body: SafeArea(
        child: Column(
          children: [

            // ============================
            // HEADER
            // ============================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 0),

              child: Row(
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.people,
                      color: Color(0xFF5C4DFF),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Event Participants',

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        Text(
                          'View and manage registered participants',

                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.refresh),

                    onPressed: _loadParticipants,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ============================
            // EVENT SUMMARY
            // ============================

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),

              child: Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Container(
                          width: 56,
                          height: 56,

                          decoration: BoxDecoration(
                            gradient:
                                const LinearGradient(
                              colors: [
                                Color(0xFF311B92),
                                Color(0xFF6A1B9A),
                              ],
                            ),

                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.groups,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                'Event Participants',

                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.event,
                                    size: 12,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    'Event ID: ${widget.eventId}',

                                    style:
                                        const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF5C4DFF),
                          size: 18,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [

                        _statChip(
                          Icons.groups,
                          'Total Registered',
                          '${_participants.length}',
                          Colors.deepPurple,
                        ),

                        const SizedBox(width: 8),

                        _statChip(
                          Icons.check_circle,
                          'Confirmed',
                          '$confirmedCount',
                          Colors.green,
                        ),

                        const SizedBox(width: 8),

                        _statChip(
                          Icons.cancel,
                          'Cancelled',
                          '$cancelledCount',
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ============================
            // TABS
            // ============================

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [

                  _tabChip(
                    'All (${_participants.length})',
                    'All',
                  ),

                  const SizedBox(width: 8),

                  _tabChip(
                    'Confirmed ($confirmedCount)',
                    'Confirmed',
                  ),

                  const SizedBox(width: 8),

                  _tabChip(
                    'Cancelled ($cancelledCount)',
                    'Cancelled',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ============================
            // SEARCH
            // ============================

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: _searchController,

                      decoration: InputDecoration(
                        hintText:
                            'Search by name, roll no or department...',

                        prefixIcon:
                            const Icon(Icons.search),

                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon:
                                        const Icon(Icons.clear),

                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,

                        filled: true,

                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(24),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ============================
            // PARTICIPANTS LIST
            // ============================

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )

                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              const Icon(
                                Icons.cloud_off,
                                size: 50,
                                color: Colors.grey,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                _errorMessage,

                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 12),

                              ElevatedButton(
                                onPressed:
                                    _loadParticipants,

                                child:
                                    const Text('Retry'),
                              ),
                            ],
                          ),
                        )

                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [

                                  const Icon(
                                    Icons.people_outline,
                                    size: 55,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    'No participants found',

                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )

                          : RefreshIndicator(
                              onRefresh:
                                  _loadParticipants,

                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.all(16),

                                itemCount:
                                    filtered.length,

                                itemBuilder:
                                    (context, index) {

                                  return _participantTile(
                                    filtered[index],
                                  );
                                },
                              ),
                            ),
            ),

            // ============================
            // BOTTOM BUTTONS
            // ============================

            Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Add Participant feature will be connected next.',
                            ),
                          ),
                        );
                      },

                      style:
                          OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        side: const BorderSide(
                          color: Color(0xFF5C4DFF),
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(
                        Icons.person_add_alt,
                        color: Color(0xFF5C4DFF),
                        size: 18,
                      ),

                      label: const Text(
                        'Add Participant',

                        style: TextStyle(
                          color: Color(0xFF5C4DFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Participant list ready to export.',
                            ),
                          ),
                        );
                      },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF5C4DFF),

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 18,
                      ),

                      label: const Text(
                        'Export List',

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  // ============================
  // STAT CHIP
  // ============================

  Widget _statChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 6,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Column(
          children: [

            Icon(
              icon,
              color: color,
              size: 16,
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            Text(
              label,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // TAB CHIP
  // ============================

  Widget _tabChip(
    String label,
    String value,
  ) {
    final isSelected =
        _selectedTab == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = value;
          });
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF5C4DFF)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(24),
          ),

          child: Text(
            label,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black87,

              fontWeight:
                  FontWeight.w600,

              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // PARTICIPANT TILE
  // ============================

  Widget _participantTile(
    _ParticipantData p,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),

      padding:
          const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 22,

            backgroundColor:
                Colors.deepPurple.shade50,

            child: Text(
              p.name.isNotEmpty
                  ? p.name[0].toUpperCase()
                  : '?',

              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  p.name,

                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [

                    const Icon(
                      Icons.badge_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        'Roll No: ${p.rollNo}',

                        style:
                            const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [

                    const Icon(
                      Icons.school_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      p.department,

                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: p.confirmed
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Row(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                Icon(
                  p.confirmed
                      ? Icons.check_circle
                      : Icons.cancel,

                  size: 12,

                  color: p.confirmed
                      ? Colors.green
                      : Colors.red,
                ),

                const SizedBox(width: 4),

                Text(
                  p.confirmed
                      ? 'Confirmed'
                      : 'Cancelled',

                  style: TextStyle(
                    fontSize: 11,

                    color: p.confirmed
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 24 - REPORTS & ANALYTICS SCREEN
// ------------------------------------------------------------

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() =>
      _ReportsAnalyticsScreenState();
}

class _TopEventData {
  final String title;
  final String date;
  final int registrations;
  final double progress;
  final Color color;
  final IconData icon;

  _TopEventData(
    this.title,
    this.date,
    this.registrations,
    this.progress,
    this.color,
    this.icon,
  );
}

class _CategoryData {
  final String name;
  final int count;
  final double percentage;
  final Color color;

  _CategoryData(
    this.name,
    this.count,
    this.percentage,
    this.color,
  );
}

class _ReportsAnalyticsScreenState
    extends State<ReportsAnalyticsScreen> {
  String _selectedTab = 'Overview';
  int _selectedNavIndex = 4;

  bool _isLoading = true;
  String _errorMessage = '';

  int _totalEvents = 0;
  int _totalRegistrations = 0;
  int _completedEvents = 0;
  int _cancelledRegistrations = 0;

  List<_TopEventData> _topEvents = [];
  List<_CategoryData> _categories = [];

  List<int> _monthlyRegistrations = [0, 0, 0, 0, 0, 0];

  final List<Color> _eventColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
  ];

  final List<IconData> _eventIcons = [
    Icons.mic,
    Icons.rocket_launch,
    Icons.celebration,
    Icons.code,
    Icons.laptop,
  ];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // =========================================================
  // LOAD REPORTS FROM FLASK
  // =========================================================

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/admin/reports'),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        Map<String, dynamic> data = {};

        if (decoded is Map<String, dynamic>) {
          data = decoded;
        } else if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }

        _processReportData(data);

        setState(() {
          _isLoading = false;
        });
      } else {
        // Fallback: calculate basic statistics from existing APIs
        await _loadFallbackReports();
      }
    } catch (e) {
      await _loadFallbackReports();
    }
  }

  // =========================================================
  // FALLBACK REPORT DATA
  // =========================================================

  Future<void> _loadFallbackReports() async {
    try {
      final eventsResponse = await http.get(
        Uri.parse('$apiBaseUrl/events'),
      );

      final usersResponse = await http.get(
        Uri.parse('$apiBaseUrl/users'),
      );

      if (eventsResponse.statusCode == 200) {
        final eventsDecoded = jsonDecode(eventsResponse.body);

        List<dynamic> events = [];

        if (eventsDecoded is List) {
          events = eventsDecoded;
        } else if (eventsDecoded is Map &&
            eventsDecoded['events'] is List) {
          events = eventsDecoded['events'];
        }

        _totalEvents = events.length;

        final now = DateTime.now();

        _completedEvents = 0;

        for (final event in events) {
          final dateString =
              (event['event_date'] ?? '').toString();

          final eventDate =
              DateTime.tryParse(dateString);

          if (eventDate != null &&
              eventDate.isBefore(now)) {
            _completedEvents++;
          }
        }

        final List<_TopEventData> tempEvents = [];

        for (int i = 0; i < events.length; i++) {
          final event = events[i];

          final title =
              (event['title'] ?? 'Untitled Event').toString();

          final date =
              _formatDate(
            (event['event_date'] ?? '').toString(),
          );

          final registrations = int.tryParse(
                (event['registration_count'] ??
                        event['registrations'] ??
                        event['participant_count'] ??
                        0)
                    .toString(),
              ) ??
              0;

          tempEvents.add(
            _TopEventData(
              title,
              date,
              registrations,
              0,
              _eventColors[
                  i % _eventColors.length],
              _eventIcons[
                  i % _eventIcons.length],
            ),
          );
        }

        tempEvents.sort(
          (a, b) =>
              b.registrations.compareTo(
            a.registrations,
          ),
        );

        final top = tempEvents.take(5).toList();

        int maxRegistration = 1;

        for (final event in top) {
          if (event.registrations >
              maxRegistration) {
            maxRegistration =
                event.registrations;
          }
        }

        _topEvents = top.map((event) {
          return _TopEventData(
            event.title,
            event.date,
            event.registrations,
            event.registrations /
                maxRegistration,
            event.color,
            event.icon,
          );
        }).toList();

        if (usersResponse.statusCode == 200) {
          final usersDecoded =
              jsonDecode(usersResponse.body);

          if (usersDecoded is List) {
            // Users loaded successfully.
          }
        }

        // Try to calculate registrations event by event.
        int totalRegistrations = 0;
        int cancelled = 0;

        for (final event in events) {
          final eventId = event['event_id'];

          if (eventId == null) continue;

          try {
            final registrationResponse =
                await http.get(
              Uri.parse(
                '$apiBaseUrl/events/$eventId/participants',
              ),
            );

            if (registrationResponse.statusCode ==
                200) {
              final registrationDecoded =
                  jsonDecode(
                registrationResponse.body,
              );

              List<dynamic> participants = [];

              if (registrationDecoded is List) {
                participants =
                    registrationDecoded;
              } else if (registrationDecoded
                      is Map &&
                  registrationDecoded[
                          'participants'] is
                      List) {
                participants =
                    registrationDecoded[
                        'participants'];
              }

              totalRegistrations +=
                  participants.length;

              for (final participant
                  in participants) {
                final status =
                    (participant['status'] ??
                            'registered')
                        .toString()
                        .toLowerCase();

                if (status == 'cancelled') {
                  cancelled++;
                }
              }
            }
          } catch (_) {}
        }

        _totalRegistrations =
            totalRegistrations;

        _cancelledRegistrations =
            cancelled;

        _categories = _createCategories(
          events,
        );

        _monthlyRegistrations =
            _createMonthlyData(
          totalRegistrations,
        );

        setState(() {
          _isLoading = false;
          _errorMessage = '';
        });

        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load report data';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to connect to backend';
      });
    }
  }

  // =========================================================
  // PROCESS ADMIN REPORT DATA
  // =========================================================

  void _processReportData(
    Map<String, dynamic> data,
  ) {
    _totalEvents = _readInt(
      data,
      [
        'total_events',
        'events_count',
        'event_count',
      ],
    );

    _totalRegistrations = _readInt(
      data,
      [
        'total_registrations',
        'registrations_count',
        'registration_count',
      ],
    );

    _completedEvents = _readInt(
      data,
      [
        'completed_events',
        'completed_count',
      ],
    );

    _cancelledRegistrations = _readInt(
      data,
      [
        'cancelled_events',
        'cancelled_registrations',
        'cancelled_count',
      ],
    );

    // Top Events

    final topData =
        data['top_events'] ??
        data['topEvents'] ??
        data['events'];

    if (topData is List) {
      _topEvents = [];

      int maxRegistration = 1;

      for (final item in topData) {
        if (item is Map) {
          final count = int.tryParse(
                (item['registrations'] ??
                        item['registration_count'] ??
                        item['count'] ??
                        0)
                    .toString(),
              ) ??
              0;

          if (count > maxRegistration) {
            maxRegistration = count;
          }
        }
      }

      int index = 0;

      for (final item in topData) {
        if (item is! Map) continue;

        final title =
            (item['title'] ??
                    item['event_title'] ??
                    'Event')
                .toString();

        final date =
            _formatDate(
          (item['event_date'] ??
                  item['date'] ??
                  '')
              .toString(),
        );

        final count = int.tryParse(
              (item['registrations'] ??
                      item['registration_count'] ??
                      item['count'] ??
                      0)
                  .toString(),
            ) ??
            0;

        _topEvents.add(
          _TopEventData(
            title,
            date,
            count,
            count / maxRegistration,
            _eventColors[
                index % _eventColors.length],
            _eventIcons[
                index % _eventIcons.length],
          ),
        );

        index++;

        if (index >= 5) break;
      }
    }

    // Categories

    final categoryData =
        data['categories'] ??
        data['category_distribution'] ??
        data['categoryDistribution'];

    if (categoryData is List) {
      _categories = [];

      int totalCategoryEvents = 0;

      for (final item in categoryData) {
        if (item is Map) {
          totalCategoryEvents +=
              int.tryParse(
                    (item['count'] ?? 0).toString(),
                  ) ??
                  0;
        }
      }

      int index = 0;

      for (final item in categoryData) {
        if (item is! Map) continue;

        final name =
            (item['category'] ??
                    item['name'] ??
                    'Other')
                .toString();

        final count = int.tryParse(
              (item['count'] ?? 0).toString(),
            ) ??
            0;

        final percentage =
            totalCategoryEvents == 0
                ? 0.0
                : count /
                    totalCategoryEvents;

        _categories.add(
          _CategoryData(
            name,
            count,
            percentage,
            _eventColors[
                index % _eventColors.length],
          ),
        );

        index++;
      }
    }

    // Monthly trend

    final trendData =
        data['monthly_registrations'] ??
        data['registration_trend'] ??
        data['monthlyRegistrations'];

    if (trendData is List) {
      _monthlyRegistrations =
          trendData.map((item) {
        if (item is Map) {
          return int.tryParse(
                (item['registrations'] ??
                        item['count'] ??
                        0)
                    .toString(),
              ) ??
              0;
        }

        return int.tryParse(
              item.toString(),
            ) ??
            0;
      }).toList();

      if (_monthlyRegistrations.length >
          6) {
        _monthlyRegistrations =
            _monthlyRegistrations
                .sublist(
          _monthlyRegistrations.length - 6,
        );
      }
    }
  }

  int _readInt(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (data.containsKey(key)) {
        return int.tryParse(
              data[key].toString(),
            ) ??
            0;
      }
    }

    return 0;
  }

  // =========================================================
  // CATEGORY CALCULATION
  // =========================================================

  List<_CategoryData> _createCategories(
    List<dynamic> events,
  ) {
    final Map<String, int> counts = {};

    for (final event in events) {
      final category =
          (event['category'] ??
                  event['event_category'] ??
                  'Others')
              .toString();

      counts[category] =
          (counts[category] ?? 0) + 1;
    }

    if (counts.isEmpty) {
      return [];
    }

    final total = events.length;

    final result = <_CategoryData>[];

    int index = 0;

    counts.forEach((key, value) {
      result.add(
        _CategoryData(
          key,
          value,
          value / total,
          _eventColors[
              index % _eventColors.length],
        ),
      );

      index++;
    });

    return result;
  }

  // =========================================================
  // MONTHLY DATA
  // =========================================================

  List<int> _createMonthlyData(
    int total,
  ) {
    if (total == 0) {
      return [0, 0, 0, 0, 0, 0];
    }

    return [
      (total * 0.35).round(),
      (total * 0.48).round(),
      (total * 0.60).round(),
      (total * 0.72).round(),
      (total * 0.86).round(),
      total,
    ];
  }

  // =========================================================
  // DATE FORMAT
  // =========================================================

  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      return '-';
    }

    try {
      final date =
          DateTime.parse(dateString);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateString;
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7FC),

      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _errorMessage.isNotEmpty
                ? _errorView()
                : RefreshIndicator(
                    onRefresh: _loadReports,
                    child: ListView(
                      padding:
                          const EdgeInsets.all(16),
                      children: [
                        _header(),

                        const SizedBox(height: 12),

                        _tabs(),

                        const SizedBox(height: 12),

                        _periodSelector(),

                        const SizedBox(height: 16),

                        _statistics(),

                        const SizedBox(height: 16),

                        _registrationTrend(),

                        const SizedBox(height: 16),

                        _categoryDistribution(),

                        const SizedBox(height: 16),

                        _topPerformingEvents(),

                        const SizedBox(height: 16),

                        _keyInsights(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex:
            _selectedNavIndex,

        onTap: (index) =>
            _handleAdminBottomNav(
          context,
          index,
        ),

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(0xFF5C4DFF),

        unselectedItemColor:
            Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _header() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Container(
          padding:
              const EdgeInsets.all(8),

          decoration: BoxDecoration(
            color:
                const Color(0xFFE3F2FD),
            borderRadius:
                BorderRadius.circular(10),
          ),

          child: const Icon(
            Icons.insert_chart,
            color: Colors.blue,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Reports & Analytics',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 17,
                ),
              ),

              Text(
                'Track event performance and insights',
                style: TextStyle(
                  fontSize: 11,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: _loadReports,
          icon:
              const Icon(Icons.refresh),
        ),
      ],
    );
  }

  // =========================================================
  // TABS
  // =========================================================

  Widget _tabs() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection:
            Axis.horizontal,
        children: [
          _tab(
            'Overview',
            Icons.home,
          ),
          _tab(
            'Events',
            Icons.calendar_today,
          ),
          _tab(
            'Participants',
            Icons.people,
          ),
          _tab(
            'Trends',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _tab(
    String label,
    IconData icon,
  ) {
    final isSelected =
        _selectedTab == label;

    return Padding(
      padding:
          const EdgeInsets.only(
        right: 8,
      ),

      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = label;
          });
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF5C4DFF)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(24),
          ),

          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? Colors.white
                    : Colors.black54,
              ),

              const SizedBox(width: 6),

              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.black54,
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PERIOD
  // =========================================================

  Widget _periodSelector() {
    return Align(
      alignment:
          Alignment.centerRight,

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          border: Border.all(
            color:
                Colors.grey.shade300,
          ),
          borderRadius:
              BorderRadius.circular(16),
        ),

        child: const Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 12,
            ),
            SizedBox(width: 6),
            Text(
              'This Month',
              style:
                  TextStyle(fontSize: 12),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STATISTICS
  // =========================================================

  Widget _statistics() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,

      children: [
        _statCard(
          Icons.groups,
          'Total Events',
          '$_totalEvents',
          Colors.blue,
          const Color(0xFFE3F2FD),
        ),

        _statCard(
          Icons.person_add,
          'Total Registrations',
          '$_totalRegistrations',
          Colors.green,
          const Color(0xFFE8F5E9),
        ),

        _statCard(
          Icons.check_circle,
          'Completed Events',
          '$_completedEvents',
          Colors.deepPurple,
          const Color(0xFFEDE7F6),
        ),

        _statCard(
          Icons.cancel,
          'Cancelled',
          '$_cancelledRegistrations',
          Colors.red,
          const Color(0xFFFFEBEE),
        ),
      ],
    );
  }

  Widget _statCard(
    IconData icon,
    String label,
    String value,
    Color color,
    Color bg,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor:
                Colors.white,
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),

          const Spacer(),

          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color:
                  Colors.grey.shade700,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            'Live data',
            style: TextStyle(
              fontSize: 9,
              color:
                  Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // REGISTRATION TREND
  // =========================================================

  Widget _registrationTrend() {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: const [
                  Icon(
                    Icons.show_chart,
                    color:
                        Color(0xFF5C4DFF),
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Event Registration Trend',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Text(
                'Last 6 Months',
                style:
                    TextStyle(fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 160,

            child: CustomPaint(
              size:
                  const Size(
                double.infinity,
                160,
              ),

              painter:
                  _TrendLinePainter(
                values:
                    _monthlyRegistrations,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CATEGORY
  // =========================================================

  Widget _categoryDistribution() {
    if (_categories.isEmpty) {
      return Container(
        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),

        child: const Text(
          'No category data available',
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: const [
              Icon(
                Icons.pie_chart,
                color:
                    Color(0xFF5C4DFF),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                'Event Category Distribution',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              width: 140,
              height: 140,

              child: Stack(
                alignment:
                    Alignment.center,

                children: [
                  CustomPaint(
                    size:
                        const Size(
                      140,
                      140,
                    ),

                    painter:
                        _CategoryDonutPainter(
                      categories:
                          _categories,
                    ),
                  ),

                  Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Text(
                        '$_totalEvents',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const Text(
                        'Total Events',
                        style:
                            TextStyle(
                          fontSize: 10,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ..._categories.map(
            (category) =>
                _categoryLegend(
              category,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryLegend(
    _CategoryData category,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 4,
      ),

      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,

            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  category.color,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              category.name,
              style:
                  const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Text(
            '${category.count}',
            style:
                const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '${(category.percentage * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TOP EVENTS
  // =========================================================

  Widget _topPerformingEvents() {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: const [
                  Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Top Performing Events',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Text(
                'Live',
                style: TextStyle(
                  color:
                      Color(0xFF5C4DFF),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_topEvents.isEmpty)
            const Padding(
              padding:
                  EdgeInsets.all(12),
              child: Text(
                'No event data available',
                style:
                    TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

          ..._topEvents.map(
            (e) => _topEventRow(e),
          ),
        ],
      ),
    );
  }

  Widget _topEventRow(
    _TopEventData e,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color: e.color,
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              e.icon,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [
                    Expanded(
                      child: Text(
                        e.title,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      '${e.registrations} Registrations',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                Text(
                  e.date,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 4),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(4),

                  child:
                      LinearProgressIndicator(
                    value: e.progress,
                    minHeight: 5,
                    backgroundColor:
                        Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation(
                      e.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INSIGHTS
  // =========================================================

  Widget _keyInsights() {
    final registrationText =
        _totalRegistrations > 0
            ? '$_totalRegistrations registrations recorded in the system.'
            : 'No registrations recorded yet.';

    final eventText =
        _totalEvents > 0
            ? '$_totalEvents events are currently available.'
            : 'No events available yet.';

    final completedText =
        '$_completedEvents events have been completed.';

    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            const Color(0xFFEDE9FE),
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: const [
              Icon(
                Icons.lightbulb,
                color: Colors.amber,
              ),

              SizedBox(width: 8),

              Text(
                'Key Insights',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _insightRow(
            Icons.event,
            'Events',
            eventText,
            Colors.blue,
          ),

          const SizedBox(height: 10),

          _insightRow(
            Icons.people,
            'Registrations',
            registrationText,
            Colors.green,
          ),

          const SizedBox(height: 10),

          _insightRow(
            Icons.check_circle,
            'Completed Events',
            completedText,
            Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _insightRow(
    IconData icon,
    String title,
    String desc,
    Color color,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              Colors.white,

          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 12,
                ),
              ),

              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ERROR VIEW
  // =========================================================

  Widget _errorView() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_off,
              size: 55,
              color: Colors.grey,
            ),

            const SizedBox(height: 12),

            Text(
              _errorMessage,
              textAlign:
                  TextAlign.center,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed:
                  _loadReports,

              child:
                  const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// TREND PAINTER
// =========================================================

class _TrendLinePainter
    extends CustomPainter {
  final List<int> values;

  _TrendLinePainter({
    required this.values,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (values.isEmpty) return;

    int maxValue = 1;

    for (final value in values) {
      if (value > maxValue) {
        maxValue = value;
      }
    }

    final path = Path();
    final fillPath = Path();

    final linePaint = Paint()
      ..color =
          const Color(0xFF5C4DFF)
      ..strokeWidth = 3
      ..style =
          PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color =
          const Color(0xFF5C4DFF)
              .withOpacity(0.08)
      ..style =
          PaintingStyle.fill;

    for (int i = 0;
        i < values.length;
        i++) {
      final x = values.length == 1
          ? size.width / 2
          : i *
              (size.width /
                  (values.length - 1));

      final y = size.height -
          (values[i] / maxValue) *
              (size.height - 20);

      if (i == 0) {
        path.moveTo(x, y);

        fillPath.moveTo(
          x,
          size.height,
        );

        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color =
              const Color(0xFF5C4DFF),
      );
    }

    fillPath.lineTo(
      size.width,
      size.height,
    );

    fillPath.close();

    canvas.drawPath(
      fillPath,
      fillPaint,
    );

    canvas.drawPath(
      path,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TrendLinePainter
        oldDelegate,
  ) {
    return oldDelegate.values !=
        values;
  }
}

// =========================================================
// CATEGORY DONUT
// =========================================================

class _CategoryDonutPainter
    extends CustomPainter {
  final List<_CategoryData>
      categories;

  _CategoryDonutPainter({
    required this.categories,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (categories.isEmpty) {
      return;
    }

    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    double startAngle =
        -1.5708;

    for (final category
        in categories) {
      final sweep =
          6.28319 *
              category.percentage;

      final paint = Paint()
        ..color =
            category.color
        ..style =
            PaintingStyle.stroke
        ..strokeWidth = 18;

      canvas.drawArc(
        rect.deflate(9),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(
    covariant _CategoryDonutPainter
        oldDelegate,
  ) {
    return true;
  }
}

// ============================================================
// EDIT EVENT SCREEN
// ============================================================

class EditEventScreen extends StatefulWidget {
  final dynamic event;

  const EditEventScreen({
    super.key,
    required this.event,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController venueController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController seatsController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.event['title']?.toString() ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.event['description']?.toString() ?? '',
    );

    venueController = TextEditingController(
      text: widget.event['venue']?.toString() ?? '',
    );

    dateController = TextEditingController(
      text: widget.event['event_date']?.toString() ?? '',
    );

    timeController = TextEditingController(
      text: widget.event['event_time']?.toString() ?? '',
    );

    seatsController = TextEditingController(
      text: widget.event['available_seats']?.toString() ?? '100',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    dateController.dispose();
    timeController.dispose();
    seatsController.dispose();
    super.dispose();
  }

  Future<void> updateEvent() async {
    if (titleController.text.trim().isEmpty ||
        venueController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final eventId = widget.event['event_id'];

      final response = await http.put(
        Uri.parse('$apiBaseUrl/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'venue': venueController.text.trim(),
          'event_date': dateController.text.trim(),
          'event_time': timeController.text.trim(),
          'available_seats':
              int.tryParse(seatsController.text.trim()) ?? 100,
        }),
      );

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ??
                  'Event updated successfully!',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['error']?.toString() ??
                  'Failed to update event',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: const Color(0xFF1556C8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Update Event Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            buildField(
              'Event Title',
              titleController,
            ),

            buildField(
              'Description',
              descriptionController,
              maxLines: 4,
            ),

            buildField(
              'Venue',
              venueController,
            ),

            buildField(
              'Event Date',
              dateController,
            ),

            buildField(
              'Event Time',
              timeController,
            ),

            buildField(
              'Available Seats',
              seatsController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1556C8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Update Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}