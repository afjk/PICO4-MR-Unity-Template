# PICO4-MR-Unity-Template

A Unity template for developing Mixed Reality (MR) applications on PICO4 and PICO4 Ultra devices.

## Overview

This repository provides a ready-to-use Unity project template specifically designed for Mixed Reality application development on PICO4 and PICO4 Ultra devices. The template includes pre-configured settings, essential packages, and a GitHub Actions workflow for automated builds.

### Key Features

- **Unity 6000.0.48f1** - Latest LTS Unity version
- **PICO Unity OpenXR SDK** - Official PICO development SDK
- **XR Interaction Toolkit** - Unity's XR interaction framework
- **AR Foundation** - Cross-platform AR development
- **Universal Render Pipeline (URP)** - Optimized rendering for mobile VR/AR
- **Input System** - Modern input handling
- **GitHub Actions** - Automated Android build pipeline

## Setup Instructions

For detailed setup instructions and development guide, please refer to the comprehensive tutorial on Qiita:

📖 **[PICO4/4Ultra MR App Development Setup Guide](https://qiita.com/afjk/items/3549e9eeb6ed8e301f24)**

### Quick Start

1. **Clone or download** this repository
2. **Open in Unity 6000.0.48f1** or later
3. **Follow the Qiita tutorial** for detailed PICO development environment setup
4. **Build and deploy** to your PICO4/4Ultra device

## GitHub Actions for Automated Builds

This template includes a GitHub Actions workflow for automated Android builds. The workflow automatically triggers on pushes to the main branch and can also be manually executed.

### Setting Up Automated Builds

If you want to use the automated build feature:

1. **Fork this repository** to your GitHub account
2. **Set up the following Secrets** in your repository settings:
   - `UNITY_LICENSE` - Your Unity license file content (see below)
   - `UNITY_EMAIL` - Your Unity account email
   - `UNITY_PASSWORD` - Your Unity account password

### Unity License File (.ulf) Requirement

To run Unity on GitHub Actions, you need a Unity license file (.ulf), even for Personal licenses.

#### Finding Your Unity License File

The Unity license file can be found at the following locations:

- **Windows:** `C:\ProgramData\Unity\Unity_lic.ulf`
- **Mac:** `/Library/Application Support/Unity/Unity_lic.ulf`
- **Linux:** `~/.local/share/unity3d/Unity/Unity_lic.ulf`

#### Setting Up the License Secret

1. Copy the content of your Unity license file
2. In your forked repository, go to **Settings > Secrets and variables > Actions**
3. Create a new secret named `UNITY_LICENSE`
4. Paste the license file content as the secret value

For detailed instructions on Unity license activation for CI/CD, refer to the official GameCI documentation:
🔗 **[GameCI Unity Activation Guide](https://game.ci/docs/github/activation/)**

## Project Structure

```
Assets/
├── Scenes/
│   └── SampleScene.unity          # Main scene with basic MR setup
├── Settings/                      # XR and project settings
├── XR/                           # XR-related assets and configurations
├── XRI/                          # XR Interaction Toolkit assets
└── Resources/                    # Runtime resources

Packages/
└── manifest.json                 # Package dependencies including PICO SDK

.github/
└── workflows/
    └── android-debug-build.yml   # GitHub Actions build workflow
```

## Package Dependencies

This template includes the following key packages:

- **PICO Unity OpenXR SDK** (v1.4.0) - Official PICO development framework
- **XR Interaction Toolkit** (v3.2.0) - Unity's XR interaction system
- **AR Foundation** (v6.2.0) - Cross-platform AR development framework
- **XR Hands** (v1.6.0) - Hand tracking support
- **OpenXR** (v1.14.3) - Open standard for XR applications
- **Universal Render Pipeline** (v17.0.4) - Optimized rendering pipeline
- **Input System** (v1.14.0) - Modern input handling system

## Usage

1. **Development Environment**: Follow the [Qiita setup guide](https://qiita.com/afjk/items/3549e9eeb6ed8e301f24) to configure your development environment
2. **Scene Setup**: Start with the included `SampleScene.unity` which contains basic MR components
3. **Build Settings**: The project is pre-configured for Android builds targeting PICO devices
4. **Testing**: Deploy to your PICO4/4Ultra device for testing

## Requirements

- **Unity 6000.0.48f1** or later
- **PICO4 or PICO4 Ultra** device
- **Android SDK** for building
- **PICO Developer Account** for device development setup

## Contributing

Feel free to submit issues and enhancement requests. This template is designed to be a starting point for PICO4 MR development.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- 📖 [Setup Guide (Qiita)](https://qiita.com/afjk/items/3549e9eeb6ed8e301f24)
- 🔗 [PICO Developer Documentation](https://developer.picoxr.com/)
- 🔗 [Unity XR Interaction Toolkit](https://docs.unity3d.com/Packages/com.unity.xr.interaction.toolkit@3.2/manual/index.html)
- 🔗 [GameCI Documentation](https://game.ci/docs/)

---

**Happy MR Development! 🥽✨**