# CI/CD Documentation

## Overview

KompKit uses GitHub Actions for continuous integration with separate workflows optimized for our monorepo structure. Each workflow targets specific platforms to minimize build times and resource usage.

## Current Workflows Status

| Workflow       | Status    | Platform           | Triggers             | Path Filters               |
| -------------- | --------- | ------------------ | -------------------- | -------------------------- |
| **Web CI**     | ✅ Active | TypeScript/Node.js | `develop`, `release` | `packages/core/web/**`     |
| **Kotlin CI**  | ✅ Active | Kotlin JVM         | `develop`, `release` | `packages/core/android/**` |
| **Flutter CI** | ✅ Active | Dart/Flutter       | `develop`, `release` | `packages/core/flutter/**` |

## Workflow Details

### 1. Web CI (`web.yml`)

**Purpose:** Build, test, and validate TypeScript/JavaScript packages

**Triggers:**

- Push/PR to `release` or `develop` branches
- Changes in `packages/core/web/**`
- Changes in `.github/workflows/web.yml`
- Manual dispatch (`workflow_dispatch`)

**Jobs:**

- **web**: Type check (`tsc --noEmit`), build, test, and generate documentation
  - Node.js 20.x with npm caching
  - Lerna-based monorepo management
  - TypeDoc documentation generation
  - Artifact uploads (build outputs, docs)

**Path Filters:** Optimized to run only when web-related files change

### 2. Kotlin CI (`android.yml`)

**Purpose:** Build, test, and validate Kotlin JVM packages

**Triggers:**

- Push/PR to `release` or `develop` branches
- Changes in `packages/core/android/**`
- Changes in `.github/workflows/android.yml`
- Manual dispatch (`workflow_dispatch`)

**Jobs:**

- **kotlin**: Lint, static analysis, build, test, and generate documentation
  - JDK 17 (Temurin distribution)
  - Gradle build with caching
  - ktlint code formatting validation
  - detekt static analysis
  - Dokka documentation generation
  - JAR artifact uploads

**Path Filters:** Optimized to run only when Kotlin-related files change

### 3. Flutter CI (`flutter.yml`)

**Purpose:** Build, test, and validate Dart/Flutter packages

**Triggers:**

- Push/PR to `release` or `develop` branches
- Changes in `packages/core/flutter/**`
- Changes in `.github/workflows/flutter.yml`
- Manual dispatch (`workflow_dispatch`)

**Jobs:**

- **flutter**: Analyze, test, and generate documentation
  - Flutter 3.27.4 (stable channel)
  - `flutter analyze` for static analysis
  - `flutter test --coverage` with coverage reporting
  - Codecov integration for coverage uploads
  - DartDoc documentation generation
  - Artifact uploads (docs)

**Path Filters:** Optimized to run only when Flutter-related files change

## Technology Stack

### Pinned Action Versions

| Action                        | Version | Purpose             | Used In       |
| ----------------------------- | ------- | ------------------- | ------------- |
| `actions/checkout`            | v4      | Repository checkout | All workflows |
| `actions/setup-node`          | v4      | Node.js 20.x setup  | Web CI        |
| `actions/setup-java`          | v4      | JDK 17 setup        | Kotlin CI     |
| `gradle/actions/setup-gradle` | v4      | Gradle with caching | Kotlin CI     |
| `subosito/flutter-action`     | v2      | Flutter setup       | Flutter CI    |
| `codecov/codecov-action`      | v5      | Coverage upload     | Flutter CI    |
| `actions/upload-artifact`     | v4      | Artifact storage    | All workflows |

### Build Requirements

| Platform    | Requirements | Version      |
| ----------- | ------------ | ------------ |
| **Web**     | Node.js      | 20.x         |
| **Web**     | npm          | Latest       |
| **Web**     | TypeScript   | 5.7+         |
| **Kotlin**  | JDK          | 17 (Temurin) |
| **Kotlin**  | Kotlin       | 2.3.0        |
| **Kotlin**  | Gradle       | 8.5          |
| **Flutter** | Flutter      | 3.27.4       |
| **Flutter** | Dart         | 3.0+         |

