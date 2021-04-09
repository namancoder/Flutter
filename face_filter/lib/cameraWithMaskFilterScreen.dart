import "dart:io" as Platform;
import "package:flutter/material.dart";
import "package:camera_deep_ar/camera_deep_ar.dart";
import "package:avatar_view/avatar_view.dart";

class CameraWithMaskFilter extends StatefulWidget {
  @override
  _CameraWithMaskFilterState createState() => _CameraWithMaskFilterState();
}

class _CameraWithMaskFilterState extends State<CameraWithMaskFilter> {
  CameraDeepArController cameraDeepArController;

  String platformVersion = "Unknown";
  final vp = PageController(viewportFraction: .24);
  int currentPage = 0;
  Effects currentEffects = Effects.none;
  Filters currentFilters = Filters.none;

  Masks currentPath = Masks.none;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraDeepAr(
                onCameraReady: (isReady) {
                  platformVersion = "Camera Status $isReady";
                  print(platformVersion);
                  setState(() {});
                },
                onImageCaptured: (path) {
                  platformVersion = "Image saved at $path";
                  print(platformVersion);
                },
                androidLicenceKey:
                    "718e164641d07b9cdbcbcfe58f1a94f909a752a97e27fcb04d8be209c46262b91e9655d97761d843",
                cameraDeepArCallback: (c) async {
                  cameraDeepArController = c;
                  setState(() {});
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          8,
                          (page) {
                            bool active = currentPage == page;
                            return Platform.Platform.isIOS
                                ? GestureDetector(
                                    onTap: () {
                                      currentPage = page;
                                      cameraDeepArController.changeMask(page);
                                      setState(() {});
                                    },
                                    child: AvatarView(
                                      radius: active ? 65 : 30,
                                      borderColor: Colors.orange,
                                      borderWidth: 2,
                                      isOnlyText: false,
                                      avatarType: AvatarType.CIRCLE,
                                      backgroundColor: Colors.red,
                                      imagePath:
                                          "assets/ios/${page.toString()}.jpg",
                                      placeHolder:
                                          Icon(Icons.person, size: 50.0),
                                      errorWidget: Container(
                                        child: Icon(
                                          Icons.error,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      currentPage = page;
                                      cameraDeepArController.changeMask(page);

                                      setState(() {});
                                    },
                                    onSecondaryTap: () {
                                      if (null == cameraDeepArController) {
                                        return;
                                      }
                                      cameraDeepArController.snapPhoto();
                                    },
                                    child: AvatarView(
                                      // onTap: () {
                                      //   if (null ==
                                      //       cameraDeepArController) {
                                      //     return;
                                      //   }
                                      //   cameraDeepArController.snapPhoto();
                                      // },
                                      radius: active ? 65 : 30,
                                      borderColor: Colors.black,
                                      borderWidth: 2,
                                      isOnlyText: false,
                                      avatarType: AvatarType.CIRCLE,
                                      backgroundColor: Colors.red,
                                      imagePath:
                                          "assets/android/${page.toString()}.jpg",
                                      placeHolder:
                                          Icon(Icons.person, size: 50.0),
                                      errorWidget: Container(
                                        child: Icon(
                                          Icons.error,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () {
                      if (null == cameraDeepArController) {
                        return;
                      }
                      cameraDeepArController.snapPhoto();
                    },
                    child: Icon(Icons.camera)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
