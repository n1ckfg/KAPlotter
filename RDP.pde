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

    float sqr(float x) { 
        return pow(x, 2);
    }

    float distanceBetweenPoints(float vx, float vy, float wx, float wy) {
        return sqr(vx - wx) + sqr(vy - wy);
    }

    float distanceToSegmentSquared(float px, float py, float vx, float vy, float wx, float wy) {
        float l2 = distanceBetweenPoints(vx, vy, wx, wy);
        if (l2 == 0) 
            return distanceBetweenPoints(px, py, vx, vy);
        float t = ((px - vx) * (wx - vx) + (py - vy) * (wy - vy)) / l2;
        if (t < 0) 
            return distanceBetweenPoints(px, py, vx, vy);
        if (t > 1) 
            return distanceBetweenPoints(px, py, wx, wy);
        return distanceBetweenPoints(px, py, (vx + t * (wx - vx)), (vy + t * (wy - vy)));
    }

    float perpendicularDistance(float px, float py, float vx, float vy, float wx, float wy) {
        return sqrt(distanceToSegmentSquared(px, py, vx, vy, wx, wy));
    }

    void douglasPeucker(ArrayList<Float[]> list, int s, int e, float epsilon, ArrayList<Float[]> resultList) {
        // Find the point with the maximum distance
        float dmax = 0;
        int index = 0;

        int start = s;
        int end = e-1;
        for (int i=start+1; i<end; i++) {
            // Point
            float px = list.get(i)[0];
            float py = list.get(i)[1];
            // Start
            float vx = list.get(start)[0];
            float vy = list.get(start)[1];
            // End
            float wx = list.get(end)[0];
            float wy = list.get(end)[1];
            float d = perpendicularDistance(px, py, vx, vy, wx, wy); 
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
            if ((end-start)>0) {
                resultList.add(list.get(start));
                resultList.add(list.get(end));   
            } else {
                resultList.add(list.get(start));
            }
        }
    }

    /*
     * Given a curve composed of line segments, find a similar curve with fewer points.
     * @param list ArrayList of Float[] points (x,y)
     * @param epsilon Distance dimension
     * @return Similar curve with fewer points
     */
    ArrayList<Float[]> douglasPeucker(ArrayList<Float[]> list, float epsilon) {
        ArrayList<Float[]> resultList = new ArrayList<Float[]>();
        douglasPeucker(list, 0, list.size(), epsilon, resultList);
        return resultList;
    }
}
