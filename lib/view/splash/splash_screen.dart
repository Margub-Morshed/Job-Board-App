import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_board_app/services/splash/splash_services.dart';
import '../../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices splashServices = SplashServices();
  @override
  void initState() {
    splashServices.navigate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
                imageUrl:
                "https://static.vecteezy.com/system/resources/previews/021/096/523/original/3d-icon-job-search-png.png",
                height: 200),
            SizedBox(height: Utils.scrHeight * .08),
            SpinKitWaveSpinner(
              color: Colors.blueAccent.withOpacity(.6),
              trackColor: Colors.blueAccent.withOpacity(.4),
              duration: const Duration(seconds: 3),
              curve: Curves.fastOutSlowIn,
              waveColor: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
