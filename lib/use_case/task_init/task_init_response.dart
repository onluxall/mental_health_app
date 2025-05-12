import '../../data/task/data.dart';
import '../base_use_case_response.dart';

class TaskInitResponse extends BaseUseCaseResponse {
  TaskInitResponse({
    this.tasks = const [],
    bool isLoading = false,
    dynamic error,
  }) : super(isLoading: isLoading, error: error);

  final List<UserTask> tasks;
}
