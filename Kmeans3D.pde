import peasy.PeasyCam;

PeasyCam cam;

Kmeans kmeans;
Astar astar;

int depth;
int counter = 0;

void setup() {
  size(900, 450, P3D);
  depth = (width + height) / 2;

  cam = new PeasyCam(this, 400);

  kmeans = new Kmeans();
  astar = new Astar();
}

void draw() {
  background(0);

  counter++;
  
  kmeans.run();

  if (counter > 100) { 
    counter = 0;
    kmeans.init();
  }
  
}
