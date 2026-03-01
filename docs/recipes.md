# Recipes

Real-world examples using KompKit Core utilities.

## Debounced search input (React)

```tsx
import { useState, useEffect } from "react";
import { debounce } from "kompkit-core";

function SearchComponent() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  useEffect(() => {
    const search = debounce(async (q: string) => {
      if (!q) return;
      const res = await fetch(`/api/search?q=${q}`);
      const data = await res.json();
      setResults(data);
    }, 400);

    search(query);
    return () => search.cancel(); // cleanup on unmount or query change
  }, [query]);

  return (
    <div>
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search..."
      />
      <ul>
        {results.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Debounced TextField in Compose

```kotlin
import androidx.compose.material3.*
import androidx.compose.runtime.*
import com.kompkit.core.debounce
import kotlinx.coroutines.launch

@Composable
fun SearchScreen() {
    var query by remember { mutableStateOf("") }
    var results by remember { mutableStateOf(listOf<String>()) }
    val scope = rememberCoroutineScope()

    val search = remember {
        debounce<String>({ q ->
            scope.launch {
                if (q.isNotEmpty()) {
                    results = fetchResults(q)
                }
            }
        }, waitMs = 400L, scope = scope)
    }

    Column {
        TextField(
            value = query,
            onValueChange = { newValue ->
                query = newValue
                search(newValue)
            },
            placeholder = { Text("Search...") }
        )
        LazyColumn {
            items(results) { item ->
                Text(item)
            }
        }
    }
}

suspend fun fetchResults(query: String): List<String> {
    // API call here
    return emptyList()
}
```

## Debounced search input (Flutter)

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late final Debounced<String> _debouncedSearch;
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<String>((String query) async {
      if (query.isEmpty) return;
      final results = await _fetchResults(query);
      setState(() {
        _results = results;
      });
    }, const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _debouncedSearch.cancel();
    super.dispose();
  }

  Future<List<String>> _fetchResults(String query) async {
    // API call here
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
    return ['Result 1 for $query', 'Result 2 for $query'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _debouncedSearch,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Currency formatting with locale switch

```tsx
import { useState } from "react";
import { formatCurrency } from "kompkit-core";

function PriceDisplay({ amount }: { amount: number }) {
  const [locale, setLocale] = useState<"en-US" | "es-ES" | "ja-JP">("en-US");

  const localeConfig = {
    "en-US": { currency: "USD", locale: "en-US" },
    "es-ES": { currency: "EUR", locale: "es-ES" },
    "ja-JP": { currency: "JPY", locale: "ja-JP" },
  } as const;

  const config = localeConfig[locale];
  const formatted = formatCurrency(amount, config.currency, config.locale);

  return (
    <div>
      <p>Price: {formatted}</p>
      <select value={locale} onChange={(e) => setLocale(e.target.value as any)}>
        <option value="en-US">USD</option>
        <option value="es-ES">EUR</option>
        <option value="ja-JP">JPY</option>
      </select>
    </div>
  );
}
```

## Email validation on form submission

```tsx
import { useState } from "react";
import { isEmail } from "kompkit-core";

function ContactForm() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!isEmail(email)) {
      setError("Please enter a valid email address");
      return;
    }
    setError("");
    // Submit form
    console.log("Submitting:", email);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
      />
      {error && <p style={{ color: "red" }}>{error}</p>}
      <button type="submit">Submit</button>
    </form>
  );
}
```

## Currency formatting with locale switch (Flutter)

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

class PriceDisplay extends StatefulWidget {
  final double amount;

  const PriceDisplay({Key? key, required this.amount}) : super(key: key);

  @override
  _PriceDisplayState createState() => _PriceDisplayState();
}

class _PriceDisplayState extends State<PriceDisplay> {
  String _selectedLocale = 'en-US';

  final Map<String, Map<String, String>> _localeConfig = {
    'en-US': {'currency': 'USD', 'locale': 'en-US'},
    'es-ES': {'currency': 'EUR', 'locale': 'es-ES'},
    'ja-JP': {'currency': 'JPY', 'locale': 'ja-JP'},
  };

  @override
  Widget build(BuildContext context) {
    final config = _localeConfig[_selectedLocale]!;
    final formatted = formatCurrency(
      widget.amount,
      currency: config['currency']!,
      locale: config['locale']!,
    );

    return Column(
      children: [
        Text(
          'Price: \$formatted',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 16),
        DropdownButton<String>(
          value: _selectedLocale,
          onChanged: (String? newValue) {
            setState(() {
              _selectedLocale = newValue!;
            });
          },
          items: _localeConfig.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(_localeConfig[value]!['currency']!),
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

## Throttled scroll handler (TypeScript)

```ts
import { throttle } from "kompkit-core";

const onScroll = throttle(() => {
  console.log("scroll position:", window.scrollY);
}, 200);

window.addEventListener("scroll", onScroll);

