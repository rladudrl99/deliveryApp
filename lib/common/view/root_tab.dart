import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/retaurant/retaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  //bottomnavigationbar item index

  //tabBarView의 controller
  //controller는 나중에 입력돼서 null safety 오류가 나는데
  //?를 쓰지 말고 late를 쓰면 됨(어차피 확정적으로 생성되고, ?처리를 하면 컨트롤러 쓸때마다 null 확인하는 작업 해야돼서 비효율적)
  late TabController controller;

  int index = 0;

  //tabBarView의 controller 설정하는 부분
  @override
  void initState() {
    super.initState();
    //initState 안에 controller를 tabcontroller로 설정
    //length는 tabbarview의 children 개수, 여기서는 4개(몇개의 화면 컨트롤할건지)
    //vsync에는 컨트롤러를 선언하는 현재의 state(or Stateful Widget)를 넣어주면 됨.
    //여기서는 this인데 this가 특정 기능을 갖고 있어야됨
    // 그래서 위에 singleTickerProviderMixin를 설정해 줘야됨
    ////////// 정리///////
    // vsync에는 현재 클래스를 넣은 다음 현재 클래스에 singleTickerproviderMixin 추가
    //애니메이션을 사용하는 다른 클래스에서도 vsync가 있는데 똑같이 하면 됨.
    controller = TabController(length: 4, vsync: this);
    //controller에서 값이 변경될때마다 특정 변수를 실행해라 -> listener
    //ontap을 통해서 탭을 누를때도 화면이 전환되지만, bottomnavigationbar의 아이템을 누르면
    //밑의 아이템은 화면이 이동돼도 변경이 없음
    //이를 해결하기 위해 controller에 listner를 추가해야됨
    controller.addListener(tabListner);
  }

  @override
  void dispose() {
    controller.removeListener(tabListner);
    super.dispose();
  }

  //controller의 index를 bottomnavigationbar의 index로 설정하면 tabbarview와 bottomnavigationbar를 연동할 수 있다.
  void tabListner() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'copack delivery',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        //bottomNavigationBar의 타입 설정. shifting은 애니메이션 포함된 타입
        type: BottomNavigationBarType.shifting,

        //ontap에서 탭의 아이템을 누를때마다 해당 index로 이동

        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        //좌우+상하 스크롤 가능한데, 여기서는 불필요해서 좌우스크롤 불가능하게(tabbar통해서만)
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          //lib/restaurant/view/restaurant_screen
          RestaurantScreen(),
          Center(
            child: Text('음식'),
          ),
          Center(
            child: Text('주문'),
          ),
          Center(
            child: Text('프로필'),
          ),
        ],
      ),
    );
  }
}
