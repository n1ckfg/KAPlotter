// https://www.dataonfocus.com/dbscan-java-code/

import java.util.Iterator;

interface DBDataPoint {
  double distance(DBDataPoint datapoint);
  void setCluster(int id);
  int getCluster();
  int getX();
  int getY();
}

class DBCluster {
  
  ArrayList<DBDataPoint> points;
  DBDataPoint centroid;
  int id;
  
  DBCluster(int _id) {
    id = _id;
    points = new ArrayList<DBDataPoint>();
    centroid = null;
  }

  ArrayList<DBDataPoint> getPoints() {
    return points;
  }
  
  void addPoint(DBDataPoint point) {
    points.add(point);
    point.setCluster(id);
  }

  void setPoints(ArrayList<DBDataPoint> _points) {
    points = _points;
  }

  DBDataPoint getCentroid() {
    return centroid;
  }

  void setCentroid(DBDataPoint _centroid) {
    centroid = _centroid;
  }

  int getId() {
    return id;
  }
  
  void clear() {
    points.clear();
  }
  
  void plotCluster() {
    println("[DBCluster: " + id+"]");
    println("[Centroid: " + centroid + "]");
    println("[Points: \n");
    for (DBDataPoint p : points) {
      println(p);
    }
    println("]");
  }

}

class DBSCAN {
  
  ArrayList<DBDataPoint> points;
  ArrayList<DBCluster> clusters;
  
  double max_distance;
  int min_points;
  
  boolean[] visited;
  
  DBSCAN(double _max_distance, int _min_points) {
    points = new ArrayList<DBDataPoint>();
    clusters = new ArrayList<DBCluster>();
    max_distance = _max_distance;
    min_points = _min_points;
  }

  void cluster() {
    Iterator it = points.iterator();
    int n = 0;
    
    while (it.hasNext()) {
      
      if (!visited[n]) {
        DBDataPoint d = (DBDataPoint) it.next();
        visited[n] = true;
        ArrayList<Integer> neighbors = getNeighbors(d);
        
        if (neighbors.size() >= min_points) {
          DBCluster c = new DBCluster(clusters.size());
          buildCluster(d,c,neighbors);
          clusters.add(c);
        }
      }
    }
  }

  void buildCluster(DBDataPoint d, DBCluster c, ArrayList<Integer> neighbors) {
    c.addPoint(d);
    
    for (Integer point : neighbors) {
      DBDataPoint p = points.get(point);
      if (!visited[point]) {
        visited[point] = true;
        ArrayList<Integer> newNeighbors = getNeighbors(p);
        if(newNeighbors.size() >= min_points) {
          neighbors.addAll(newNeighbors);
        }
      }
      if (p.getCluster() == -1) {
        c.addPoint(p);
      }
    }
  }

  ArrayList<Integer> getNeighbors(DBDataPoint d) {
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    int i = 0;
    for (DBDataPoint point : points) {
      double distance = d.distance(point);
      
      if (distance <= max_distance) {
        neighbors.add(i);
      }
      i++;
    }
    
    return neighbors;
  }

  void setPoints(ArrayList<DBDataPoint> _points) {
    points = _points;
    visited = new boolean[points.size()];
  }
  
}
