import 'package:flutter/material.dart';

import 'design_tokens.dart';

class ReferenceScaffold extends StatelessWidget {
  const ReferenceScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    this.bottomNavigation,
    this.leading,
    this.bottomAction,
    super.key,
  });
  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? bottomNavigation;
  final Widget? leading;
  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Column(
        children: [
          ReferenceHeader(title: title, actions: actions, leading: leading),
          Expanded(child: body),
          if (bottomAction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: bottomAction!,
            ),
        ],
      ),
    ),
    bottomNavigationBar: bottomNavigation,
  );
}

class ReferenceHeader extends StatelessWidget {
  const ReferenceHeader({
    required this.title,
    this.actions = const [],
    this.leading,
    super.key,
  });
  final String title;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          leading ??
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const SizedBox(
                  width: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ),
        ],
      ),
    ),
  );
}

class ReferenceSearch extends StatelessWidget {
  const ReferenceSearch({this.hint = 'Search all events...', super.key});
  final String hint;
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(AppRadii.field),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Row(
      children: [
        const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(hint, style: AppTextStyles.body),
      ],
    ),
  );
}

class ReferenceButton extends StatelessWidget {
  const ReferenceButton({
    required this.label,
    required this.onPressed,
    this.outline = false,
    this.expand = false,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final bool outline;
  final bool expand;
  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: outline ? AppColors.background : AppColors.primary,
          border: outline ? Border.all(color: AppColors.primary) : null,
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: outline ? AppColors.primary : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class ReferenceTabs extends StatelessWidget {
  const ReferenceTabs({
    required this.labels,
    required this.selected,
    required this.onSelected,
    super.key,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index == selected
                          ? AppColors.primary
                          : AppColors.divider,
                      width: index == selected ? 2 : 1,
                    ),
                  ),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: index == selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: index == selected
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ReferenceEventRow extends StatelessWidget {
  const ReferenceEventRow({
    required this.event,
    this.action,
    this.onTap,
    super.key,
  });
  final dynamic event;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B17212B),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Color(event.color as int),
              borderRadius: BorderRadius.circular(AppRadii.thumbnail),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 7),
                Text(
                  '${event.venue as String}, CA',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    ),
  );
}

class ReferenceSettingRow extends StatelessWidget {
  const ReferenceSettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.divider)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 3),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        trailing ??
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
      ],
    ),
  );
}

class ReferenceLoading extends StatelessWidget {
  const ReferenceLoading({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      4,
      (index) => Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
    ),
  );
}
