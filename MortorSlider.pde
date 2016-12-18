public class MortorSlider {
  Serial myPort;
  LineChart lineChart;
  boolean canMoveForward = true;
  boolean canMoveReverse = true;

  public MortorSlider (PApplet parent, int _num, color _bColor) {
    lineChart = new LineChart(1024, _bColor);
    myPort = new Serial(parent, Serial.list()[_num], 57600);
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
      //println("FOWARD");
    }
  }

  public void movingReverse() {
    if (canMoveReverse) {
      myPort.write(2);
      //println("REVERSE");
    }
  }

  public void movingStop() {
    myPort.write(0);
    //println("STOP");
  }
}

