/*
 * https://raw.githubusercontent.com/phishman3579/java-algorithms-implementation/master/src/com/jwetherell/algorithms/mathematics/RamerDouglasPeucker.java
 * The Ramer–Douglas–Peucker algorithm (RDP) is an algorithm for reducing the number of points in a 
 * curve that is approximated by a series of points.
 * See https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
 * @author Justin Wetherell <phishman3579@gmail.com>
 */
class RDP {

  RDP() { 
    //
  }

  float sqr(float n) { 
    return pow(n, 2);
  }

  float distanceBetweenPoints(Vert v, Vert w) {
    return pow(sqr(v.x - w.x) + sqr(v.y - w.y) + sqr(v.z - w.z), 0.5);
  }

  float distanceToSegmentSquared(Vert p, Vert v, Vert w) {
    float l2 = distanceBetweenPoints(v, w);
    if (l2 == 0) 
      return distanceBetweenPoints(p, v);
    float t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
    if (t < 0) 
      return distanceBetweenPoints(p, v);
    if (t > 1) 
      return distanceBetweenPoints(p, w);
    return distanceBetweenPoints(p, new Vert ((v.x + t * (w.x - v.x)), (v.y + t * (w.y - v.y)), (v.z + t * (w.z - v.z))));
  }

  float perpendicularDistance(Vert p, Vert v, Vert w) {
    return sqrt(distanceToSegmentSquared(p, v, w));
  }

  void douglasPeucker(ArrayList<Vert> list, int s, int e, float epsilon, ArrayList<Vert> resultList) {
    // Find the point with the maximum distance
    float dmax = 0;
    int index = 0;

    int start = s;
    int end = e-1;
    for (int i=start+1; i<end; i++) {      
      Vert p = list.get(i); // Point    
      Vert v = list.get(start); // Start
      Vert w = list.get(end); // End
      
      float d = perpendicularDistance(p, v, w); 
      if (d > dmax) {
        index = i;
        dmax = d;
      }
    }
    
    // If max distance is greater than epsilon, recursively simplify
    if (dmax > epsilon) {
      // Recursive call
      douglasPeucker(list, s, index, epsilon, resultList);
      douglasPeucker(list, index, e, epsilon, resultList);
    } else {
      if ((end - start) > 0) {
        resultList.add(list.get(start));
        resultList.add(list.get(end));   
      } else {
        try {
          resultList.add(list.get(start));
        } catch (Exception ee) {
          println("RDP found no points within epsilon distance.");
          resultList.clear();
          resultList = list;
          return;
        }
      }
    }
  }

  /*
   * Given a curve composed of line segments, find a similar curve with fewer points.
   * @param list ArrayList of Float[] points (x,y)
   * @param epsilon Distance dimension
   * @return Similar curve with fewer points
   */
  ArrayList<Vert> douglasPeucker(ArrayList<Vert> list, float epsilon) {
    ArrayList<Vert> resultList = new ArrayList<Vert>();
    douglasPeucker(list, 0, list.size(), epsilon, resultList);
    return resultList;
  }
  
}
