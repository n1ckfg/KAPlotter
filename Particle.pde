class Particle {

  PVector position;
  PVector velocity;
  int centroidIndex;
  float colorR, colorG, colorB;

  Particle() {
    position = new PVector(random(width) - width/2, random(height) - height/2);
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

  void drawParticle() {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();    
    fill(colorR, colorG, colorB, 255);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
  
}
