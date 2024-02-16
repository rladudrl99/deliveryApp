import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//앱이 처음 실행되면 나오는 splash screen
//로딩시간동안 토큰을 가지고있는지 아닌지 확인.
//토큰이 없으면 로그인 페이지로 진입
//토큰이 있으면 roottab으로 이동

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
////////////////////////////////////////////////////////////
  //initState에 위젯이 처음 생성됐을때 하고싶은 일 작성
  @override
  void initState() {
    // deleteToken();
    checkToken();
  }
  ////////////////////////////////////////////////////////////

  //storage의 token을 삭제해서 로그인 페이지 확인할수 있도록..
  void deleteToken() async {
    await storage.deleteAll();
  }

  // 토큰을 확인해서 있다(로그인 한 적이 있고 refreshToken이 만료가 안됐다) => roottab으로 이동
  //refreshToken이나 AccessToken이 없다(로그인해서 토큰 받아야된다) => loginpage로 이동
  void checkToken() async {
    //flutterSecureStorage의 read를 통해 데이터 불러오기.
    //initState 내에서는 await이 안돼서 밖으로 함수를 따로 빼서 비동기 적용
    final dio = Dio();
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootTab()), (route) => false);
    } catch (e) {
      print('e: $e');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    }
  }

  // 다음 화면으로 이동할때 이전의 화면을 제거하기 위해 pushAndRemoveUntil 사용

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        //sizedBox로 column 감싸고 width를 화면 width로 설정해서 최대크기로 설정
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
