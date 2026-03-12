import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/app_database.dart';
import '../viewmodels/draft_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  final Draft? draftToEdit;
  final VoidCallback? onEditComplete;

  const HomePage({super.key, this.draftToEdit, this.onEditComplete});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  String? _imagePath;
  Draft? _currentData;

  void _loadData(Draft? data) {
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

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.draftToEdit != oldWidget.draftToEdit) {
      _currentData = widget.draftToEdit;
      _loadData(_currentData);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentData = widget.draftToEdit;
    _loadData(_currentData);
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

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final draftModel = Provider.of<DraftViewModel>(context, listen: false);

      final isUpdate = _currentData != null;
      final id = isUpdate
          ? _currentData!.id
          : DateTime.now().toIso8601String();
      final entry = Draft(
        id: id,
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        imagePath: _imagePath,
      );

      await draftModel.add(entry, isUpdate: isUpdate);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved')));
      _formKey.currentState?.reset();
      _loadData(null);
      if (widget.onEditComplete != null) {
        widget.onEditComplete!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (ctx, homeModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              Switch(
                value: homeModel.isDark,
                onChanged: (_) {
                  homeModel.toggleTheme();
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
