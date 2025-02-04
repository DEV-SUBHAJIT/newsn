import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:newsn/view/webview.dart';
import '../model/news.dart';
import '../utils/const.dart';
import '../widget/appbar.dart';

class PostDetails extends StatefulWidget {
  static const String id = "PostDetails";

  final News news;

  const PostDetails({super.key, required this.news});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    // Initialize the Google Mobile Ads SDK
    MobileAds.instance.initialize();

    // Create and load the banner ad
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: BANNER_AD_UNIT,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            // Banner ad loaded successfully
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
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
      appBar: CustomToolbar(title: widget.news.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display thumbnail image
            Image.network(
              widget.news.thumbnailUrl ??
                  "https://picsum.photos/300/200?random=2",
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HtmlWidget(
                HtmlUnescape().convert(widget.news.title),
                textStyle: TextStyle(fontSize: getTextSize(context, 16), fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Display banner ad
            Center(
              child: SizedBox(
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),

            const SizedBox(height: 8),

            // Render decoded HTML content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HtmlWidget(
                HtmlUnescape().convert(widget.news.newsContent),
                textStyle: TextStyle(fontSize: getTextSize(context, 16)),
              ),
            ),

            // Button to open the source link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      title: "Source",
                      url: widget.news.newsLink,
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width/3,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                margin: EdgeInsets.only(bottom: 12, left: 16, right: 16, top: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // Optional: Background color
                  border: Border.all(
                    color: THEME_COLOR, // Set border color
                    width: 1.0, // Set border width
                  ),
                  borderRadius: BorderRadius.circular(5.0), // Set corner radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Source", style: TextStyle(color: THEME_COLOR),),
                    Icon(Icons.arrow_right_alt, color: THEME_COLOR,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
