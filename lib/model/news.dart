class News {
  late String title,
      newsContent,
      newsLink,
      pubDate;
  var thumbnailUrl;

  News( this.title, this.newsContent, this.newsLink,
      this.thumbnailUrl, this.pubDate);

  News.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    newsContent = json["newsContent"];
    newsLink = json["newsLink"];
    thumbnailUrl = json["thumbnailUrl"];
    pubDate = json["pubDate"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['newsContent'] = newsContent;
    data['newsLink'] = newsLink;
    data['thumbnailUrl'] = thumbnailUrl;
    data['pubDate'] = pubDate;
    return data;
  }
}