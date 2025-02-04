import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class RssFeedService {
  Future<List<RssItem>> fetchAllFeeds(rssUrls) async {
    List<RssItem> allNews = [];

    for (String url in rssUrls) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Decode the response as UTF-8
          final decodedBody = utf8.decode(response.bodyBytes);

          // Parse the RSS feed
          final document = xml.XmlDocument.parse(decodedBody);

          // Extract <item> nodes
          final items = document.findAllElements('item');

          // Map each <item> to an RssItem
          final rssItems =
              items.map((node) {
                return RssItem(
                  title: node.getElement('title')?.text ?? 'No Title',
                  pubDate: node.getElement('pubDate')?.text ?? '',
                  media: RssMedia(
                    contents: [
                      RssMediaContent(
                        url: node.findAllElements('media:content').firstOrNull?.getAttribute('url') ??
                            node.findAllElements('media:thumbnail').firstOrNull?.getAttribute('url'),
                      ),
                    ],
                  ),
                  newsContent: node.getElement('description')?.text ?? 'No Content',
                  newsLink: node.getElement('link')?.text ?? 'No Link',
                );
              }).toList();

          allNews.addAll(rssItems);
        } else {
          print('Failed to fetch RSS feed from $url: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching RSS feed from $url: $e');
      }
    }

    return allNews;
  }
}

class RssItem {
  final String title;
  final String newsContent;
  final String newsLink;
  final String pubDate;
  final RssMedia? media;

  RssItem({
    required this.title,
    required this.newsContent,
    required this.newsLink,
    required this.pubDate,
    this.media,
  });
}

class RssMedia {
  final List<RssMediaContent>? contents;

  RssMedia({this.contents});
}

class RssMediaContent {
  final String? url;

  RssMediaContent({this.url});
}
