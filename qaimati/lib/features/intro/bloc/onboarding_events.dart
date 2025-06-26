// class OnboardingEvents {}


abstract class OnboardingEvents {}

class PageChangedEvent extends OnboardingEvents {
  final int newIndex;
  PageChangedEvent(this.newIndex);
}

class NextPressedEvent extends OnboardingEvents {
  final int totalPages;
  NextPressedEvent(this.totalPages);
}
