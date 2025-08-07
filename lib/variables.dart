const VersionType currentVersionType = VersionType.release;

const String appCode = 'random_please';
const String appName = 'Random Please';
const String appSlogan = "Convenient randomizer tool that can help you anytime";
const String appAssetIcon = 'assets/app_icon.png';

const String githubRepoUrl = 'https://github.com/TrongAJTT/random-please';
const String githubSponsorUrl = 'https://github.com/sponsors/TrongAJTT';
const String buyMeACoffeeUrl = 'https://www.buymeacoffee.com/trongajtt';
const String momoDonateUrl =
    'https://me.momo.vn/8vI1TzseFRFQF3UquBU1fz/5xe79k5vr5VAb7r';

// Replace <locale> with the actual locale code
const String supportersAcknowledgmentUrl =
    'https://raw.githubusercontent.com/TrongAJTT/TrongAJTT/refs/heads/main/SUPPORTERS.json';

const String latestReleaseEndpoint =
    'https://api.github.com/repos/TrongAJTT/random-please/releases/latest';
const String authorProductsEndpoint =
    'https://raw.githubusercontent.com/TrongAJTT/TrongAJTT/refs/heads/main/MY_PRODUCTS.json';
const String authorAvatarEndpoint =
    'https://avatars.githubusercontent.com/u/157729907?v=4';

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
