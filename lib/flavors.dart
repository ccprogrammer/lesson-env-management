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
