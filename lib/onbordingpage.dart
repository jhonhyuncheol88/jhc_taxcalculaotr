import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:jhc_provider_taxcalculator/homepage.dart';

//import on board me dependency

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntroScreen();
  }
}

class _IntroScreen extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    //this is a page decoration for intro screen
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w100,
          color: Colors.white), //tile font size, weight and color
      bodyTextStyle: TextStyle(fontSize: 19.0, color: Colors.white),
      //body text size and color

      //decription padding
      imagePadding: EdgeInsets.all(20), //image padding
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            0.3,
            0.7,
          ],
          colors: [
            Colors.greenAccent,
            Colors.lightGreenAccent,
            Colors.green,
          ],
        ),
      ), //show linear gradient background of page
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.green,
      //main background of screen
      pages: [
        //set your page view here
        PageViewModel(
          title: '부까 사용 안내',
          body: " 연매출 10억 이하 매장만 \n사용 권장합니다! \n "
              "\n  세금을 드라마틱 하게 줄여주는 \n계산기가 아닙니다.",
          image: Image.asset(
            'assets/image/001.png',
            fit: BoxFit.fill,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "계산된 예상 부가세와 실제 부가세가 차이나는 경우",
          body: ""
              "\n"
              "가.신용카드공제 23년 연말까지 \n1000만원 한도\n"
              "\n"
              "나.놓친 지출 증빙 자료가 있다.\n"
              "\n"
              "다.식자재 지출과 공산품 지출을 \n정확히 구분하지 않았다",
          image: Image.asset('assets/image/002.png'),
          decoration: pageDecoration,
        ),

        PageViewModel(
          title: "절세의 시작은 부가세입니다.",
          body: "\n"
              "사장님의 1년 부가세가 다음해의 종합소득세의 과세표준이 되며 종합소득세에 따라서 연금과 건강보험료가 측정됩니다.\n "
              "\n절세의 시작은 부가세!",
          image: Image.asset('assets/image/003.png'),
          decoration: pageDecoration,
        ),

        //add more screen here
      ],

      onDone: () => goHomepage(context), //go to home page on done
      onSkip: () => goHomepage(context), // You can override on skip
      showSkipButton: true,

      nextFlex: 0,
      skip: Text(
        'Skip',
        style: TextStyle(color: Colors.white),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: Text(
        'Getting Stated',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0), //size of dots
        color: Colors.white, //color of dots
        activeSize: Size(22.0, 10.0),
        //activeColor: Colors.white, //color of active dot
        activeShape: RoundedRectangleBorder(
          //shave of active dot
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  void goHomepage(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (Route<dynamic> route) => false);
    //Navigate to home page and remove the intro screen history
    //so that "Back" button wont work.
  }
}
