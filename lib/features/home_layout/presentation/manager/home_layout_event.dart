 abstract class HomeLayoutEvent {}

class InitLayoutEvent extends HomeLayoutEvent {}

class ChangeTabEvent extends HomeLayoutEvent {
  final int index;
  ChangeTabEvent(this.index);
}

class CenterActionPressed extends HomeLayoutEvent {}
