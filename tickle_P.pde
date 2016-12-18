import java.util.*;
import processing.serial.*;
import controlP5.*;
MortorSlider mortorA;
MortorSlider mortorB;
Timer timer;
int mortor = 0;  // 0:A, 1:B
int lastTimeA = 0;
int lastTimeB = 0;
final color colorA = color(255, 0, 0);
final color colorB = color(0, 0, 255);

void setup() {
  size(600, 600);

  println(Serial.list());
  mortorA = new MortorSlider(this, 3, colorA);
  mortorB = new MortorSlider(this, 1, colorB);
  timer = new Timer(100);
}


void draw() {
  background(0);
  
  drawGraph();
  move();
}

void drawGraph() {
  fill(0, 255, 0);
  textSize(20);
  text(String.format("valA = %d", mortorA.lineChart.getValue()), 20, height - 20);
  text(String.format("valB = %d", mortorB.lineChart.getValue()), 150, height - 20);
  if (mortor == 0) {
    fill(colorA);
    text("operating mortorA", width-200, height-20);
  } 
  else if (mortor == 1) {
    fill(colorB);
    text("operating mortorB", width-200, height-20);
  }
  mortorA.lineChart.draw();
  mortorB.lineChart.draw();
}

void move() {
  //lastTime = millis();
  //timer.startTimer(20);
  int valA = mortorA.lineChart.getValue(448);
  int valB = mortorB.lineChart.getValue();

  if (mortor == 0) {
    mortorB.movingControl(mortorA.lineChart.getDirection(448));
    if (valB < valA) mortorB.movingForward();
    else if (valA < valB) mortorB.movingReverse();
  }
  /*
  if (timer.isLimitTime()) {
    timer.reset();
  }
  print(millis()+" - " + lastTime + " = ");
  println(millis() - lastTime);
  */
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

int cntA = 0;
int cntB = 0;
void serialEvent(Serial p) {
  try {
    if (p == mortorA.myPort) {
      mortorA.setValue();
      cntA++;
      if(cntA == 576) {
        println("A " + (millis() - lastTimeA));
        lastTimeA = millis();
        cntA = 0;
      }
    } 
    else if (p == mortorB.myPort) {
      mortorB.setValue();
      cntB++;
      if(cntB == 576) {
        println("B " + (millis() - lastTimeB));
        lastTimeB = millis();
        cntB = 0;
      }
    }
  }
  catch(Exception e) {
    println("Error parsing:");
    e.printStackTrace();
  }
}

