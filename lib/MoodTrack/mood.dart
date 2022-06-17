import 'package:flutter/material.dart';
enum Mood {
  awesome,
  good,
  meh,
  bad,
  awful,
}

Color mood_color(Mood mood) {
  switch (mood) {
    case Mood.awesome: {
      return Colors.green;
    }
    case Mood.good: {
      return Colors.lightGreen;
    }
    case Mood.meh: {
      return Colors.blue;
    }
    case Mood.bad: {
      return Colors.orange;
    }
    case Mood.awful: {
      return Colors.red;
    }
  }
}

String mood_icon(Mood mood) {
  switch (mood) {
    case Mood.awesome: {
      return 'assets/MoodIcons/Excited_Smiley_Face.svg';
    }
    case Mood.good: {
      return 'assets/Happy_Face.svg';
    }
    case Mood.meh: {
      return 'assets/Neutral_Face.svg';
    }
    case Mood.bad: {
      return 'assets/Bad_Face.svg';
    }
    case Mood.awful: {
      return 'assets/Awful_Face.svg';
    }
  }
}

String mood_name(Mood mood) {
  switch (mood) {
    case Mood.awesome: {
      return 'Awesome';
    }
    case Mood.good: {
      return 'Good';
    }
    case Mood.meh: {
      return 'Neutral';
    }
    case Mood.bad: {
      return 'Bad';
    }
    case Mood.awful: {
      return 'Awful';
    }
  }
}
