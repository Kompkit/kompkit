#!/usr/bin/env node

console.log(`
🚀 KompKit Development Scripts

📦 BUILD COMMANDS:
  npm run build              - Build all platforms
  npm run build:web          - Build Web (TypeScript)
  npm run build:android      - Build Android (Kotlin)
  npm run build:flutter      - Build Flutter (Dart)

🧪 TEST COMMANDS:
  npm run test               - Run all tests
  npm run test:web           - Test Web platform
  npm run test:android       - Test Android platform
  npm run test:flutter       - Test Flutter platform
  npm run test:watch         - Watch mode for Web tests

🔍 LINT & FORMAT:
  npm run lint               - Lint all platforms
  npm run lint:web           - Lint Web code
  npm run lint:android       - Lint Android code (ktlint)
  npm run lint:flutter       - Lint Flutter code (dart analyze)
  npm run format             - Format all platforms
  npm run format:web         - Format Web code
  npm run format:android     - Format Android code (ktlint)
  npm run format:flutter     - Format Flutter code

🧹 CLEAN COMMANDS:
  npm run clean              - Clean all build artifacts
  npm run clean:web          - Clean Web build
  npm run clean:android      - Clean Android build
  npm run clean:flutter      - Clean Flutter build
  npm run clean:docs         - Clean generated docs
  npm run clean:all          - Clean everything

📚 DOCUMENTATION:
  npm run docs:all           - Generate all documentation
  npm run docs:web           - Generate Web docs
  npm run docs:android       - Generate Android docs
  npm run docs:flutter       - Generate Flutter docs
  npm run docs:clean         - Clean & regenerate docs

🌐 SERVE DOCUMENTATION:
  npm run serve:web          - Serve Web docs (port 3000)
  npm run serve:android      - Serve Android docs (port 3001)
  npm run serve:flutter      - Serve Flutter docs (port 3002)
  npm run serve:all          - Serve all docs simultaneously

🛠️ DEVELOPMENT:
  npm run dev:web            - Web development mode
  npm run dev:docs           - Generate & serve all docs

✅ QUALITY CHECKS:
  npm run check              - Run lint + test for all
  npm run check:web          - Check Web platform
  npm run check:android      - Check Android platform
  npm run check:flutter      - Check Flutter platform

🔧 MAINTENANCE:
  npm run install:all        - Install all dependencies
  npm run version:check      - Check tool versions
  npm run deps:update        - Update dependencies
  npm run release:prepare    - Prepare for release
  npm run ci                 - CI pipeline (install + check + build)

💡 EXAMPLES:
  npm run check              # Quick quality check
  npm run dev:docs           # Work on documentation
  npm run release:prepare    # Before releasing
  npm run serve:all          # View all docs at once
`);
