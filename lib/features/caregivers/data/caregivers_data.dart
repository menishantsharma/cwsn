import 'package:cwsn/features/caregivers/models/caregiver_model.dart';

// Mock data representing a list of caregivers
final List<Caregiver> mockCaregivers = List.generate(10, (index) {
  final isMale = index % 2 == 0;
  return Caregiver(
    id: 'cg_$index',
    name: isMale ? 'Nishant Sharma' : 'Nisha Sharma',
    imageUrl:
        'https://randomuser.me/api/portraits/${isMale ? 'men' : 'women'}/$index.jpg',
    rating: 2000 + index * 10,
    isOnline: index % 3 == 0,
    isVerified: index % 2 == 0,
    isAvailable: index % 5 != 0,
  );
});
