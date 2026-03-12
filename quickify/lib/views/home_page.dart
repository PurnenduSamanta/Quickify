import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/form_data.dart';
import '../viewmodels/drafts_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  String? _imagePath;
  FormData? _currentData;

  void _loadData(FormData? data) {
    if (data == null) {
      _nameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _imagePath = null;
    } else {
      _nameCtrl.text = data.name;
      _emailCtrl.text = data.email;
      _phoneCtrl.text = data.phone;
      _imagePath = data.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final model = Provider.of<DraftsViewModel>(context, listen: false);
      final id = model.isEditing
          ? model.editingData!.id
          : DateTime.now().toIso8601String();
      final entry = FormData(
        id: id,
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        imagePath: _imagePath,
      );
      if (model.isEditing) {
        model.update(entry);
      } else {
        model.add(entry);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved')));
      _formKey.currentState?.reset();
      _loadData(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DraftsViewModel, ThemeViewModel>(
      builder: (ctx, draftsModel, themeModel, _) {
        if (draftsModel.isEditing && _currentData != draftsModel.editingData) {
          _currentData = draftsModel.editingData;
          _loadData(_currentData);
        } else if (!draftsModel.isEditing && _currentData != null) {
          _currentData = null;
          _loadData(null);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              Switch(
                value: themeModel.isDark,
                onChanged: (_) {
                  themeModel.toggle();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _imagePath == null
                          ? const Text('No image selected')
                          : Image.file(
                              File(_imagePath!),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Pick Image'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
