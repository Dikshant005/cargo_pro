import 'package:cargo_pro_assignments/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';
import 'object_detail_screen.dart';
import 'object_edit_screen.dart';

class ObjectListScreen extends StatefulWidget {
  ObjectListScreen({super.key});

  @override
  State<ObjectListScreen> createState() => _ObjectListScreenState();
}

class _ObjectListScreenState extends State<ObjectListScreen> {
  final apiController = Get.put(ApiController());
  final authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    apiController.fetchObjects();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        apiController.fetchObjects(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildListTile(BuildContext context, int index) {
    final obj = apiController.objects[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        title: Text(
          obj.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text('ID: ${obj.id}', style: Theme.of(context).textTheme.bodyMedium),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () async {
            final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Text('Delete Confirmation'),
                      content: Text('Delete "${obj.name}"?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete')),
                      ],
                    ));
            if (confirm == true) {
              final success = await apiController.deleteObject(obj.id);
              if (success) {
                Get.snackbar('Deleted', '${obj.name} deleted.',
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar('Error', apiController.error.value,
                    snackPosition: SnackPosition.BOTTOM);
              }
            }
          },
        ),
        onTap: () {
          apiController.selectedObject.value = obj;
          Get.to(() => ObjectDetailScreen());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Obx(() {
            if (apiController.isLoading.value && apiController.objects.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (apiController.error.value.isNotEmpty &&
                apiController.objects.isEmpty) {
              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        apiController.error.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )));
            }
            if (apiController.objects.isEmpty) {
              return const Center(
                child: Text('No objects found',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 12),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: apiController.objects.length + 1,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder: (context, index) {
                  if (index == apiController.objects.length) {
                    return apiController.isMoreLoading.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                  return buildListTile(context, index);
                },
              ),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          apiController.selectedObject.value = null;
          Get.to(() => ObjectEditScreen(isEdit: false));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
