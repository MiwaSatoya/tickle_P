import java.util.*;
import processing.serial.*;  
import controlP5.*;

Serial myPortA;
Serial myPortB;
LineChart line_chartA;
LineChart line_chartB;
ControlP5 cp5;
int limit_t = 895;  // top of limit
int limit_b = 818;  // bottom of limit
int r_valA;  // resistance value mortorA
int r_valB;  // resistance value mortorB
int mortor = 1;  // 1:A, 2:B
color backColor = color(0);
boolean canMoveForward = true;
boolean canMoveReverse = true;
boolean start = false;
boolean stop = false;

void setup() {
  size(600, 600);  
  cp5 = new ControlP5(this);
  cp5.addSlider("limit_t").setPosition(20, 60).setSize(200, 15).setRange(0, 1023).setValue(limit_t);
  cp5.addSlider("limit_b").setPosition(20, 80).setSize(200, 15).setRange(0, 1023).setValue(limit_b);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  myPort.bufferUntil('\n');
  line_chartA = new LineChart(1024);
  line_chartB = new LineChart(1024);
}

void draw() {
  background(backColor, 100);

  draw_threshold();
  line_chartA.draw();
  line_chartB.draw();

  if (start) tickle();
  if (stop) {
    movingControlA();
    movingControlB();
    if (!canMoveForward) {
      if (limit_t < r_valA) {
        movingReverse();
      }
    } 
    else if (!canMoveReverse) {
      if (r_valA < limit_b) {
        movingForward();
      }
    } 
    else {
      movingStop();
    }
  }
}

void tickle() {
  if (r_valA < limit_b) movingForward();
  if (limit_t < r_valA) movingReverse();
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
  text(String.format("val = %d", r_valA), width - 120, height - 20);

  text("frameRate = " + frameRate, 20, height - 20);
}

void movingControlA() {
  if (limit_b <= r_valA && r_valA <= limit_t) {
    canMoveForward = true;
    canMoveReverse = true;
  }
  if (r_valA < limit_b) {
    canMoveForward = true;
    canMoveReverse = false;
  } 
  else if (limit_t < r_valA) {
    canMoveReverse = true;
    canMoveForward = false;
  }
}
void movingControlB() {
  if (limit_b <= r_valB && r_valB <= limit_t) {
    canMoveForward = true;
    canMoveReverse = true;
  }
  if (r_valB < limit_b) {
    canMoveForward = true;
    canMoveReverse = false;
  } 
  else if (limit_t < r_valB) {
    canMoveReverse = true;
    canMoveForward = false;
  }
  println(canMoveForward + " _ " + canMoveReverse);
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

void movingForwardB() {
  backColor = color(255, 0, 0);
  myPort.write(4);
  println("FOWARD");
}

void movingReverseB() {
  backColor = color(0, 0, 255);
  myPort.write(5);
  println("REVERSE");
}

void movingStopB() {
  backColor = color(0);
  myPort.write(3);
  println("STOP");
}

void keyPressed() {
  switch(keyCode) {
  case RIGHT:
    if (canMoveForward) {
      if (mortor == 1) movingForward();
      else if (mortor == 2) movingForwardB();
    }
    break;
  case LEFT:
    if (canMoveReverse) {
      if (mortor == 1) movingReverse();
      else if (mortor == 2) movingReverseB();
    }
    break;
  case ENTER:
    if (start) start = false;
    else start = true;
    break;
  case ' ':
    if (stop) stop = false;
    else stop = true;
    break;
  case UP:
    mortor = 2;
    break;
  case DOWN:
    mortor = 1;
    break;
  }
}

void keyReleased() {
  movingStop();
  movingStopB();
}

void serialEvent(Serial p) {
  while (myPort.available () > 0) {
    String l = myPort.readStringUntil('\n');
    l = trim(l);
    int value[] = int(split(l, ','));
    r_valA = value[0];
    r_valB = value[1];
    myPort.write("A");
    line_chartA.add(r_valA);
    line_chartB.add(r_valB);
    //println(r_valA+", "+r_valB);
  }
}

