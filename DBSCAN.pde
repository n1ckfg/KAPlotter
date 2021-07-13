// https://www.dataonfocus.com/dbscan-java-code/

import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

interface Algorithm {
  void setPoints(List points);
  void cluster();
}

interface DataPoint {
  double distance(DataPoint datapoint);
  void setCluster(int id);
  int getCluster();
  int getX();
  int getY();
}

class Cluster {
  
  List points;
  DataPoint centroid;
  int id;
  
  Cluster(int id) {
    this.id = id;
    this.points = new ArrayList();
    this.centroid = null;
  }

  List getPoints() {
    return points;
  }
  
  void addPoint(DataPoint point) {
    points.add(point);
    point.setCluster(id);
  }

  void setPoints(List points) {
    this.points = points;
  }

  DataPoint getCentroid() {
    return centroid;
  }

  void setCentroid(Point centroid) {
    this.centroid = centroid;
  }

  int getId() {
    return id;
  }
  
  void clear() {
    points.clear();
  }
  
  void plotCluster() {
    println("[Cluster: " + id+"]");
    println("[Centroid: " + centroid + "]");
    println("[Points: \n");
    for (DataPoint p : points) {
      println(p);
    }
    println("]");
  }

}

class DBSCAN implements Algorithm {
  
  List points;
    List clusters;
  
  double max_distance;
  int min_points;
  
  boolean[] visited;
  
  DBSCAN(double max_distance, int min_points) {
    this.points = new ArrayList();
    this.clusters = new ArrayList();
    this.max_distance = max_distance;
    this.min_points = min_points;
  }

  void cluster() {
    Iterator it = points.iterator();
    int n = 0;
    
    while (it.hasNext()) {
      
      if (!visited[n]) {
        DataPoint d = it.next();
        visited[n] = true;
        List neighbors = getNeighbors(d);
        
        if (neighbors.size() &gt;= min_points) {
          Cluster c = new Cluster(clusters.size());
          buildCluster(d,c,neighbors);
          clusters.add(c);
        }
      }
    }
  }

  void buildCluster(DataPoint d, Cluster c, List neighbors) {
    c.addPoint(d);
    
    for (Integer point : neighbors) {
      DataPoint p = points.get(point);
      if (!visited[point]) {
        visited[point] = true;
        List newNeighbors = getNeighbors(p);
        if(newNeighbors.size() &gt;= min_points) {
          neighbors.addAll(newNeighbors);
        }
      }
      if (p.getCluster() == -1) {
        c.addPoint(p);
      }
    }
  }

  List getNeighbors(DataPoint d) {
    List neighbors = new ArrayList();
    int i = 0;
    for (DataPoint point : points) {
      double distance = d.distance(point);
      
      if (distance &lt;= max_distance) {
        neighbors.add(i);
      }
      i++;
    }
    
    return neighbors;
  }

  void setPoints(List points) {
    this.points = points;
    this.visited = new boolean[points.size()];
  }
  
}
