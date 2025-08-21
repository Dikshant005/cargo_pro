import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';
import '../models/api_object.dart';

class ObjectEditScreen extends StatefulWidget {
  final bool isEdit;

  const ObjectEditScreen({super.key, required this.isEdit});

  @override
  State<ObjectEditScreen> createState() => _ObjectEditScreenState();
}

class _ObjectEditScreenState extends State<ObjectEditScreen> {
  final apiController = Get.find<ApiController>();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dataController;

  @override
  void initState() {
    super.initState();
    final selected = apiController.selectedObject.value;
    _nameController = TextEditingController(text: selected?.name ?? '');
    _dataController =
        TextEditingController(text: selected != null ? jsonEncode(selected.data) : '{}');
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    String name = _nameController.text.trim();
    Map<String, dynamic> data;
    try {
      data = jsonDecode(_dataController.text.trim());
    } catch (e) {
      Get.snackbar('Error', 'Invalid JSON format in data',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    bool success;
    if (widget.isEdit && apiController.selectedObject.value != null) {
      final current = apiController.selectedObject.value!;
      final updated = ApiObject(
        id: current.id,
        name: name,
        data: data,
      );
      success = await apiController.updateObject(updated);
    } else {
      final newObj = ApiObject(id: '', name: name, data: data);
      success = await apiController.createObject(newObj);
    }

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        widget.isEdit ? 'Object updated successfully' : 'Object created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar('Error', apiController.error.value,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit ? 'Edit Object' : 'Create Object';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide ? 48.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
            child: Center(
              child: SizedBox(
                width: isWide ? 600 : double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: TextFormField(
                          controller: _dataController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            labelText: 'Data (JSON format)',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.multiline,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Data JSON is required';
                            try {
                              jsonDecode(val);
                            } catch (_) {
                              return 'Invalid JSON format';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _save,
                          child: Text(widget.isEdit ? 'Update' : 'Create',
                          style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
