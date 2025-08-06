import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
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
import 'package:random_please/widgets/generic/section_item.dart';
import 'package:random_please/widgets/generic/section_list_view.dart';
import 'package:random_please/widgets/generic/section_grid_view.dart';

class RandomToolsScreen extends StatelessWidget {
  final bool isEmbedded;
  final Function(Widget, String, {String? parentCategory, IconData? icon})?
      onToolSelected;

  const RandomToolsScreen({
    super.key,
    this.isEmbedded = false,
    this.onToolSelected,
  });

  List<SectionItem> _buildSections(AppLocalizations loc) {
    return [
      SectionItem(
        id: 'password_generator',
        title: loc.passwordGenerator,
        subtitle: loc.passwordGeneratorDesc,
        icon: Icons.password_rounded,
        iconColor: Colors.purple,
        content: PasswordGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'number_generator',
        title: loc.numberGenerator,
        subtitle: loc.numberGeneratorDesc,
        icon: Icons.tag,
        iconColor: Colors.blue,
        content: NumberGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'yes_no',
        title: loc.yesNo,
        subtitle: loc.yesNoDesc,
        icon: Icons.question_answer,
        iconColor: Colors.orange,
        content: YesNoGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'coin_flip',
        title: loc.flipCoin,
        subtitle: loc.flipCoinDesc,
        icon: Icons.monetization_on,
        iconColor: Colors.amber,
        content: CoinFlipGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'rock_paper_scissors',
        title: loc.rockPaperScissors,
        subtitle: loc.rockPaperScissorsDesc,
        icon: Icons.sports_mma,
        iconColor: Colors.brown,
        content: RockPaperScissorsGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'dice_roll',
        title: loc.rollDice,
        subtitle: loc.rollDiceDesc,
        icon: Icons.casino,
        iconColor: Colors.red,
        content: DiceRollGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'color_generator',
        title: loc.colorGenerator,
        subtitle: loc.colorGeneratorDesc,
        icon: Icons.palette,
        iconColor: Colors.pink,
        content: ColorGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'latin_letters',
        title: loc.latinLetters,
        subtitle: loc.latinLettersDesc,
        icon: Icons.abc,
        iconColor: Colors.indigo,
        content: LatinLetterGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'playing_cards',
        title: loc.playingCards,
        subtitle: loc.playingCardsDesc,
        icon: Icons.style,
        iconColor: Colors.deepOrange,
        content: PlayingCardGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'date_generator',
        title: loc.dateGenerator,
        subtitle: loc.dateGeneratorDesc,
        icon: Icons.calendar_today,
        iconColor: Colors.green,
        content: DateGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'time_generator',
        title: loc.timeGenerator,
        subtitle: loc.timeGeneratorDesc,
        icon: Icons.access_time,
        iconColor: Colors.cyan,
        content: TimeGeneratorScreen(isEmbedded: isEmbedded),
      ),
      SectionItem(
        id: 'date_time_generator',
        title: loc.dateTimeGenerator,
        subtitle: loc.dateTimeGeneratorDesc,
        icon: Icons.schedule,
        iconColor: Colors.teal,
        content: DateTimeGeneratorScreen(isEmbedded: isEmbedded),
      ),
    ];
  }

  void _onSectionSelected(
      String sectionId, AppLocalizations loc, BuildContext context) {
    final sections = _buildSections(loc);
    final section = sections.firstWhere((s) => s.id == sectionId);

    if (isEmbedded && onToolSelected != null) {
      // Desktop mode: sử dụng callback để hiển thị công cụ trong main widget
      onToolSelected!(section.content, section.title,
          parentCategory: 'RandomToolsScreen', icon: section.icon);
    } else {
      // Mobile mode: navigation stack bình thường
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => section.content),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    final sections = _buildSections(loc);

    Widget content;
    if (isDesktop) {
      // Desktop: Use AutoScaleSectionGridView
      content = AutoScaleSectionGridView(
        sections: sections,
        onSectionSelected: (sectionId) =>
            _onSectionSelected(sectionId, loc, context),
        minCellWidth: 400,
        fixedCellHeight: 100,
        decorator: const SectionGridDecorator(
          padding: EdgeInsets.all(16),
        ),
      );
    } else {
      // Mobile: Use SectionListView
      content = SectionListView(
        sections: sections,
        onSectionSelected: (sectionId) =>
            _onSectionSelected(sectionId, loc, context),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      );
    }

    return content;
  }
}
