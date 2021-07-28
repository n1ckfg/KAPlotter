class Vert {

  PVector co;
  color col;
  
  Vert(PVector _co, color _col) {
    co = _co;
    col = _col;
  }
  
  float dist(Vert v) {
    return co.dist(v.co);
  }
  
  Vert copy() {
    return new Vert(co, col);
  }


}
