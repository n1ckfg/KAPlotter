//  https://openprocessing.org/sketch/51404/

import peasy.PeasyCam;

PeasyCam cam;

int numberOfParticles = 128;
int numberOfCentroids = 6;

int counter = 0;

ArrayList<Particle> particles;
ArrayList<Centroid> centroids;

void setup() {
  size(900, 450, P3D);
  background(0);

  particles = new ArrayList<Particle>();
  centroids = new ArrayList<Centroid>();
  cam = new PeasyCam(this, 400);

  init();
}

void draw() {
  background(0);

  counter++;
  
  update();

  if (counter > 100) { 
    init();
  }

  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).draw();
  }  

  for (int i = 0; i < centroids.size(); i++) {
    centroids.get(i).draw();
  }
}

void init() {
  counter = 0;
  
  particles.clear(); 
  centroids.clear();
  
  for (int i = 0; i < numberOfParticles; i++) {
    particles.add(new Particle());
  }

  for (int i = 0; i < numberOfCentroids; i++) {
    centroids.add(new Centroid(i, 127+random(127), 127+random(127), 127+random(127)));
  }
}

void update() {
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).FindClosestCentroid(centroids);
  }  

  for (int i = 0; i < centroids.size(); i++) {
    centroids.get(i).update(particles);
  }
}
