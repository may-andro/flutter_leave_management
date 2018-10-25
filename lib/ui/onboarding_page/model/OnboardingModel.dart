class OnboardingItem {
  OnboardingItem({
    this.title,
    this.category,
    this.imageUrl,
  });

  final String title;
  final String category;
  final String imageUrl;
}

final sampleItems = <OnboardingItem>[
  new OnboardingItem(
    title: 'No more looking for Manager and HR before applying leaves',
    category: 'Hassel free',
    imageUrl: 'assets/images/page1.webp',
  ),
  new OnboardingItem(
    title: 'Everything is on your phone. Arrange your next holiday with ease',
    category: 'Centralized',
    imageUrl: 'assets/images/page2.webp',
  ),
  new OnboardingItem(
    title: 'Get notified when your leaves are approved and many more features',
    category: 'Connected',
    imageUrl: 'assets/images/page3.webp',
  ),
];
