# KompKit Core — Android / Kotlin

Cross-platform utility functions for Android and JVM applications. Part of the [KompKit ecosystem](../../../README.md) with identical APIs across Web (TypeScript), Android (Kotlin), and Flutter (Dart).

> **⚠️ Alpha**: APIs may change before `1.0.0`. Pin to an exact version in production.

## Installation

Add to your `app/build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.kompkit:kompkit-core:0.4.1-alpha.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}
```

Make sure `mavenCentral()` is in your repository list (it is by default in new Android projects):

```kotlin
// settings.gradle.kts
dependencyResolutionManagement {
    repositories {
        mavenCentral()
        google()
    }
}
```

> Published on [central.sonatype.com](https://central.sonatype.com/artifact/com.kompkit/kompkit-core)

## Coroutines setup

`debounce` and `throttle` require a `CoroutineScope`. Use the lifecycle-aware scopes provided by Android:

| Context | Recommended scope |
|---|---|
| `ViewModel` | `viewModelScope` (auto-cancels on `onCleared`) |
| `@Composable` | `rememberCoroutineScope()` |
| `Fragment` / `Activity` | `lifecycleScope` |
| Plain JVM / tests | `CoroutineScope(Dispatchers.Default)` |

`isEmail`, `formatCurrency`, and `clamp` are pure functions — no coroutine dependency.

## Usage

Import all utilities:

```kotlin
import com.kompkit.core.*
```

Or import individually:

```kotlin
import com.kompkit.core.debounce
import com.kompkit.core.throttle
import com.kompkit.core.isEmail
import com.kompkit.core.formatCurrency
import com.kompkit.core.clamp
```

---

### `debounce`

Delays execution until calls stop for `waitMs` milliseconds. The last call within the wait period executes; all earlier ones are cancelled.

**Signature:**
```kotlin
fun <T> debounce(
    action: (T) -> Unit,
    waitMs: Long = 250L,
    scope: CoroutineScope,
): Debounced<T>
```

**Basic usage:**
```kotlin
val scope = CoroutineScope(Dispatchers.Main)

val onSearch = debounce<String>(
    action = { query -> println("Searching: $query") },
    waitMs = 300L,
    scope = scope,
)

onSearch("k")
onSearch("ko")
onSearch("kompkit") // only this executes, after 300ms of inactivity

onSearch.cancel()   // discard pending call (e.g. in onCleared / onDestroy)
```

**ViewModel example:**
```kotlin
class SearchViewModel : ViewModel() {

    val results = MutableLiveData<List<String>>()

    val onSearch = debounce<String>(
        action = { query -> search(query) },
        waitMs = 300L,
        scope = viewModelScope,
    )

    private fun search(query: String) {
        viewModelScope.launch {
            results.value = repository.search(query)
        }
    }

    // No need to call onSearch.cancel() — viewModelScope cancels automatically
}
```

**Jetpack Compose:**
```kotlin
@Composable
fun SearchBox() {
    var value by remember { mutableStateOf("") }
    val scope = rememberCoroutineScope()

    val onSearch = remember {
        debounce<String>(
            action = { query -> println("Search: $query") },
            waitMs = 300L,
            scope = scope,
        )
    }

    TextField(
        value = value,
        onValueChange = { newValue ->
            value = newValue
            onSearch(newValue)
        },
        placeholder = { Text("Search") }
    )
}
```

---

### `throttle`

Limits execution to at most once per `waitMs` milliseconds. The first call executes immediately; subsequent calls within the cooldown are ignored.

**Signature:**
```kotlin
fun <T> throttle(
    waitMs: Long,           // must be > 0
    scope: CoroutineScope,
    action: (T) -> Unit,
): Throttled<T>
```

> Note: `throttle` parameter order differs from `debounce` — `waitMs` is first, `action` is last (trailing lambda).

**Basic usage:**
```kotlin
val scope = CoroutineScope(Dispatchers.Main)

val onScroll = throttle<Int>(200L, scope) { position ->
    println("Scroll position: $position")
}

onScroll(0)         // executes immediately
onScroll(50)        // ignored — within 200ms cooldown
onScroll.cancel()   // reset state (e.g. in onDestroy)
```

**Jetpack Compose — scroll tracker:**
```kotlin
@Composable
fun ScrollTracker() {
    val listState = rememberLazyListState()
    val scope = rememberCoroutineScope()

    val onScroll = remember {
        throttle<Int>(200L, scope) { index ->
            println("First visible: $index")
        }
    }

    LaunchedEffect(listState.firstVisibleItemIndex) {
        onScroll(listState.firstVisibleItemIndex)
    }

    LazyColumn(state = listState) {
        items(100) { i -> Text("Item $i") }
    }
}
```

---

### `isEmail`

Validates an email address using a robust regex pattern.

```kotlin
isEmail("user@example.com")   // true
isEmail("invalid@")           // false
isEmail("  user@domain.org ") // true (trimmed before validation)
```

---

### `formatCurrency`

Formats a number as a localized currency string.

**Signature:**
```kotlin
fun formatCurrency(
    amount: Double,
    currency: String = "USD",
    locale: String = "en-US",
): String
```

```kotlin
formatCurrency(1234.56)                    // "$1,234.56"
formatCurrency(1234.56, "EUR", "es-ES")   // "1.234,56 €"
formatCurrency(1234.56, "JPY", "ja-JP")   // "¥1,235"
```

- Accepts BCP 47 locale strings (`"en-US"`, `"ja-JP"`) — no `java.util.Locale` needed
- Throws `IllegalArgumentException` on invalid currency codes

---

### `clamp`

Constrains a number within an inclusive `[min, max]` range.

```kotlin
clamp(5.0, 0.0, 10.0)   // 5.0
clamp(-3.0, 0.0, 10.0)  // 0.0
clamp(15.0, 0.0, 10.0)  // 10.0
```

Useful for bounding user-controlled values:

```kotlin
val opacity = clamp(userInput, 0.0, 1.0)
val page    = clamp(requestedPage, 1.0, totalPages.toDouble())
val volume  = clamp(rawVolume, 0.0, 100.0)
```

**Compose slider:**
```kotlin
@Composable
fun VolumeSlider() {
    var volume by remember { mutableStateOf(50f) }

    Slider(
        value = volume,
        onValueChange = { raw ->
            volume = clamp(raw.toDouble(), 0.0, 100.0).toFloat()
        },
        valueRange = 0f..100f
    )
}
```

---

## API Signatures

```kotlin
fun <T> debounce(action: (T) -> Unit, waitMs: Long = 250L, scope: CoroutineScope): Debounced<T>
fun <T> throttle(waitMs: Long, scope: CoroutineScope, action: (T) -> Unit): Throttled<T>
fun isEmail(value: String): Boolean
fun formatCurrency(amount: Double, currency: String = "USD", locale: String = "en-US"): String
fun clamp(value: Double, min: Double, max: Double): Double

class Debounced<T> { operator fun invoke(value: T); fun cancel() }
class Throttled<T> { operator fun invoke(value: T); fun cancel() }
```

## Platform notes

- Requires **JDK 17+** and **Kotlin 2.0+**
- Compatible with **Android API 21+** (minSdk 21)
- `debounce` and `throttle` require `kotlinx-coroutines-core` (included transitively)
- `formatCurrency` uses `java.text.NumberFormat` — locale fallback behavior follows JVM conventions
- All utilities are top-level functions in the `com.kompkit.core` package — no class instantiation needed

## Documentation

- **[Android Guide](../../../docs/android.md)** — Detailed usage with Jetpack Compose examples
- **[Main README](../../../README.md)** — Project overview and cross-platform APIs
- **[Architecture](../../../docs/ARCHITECTURE.md)** — API parity contract and platform differences
- **[Recipes](../../../docs/recipes.md)** — Real-world usage patterns across platforms

## Testing

```bash
cd packages/core/android
./gradlew test
```
