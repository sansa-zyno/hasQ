/*import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String testDevice = '0b60a0dc8901ca7b635b7294ef48b01a';
const int maxFailedLoadAttempts = 3;

///https://stackoverflow.com/questions/50972863/admob-banner-how-to-show-only-on-home
///
class AdmobService {
  // static BannerAd _bannerAd;
  static InterstitialAd _interstitialAd;
  static int _numRewardedLoadAttempts = 0;
  static RewardedAd _rewardedAd;
  static int _numInterstitialLoadAttempts = 0;

  //static BannerAd get bannerAd => _bannerAd;
  /*static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';*/

  /*static String get iOSInterstitialAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'cca-app-pub-3940256099942544/1033173712';*/

  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = new BannerAd(
      adUnitId: 'ca-app-pub-1921045378803928/7517660349',
      size: AdSize.largeBanner,
      request: AdRequest(),
      //listener: null,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );

    return ad;
  }

  /*static showBannerAd() {
     if (_bannerAd != null) {
      return;
    }
    _bannerAd = createBannerAd();
    _bannerAd..load();
    return _bannerAd;
  }

  void disposeAds() {
    print("disposeAds");
    if (_bannerAd != null) {
      _bannerAd?.dispose();
    }
  }*/

  static _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1921045378803928/6756264516',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;

          _interstitialAd.show();
          _interstitialAd = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    //_interstitialAd?.dispose();
    //_interstitialAd = null;
    if (_interstitialAd == null) {
      //_interstitialAd = _createInterstitialAd();
      //_interstitialAd.load();
      _createInterstitialAd();
    }
  }

  static _createRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-1921045378803928/9063875416',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
            _rewardedAd.show(
                onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
              // Reward the user for watching an ad.
            });
            _rewardedAd = null;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _numRewardedLoadAttempts += 1;
            _rewardedAd = null;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  static void showRewardedAd() {
    if (_rewardedAd == null) {
      _createRewardedAd();
    }
  }
}*/
