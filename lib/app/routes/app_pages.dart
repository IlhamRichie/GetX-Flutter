import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/registrasi/bindings/regist_binding.dart';
import '../modules/registrasi/views/regist_view.dart';
import '../modules/resep/bindings/resep_binding.dart';
import '../modules/resep/views/resep_views.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '${_Paths.RECIPE}/:id',
      page: () =>
          RecipeView(recipeId: int.tryParse(Get.parameters['id'] ?? '0') ?? 0),
      binding: RecipeBinding(),
    ),
  ];
}
