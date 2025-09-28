const VersionType currentVersionType = VersionType.release;

const String appCode = 'random_please';
const String appName = 'Random Please';
const String appSlogan = "Convenient randomizer tool that can help you anytime";
const String appAssetIcon = 'assets/app_icon.png';
const String appAssetIconUrl =
    'https://raw.githubusercontent.com/TrongAJTT/random-please/main/assets/app_icon.png';

const String termsOfUseUrl =
    'https://www.trongajtt.com/apps/random-please/terms/latest/';

const String githubRepoUrl = 'https://github.com/TrongAJTT/random-please';
const String githubSponsorUrl = 'https://github.com/sponsors/TrongAJTT';
const String buyMeACoffeeUrl = 'https://www.buymeacoffee.com/trongajtt';

const String latestReleaseEndpoint =
    'https://api.github.com/repos/TrongAJTT/random-please/releases/latest';

const String authorAvatarEndpoint =
    'https://avatars.githubusercontent.com/u/157729907?v=4';

const String authorCloudListRoute =
    "https://www.trongajtt.com/apps/random-please/list-template";
const String authorCloudListEndpoint = "$authorCloudListRoute/all.json";

const String listPickerTemplateHelpUrl =
    'https://www.trongajtt.com/apps/random-please/list-template/';

const String appGuidesUrl =
    'https://www.trongajtt.com/apps/random-please/guides/';

const String userAgent = "Random-Please-App";
const String imageAssetPath = "assets/app_icon.png";

const double tabletScreenWidthThreshold = 600.0;
const double desktopScreenWidthThreshold = 1024.0;

const int p2pChatMediaWaitTimeBeforeDelete = 6; // seconds
const int p2pChatClipboardPollingInterval = 3; // seconds

// This enum represents the different types of app versions.
// It is used to determine the current version type of the application.
enum VersionType {
  release,
  beta,
  dev,
}
