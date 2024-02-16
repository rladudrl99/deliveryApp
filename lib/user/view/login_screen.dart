import 'dart:convert';
// import 'dart:html';

import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    //dio를 불러오기 전 선언하기
    final dio = Dio();

    return DefaultLayout(
      //키보드가 올라왔을때 올라가게 하기 위해 singleChildScrollView
      child: SingleChildScrollView(
        //키보드 입력이 완료됐을때 화면을 누르면(스크롤하면) 키보드 자동으로 내려감 => ondrag
        //onManual => done을 눌러야 키보드 내려감(수동)
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해 주세요',
                  obsecureText: false,
                  autoFocus: true,
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해 주세요',
                  obsecureText: true,
                  autoFocus: false,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  //로그인 버튼 구현
                  //비동기 함수이기 때문에 async 적용
                  onPressed: () async {
                    final rawString = '$username:$password';

                    //해당 라인을 통해 base64 인코딩 가능
                    Codec<String, String> StringToBase64 = utf8.fuse(base64);
                    ////////////////////////////////////////////////////////

                    //id/pw의 rawstring을 base64로 인코딩
                    String token = StringToBase64.encode(rawString);

                    //dio 패키지를 이용해 API 요청하는 부분
                    //resp에 dio의 post(경로, 옵션)
                    //경로는 API 주소
                    //옵션은 필요한 정보, 여기서는 base64로 인코딩된 토큰이 필요하므로 header에 Basic + token
                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );
                    //.data는 응답받은 데이터값, body에 해당하는 데이터
                    //access token과 refresh token이 map으로 존재
                    //따라서 refresh token은 resp.data의 map에서 key에 해당한다.
                    // map<String accessToken : value, String refreshToken : value>
                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);

                    //로그인에 성공하면 rootPage로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RootTab(),
                      ),
                    );
                  },
                  //ElevatedButton 스타일 적용
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {},

                  //TextButton 스타일 적용
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해 로그인 해 주세요.\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
