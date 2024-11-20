import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'local_storage.dart';

class DataController extends GetxController {
  final ApiService _apiService = ApiService();
  final LocalStorage _localStorage = LocalStorage();

  var data = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult != ConnectivityResult.none) {
        //
        // if device is online then fetch data from the API
        //
        final apiData = await _apiService.fetchData();
        data.assignAll(apiData);
         //
        // Save the data to local storage
        //
        await _localStorage.insertData(apiData);
      } else {
        //
        // if device is offline then load cached data
        //
        final cachedData = await _localStorage.fetchCachedData();
        data.assignAll(cachedData.map((e) => e).toList());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
