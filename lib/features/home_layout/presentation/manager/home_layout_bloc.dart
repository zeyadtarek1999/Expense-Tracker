 import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_layout_event.dart';
import 'home_layout_state.dart';

class HomeLayoutBloc extends Bloc<HomeLayoutEvent, HomeLayoutState> {
  HomeLayoutBloc() : super(HomeLayoutState.initial()) {
    on<InitLayoutEvent>((event, emit) {});
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
    on<CenterActionPressed>((event, emit) {


    });
  }
}
