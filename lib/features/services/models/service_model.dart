// Models representing service items and sections for services page
class ServiceItem {
  final String title;
  final String imgUrl;

  ServiceItem({required this.title, required this.imgUrl});
}

class ServiceSection {
  final String title;
  final List<ServiceItem> items;

  ServiceSection({required this.title, required this.items});
}
