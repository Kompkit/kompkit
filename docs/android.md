# Android guide

KompKit Core provides small utilities for Android applications written in Kotlin.

Status: `v0.4.0-alpha.0`.

## Installation

> **Note**: The Android/Kotlin package is not yet published to Maven. Use a local project reference for now.

Add the project reference to your `settings.gradle.kts`:

```kotlin
include(":kompkit-core")
project(":kompkit-core").projectDir = file("path/to/KompKit/packages/core/android")
```

Then add the dependency to your module `build.gradle.kts`:

```kotlin
dependencies {
    implementation(project(":kompkit-core"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
}
```

## Imports

```kotlin
import com.kompkit.core.debounce
import com.kompkit.core.isEmail
import com.kompkit.core.formatCurrency
import com.kompkit.core.clamp
import com.kompkit.core.throttle
```

## Usage examples

### debounce

```kotlin
import com.kompkit.core.debounce
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

val scope = CoroutineScope(Dispatchers.Main)
val onType = debounce<String>(300L, scope) { value ->
    println("Search: $value")
}

onType("k")
onType("ko")
onType("kompkit") // only this call will execute after ~300ms
```

### isEmail

```kotlin
import com.kompkit.core.isEmail

isEmail("test@example.com") // true
isEmail("invalid@") // false
```

### formatCurrency

```kotlin
import com.kompkit.core.formatCurrency

formatCurrency(1234.56) // "$1,234.56" (en-US / USD default)
formatCurrency(1234.56, "EUR", "es-ES") // "1.234,56 €"
```

### clamp

```kotlin
import com.kompkit.core.clamp

clamp(5.0, 0.0, 10.0)   // 5.0  — within range, returned as-is
clamp(-3.0, 0.0, 10.0)  // 0.0  — below min, clamped to min
clamp(15.0, 0.0, 10.0)  // 10.0 — above max, clamped to max
```

Useful for bounding any user-controlled numeric value:

```kotlin
val opacity = clamp(userInput, 0.0, 1.0)
val page = clamp(requestedPage, 1.0, totalPages.toDouble())
val volume = clamp(rawVolume, 0.0, 100.0)
```

### throttle

```kotlin
import com.kompkit.core.throttle
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

val scope = CoroutineScope(Dispatchers.Main)
val onScroll = throttle<Int>(200L, scope) { position ->
    println("scroll position: $position")
}

onScroll(0)       // executes immediately
onScroll(50)      // ignored within 200ms
onScroll(100)     // ignored within 200ms
onScroll.cancel() // reset state — call in onDestroy/onStop
```

Unlike `debounce` (which waits until calls stop), `throttle` fires immediately then enforces a cooldown — ideal for scroll, sensor, and touch events where you want immediate feedback at a controlled rate.

## Jetpack Compose integration

### Debounced search field

```kotlin
import androidx.compose.material3.TextField
import androidx.compose.runtime.*
import com.kompkit.core.debounce

@Composable
fun SearchBox() {
    var value by remember { mutableStateOf("") }
    val scope = rememberCoroutineScope()
    val onSearch = remember {
        debounce<String>(300L, scope) { query ->
            println("Search: $query")
        }
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

### Throttled scroll position tracker

```kotlin
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.*
import com.kompkit.core.throttle

@Composable
fun ScrollTracker() {
    val listState = rememberLazyListState()
    val scope = rememberCoroutineScope()
    val onScroll = remember {
        throttle<Int>(200L, scope) { index ->
            println("First visible item: $index")
        }
    }

    LaunchedEffect(listState.firstVisibleItemIndex) {
        onScroll(listState.firstVisibleItemIndex)
    }

    LazyColumn(state = listState) {
        items(100) { index ->
            Text("Item $index")
        }
    }
}
```

### Bounded slider with clamp

```kotlin
import androidx.compose.material3.Slider
import androidx.compose.runtime.*
import com.kompkit.core.clamp

@Composable
fun VolumeSlider() {
    var volume by remember { mutableStateOf(50f) }

    Slider(
        value = volume,
        onValueChange = { raw -> volume = clamp(raw.toDouble(), 0.0, 100.0).toFloat() },
        valueRange = 0f..100f
    )
}
```

## Notes

- Requires `kotlinx-coroutines-core` for the `debounce` and `throttle` utilities.
- All utilities are top-level functions in the `com.kompkit.core` package.
- `formatCurrency` accepts a BCP 47 locale string (e.g., `"en-US"`) — no `java.util.Locale` needed.
- Compatible with Android API 21+.
