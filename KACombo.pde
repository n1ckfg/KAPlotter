class KACombo {
  
  Kmeans kmeans;
  ArrayList<Astar> astars;
  boolean astarsGenerated = false;
  
  KACombo(ArrayList<PVector> _points, int _numCentroids) {
    kmeans = new Kmeans(_points, _numCentroids);
    astars = new ArrayList<Astar>();
  }

  void run() {
    kmeans.run();

    if (kmeans.ready && !astarsGenerated) {
      for (int i=0; i<kmeans.clusters.size(); i++) {
        Cluster cluster = kmeans.clusters.get(i);
        astars.add(new Astar(cluster.points, cluster.centroid));
      }
      write("output.json");
      astarsGenerated = true;
    }

    for (int i=0; i<astars.size(); i++) {
      astars.get(i).run();
    }
  }
  
  void init() {
    kmeans.init();
  }
  
  void write(String _fileName) {
    ArrayList<String> s = new ArrayList<String>();
    
    String nodeLabels = "";
    String nodePositions = "";
    
    for (int i=0; i<astars.size(); i++) {
      PVector p = astars.get(i).inputCentroid;
      if (!Float.isNaN(p.x) && !Float.isNaN(p.y) && !Float.isNaN(p.z)) {
        String ps = "[" + p.x + ", " + p.y + ", " + p.z + "]";
        if (i == astars.size()-1) {
          nodePositions += ps;
          nodeLabels += "" + i;
        } else {
          nodePositions += ps + ", ";
          nodeLabels += i + ", ";
        }
      }
    }
    
    s.add("{");  
    s.add("\t\"info\": {");
    s.add("\t\t\"A\": 1.0,");
    s.add("\t\t\"links\": {");
    s.add("\t\t\t\"weighted\": 0,");
    s.add("\t\t\t\"segs\": 20,");
    s.add("\t\t\t\"labels\": [],");
    s.add("\t\t\t\"T0\": 0.5,");
    s.add("\t\t\t\"thickness\": 4.3,");
    s.add("\t\t\t\"max_workers\": 50,");
    s.add("\t\t\t\"Temp0\": 0.0,");
    s.add("\t\t\t\"ce\": 10.0,");
    s.add("\t\t\t\"amplitude\": 4.3,");
    s.add("\t\t\t\"k\": 0.1");
    s.add("\t\t},");
    s.add("\t\t\"n_radius\": 1.0,");
    s.add("\t\t\"pow\": 2,");
    s.add("\t\t\"k\": 0.1,");
    s.add("\t\t\"nodes\": {");    
    s.add("\t\t\t\"labels\": [" + nodeLabels + "],");
    s.add("\t\t\t\"radius\": 1.0,");
    s.add("\t\t\t\"amplitude\": 4.3,");
    s.add("\t\t\t\"weighted\": 0,");
    s.add("\t\t},");
    s.add("\t\t\"long_rep\": 0.008691716021844473,");
    s.add("\t},");
    s.add("\t\"scale\": 1.0,");
    s.add("\t\"name\": \"" + _fileName + "\",");
    s.add("\t\"links\": {");
    for (int i=0; i<astars.size(); i++) {
      s.add("\t\t\"LINK_NAME\": {");
      s.add("\t\t\t\"end_points\": [],");
      s.add("\t\t\t\"points\": [],");
      s.add("\t\t\t\"radius\": 4.300000190734863,");
      s.add("\t\t\t\"weight\": 1");
      if (i==astars.size()-1) {
        s.add("\t\t}");
      } else {
        s.add("\t\t},");
      }
    }
    s.add("\t},");
    s.add("\t\"edgelist\": [],");
    s.add("\t\"nodes\": {");
    s.add("\t\t\"positions\": [" + nodePositions + "],");
    s.add("\t\t\"labels\": [" + nodeLabels + "]");
    s.add("\t}");
    s.add("}"); 
    
    saveStrings(_fileName, s.toArray(new String[s.size()]));
  }
  
}
