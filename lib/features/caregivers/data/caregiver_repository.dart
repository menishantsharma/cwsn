import 'package:cwsn/features/caregivers/data/caregivers_data.dart';
import 'package:cwsn/features/caregivers/models/caregiver_model.dart';

class CaregiverRepository {
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<List<Caregiver>> getCaregiversList() async {
    await _simulateNetworkDelay();
    return mockCaregivers;
  }

  Future<Caregiver> getCaregiverDetails(String id) async {
    await _simulateNetworkDelay();
    final index = int.tryParse(id.split('_').last) ?? 0;
    final isMale = index % 2 == 0;
    return Caregiver(
      id: id,
      name: isMale ? 'Nishant Sharma' : 'Nisha Sharma',
      imageUrl:
          'https://randomuser.me/api/portraits/${isMale ? 'men' : 'women'}/$index.jpg',
      rating: 2000 + (index * 5),
      isOnline: true, // Let's say they are online now
      location: 'Hostel 14, IIT Bombay, Mumbai, 400076',
      about:
          'This is the FULL profile loaded from the server. I have 5 years of experience in special education and have worked with over 50 families in Mumbai.',
      joinedDate: 'Jan 2023',
      services: [
        'Shadow Teacher',
        'Special Educator',
        'Travel Guide',
        'Therapy Asst',
      ],
      languages: ['Hindi', 'English', 'Marathi'],
    );
  }
}
