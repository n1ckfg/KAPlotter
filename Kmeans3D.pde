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
  smooth();

  particles = new ArrayList<Particle>();
  centroids = new ArrayList<Centroid>();

  for (int i = 0; i < numberOfParticles; i++) {
    particles.add(new Particle());
  }

  for (int i = 0; i < numberOfCentroids; i++) {
    centroids.add(new Centroid(i, 127+random(127), 127+random(127), 127+random(127)));
  }

  cam = new PeasyCam(this, 400);

  TickSim();
}

void draw() {
  background(0);

  counter++;
  
  TickSim();

  if (counter > 100) { 
    counter = 0;
    
    particles.clear(); centroids.clear();
    
    for (int i = 0; i < numberOfParticles; i++) {
      particles.add(new Particle());
    }
  
    for (int i = 0; i < numberOfCentroids; i++) {
      centroids.add(new Centroid(i, random(255), random(255), random(255)));
    }
  }

  for (int i = 0; i < particles.size(); i++) {
    Particle curParticle = (Particle) particles.get(i);

    curParticle.drawParticle();
  }  

  for (int i = 0; i < centroids.size(); i++) {
    Centroid curCentroid = (Centroid) centroids.get(i);

    curCentroid.drawCentroid();
  }
}

void TickSim() {
  for (int i = 0; i < particles.size(); i++) {
    Particle curParticle = (Particle) particles.get(i);

    curParticle.FindClosestCentroid(centroids);
  }  

  for (int i = 0; i < centroids.size(); i++) {
    Centroid curCentroid = (Centroid) centroids.get(i);

    curCentroid.Tick(particles);
  }
}
