import 'package:get_it/get_it.dart';
import 'package:stories_admin/data/services/permission_service.dart';

final diStoriesAdmin = GetIt.instance;

Future<void> setupDiStoriesAdmin() async {
  //Services
  diStoriesAdmin.registerLazySingleton(
    () => PermissionService()..requestPhotoOrStorage(),
  );
}
