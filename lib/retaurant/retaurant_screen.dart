import 'package:actual/common/const/data.dart';
import 'package:actual/retaurant/component/restaurant_card.dart';
import 'package:actual/retaurant/model/restarant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  // restaurant API에서 레스토랑 정보를 페이지네이션으로 받아오는 함수
  //http로 받아오기때문에 기본적으로 비동기, Future / async / await 사용
  // 아래 FutureBuild에 필요
  Future<List> paginateRestaurant() async {
    final dio = Dio();
    //restaurant는 authorization이 필수요소이기 때문에 storage에서 token 가져옴
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );
    //resp.data의 'data' 부분 return ( not 'meta')
    //postman 참고
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        //FutureBuilder => 비동기 데이터를 처리하고 위젯을 반환하는 위젯
        //비동기 데이터들은 위에 paginateRestaurant 함수를 통해 받아옴(API로부터)
        child: FutureBuilder<List>(
          future: paginateRestaurant(),
          //snapshot은 Future의 결과를 나타내는데 사용
          //AsyncSnapshot은 snapshot의 하위 클래스인데, Future의 결과와 에러 정보를 저장하며,
          //snapshot의 모든 상태를 포함한다
          // 결론: AsyncSnapshot은 FutureBuilder에서 가장 많이 사용하는 Snapshot 클래스이다.
          builder: (context, AsyncSnapshot<List> snapshot) {
            //오류, nodata
            if (!snapshot.hasData) {
              return const Center();
            }
            //ListView는 스크롤 위젯
            //separated를 사용하면 자식 요소마다 구분을 줘야되는 곳에 자동으로 넣는다.
            //아래에 separatorBuilder를 통해
            return ListView.separated(
              //itemCount : ListView에 표시될 아이템 개수
              itemCount: snapshot.data!.length,
              //itemBuilder : ListView에 각 요소를 동적으로 생성하는 방법을 정의하는 부분
              //매개변수에서 _는 context 부분인데...
              itemBuilder: (_, index) {
                //itemBuilder가 실행될때마다 해당 index의 item이 선택이 된다.
                //item은 아마 Map<String, Dynamic>으로 있을것임
                final item = snapshot.data![index];
                //p는 parsed의 약자, 모델을 통해 전부 required하게 처리해서 누락하는 실수 방지
                final pItem = RestaurantModel(
                  id: item['id'],
                  name: item['name'],
                  thumbUrl: item['thumbUrl'],
                  tags: List<String>.from(item['tags']),
                  // RestaurantModel의 PriceRange enum에서, item의'priceRange'와
                  // 같은 값을 찾는 의미
                  //firstWhere => 요소를 반복하고 주어진 조건의 첫번째 요소를 반환한다.
                  priceRange: RestaurantPriceRange.values
                      .firstWhere((e) => e.name == item['priceRange']),
                  ratings: item['ratings'],
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['delivertTime'],
                  deliveryFee: item['deliveryFee'],
                );

                return RestaurantCard(
                  // item의 해당 부분을 선택한다. API 참고
                  //asset이 아니라 network로 받아야될때
                  image: Image.network(
                    //
                    // 'http://$ip${item['thumbUrl']}', ---> pItem.thumbUrl
                    // 이렇게 인스턴스화된 요소로 바꿈으로서
                    //  1.자동완성 지원 , 2. 오타 시 오류 의 장점
                    //
                    pItem.thumbUrl,
                    fit: BoxFit.cover,
                  ),
                  // name: item['name'],
                  name: pItem.name,
                  //List는 Dynamic List로 불러오는데, 우리는 List<String>으로 미리
                  //정의를 해놔서 타입 오류가 남
                  //그래서 강제로 tags를 List<String>으로 바꾼것임
                  //이게 가능한 이유는 tags가 실제로 String으로 된 List라서
                  // tags: List<String>.from(item['tags']),
                  tags: pItem.tags,
                  // ratingsCount: item['ratingsCount'],
                  ratingsCount: pItem.ratingsCount,
                  // deliveryTime: item['deliveryTime'],
                  deliveryTime: pItem.deliveryTime,
                  // deliveryFee: item['deliveryFee'],
                  deliveryFee: pItem.deliveryFee,
                  // ratings: item['ratings'],dd
                  ratings: pItem.ratings,
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 16,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
