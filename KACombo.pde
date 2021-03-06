class KACombo {
  
  Kmeans kmeans;
  DBSCAN dbscan;
  ArrayList<Sorter> sorters;
  ArrayList<Astar> astars;
  boolean secondaryGenerated = false;
  float outputScaler = 0.1;
  boolean enableAstars = false;
  
  KACombo(ArrayList<Vert> _points, int _numCentroids) {
    kmeans = new Kmeans(_points, _numCentroids);
    sorters = new ArrayList<Sorter>();
    astars = new ArrayList<Astar>();
  }

  void run() {
    kmeans.run();

    if (kmeans.ready && !secondaryGenerated) {
      for (int i=0; i<kmeans.clusters.size(); i++) {
        KCluster cluster = kmeans.clusters.get(i);
        if (cluster.points.size() > 1) {
          Sorter sorter = new Sorter(cluster);
          sorters.add(sorter);
          if (enableAstars) {
            Astar astar = new Astar(sorter.points, cluster.centroid);
            astars.add(astar);
          }
        }
      }
      //writeNetwork("output.json");
      secondaryGenerated = true;
    }

    for (int i=0; i<sorters.size(); i++) {
      sorters.get(i).run();
      if (enableAstars) astars.get(i).run();
    }
  }
  
  void init() {
    kmeans.init();
  }
  
  void writeNetwork(String _fileName) {
    ArrayList<String> s = new ArrayList<String>();
    
    // clean the list first
    for (int i=astars.size()-1; i>=0; i--) {
      Astar astar = astars.get(i);
      Vert p = astar.inputCentroid;
      if (Float.isNaN(p.x) || Float.isNaN(p.y) || Float.isNaN(p.z) || astar.outputPoints.size() <= 0) {
        astars.remove(i);
      }
    }
    
    String nodePositions = "";
    String nodeLabels = "";
    for (int i=0; i<astars.size(); i++) {
      Astar astar = astars.get(i);
      Vert p = astar.inputCentroid.copy().mult(outputScaler);
      String ps = "[" + p.x + ", " + p.y + ", " + p.z + "]";
      if (i == astars.size()-1) {
        nodePositions += ps;
        nodeLabels += "" + i;
      } else {
        nodePositions += ps + ", ";
        nodeLabels += i + ", ";
      }
     }

    String linkLabels = "";
    for (int i=0; i<astars.size(); i++) {
      if (i == astars.size()-1) {
        linkLabels += "\"" + i + ";" + 0 + "\"";
      } else {
        linkLabels += "\"" + i + ";" + (i+1) + "\"" + ", ";
      }
    }

    String[]linkLabelsArray = linkLabels.split(", ");
    
    s.add("{");  
    s.add("\t\"info\": {");
    s.add("\t\t\"A\": 1.0,");
    s.add("\t\t\"links\": {");
    s.add("\t\t\t\"weighted\": 0,");
    s.add("\t\t\t\"segs\": 20,");
    s.add("\t\t\t\"labels\": [" + linkLabels + "],");
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
    s.add("\t\t\t\"weighted\": 0");
    s.add("\t\t},");
    s.add("\t\t\"long_rep\": 0.008691716021844473");
    s.add("\t},");
    s.add("\t\"scale\": 1.0,");
    s.add("\t\"name\": \"" + _fileName + "\",");
    s.add("\t\"links\": {");
    for (int i=0; i<linkLabelsArray.length; i++) {
      s.add("\t\t" + linkLabelsArray[i] + ": {");
      String[] endPointsS = linkLabelsArray[i].split(";");
      endPointsS[0] = endPointsS[0].split("\"")[1];
      endPointsS[1] = endPointsS[1].split("\"")[0];
      int[] endPoints = { int(endPointsS[0]), int(endPointsS[1]) };
      s.add("\t\t\t\"end_points\": [" +endPoints[0] + ", " + endPoints[1] + "],");
      
      ArrayList<Vert> points = astars.get(endPoints[0]).outputPoints;
      String pointsS = "";
      for (int j=0; j<points.size(); j++) {
        Vert p = points.get(j).copy().mult(outputScaler);
        String pS = "[" + p.x + ", " + p.y + ", " + p.z + "]";
        if (j != points.size()-1) pS += ", ";
        pointsS += pS;
      }
      s.add("\t\t\t\"points\": [" + pointsS + "],");
      
      s.add("\t\t\t\"radius\": 4.300000190734863,");
      s.add("\t\t\t\"weight\": 1");
      if (i==linkLabelsArray.length-1) {
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
