import java.util.*;
import processing.serial.*;  
Serial myPort;
LineChart line_chart;

int limit_t = 10;  // top of limit
int limit_b = 9;  // bottom of limit
int r_val;  // resistance value
color backColor = color(0);
boolean canMoveForward = true;
boolean canMoveReverse = true;
boolean start = false;
boolean stopper = false;

void setup() {
  size(600, 600);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  line_chart = new LineChart(1024);
}

void draw() {
  readSerial();
  background(backColor, 100);

  draw_threshold();
  line_chart.draw();

  if (start) tickle();
  movingControl();
}

void tickle() {
  if (r_val < limit_b) movingForward();
  if (limit_t < r_val) movingReverse();
}

void draw_threshold() {
  int y_top = (height-50) - limit_t;
  int y_bottom = (height-50) - limit_b;

  fill(0);
  rect(0, 50, width, height-100);

  stroke(255, 255, 0);
  line(0, y_top, width, y_top);
  line(0, y_bottom, width, y_bottom);

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
  } else if (limit_t < r_val) {
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
  if (stopper) {
    if (r_val < limit_b || limit_t < r_val) {
      canMoveReverse = false;
      canMoveForward = false;
      movingStop();
      println("eiya");
    }
  }

  switch(keyCode) {
  case RIGHT:
    if (canMoveForward) movingForward();
    break;
  case LEFT:
    if (canMoveReverse) movingReverse();
    break;
  }
  stopper = true;
  
  if(keyCode == ENTER) start = true;
  else if(keyCode == DELETE) start = false;

  /*
  if (!start) {
   movingControl();
   
   switch(keyCode) {
   case RIGHT:
   if (canMoveForward) movingForward();
   break;
   case LEFT:
   if (canMoveReverse) movingReverse();
   break;
   case DOWN:
   movingStop();
   println("STOP");
   break;
   case ENTER:
   start = true;
   break;
   }
   } else {
   switch(keyCode) {
   case ENTER:
   start = true;
   movingForward();
   break;
   }
   start = false;
   movingStop();
   }
   */
}

void keyReleased() {
  movingStop();
  stopper = false;
}

void readSerial() {
  while (myPort.available() > 0) {
    String l = myPort.readStringUntil(10);
    if (l == null) continue;
    l = trim(l);
    if (1024 < parseInt(l)) continue;
    else r_val = parseInt(l);

    line_chart.add(r_val);
    //println("r_val = "+r_val);
  }
}