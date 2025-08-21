import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';
import 'object_edit_screen.dart';

class ObjectDetailScreen extends StatelessWidget {
  ObjectDetailScreen({super.key});

  final apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    final obj = apiController.selectedObject.value;
    if (obj == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Object Details')),
        body: const Center(child: Text('No object selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(obj.name),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.to(() => ObjectEditScreen(isEdit: true));
              }),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide ? 48.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
            child: SizedBox(
              width: isWide ? 600 : double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(obj.id, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Text('Name:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(obj.name, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Text('Data:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(obj.data.toString(), style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
