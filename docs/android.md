# Android guide

KompKit Core provides small utilities for Android applications written in Kotlin.

Status: `V0.3.1-alpha`.

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

clamp(5.0, 0.0, 10.0)   // 5.0
clamp(-3.0, 0.0, 10.0)  // 0.0
clamp(15.0, 0.0, 10.0)  // 10.0
```

## Jetpack Compose integration

```kotlin
import androidx.compose.material3.TextField
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
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

## Notes

- Requires `kotlinx-coroutines-core` for the `debounce` utility.
- All utilities are top-level functions in the `com.kompkit.core` package.
- `formatCurrency` accepts a BCP 47 locale string (e.g., `"en-US"`) — no `java.util.Locale` needed.
- Compatible with Android API 21+.
