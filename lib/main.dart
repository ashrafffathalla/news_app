
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:udemy_flutter/layout/news-app/news_layout.dart';
import 'package:udemy_flutter/modules/news_app/home_layout.dart';
import 'package:udemy_flutter/modules/bmi-app/bmi_result/bmi_result_screen.dart';
import 'package:udemy_flutter/modules/bmi-app/bmi/bmi_screen.dart';
import 'package:udemy_flutter/modules/bmi-app/bmi_result/bmi_result_screen.dart';
import 'package:udemy_flutter/modules/counter-app/counter/counter.dart';
import 'package:udemy_flutter/modules/counter-app/counter/cubit/cubit.dart';
import 'package:udemy_flutter/modules/counter-app/counter/states.dart';
import 'package:udemy_flutter/modules/basics-app/home/home.dart';
import 'package:udemy_flutter/modules/basics-app/login/loginscreen.dart';
import 'package:udemy_flutter/modules/basics-app/messenger/messenger_screen.dart';
import 'package:udemy_flutter/modules/basics-app/users/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:udemy_flutter/modules/shop_app/on_boarding/onboarding_screen.dart';
import 'package:udemy_flutter/shared/bloc_observe.dart';
import 'package:udemy_flutter/layout/news-app/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';
import 'package:udemy_flutter/shared/styles/themes.dart';
void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
    bool? isDark = CacheHelper.getData(key:'isDark');

  runApp( MyApp(
      isDark!
  ));
}
//  stateless
//  Stateful

// class MyAPP
class MyApp extends StatelessWidget

{

    MyApp(this.isDark,{Key? key}) : super(key: key);
    bool? isDark;
  @override

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context)=>NewsCubit()..getBusiness()..getSports()..getScience(),
        ),
    BlocProvider(
    create: (BuildContext context) =>AppCubit()..changeAppMode(
    fromShared: isDark!,
    ),
    ),
      ],

        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state){},
          builder: (context, state){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode:AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light ,
              home: Directionality(
                  textDirection: TextDirection.ltr,
                  child: OnBoardingScreen()),
            );
          },
        ),
      );

  }
  }

