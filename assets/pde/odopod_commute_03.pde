
ArrayList<Position> employeePositions = new ArrayList<Position>();


int histDivs = 6;
int divSize;
int[] divCount = new int[histDivs];
float histX, histY;

boolean running = true;




// range of latitude and longitude in data:
float minLon, minLat, maxLon, maxLat;
int minTravel, maxTravel;
float sx, sy, sc;

float paddingTop = 60;
float paddingRight = 60;
float paddingBottom = 80;
float paddingLeft = 60;

float time = 0;

float minSpeed;

String activePerson;

Position odopod = new Position("Odopod",-122.4212424,37.7786871,0);
Position hoverPosition,slowestPosition;
Position caTop = new Position("California",-124.17058032226562,42.02845943001252,0);
Position caBot = new Position("California",-114.13125514984131,32.53420509787625,0);

PShape s;

int hoverCount = 0;

void setup() {
  size(800,600);
  smooth();
  frameRate(60);
  
  //Load employees
//  println("Opening position data...");
  loadEmployeePositions();
//  println("Parsed " + employeePositions.size() + " employee locations.");
  
  //Determine ranges
  minLon = maxLon = odopod.lon;
  minLat = maxLat = odopod.lat;
  minTravel = maxTravel = employeePositions.get(0).travelSecs;
  minSpeed = dist(employeePositions.get(0).lat,employeePositions.get(0).lon,odopod.lat,odopod.lon) / employeePositions.get(0).travelSecs;
  for(Position position : employeePositions) {
    if (position.lat < minLat) minLat = position.lat;
    if (position.lat > maxLat) maxLat = position.lat;
    if (position.lon < minLon) minLon = position.lon;
    if (position.lon > maxLon) maxLon = position.lon;
    if (position.travelSecs > maxTravel) maxTravel = position.travelSecs;
    if (position.travelSecs < minTravel) minTravel = position.travelSecs;
    
    float travelSpeed = dist(position.lat,position.lon,odopod.lat,odopod.lon) / position.travelSecs;
//    println(travelSpeed*1000);
    if (travelSpeed<minSpeed) {
      minSpeed = travelSpeed;
      slowestPosition = position;
    }
  }
//  println("Longitude range: (" + minLon + ", " + maxLon + ")");
//  println("Latitude range: (" + minLat + ", " + maxLat + ")");
//  println("Time range: (" + minTravel + ", " + maxTravel + ")");
//  println("Slowest speed is " + slowestPosition.name + ": " + minSpeed);
  
  // how much we'd scale x and y to fit the screen
  sx = (float(width)-paddingLeft-paddingRight) / (maxLon - minLon);
  sy = (float(height)-paddingTop-paddingBottom) / (maxLat - minLat);

  // we'll actually use the smallest one to fit the screen both ways
  sc = min(sx, sy);
  
  for(Position position : employeePositions) {
    position.calcXY();
  }
  odopod.calcXY();
  

    caTop.calcXY();
    caBot.calcXY();

    
    s = loadShape("assets/data/CA.svg");
    

  
  time = maxTravel*1.1;
  

  calcHistogram();
}

void draw() {
  background(0);
//  displayInfo();
  hoverCount=0;
  
  //Draw the borders
  shape(s,caTop.x,caTop.y,caBot.x-caTop.x,caBot.y-caTop.y);
  shape(s,caTop.x,caTop.y,caBot.x-caTop.x,caBot.y-caTop.y);


  //Draw the path
  for(Position position : employeePositions) {
    if(time<=position.travelSecs) position.drawPath(min(1,(position.travelSecs-time)/position.travelSecs));
  }
  
  //Draw the start points
  for(Position position : employeePositions) {
    position.drawStart();
    if(time<=position.travelSecs && time>0) {
      position.drawSize += 1;
    } else if(position.drawSize > 0) position.drawSize++;
//    if(position.drawSize >= 50) position.reset();
    if((int)time == position.travelSecs) activePerson = position.name;
    
    if(mouseX > position.x - 5 && mouseX < position.x + 5 && mouseY > position.y - 5 && mouseY < position.y + 5) {
      hoverPosition = position; 
      hoverCount++;
    }

  }
  
  //Manipulate the timeline
  if(running) time-=.1;
  if(running && time<=maxTravel-(maxTravel*1.1)) {
    for(Position position : employeePositions) position.reset();
    activePerson = null;
    time=maxTravel*1.1;
  }

  //Draw destination
  fill(192,235,130);
  noStroke();
  ellipse((odopod.lon - minLon) * sc + paddingLeft,((float(height)-paddingTop-paddingBottom)-((odopod.lat - minLat)) * sc + paddingBottom),8,8);
  
  if(hoverPosition!=null && hoverCount>0) {
    fill(255);
    rect(hoverPosition.x-(textWidth(hoverPosition.name)+15)/2,hoverPosition.y-50,textWidth(hoverPosition.name)+15,23);
    triangle(hoverPosition.x,hoverPosition.y-5,hoverPosition.x+8,hoverPosition.y-35,hoverPosition.x-8,hoverPosition.y-35);
    fill(0);
    textAlign(CENTER,CENTER);
    text(hoverPosition.name,hoverPosition.x,hoverPosition.y-40);
  }
  
  displayClock(40,40);
  displayHistogram(histX,histY);
//  //Print info
//  if(activePerson != null) {
//    fill(255);
//    textAlign(RIGHT,TOP);
//    text(activePerson + " just left for work",width,0);
//  }
}

void mousePressed() {
  if(mouseX > histX-10 && mouseY < histY+30) {
    time = constrain(map(mouseX,histX,histX+(31)*histDivs,maxTravel,0),0,maxTravel);
    running = false;
  }
}

void mouseDragged() {
  if(mouseX > histX-10 && mouseY < histY+30) {
    time = constrain(map(mouseX,histX,histX+(31)*histDivs,maxTravel,0),0,maxTravel);
    running = false;
  }
}

void mouseReleased() {
  running = true;
}
