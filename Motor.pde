class Mortor {
  Serial myPort;
  color backColor = color(0, 255, 0);
  int value;

  Mortor (Serial p) {
    myPort = p;
    myPort.clear();
    myPort.bufferUntil('\n');
  }
  
  void getData() {
  }

  void movingForward() {
    backColor = color(255, 0, 0);
    myPort.write(1);
    println("FOWARD");
  }

  void movingReverse() {
    backColor = color(0, 0, 255);
    myPort.write(2);
    println("REVERSE");
  }

  void movingStop() {
    backColor = color(0);
    myPort.write(0);
    println("STOP");
  }
}

