import 'package:flutter/material.dart';

// QR Code Challenge Screen
class QRCodeChallengeScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const QRCodeChallengeScreen({required this.onCompleted, super.key});

  @override
  State<QRCodeChallengeScreen> createState() => _QRCodeChallengeScreenState();
}

class _QRCodeChallengeScreenState extends State<QRCodeChallengeScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1A1D26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // QR Code Scanner Placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF4F6BFF), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, size: 80, color: Color(0xFF4F6BFF)),
                    SizedBox(height: 10),
                    Text(
                      'Point camera at QR code',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Demo Button (in real app, would integrate actual QR scanner)
            ElevatedButton(
              onPressed: () {
                setState(() => _isScanned = true);
                Future.delayed(Duration(seconds: 1), () {
                  widget.onCompleted();
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4F6BFF),
              ),
              child: Text(_isScanned ? 'QR Code Scanned!' : 'Simulate Scan'),
            ),
          ],
        ),
      ),
    );
  }
}

// Math Challenge Screen
class MathChallengeScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const MathChallengeScreen({required this.onCompleted, super.key});

  @override
  State<MathChallengeScreen> createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends State<MathChallengeScreen> {
  late int num1;
  late int num2;
  late int correctAnswer;
  late TextEditingController _answerController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    num1 = DateTime.now().millisecondsSinceEpoch % 100;
    num2 = DateTime.now().millisecondsSinceEpoch ~/ 100 % 100;
    correctAnswer = num1 + num2;
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    if (userAnswer == null) {
      setState(() => _errorMessage = 'Please enter a valid number');
      return;
    }

    if (userAnswer == correctAnswer) {
      widget.onCompleted();
      Navigator.pop(context);
    } else {
      setState(() => _errorMessage = 'Wrong answer. Try again!');
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1A1D26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Math Challenge',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            // Math Problem
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF4F6BFF).withOpacity(0.1),
                border: Border.all(color: Color(0xFF4F6BFF)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$num1 + $num2 = ?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F6BFF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Answer Input
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Your answer',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Color(0xFF1A1D26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF4F6BFF)),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red[400], fontSize: 12),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4F6BFF),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Word Arrange Challenge Screen
class WordArrangeChallengeScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const WordArrangeChallengeScreen({required this.onCompleted, super.key});

  @override
  State<WordArrangeChallengeScreen> createState() =>
      _WordArrangeChallengeScreenState();
}

class _WordArrangeChallengeScreenState
    extends State<WordArrangeChallengeScreen> {
  late List<String> shuffledWords;
  late List<String> correctOrder;
  late List<String> selectedOrder;

  @override
  void initState() {
    super.initState();
    correctOrder = ['Good', 'Morning', 'Wake', 'Up'];
    shuffledWords = List.from(correctOrder)..shuffle();
    selectedOrder = [];
  }

  void _toggleWord(String word) {
    setState(() {
      if (selectedOrder.contains(word)) {
        selectedOrder.remove(word);
      } else {
        selectedOrder.add(word);
      }
    });
  }

  void _checkAnswer() {
    if (selectedOrder.join() == correctOrder.join()) {
      widget.onCompleted();
      Navigator.pop(context);
    }
  }

  void _resetSelection() {
    setState(() {
      selectedOrder = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1A1D26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Arrange Words',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Arrange the words in correct order',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            SizedBox(height: 20),
            // Selected Order Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4F6BFF).withOpacity(0.1),
                border: Border.all(color: Color(0xFF4F6BFF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                spacing: 8,
                children: selectedOrder.isNotEmpty
                    ? selectedOrder
                          .map(
                            (word) => Chip(
                              label: Text(word),
                              onDeleted: () => _toggleWord(word),
                            ),
                          )
                          .toList()
                    : [
                        Text(
                          'Select words in order',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
              ),
            ),
            SizedBox(height: 20),
            // Shuffled Words
            Wrap(
              spacing: 8,
              children: shuffledWords.map((word) {
                final isSelected = selectedOrder.contains(word);
                return GestureDetector(
                  onTap: () => _toggleWord(word),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF4F6BFF) : Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _resetSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                  ),
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F6BFF),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
