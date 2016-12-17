public class MortorSlider {
  Serial myPort;
  LineChart lineChart;
  boolean canMoveForward = true;
  boolean canMoveReverse = true;
  color backColor = color(255);

  public MortorSlider (PApplet parent, int _num, color _bColor) {
    myPort = new Serial(parent, Serial.list()[_num], 115200);
    lineChart = new LineChart(_num, _bColor);
    backColor = _bColor;
  }
  
  public int getDirection() {
    return lineChart.getDirection();
  }

  private int getValue() {
    return lineChart.getValue(lineChart.getSize()-1);
  }

  private boolean isLimit(int val) {
    if (val < 0 || 1023 < val) return true;
    else return false;
  }

  public void setValue() {
    while (myPort.available () >= 3) {
      if (myPort.read() == 'H') {
        int high = myPort.read();
        int low = myPort.read();
        int val = high*256 + low;
        lineChart.addValue(val);
      }
    }
  }

  public void movingControl(int num) {
    if (isLimit(lineChart.getSize()-1)) {
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
  
  public void draw() {
    lineChart.draw();
  }
}

