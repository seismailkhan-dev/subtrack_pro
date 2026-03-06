import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:subtrack_pro/shared/cards/custom_card_theme.dart';
import '../../controllers/add_subscription_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_toggle_row.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/input_fields/custom_dropdown.dart';
import '../../shared/widgets/custom_snack_bar.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {

  final subController = Get.put(AddSubscriptionController());
  final _form = GlobalKey<FormState>();



  void _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final price = double.tryParse(subController.priceTextController.text);
    if (price == null || price <= 0) {
      customSnackBar(
        'Invalid Price',
        'Please enter a valid price greater than 0',
      );
      return;
    }

    if (subController.category.value.isEmpty) {
      customSnackBar(
        'Category Required',
        'Please select a category',
        isWarning: true,
      );
      return;
    }

    subController.addSubscription(context: context);

  }

  Future<void> _pickBrandColor(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color temp = Color(subController.brandColor.value);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SheetHandle(),
                  Text('Pick brand color', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ColorPicker(
                    pickerColor: temp,
                    onColorChanged: (c) => setState(() => temp = c),
                    enableAlpha: false,
                    displayThumbColor: true,
                    portraitOnly: true,
                    labelTypes: const [],
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    label: 'Use this color',
                    onTap: () {
                      subController.setBrandColor(temp);
                      Navigator.pop(context);
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



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Obx((){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Name
                  AppTextField(
                    label: 'Service Name',
                    hint: 'e.g. Netflix, Spotify...',
                    controller: subController.subNameTextController,
                    prefixIcon: Icons.apps_rounded,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Price + Currency
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: AppTextField(
                          label: 'Price',
                          hint: '9.99',
                          controller: subController.priceTextController,
                          prefixIcon: Icons.attach_money_rounded,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Currency', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            CustomDropdown(
                              value: subController.currency.value,
                              items: AppConstants.currencies,
                              onChanged: (v) => subController.changeCurrency(v??'USD'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Billing Cycle
                  Text('Billing Cycle', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  AppSegmentedControl(
                    options: AppConstants.billingCycles,
                    selectedIndex: subController.cycleIndex.value,
                    onChanged: (v) => subController.changeCycle(v),
                  ),
                  const SizedBox(height: 16),

                  // Category
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        value: subController.category.value,
                        items: AppConstants.categories.skip(1).toList(),
                        onChanged: (v) =>
                            subController.changeCategory(v ?? 'Other'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Brand + Category Colors
                  CustomCardTheme(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Colors', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _ColorSwatch(
                              color: Color(subController.brandColor.value),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Brand color',
                                      style: theme.textTheme.labelLarge),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Used for the subscription icon',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => _pickBrandColor(context),
                              child: const Text(
                                'Pick',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          color:
                              isDark ? AppColors.dividerDark : AppColors.dividerLight,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _ColorSwatch(
                              color: Color(subController.categoryColor.value),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category color',
                                      style: theme.textTheme.labelLarge),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Auto-picked from category',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Date
                  AppTextField(
                    label: 'Start Date',
                    hint:
                        'dd/mm/yyyy',
                    prefixIcon: Icons.calendar_today_rounded,
                    readOnly: true,
                    onTap: ()=> subController.selectDate(context, true),
                    controller: subController.startDateTextController
                  ),

                  const SizedBox(height: 16),

                  // Start Date
                  AppTextField(
                      label: 'Next Billing Date',
                      hint:
                      'dd/mm/yyyy',
                      prefixIcon: Icons.calendar_today_rounded,
                      readOnly: true,
                      controller: subController.nextBillingDateTextController
                  ),
                  const SizedBox(height: 20),

                  // Auto Renew
                  CustomCardTheme(
                    child: AppToggleRow(
                      icon: Icons.autorenew_rounded,
                      title: 'Auto Renew',
                      subtitle: 'Automatically renews on billing date',
                      value: subController.autoRenew.value,
                      onChanged: (v) => subController.changeAutoRenew(v), context: context,
                    ),
                  ),
                  const SizedBox(height: 12),


                  // Free Trial
                  CustomCardTheme(
                    child: AppToggleRow(
                      icon: Icons.lock_open_rounded,
                      title: 'Free Trial',
                      subtitle: 'Subscription starts automatically after the trial.',
                      value: subController.freeTrial.value,
                      onChanged: (v) => subController.changeFreeTrail(v),
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reminder Days
                  CustomCardTheme(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  size: 18, color: AppColors.warning),
                            ),
                            const SizedBox(width: 12),
                            Text('Remind me', style: theme.textTheme.titleSmall),
                            const Spacer(),
                            Text('${subController.reminderDays.value} days before',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            thumbColor: AppColors.primary,
                            inactiveTrackColor:
                                isDark ? AppColors.borderDark : AppColors.borderLight,
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10),
                          ),
                          child: Slider(
                            value: subController.reminderDays.value.toDouble(),
                            min: 1,
                            max: 7,
                            divisions: 6,
                            onChanged: (v) => subController.changeRemindDays(v.toInt()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('1 day', style: TextStyle(fontSize: 10, color: AppColors.textTertiaryLight)),
                            Text('7 days', style: TextStyle(fontSize: 10, color: AppColors.textTertiaryLight)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  AppTextField(
                    label: 'Notes (optional)',
                    hint: 'Any additional info...',
                    controller: subController.notesTextController,
                    maxLines: 3,
                    prefixIcon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 28),

                  AppButton(
                    label: 'Save Subscription',
                    icon: Icons.check_rounded,
                    isLoading: subController.isSaving.value,
                    onTap: _save,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  const _ColorSwatch({required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? null : AppShadows.sm,
      ),
    );
  }
}





