import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class FilteredBrowser extends StatefulWidget {
  const FilteredBrowser({super.key, required this.service});
  final Service service;

  @override
  State<FilteredBrowser> createState() => _FilteredBrowserState();
}

class _FilteredBrowserState extends State<FilteredBrowser> {
  InAppWebViewController? _controller;
  double _progress = 0;
  bool _filterEnabled = true;

  // Conservative blocklist: third-party advertising and tracking hosts.
  // Media/CDN requests are deliberately not blocked to avoid breaking playback.
  static final _blockers = <ContentBlocker>[
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: r'^https?://([^/]*\.)?(doubleclick\.net|googlesyndication\.com|googleadservices\.com|adnxs\.com|criteo\.com|taboola\.com|outbrain\.com|scorecardresearch\.com|adsrvr\.org)([:/]|$)',
      ),
      action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
    ),
  ];

  Future<void> _external() async {
    await launchUrl(Uri.parse(widget.service.url),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.service.name),
      actions: [
        IconButton(
          tooltip: _filterEnabled ? 'Stäng av reklamfilter' : 'Aktivera reklamfilter',
          icon: Icon(_filterEnabled ? Icons.shield : Icons.shield_outlined),
          onPressed: () => setState(() => _filterEnabled = !_filterEnabled),
        ),
        IconButton(
          tooltip: 'Öppna i extern app',
          icon: const Icon(Icons.open_in_new),
          onPressed: _external,
        ),
        IconButton(
          tooltip: 'Ladda om',
          icon: const Icon(Icons.refresh),
          onPressed: () => _controller?.reload(),
        ),
      ],
    ),
    body: Column(children: [
      if (_progress < 1) LinearProgressIndicator(value: _progress),
      Expanded(child: InAppWebView(
        key: ValueKey(_filterEnabled),
        initialUrlRequest: URLRequest(url: WebUri(widget.service.url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
          contentBlockers: _filterEnabled ? _blockers : <ContentBlocker>[],
        ),
        onWebViewCreated: (controller) => _controller = controller,
        onProgressChanged: (_, progress) {
          if (mounted) setState(() => _progress = progress / 100);
        },
      )),
    ]),
  );
}
