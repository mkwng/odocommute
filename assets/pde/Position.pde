
class Position {

  String name;
  float lon,lat;
  float x,y;
  int travelSecs;
  
  float drawSize;
  
  int startColor = color(91,0,0);
  int activeColor = color(233,0,0);
  int flashColor = color(254,245,121);
  int pathColor = color(255);
  
  Position(String name, float lon, float lat, int travelSecs) {
    this.name = name;
    this.travelSecs = travelSecs;
    this.lon = lon;
    this.lat = lat;
    
    this.drawSize = 0;
  }
  
  void calcXY() {
    // scale the x (longitude) to fit the screen:
    float x = (this.lon - minLon) * sc + paddingLeft;
    // flip latitude because it runs from bottom-to-top,
    // ... but Processing's y-axis is from top-to-bottom
    float y = ((float(height)-paddingTop-paddingBottom)-((this.lat - minLat)) * sc + paddingBottom);
    
    this.x = x;
    this.y = y;
  }
  
  void drawPosition() {
    ellipse(x, y, 4, 4);
  }
  
  void drawPath(float progress) {
    stroke(this.pathColor);
    strokeWeight(.5);
    strokeCap(SQUARE);
    float xNew = 0; float yNew = 0;
    if(this.x >= odopod.x) {
      if(this.y >= odopod.y) yNew = this.y - abs(odopod.y - this.y) * progress;
      if(this.y < odopod.y) yNew = this.y + abs(odopod.y - this.y) * progress;
      xNew = this.x - abs(odopod.x - this.x) * progress;
    }
    if(this.x < odopod.x) {
      if(this.y >= odopod.y) yNew = this.y - abs(odopod.y - this.y) * progress;
      if(this.y < odopod.y) yNew = this.y + abs(odopod.y - this.y) * progress;
      xNew = this.x + abs(odopod.x - this.x) * progress;
    }
    line(this.x,this.y,xNew,yNew);
    line(this.x,this.y,xNew,yNew);
    line(this.x,this.y,xNew,yNew);
    line(this.x,this.y,xNew,yNew);
  }
  
  void drawStart() {
    fill(this.activeColor,map(constrain(drawSize,0,50),50,0,0,80));
    stroke(255,map(constrain(drawSize,0,25),25,0,5,20));
    strokeWeight(0.5);
    ellipse(this.x,this.y,max(this.drawSize,0),max(this.drawSize,0));
    
    if(time<=this.travelSecs) fill(this.activeColor);
    else fill(this.startColor);
    noStroke();
    ellipse(this.x,this.y,4,4);
  }
  
  void reset() {
    drawSize = 0;
  }
}
