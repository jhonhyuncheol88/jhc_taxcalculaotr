import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jhc_provider_taxcalculator/homepage.dart';
import 'package:jhc_provider_taxcalculator/model.dart';

import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('box');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(390, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => Tax(
                      taxincome: 0,
                      spendingFoodHelp: 0,
                      estimateTax: 0,
                      creditcardHelp: 0,
                      taxspending: 0)),
              ChangeNotifierProvider(
                  create: (_) => Taxsave(
                      estimateTaxsave: 0,
                      spendingFoodsave: 0,
                      spendingProuctsave: 0,
                      taxincomesave: 0,
                      today: ""))
            ],
            child: MaterialApp(
              theme: ThemeData(primaryColor: Colors.green, useMaterial3: true),
              debugShowCheckedModeBanner: false,
              home: HomePage(),
            ),
          );
        });
  }
}
