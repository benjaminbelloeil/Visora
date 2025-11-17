# Visora

Visora is an iOS travel app that uses AI to recognize and analyze monuments, landmarks, and hidden locations from user photos. It helps travelers capture, organize, and learn the stories behind every place they visit, featuring interactive maps, a calendar of memories, and easy bookmarking for favorite destinations.

## Features

- **AI-powered photo analysis:** Automatically recognizes famous and lesser-known locations from your photos.
- **Interactive calendar & map:** Visualize your travel history and revisit memories.
- **Bookmarking & favorites:** Save and organize your favorite places for quick access.
- **Profile management:** Edit personal details and view travel stats.
- **Seamless onboarding & loading screens:** Smooth transitions for a polished user experience.

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 17 SDK
- Swift 5.9+
- Apple Developer account (for iCloud and App Store deployment)
- [Gemini API key](https://aistudio.google.com/) (for AI analysis features)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/benjaminbelloeil/Visora.git
   cd visora
   ```

2. **Open the project in Xcode:**
   ```
   open Visora.xcodeproj
   ```

3. **Configure API keys:**
   - Add your OpenAI API key to the app’s configuration file or environment variables as needed.

4. **Set up iCloud (optional):**
   - Enable iCloud capabilities in your Xcode project for bookmark syncing.

5. **Build and run:**
   - Select a simulator or device and hit `Run`.

## Project Structure

```
Visora/
├── Models/                # Data models (UserProfile, Destination, etc.)
├── ViewModels/            # State management and business logic
├── Views/                 # SwiftUI views (Home, Calendar, Map, Profile, etc.)
├── Components/            # Reusable UI components (cards, headers, etc.)
├── Helpers/               # Utility classes (BookmarkManager, etc.)
├── Assets.xcassets/       # Images and app icons
├── VisoraApp.swift        # App entry point
```

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

- Follow Swift and iOS best practices.
- Keep UI consistent with Apple’s Human Interface Guidelines.
- Write clear, maintainable code and add comments where necessary.

## Next Steps

- Implement subscription model for AI features after a set number of uses.
- Add more features based on user feedback.
- Prepare for App Store release.

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contact

For questions or feedback, please open an issue or contact [your.email@example.com](mailto:your.email@example.com).
