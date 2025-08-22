 class HomeLayoutState {
  final int currentIndex;
  final bool isLoading;

  const HomeLayoutState({
    required this.currentIndex,
    required this.isLoading,
  });

  factory HomeLayoutState.initial() =>
      const HomeLayoutState(currentIndex: 0, isLoading: false);

  HomeLayoutState copyWith({
    int? currentIndex,
    bool? isLoading,
  }) {
    return HomeLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
