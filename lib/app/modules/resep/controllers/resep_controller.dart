import 'package:get/get.dart';
import '../../../data/providers/api_services.dart';

class RecipeController extends GetxController {
  var recipeDetail = {}.obs;
  var isLoading = false.obs;
  final ApiServices _recipeServices = ApiServices();

  void fetchRecipeById(int id) async {
    isLoading.value = true;
    var data = await _recipeServices.getRecipeById(id);
    if (data != null) {
      recipeDetail.value = data;
    } else {
      Get.snackbar("Error", "Failed to load recipe details.");
    }
    isLoading.value = false;
  }
}
