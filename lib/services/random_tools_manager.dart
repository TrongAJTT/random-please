import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/tool_order_service.dart';
import 'package:random_please/widgets/generic/section_item.dart' as generic;
import 'package:random_please/screens/random_tools/password_generator.dart';
import 'package:random_please/screens/random_tools/number_generator.dart';
import 'package:random_please/screens/random_tools/yes_no_generator.dart';
import 'package:random_please/screens/random_tools/coin_flip_generator.dart';
import 'package:random_please/screens/random_tools/rock_paper_scissors_generator.dart';
import 'package:random_please/screens/random_tools/dice_roll_generator.dart';
import 'package:random_please/screens/random_tools/color_generator.dart';
import 'package:random_please/screens/random_tools/latin_letter_generator.dart';
import 'package:random_please/screens/random_tools/playing_card_generator.dart';
import 'package:random_please/screens/random_tools/date_generator.dart';
import 'package:random_please/screens/random_tools/time_generator.dart';
import 'package:random_please/screens/random_tools/date_time_generator.dart';
import 'package:random_please/screens/random_tools/lorem_ipsum_generator.dart';
import 'package:random_please/screens/random_tools/list_picker_generator.dart';

/// Manages the list and order of all random tools
class RandomToolsManager {
  /// Get all tools in the user-defined order
  static Future<List<ToolItem>> getOrderedTools(AppLocalizations loc) async {
    final order = await ToolOrderService.getToolOrder();
    final allTools = _getAllTools(loc);

    // Create a map for quick lookup
    final toolMap = {for (var tool in allTools) tool.id: tool};

    // Return tools in the saved order
    return order
        .where((id) => toolMap.containsKey(id))
        .map((id) => toolMap[id]!)
        .toList();
  }

  /// Get all available tools with default properties
  static List<ToolItem> _getAllTools(AppLocalizations loc) {
    return [
      ToolItem(
        id: 'password',
        title: loc.passwordGenerator,
        subtitle: loc.passwordGeneratorDesc,
        icon: Icons.lock_outline,
        color: Colors.purple,
        screenBuilder: (isEmbedded) =>
            PasswordGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'number',
        title: loc.numberGenerator,
        subtitle: loc.numberGeneratorDesc,
        icon: Icons.tag,
        color: Colors.blue,
        screenBuilder: (isEmbedded) =>
            NumberGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'yesno',
        title: loc.yesNo,
        subtitle: loc.yesNoDesc,
        icon: Icons.help_outline,
        color: Colors.orange,
        screenBuilder: (isEmbedded) =>
            YesNoGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'coin',
        title: loc.flipCoin,
        subtitle: loc.flipCoinDesc,
        icon: Icons.monetization_on_outlined,
        color: Colors.amber,
        screenBuilder: (isEmbedded) =>
            CoinFlipGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'rps',
        title: loc.rockPaperScissors,
        subtitle: loc.rockPaperScissorsDesc,
        icon: Icons.back_hand_outlined,
        color: Colors.brown,
        screenBuilder: (isEmbedded) =>
            RockPaperScissorsGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'dice',
        title: loc.rollDice,
        subtitle: loc.rollDiceDesc,
        icon: Icons.casino_outlined,
        color: Colors.red,
        screenBuilder: (isEmbedded) =>
            DiceRollGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'color',
        title: loc.colorGenerator,
        subtitle: loc.colorGeneratorDesc,
        icon: Icons.palette_outlined,
        color: Colors.pink,
        screenBuilder: (isEmbedded) =>
            ColorGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'letters',
        title: loc.latinLetters,
        subtitle: loc.latinLettersDesc,
        icon: Icons.abc,
        color: Colors.indigo,
        screenBuilder: (isEmbedded) =>
            LatinLetterGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'cards',
        title: loc.playingCards,
        subtitle: loc.playingCardsDesc,
        icon: Icons.style_outlined,
        color: Colors.teal,
        screenBuilder: (isEmbedded) =>
            PlayingCardGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'date',
        title: loc.dateGenerator,
        subtitle: loc.dateGeneratorDesc,
        icon: Icons.calendar_today_outlined,
        color: Colors.green,
        screenBuilder: (isEmbedded) =>
            DateGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'time',
        title: loc.timeGenerator,
        subtitle: loc.timeGeneratorDesc,
        icon: Icons.schedule_outlined,
        color: Colors.cyan,
        screenBuilder: (isEmbedded) =>
            TimeGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'datetime',
        title: loc.dateTimeGenerator,
        subtitle: loc.dateTimeGeneratorDesc,
        icon: Icons.access_time_outlined,
        color: Colors.deepPurple,
        screenBuilder: (isEmbedded) =>
            DateTimeGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'lorem',
        title: loc.loremIpsumGenerator,
        subtitle: loc.loremIpsumGeneratorDesc,
        icon: Icons.text_fields,
        color: Colors.teal.shade700,
        screenBuilder: (isEmbedded) =>
            LoremIpsumGeneratorScreen(isEmbedded: isEmbedded),
      ),
      ToolItem(
        id: 'listpicker',
        title: loc.listPicker,
        subtitle: loc.listPickerDesc,
        icon: Icons.format_list_bulleted,
        color: Colors.deepOrange,
        screenBuilder: (isEmbedded) =>
            ListPickerGeneratorScreen(isEmbedded: isEmbedded),
      ),
    ];
  }

  /// Find a specific tool by ID
  static ToolItem? findToolById(String id, List<ToolItem> tools) {
    try {
      return tools.firstWhere((tool) => tool.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Convert tools to SectionItem format for use in section-based layouts
  static List<generic.SectionItem> toolsToSectionItems(List<ToolItem> tools) {
    return tools
        .map((tool) => generic.SectionItem(
              id: tool.id,
              title: tool.title,
              subtitle: tool.subtitle,
              icon: tool.icon,
              iconColor: tool.color,
              content: tool.screenBuilder(
                  true), // Use embedded version for section items
            ))
        .toList();
  }
}

/// Convert SectionItem to ToolItem when needed
extension SectionItemToToolItem on generic.SectionItem {
  ToolItem toToolItem(Widget Function(bool isEmbedded) screenBuilder) {
    return ToolItem(
      id: id,
      title: title,
      subtitle: subtitle ?? '',
      icon: icon,
      color: iconColor ?? Colors.grey,
      screenBuilder: screenBuilder,
    );
  }
}
