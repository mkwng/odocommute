
void calcHistogram() {
  histX = width-200;
  histY = 80;
  divSize = ceil(maxTravel/histDivs);
  
  for(Position position : employeePositions) {
    for(int i=0;i<histDivs;i++) {
      if(position.travelSecs > i*divSize && position.travelSecs <= (i+1)*divSize) divCount[i]++;
    }
  }
}

void displayHistogram(float x, float y) {
  
  float barWidth = 30;
  float barHeight = 4;
  
  strokeWeight(.5);
  line(x,y+3,x+(barWidth+1)*histDivs,y+3);
  
  for(int i=0;i<histDivs;i++) {
    noStroke();
    fill(255,80);
    rect(x+(barWidth+1)*(histDivs-i-1),y-divCount[i]*barHeight,barWidth,divCount[i]*barHeight);
    textAlign(CENTER,TOP);
    fill(255);
    text(i*divSize + "",x+(barWidth+1)*(histDivs-i-1)+barWidth/2,y+8);
  }
  float histoTime = constrain(map(time,maxTravel,0,0,(barWidth+1)*histDivs),0,(barWidth+1)*histDivs);
  strokeWeight(1);
  stroke(255);
  line(x+histoTime,y+5,x+histoTime,y-100);
}

void displayClock(float x, float y) {
  
  float minTime = max(time,0);
  
  int timeHour = 10 - ceil(minTime/60);
  int timeMinute = (60 - (int)minTime%60)%60;
  
  String timeFormatted = "" + timeHour + ":" + nf(timeMinute,2);
  
  
  fill(255,80);
  noStroke();
  ellipse(x,y,50,50);
   
  float timeHourRad = map(10-minTime/60,0,12,-PI/2,3*PI/2);
  float timeMinuteRad = map((600-((int)(minTime*10))%600)%600,0,600,-PI/2,3*PI/2);
  
  float hourX = cos(timeHourRad)*13;
  float hourY = sin(timeHourRad)*13;
  float minuteX = cos(timeMinuteRad)*23;
  float minuteY = sin(timeMinuteRad)*23;
  
  noFill();
  stroke(255);
  strokeWeight(1);
  strokeCap(ROUND);
  line(x,y,x+minuteX,y+minuteY);
  
  noFill();
  stroke(255);
  strokeWeight(2);
  strokeCap(ROUND);
  line(x,y,x+hourX,y+hourY);
  
  fill(255);
  noStroke();
  textAlign(CENTER,TOP);
  text(timeFormatted,x,y+35);
  
}
