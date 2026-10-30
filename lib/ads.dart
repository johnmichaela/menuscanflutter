import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Android test ID for Banner
  final String _adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner, // 320x50
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          debugPrint('Banner failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 50); // Placeholder height
    }
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  // Android test ID for Native
  final String _adUnitId = 'ca-app-pub-3940256099942544/2247696110';

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      // This must match the ID registered in MainActivity.kt
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
          debugPrint('Native failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox(height: 100); // Placeholder
    }
    return Container(
      height: 120, // Adjust based on your native layout
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10)),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}


class NativeAdWidgetGrid extends StatefulWidget {
  const NativeAdWidgetGrid({super.key});

  @override
  State<NativeAdWidgetGrid> createState() => _NativeAdWidgetGridState();
}

class _NativeAdWidgetGridState extends State<NativeAdWidgetGrid> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  // Android test ID for Native
  final String _adUnitId = 'ca-app-pub-3940256099942544/2247696110';

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      // This must match the ID registered in MainActivity.kt
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
          debugPrint('Native failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox(height: 100); // Placeholder
    }
    return Container(
      // height: 120, // Adjust based on your native layout
      // margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10)),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}

class NativeVideoAdCard extends StatefulWidget {
  const NativeVideoAdCard({super.key});

  @override
  State<NativeVideoAdCard> createState() => _NativeVideoAdCardState();
}

class _NativeVideoAdCardState extends State<NativeVideoAdCard> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _disposed = false;

  // Test native unit ID — video ads are served from the same unit.
  static const String _unitId =
      'ca-app-pub-3940256099942544/2247696110';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _ad = NativeAd(
      adUnitId: _unitId,
      factoryId: 'videoCard',       // matches MainActivity.kt
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        // Let AdMob pick video when available
        videoOptions: VideoOptions(
          startMuted: true,
          // shouldStartVideoMuted: true,
          clickToExpandRequested: true,
        ),
        mediaAspectRatio: MediaAspectRatio.landscape,
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (_disposed) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          _ad = null;
          debugPrint('Native video ad failed: $err');
        },
        // onVideoPlay: () => debugPrint('Video playing'),
        // onVideoPause: () => debugPrint('Video paused'),
        // onVideoEnd: () => debugPrint('Video ended'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _disposed = true;
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) {
      return Container(
        height: 260,
        margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      height: 260, // adjust to your NativeAdView height
      margin:  EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
      child: AdWidget(ad: _ad!),
    );
  }
}