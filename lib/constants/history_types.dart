/// Constants for history types used across the application
class HistoryTypes {
  // Private constructor to prevent instantiation
  HistoryTypes._();

  /// Number Generator history type
  static const String number = 'number';

  /// List Picker Generator history type
  static const String listPicker = 'listpicker';

  /// Password Generator history type
  static const String password = 'password';

  /// Color Generator history type
  static const String color = 'color';

  /// Yes/No Generator history type
  static const String yesNo = 'yes_no';

  /// Coin Flip Generator history type
  static const String coinFlip = 'coin_flip';

  /// Rock Paper Scissors Generator history type
  static const String rockPaperScissors = 'rock_paper_scissors';

  /// Dice Roll Generator history type
  static const String diceRoll = 'dice_roll';

  /// Latin Letter Generator history type
  static const String latinLetter = 'latin_letter';

  /// Playing Card Generator history type
  static const String playingCard = 'playing_card';

  /// Date Generator history type
  static const String date = 'date';

  /// Time Generator history type
  static const String time = 'time';

  /// Date Time Generator history type
  static const String dateTime = 'date_time';

  /// Lorem Ipsum Generator history type
  static const String loremIpsum = 'lorem_ipsum';

  /// Get all available history types
  static List<String> get all => [
        number,
        listPicker,
        password,
        color,
        yesNo,
        coinFlip,
        rockPaperScissors,
        diceRoll,
        latinLetter,
        playingCard,
        date,
        time,
        dateTime,
        loremIpsum,
      ];
}
