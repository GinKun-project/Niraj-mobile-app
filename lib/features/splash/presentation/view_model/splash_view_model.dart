class SplashViewModel {
  // You can expand this for token check, first-time launch, etc.
  Future<bool> shouldNavigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}
