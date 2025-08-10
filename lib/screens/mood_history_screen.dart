import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/mood_colors.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('moods')
          .where('timestamp', isGreaterThan: sevenDaysAgo)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No mood entries found for the past 7 days',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final mood = data['mood'] as String;
            final note = data['note'] as String? ?? '';
            final date = doc.id;

            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: MoodColors.moodColors[mood],
                  child: Text(
                    mood[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(mood),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(date), if (note.isNotEmpty) Text(note)],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editNote(context, doc.id, note),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editNote(BuildContext context, String docId, String currentNote) {
    final controller = TextEditingController(text: currentNote);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Note',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser!;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('moods')
                  .doc(docId)
                  .update({'note': controller.text.trim()});
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
