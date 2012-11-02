// Made By Eight Eyes Creations - sean@8isc.com

int count = 25;

int maxSize = 10;
int minSize = 2;
int fadeUpperLimit = 75;
int fadeLowerLimit = 5;

int gravRange = 5;
int brakes = 5;
int brakeSpeed = 4;

int width = 860;
int height = 500;

float[][]curves = new float[count][8];
GCircle[]circles = new GCircle[count];


void setup() {
  frameRate(30);
  ellipseMode(CENTER);
  size(width, height);
  strokeWeight(0);
	noStroke();

  for (int j=0;j<count;j++) {
    circles[j] = new GCircle(j, random(width), random(height));
  }

  for (int j = 0; j<count;j++) {
    curves[j][0] = random(0, -10); // begin x
    curves[j][1] = random(0, height/3); // begin y
    curves[j][2] = random(0, width+10); // end x
    curves[j][3] = random(0, height/3); // end y
  }
}


void draw() {
  //background(255);
  fill(255,10);
  rect(0,0,width,height);
  makeCircles();

  //makeCurves();
}

class GCircle {
  float x, y, r, mX, mY, g;
  int id, xInt, yInt, black, opacity, iterations;
  PVector[] gravity;
	PVector location, velocity;
  boolean highlight;
  PVector current, target;

  GCircle(int id, float xPos, float yPos) {
    id = id;
	x  = xPos;
    y  = yPos;
	xInt = floor(x);
	yInt = floor(y);
    current = new PVector(x, y);
	r  = random(minSize, maxSize); // Radius  
    mX = random(-1, 1); // X Speed
    mY = random(-1, 1); // Y Speed    
    g  = random(.99, 1.01); // Growth Factor
    black = floor(random(100, 200));
    opacity = floor(random(50, fadeUpperLimit));
	highlight = false;
	gravity = new PVector[count];
	location = new PVector(x, y);
	velocity = new PVector(mX, mY);
}

  void activate() {
	moveit();
   // change();
    make();
  }

  void moveit() {
	
	//wrap
    if ( x < -r ) { 
      x = width+r;
    } 
    if ( x > width+r ) { 
      x = -r;
    }
    if ( y < 0-r ) { 
      y = height+r;
    }
    if ( y > height+r) { 
      y = -r;
    }
	
	//collision
	for (int j=0; j<count; j++){
		GCircle c = circles[j];
		if (c != this){
			// don't ping on self
			//highlight = false;
			float dis = dist(x,y,c.x,c.y);
			if (dis <= c.r*2 + gravRange){
				PVector currPos = new PVector(x, y);
				PVector targetPos = new PVector(c.x, c.y);
				float gFactor = (dis*dis)/10000;
				gravity[j] = PVector.sub(currPos, targetPos);
				gravity[j].mult(gFactor);
				//println(gravity[j]);
				velocity = PVector.sub(velocity,gravity[j]);
				black = 50;
				
				if (abs(velocity.x) > brakeSpeed || abs(velocity.y) > brakeSpeed)
				{ //println("'EEK'");
					velocity = PVector.add(velocity,gravity[j]); 
					velocity.div(brakes);
				}
			
			}
			if ((dis - r - c.r) < 0){
				gravity = new PVector[count];
				highlight = true;
				break;
			} 
				
			
		}
	}
	

	
	mX = velocity.x;
	mY = velocity.y;
	
	//move
    x += mX;
    y += mY;

}


  void make() {
	//drawing base circle
	if (highlight == true) {
		color c = color(#ce3d30);
		fill(c,opacity);
		black = 25;
		opacity = 25;
	} else {
		fill(black,opacity);
	}
	if (opacity < fadeUpperLimit) {opacity++;}
	if (opacity > fadeLowerLimit ){ opacity--; }
		//drawing fake blur
        
    ellipse(x, y, r*2, r*2);
	smooth();

  }

  void change() {
	if (opacity < 100) {opacity += 1;}
    if (r < maxSize && r > minSize ) {
      //fadeout
      opacity -= 2;
      //size change
      if (r > minSize) {r -= .5;}
      //growth change
      g -= 0.001;
    } 
    else {
	//println("'test'");
      r += 1;
      g += 0.001;
    } 

	if (r <= maxSize && r >= minSize) {r *= g;}
  }
}

class GCurve {
	PVector pos1, pos2, hand;
	
}

void makeCurves() {
  curveTightness(5);
  for (int j=0; j<count; j++) {
    curve(curves[j][0] - random(0, 10), curves[j][1] + random(0, 10), curves[j][0], curves[j][1], curves[j][2], curves[j][3], curves[j][2] + random(0, 10), curves[j][3] + random(0, 10));
  }
  smooth();
}

void makeCircles() {

  for (int j=0;j<count;j++) {
    circles[j].activate();
  }
}


