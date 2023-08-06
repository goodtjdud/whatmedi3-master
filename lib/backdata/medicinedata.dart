import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///이 페이지에서
///약 데이터 가져와서 searchpage에 넘겨주는 형식으로 작성될 거 같습니다.
class MedicineData extends StatelessWidget {
  MedicineData({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> data = [
    {
      "title": "타이레놀정 500 밀리그램",
      "corp": "주) 한국얀센",
      "ingredient": "아세트아미노펜",
      "effect": "1. 주효능·효과\n감기로 인한 발열 및 동통(통증), 두통, 신경통, 근육통, 월경통, 염좌통(삔 통증)\n2. 다음 질환에도 사용할 수 있다.\n치통, 관절통, 류마티양 동통(통증)",
      "usage": "만 12세 이상 소아 및 성인:\n1회 1~2정씩 1일 3-4회 (4-6시간 마다) 필요시 복용한다.\n1일 최대 4그램 (8정)을 초과하여 복용하지 않는다.\n이 약은 가능한 최단기간동안 최소 유효용량으로 복용한다.",
      "juyi": "모름"
    },
    {
      "title": "타이레놀정160밀리그램",
      "corp": "주) 한국얀센",
      "ingredient": "아세트아미노펜",
      "effect": "모름",
      "usage": "모름",
      "juyi": "모름"
    },
    {
      "title": "어린이타이레놀현탁액",
      "corp": "주) 한국얀센",
      "ingredient": "아세트아미노펜",
      "effect": "모름",
      "usage": "모름",
      "juyi": "모름"
    },
    {"title": "b", "corp": "b", "ingredient": "b", "effect": "ba", "usage": "b"},
    {"title": "a", "corp": "a", "ingredient": "a", "effect": "a", "usage": "a"},
    {"title": "a", "corp": "a", "ingredient": "a", "effect": "a", "usage": "a"},
    {"title": "a", "corp": "a", "ingredient": "a", "effect": "a", "usage": "a"},
    {"title": "a", "corp": "a", "ingredient": "a", "effect": "a", "usage": "a"}
  ];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}