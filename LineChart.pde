public class LineChart {
  Vector vals = new Vector();
  color lineColor = color(0, 255, 0);
  boolean max = false;
  int max_size = 1024;

  public LineChart(int _size, color _c) {
    max_size = _size;
    lineColor = _c;
  }

  private int getSize() {
    if (vals.size() <= 0) return 0;
    else if (max_size <= vals.size()) return max_size-1;
    else return vals.size();
  }

  private int getValue() {
    if (vals.size() <= 0) return 0;
    if (max_size <= vals.size()) return ((Integer)vals.get(max_size-1)).intValue();
    else return ((Integer)vals.get(vals.size()-1)).intValue();
  }

  private int getValue(int idx) {
    if (idx <= 0) return 0;
    if (max_size <= idx) return ((Integer)vals.get(max_size-1)).intValue();
    else return ((Integer)vals.get(idx)).intValue();
  }

  private int getFluctuation() {
    int range = 10;
    int last = getSize()-1;
    if (last-range < 0) return 0;
    int fastValue = getValue(last-range);
    int lastValue = getValue(last);
    if (lastValue - fastValue > 0) return 1;
    else if (lastValue - fastValue < 0) return -1;
    else return 0;
  }

  private int getDirection() {
    int fast = getValue(getSize()-2);
    int last = getValue(getSize()-1);
    if (last-fast > 0) return 1;
    else if (last-fast < 0) return 2;
    else return 0;
  }

  private int getDirection(int idx) {
    int fast = getValue(idx-2);
    int last = getValue(idx-1);
    if (last-fast > 0) return 1;
    else if (last-fast < 0) return 2;
    else return 0;
  }

  private void addValue(int val) {
    vals.add(val);
    if (vals.size() > max_size) {
      vals.remove(0);
      vals.trimToSize();
      max = true;
    }
  }

  public void draw() {
    noFill();
    stroke(lineColor);
    rect(0, 50, width, height-100);
    
    final int h = height-50;
    final float step_x = width / (float)(max_size);
    final float step_y =  (h-50) / 1024.0;
    int size = getSize()-1;
    for (int i = 1; i < size; i++) {    
      float x0 = (i-1) * step_x;
      float x1 = (i  ) * step_x;
      float y0 = h - getValue(i-1) * step_y;
      float y1 = h - getValue(i  ) * step_y;
      line(x0, y0, x1, y1);
    }
  }
}

