class LineChart {
  Vector vals = new Vector();
  int max_size = 1024;
  boolean max = false;
  color lineColor = color(0, 255, 0);

  LineChart(int _size, color _c) {
    max_size = _size;
    lineColor = _c;
  }

  int get(int idx) {
    return ((Integer)vals.get(idx)).intValue();
  }

  void add(int val) {
    vals.add(val);
    if (vals.size() > max_size) {
      vals.remove(0);
      vals.trimToSize();
      max = true;
    }
  }
  
  int getFluctuation() {
    int range = 10;
    int last = (Integer)vals.size()-2;
    if(last-range < 0) return 0;
    int lastValue = (Integer)vals.get(last);
    int fastValue = (Integer)vals.get(last-range);
    if(lastValue - fastValue > 10) return 1;
    else if(lastValue - fastValue < -10) return -1;
    else return 0;
  }

  void draw() {
    noFill();
    stroke(lineColor);
    float step_x = width / (float)(max_size);
    float step_y =  ((height-100) / 1024.0);
    for (int i = 0; i < vals.size () - 1; ++i) {    
      float x0 = (i  ) * step_x;
      float x1 = (i+1) * step_x;
      float y0 = (height-50) - ((Integer)vals.get(i  )).intValue() * step_y;
      float y1 = (height-50) - ((Integer)vals.get(i+1)).intValue() * step_y;
      line(x0, y0, x1, y1);
    }
  }

  int max_val(int n) {
    int max_val = 0;
    int st = vals.size() - n;
    if (st < 0) st = 0;
    int et = vals.size() - 1;
    for (int i = st; i <= et; ++i) {
      int v = (Integer)vals.get(i);
      if (v > max_val) max_val = v;
    }
    return max_val;
  }
}
