import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

/// Represents an individual service card (e.g., "Special School", "Speech Therapy")
@freezed
class ServiceItem with _$ServiceItem {
  const factory ServiceItem({
    required String title,
    
    /// The path to the image (can be a network URL or an Asset path)
    required String imgUrl,
    
    /// Optional: Add an ID if you want to navigate to a specific service detail page
    String? id,
  }) = _ServiceItem;

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);
}

/// Represents a horizontal row or a category of services on the Services Page
@freezed
class ServiceSection with _$ServiceSection {
  const factory ServiceSection({
    required String title,
    
    /// The list of service cards belonging to this specific category
    @Default([]) List<ServiceItem> items,
  }) = _ServiceSection;

  factory ServiceSection.fromJson(Map<String, dynamic> json) =>
      _$ServiceSectionFromJson(json);
}