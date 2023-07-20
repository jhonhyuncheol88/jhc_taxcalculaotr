import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'model.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:hive/hive.dart';
import 'onbordingpage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //텍스트 필드 클릭하면 화면이 올라가는 값을 저장 하는 변수
  ScrollController _scrollController = ScrollController();
  //배너 광고 코드, 화면에 맞는 코드 짜게 하기
  BannerAd? banner;

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            banner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return banner!.load();
  }

  var mybox = Hive.box('box');

  bool click = false; //계산 버튼 애니메이션

  //Datetime yy-mm--dd

  var comma = NumberFormat('###,### 원'); // 콤마 찍는 변수 선언

  //뉴모피즘 변수값
  double off1 = -2.0;
  double off2 = 2.0;
  double blurR = 2.0;
  double spredR = 2.0;

  var incomeController = TextEditingController(); //수입
  var spendingfoodController = TextEditingController(); // 식자재 지출
  var spendingproductController = TextEditingController(); //공산품 지출

//2023년 신용카드 공제 한도값
  double overcreditcardHelp = 10000000;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void initState() {
    if (mybox.get('tax') == null) {
      context.read<Taxsave>().estimateTaxsave = 0;
    } else {
      context.read<Taxsave>().estimateTaxsave = mybox.get('tax');
      context.read<Taxsave>().today = mybox.get('taxtime');
      context.read<Taxsave>().taxincomesave = mybox.get('taxincome');
      context.read<Taxsave>().spendingFoodsave = mybox.get('spendingfood');
      context.read<Taxsave>().spendingProuctsave = mybox.get('spendingproduct');
    }

    incomeController = TextEditingController();
    spendingfoodController = TextEditingController();
    spendingproductController = TextEditingController();

    _scrollController = ScrollController();

    // banner = BannerAd(

    //
    //  size: AdSize(width: 728, height: 90),
    //  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    // listener: BannerAdListener(),
    //  request: AdRequest())
    //..load();

    super.initState();
  }

  @override
  void dispose() {
    incomeController.dispose();
    spendingfoodController.dispose();
    spendingproductController.dispose();
    banner?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

// 기존 데이터 조회 가능 하게 하는 알럿 다이얼로그

  void beforeData() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
                  child: Text(
                '저장 된 부가세 내역 ',
                style: TextStyle(fontSize: ScreenUtil().setSp(20)),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '날  짜',
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Text(
                        (context.read<Taxsave>().today),
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '매  출',
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Text(
                        comma.format(context.read<Taxsave>().taxincomesave),
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '지출1',
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Text(
                        comma.format(context.read<Taxsave>().spendingFoodsave),
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '지출2',
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Center(
                        child: Text(
                          comma.format(
                              context.read<Taxsave>().spendingProuctsave),
                          style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '부가세',
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Text(
                        comma.format(context.read<Taxsave>().estimateTaxsave),
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      )
                    ],
                  ),
                ],
              ));
        });
  }

  //1.콤마를 추가하면서 문자가 된 숫자 값을 replaceAll을 이용해 콤마를 제거해준다.
  //2. 콤마를 제거한 숫자 값을 double.parse로 변환해준다.
  //3. double로 된 숫자 값을 해당 변수에 넣어주고 계산식을 적용한다.
  //4. flutter가 업그레이드 되면서 try catch = error처리를 해줘야 하는 것 같다.

  void convertStringToDouble() {
    try {
      var t1text = incomeController.text;
      var t1convert = t1text.replaceAll(",", "");
      var income = double.parse(t1convert);

      var t2text = spendingfoodController.text;
      var t2convert = t2text.replaceAll(",", "");
      var spendingFood = double.parse(t2convert);

      var t3text = spendingproductController.text;
      var t3convert = t3text.replaceAll(",", "");
      var spendingProduct = double.parse(t3convert);

      context.read<Tax>().taxincome = income * 1 / 10;
      context.read<Tax>().spendingFoodHelp = spendingFood * 9 / 109;
      context.read<Tax>().taxspending = spendingProduct * 1 / 10;
      context.read<Tax>().creditcardHelp = income * 13 / 1000;

      // 신용카드공제, 의제매입공제 조건식
      if (context.read<Tax>().creditcardHelp > 10000000) {
        context.read<Tax>().creditcardHelp = 10000000;
      }

      context.read<Tax>().estimateTax = context.read<Tax>().taxincome -
          context.read<Tax>().taxspending -
          context.read<Tax>().creditcardHelp -
          context.read<Tax>().spendingFoodHelp;

      context.read<Taxsave>().estimateTaxsave = context.read<Tax>().taxincome -
          context.read<Tax>().taxspending -
          context.read<Tax>().creditcardHelp -
          context.read<Tax>().spendingFoodHelp;

      context.read<Taxsave>().taxincomesave = double.parse(t1convert);
      context.read<Taxsave>().spendingFoodsave = double.parse(t2convert);
      context.read<Taxsave>().spendingProuctsave = double.parse(t3convert);
    } catch (e) {
      print("Error occurred while converting string to double: $e");
    }

    //
    //
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green,
        body: GestureDetector(
          onTap: () {
            setState(() {
              FocusScope.of(context).unfocus();
            });
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(5)),
                Center(
                  child: Container(
                    width: ScreenUtil().setWidth(350),
                    height: ScreenUtil().setHeight(50),
                    child: Image.asset('assets/image/title1.png'),
                  ),
                ),
                Container(
                  child: this.banner == null
                      ? Container()
                      : Container(
                          color: Colors.green,
                          width: banner!.size.width.toDouble(),
                          height: banner!.size.height.toDouble(),
                          child: AdWidget(ad: banner!)),
                  width: ScreenUtil().setWidth(double.infinity),
                  height: ScreenUtil().setHeight(80),
                  color: Colors.green,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: () {
                          //도움말 코드

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroScreen()),
                          );
                        },
                        child: Text(
                          '도움말',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(12)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {});
                          context.read<Tax>().reset();
                          incomeController.clear();
                          spendingfoodController.clear();
                          spendingproductController.clear();
                        },
                        child: Text(
                          '초기화',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(12)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(7),
                          ),
                          Text(
                            '매출',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(10),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(6),
                          ),
                          Text(
                            '카드,배달,현금영수증',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(9),
                                color: Colors.white),
                          ),
                        ],
                      ),
                      width: ScreenUtil().setWidth(140),
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: TextField(
                        maxLength: 11,
                        controller: incomeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        inputFormatters: [ThousandsFormatter()],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.white70),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.white70)),
                            suffixIcon: IconButton(
                                onPressed: incomeController.clear,
                                icon: Icon(
                                  Icons.clear,
                                  size: ScreenUtil().setSp(15),
                                  color: Colors.white70,
                                )),
                            counterText: "",
                            hintText: ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(7),
                          ),
                          Text(
                            '지출1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(10),
                                color: Colors.white),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '농축산물,식자재,면세물품',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(9),
                                color: Colors.white),
                          ),
                        ],
                      ),
                      width: ScreenUtil().setWidth(140),
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: TextField(
                        onTap: () {
                          _scrollController.animateTo(120.0,
                              //텍스트필드 클릭하면 스크롤을 올려줌 -> 계산기 버튼이 잘 보일 수 있게 하기
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        maxLength: 11,
                        controller: spendingfoodController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        inputFormatters: [ThousandsFormatter()],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.white70),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.white70)),
                            suffixIcon: IconButton(
                                onPressed: spendingfoodController.clear,
                                icon: Icon(
                                  Icons.clear,
                                  size: ScreenUtil().setSp(15),
                                  color: Colors.white70,
                                )),
                            counterText: "",
                            hintText: ''),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),
                          Text(
                            '지출2',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(10),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(6),
                          ),
                          Text(
                            '공산품,배달대행,광고,월세',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(9),
                                color: Colors.white),
                          ),
                        ],
                      ),
                      width: ScreenUtil().setWidth(140),
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: TextField(
                        onTap: () {},
                        maxLength: 11,
                        controller: spendingproductController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        inputFormatters: [ThousandsFormatter()],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.white70),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.white70)),
                            suffixIcon: IconButton(
                                onPressed: spendingproductController.clear,
                                icon: Icon(
                                  Icons.clear,
                                  size: ScreenUtil().setSp(15),
                                  color: Colors.white70,
                                )),
                            counterText: "",
                            hintText: ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        beforeData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8)),
                        width: ScreenUtil().setWidth(250),
                        height: ScreenUtil().setHeight(75),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(180),
                                height: ScreenUtil().setHeight(70),
                                child: Column(children: [
                                  Text(
                                    '클릭하면 세부내역 확인가능',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(8)),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(5),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '계산 한 날짜',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10)),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(30),
                                      ),
                                      Text('예상 부가세',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(10))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(5),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          context.read<Taxsave>().today == ""
                                              ? "날짜"
                                              : context.read<Taxsave>().today,
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(10))),
                                      Text(
                                        comma.format(context
                                            .read<Taxsave>()
                                            .estimateTaxsave),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(10),
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
//클릭 함수
                        click = !click;
                        // 텍스트 필드의 값이 비어있으면 날짜는 기존 데이터의 저장 된 값으로 쓰고
                        // 아니면 현재 날짜를 저장하게 함

                        var today1 = context.read<Taxsave>().today;

                        if (incomeController.text.isEmpty &&
                            spendingfoodController.text.isEmpty &&
                            spendingproductController.text.isEmpty) {
                          setState(() {});
                          context.read<Taxsave>().today = today1;
                        } else {
                          setState(() {
                            convertStringToDouble();
                            context.read<Taxsave>().today =
                                DateFormat('yy년 MM월 dd일')
                                    .format(DateTime.now());

                            mybox.put('taxtime', context.read<Taxsave>().today);

                            mybox.put(
                                'tax', context.read<Taxsave>().estimateTaxsave);

                            mybox.put('taxincome',
                                context.read<Taxsave>().taxincomesave);
                            mybox.put('spendingfood',
                                context.read<Taxsave>().spendingFoodsave);
                            mybox.put('spendingproduct',
                                context.read<Taxsave>().spendingProuctsave);

                            FocusScope.of(context).unfocus(); //키보드 내리는 함수
                          });
                        }
                      },
                      child: AnimatedContainer(
                          child: Icon(
                            Icons.currency_exchange_sharp,
                            color: Colors.green,
                            size: ScreenUtil().setSp(50),
                          ),
                          height: ScreenUtil().setHeight(70),
                          width: ScreenUtil().setWidth(70),
                          duration: Duration(milliseconds: 1),
                          curve: Curves.easeInBack,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen[200],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: click
                                  ? null
                                  : [
                                      BoxShadow(
                                        offset: Offset(off2, off2),
                                        color: Colors.black38,
                                        blurRadius: blurR,
                                        spreadRadius: spredR,
                                      ),
                                      BoxShadow(
                                        offset: Offset(off1, off1),
                                        color: Colors.white70,
                                        blurRadius: blurR,
                                        spreadRadius: spredR,
                                      )
                                    ])),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: ScreenUtil().setWidth(340),
                  height: ScreenUtil().setHeight(190),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[200],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(off2, off2),
                        color: Colors.black38,
                        blurRadius: blurR,
                        spreadRadius: spredR,
                      ),
                      BoxShadow(
                        offset: Offset(off1, off1),
                        color: Colors.white70,
                        blurRadius: blurR,
                        spreadRadius: spredR,
                      )
                    ],
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(110),
                          child: Text(
                            '매출 과세표준',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            width: ScreenUtil().setWidth(120),
                            height: ScreenUtil().setHeight(20),
                            child: Text(
                              comma.format(context.read<Tax>().taxincome),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black54),
                              textAlign: TextAlign.end,
                            )), //taxincome
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(110),
                          child: Text(
                            '지출 과세표준',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            width: ScreenUtil().setWidth(120),
                            height: ScreenUtil().setHeight(20),
                            child: Text(
                              comma.format(context.read<Tax>().taxspending),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black54),
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(110),
                          child: Text(
                            '신용카드공제',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            width: ScreenUtil().setWidth(120),
                            height: ScreenUtil().setHeight(20),
                            child: Text(
                              comma.format(context.read<Tax>().creditcardHelp),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black54),
                              textAlign: TextAlign.end,
                            )),
                        //신용카드 공제 매출의 1.3%
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(110),
                          child: Text(
                            '의제매입공제',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            width: ScreenUtil().setWidth(120),
                            height: ScreenUtil().setHeight(20),
                            child: Text(
                              comma
                                  .format(context.read<Tax>().spendingFoodHelp),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black54),
                              textAlign: TextAlign.end,
                            )),
                        //의제매입공제 식자재 매출의 2억미만 8.26% , 2억 초과 7.24%
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(110),
                          child: Text(
                            '예상 부가세',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            width: ScreenUtil().setWidth(120),
                            height: ScreenUtil().setHeight(20),
                            child: Text(
                              comma.format(context.read<Tax>().estimateTax),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(12),
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
