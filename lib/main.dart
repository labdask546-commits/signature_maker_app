import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(const SignatureMakerApp());
}

// Global App State Manager for Saved Signatures
class SignatureStore extends ChangeNotifier {
  static final SignatureStore instance = SignatureStore._();
  SignatureStore._();

  final List<SavedSignature> _signatures = [
    SavedSignature(
      id: '1',
      title: 'Official Work Signature',
      date: 'Today, 10:24 AM',
      category: 'Official',
      color: Colors.indigo,
    ),
    SavedSignature(
      id: '5',
      title: 'Personal Contract Signature',
      date: 'Today, 2:30 PM',
      category: 'Personal',
      color: Colors.teal,
    ),
    SavedSignature(
      id: '2',
      title: 'Bank & Loan Documents',
      date: 'Yesterday, 3:15 PM',
      category: 'Official',
      color: Colors.black,
    ),
    SavedSignature(
      id: '3',
      title: 'Quick Initials Stamp',
      date: '2 days ago',
      category: 'Initials',
      color: Colors.blue,
    ),
  ];

  List<SavedSignature> get signatures => List.unmodifiable(_signatures);

  void addSignature(String title, String category, Color color) {
    final newSig = SavedSignature(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Signature #${_signatures.length + 1}' : title,
      date: 'Just now',
      category: category,
      color: color,
    );
    _signatures.insert(0, newSig);
    notifyListeners();
  }

  void deleteSignature(String id) {
    _signatures.removeWhere((sig) => sig.id == id);
    notifyListeners();
  }
}

class SavedSignature {
  final String id;
  final String title;
  final String date;
  final String category;
  final Color color;

  SavedSignature({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    required this.color,
  });
}

class SignatureMakerApp extends StatelessWidget {
  const SignatureMakerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Maker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        fontFamily: 'sans-serif',
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.edit,
                size: 64,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Signature Maker App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fast • Smooth • Professional Digital Signatures',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                );
              },
              child: const Text(
                'Get Started →',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Navigation Shell with IndexedStack for Instant Switching
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onSwitchTab: _onTabTapped),
          const CreateSignatureScreen(),
          const MySignaturesScreen(),
          const SignImageScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.gesture_rounded), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_special_rounded), label: 'Signatures'),
          BottomNavigationBarItem(icon: Icon(Icons.image_search_rounded), label: 'Sign File'),
        ],
      ),
    );
  }
}

