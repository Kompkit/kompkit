plugins {
  kotlin("jvm") version "2.3.0"
  id("org.jetbrains.dokka") version "2.0.0"
  id("org.jlleitschuh.gradle.ktlint") version "14.0.1"
  id("io.gitlab.arturbosch.detekt") version "1.23.8"
}

repositories {
  mavenCentral()
}

java {
  sourceCompatibility = JavaVersion.VERSION_17
  targetCompatibility = JavaVersion.VERSION_17
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
  compilerOptions {
    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
  }
}

dependencies {
  implementation(kotlin("stdlib"))
  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
  testImplementation(kotlin("test"))
  testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.10.2")
  testImplementation("junit:junit:4.13.2")
}

tasks.test {
  useJUnit()
}

tasks.register<Copy>("copyDokkaToDocs") {
  dependsOn(tasks.named("dokkaHtml"))
  from(layout.buildDirectory.dir("dokka/html")) {
    include("**/*")
  }
  into(layout.projectDirectory.dir("../../../docs/api/android"))
  duplicatesStrategy = DuplicatesStrategy.INCLUDE
}

// ktlint configuration
ktlint {
  version.set("1.0.1")
  android.set(false)
  ignoreFailures.set(false)
  reporters {
    reporter(org.jlleitschuh.gradle.ktlint.reporter.ReporterType.PLAIN)
    reporter(org.jlleitschuh.gradle.ktlint.reporter.ReporterType.CHECKSTYLE)
  }
}

// detekt configuration
detekt {
  buildUponDefaultConfig = true
  allRules = false
}

tasks.withType<io.gitlab.arturbosch.detekt.Detekt>().configureEach {
  jvmTarget = "17"
  reports {
    html.required.set(true)
    xml.required.set(true)
    txt.required.set(true)
  }
}
