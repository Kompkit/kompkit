# Android guide

KompKit Core provides small utilities for Android applications written in Kotlin.

Status: `V0.2.0-alpha`.

## Installation

Add the dependency to your module `build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.kompkit:core:<version>")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
}
```

## Imports

```kotlin
import com.kompkit.core.debounce
import com.kompkit.core.isEmail
import com.kompkit.core.formatCurrency
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
import java.util.Locale

formatCurrency(1234.56) // "1.234,56 €" (es-ES by default)
formatCurrency(1234.56, "USD", Locale.US) // "$1,234.56"
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
- Compatible with Android API 21+.
