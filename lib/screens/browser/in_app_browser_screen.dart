import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/url_utils.dart';

class InAppBrowserScreen extends StatefulWidget {
  final String url;

  const InAppBrowserScreen({
    super.key,
    required this.url,
  });

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _currentTitle;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            // Get page title
            final title = await _controller.getTitle();
            if (title != null && title.isNotEmpty) {
              setState(() {
                _currentTitle = title;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.loadUrlError}: ${error.description}',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _showUrlOptionsDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.info),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.currentUrl,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.url,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.copy),
                      label: Text(
                        loc.copyLink,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.url));
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          SnackBarUtils.showTyped(
                            context,
                            loc.linkCopiedToClipboard,
                            SnackBarType.success,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.open_in_browser),
                      label: Text(
                        loc.openInBrowser,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        UriUtils.launchInBrowser(widget.url, context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showUrlOptionsDialog(context),
          child: Text(
            _currentTitle ?? l10n.inAppBrowser,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
            tooltip: l10n.refresh,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'go_back':
                  if (await _controller.canGoBack()) {
                    await _controller.goBack();
                  }
                  break;
                case 'go_forward':
                  if (await _controller.canGoForward()) {
                    await _controller.goForward();
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'go_back',
                child: Text(l10n.goBack),
              ),
              PopupMenuItem(
                value: 'go_forward',
                child: Text(l10n.goForward),
              ),
            ],
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
