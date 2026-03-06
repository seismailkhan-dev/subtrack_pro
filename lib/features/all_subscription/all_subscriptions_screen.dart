import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/get_subscription_controller.dart';
import '../../data/models/subcription_model.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/custom_loader.dart';

class AllSubscriptionsScreen extends StatelessWidget {
  AllSubscriptionsScreen({super.key});

  final GetSubscriptionsController _controller =
      Get.isRegistered<GetSubscriptionsController>()
          ? Get.find<GetSubscriptionsController>()
          : Get.put(GetSubscriptionsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Subscriptions'),
      ),
      body: StreamBuilder<List<SubscriptionDataModel>>(
        stream: _controller.watchSubscriptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return customLoader();
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Something went wrong.\nPlease try again.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final subs = (snapshot.data ?? <SubscriptionDataModel>[])
            ..sort((a, b) => b.startDate.compareTo(a.startDate));

          if (subs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: EmptyState(
                icon: Icons.inbox_outlined,
                title: 'No subscriptions found',
                body: 'Add a subscription to see it here.',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: subs.length,
            itemBuilder: (context, index) {
              final sub = subs[index];
              return SubscriptionCard(
                subscription: sub,
                onDelete: () async {
                  final id = sub.id;
                  if (id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to delete this subscription.'),
                      ),
                    );
                    return;
                  }

                  await _controller.deleteSubscription(id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription deleted')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