## Security & Permissions

**Minimal Permissions:**

- `contents: read` - Repository access
- `pull-requests: read` - PR information access

**No Secrets Required:** All builds use public dependencies and tools.

## Local Development

### Web Development

```bash
# Install dependencies
npm ci

# Build packages (using Lerna)
npm run build

# Run tests
npm run test:web

# Generate docs
npm run docs:web
```

### Kotlin Development

```bash
# Navigate to Kotlin module
cd packages/core/android

# Make gradlew executable (if needed)
chmod +x gradlew

# Clean build
./gradlew clean

# Lint with ktlint
./gradlew ktlintCheck

# Static analysis with detekt
./gradlew detekt

# Build JAR
./gradlew assemble

# Run unit tests
./gradlew test

# Generate documentation
./gradlew dokkaHtml
```

## Caching Strategy

- **Node.js**: Native npm cache via `actions/setup-node`
- **Gradle**: Build cache via `gradle/actions/setup-gradle`
- **No manual caching**: Avoids cache conflicts and complexity

## Artifacts

### Web Artifacts

- `web-docs-{run_id}`: Generated TypeDoc documentation (30 days)
- `web-build-{run_id}`: Built packages from dist/ directories (7 days)

### Kotlin Artifacts

- `android-test-reports-{run_id}`: JUnit test reports (7 days)
- `android-lint-reports-{run_id}`: ktlint and detekt reports (7 days)
- `kotlin-jar-{run_id}`: Built JAR files (7 days)
- `kotlin-docs-{run_id}`: Dokka-generated documentation (30 days)

### Flutter Artifacts

- `flutter-docs-{run_id}`: DartDoc-generated documentation (30 days)

## Skip Flags

Use commit message flags to skip specific builds:

- `[skip web]`: Skip web CI workflow
- `[skip android]`: Skip Kotlin CI workflow
- `[skip flutter]`: Skip Flutter CI workflow

## Troubleshooting

### Common Issues

**1. Gradle Permission Denied**

```bash
chmod +x packages/core/android/gradlew
git add packages/core/android/gradlew
git commit -m "fix: make gradlew executable"
```

**2. Node.js Build Failures**

- Check Node.js version compatibility (using 20.x)
- Verify `package-lock.json` is committed
- Clear npm cache: `npm ci --cache .npm --prefer-offline`

**3. Kotlin Build Failures**

- Verify JDK 17 compatibility
- Check Kotlin version compatibility (2.3.0)
- Review ktlint/detekt reports for code quality issues
- Ensure Gradle wrapper is executable

**4. Path Filters Not Working**

- Ensure file changes match the path patterns in workflow triggers
- Check that both `push` and `pull_request` events have same path filters

### Debug Commands

**Check workflow status:**

```bash
# View recent workflow runs
gh run list --limit 10

# View specific run details
gh run view <run-id>

# Download artifacts
gh run download <run-id>
```

**Local debugging:**

```bash
# Simulate CI environment
export CI=true
export GITHUB_ACTIONS=true

# Run builds with same flags as CI
npm ci
npm run build --workspaces --if-present || npm run build
npm test --workspaces --if-present || npm test || echo "No tests found"
```

## Performance Targets

- **Web builds**: < 5 minutes for typical changes
- **Kotlin builds**: < 8 minutes for typical changes
- **First-time builds**: May take longer due to dependency downloads
- **Concurrent builds**: Path filters prevent unnecessary parallel execution

## Branch Strategy

- **develop**: Active development branch, all PRs target here
- **release**: Stable release branch, merges from develop
- **Dependabot**: Targets develop branch for dependency updates

## Monitoring

Monitor CI health via:

- GitHub Actions dashboard
- README badges showing build status
- Artifact retention and storage usage
- Build time trends and performance metrics
