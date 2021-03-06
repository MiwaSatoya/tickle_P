class Timer {
  int lastTime = 0;
  int limitTime = 0;
  boolean canCount = false;

  Timer(int _lt) {
    limitTime = _lt;
  }

  boolean isLimitTime() {
    if (canCount) {
      int time = millis() - lastTime;
      if (limitTime <= time) {
        println("count: "+ time + "ms");
        canCount = false;
        return true;
      } 
      else {
        return false;
      }
    }
    return false;
  }

  void startTimer(int lt) {
    if (!canCount) {
      limitTime = lt;
      lastTime = millis();
      canCount = true;
    }
  }

  void reset() {
    lastTime = 0;
    canCount = false;
  }
}

