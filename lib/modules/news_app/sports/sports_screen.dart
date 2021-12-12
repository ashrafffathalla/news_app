import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/layout/news-app/cubit/cubit.dart';
import 'package:udemy_flutter/layout/news-app/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';

class SportsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state){},
        builder: (context, state){
          var list =NewsCubit.get(context).sports;
          return articleBuilder(list,context);
        }
    );
  }
}