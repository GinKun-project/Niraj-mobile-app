// Root build.gradle.kts

// Define repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect build outputs to a centralized directory two levels up
val centralizedBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(centralizedBuildDir)

// Set the build directory for each subproject to a subfolder inside the centralized build directory
subprojects {
    val subprojectBuildDir = centralizedBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
}

// Ensure that subprojects evaluate the ':app' project (if needed)
subprojects {
    project.evaluationDependsOn(":app")
}

// Register a clean task that deletes the centralized build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
