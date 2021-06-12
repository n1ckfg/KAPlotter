// based on https://gist.github.com/raymondchua/8064159

import java.util.PriorityQueue;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;

class Astar {
  
  ArrayList<Node> nodes;
  int minEdges = 1;
  int maxEdges = 3;
  int minPathLength = 4;
  int searchReps = 10;
  float avgDistance = 0;
  float weightScale = 10;
  ArrayList<PVector> outputPoints;
  PVector inputCentroid;
  int smoothReps = globalSmoothReps;
  int splitReps = globalSplitReps;
  float addOdds = 0.4;

  // h-score is the straight-line distance from the current point to the centroid
  Astar(ArrayList<PVector> _points, PVector _centroid) {
    inputCentroid = _centroid;
    nodes = new ArrayList<Node>();
    outputPoints = new ArrayList<PVector>();
    
    nodes.add(new Node("0", 0)); // centroid
    
    for (int i=0; i<_points.size(); i++) {
      float distance = _points.get(i).dist(_centroid);
      avgDistance += distance;
      nodes.add(new Node("" + (i+1), distance));
    }
    
    if (_points.size() > 0) {
      avgDistance /= _points.size();
    }
    
    for (int h=0; h<searchReps; h++) {
      for (int i=0; i<nodes.size(); i++) {
        Node node = nodes.get(i);
        int numEdges = int(random(minEdges, maxEdges+1));
  
        Edge[] edges = new Edge[numEdges];
        for (int j=0; j<edges.length; j++) {
          int whichNode = int(random(nodes.size()));
          edges[j] = new Edge(nodes.get(whichNode), random(avgDistance/weightScale, avgDistance*weightScale)); // weights are all equal
        }
        node.adjacencies = edges;
      }
    
      AstarSearch(nodes.get(0), nodes.get(nodes.size()-1));
  
      ArrayList<Node> path = printPath(nodes.get(nodes.size()-1));
      
      if (path.size() >= minPathLength) {
        for (int i=0; i<path.size(); i++) {
          int index = int(path.get(i).value);
          if (index < _points.size() && random(1) < addOdds) outputPoints.add(_points.get(index));
        }
      }
    }

    refine();
  }

  void draw() {
    strokeWeight(2);
    stroke(255, 127, 0, 127);
    noFill();
    beginShape(TRIANGLE_STRIP);
    for (int j=0; j<outputPoints.size(); j++) {
      PVector p = outputPoints.get(j);
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
    int nPointsMinusTwo = outputPoints.size() - 2;
    PVector lower, upper, center;

    for (int i = 1; i < nPointsMinusTwo; i++) {
      lower = outputPoints.get(i-1);
      center = outputPoints.get(i);
      upper = outputPoints.get(i+1);

      center.x = (lower.x + weight * center.x + upper.x) * scale;
      center.y = (lower.y + weight * center.y + upper.y) * scale;
    }
  }

  void splitStroke() {
    for (int i = 1; i < outputPoints.size(); i+=2) {
      PVector center = outputPoints.get(i);
      PVector lower = outputPoints.get(i-1);
      float x = (center.x + lower.x) / 2;
      float y = (center.y + lower.y) / 2;
      float z = (center.z + lower.z) / 2;
      PVector p = new PVector(x, y, z);
      outputPoints.add(i, p);
    }
  }

  void refine() {
    for (int i=0; i<splitReps; i++) {
      splitStroke();  
      smoothStroke();  
    }
    for (int i=0; i<smoothReps - splitReps; i++) {
      smoothStroke();    
     }
  }
  
  ArrayList<Node> printPath(Node target) {
    ArrayList<Node> path = new ArrayList<Node>();
  
    for (Node node = target; node!=null; node = node.parent) {
        path.add(node);
    }

    Collections.reverse(path);
    return path;
  }

  void AstarSearch(Node source, Node goal) {
    Set<Node> explored = new HashSet<Node>();

    PriorityQueue<Node> queue = new PriorityQueue<Node>(20, new Comparator<Node>() {
      //override compare method
      public int compare(Node i, Node j) {
        if (i.f_scores > j.f_scores) {
            return 1;
        } else if (i.f_scores < j.f_scores){
            return -1;
        } else{
            return 0;
        }
      }
    });

    // cost from start
    source.g_scores = 0;

    queue.add(source);

    boolean found = false;

    while ((!queue.isEmpty()) && (!found)) {
      //the node in having the lowest f_score value
      Node current = queue.poll();

      explored.add(current);

      //goal found
      if (current.value.equals(goal.value)) {
        found = true;
      }

      //check every child of current node
      for (Edge e : current.adjacencies) {
        Node child = e.target;
        double cost = e.cost;
        double temp_g_scores = current.g_scores + cost;
        double temp_f_scores = temp_g_scores + child.h_scores;

        // if child node has been evaluated and the newer f_score is higher, skip
        if ((explored.contains(child)) && (temp_f_scores >= child.f_scores)) {
          continue;
        // else if child node is not in queue or newer f_score is lower
        } else if((!queue.contains(child)) || (temp_f_scores < child.f_scores)) {
          child.parent = current;
          child.g_scores = temp_g_scores;
          child.f_scores = temp_f_scores;

          if (queue.contains(child)) {
            queue.remove(child);
          }

          queue.add(child);
        }
      }
    }
  }
        
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

class Node {

  String value;
  double g_scores;
  double h_scores;
  double f_scores = 0;
  Edge[] adjacencies;
  Node parent;

  Node(String val, double hVal) {
    value = val;
    h_scores = hVal;
  }

  String toString(){
    return value;
  }

}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

class Edge {
  
  double cost;
  Node target;

  Edge(Node targetNode, double costVal) {
    target = targetNode;
    cost = costVal;
  }
  
}
