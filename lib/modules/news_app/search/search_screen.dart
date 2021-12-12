import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/layout/news-app/cubit/cubit.dart';
import 'package:udemy_flutter/layout/news-app/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';

class SearchScreen extends StatelessWidget {
   SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener:(context, state) {},
        builder: (context ,state){

          var list = NewsCubit.get(context).search;
        return Scaffold(
            appBar: AppBar(
              title: Text(
                  'Search Screen'
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                    controller: searchController,
                    onChange: (value)
                    {
                      NewsCubit.get(context).getSearch(value);
                    },
                    type: TextInputType.text,
                    validate: (String? value)
                    {
                      if(value!.isEmpty){
                        return 'search must not be empty';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefix: Icons.search,
                  ),
                ),
                Expanded(child: articleBuilder(list, context,isSearch:true,),),
              ],
            ),
          );
        },
      ),
    );
  }
}
