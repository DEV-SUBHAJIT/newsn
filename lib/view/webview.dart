import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../utils/const.dart';
import '../widget/WebAdWidget.dart';
import '../widget/appbar.dart';
import '../widget/color_loader.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = true;
  late final WebViewController _webViewController;
  late BannerAd _bannerAd;

  late PlatformWebViewController _controller;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _isLoading = false;
      _controller = PlatformWebViewController(
        const PlatformWebViewControllerCreationParams(),
      )..loadRequest(
          LoadRequestParams(
            uri: Uri.parse(widget.url),
          ),
        );
    } else {
      // Initialize the WebViewController
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (_) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (error) {
              // Handle errors (optional)
              debugPrint('Error loading page: $error');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }

    // Initialize the Google Mobile Ads SDK
    MobileAds.instance.initialize();

    // Create a BannerAd instance
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: BANNER_AD_UNIT,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            // Banner ad loaded successfully
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
    );

    // Load the banner ad
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomToolbar(title: widget.title),
      body: Stack(
        children: [
          kIsWeb
              ? PlatformWebViewWidget(
                  PlatformWebViewWidgetCreationParams(controller: _controller),
                ).build(context)
              : WebViewWidget(controller: _webViewController),
          if (_isLoading)
            const Center(
              child: ColorLoader(),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child:/* kIsWeb
                ? WebAdWidget() // Show AdSense on the web
                :*/ SizedBox(
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd), // Show AdMob on mobile
                  ),
          ),
        ],
      ),
    );
  }
}
