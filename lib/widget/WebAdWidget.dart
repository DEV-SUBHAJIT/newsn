/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class WebAdWidget extends StatelessWidget {
  const WebAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Register the AdSense HTML element
      return Container(
        height: 100,
        child: HtmlElementView(
          viewType: 'ad-view',
        ),
      );
    } else {
      // Return a placeholder or nothing for non-web platforms
      return SizedBox.shrink();
    }
  }

  */
/*static void registerAdView() {
    if (kIsWeb) {
      // Register AdSense iframe view only on web platforms
      html.window.document.getElementById('ad-container')?.innerHtml = '''
        <ins class="adsbygoogle"
             style="display:block"
             data-ad-client="ca-pub-1234567890123456"
             data-ad-slot="1234567890"
             data-ad-format="auto"></ins>
        <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>
      ''';
    }
  }*//*

}
*/
