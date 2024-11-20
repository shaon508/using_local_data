import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_controller.dart';

class HomeScreen extends StatelessWidget {
  final DataController _dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Offline Data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
      ),
      body: Obx(() {
        if (_dataController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_dataController.data.isEmpty) {
          return const Center(child: Text("No data available."));
        }

        return ListView.builder(
          itemCount: _dataController.data.length,
          itemBuilder: (context, index) {
            final item = _dataController.data[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        item["title"] ?? "No Title",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(
                      height:10,
                    ),
                    Text(
                        item["body"] ?? "No Body",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      //
      //floatingActionButton for refresh the data
      //
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _dataController.fetchData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
