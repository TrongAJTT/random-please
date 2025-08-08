import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/icon_utils.dart';
import 'package:random_please/utils/localization_utils.dart';
import 'package:random_please/utils/platform_utils.dart';
import 'package:random_please/utils/url_utils.dart';
import 'package:random_please/variables.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReleaseAsset {
  final String name;
  final int size;
  final String browserDownloadUrl;
  final DateTime updatedAt;

  ReleaseAsset({
    required this.name,
    required this.size,
    required this.browserDownloadUrl,
    required this.updatedAt,
  });

  factory ReleaseAsset.fromJson(Map<String, dynamic> json) {
    return ReleaseAsset(
      name: json['name'] ?? '',
      size: json['size'] ?? 0,
      browserDownloadUrl: json['browser_download_url'] ?? '',
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get sizeInMB {
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class ReleaseInfo {
  final String name;
  final String tag;
  final String body;
  final DateTime publishedAt;
  final List<ReleaseAsset> assets;

  ReleaseInfo({
    required this.name,
    required this.body,
    required this.tag,
    required this.publishedAt,
    required this.assets,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) {
    final assetsList = (json['assets'] as List<dynamic>?)
            ?.map((asset) => ReleaseAsset.fromJson(asset))
            .toList() ??
        [];

    return ReleaseInfo(
      name: json['name'],
      tag: json['tag_name'],
      body: json['body'],
      publishedAt: DateTime.parse(
          json['published_at'] ?? DateTime.now().toIso8601String()),
      assets: assetsList,
    );
  }
}

class VersionCheckService {
  static Future<ReleaseInfo?> fetchLatestRelease() async {
    try {
      final response = await http.get(
        Uri.parse(latestReleaseEndpoint),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': userAgent,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ReleaseInfo.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch release info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching release info: $e');
    }
  }

  static Future<bool> isCurrentVersionLatest() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final releaseInfo = await fetchLatestRelease();

      if (releaseInfo == null) return true;

      return _compareVersions(currentVersion, releaseInfo.tag) >= 0;
    } catch (e) {
      return true; // If we can't check, assume it's latest to avoid false positives
    }
  }

  static int _compareVersions(String version1, String version2) {
    // Remove 'v' prefix if present
    final v1 = version1.startsWith('v') ? version1.substring(1) : version1;
    final v2 = version2.startsWith('v') ? version2.substring(1) : version2;

    final v1Parts = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final v2Parts = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad with zeros to make them the same length
    while (v1Parts.length < v2Parts.length) {
      v1Parts.add(0);
    }
    while (v2Parts.length < v1Parts.length) {
      v2Parts.add(0);
    }

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }

    return 0;
  }

  static void showVersionDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(loc.checkingForUpdates),
          ],
        ),
      ),
    );

    try {
      final releaseInfo = await fetchLatestRelease();
      final packageInfo = await PackageInfo.fromPlatform();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (releaseInfo != null) {
          final isLatest =
              _compareVersions(packageInfo.version, releaseInfo.tag) >= 0;
          _showReleaseInfoDialog(context, releaseInfo, packageInfo, isLatest);
        } else {
          _showErrorDialog(context, loc.noNewUpdates);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorDialog(context, loc.updateCheckError(e.toString()));
      }
    }
  }

  static void _showReleaseInfoDialog(BuildContext context,
      ReleaseInfo releaseInfo, PackageInfo packageInfo, bool isLatest) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? MediaQuery.of(context).size.width * 0.95 : 700,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.update,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 28 : 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLatest
                                ? loc.usingLatestVersion
                                : loc.newVersionAvailable,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 18 : null,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                releaseInfo.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: isLatest
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile ? 14 : null,
                                    ),
                              ),
                              if (isLatest) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    loc.latest,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (!isLatest) ...[
                            const SizedBox(height: 4),
                            Text(
                              loc.currentVersion(packageInfo.version),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: isMobile ? 11 : null,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: isMobile ? 20 : 24,
                      ),
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 36 : 48,
                        minHeight: isMobile ? 36 : 48,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Release date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            loc.publishDate(LocalizationUtils.formatDateTime(
                                context: context,
                                dateTime: releaseInfo.publishedAt,
                                formatType: DateTimeFormatType.exceptSec)),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Release notes
                      Text(
                        loc.releaseNotes,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),

                      // Markdown content in a container with max height
                      // Markdown content in a container with max height
                      Container(
                        constraints: const BoxConstraints(maxHeight: 400),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Markdown(
                          data: releaseInfo.body.isEmpty
                              ? loc.noReleaseNotes
                              : releaseInfo.body,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          styleSheet: MarkdownStyleSheet(
                            p: Theme.of(context).textTheme.bodyMedium,
                            h1: Theme.of(context).textTheme.titleLarge,
                            h2: Theme.of(context).textTheme.titleMedium,
                            h3: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Always use Column layout for mobile to prevent overflow
                      if (isMobile) ...[
                        SizedBox(
                          width: double.infinity,
                          child: isLatest
                              ? ElevatedButton.icon(
                                  onPressed: null, // Disabled button
                                  icon: const Icon(Icons.check_circle),
                                  label: Text(
                                    loc.alreadyLatestVersion,
                                    textAlign: TextAlign.center,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Colors.green.withValues(alpha: 0.7),
                                    backgroundColor:
                                        Colors.green.withValues(alpha: 0.1),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: releaseInfo.assets.isNotEmpty
                                      ? () => _showDownloadDialog(
                                          context, releaseInfo.assets)
                                      : null,
                                  icon: const Icon(Icons.download),
                                  label: Text(loc.download),
                                ),
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: isLatest
                                  ? ElevatedButton.icon(
                                      onPressed: null, // Disabled button
                                      icon: const Icon(Icons.check_circle),
                                      label: Text(loc.alreadyLatestVersion),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Colors.green.withValues(alpha: 0.7),
                                        backgroundColor:
                                            Colors.green.withValues(alpha: 0.1),
                                      ),
                                    )
                                  : ElevatedButton.icon(
                                      onPressed: releaseInfo.assets.isNotEmpty
                                          ? () => _showDownloadDialog(
                                              context, releaseInfo.assets)
                                          : null,
                                      icon: const Icon(Icons.download),
                                      label: Text(loc.download),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showDownloadDialog(
      BuildContext context, List<ReleaseAsset> assets) {
    final filteredAssets = PlatformUtils.filterAssetsByPlatform(assets);
    final showAllAssets = filteredAssets.isEmpty;
    final assetsToShow = showAllAssets ? assets : filteredAssets;
    final loc = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? MediaQuery.of(context).size.width * 0.95 : 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: 200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 24 : 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loc.selectVersionToDownload,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 16 : null,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!showAllAssets) ...[
                            const SizedBox(height: 4),
                            Text(
                              loc.filteredForPlatform(
                                  PlatformUtils.getPlatformName()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: isMobile ? 11 : null,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: isMobile ? 20 : 24,
                      ),
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 36 : 48,
                        minHeight: isMobile ? 36 : 48,
                      ),
                    ),
                  ],
                ),
              ),

              // Asset list
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  itemCount: assetsToShow.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final asset = assetsToShow[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          radius: isMobile ? 18 : 20,
                          child: Icon(
                            IconUtils.getFileIconFromFileName(asset.name),
                            color: Theme.of(context).colorScheme.primary,
                            size: isMobile ? 18 : 20,
                          ),
                        ),
                        title: Text(
                          asset.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              loc.sizeInMB(asset.sizeInMB),
                              style: TextStyle(
                                fontSize: isMobile ? 12 : null,
                              ),
                            ),
                            Text(
                              loc.uploadDate(
                                LocalizationUtils.formatDateTime(
                                  context: context,
                                  dateTime: asset.updatedAt,
                                  formatType: DateTimeFormatType.exceptSec,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: isMobile ? 12 : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.download,
                          size: isMobile ? 20 : 24,
                        ),
                        onTap: () => _showDownloadConfirmation(context, asset),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16,
                          vertical: isMobile ? 4 : 8,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showDownloadConfirmation(
      BuildContext context, ReleaseAsset asset) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.confirmDownload),
        content: Text(
          loc.confirmDownloadMessage(
            asset.name,
            asset.sizeInMB,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              Navigator.of(context).pop(); // Close download dialog
              UriUtils.launchInBrowser(asset.browserDownloadUrl, context);
            },
            child: Text(loc.download),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.eerror),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.close),
          ),
        ],
      ),
    );
  }

  /// Tạo layout tải ứng dụng có thể đặt trong container hoặc scaffold
  static Widget buildDownloadAppLayout({
    required BuildContext context,
    bool showTitle = true,
    EdgeInsets? padding,
  }) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<ReleaseInfo?>(
      future: fetchLatestRelease(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(loc.checkingForUpdates),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.updateCheckError(snapshot.error.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Trigger rebuild to retry
                    (context as Element).markNeedsBuild();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(loc.retry),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(loc.noNewUpdates),
              ],
            ),
          );
        }

        final releaseInfo = snapshot.data!;
        final platformGroups =
            PlatformUtils.groupAssetsByPlatform(releaseInfo.assets);

        return SingleChildScrollView(
          padding: padding ?? EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.downloadAppDesc,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (showTitle) ...[
                // Header với thông tin phiên bản
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              releaseInfo.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.publishDate(LocalizationUtils.formatDateTime(
                                context: context,
                                dateTime: releaseInfo.publishedAt,
                                formatType: DateTimeFormatType.exceptSec,
                              )),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Danh sách các nền tảng
              Text(
                loc.selectPlatform,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              if (platformGroups.isEmpty)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(loc.noDownloadsAvailable),
                  ),
                )
              else
                ...platformGroups.entries.map(
                  (entry) => _buildPlatformCard(
                    context,
                    entry.key,
                    entry.value,
                    releaseInfo,
                    isMobile,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Tạo card cho từng nền tảng
  static Widget _buildPlatformCard(
    BuildContext context,
    String platform,
    List<ReleaseAsset> assets,
    ReleaseInfo releaseInfo,
    bool isMobile,
  ) {
    final loc = AppLocalizations.of(context)!;
    final totalSize = assets.fold<double>(
      0,
      (sum, asset) => sum + double.parse(asset.sizeInMB.replaceAll(' MB', '')),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () =>
            _showPlatformDownloadDialog(context, platform, assets, releaseInfo),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PlatformUtils.getPlatformColor(platform)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  PlatformUtils.getPlatformIcon(platform),
                  color: PlatformUtils.getPlatformColor(platform),
                  size: isMobile ? 24 : 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 16 : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${assets.length} ${loc.fileS} • ${totalSize.toStringAsFixed(1)} MB',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontSize: isMobile ? 14 : null,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: isMobile ? 16 : 20,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hiển thị dialog danh sách file cho nền tảng được chọn
  static void _showPlatformDownloadDialog(
    BuildContext context,
    String platform,
    List<ReleaseAsset> assets,
    ReleaseInfo releaseInfo,
  ) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? MediaQuery.of(context).size.width * 0.95 : 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: 200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                decoration: BoxDecoration(
                  color: PlatformUtils.getPlatformColor(platform)
                      .withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      PlatformUtils.getPlatformIcon(platform),
                      color: PlatformUtils.getPlatformColor(platform),
                      size: isMobile ? 24 : 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loc.downloadPlatform(platform),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 16 : null,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            releaseInfo.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: isMobile ? 12 : null,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: isMobile ? 20 : 24,
                      ),
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 36 : 48,
                        minHeight: isMobile ? 36 : 48,
                      ),
                    ),
                  ],
                ),
              ),

              // Asset list
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  itemCount: assets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              PlatformUtils.getPlatformColor(platform)
                                  .withValues(alpha: 0.1),
                          radius: isMobile ? 18 : 20,
                          child: Icon(
                            IconUtils.getFileIconFromFileName(asset.name),
                            color: PlatformUtils.getPlatformColor(platform),
                            size: isMobile ? 18 : 20,
                          ),
                        ),
                        title: Text(
                          asset.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              loc.sizeInMB(asset.sizeInMB),
                              style: TextStyle(
                                fontSize: isMobile ? 12 : null,
                              ),
                            ),
                            Text(
                              loc.uploadDate(
                                LocalizationUtils.formatDateTime(
                                  context: context,
                                  dateTime: asset.updatedAt,
                                  formatType: DateTimeFormatType.exceptSec,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: isMobile ? 12 : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.download,
                          size: isMobile ? 20 : 24,
                        ),
                        onTap: () => _showDownloadConfirmation(context, asset),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16,
                          vertical: isMobile ? 4 : 8,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
