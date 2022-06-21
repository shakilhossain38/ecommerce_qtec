import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home_screen/view_model/counter_bloc.dart';
import 'features/home_screen/view_model/home_view_model.dart';
import 'features/home_screen/views/home_screen.dart';

class EcommerceQtecInit extends StatelessWidget {
  const EcommerceQtecInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var providers = [
    //   BlocProvider<CounterBloc>(
    //     create: (BuildContext context) => CounterBloc(),
    //   ),
    //   BlocProvider<ProductsViewModel>(
    //     create: (BuildContext context) => ProductsViewModel(),
    //   ),
    // ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => CounterBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ProductsViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: const HomeScreen(),
      ),
    );
  }
}
