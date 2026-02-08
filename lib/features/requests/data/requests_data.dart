import 'package:cwsn/features/requests/models/request_model.dart';

final mockRequests = [
  CaregiverRequest(
    id: '1',
    parentId: '1',
    parentName: 'Nishant Sharma',
    parentImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    parentLocation: 'IIT Bombay',
    childName: 'Raghav',
    childAge: 12,
    childGender: 'Male',
    specialNeed: 'Blindness',
    serviceName: 'Shadow Teacher',
  ),

  CaregiverRequest(
    id: '2',
    parentId: '2',
    parentName: 'Anjali Verma',
    parentImageUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    parentLocation: 'Powai',
    childName: 'Aarav',
    childAge: 10,
    childGender: 'Male',
    specialNeed: 'Autism',
    serviceName: 'Therapy Sessions',
  ),

  CaregiverRequest(
    id: '3',
    parentId: '3',
    parentName: 'Rohit Singh',
    parentImageUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    parentLocation: 'Andheri',
    childName: 'Diya',
    childAge: 8,
    childGender: 'Female',
    specialNeed: 'Cerebral Palsy',
    serviceName: 'Physical Therapy',
  ),
];
