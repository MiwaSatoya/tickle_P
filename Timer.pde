class Timer {
  int lastTime = 0;
  int limitTime = 0;
  boolean canCount = false;

  Timer(int lt) {
    limitTime = lt;
  }

  boolean isLimitTime() {
    if (canCount) {
      int time = millis() - lastTime;
      if (limitTime < time) {
        println("count: "+ limitTime + "ms");
        canCount = false;
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void startTimer() {
    lastTime = millis();
    canCount = true;
  }

  void reset() {
    lastTime = 0;
    canCount = false;
  }
}