// On cleanup:
onScroll.cancel();
window.removeEventListener("scroll", onScroll);
```

## Throttled event handler (Kotlin)

```kotlin
import com.kompkit.core.throttle
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

val scope = CoroutineScope(Dispatchers.Main)
val onSensorUpdate = throttle<Float>(100L, scope) { value ->
    updateUI(value)
}

// In sensor callback:
onSensorUpdate(sensorValue)

// On cleanup:
onSensorUpdate.cancel()
```

## Throttled scroll listener (Flutter)

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

class ScrollTracker extends StatefulWidget {
  @override
  _ScrollTrackerState createState() => _ScrollTrackerState();
}

class _ScrollTrackerState extends State<ScrollTracker> {
  final _controller = ScrollController();
  late final Throttled<double> _throttledScroll;

  @override
  void initState() {
    super.initState();
    _throttledScroll = throttle<double>(
      (offset) => print('scroll: $offset'),
      const Duration(milliseconds: 200),
    );
    _controller.addListener(() => _throttledScroll(_controller.offset));
  }

  @override
  void dispose() {
    _throttledScroll.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: 100,
      itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
    );
  }
}
```

## Clamping a slider value (TypeScript / React)

```tsx
import { clamp } from "kompkit-core";

function VolumeSlider() {
  const [volume, setVolume] = useState(50);

  const handleChange = (raw: number) => {
    setVolume(clamp(raw, 0, 100));
  };

  return (
    <input
      type="range"
      value={volume}
      onChange={(e) => handleChange(Number(e.target.value))}
    />
  );
}
```

## Clamping a value (Kotlin)

```kotlin
import com.kompkit.core.clamp

val volume = clamp(rawInput, 0.0, 100.0)
val opacity = clamp(userValue, 0.0, 1.0)
```

## Clamping a value (Flutter)

```dart
import 'package:kompkit_core/kompkit_core.dart';

final volume = clamp(rawInput, 0.0, 100.0);
final opacity = clamp(userValue, 0.0, 1.0);
final scrollOffset = clamp(rawOffset, 0.0, maxScrollExtent);
```

## Throttled scroll header with clamped opacity (TypeScript / React)

A common pattern: fade in a sticky header as the user scrolls, throttled to avoid running every frame, opacity clamped to stay in `[0, 1]`.

```tsx
import { useEffect, useRef, useState } from "react";
import { throttle, clamp } from "kompkit-core";

export function StickyHeader() {
  const [opacity, setOpacity] = useState(0);
  const onScroll = useRef(
    throttle(() => {
      // Full opacity by 200px, clamped so it never exceeds 1
      setOpacity(clamp(window.scrollY / 200, 0, 1));
    }, 50),
  );

  useEffect(() => {
    window.addEventListener("scroll", onScroll.current);
    return () => {
      onScroll.current.cancel();
      window.removeEventListener("scroll", onScroll.current);
    };
  }, []);

  return (
    <header style={{ opacity, position: "sticky", top: 0, background: "#fff" }}>
      My App
    </header>
  );
}
```

## Throttled scroll header with clamped opacity (Kotlin / Compose)

```kotlin
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.lerp
import com.kompkit.core.clamp
import com.kompkit.core.throttle

@Composable
fun StickyHeader() {
    val listState = rememberLazyListState()
    val scope = rememberCoroutineScope()
    var opacity by remember { mutableStateOf(0f) }

    val onScroll = remember {
        throttle<Int>(50L, scope) { offset ->
            opacity = clamp(offset / 200.0, 0.0, 1.0).toFloat()
        }
    }

    LaunchedEffect(listState.firstVisibleItemScrollOffset) {
        onScroll(listState.firstVisibleItemScrollOffset)
    }

    Box(modifier = Modifier.graphicsLayer { alpha = opacity }) {
        Text("My App", style = MaterialTheme.typography.headlineSmall)
    }
}
```

## Throttled scroll header with clamped opacity (Flutter)

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

class StickyHeader extends StatefulWidget {
  @override
  State<StickyHeader> createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<StickyHeader> {
  final _controller = ScrollController();
  late final Throttled<double> _onScroll;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _onScroll = throttle<double>(
      (offset) => setState(() {
        // Full opacity by 200px, clamped to [0, 1]
        _opacity = clamp(offset / 200, 0.0, 1.0);
      }),
      const Duration(milliseconds: 50),
    );
    _controller.addListener(() => _onScroll(_controller.offset));
  }

  @override
  void dispose() {
    _onScroll.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _controller,
          itemCount: 100,
          itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
        ),
        Opacity(
          opacity: _opacity,
          child: Container(
            color: Colors.white,
            height: 56,
            child: const Center(child: Text('My App')),
          ),
        ),
      ],
    );
  }
}
```

## Email validation on form submission (Flutter)

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Submit form
      print('Submitting: ${_emailController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
