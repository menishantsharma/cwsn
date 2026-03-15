/// Mock data representing special needs categories.
///
/// [mockSpecialNeeds] is the flat master list (used by the browsing page).
/// [mockSpecialNeedsByService] maps each service to the subset of special
/// needs it can address (used by the Add Service sheet).
final List<String> mockSpecialNeeds = [
  'Autism Spectrum Disorder (ASD)',
  'Attention Deficit Hyperactivity Disorder (ADHD)',
  'Cerebral Palsy',
  'Down Syndrome',
  'Learning Disabilities',
  'Speech and Language Disorders',
  'Sensory Processing Disorder',
  'Intellectual Disabilities',
  'Emotional and Behavioral Disorders',
  'Physical Disabilities',
];

/// Service name → applicable special needs.
/// When a real backend is available, replace with an API call keyed by service ID.
final Map<String, List<String>> mockSpecialNeedsByService = {
  'Shadow Teacher': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Learning Disabilities',
    'Down Syndrome',
    'Intellectual Disabilities',
  ],
  'IEP Specialist': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Learning Disabilities',
    'Intellectual Disabilities',
    'Emotional and Behavioral Disorders',
  ],
  'Early Intervention': [
    'Autism Spectrum Disorder (ASD)',
    'Down Syndrome',
    'Cerebral Palsy',
    'Speech and Language Disorders',
    'Sensory Processing Disorder',
  ],
  'Speech Tutor': [
    'Autism Spectrum Disorder (ASD)',
    'Speech and Language Disorders',
    'Down Syndrome',
    'Cerebral Palsy',
  ],
  'Math Coach': [
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Learning Disabilities',
    'Down Syndrome',
  ],
  'Occupational': [
    'Autism Spectrum Disorder (ASD)',
    'Cerebral Palsy',
    'Sensory Processing Disorder',
    'Down Syndrome',
    'Physical Disabilities',
  ],
  'Behavioral (ABA)': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Emotional and Behavioral Disorders',
    'Intellectual Disabilities',
  ],
  'Physical Therapy': [
    'Cerebral Palsy',
    'Physical Disabilities',
    'Down Syndrome',
  ],
  'Music Therapy': [
    'Autism Spectrum Disorder (ASD)',
    'Emotional and Behavioral Disorders',
    'Sensory Processing Disorder',
    'Intellectual Disabilities',
  ],
  'Art Therapy': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Emotional and Behavioral Disorders',
    'Sensory Processing Disorder',
  ],
  'Adaptive Swimming': [
    'Cerebral Palsy',
    'Physical Disabilities',
    'Down Syndrome',
    'Autism Spectrum Disorder (ASD)',
  ],
  'Wheelchair Basketball': ['Physical Disabilities', 'Cerebral Palsy'],
  'Sensory Gym': [
    'Autism Spectrum Disorder (ASD)',
    'Sensory Processing Disorder',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
  ],
  'Soccer Club': [
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Down Syndrome',
    'Physical Disabilities',
  ],
  'Yoga Classes': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Cerebral Palsy',
    'Sensory Processing Disorder',
    'Emotional and Behavioral Disorders',
  ],
  'Pediatric Neuro': [
    'Autism Spectrum Disorder (ASD)',
    'Cerebral Palsy',
    'Down Syndrome',
    'Intellectual Disabilities',
  ],
  'Dietician': ['Down Syndrome', 'Cerebral Palsy', 'Physical Disabilities'],
  'Psychologist': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Emotional and Behavioral Disorders',
    'Learning Disabilities',
    'Intellectual Disabilities',
  ],
  'Dental Care': [
    'Down Syndrome',
    'Cerebral Palsy',
    'Intellectual Disabilities',
    'Physical Disabilities',
  ],
};
