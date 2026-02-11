import 'package:cwsn/core/models/user_model.dart';

final user = User(
  id: '1',
  firstName: 'Nishant Sharma',
  imageUrl: 'https://randomuser.me/api/portraits/men/0.jpg',
);

final caregivers = [
  User(
    id: '2',
    firstName: 'Amit Kumar',
    imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    caregiverProfile: CaregiverProfile(
      about: 'Experienced caregiver with a passion for helping others.',
      rating: 4,
      services: ['Elderly Care', 'Child Care', 'Disability Support'],
      isVerified: true,
      isAvailable: true,
      languages: ['English', 'Hindi'],
      joinedDate: DateTime(2020, 1, 15),
      yearsOfExperience: 5,
      totalRecommendations: 20000,
    ),
  ),
  User(
    id: '3',
    firstName: 'Priya Singh',
    imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    caregiverProfile: CaregiverProfile(
      about: 'Compassionate caregiver with 3 years of experience.',
      rating: 5,
      services: ['Child Care', 'Special Needs Support'],
      isVerified: true,
      isAvailable: false,
      languages: ['English', 'Hindi', 'Marathi'],
      joinedDate: DateTime(2021, 6, 10),
      yearsOfExperience: 3,
      totalRecommendations: 1500,
    ),
  ),
  User(
    id: '4',
    firstName: 'Rahul Verma',
    imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    caregiverProfile: CaregiverProfile(
      about: 'Reliable caregiver specializing in elderly care.',
      rating: 3,
      services: ['Elderly Care', 'Disability Support'],
      isVerified: false,
      isAvailable: true,
      languages: ['English', 'Hindi'],
      joinedDate: DateTime(2019, 3, 5),
      yearsOfExperience: 7,
      totalRecommendations: 1000000,
    ),
  ),
];
