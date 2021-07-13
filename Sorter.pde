class Sorter {
  
  ArrayList<PVector> points;
  int smoothReps = globalSmoothReps;
  int splitReps = globalSplitReps;
  float addOdds = 0.1;
  RDP rdp;
  
  Sorter(ArrayList<PVector> _points, int _root) {
    rdp = new RDP();
    points = new ArrayList<PVector>();
    
    ArrayList<PVector> input = new ArrayList<PVector>();
    for (int i=0; i<_points.size(); i++) {
      input.add(_points.get(i).copy());
    }
    
    PVector root = input.get(_root);
    points.add(root);
    input.remove(_root);
    
    int counter = _points.size()-1;
    while (counter > 0) {
      float shortestDistance = 999999;
      int shortestDistanceIndex = 0;
      for (int i=0; i<counter; i++) {
        float d = root.dist(input.get(i));
        if (d < shortestDistance) {
          shortestDistance = d;
          shortestDistanceIndex = i;
        }
      }
      
      root = input.get(shortestDistanceIndex);
      if (random(1) < addOdds) points.add(root);
      input.remove(shortestDistanceIndex);
      counter--;
    }
        
    refine();
  }
  
  void draw() {
    strokeWeight(2);
    stroke(0, 127, 255, 127);
    noFill();
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<points.size(); i++) {
      PVector p = points.get(i);
      vertex(p.x, p.y, p.z);
    }
    endShape();  
  }

  void run() {
    draw();
  }

  void smoothStroke() {
    float weight = 18;
    float scale = 1.0 / (weight + 2);
    int nPointsMinusTwo = points.size() - 2;
    PVector lower, upper, center;

    for (int i = 1; i < nPointsMinusTwo; i++) {
      lower = points.get(i-1);
      center = points.get(i);
      upper = points.get(i+1);

      center.x = (lower.x + weight * center.x + upper.x) * scale;
      center.y = (lower.y + weight * center.y + upper.y) * scale;
    }
  }

  void splitStroke() {
    for (int i = 1; i < points.size(); i+=2) {
      PVector center = points.get(i);
      PVector lower = points.get(i-1);
      float x = (center.x + lower.x) / 2;
      float y = (center.y + lower.y) / 2;
      float z = (center.z + lower.z) / 2;
      PVector p = new PVector(x, y, z);
      points.add(i, p);
    }
  }

  void refine() {
    for (int i=0; i<splitReps; i++) {
      splitStroke();  
      smoothStroke();  
    }
    
    points = rdp.douglasPeucker(points, globalRdpEpsilon);

    for (int i=0; i<smoothReps - splitReps; i++) {
      smoothStroke();    
     }
  }
  
}


// https://forum.processing.org/one/topic/sort-arraylist-with-pvector-on-distance-to-a-point.html

import java.util.Comparator;

class DistanceComparator implements Comparator<PVector> {

  PVector compareToVector;

  DistanceComparator(PVector compareToVector) {
    this.compareToVector = compareToVector;
  }

  int compare(PVector v1, PVector v2) {
    float d1 = v1.dist(compareToVector);
    float d2 = v2.dist(compareToVector);

    if (d1 < d2) {
      return -1;
    } else if (d1 > d2) {
      return 1;
    } else {
      return 0;
    }
  } 
  
}
