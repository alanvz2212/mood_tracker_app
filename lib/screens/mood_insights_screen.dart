import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/insights_service.dart';

class MoodInsightsScreen extends StatelessWidget {
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
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No data available for insights',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final moods = snapshot.data!.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['mood'] as String)
            .toList();

        final insights = InsightsService.calculateInsights(moods);

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mood Insights (Past 7 Days)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildInsightCard(
                'Most Frequent Mood',
                insights['mostFrequent'] ?? 'N/A',
                Icons.trending_up,
                Colors.blue,
              ),
              SizedBox(height: 16),
              _buildInsightCard(
                'Happy Days',
                '${insights['happyPercentage']}%',
                Icons.sentiment_very_satisfied,
                Colors.green,
              ),
              SizedBox(height: 16),
              _buildInsightCard(
                'Longest Streak',
                '${insights['longestStreak']} days of ${insights['streakMood']}',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}