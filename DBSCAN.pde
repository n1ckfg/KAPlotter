// https://www.dataonfocus.com/dbscan-java-code/

import java.util.Iterator;


class DBDataPoint {

  float distance = 0.0;
  int clusterId = 0;
  Vert co = new Vert(0,0,0);
  
  DBDataPoint() { }

  DBDataPoint(Vert _point) { 
    co = _point;
  }

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
    point.clusterId = id;
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
  
  float max_distance = 999;
  int min_points = 1;
  
  boolean[] visited;
  
  DBSCAN(float _max_distance, int _min_points) {
    max_distance = _max_distance;
    min_points = _min_points;  
    init();
  }
  
  DBSCAN(ArrayList<Vert> _points) {
    init();
    setPoints(_points);    
    cluster();
  }

  DBSCAN(ArrayList<Vert> _points, float _max_distance, int _min_points) {
    max_distance = _max_distance;
    min_points = _min_points;  
    init();
    setPoints(_points);
    cluster();
  }
  
  void init() {
    points = new ArrayList<DBDataPoint>();   
    clusters = new ArrayList<DBCluster>();      
  }
  
  void setPoints(ArrayList<Vert> _points) {
    for (Vert p : _points) {
      points.add(new DBDataPoint(p));
    }
    
    visited = new boolean[points.size()];
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
      if (p.clusterId == -1) {
        c.addPoint(p);
      }
    }
  }

  ArrayList<Integer> getNeighbors(DBDataPoint d) {
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    int i = 0;
    for (DBDataPoint point : points) {
      float distance = d.co.dist(point.co);
      
      if (distance <= max_distance) {
        neighbors.add(i);
      }
      i++;
    }
    
    return neighbors;
  }
  
}
