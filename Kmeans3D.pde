import peasy.PeasyCam;

PeasyCam cam;

Kmeans kmeans;
Astar astar;

PShape shp;
ArrayList<PVector> points;

int depth;
int counter = 0;

void setup() {
  size(900, 450, P3D);
  depth = (width + height) / 2;

  cam = new PeasyCam(this, 400);
  
  shp = loadShape("battle_pod_tri.obj");
  points = new ArrayList<PVector>();
  for (int i=0; i<shp.getChildCount(); i++) {
    PShape child = shp.getChild(i);
    for (int j=0; j<child.getVertexCount(); j++) {
      points.add(child.getVertex(j));
    }
  }

  kmeans = new Kmeans(points);
  astar = new Astar();
}

void draw() {
  background(0);

  counter++;
   
  pushMatrix();
  translate(width/2, height/2, -500);
  scale(1000, 1000, 1000);
  rotateX(radians(180));
  rotateY(radians(90));

  kmeans.run();

  popMatrix();

  if (counter > 100) { 
    counter = 0;
    kmeans.init();
  }
  
  surface.setTitle(""+frameRate);
}
