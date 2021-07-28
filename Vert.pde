class Vert {

  PVector co;
  color col;

  Vert(PVector _co) {
    co = _co;
    col = color(255);
  }
  
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
  
  PVector colToVec() {
    float r = red(col) / 255.0;
    float g = green(col) / 255.0;
    float b = blue(col) / 255.0;
    return new PVector(r, g, b);
  }


}
