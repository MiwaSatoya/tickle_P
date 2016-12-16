import java.util.*;
import processing.serial.*;
import controlP5.*;
MortorSlider mortorA;
MortorSlider mortorB;
ControlP5 cp5;
Timer timer;
int mortor = 0;  // 0:A, 1:B
final color colorA = color(255, 0, 0);
final color colorB = color(0, 0, 255);

void setup() {
  size(600, 600);

  println(Serial.list());
  mortorA = new MortorSlider(this, 2, colorA);
  mortorB = new MortorSlider(this, 1, colorB);
}


void draw() {
  background(0);

  drawThreshold();
  move();
}

void drawThreshold() {
  noFill();
  stroke(0, 255, 0);
  rect(0, 50, width, height-100);

  fill(0, 255, 0);
  textSize(20);
  text(String.format("valA = %d", mortorA.getValue()), 20, height - 20);
  text(String.format("valB = %d", mortorB.getValue()), 150, height - 20);
  if (mortor == 0) {
    fill(colorA);
    text("operating mortorA", width-200, height-20);
  } 
  else if (mortor == 1) {
    fill(colorB);
    text("operating mortorB", width-200, height-20);
  }
  mortorA.draw();
  mortorB.draw();
}


void move() {
  int valA = mortorA.getValue();
  int valB = mortorB.getValue();

  if (mortor == 0) {
    int dir = mortorA.getDirection();
    mortorB.movingControl(dir);
    
    if (valB < valA) mortorB.movingForward();
    else if (valA < valB) mortorB.movingReverse();
  }
}

void keyPressed() {
  switch(keyCode) {
  case RIGHT:
    if (mortor == 0) mortorA.movingForward();
    else if (mortor == 1) mortorB.movingForward();
    break;
  case LEFT:
    if (mortor == 0) mortorA.movingReverse();
    else if (mortor == 1) mortorB.movingReverse();
    break;
  case UP:
    mortor = 1;
    break;
  case DOWN:
    mortor = 0;
    break;
  }
}

void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    if (mortor == 0) mortorA.movingStop();
    else if (mortor == 1) mortorB.movingStop();
  }
}

void serialEvent(Serial p) {
  try {
    if (p == mortorA.myPort) {
      mortorA.setValue();
    } 
    else if (p == mortorB.myPort) {
      mortorB.setValue();
    }
  }
  catch(Exception e) {
    println("Error parsing:");
    e.printStackTrace();
    noLoop();
  }
}

