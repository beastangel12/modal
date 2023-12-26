import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_hive_api/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management_hive_api/features/batch/domain/use_case/add_batch_usecase.dart';
import 'package:student_management_hive_api/features/batch/presentation/state/batch_state.dart';
import '../../domain/entity/course_entity.dart';
import '../../domain/use_case/add_course_usecase.dart';
import '../../domain/use_case/get_all_courses_usecase.dart';
import '../state/course_state.dart';

// View model ma kaile pani build context use na garne

final courseViewModelProvider =
    StateNotifierProvider.autoDispose<CourseViewModel, CourseState>(
  (ref) => CourseViewModel(
    addCourseUsecase: ref.read(addCourseUsecaseProvider),
    getAllCoursesUsecase: ref.read(getAllCoursesUsecaseProvider),
  ),
);

class CourseViewModel extends StateNotifier<CourseState> {
  final AddCourseUsecase addCourseUsecase;
  final GetAllCoursesUsecase getAllCoursesUsecase;

  CourseViewModel({
    required this.addCourseUsecase,
    required this.getAllCoursesUsecase,
  }) : super(CourseState.initialState()) {
    getAllCourses();
  }

  void addCourse(CourseEntity course) {
    state = state.copyWith(isLoading: true);

    addCourseUsecase.addCourse(course).then((value) {
      value.fold(
        (failure) => state = state.copyWith(isLoading: false),
        (success) {
          state = state.copyWith(isLoading: false, showMessage: true);
          getAllCourses();
        },
      );
    });
  }

  void getAllCourses() {
    state = state.copyWith(isLoading: true);
    getAllCoursesUsecase.getAllCourses().then((value) {
      value.fold(
        (failure) => state = state.copyWith(isLoading: false),
        (courses) {
          state = state.copyWith(isLoading: false, courses: courses);
        },
      );
    });
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: value);
  }
}
