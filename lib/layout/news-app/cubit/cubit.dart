import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/layout/news-app/cubit/states.dart';
import 'package:udemy_flutter/modules/news_app/business/business_screen.dart';
import 'package:udemy_flutter/modules/news_app/scince/scince_screen.dart';
import 'package:udemy_flutter/modules/news_app/sports/sports_screen.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewInitialStates());
  static NewsCubit get(context) => BlocProvider.of(context);
// Start List BottomNavigationBar
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems =
  [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.business,

      ),
      label:'Business',
    ),
    const BottomNavigationBarItem(
       icon: Icon(
         Icons.sports,
       ),
       label:'Sports',
     ),
     const BottomNavigationBarItem(
       icon: Icon(
         Icons.science,
       ),
       label:'Science',
     ),

    // BottomNavigationBarItem(),
  ];
  //Start Body Screens List
  List<Widget>screens =
  [
      BusinessScreen(),
      SportsScreen(),
      ScienceScreen(),

  ];
  void changeBottomNavBar( int index)
  {
  currentIndex = index;
  if(index == 1)
      getSports();
  if(index == 2)
    getScience();

  emit(NewBottomNavStates());
  }
// start business
  List<dynamic> business = [];
  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'business',
          'apiKey':'2184d6ee1b864e7c955f5aa3e2ef0308',
        }
    ).then(((value){
     // print(value.data['articles'][2]['title']);
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }),
    ).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));

    });
  }
// end business

  // start Sports
  List<dynamic> sports = [];
  void getSports()
  {
    emit(NewsGetSportsLoadingState());
    if(sports.length == 0)
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sports',
            'apiKey':'2184d6ee1b864e7c955f5aa3e2ef0308',
          }
      ).then(((value){
        // print(value.data['articles'][2]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }),
      ).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));

      });
    }
    else{
      emit(NewsGetSportsSuccessState());
    }
  }
  // end Sports

  // start science
  List<dynamic> science = [];
  void getScience()
  {
    emit(NewsGetScienceLoadingState());
    if(science.length == 0)
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apiKey':'2184d6ee1b864e7c955f5aa3e2ef0308',
          }
      ).then(((value){
        // print(value.data['articles'][2]['title']);
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }),
      ).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));

      });
    }
    else {
     emit( NewsGetScienceSuccessState());
    }
  }
// End science
//Start Search List
List<dynamic> search = [];
  void getSearch(String value)
  {
search =[];
emit(NewsGetSearchLoadingStat());
DioHelper.getData(
    url: 'v2/everything',
    query: {

      'q':'$value',
      'apiKey':'2184d6ee1b864e7c955f5aa3e2ef0308',
    }
).then(((value){
  // print(value.data['articles'][2]['title']);
  search = value.data['articles'];
  print(search[0]['title']);
  emit(NewsGetSearchStat());
}),
).catchError((error){
  print(error.toString());
  emit(NewsGetSearchErrorState(error.toString()));

});
  }
//End Search List
}