import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/foundation.dart';

class WallpaperPage extends StatefulWidget {
  final String heroId, imageUrl, name;
  final ThemeData themeData;

  WallpaperPage(
      {@required this.heroId,
      @required this.imageUrl,
      this.name,
      this.themeData});
  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-3935970661666157/9069565535",
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  bool downloadDone = false;
  var progressString = "";

  Widget myBody(BuildContext context) {
    print(Theme.of(context).accentColor);
    return Theme(
      data: widget.themeData,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Hero(
              tag: widget.heroId,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: FadeInImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/loading.gif'),
                ),
              ),
            ),
            Positioned(
              top: 28,
              left: 8,
              child: FloatingActionButton(
                tooltip: 'Close',
                child: Icon(
                  Icons.clear,
                  color: widget.themeData.accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                heroTag: 'close',
                mini: true,
                backgroundColor: widget.themeData.primaryColor.withOpacity(0.5),
              ),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height - 150,
                      ),
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height - 200,
                        decoration: BoxDecoration(
                            color:
                                widget.themeData.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0))),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.name,
                                    style: widget.themeData.textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {
                                    shareImage(widget.imageUrl);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.file_download),
                                  onPressed: () {
                                    downloadImage(widget.imageUrl);
                                  },
                                ),
                                Text(
                                  !downloadDone ? '' : 'Downloaded',
                                  style: widget.themeData.textTheme.body2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Platform.isAndroid
                        ? Positioned(
                            right: 16.0,
                            top: 0.0,
                            child: FloatingActionButton(
                              tooltip: 'Set as Wallpaper',
                              backgroundColor: widget.themeData.primaryColor,
                              child: Icon(
                                Icons.format_paint,
                                color: widget.themeData.accentColor,
                              ),
                              onPressed: () async {
                                makeWallpaper(widget.imageUrl);
                              },
                            ),
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makeWallpaper(url) async {
    Stream<String> progressString = Wallpaper.ImageDownloadProgress(url);
    progressString.listen((data) {
      print("DataReceived: " + data);
    }, onDone: () async {
      await Wallpaper.homeScreen();
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
  }

  Future<void> shareImage(url) async {
    print("share");
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('wallpaper', 'wallpaper.jpg', bytes, 'image/jpg');
  }

  Future<void> downloadImage(url) async {
    try {
      print("downloadImage");

      String result =
          await ImageDownloader.downloadImage(url).catchError((error) {
        print(error);
      }).timeout(Duration(seconds: 10), onTimeout: () {
        print("timeout");
        return "";
      });

      print("result");
      print(result);
      setState(() {
        downloadDone = true;
      });
    } on PlatformException catch (error) {
      print(error);
    }
    // Dio dio = Dio();

    // try {
    //   var directory = await getExternalStorageDirectory();
    //   // var dir = await getApplicationDocumentsDirectory();

    //   await dio.download(widget.imageUrl,
    //       "${directory.path}/${DateTime.now().toUtc().toIso8601String()}.png",
    //       onReceiveProgress: (rec, total) {
    //     // print("Rec: $rec , Total: $total");

    //     setState(() {
    //       downloading = true;
    //       progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
    //     });
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return myBody(context);
  }
}
