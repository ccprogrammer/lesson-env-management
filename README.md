[HEADER IMAGE]

In the landscape of app development often presents us with a pressing challenge – the distribution of apps on the Play Store with identical package names, such as "com.example.package" or "com.my.app" whatever you want to name it, this issue becomes particularly thorny when we’re concurrently developing and releasing apps. The core problem lies in the risk of inadvertently overwriting production apps when installing development versions.

The solutions is simply to add descriptive suffixes like “.dev,” “.stage,” and “.prod” to the package names (for instance, “com.example.package.dev”). These suffixes not only differentiate the apps but also enable us to assign unique names, icons, and labels, allowing coexistence without confusion.

In this article, we’ll delve into the practical implementation of this strategy and explore its profound impact on app development efficiency step by step.

There are 6 steps to do to achieve this, i’ll explain it very simple way although it’s not even a short explanation :D

1. **Specify the application type**
2. **Create ENV for each type**
3. **Create launch configuration**
4. **Create app icon for each type**
5. **Firebase (Optional)**
6. **iOS**

Seems like easy peezy right? well programming is very easy to learn if we have time and determination for it. Okay, without saying much more let’s go to the step.

## 1. Specify the application type
In this case we want our app to have 3 different types “Production”, “Staging”, and “Development” waitt…. what is this ? what is Production what is Staging what is Development ??? basically we are free to write this name and the app will not go error, but in common ways to separate the app type is like this, and what is that 3 type?

1. **Production**
   
A ‘Production’ app type refers to an app that has been officially released and is accessible to users through platforms like the Play Store or App Store.

3. **Staging**

The **'Staging'** app type serves as a demonstration for stakeholders. Once they approve it, the app can transition to the ‘**Production**’ type for release.

3. **Development**

In the ‘Development’ phase, we either create new app features or maintain existing ones. Once the development is complete and the app passes the QA check or receives approval from the Project Manager, it progresses to the ‘Staging’ state.

