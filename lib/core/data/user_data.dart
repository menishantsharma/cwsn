import 'package:cwsn/core/models/caregiver_service_model.dart';
import 'package:cwsn/core/models/user_model.dart';

final user = User(
  id: '1',
  firstName: 'Nishant Sharma',
  imageUrl: 'https://randomuser.me/api/portraits/men/0.jpg',
  gender: Gender.male,
);

final caregivers = [
  User(
    id: '2',
    firstName: 'Amit Kumar',
    imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    gender: Gender.male,
    caregiverProfile: CaregiverProfile(
      about: 'Experienced caregiver with a passion for helping others.',
      services: [
        CaregiverService(
          id: 's1',
          name: 'Shadow Teacher',
          specialNeeds: ['Autism Spectrum Disorder (ASD)', 'ADHD'],
        ),
        CaregiverService(
          id: 's2',
          name: 'Occupational',
          specialNeeds: ['Cerebral Palsy', 'Physical Disabilities'],
        ),
        CaregiverService(
          id: 's3',
          name: 'Speech Tutor',
          specialNeeds: ['Speech and Language Disorders'],
        ),
      ],
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
    gender: Gender.female,
    caregiverProfile: CaregiverProfile(
      about: 'Compassionate caregiver with 3 years of experience.',
      services: [
        CaregiverService(
          id: 's4',
          name: 'Behavioral (ABA)',
          specialNeeds: [
            'Autism Spectrum Disorder (ASD)',
            'Emotional and Behavioral Disorders',
          ],
        ),
        CaregiverService(
          id: 's5',
          name: 'Early Intervention',
          specialNeeds: ['Down Syndrome', 'Intellectual Disabilities'],
          isActive: false,
        ),
      ],
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
    gender: Gender.male,
    caregiverProfile: CaregiverProfile(
      about: 'Reliable caregiver specializing in elderly care.',
      services: [
        CaregiverService(
          id: 's6',
          name: 'Physical Therapy',
          specialNeeds: ['Cerebral Palsy', 'Physical Disabilities'],
        ),
        CaregiverService(
          id: 's7',
          name: 'Pediatric Neuro',
          specialNeeds: [
            'Autism Spectrum Disorder (ASD)',
            'Sensory Processing Disorder',
          ],
        ),
      ],
      isVerified: false,
      isAvailable: true,
      languages: ['English', 'Hindi'],
      joinedDate: DateTime(2019, 3, 5),
      yearsOfExperience: 7,
      totalRecommendations: 1000000,
    ),
  ),
];
