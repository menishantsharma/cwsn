import datetime
import random
from django.core.management.base import BaseCommand
from django.db import transaction
from django.contrib.auth.models import Group, Permission
from django.contrib.contenttypes.models import ContentType
from django.utils import timezone

# Import Faker
from faker import Faker

# Import all your models
from apps.users.models import User, CWSNProfile, ChildProfile, CaregiverProfile, ModeratorProfile
from apps.common.models import Region, ServiceCategory, Disability, Language
from apps.services.models import Service, AvailabilitySlot
from apps.interactions.models import Report, ServiceRequest, Upvote # Corrected import order

# A simple password for all test users
TEST_PASSWORD = 'password123'

class Command(BaseCommand):
    help = 'Seeds the database with a much larger set of dummy data'

    @transaction.atomic
    def handle(self, *args, **options):
        self.stdout.write(self.style.WARNING('Deleting old data...'))
        
        # Nuke all data
        User.objects.all().delete()
        Region.objects.all().delete()
        ServiceCategory.objects.all().delete()
        Disability.objects.all().delete()
        Language.objects.all().delete()
        Group.objects.all().delete()

        self.stdout.write(self.style.SUCCESS('Old data deleted.'))

        # Initialize Faker
        fake = Faker('en_IN') # Use Indian names/data

        # === 1. Create Admin User ===
        self.stdout.write('Creating Admin user...')
        admin_email = 'admin@app.com'
        admin_user = User.objects.create_superuser(
            email=admin_email,
            username='admin',
            password=TEST_PASSWORD
        )
        self.stdout.write(f'  -> Created Admin: {admin_email}')

        # === 2. Create Common Data ===
        self.stdout.write('Creating common data (Regions, Categories, etc.)...')
        
        # Regions
        r_india = Region.objects.create(name='India', parent=None)
        
        r_mah = Region.objects.create(name='Maharashtra', parent=r_india)
        r_mum = Region.objects.create(name='Mumbai', parent=r_mah)
        r_pune = Region.objects.create(name='Pune', parent=r_mah)
        
        r_del = Region.objects.create(name='Delhi NCR', parent=r_india)
        r_del_city = Region.objects.create(name='Delhi', parent=r_del)
        r_gurgaon = Region.objects.create(name='Gurgaon', parent=r_del)

        r_kar = Region.objects.create(name='Karnataka', parent=r_india)
        r_blr = Region.objects.create(name='Bengaluru', parent=r_kar)
        r_mys = Region.objects.create(name='Mysuru', parent=r_kar)
        
        r_guj = Region.objects.create(name='Gujarat', parent=r_india)
        r_ahd = Region.objects.create(name='Ahmedabad', parent=r_guj)
        r_sur = Region.objects.create(name='Surat', parent=r_guj)
        
        r_tn = Region.objects.create(name='Tamil Nadu', parent=r_india)
        r_che = Region.objects.create(name='Chennai', parent=r_tn)
        r_coi = Region.objects.create(name='Coimbatore', parent=r_tn)
        
        city_regions = [r_mum, r_pune, r_del_city, r_gurgaon, r_blr, r_mys, r_ahd, r_sur, r_che, r_coi]

        # Service Categories
        cat_travel = ServiceCategory.objects.create(name='Travel')
        cat_therapy = ServiceCategory.objects.create(name='Therapy')
        cat_edu = ServiceCategory.objects.create(name='Educational')
        cat_rec = ServiceCategory.objects.create(name='Recreational')
        cat_fin = ServiceCategory.objects.create(name='Financial')
        cat_med = ServiceCategory.objects.create(name='Medical Assistance')
        cat_legal = ServiceCategory.objects.create(name='Legal Aid')
        cat_tech = ServiceCategory.objects.create(name='Assistive Tech')
        
        all_categories = list(ServiceCategory.objects.all())

        # Disabilities
        dis_autism = Disability.objects.create(name='Autism Spectrum')
        dis_visual = Disability.objects.create(name='Visual Impairment')
        dis_hearing = Disability.objects.create(name='Hearing Impairment')
        dis_down = Disability.objects.create(name='Down Syndrome')
        dis_adhd = Disability.objects.create(name='ADHD')
        dis_phys = Disability.objects.create(name='Physical Disability')
        dis_cp = Disability.objects.create(name='Cerebral Palsy')
        dis_learn = Disability.objects.create(name='Learning Disability')
        
        all_disabilities = list(Disability.objects.all())

        # Languages
        lang_en = Language.objects.create(name='English')
        lang_hi = Language.objects.create(name='Hindi')
        lang_ma = Language.objects.create(name='Marathi')
        lang_kn = Language.objects.create(name='Kannada')
        lang_ta = Language.objects.create(name='Tamil')
        lang_gu = Language.objects.create(name='Gujarati')
        lang_te = Language.objects.create(name='Telugu')
        
        all_languages = list(Language.objects.all())

        # === 3. Create Moderator Group & Permissions ===
        self.stdout.write('Creating Moderator group and permissions...')
        moderator_group, _ = Group.objects.get_or_create(name='Moderators')
        
        models_to_manage = [CWSNProfile, CaregiverProfile, Report, Service, User]
        permissions = []
        for model in models_to_manage:
            content_type = ContentType.objects.get_for_model(model)
            permissions.extend(Permission.objects.filter(content_type=content_type))
        
        moderator_group.permissions.set(permissions)

        # === 4. Create Moderators (8) ===
        self.stdout.write('Creating 8 Moderators...')
        moderator_users = []
        mod_regions = [r_mum, r_pune, r_del_city, r_blr, r_ahd, r_che, r_gurgaon, r_mys]
        for region in mod_regions:
            email = f'moderator.{region.name.lower()}@app.com'
            username = f'mod_{region.name.lower()}'
            mod_user = User.objects.create_user(
                email=email,
                username=username,
                password=TEST_PASSWORD,
                is_moderator=True,
                is_staff=True
            )
            mod_user.groups.add(moderator_group)
            mod_profile = ModeratorProfile.objects.create(user=mod_user)
            mod_profile.regions.add(region)
            moderator_users.append(mod_user)
            self.stdout.write(f'  -> Created Moderator: {email}') # <-- ADDED

        # === 5. Create Caregivers (20) ===
        self.stdout.write('Creating 20 Caregivers...')
        caregiver_users = []
        qualifications_list = [
            'Certified ABA Therapist', 'Special Educator (M.Ed)', 
            'Physical Therapist', 'Occupational Therapist', 'Speech Therapist',
            'Financial Planner (Disability Focus)', 'Legal Counsel', 'Sign Language Interpreter'
        ]
        
        for i in range(20):
            profile = fake.profile()
            name = profile['name']
            email = f'caregiver.{name.split()[0].lower()}{i}@app.com'
            username = f'caregiver{i}'
            region = random.choice(city_regions)

            user = User.objects.create_user(
                email=email,
                username=username,
                password=TEST_PASSWORD,
                is_caregiver=True
            )
            cg_profile = CaregiverProfile.objects.create(
                user=user,
                name=name,
                contact_no=fake.phone_number(),
                age=random.randint(25, 55),
                gender=random.choice(['Male', 'Female', 'Other']),
                region=region,
                qualifications=random.choice(qualifications_list),
                upvote_count=random.randint(0, 5),
                is_verified=random.choices([True, False], weights=[0.8, 0.2])[0],
                availability_status=random.choice(['Available', 'Busy']),
                verification_notes=fake.sentence() if random.random() > 0.5 else ""
            )
            # Add 2-3 languages
            cg_profile.languages.add(lang_en, *random.sample(all_languages, 2))
            caregiver_users.append(user)
            self.stdout.write(f'  -> Created Caregiver: {email}') # <-- ADDED

        # === 6. Create CWSN Users (40) ===
        self.stdout.write('Creating 40 CWSN Users and their Children...')
        cwsn_users = []
        for i in range(40):
            profile = fake.profile()
            name = profile['name']
            email = f'parent.{name.split()[0].lower()}{i}@app.com'
            username = f'parent{i}'
            region = random.choice(city_regions) # Assign parent a region
            
            user = User.objects.create_user(
                email=email,
                username=username,
                password=TEST_PASSWORD,
                is_cwsn_user=True
            )
            CWSNProfile.objects.create(
                user=user,
                name=name,
                age=random.randint(30, 50),
                gender=profile.get('sex', 'Female'),
                region=region
            )
            cwsn_users.append(user)
            self.stdout.write(f'  -> Created CWSN User: {email}') # <-- ADDED

            # Create 1 to 3 children for each parent
            for _ in range(random.randint(1, 3)):
                child_name = fake.first_name()
                child = ChildProfile.objects.create(
                    parent=user,
                    name=child_name,
                    age=random.randint(4, 16),
                    gender=random.choice(['Male', 'Female'])
                )
                # Assign 1 or 2 disabilities to each child
                child.disabilities.add(*random.sample(all_disabilities, random.randint(1, 2)))

        # === 7. Create Dummy Services (60-80) ===
        self.stdout.write('Creating dummy services for each caregiver...')
        all_services = []
        for caregiver in caregiver_users:
            # 2-5 services per caregiver
            for _ in range(random.randint(2, 5)):
                cat = random.choice(all_categories)
                service = Service.objects.create(
                    caregiver=caregiver,
                    category=cat,
                    region=caregiver.caregiver_profile.region, # Service is in caregiver's region
                    title=f'{cat.name} Session in {caregiver.caregiver_profile.region.name}',
                    description=fake.text(max_nb_chars=200),
                    service_type=random.choice(['Online', 'Offline', 'Hybrid']),
                    payment_type=random.choice(['Paid', 'Unpaid']),
                    target_age_min=random.randint(5, 12),
                    target_age_max=random.randint(13, 18),
                    target_gender=random.choice(['Male', 'Female', 'Any']),
                    is_active=random.choices([True, False], weights=[0.9, 0.1])[0] # 90% are active
                )
                service.target_disabilities.add(random.choice(all_disabilities))
                all_services.append(service)
        self.stdout.write(f'  -> Created {len(all_services)} services.') # <-- ADDED

        # === 8. Create Dummy Interactions ===
        self.stdout.write('Creating dummy interactions (Requests, Reports, Upvotes)...')
        
        # Create 50 Service Requests
        requests_created = 0
        for _ in range(50):
            parent = random.choice(cwsn_users)
            # Find services in the same region as the parent
            region_services = [s for s in all_services if s.region == parent.cwsn_profile.region]
            if not region_services:
                continue # Skip if no services in this parent's region
                
            service = random.choice(region_services)
            child = random.choice(list(parent.children.all()))
            
            # Avoid creating duplicate requests
            if not ServiceRequest.objects.filter(cwsn_user=parent, child=child, service=service).exists():
                ServiceRequest.objects.create(
                    cwsn_user=parent,
                    caregiver=service.caregiver,
                    child=child,
                    service=service,
                    status=random.choice(['Pending', 'Accepted', 'Rejected'])
                )
                requests_created += 1
        self.stdout.write(f'  -> Created {requests_created} service requests.') # <-- ADDED
        
        # Create 10 Reports
        for _ in range(10):
            reporter = random.choice(cwsn_users)
            reported_user = random.choice(caregiver_users)
            
            Report.objects.create(
                reporter=reporter,
                reported_user=reported_user,
                reason=fake.sentence(nb_words=10),
                moderator_action="Initial review pending."
            )
        self.stdout.write('  -> Created 10 reports.') # <-- ADDED

        # Create 75 Upvotes
        upvotes_created = 0
        for _ in range(75):
            voter = random.choice(cwsn_users)
            caregiver = random.choice(caregiver_users)
            
            # Avoid duplicate upvotes
            if not Upvote.objects.filter(voter=voter, caregiver=caregiver).exists():
                Upvote.objects.create(
                    voter=voter,
                    caregiver=caregiver
                )
                upvotes_created += 1
        self.stdout.write(f'  -> Created {upvotes_created} upvotes.') # <-- ADDED

        self.stdout.write(self.style.SUCCESS('Successfully seeded the database with expanded data!'))