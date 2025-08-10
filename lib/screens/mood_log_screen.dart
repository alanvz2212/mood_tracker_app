import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/mood_colors.dart';

class MoodLogScreen extends StatefulWidget {
  @override
  _MoodLogScreenState createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  String? _selectedMood;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('moods')
          .doc(today)
          .set({
        'mood': _selectedMood,
        'note': _noteController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mood saved successfully!')),
      );
      
      _noteController.clear();
      setState(() => _selectedMood = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving mood: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: MoodColors.moodColors.keys.map((mood) {
              return ChoiceChip(
                label: Text(mood),
                selected: _selectedMood == mood,
                onSelected: (selected) {
                  setState(() => _selectedMood = selected ? mood : null);
                },
                selectedColor: MoodColors.moodColors[mood]!.withOpacity(0.3),
                backgroundColor: Colors.grey[200],
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
              hintText: 'How was your day?',
            ),
            maxLines: 3,
          ),
          SizedBox(height: 20),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _saveMood,
                  child: Text('Save Mood'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
        ],
      ),
    );
  }
}