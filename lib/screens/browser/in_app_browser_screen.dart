import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/url_utils.dart';

class InAppBrowserScreen extends StatefulWidget {
  final String url;
  final bool confirmExit;

  const InAppBrowserScreen({
    super.key,
    required this.url,
    this.confirmExit = false,
  });

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _currentTitle;
  String _currentUrl = '';
  bool _canGoBack = false;
  bool _canGoForward = false;
  Timer? _navigationTimer;
  bool _hasShownExitConfirmation = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _initWebView();
    _startNavigationTimer();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle messages from JavaScript
          if (message.message.startsWith('URL_CHANGE:')) {
            final newUrl = message.message.substring(11);
            if (mounted) {
              setState(() {
                _currentUrl = newUrl;
              });
              _updateNavigationState();
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
              _currentUrl = url;
            });

            // Inject JavaScript to track SPA navigation
            await _injectSPATracking();

            // Get page title
            final title = await _controller.getTitle();
            if (title != null && title.isNotEmpty) {
              setState(() {
                _currentTitle = title;
              });
            }

            // Update navigation state
            _updateNavigationState();
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

  void _updateNavigationState() async {
    try {
      final canGoBack = await _controller.canGoBack();
      final canGoForward = await _controller.canGoForward();

      // Also get current URL from WebView
      final currentUrl = await _controller.currentUrl();
      if (currentUrl != null && currentUrl != _currentUrl) {
        setState(() {
          _currentUrl = currentUrl;
        });
      }

      if (mounted) {
        setState(() {
          _canGoBack = canGoBack;
          _canGoForward = canGoForward;
        });
      }
    } catch (e) {
      // Handle errors gracefully
      logError('Navigation state update error: $e');
    }
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_isLoading) {
        _updateNavigationState();
      }
    });
  }

  void _handlePopInvoked(bool didPop) {
    if (didPop) return; // Already popped

    if (!widget.confirmExit) {
      Navigator.of(context).pop(); // Allow back navigation
      return;
    }

    if (!_hasShownExitConfirmation) {
      _hasShownExitConfirmation = true;
      final loc = AppLocalizations.of(context)!;

      SnackBarUtils.showTyped(
        context,
        loc.pressBackAgainToExit,
        SnackBarType.info,
      );

      // Reset confirmation after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _hasShownExitConfirmation = false;
        }
      });

      return; // Prevent back navigation
    }

    Navigator.of(context).pop(); // Allow back navigation on second press
  }

  Future<void> _injectSPATracking() async {
    try {
      // Inject JavaScript to track SPA navigation
      await _controller.runJavaScript('''
        (function() {
          // Track URL changes for SPA
          let currentUrl = window.location.href;
          
          // Override pushState and replaceState to track navigation
          const originalPushState = history.pushState;
          const originalReplaceState = history.replaceState;
          
          history.pushState = function() {
            originalPushState.apply(history, arguments);
            currentUrl = window.location.href;
            // Notify Flutter about URL change
            if (window.FlutterChannel) {
              window.FlutterChannel.postMessage('URL_CHANGE:' + currentUrl);
            }
          };
          
          history.replaceState = function() {
            originalReplaceState.apply(history, arguments);
            currentUrl = window.location.href;
            // Notify Flutter about URL change
            if (window.FlutterChannel) {
              window.FlutterChannel.postMessage('URL_CHANGE:' + currentUrl);
            }
          };
          
          // Listen for popstate events
          window.addEventListener('popstate', function() {
            currentUrl = window.location.href;
            window.flutter_inappwebview.callHandler('onUrlChange', currentUrl);
          });
          
          // Listen for hashchange events
          window.addEventListener('hashchange', function() {
            currentUrl = window.location.href;
            window.flutter_inappwebview.callHandler('onUrlChange', currentUrl);
          });
          
          // Initial URL
          window.flutter_inappwebview.callHandler('onUrlChange', currentUrl);
        })();
      ''');
    } catch (e) {
      // Ignore JavaScript errors
      logError('JavaScript injection error: $e');
    }
  }

  void _showUrlOptionsDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  loc.info,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.currentUrl,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: SelectableText(
                  _currentUrl,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      icon: const Icon(Icons.copy, size: 18),
                      label: Text(
                        loc.copyLink,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: _currentUrl));
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.open_in_browser, size: 18),
                      label: Text(
                        loc.openInBrowser,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        UriUtils.launchInBrowser(_currentUrl, context);
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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _handlePopInvoked(didPop),
      child: Scaffold(
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
              icon: const Icon(Icons.arrow_back),
              onPressed: _canGoBack
                  ? () async {
                      await _controller.goBack();
                      _updateNavigationState();
                    }
                  : null,
              tooltip: l10n.goBack,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
              tooltip: l10n.refresh,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _canGoForward
                  ? () async {
                      await _controller.goForward();
                      _updateNavigationState();
                    }
                  : null,
              tooltip: l10n.goForward,
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
