/// Master list of all special needs categories.
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

/// Maps each service name (must match titles in services_data.dart) to the
/// special needs it can address.
final Map<String, List<String>> mockSpecialNeedsByService = {
  // ── Educational Support ──
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
    'Intellectual Disabilities',
  ],
  'Speech Tutor': [
    'Autism Spectrum Disorder (ASD)',
    'Speech and Language Disorders',
    'Down Syndrome',
    'Cerebral Palsy',
  ],
  'Math Coach': [
    'Learning Disabilities',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Down Syndrome',
    'Intellectual Disabilities',
  ],

  // ── Therapy Services ──
  'Occupational': [
    'Cerebral Palsy',
    'Sensory Processing Disorder',
    'Down Syndrome',
    'Physical Disabilities',
    'Learning Disabilities',
  ],
  'Behavioral (ABA)': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Emotional and Behavioral Disorders',
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
    'Cerebral Palsy',
  ],
  'Art Therapy': [
    'Autism Spectrum Disorder (ASD)',
    'Emotional and Behavioral Disorders',
    'Sensory Processing Disorder',
    'Intellectual Disabilities',
  ],

  // ── Recreational & Sports ──
  'Adaptive Swimming': [
    'Cerebral Palsy',
    'Physical Disabilities',
    'Down Syndrome',
    'Autism Spectrum Disorder (ASD)',
  ],
  'Wheelchair Basketball': [
    'Physical Disabilities',
    'Cerebral Palsy',
  ],
  'Sensory Gym': [
    'Sensory Processing Disorder',
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
  ],
  'Soccer Club': [
    'Down Syndrome',
    'Intellectual Disabilities',
    'Emotional and Behavioral Disorders',
    'Physical Disabilities',
  ],
  'Yoga Classes': [
    'Cerebral Palsy',
    'Sensory Processing Disorder',
    'Emotional and Behavioral Disorders',
    'Physical Disabilities',
  ],

  // ── Medical & Health ──
  'Pediatric Neuro': [
    'Autism Spectrum Disorder (ASD)',
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Cerebral Palsy',
    'Down Syndrome',
    'Sensory Processing Disorder',
  ],
  'Dietician': [
    'Down Syndrome',
    'Cerebral Palsy',
    'Physical Disabilities',
  ],
  'Psychologist': [
    'Attention Deficit Hyperactivity Disorder (ADHD)',
    'Emotional and Behavioral Disorders',
    'Learning Disabilities',
    'Autism Spectrum Disorder (ASD)',
  ],
  'Dental Care': [
    'Down Syndrome',
    'Cerebral Palsy',
    'Intellectual Disabilities',
  ],
};
