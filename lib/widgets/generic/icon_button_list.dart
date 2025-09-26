import 'package:flutter/material.dart';
import 'package:random_please/utils/variables_utils.dart';

class IconButtonListItem {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? color;

  IconButtonListItem({
    required this.icon,
    required this.onPressed,
    this.label,
    this.color,
  });

  factory IconButtonListItem.fromIconButton(IconButton button) {
    IconData iconData;
    if (button.icon is Icon) {
      iconData = (button.icon as Icon).icon ?? Icons.help;
    } else {
      iconData = Icons.help; // fallback
    }

    return IconButtonListItem(
      icon: iconData,
      onPressed: button.onPressed ?? () {},
      label: button.tooltip,
      color: button.color,
    );
  }
}

class IconButtonList extends StatelessWidget {
  final List<IconButtonListItem> buttons;
  final int visibleCount;
  final double spacing;

  const IconButtonList({
    super.key,
    required this.buttons,
    required this.visibleCount,
    this.spacing = 0,
  });

  static int getVisibleContext(BuildContext context) {
    if (isMobileContext(context)) {
      return 0;
    }
    return 999;
  }

  @override
  Widget build(BuildContext context) {
    if (visibleCount < 0) {
      throw ArgumentError('visibleCount must be >= 0');
    }
    if (buttons.isEmpty) return const SizedBox.shrink();
    final showCount =
        visibleCount > buttons.length ? buttons.length : visibleCount;
    final visible = buttons.take(showCount).toList();
    final overflow =
        buttons.length > showCount ? buttons.sublist(showCount) : [];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < visible.length; i++) ...[
          IconButton(
            icon: Icon(visible[i].icon, color: visible[i].color),
            tooltip: visible[i].label,
            onPressed: visible[i].onPressed,
          ),
          if (i != visible.length - 1 && spacing > 0) SizedBox(width: spacing),
        ],
        if (overflow.isNotEmpty)
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              for (int i = 0; i < overflow.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: ListTile(
                    leading: Icon(overflow[i].icon, color: overflow[i].color),
                    title: Text(overflow[i].label ?? ''),
                  ),
                ),
            ],
            onSelected: (idx) => overflow[idx].onPressed(),
          ),
      ],
    );
  }
}
