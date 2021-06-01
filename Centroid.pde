class Centroid {

  PVector position;
  float colorR, colorG, colorB;
  int internalIndex;

  Centroid(int _internalIndex, float _r, float _g, float _b) {
    position = new PVector(random(width) - width/2, random(height) - height/2);
    colorR = _r;
    colorG = _g;
    colorB = _b;
    internalIndex = _internalIndex;
  }

  void Tick(ArrayList<Particle> _particles) {
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

  void drawCentroid() {
    pushMatrix();

    translate(position.x, position.y);
    noStroke();
    fill(colorR, colorG, colorB, 128);
    ellipse(0, 0, 20, 20);

    popMatrix();
  }
  
}
