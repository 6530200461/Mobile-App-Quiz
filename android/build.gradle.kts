buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ใช้ Kotlin DSL รูปแบบที่ถูกต้อง
        classpath("com.google.gms:google-services:4.3.8")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}


subprojects {
    project.evaluationDependsOn(":app")
}

// ใช้ Kotlin DSL ที่ถูกต้องสำหรับ tasks.register
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
