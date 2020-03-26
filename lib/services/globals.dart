import 'package:quizapp/services/db.dart';
import 'package:quizapp/services/model.dart';

class Global {
  // App Data
  static final String title = 'test';

  static final Map models = {
    Topic: (data) => Topic.fromMap(data),
    Quiz: (data) => Quiz.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };

  static final Collection<Topic> topicsRef = Collection<Topic>(path: 'topics');
  static final UserData<Report> reportRef = UserData<Report>(collection: 'reports');
}