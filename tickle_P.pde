import java.util.*;
import processing.serial.*;  
import controlP5.*;

Serial myPort;
LineChart line_chart;
ControlP5 cp5;
int limit_t = 895;  // top of limit
int limit_b = 818;  // bottom of limit
int r_val;  // resistance value
color backColor = color(0);
boolean canMoveForward = true;
boolean canMoveReverse = true;
boolean start = false;

void setup() {
  size(600, 600);  
  cp5 = new ControlP5(this);
  cp5.addSlider("limit_t").setPosition(20, 60).setSize(200, 15).setRange(0, 1023).setValue(limit_t);
  cp5.addSlider("limit_b").setPosition(20, 80).setSize(200, 15).setRange(0, 1023).setValue(limit_b);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  line_chart = new LineChart(1024);
}

void draw() {
  readSerial();
  background(backColor, 100);

  draw_threshold();
  line_chart.draw();

  if (start) tickle();
}

void tickle() {
  if (r_val < limit_b) movingForward();
  if (limit_t < r_val) movingReverse();
}

void draw_threshold() {
  int y_t = (height-50) - int(limit_t/1024.0 * (height-100));
  int y_b = (height-50) - int(limit_b/1024.0 * (height-100));

  fill(0);
  rect(0, 50, width, height-100);

  stroke(255, 255, 0);
  line(0, y_t, width, y_t);
  line(0, y_b, width, y_b);

  fill(0, 255, 0);
  textSize(20);
  text(String.format("val = %d", r_val), width - 120, height - 20);

  text("frameRate = " + frameRate, 20, height - 20);
}

void movingControl() {
  if (limit_b <= r_val && r_val <= limit_t) {
    canMoveForward = true;
    canMoveReverse = true;
  }
  if (r_val < limit_b) {
    canMoveForward = true;
    canMoveReverse = false;
  } 
  else if (limit_t < r_val) {
    canMoveReverse = true;
    canMoveForward = false;
  }
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

void keyPressed() {
  if (r_val < limit_b || limit_t < r_val) {
    movingStop();
    println("STOP");
  }

  switch(keyCode) {
  case RIGHT:
    if (canMoveForward) movingForward();
    break;
  case LEFT:
    if (canMoveReverse) movingReverse();
    break;
  case ENTER:
    start = true;
    break;
  case DELETE:
    start = false;
    break;
  }
}

void keyReleased() {
  movingStop();
}

void readSerial() {
  while (myPort.available () > 0) {
    String l = myPort.readStringUntil(10);
    if (l == null) continue;
    l = trim(l);
    if (1024 < parseInt(l)) continue;
    else r_val = parseInt(l);

    line_chart.add(r_val);
    //println("r_val = "+r_val);
  }
}

