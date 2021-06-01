// based on https://openprocessing.org/sketch/51404/

class Kmeans {

  ArrayList<Particle> particles;
  ArrayList<Centroid> centroids;
  int numberOfParticles = 4096; //128;
  int numberOfCentroids = 32;

  Kmeans() {
    particles = new ArrayList<Particle>();
    centroids = new ArrayList<Centroid>();
    
    init();
  }
  
  void init() {    
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
  
  void draw() {
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).draw();
    }  
  
    for (int i = 0; i < centroids.size(); i++) {
      centroids.get(i).draw();
    }
  }
  
  void run() {
    update();
    draw();
  }

}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

class Centroid {

  PVector position;
  float colorR, colorG, colorB;
  int internalIndex;

  Centroid(int _internalIndex, float _r, float _g, float _b) {
    position = new PVector(random(width) - width/2, random(height) - height/2, random(depth) - depth/2);
    colorR = _r;
    colorG = _g;
    colorB = _b;
    internalIndex = _internalIndex;
  }

  void update(ArrayList<Particle> _particles) {
    //println("-----------------------");
    //println("K-Means Centroid Tick");
    // move the centroid to its new position

    PVector newPosition = new PVector(0.0, 0.0);

    float numberOfAssociatedParticles = 0;

    for (int i = 0; i < _particles.size(); i++) {
      Particle curParticle = _particles.get(i);

      if (curParticle.centroidIndex == internalIndex) {
        newPosition.add(curParticle.position); 
        numberOfAssociatedParticles++;
      }
    }

    newPosition.div(numberOfAssociatedParticles);
    position = newPosition;
  }

  void draw() {
    pushMatrix();

    translate(position.x, position.y, position.z);
    strokeWeight(20);
    stroke(colorR, colorG, colorB);
    point(0,0);
    
    popMatrix();
  }
  
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

class Particle {

  PVector position;
  PVector velocity;
  int centroidIndex;
  float colorR, colorG, colorB;

  Particle() {
    position = new PVector(random(width) - width/2, random(height) - height/2, random(depth) - depth/2);
  }

  void FindClosestCentroid(ArrayList<Centroid> _centroids) {
    int closestCentroidIndex = 0;
    float closestDistance = 100000;

    // find which centroid is the closest
    for (int i = 0; i < _centroids.size(); i++) {      
      Centroid curCentroid = _centroids.get(i);

      float distanceCheck = position.dist(curCentroid.position); 

      if (distanceCheck < closestDistance) {
        closestCentroidIndex = i;
        closestDistance = distanceCheck;
      }
    }

    // now that we have the closest centroid chosen, assign the index,
    centroidIndex = closestCentroidIndex;

    // and grab the color for the visualization    
    Centroid curCentroid = _centroids.get(centroidIndex);
    colorR = curCentroid.colorR;
    colorG = curCentroid.colorG;
    colorB = curCentroid.colorB;
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    strokeWeight(4);
    stroke(colorR, colorG, colorB);
    point(0, 0);
    popMatrix();
  }
  
}
