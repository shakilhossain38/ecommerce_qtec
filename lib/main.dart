import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppBlocObserver(),
  );
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class App extends StatelessWidget {
  /// {@macro app}
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsViewModel(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: const Center(child: Text("QTEC SOLUTIONS")),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              vm.add(GetProductList());
            },
          ),
        ],
      ),
    );
  }
}

class GetProductList {}

class ProductsViewModel extends Bloc<GetProductList, void> {
  static ProductsViewModel read(BuildContext context) =>
      context.read<ProductsViewModel>();
  static ProductsViewModel watch(BuildContext context) =>
      context.watch<ProductsViewModel>();
  ProductsViewModel() : super(0) {
    on<GetProductList>((event, emit) async {
      var response = await http.get(Uri.parse(
          "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=rice"));
      print("reponse body ${response.body}");
    });
    // on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}
