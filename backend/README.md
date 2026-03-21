# CWSN App

A platform connecting parents with caregivers, offering secure communication, service matching, and community-driven feedback. The app includes both a mobile frontend built with Flutter and a backend API powered by Django.

This monorepo houses both the frontend and backend in a single repository, following a modular approach to simplify development and maintainability.

## Project Structure

```bash
/cswn
├── /artifacts                    # Build artifacts or generated files
├── /docs                         # Documentation (HLD, user guides, etc.)
├── /scripts                      # Setup and utility scripts
├── /src
│   ├── /client                   # Flutter (Frontend)
│   │   ├── /cwsn_app             # Main Flutter app
│   │   └── ...
│   └── /server                   # Django (Backend)
│       ├── /apps                 # Django app directory
│       ├── /cwsn_backend
│       └── ...
├── /docker                       # Docker setup for both backend and frontend
├── /env                          # Virtual environments
└── README.md                     # This file
```

## Setting Up the Project

### Prerequisites

* Flutter: Ensure you have Flutter installed. For installation instructions, visit the official Flutter website.
* Python: Ensure Python 3.x is installed for running the Django backend.
* Docker: Optional, but highly recommended for a unified development environment.

### Environment Setup

Clone the Repository:

```bash
git clone https://github.com/sudo-boo/cswn.git
cd cswn
```

#### 1. Frontend Setup (Flutter)

* Install Flutter dependencies:

    ```bash
    cd src/client
    flutter pub get
    ```

* Run the Flutter app for Android/iOS:

    ```bash
    flutter run
    ```

    Alternatively, you can build for web, desktop, or other platforms using:

    ```bash
    flutter run -d web    # For web
    flutter run -d linux  # For Linux
    ```

The Flutter frontend will be available on your emulator or connected device.

#### 2. Backend Setup (Django)

> To be added

#### 3. Docker Setup (Optional)

> To be added

## Documentation

Follow the given document for high level implementation details, queries and overall design decisions of the project: [CWSN Documentation](https://docs.google.com/document/d/16W5wM7BtTdV1CvX3uoUac_RMXl70NYctZVG_MaH2bhQ/edit?usp=sharing)

The `./docs` directory houses the low level implementation details of both the frontend and backend aspects of the project.

> If you're a developer on this app, make sure to update this regularly since this will be a single source of truth for implementation details.
>
> If you're a contributor, also create a PR for updating the documentation (if applies) after your changes are accepted.

## Contributing

If you'd like to help improve the CSWN app, please follow these steps:

1. Fork the repository
2. Create a new branch (git checkout -b feature-name)
3. Make your changes and commit them (git commit -m "Add feature")
4. Push your branch to your fork (git push origin feature-name)
5. Open a pull request
