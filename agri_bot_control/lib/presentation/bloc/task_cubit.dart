import 'package:flutter_bloc/flutter_bloc.dart';

class TaskState {
  final DateTime selectedDate;
  TaskState(this.selectedDate);
}

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState(DateTime(2024, 12, 12)));

  void selectDate(DateTime date) => emit(TaskState(date));
}