In **build.gradle** “**android\app\build.gradle**” file you can specify the application type according to your needs, inside android { … section we put flavors and what is that? that’s just the name for this stuff it’s like a different taste of the apps

```gradle
android {
    defaultConfig {
    ...
    }
    ...

    flavorDimensions "flavor-type"
    productFlavors {
        prod {
            dimension "flavor-type"
            applicationId "com.my.app"
            resValue "string", "app_name", "My App"
        }        
        stg {
            dimension "flavor-type"
            applicationId "com.my.app.stg"
            resValue "string", "app_name", "My App - Staging"
        }
        dev {
            dimension "flavor-type"
            applicationId "com.my.app.dev"
            resValue "string", "app_name", "My App - Dev"
        }
    }
}
```
just ignore the dimension **flavor-type**, let’s take a look at resValue and **applicationId**,

**resValue** this is where you will specify the app name ‘**My App — Dev**‘ and the “**app_name**” we will use this later on in android manifest to make our app name dynamic base on which build we are using.

**applicationId** this is where you specify the app id that will make it different installation in the device

after we are done specifying the app type let’s move on to **AndroidManifest.xml** file “**android\app\src\main\AndroidManifest.xml**” to make our app name dynamic

[android manifest image]

maybe your **AndroidManifest.xml** won’t look 100 percent same with me but don’t panic just go through the file path and you will find it.

In **<application android:label=** change the value to **“@string/app_name**” so our app will target the app name in **resValue** “**string**”, “**app_name**”, “**My App — Dev**" inside **build.gradle** “**android\app\build.gradle**”

## 2. Create ENV for each type
In this case we want our app to have 3 different types “Production”, “Staging”, and “Development” waitt…. what is this ? what is Production what is Staging what is Development ??? basically we are free to write this name and the app will not go error, but in common ways to separate the app type is like this, and what is that 3 type?

[main image]

Each app type has its dedicated environment. For instance, the development stage uses a development server with the URL ‘**api.dev.com/api/**’, while the production stage employs ‘**api.production.com/api/**’. Additionally, we may want the development app to feature a debug screen, whereas the production app does not. How can we make these distinctions? that’s why we should specify the env in each **main_**.

[6 image]

```dart
enum Flavor {
  dev,
  stg,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Env Management - Dev';
      case Flavor.stg:
        return 'Env Management - Staging';
      case Flavor.prod:
        return 'Env Management';
      default:
        return 'Env Management';
    }
  }

  static String get url {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://dev.your.api.url';
      case Flavor.stg:
        return 'https://stg.your.api.url';
      case Flavor.prod:
        return 'https://your.api.url';
      default:
        return 'no url';
    }
  }
}
```

as you can see each config is different, if we run **main.dart** the config will initialized and have variables of **url** for production if we run **main_dev.dart** it will have development **url**, to use it we just have to call this getter

```dart
final _baseUrl = F.url;
```

## 3. Create launch configuration
As default launch we only press **F5** to launch the app for debugging but since we have 3 **main.dart** how do we specify which **main.dart** to launch ?

```cmd
flutter run -t lib/main.dart --flavor prod
flutter run -t lib/main_stg.dart --flavor stg
flutter run -t lib/main_dev.dart --flavor dev
```

or we can set it in the setting so we don’t need to run it on terminal over and over again by creating a **launch.json** file inside the **.vscode** folder

[3 image]

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Production",
            "request": "launch",
            "type": "dart",
            "args": [
                "-t",
                "lib/main_prod.dart",
                "--flavor",
                "prod"
            ]
        },
        {
            "name": "Launch Staging",
            "request": "launch",
            "type": "dart",
            "args": [
                "-t",
                "lib/main_stg.dart",
                "--flavor",
                "stg"
            ]
        },
        {
            "name": "Launch Development",
            "request": "launch",
            "type": "dart",
            "args": [
                "-t",
                "lib/main_dev.dart",
                "--flavor",
                "dev"
            ]
        }
    ]
}
```

Where are these **prod**, **stg**, and **dev** come from ? it’s from **build.gradle** that we have already specify the **flavor** before.

Well done ! now you are ready to start developing your app with different environment for **Production**, **Staging**, and **Development**.

## 4. Create app icon for each type

[app icon image]

As you can see at the beginning we have 3 types of app and how do we create different icon for each type? we can use this package and our work will be very easy [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

1. Configure **pubspec.yaml** and create 3 different **.yaml** file for each app types
   [image]
   put this inside each file and target the image_path to your app icons inside assets folder
   ```yaml
   flutter_icons:
    android: true
    ios: true
    image_path: "assets/launcher_icons/app_icon_dev.png"
   ```
   ```yaml
   flutter_icons:
    android: true
    ios: true
    image_path: "assets/launcher_icons/app_icon_stg.png"
   ```
   ```yaml
   flutter_icons:
    android: true
    ios: true
    image_path: "assets/launcher_icons/app_icon.png"
   ```
   and inside the pubspec.yaml
   ```yaml
   flutter_icons:
    android: true
    ios: true
   ```
   [image]

after that just launch this command and it will automatically generate the app icon for each types

NOTE: These folder **prod**, **dev**, **stg** inside **android/app/src/** won’t appear until you generate the [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) so don’t panic :D

```cmd
dart run flutter_launcher_icons:main
```

[image]

Next on iOS set the “**Asset Catalog**” path in XCode depending what names in the assets like below image

[2 image]

## 5. Firebase (Optional)
If you are using Firebase, you may encounter an issue where you cannot build another environment. This occurs when your package name does not match the one specified in the Google services configuration. So, how can you resolve this issue? The solution is quite simple: just copy and paste your current Google services configuration file and place it inside the corresponding environment directories, which can be found in “**android/app/src/…dev …prod,**” or whatever you have named them.

[image]

Next, within the folder, include the environment type as a prefix to the package name, changing it from “com.example.package” to “com.example.package.dev,” and you’re all set.

[image]

# iOS
In the configuration of environment flavors for iOS, the first step you need to take is to open the ‘**ios**’ folder in the Flutter project by right-clicking and selecting ‘**Open in Xcode**.’ This will take you to the iOS folder using Xcode, making it easy for you to make changes.

[image]

## 1. Create Flavor Schemes
For the initial stage, you need to create flavor schemes such as **prod**, **staging**, **dev**. The naming is flexible and entirely up to you. These will be used later when running the project to determine whether the app runs in production, development, or other configurations. You only need to duplicate the default scheme and rename it according to your needs

[2 image]

## 2. Create Build Configuration
After creating the necessary schemes, you need to configure what happens when the app is run. For example, if the running flavor is ‘**dev**,’ the ‘**dev**’ flavor will fetch the corresponding configuration. As shown in the image below, you only need to duplicate the default debug, profile, and release configurations by adding your scheme name, such as ‘**Debug-dev**’, ‘**Debug-stg**’ or ‘**Debug-prod**’

[2 image]

And don’t forget, after creating the configurations, you need to match them with the previously created schemes by clicking edit schemes

[image] 

As you can see in the image below, you need to modify all configurations on the left by matching them with the corresponding scheme. For example, if the scheme is ‘dev,’ you select the configuration with the ‘dev’ name.

[3 image]

## 3. Name The App Bundle
Now, we need to change the bundle name, and this will be the differentiator when the app is installed. For example, if the bundle name is ‘com.example.project,’ for the newly created scheme, we add something like ‘**com.example.project.dev**’ or ‘**com.example.project.stg**.’ Leave it as is for production.

To do this we have to go to Targets section and look for “**Product Bundle Identifier**”

[image]

## 4. Name The App Product Name
Next, we name our app when installed by going to the ‘**Product Name**’ section

[image]

As you can see, I added ‘ - **Dev** ’ or ‘ - **Stg** ’ except for production because users don’t need to know what production means.

Then in info.plist we need to call this dynamic name base on what build settings we are running by changing the “**Bundle Display Name**”

[image]

## 5. Modify Some Other Things (Optional)
Last but not least, we need to change some other crucial elements; at least, that’s what I’ve experienced if not maybe you will encounter some frustrating issues in the days ahead like me :’(

the first one you need to add this command **-no-verify-emitted-module-interface** to **Other Swift Flags**

[image]

and why? why do we do this? maybe at some point you will encounter an issue like this and for me i need 2 days to find the solution from [StackOverflow](https://stackoverflow.com/) even though the solution is very simple but the answer is hard to find

```
failed to verify module interface of 'projectName' due to the errors above; 
the textual interface may be broken by project issues or a compiler bug
```

I think there’s only one thing you should change at the moment. I forgot what else we need to modify :D
