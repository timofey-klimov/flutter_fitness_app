import 'package:app/domain/activities/activity.dart';

class EmptyActivity extends Activity {
  EmptyActivity() : super(type: ActivityTypes.empty);

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  @override
  bool validate() {
    return false;
  }

}