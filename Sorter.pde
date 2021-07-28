class Sorter {
  
  ArrayList<Vert> points;
  int smoothReps = globalSmoothReps;
  int splitReps = globalSplitReps;
  RDP rdp;
  int increment = 5;

  Sorter(KCluster cluster) {
    rdp = new RDP();
    points = new ArrayList<Vert>();
    
    Collections.sort(cluster.points, new DistanceComparator(cluster.centroid)); // sort points by distance from centroid

    ArrayList<Vert> input = new ArrayList<Vert>();
    for (int i=0; i<cluster.points.size(); i+=increment) {
      input.add(cluster.points.get(i).copy());
    }
       
    int _root = input.size()-1; // start with the point furthest away from the centroid
    
    Vert root = input.get(_root);
    points.add(root);
    input.remove(_root);
    
    int counter = input.size()-1;
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
      //if (random(1) < addOdds) 
      points.add(root);
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
      Vert p = points.get(i);
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
    Vert lower, upper, center;

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
      Vert center = points.get(i);
      Vert lower = points.get(i-1);
      float x = (center.x + lower.x) / 2;
      float y = (center.y + lower.y) / 2;
      float z = (center.z + lower.z) / 2;
      float r = (red(center.col) + red(lower.col)) / 2;
      float g = (green(center.col) + green(lower.col)) / 2;
      float b = (blue(center.col) + blue(lower.col)) / 2;
      Vert p = new Vert(x, y, z, r, g, b);
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
// example:
// Collections.sort(points, new DistanceComparator(root));

import java.util.Comparator;

class DistanceComparator implements Comparator<Vert> {

  Vert compareToVector;

  DistanceComparator(Vert compareToVector) {
    this.compareToVector = compareToVector;
  }

  int compare(Vert v1, Vert v2) {
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
