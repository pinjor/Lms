// import 'package:bjp_app/features/home/data/home_repository.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// import '../../../../core/utils/utils.dart';
//
// part 'home_controller.g.dart';
//
// @riverpod
// class HomeController extends _$HomeController {
//   late final HomeRepository _homeRepository;
//   @override
//   AsyncValue<dynamic> build() {
//     _homeRepository = ref.read(homeRepositoryProvider);
//
//     return AsyncValue.loading();
//   }
//
//   Future<void> fetchRecentMemberAnnouncement() async {
//     final result = await _homeRepository.fetchRecentMemberAnnouncement();
//     result.fold(
//       (failure) => lgr.e('Error fetching recent announcement: $failure'),
//       (recentAnnouncement) {
//         state = AsyncValue.data(recentAnnouncement);
//         lgr.i('Fetched Recent Announcement: $recentAnnouncement');
//       },
//     );
//   }
// }
