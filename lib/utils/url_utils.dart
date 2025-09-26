import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/screens/browser/in_app_browser_screen.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:url_launcher/url_launcher.dart';

enum FileType { all, image, video, audio, document, archive, other }

enum FileCategory { downloads, images, audio, documents, videos }

class UriUtils {
  static Future<void> launchInBrowserWithConfirm(
      {required BuildContext context,
      required String url,
      required String content}) async {
    final loc = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.aboutToOpenUrlOutsideApp),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.ccontinue),
          ),
        ],
      ),
    );

    if (context.mounted && confirm == true) {
      await launchInBrowser(url, context);
    }
  }

  static String getFileName(String filePath) {
    return filePath.contains('/')
        ? filePath.split('/').last
        : filePath.split('\\').last;
  }

  /// Opens a URL in the default browser.
  static Future<void> launchInBrowser(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        late String e;
        if (url.isEmpty) {
          e = "The URL is empty.";
        } else {
          e = "There is no handler available, or that the application does not have permission to check. For example:\nOn recent versions of Android and iOS, this will always return false unless the application has been configuration to allow querying the system for launch support. See the README for details.\nOn web, this will always return false except for a few specific schemes that are always assumed to be supported (such as http(s)), as web pages are never allowed to query installed applications.";
        }
        _handleErrorOpenUrl(e, url, context);
      }
    } catch (e) {
      // Handle error silently or show user-friendly message
      _handleErrorOpenUrl(e, url, context);
    }
  }

  static void _handleErrorOpenUrl(Object e, String url, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(loc.errorOpeningUrl),
            content: SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(loc.canNotOpenUrl),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: url),
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: e.toString()),
                      maxLines: null,
                      expands: true,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Detail error:',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(loc.close),
              ),
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: url));
                  if (context.mounted) {
                    SnackBarUtils.showTyped(
                      context,
                      loc.linkCopiedToClipboard,
                      SnackBarType.success,
                    );
                  }
                },
                child: Text(loc.copyLink),
              ),
            ],
          );
        },
      );
    }
  }

  /// Universal URL viewer - opens in browser on desktop, in-app browser on mobile
  static Future<void> viewUniUrl(
    BuildContext context,
    String url,
  ) async {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width <= 800;

    if (isMobile) {
      // Mobile: Navigate to in-app browser screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InAppBrowserScreen(url: url),
        ),
      );
    } else {
      // Desktop: Open in external browser
      await launchInBrowser(url, context);
    }
  }
}
