class InsightsService {
  static Map<String, dynamic> calculateInsights(List<String> moods) {
    if (moods.isEmpty) return {};

    // Most frequent mood
    final moodCounts = <String, int>{};
    for (final mood in moods) {
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }
    final mostFrequent = moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Happy percentage
    final happyCount = moods.where((mood) => mood == 'Happy').length;
    final happyPercentage = ((happyCount / moods.length) * 100).round();

    // Longest streak
    String? currentStreakMood;
    int currentStreak = 0;
    int longestStreak = 0;
    String longestStreakMood = moods.first;

    for (final mood in moods.reversed) {
      if (mood == currentStreakMood) {
        currentStreak++;
      } else {
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
          longestStreakMood = currentStreakMood ?? mood;
        }
        currentStreakMood = mood;
        currentStreak = 1;
      }
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
      longestStreakMood = currentStreakMood!;
    }

    return {
      'mostFrequent': mostFrequent,
      'happyPercentage': happyPercentage,
      'longestStreak': longestStreak,
      'streakMood': longestStreakMood,
    };
  }
}