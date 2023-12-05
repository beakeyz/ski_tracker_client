
enum AppState {
  RUNNING,
  LOADING,
  REQUESTING,
  TRACKING
}

// singleton
class AppStateManager {

  static AppState state = AppState.RUNNING;

  static void setAppState(AppState state) {
    AppStateManager.state = state;
  }

  

}