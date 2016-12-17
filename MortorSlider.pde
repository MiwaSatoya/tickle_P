public class MortorSlider extends LineChart {
  Serial myPort;
  boolean canMoveForward = true;
  boolean canMoveReverse = true;
  color backColor = color(255);

  public MortorSlider (PApplet parent, int num, color bColor) {
    super(1024, bColor);

    myPort = new Serial(parent, Serial.list()[num], 115200);
    backColor = bColor;
  }

  private int getValue() {
    if (vals.size() <= 0) return 0;
    return getValue(getSize()-1);
  }

  public boolean isLimit(int val) {
    if (val < 0 || 1023 < val) return true;
    else return false;
  }

  public void setValue() {
    while (myPort.available () >= 3) {
      if (myPort.read() == 'H') {
        int high = myPort.read();
        int low = myPort.read();
        int val = high*256 + low;
        addValue(val);
      }
    }
  }

  public void movingControl(int num) {
    if (isLimit(getSize()-1)) {
      canMoveForward = false;
      canMoveReverse = false;
      movingStop();
    } 
    else {
      if (num == 1) {
        canMoveForward = true;
        canMoveReverse = false;
      } 
      else if (num == 2) {
        canMoveForward = false;
        canMoveReverse = true;
      }
      else movingStop();
    }
  }

  public void movingForward() {
    if (canMoveForward) {
      myPort.write(1);
      backColor = color(255, 0, 0);
      //println("FOWARD");
    }
  }

  public void movingReverse() {
    if (canMoveReverse) {
      myPort.write(2);
      backColor = color(0, 0, 255);
      //println("REVERSE");
    }
  }

  public void movingStop() {
    backColor = color(0);
    myPort.write(0);
    //println("STOP");
  }
}

