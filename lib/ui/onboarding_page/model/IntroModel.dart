class IntroItem {
  IntroItem({
    this.title,
    this.category,
    this.imageUrl,
  });

  final String title;
  final String category;
  final String imageUrl;
}

final sampleItems = <IntroItem>[
  new IntroItem(title: 'No more looking for Manager and HR before applying leaves', category: 'Hassel free', imageUrl: 'assets/page1.jpg',),
  new IntroItem(title: 'Everything is on your phone. Arrange your next holiday with ease', category: 'Centralized', imageUrl: 'assets/page2.jpg',),
  new IntroItem(title: 'Get notified when your leaves are approved and many more features', category: 'Connected', imageUrl: 'assets/page3.jpg',),
];