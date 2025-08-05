import '../../data/task/data.dart';
import '../base_use_case_response.dart';

class TaskInitResponse extends BaseUseCaseResponse {
  TaskInitResponse({
    this.tasks = const [],
    super.isLoading,
    super.error,
  });

  final List<UserTask> tasks;
}
