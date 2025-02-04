import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newsn/model/news.dart';
import 'package:newsn/utils/const.dart';
import 'package:newsn/view/post_details.dart';
import 'package:newsn/widget/appbar.dart';
import 'package:shimmer/shimmer.dart';

import '../service/RssService.dart';
import '../widget/select_category.dart';

class RssFeedScreen extends StatefulWidget {
  const RssFeedScreen({Key? key}) : super(key: key);

  @override
  _RssFeedScreenState createState() => _RssFeedScreenState();
}

class _RssFeedScreenState extends State<RssFeedScreen> {
  late RssFeedService _rssFeedService;
  List<RssItem> _allNews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _rssFeedService = RssFeedService();
    _fetchAllFeeds([]);
  }

  Future<void> _fetchAllFeeds(List<String> rssUrls) async {
    try {
      if (rssUrls.isEmpty) {
        rssUrls = getRssUrlList('');
      }
      setState(() {
        _isLoading = true;
      });
      final rssItems = await _rssFeedService.fetchAllFeeds(rssUrls);

      _allNews = rssItems;

      setState(() {
        _allNews.shuffle();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching RSS feeds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomToolbar(title: 'NewsN'),
      body: Column(
        children: [
          SelectCategory(
            onTap: (categories) {
              setState(() {
                _fetchAllFeeds(categories);
              });
            },
          ),
          _isLoading
              ? Expanded(child: _buildShimmerEffect()) // Shimmer effect
              : _allNews.isEmpty
                  ? const Center(child: Text('No news available'))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isMobile(context)
                            ? ListView.builder(
                                itemCount: _allNews.length,
                                itemBuilder: (context, index) {
                                  final item = _allNews[index];
                                  News news = News(
                                    item.title,
                                    item.newsContent,
                                    item.newsLink,
                                    item.media!.contents!.first.url,
                                    item.pubDate,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      gotoNextPage(
                                          context, PostDetails(news: news));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 4,
                                      child: Column(
                                        children: [
                                          // Image Section (Flexible)
                                          Container(
                                            width: double.infinity,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: CachedNetworkImageProvider(item
                                                        .media
                                                        ?.contents
                                                        ?.first
                                                        .url ??
                                                    'https://picsum.photos/300/200?random=2'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          // Title and Date Section at the Bottom
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0,
                                              top: 4.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.title.trim(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2.0),
                                                Text(
                                                  item.pubDate?.trim() ??
                                                      'Unknown date',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : GridView.custom(
                                gridDelegate: SliverQuiltedGridDelegate(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  repeatPattern:
                                      QuiltedGridRepeatPattern.inverted,
                                  pattern: [
                                    QuiltedGridTile(2, 2),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 2),
                                  ],
                                ),
                                childrenDelegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final item = _allNews[index];
                                  News news = News(
                                    item.title,
                                    item.newsContent,
                                    item.newsLink,
                                    item.media!.contents!.first.url,
                                    item.pubDate,
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      gotoNextPage(
                                          context, PostDetails(news: news));
                                    },
                                    child: Tile(item: item),
                                  );
                                }, childCount: _allNews.length),
                              ),
                      ),
                    )
        ],
      ),
    );
  }

  // Function to create the Shimmer effect for the loading state
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4,
              child: Column(
                children: [
                  // Placeholder for Image Section
                  Container(
                    height: 150,
                    color: Colors.grey.shade200,
                  ),
                  // Placeholder for Title and Date Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 12.0,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 80,
                          height: 10.0,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final RssItem item;

  const Tile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fallback URL if media or contents are null
    final imageUrl = item.media?.contents?.first.url ??
        'https://picsum.photos/300/200?random=2';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        children: [
          // Image Section (Flexible)
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Title and Date Section at the Bottom
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
              top: 4.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.trim(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  item.pubDate?.trim() ?? 'Unknown date',
                  // Handle potential null for pubDate
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