// 2. Home Screen
class HomeScreen extends StatelessWidget {
  final Function(int) onSwitchTab;
  const HomeScreen({Key? key, required this.onSwitchTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit, color: Color(0xFF4F46E5), size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'Signature Maker',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFF4F46E5), size: 28),
            onPressed: () {
              _showProfileDialog(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: SignatureStore.instance,
        builder: (context, _) {
          final recentSigs = SignatureStore.instance.signatures;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good day, Alex 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Create, manage & stamp your digital signatures', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 20),

                // Create New Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.draw_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 12),
                          const Text('Create New Signature', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Design your custom signature with smooth pen gestures & instant export.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4F46E5),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          onSwitchTab(1); // Switch to Create Tab instantly
                        },
                        child: const Text('Create Now →', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Options Row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onSwitchTab(2); // Switch to My Signatures Tab
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFF4F46E5).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.folder_shared_rounded, color: Color(0xFF4F46E5), size: 24),
                              ),
                              const SizedBox(height: 12),
                              const Text('My Signatures', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('${recentSigs.length} Saved', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onSwitchTab(3); // Switch to Sign File Tab
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFF4F46E5).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF4F46E5), size: 24),
                              ),
                              const SizedBox(height: 12),
                              const Text('Sign an Image', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('Stamp PDF/PNG', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Signatures', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => onSwitchTab(2),
                      child: const Text('View All', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recentSigs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('No signatures created yet.', style: TextStyle(color: Colors.grey.shade600)),
                    ),
                  )
                else
                  ...recentSigs.take(4).map((sig) => _buildRecentSignatureCard(context, sig)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.account_circle, color: Color(0xFF4F46E5), size: 32),
            SizedBox(width: 10),
            Text('User Profile'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: Alex Johnson', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 6),
            Text('Email: alex.signature@example.com', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 6),
            Text('COMSATS Student Edition', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSignatureCard(BuildContext context, SavedSignature sig) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(signature: sig)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sig.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.gesture_rounded, color: sig.color),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sig.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('${sig.date} • ${sig.category}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              onSelected: (val) {
                if (val == 'view') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(signature: sig)));
                } else if (val == 'delete') {
                  SignatureStore.instance.deleteSignature(sig.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signature deleted')));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('View & Export')),
                const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Fast & Smooth Drawing Canvas (Optimized with RepaintBoundary & ValueNotifier)
class CreateSignatureScreen extends StatefulWidget {
  const CreateSignatureScreen({Key? key}) : super(key: key);

  @override
  State<CreateSignatureScreen> createState() => _CreateSignatureScreenState();
}

class _CreateSignatureScreenState extends State<CreateSignatureScreen> {
  final ValueNotifier<List<DrawnStroke>> _strokesNotifier = ValueNotifier([]);
  Color _selectedColor = Colors.indigo;
  double _strokeWidth = 4.0;
  List<Offset> _currentPoints = [];
  final TextEditingController _titleController = TextEditingController(text: 'My Official Signature');
  String _selectedCategory = 'Official';

  void _clearCanvas() {
    _strokesNotifier.value = [];
    _currentPoints = [];
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Canvas cleared')));
  }

  void _saveSignature() {
    if (_strokesNotifier.value.isEmpty && _currentPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please draw your signature first on the canvas!')),
      );
      return;
    }

    final sigTitle = _titleController.text.trim();
    SignatureStore.instance.addSignature(sigTitle, _selectedCategory, _selectedColor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signature saved successfully!')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          signature: SignatureStore.instance.signatures.first,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _strokesNotifier.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Signature', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black87),
            tooltip: 'Clear Canvas',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Signature Title',
                hintText: 'e.g. Work Signature',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // Drawing Canvas Area (RepaintBoundary for 60/120 FPS performance)
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Stack(
                children: [
                  RepaintBoundary(
                    child: ValueListenableBuilder<List<DrawnStroke>>(
                      valueListenable: _strokesNotifier,
                      builder: (context, strokes, _) {
                        return GestureDetector(
                          onPanStart: (details) {
                            _currentPoints = [details.localPosition];
                          },
                          onPanUpdate: (details) {
                            _currentPoints.add(details.localPosition);
                            final updated = List<DrawnStroke>.from(_strokesNotifier.value);
                            if (updated.isNotEmpty && updated.last.isLive) {
                              updated.removeLast();
                            }
                            updated.add(DrawnStroke(
                              points: List.from(_currentPoints),
                              color: _selectedColor,
                              width: _strokeWidth,
                              isLive: true,
                            ));
                            _strokesNotifier.value = updated;
                          },
                          onPanEnd: (details) {
                            final updated = List<DrawnStroke>.from(_strokesNotifier.value);
                            if (updated.isNotEmpty && updated.last.isLive) {
                              final last = updated.removeLast();
                              updated.add(DrawnStroke(
                                points: last.points,
                                color: last.color,
                                width: last.width,
                                isLive: false,
                              ));
                            }
                            _strokesNotifier.value = updated;
                            _currentPoints = [];
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CustomPaint(
                              painter: FastSignaturePainter(strokes: strokes),
                              size: Size.infinite,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        tooltip: 'Clear',
                        onPressed: _clearCanvas,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Color Selection
            const Text('Ink Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _colorButton(Colors.black),
                _colorButton(const Color(0xFF4F46E5)),
                _colorButton(Colors.blue.shade800),
                _colorButton(Colors.red.shade700),
                _colorButton(const Color(0xFF047857)),
              ],
            ),
            const SizedBox(height: 20),

            // Stroke Thickness Slider
            Row(
              children: [
                const Text('Thickness:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Expanded(
                  child: Slider(
                    value: _strokeWidth,
                    min: 1.5,
                    max: 8.0,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      setState(() {
                        _strokeWidth = val;
                      });
                    },
                  ),
                ),
                Text('${_strokeWidth.toStringAsFixed(1)}px', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Save Signature Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: _saveSignature,
                icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                label: const Text('Save & Store Signature', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 42 : 36,
        height: isSelected ? 42 : 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? Colors.black87 : Colors.transparent, width: 3),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))] : [],
        ),
      ),
    );
  }
}



class DrawnStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isLive;

  DrawnStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isLive = false,
  });
}

class FastSignaturePainter extends CustomPainter {
  final List<DrawnStroke> strokes;

  FastSignaturePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.width;

      if (stroke.points.length == 1) {
        canvas.drawPoints(ui.PointMode.points, [stroke.points.first], paint);
      } else {
        final path = Path();
        path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (int i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FastSignaturePainter oldDelegate) => true;
}

// 4. My Signatures Screen
class MySignaturesScreen extends StatelessWidget {
  const MySignaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Signatures', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListenableBuilder(
        listenable: SignatureStore.instance,
        builder: (context, _) {
          final list = SignatureStore.instance.signatures;
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text('No signatures saved yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final sig = list[index];
              return SignatureCard(signature: sig);
            },
          );
        },
      ),
    );
  }
}

