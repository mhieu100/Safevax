enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return '[DEV] Flutter GetX';
      case Flavor.prod:
        return 'Flutter GetX';
      default:
        return 'title';
    }
  }

  static String? toBaseurl() {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://backend.mhieu100.space/api/';
      case Flavor.prod:
        return 'https://backend.mhieu100.space/api/';
      default:
        return null;
    }
  }
}
