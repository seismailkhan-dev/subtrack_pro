import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_widgets.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _notes = TextEditingController();

  int _cycleIndex = 1; // Monthly
  String _category = 'Entertainment';
  String _currency = 'USD';
  bool _autoRenew = true;
  int _reminderDays = 3;
  DateTime _startDate = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _saving = false);
      _showSuccess();
    }
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessSheet(name: _name.text),
    ).then((_) => Navigator.pop(context));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _startDate = picked);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Picker
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark2
                          : AppColors.surfaceLight2,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            color: AppColors.primary, size: 28),
                        const SizedBox(height: 4),
                        const Text('Logo',
                            style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Service Name
              AppTextField(
                label: 'Service Name',
                hint: 'e.g. Netflix, Spotify...',
                controller: _name,
                prefixIcon: Icons.apps_rounded,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Price + Currency
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'Price',
                      hint: '9.99',
                      controller: _price,
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
                        _Dropdown(
                          value: _currency,
                          items: AppConstants.currencies,
                          onChanged: (v) => setState(() => _currency = v!),
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
                selectedIndex: _cycleIndex,
                onChanged: (i) => setState(() => _cycleIndex = i),
              ),
              const SizedBox(height: 16),

              // Category
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  _Dropdown(
                    value: _category,
                    items: AppConstants.categories.skip(1).toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Start Date
              AppTextField(
                label: 'Start Date',
                hint:
                    '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                prefixIcon: Icons.calendar_today_rounded,
                readOnly: true,
                onTap: _pickDate,
                controller: TextEditingController(
                  text:
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                ),
              ),
              const SizedBox(height: 20),

              // Auto Renew
              _SettingsCard(
                child: AppToggleRow(
                  icon: Icons.autorenew_rounded,
                  title: 'Auto Renew',
                  subtitle: 'Automatically renews on billing date',
                  value: _autoRenew,
                  onChanged: (v) => setState(() => _autoRenew = v),
                ),
              ),
              const SizedBox(height: 12),

              // Reminder Days
              _SettingsCard(
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
                        Text('$_reminderDays days before',
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
                        value: _reminderDays.toDouble(),
                        min: 1,
                        max: 7,
                        divisions: 6,
                        onChanged: (v) => setState(() => _reminderDays = v.round()),
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
                controller: _notes,
                maxLines: 3,
                prefixIcon: Icons.notes_rounded,
              ),
              const SizedBox(height: 28),

              AppButton(
                label: 'Save Subscription',
                icon: Icons.check_rounded,
                isLoading: _saving,
                onTap: _save,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: child,
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark2.withOpacity(0.5)
            : AppColors.surfaceLight2,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 14,
          ),
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ),
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  final String name;
  const _SuccessSheet({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                color: AppColors.accent, size: 32),
          ),
          const SizedBox(height: 16),
          Text('Subscription Added!',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('$name has been added to your tracker.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          AppButton(
            label: 'Great!',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
