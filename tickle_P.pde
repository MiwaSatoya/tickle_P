import java.util.*;
import processing.serial.*;
import controlP5.*;

Serial portA;
Serial portB;
LineChart lineChartA;
LineChart lineChartB;
ControlP5 cp5;
Timer timer;
int limitTop = 895;  // top of limit
int limitBottom = 818;  // bottom of limit
int valA;  // resistance value mortorA
int valB;  // resistance value mortorB
int mortor = 0;  // 0:A, 1:B
int speed = 0;
color backColor = color(0);
color colorA = color(255, 0, 0);
color colorB = color(0, 0, 255);
boolean canMoveForward = true;
boolean canMoveReverse = true;
boolean start = false;
boolean stop = false;

void setup() {
  size(600, 600);

  println(Serial.list());
  portA = new Serial(this, Serial.list()[2], 9600);
  portB = new Serial(this, Serial.list()[1], 9600);
  portA.clear();
  portB.clear();
  portA.bufferUntil('\n');
  portB.bufferUntil('\n');

  lineChartA = new LineChart(1024, colorA);
  lineChartB = new LineChart(1024, colorB);

  cp5 = new ControlP5(this);
  cp5.addSlider("limitTop").setPosition(20, 60).setSize(200, 15).setRange(0, 1023).setValue(limitTop);
  cp5.addSlider("limitBottom").setPosition(20, 80).setSize(200, 15).setRange(0, 1023).setValue(limitBottom);
  cp5.addSlider("speed").setPosition(20, 100).setSize(200, 15).setRange(0, 255).setValue(speed);
  timer = new Timer(100);
}


void draw() {
  background(backColor, 100);

  drawThreshold();
  tickle();
  move();
}

void drawThreshold() {
  float _stepY = ((height-100) / 1024.0);
  float _top = (height-50) - limitTop * _stepY;
  float _bottom = (height-50) - limitBottom * _stepY;

  fill(0);
  stroke(0, 255, 0);
  rect(0, 50, width, height-100);

  stroke(255, 255, 0);
  line(0, _top, width, _top);
  line(0, _bottom, width, _bottom);

  fill(0, 255, 0);
  textSize(20);
  text(String.format("valA = %d", valA), 20, height - 20);
  text(String.format("valB = %d", valB), 150, height - 20);

  if (mortor == 0) {
    fill(colorA);
    text("operating mortorA", width-200, height-20);
  } 
  else if (mortor == 1) {
    fill(colorB);
    text("operating mortorB", width-200, height-20);
  }

  lineChartA.draw();
  lineChartB.draw();
}

void tickle() {
  if (start) {
    if (valA < limitBottom) movingForwardA();
    if (limitTop < valA) movingReverseA();
  }

  if (stop) {
    movingControlA();
    movingControlB();
    if (!canMoveForward) {
      if (limitTop < valA) {
        movingReverseA();
      }
    } 
    else if (!canMoveReverse) {
      if (valA < limitBottom) {
        movingForwardA();
      }
    } 
    else {
      movingStopA();
    }
  }
}

void move() {
  if (mortor == 0) {
    int fluctuation = lineChartA.getFluctuation();
    if (fluctuation == 1) {
      canMoveForward = true;
      canMoveReverse = false;
    }
    else if (fluctuation == -1) {
      canMoveForward = false;
      canMoveReverse = true;
    }
    else {
      movingStopB();
    }
    if (valB < valA) movingForwardB();
    else if (valA < valB) movingReverseB();
    else movingStopB();
    
    if(valB <= 0 || 1023 <=valB) movingStopB();
  }
}

void movingControlA() {
  if (limitBottom <= valA && valA <= limitTop) {
    canMoveForward = true;
    canMoveReverse = true;
  }
  if (valA < limitBottom) {
    canMoveForward = true;
    canMoveReverse = false;
  } 
  else if (limitTop < valA) {
    canMoveReverse = true;
    canMoveForward = false;
  }
}

void movingControlB() {
  if (limitBottom <= valB && valB <= limitTop) {
    canMoveForward = true;
    canMoveReverse = true;
  }
  if (valB < limitBottom) {
    canMoveForward = true;
    canMoveReverse = false;
  } 
  else if (limitTop < valB) {
  } 
  else if (limitTop < valA) {
    canMoveReverse = true;
    canMoveForward = false;
  }
}

void movingForwardA() {
  backColor = color(255, 0, 0);
  portA.write(1);
  println("FOWARD");
}

void movingReverseA() {
  backColor = color(0, 0, 255);
  portA.write(2);
  println("REVERSE");
}

void movingStopA() {
  backColor = color(0);
  portA.write(0);
  println("STOP");
}

void movingForwardB() {
  if(!canMoveForward) return;
  backColor = color(255, 0, 0);
  portB.write(1);
  //println("FOWARD");
}

void movingReverseB() {
  if(!canMoveReverse) return;
  backColor = color(0, 0, 255);
  portB.write(2);
  //println("REVERSE");
}

void movingStopB() {
  backColor = color(0);
  portB.write(0);
  //println("STOP");
}

void keyPressed() {
  switch(keyCode) {
  case RIGHT:
    if (canMoveForward) {
      if (mortor == 0) movingForwardA();
      else if (mortor == 1) movingForwardB();
    }
    break;
  case LEFT:
    if (canMoveReverse) {
      if (mortor == 0) movingReverseA();
      else if (mortor == 1) movingReverseB();
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
    mortor = 1;
    break;
  case DOWN:
    mortor = 0;
    break;
  }
}

void keyReleased() {
  movingStopA();
  movingStopB();
}

void serialEvent(Serial p) {
  if (p == portA) {
    while (portA.available () > 0) {
      String _l = portA.readStringUntil(10);
      if (_l == null) continue;
      _l = trim(_l);
      if (1024 < parseInt(_l)) continue;
      valA = parseInt(_l);
      lineChartA.add(valA);
    }
  } 
  else if (p == portB) {
    while (portB.available () > 0) {
      String _l = portB.readStringUntil(10);
      if (_l == null) continue;
      _l = trim(_l);
      if (1024 < parseInt(_l)) continue;
      valB = parseInt(_l);
      lineChartB.add(valB);
    }
  }
}