class SignatureCard extends StatelessWidget {
  final SavedSignature signature;

  const SignatureCard({Key? key, required this.signature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreviewScreen(signature: signature)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: signature.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.gesture_rounded, color: signature.color, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(signature.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${signature.date} • ${signature.category}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// 5. Sign an Image / PDF Screen
class SignImageScreen extends StatefulWidget {
  const SignImageScreen({Key? key}) : super(key: key);

  @override
  State<SignImageScreen> createState() => _SignImageScreenState();
}

class _SignImageScreenState extends State<SignImageScreen> {
  String _selectedFileName = 'certificate_sample.pdf';
  String _fileSize = '1.8 MB';

  void _pickFile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Document Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Contract_Agreement.pdf (2.4 MB)'),
              onTap: () {
                setState(() {
                  _selectedFileName = 'Contract_Agreement.pdf';
                  _fileSize = '2.4 MB';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Official_Stamp_Doc.png (850 KB)'),
              onTap: () {
                setState(() {
                  _selectedFileName = 'Official_Stamp_Doc.png';
                  _fileSize = '850 KB';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign an Image / PDF', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF4F46E5).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF4F46E5), size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedFileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('$_fileSize • Tap to change document', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.swap_horiz_rounded, color: Color(0xFF4F46E5)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 48, color: Color(0xFF4F46E5)),
                    const SizedBox(height: 12),
                    Text('Document Preview Ready for Stamping', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                    const SizedBox(height: 4),
                    Text('Tap below to apply your saved signature stamp', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: () {
                  final sigs = SignatureStore.instance.signatures;
                  final sig = sigs.isNotEmpty
                      ? sigs.first
                      : SavedSignature(id: '0', title: 'Default Signature', date: 'Just now', category: 'Official', color: Colors.indigo);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(signature: sig)));
                },
                icon: const Icon(Icons.verified, color: Colors.white),
                label: const Text('Save & Stamp Image', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Preview Screen
class PreviewScreen extends StatelessWidget {
  final SavedSignature signature;

  const PreviewScreen({Key? key, required this.signature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview & Export', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Signature Processed Successfully!',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Signature Card Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.gesture_rounded, size: 72, color: signature.color),
                  const SizedBox(height: 16),
                  Text(signature.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('${signature.category} • Created ${signature.date}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                      foregroundColor: const Color(0xFF4F46E5),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signature shared via WhatsApp / Email!')),
                      );
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                      foregroundColor: const Color(0xFF4F46E5),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloaded signature as PNG file')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download PNG'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to Gallery!')),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Save to Gallery & Finish', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
