import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/update_service.dart';

class UpdateDialog extends StatelessWidget {
  final String title;
  final String features;
  final bool forceUpdate;
  final VoidCallback onLater;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.features,
    required this.forceUpdate,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !forceUpdate,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What's new:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              features,
              style: const TextStyle(height: 1.6),
            ),
          ],
        ),
        actions: [
          if (!forceUpdate)
            TextButton(
              onPressed: () async {
                await UpdateService.remindTomorrow();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                onLater();
              },
              child: const Text('Update Later'),
            ),
          ElevatedButton(
            onPressed: () async {
              const url = 'https://play.google.com/store/apps/details?id=com.ikappsstudio.subtrackpro';
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}
