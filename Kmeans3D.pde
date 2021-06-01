import peasy.PeasyCam;

PeasyCam cam;

Kmeans kmeans;
Astar astar;

PShape shp;

int depth;
int counter = 0;

void setup() {
  size(900, 450, P3D);
  depth = (width + height) / 2;

  cam = new PeasyCam(this, 400);
  shp = loadShape("battle_pod_tri.obj");

  kmeans = new Kmeans();
  astar = new Astar();
}

void draw() {
  background(0);

  counter++;
  
  //kmeans.run();

  if (counter > 100) { 
    counter = 0;
    kmeans.init();
  }
  
  strokeWeight(0.005);
  stroke(255);
  fill(255);
  
  pushMatrix();
  translate(width/2, height/2, -500);
  scale(1000, 1000, 1000);
  rotateX(radians(180));
  rotateY(radians(90));
  beginShape(POINTS);
  for (int i=0; i<shp.getChildCount(); i++) {
    PShape child = shp.getChild(i);
    for (int j=0; j<child.getVertexCount(); j++) {
      PVector p = child.getVertex(j);
      vertex(p.x, p.y, p.z);
    }
  }

  endShape();
  popMatrix();

  surface.setTitle(""+frameRate);
}
