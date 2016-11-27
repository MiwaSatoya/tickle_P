class Mortor {
  Serial myPort;
  color backColor = color(0, 255, 0);

  Mortor (Serial p) {
    myPort = p;
    myPort.clear();
    myPort.bufferUntil('\n');
  }
  
  void getData() {
  }

  void movingForward() {
    backColor = color(255, 0, 0);
    portA.write(1);
    println("FOWARD");
  }

  void movingReverse() {
    backColor = color(0, 0, 255);
    portA.write(2);
    println("REVERSE");
  }

  void movingStop() {
    backColor = color(0);
    portA.write(0);
    println("STOP");
  }
}

