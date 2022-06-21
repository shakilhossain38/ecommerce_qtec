import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterEvent {}

class CounterIncrementPressed extends CounterEvent {}

class CartIndex extends CounterEvent {
  int index;
  CartIndex({this.index = -1});
}

class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  static CounterBloc read(BuildContext context) => context.read<CounterBloc>();
  static CounterBloc watch(BuildContext context) =>
      context.watch<CounterBloc>();
  int _index = -1;
  int get index => _index;
  set index(int? i) {
    _index = i!;
  }

  CounterBloc() : super(0) {
    on<CartIndex>((event, emit) {
      _index = event.index;
      emit(event.index);
    });
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}
