String numberOfRecommendationsToK(int recommendations) {
  if (recommendations >= 1000000) {
    final mValue = (recommendations / 1000000).toStringAsFixed(1);
    return "${mValue}M";
  } else if (recommendations >= 1000) {
    final kValue = (recommendations / 1000).toStringAsFixed(1);
    return "${kValue}k";
  } else {
    return recommendations.toString();
  }
}
