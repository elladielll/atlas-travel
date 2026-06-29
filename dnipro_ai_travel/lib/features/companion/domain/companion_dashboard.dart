class CompanionDashboard {
  final String greeting;
  final String message;
  final AiPick aiPick;
  final Mission mission;
  final Achievement achievement;

  const CompanionDashboard({
    required this.greeting,
    required this.message,
    required this.aiPick,
    required this.mission,
    required this.achievement,
  });

  factory CompanionDashboard.fromJson(Map<String, dynamic> json) {
    return CompanionDashboard(
      greeting: json['greeting'],
      message: json['message'],
      aiPick: AiPick.fromJson(json['ai_pick']),
      mission: Mission.fromJson(json['mission']),
      achievement: Achievement.fromJson(json['achievement']),
    );
  }
}

class AiPick {
  final String title;
  final String reason;
  final double score;

  const AiPick({
    required this.title,
    required this.reason,
    required this.score,
  });

  factory AiPick.fromJson(Map<String, dynamic> json) {
    return AiPick(
      title: json['title'],
      reason: json['reason'],
      score: (json['score'] as num).toDouble(),
    );
  }
}

class Mission {
  final String title;
  final int xp;

  const Mission({
    required this.title,
    required this.xp,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      title: json['title'],
      xp: json['xp'],
    );
  }
}

class Achievement {
  final String title;
  final String emoji;

  const Achievement({
    required this.title,
    required this.emoji,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'],
      emoji: json['emoji'],
    );
  }
}