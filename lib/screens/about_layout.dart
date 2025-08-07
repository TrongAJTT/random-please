import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/library_list.dart';
import 'package:random_please/screens/donors_acknowledgment_screen.dart';
import 'package:random_please/services/author_products_service.dart';
import 'package:random_please/services/version_check_service.dart';
import 'package:random_please/utils/url_utils.dart';
import 'package:random_please/utils/variables_utils.dart';
import 'package:random_please/widgets/generic/generic_settings_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:random_please/variables.dart';

/// About layout with GitHub, Sponsor, Credits, and Version information
class AboutLayout extends StatefulWidget {
  final bool showHeader;

  const AboutLayout({super.key, this.showHeader = true});

  @override
  State<AboutLayout> createState() => _AboutLayoutState();
}

class _AboutLayoutState extends State<AboutLayout> {
  PackageInfo? packageInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          packageInfo = info;
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error silently, will show fallback version
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // App Header (conditional)
          if (widget.showHeader) ...[
            _buildAppHeader(theme),
            const SizedBox(height: 24),
          ],

          // GitHub Repository section
          ListTile(
            leading: Icon(
              Icons.qr_code,
              color: theme.colorScheme.onPrimary,
            ),
            title: Text(l10n.githubRepo),
            subtitle: Text(l10n.githubRepoDesc),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => UriUtils.launchInBrowser(githubRepoUrl, context),
          ),

          // Donate section
          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text(l10n.donate),
            subtitle: Text(l10n.donateDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showDonateDialog,
          ),

          // Donors Acknowledgment section
          ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: Text(l10n.donorsAck),
              subtitle: Text(l10n.donorsAckDesc),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DonorsAcknowledgmentScreen(),
                  ),
                );
              }),

          // Credits & Acknowledgments section
          ListTile(
            leading: const Icon(
              Icons.groups,
              color: Colors.orange,
            ),
            title: Text(l10n.creditAck),
            subtitle: Text(l10n.creditAckDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showCreditsDialog,
          ),

          // Version Information section
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
            title: Text(l10n.versionInfo),
            subtitle: Text(_getVersionString()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showVersionDialog,
          ),

          // Update new version section
          ListTile(
            leading: const Icon(
              Icons.update,
              color: Colors.purple,
            ),
            title: Text(l10n.checkForNewVersion),
            subtitle: Text(l10n.checkForNewVersionDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              VersionCheckService.showVersionDialog(context);
            },
          ),

          // View author's products section
          ListTile(
            leading: const Icon(
              Icons.shopping_bag,
              color: Colors.green,
            ),
            title: Text(l10n.authorProducts),
            subtitle: Text(l10n.authorProductsDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              AuthorProductsService.navigateToAuthorProductsScreen(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppHeader(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset(
            imageAssetPath,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          appName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          appSlogan,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getVersionString() {
    final l10n = AppLocalizations.of(context)!;
    final versionType = currentVersionType.getDisplayName(l10n);

    if (isLoading || packageInfo == null) {
      return '${l10n.loading} ($versionType)';
    }

    return '${packageInfo!.version}+${packageInfo!.buildNumber} ($versionType)';
  }

  void _showDonateDialog() {
    final l10n = AppLocalizations.of(context)!;
    final config = GenericSettingsConfig<dynamic>(
      title: l10n.donate,
      settingsLayout: _buildDonateContent(),
      onSettingsChanged: (_) {},
    );

    GenericSettingsHelper.showSettings(context, config);
  }

  Widget _buildDonateContent() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Donation header
          const Icon(
            Icons.favorite,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.supportDesc,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 24),

          // Github Sponsors
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('GitHub Sponsors'),
            subtitle: Text(l10n.supportOnGitHub),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => UriUtils.launchInBrowser(githubSponsorUrl, context),
          ),
          // Buy me a Coffee
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Buy me a Coffee'),
            subtitle: Text(l10n.oneTimeDonation),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => UriUtils.launchInBrowser(buyMeACoffeeUrl, context),
          ),
          // Check language is Vietnamese for Momo donation
          if (Localizations.localeOf(context).languageCode == 'vi') ...[
            ListTile(
              leading: const Icon(Icons.mobile_friendly),
              title: const Text('Momo'),
              subtitle: Text(l10n.momoDonateDesc),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UriUtils.launchInBrowserWithConfirm(
                  context: context,
                  url: momoDonateUrl,
                  content: 'Momo không phải là nền tảng ủng hộ chuyên dụng!\n'
                      'Vui lòng để lại email để mình có thể liên hệ bạn.'),
            ),
          ],

          const SizedBox(height: 32),

          // Donor benefits
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.donorBenefits,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(l10n.donorBenefit1)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(l10n.donorBenefit2)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(l10n.donorBenefit3)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Check out the author's other products card
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: Text(l10n.alsoViewAuthorOtherProducts),
              subtitle: Text(l10n.authorProductsDesc),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                AuthorProductsService.navigateToAuthorProductsScreen(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  width: 2,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showCreditsDialog() {
    final l10n = AppLocalizations.of(context)!;
    final config = GenericSettingsConfig<dynamic>(
      title: l10n.creditAck,
      settingsLayout: _buildCreditsContent(),
      currentSettings: null,
      onSettingsChanged: (_) {},
      showActions: false,
      isCompact: false,
      barrierDismissible: true,
      padding: const EdgeInsets.all(16),
    );

    GenericSettingsHelper.showSettings(context, config);
  }

  Widget _buildCreditsContent() {
    final libraries = libraryList;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thank you authors card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.code,
                    color: Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.thanksLibAuthor,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.thanksLibAuthorDesc,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Libraries list
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: libraries.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lib = libraries[index];
              return ListTile(
                  title: Text(lib['name'] ?? ''),
                  subtitle:
                      Text('${lib['author'] ?? ''} • ${lib['license'] ?? ''}'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => UriUtils.launchInBrowser(
                      'https://pub.dev/packages/${lib['name'] ?? ''}',
                      context));
            },
          ),
        ),
      ],
    );
  }

  void _showVersionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final config = GenericSettingsConfig<dynamic>(
      title: l10n.versionInfo,
      settingsLayout: _buildVersionContent(),
      currentSettings: null,
      onSettingsChanged: (_) {},
      showActions: false,
      isCompact: false,
      barrierDismissible: true,
      padding: const EdgeInsets.all(16),
    );

    GenericSettingsHelper.showSettings(context, config);
  }

  Widget _buildVersionContent() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.tag),
            title: Text(l10n.appVersion),
            subtitle: Text(
                isLoading ? 'Loading...' : (packageInfo?.version ?? 'Unknown')),
          ),
          // ListTile(
          //   leading: const Icon(Icons.build),
          //   title: const Text('Build Number'),
          //   subtitle: Text(buildNumber),
          // ),
          ListTile(
            leading: const Icon(Icons.science),
            title: Text(l10n.versionType),
            subtitle: Text(currentVersionType.getDisplayName(l10n)),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: Text(l10n.platform),
            subtitle: Text(Theme.of(context).platform.name),
          ),
        ],
      ),
    );
  }
}
