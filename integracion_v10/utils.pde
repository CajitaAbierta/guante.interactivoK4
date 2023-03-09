void PrintlnIzq(String in) {
  //funcion tomada de https://forum.processing.org/two/discussion/8016/display-the-console-during-execution.html
  println(in);
  if(consolaIzq.size()>limChar)
  {
    consolaIzq.remove(0);
  }
  consolaIzq.append(in);
}
void PrintlnDer(String in) {
  //funcion tomada de https://forum.processing.org/two/discussion/8016/display-the-console-during-execution.html
  println(in);
  if(consolaDer.size()>limChar)
  {
    consolaDer.remove(0);
  }
  consolaDer.append(in);
}
PVector coord_polar_grados(float rad, float rot) {//funcion para optimizar las coordenadas polares
  float x, y;
  x=rad*cos(radians(rot));
  y=rad*sin(radians(rot));
  return new PVector(x, y);
}
PVector coord_polar(float rad, float rot) {//funcion para optimizar las coordenadas polares
  float x, y;
  x=rad*cos(rot);
  y=rad*sin(rot);
  return new PVector(x, y);
}

PVector [] listCoordPoligono(int rad, int div) {
  PVector []  vectores = new PVector[div] ;
  float rotaciones=TAU/float(div);
  println("rotaciones");
  println(rotaciones);
  for (int i=0; i<div; i++) {
      println(i);
      println(rotaciones*float(i));

    vectores[i] = coord_polar(rad, rotaciones*float(i));
  }
    println("vectores");
    printArray(vectores);

  return vectores;
}

PVector [] listCoordPoligono(int rad, int div,float offAngle) {
  PVector []  vectores = new PVector[div] ;
  float rotaciones=TAU/float(div);
  println("rotaciones");
  println(rotaciones);
  for (int i=0; i<div; i++) {
      println(i);
      println(rotaciones*float(i));

    vectores[i] = coord_polar(rad, rotaciones*float(i)+offAngle);
  }
    println("vectores");
    printArray(vectores);

  return vectores;
}
