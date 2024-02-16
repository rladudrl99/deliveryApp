import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  //레스토랑 이미지
  final Widget image;
  //레스토랑 이름
  final String name;
  //레스토랑 태그
  final List<String> tags;
  //평점 개수
  final int ratingsCount;
  //배송 걸리는 시간
  final int deliveryTime;
  //배송 비용
  final int deliveryFee;
  //평균 평점
  final double ratings;

  const RestaurantCard(
      {super.key,
      required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: image,
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            //join을 통해 리스트 요소들을 하나로 합친다
            //join의 파라미터에 값을 넣으면 요소 사이마다 해당 값을 넣어줌
            Text(
              tags.join(' · '),
              style: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _IconText(icon: Icons.star, lable: ratings.toString()),
                renderDot(),
                _IconText(icon: Icons.receipt, lable: ratingsCount.toString()),
                renderDot(),
                _IconText(
                    icon: Icons.timelapse_outlined, lable: '$deliveryTime분'),
                renderDot(),
                _IconText(
                    icon: Icons.monetization_on,
                    lable: deliveryFee == 0 ? '무료' : deliveryFee.toString()),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget renderDot() {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          '·',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ));
  }
}

//카드 아래의 평점 개수, 배달 시간, 배달료 등을 아이콘-텍스트의 쌍으로 표시하기 위한 위젯
class _IconText extends StatelessWidget {
  final IconData icon;
  final String lable;
  const _IconText({super.key, required this.icon, required this.lable});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          lable,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
