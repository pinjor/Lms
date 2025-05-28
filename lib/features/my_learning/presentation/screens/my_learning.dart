import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


// class PracticeModeTestApp extends StatelessWidget {
//   const PracticeModeTestApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Practice Mode Test',
//       theme: ThemeData(
//         fontFamily: /'Inter',
//         primarySwatch: Colors.indigo,
//         scaffoldBackgroundColor: Colors.white,/
//       ),
//       home: const MCQQuestionScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class MCQQuestionScreen extends StatefulWidget {
  const MCQQuestionScreen({super.key});

  @override
  State<MCQQuestionScreen> createState() => _MCQQuestionScreenState();
}

class _MCQQuestionScreenState extends State<MCQQuestionScreen> {
  int? selectedOptionIndex;
  final int totalQuestions = 65;
  final int currentQuestion = 1;

  final List<Option> options = [
    Option(label: 'A)', text: 'Scapula'),
    Option(label: 'B)', text: 'Sternum'),
    Option(label: 'C)', text: 'Vertebra'),
    Option(label: 'D)', text: 'Skull'),
  ];

  void onOptionSelected(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final purpleColor = const Color(0xFF4F46E5); // Indigo-700
    final grayBorder = Colors.grey.shade300;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Navbar
                    Navbar(),
        
                    const SizedBox(height: 20),
        
                    // Practice mode badge + info icon
                    Row(
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Practice mode',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.info_outline,
                            size: 18, color: Colors.grey.shade600),
                      ],
                    ),
        
                    const SizedBox(height: 16),
        
                    // Progress bar row
                    Row(
                      children: [
                        Text(
                          '$currentQuestion/$totalQuestions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: currentQuestion / totalQuestions,
                              color: Colors.grey.shade600,
                              backgroundColor: Colors.grey.shade300,
                              minHeight: 12,
                            ),
                          ),
                        ),
                       const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Finish test action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(color: Colors.indigo.shade700),
                            ),
                            elevation: 0,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          child: const Text('Finish test'),
                        )
                      ],
                    ),
        
                    const SizedBox(height: 24),
        
                    // Question label with bookmark icon
                    Row(
                      children: [
                        Icon(Icons.bookmark_border,
                            size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Question $currentQuestion:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 12),
        
                    // Question text
                    Text(
                      'Which of the following bones is not part of the axial skeleton?',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.grey.shade900,
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    // Options list
                    ...List.generate(options.length, (index) {
                      final option = options[index];
                      final isSelected = selectedOptionIndex == index;
        
                      return GestureDetector(
                        onTap: () => onOptionSelected(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.indigo.shade600
                                  : grayBorder,
                              width: 1.8,
                            ),
                            color: isSelected
                                ? Colors.indigo.shade50
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: selectedOptionIndex,
                                activeColor: purpleColor,
                                onChanged: (value) {
                                  onOptionSelected(value!);
                                },
                              ),
                              const SizedBox(width: 12),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.indigo.shade700,
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(text: option.label),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
        
                    const SizedBox(height: 88), // spacing for buttons + bottom nav
                  ],
                ),
        
                // Skip and Next buttons fixed bottom above bottom nav
                Positioned(
                  bottom: 72,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -1),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Skip question action
                          },
                          icon: Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey.shade700,
                          ),
                          label: Text(
                            'Skip this question',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Next question action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar

    );
  }
}

class Option {
  final String label;
  final String text;
  Option({required this.label, required this.text});
}

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final purpleColor = const Color(0xFF4F46E5); // Indigo-700
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.grey),
            onPressed: () {},
            tooltip: 'Menu',
          ),
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: purpleColor,
                size: 24,
              ),
              const SizedBox(width: 4),
              Text(
                'Preparation360',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
                tooltip: 'Search',
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.grey),
                onPressed: () {},
                tooltip: 'Cart',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color? selectedColor;
  final VoidCallback onTap;

  const BottomNavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? (selectedColor ?? Colors.indigo) : Colors.grey.shade700;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
