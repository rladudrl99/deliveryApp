import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obsecureText;
  final bool autoFocus;
  final Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obsecureText = false,
    this.autoFocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BG_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      //비밀번호 입력
      obscureText: obsecureText,
      //자동으로 텍스트필드 선택
      autofocus: autoFocus,
      //값이 바뀔때마다 실행하는 함수
      onChanged: onChanged,
      //TextformField decoration => InputDecoration
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14,
        ),
        //배경색 설정
        fillColor: INPUT_BG_COLOR,
        //false - 배경색 없음
        //true - 배경색 있음
        filled: true,
        //모든 input 상태의 기본 스타일 세팅
        border: baseBorder,
        //선택된 textfield에 테두리 적용.
        enabledBorder: baseBorder,
        //선택된 텍스트필드 보더 변경
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
