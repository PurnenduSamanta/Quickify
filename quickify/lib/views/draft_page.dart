import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/drafts_viewmodel.dart';

class DraftPage extends StatelessWidget {
  final VoidCallback onEdit;

  const DraftPage({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Consumer<DraftsViewModel>(
      builder: (ctx, model, _) {
        final drafts = model.drafts;
        if (drafts.isEmpty) {
          return const Center(child: Text('No drafts'));
        }
        return ListView.builder(
          itemCount: drafts.length,
          itemBuilder: (context, index) {
            final entry = drafts[index];
            return ListTile(
              leading: entry.imagePath == null
                  ? null
                  : Image.file(
                      File(entry.imagePath!),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
              title: Text(entry.name),
              subtitle: Text('${entry.email}\n${entry.phone}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      model.startEditing(index);
                      onEdit();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      model.delete(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final success = await model.send(index);
                      if (!context.mounted) return;
                      final msg = success ? 'Sent' : 'Failed';
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
