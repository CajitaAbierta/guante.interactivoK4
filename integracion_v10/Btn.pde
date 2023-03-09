class Btn {
  /*
  Clase 
   */

  PGraphics regiones; //podria omiti regiones y umbral en el caso de no modificar con invert
  PImage img, imgAlt;//, umbral
  int x, y, w, h;
  boolean onOff, boundBox=false, estadoAnterior;

  //Btn(PImage img_, PImage umbral_, int x_, int y_) {
  //        regiones = createGraphics(width, height);

  //  //por ref
  //  img=img_;
  //  umbral=umbral_;
  //  x=x_;
  //  y=y_;
  //  w=umbral.width;
  //  h=umbral.height;
  //  regiones.beginDraw();
  //  regiones.image(umbral, x, y, w, h);
  //  regiones.endDraw();
  //}
  //Btn(String pathImg, String pathUmbral, int x_, int y_) {
  //    regiones = createGraphics(width, height);

  //  img=loadImage(pathImg);
  //  umbral=loadImage(pathUmbral);
  //  x=x_;
  //  y=y_;
  //  w=umbral.width;
  //  h=umbral.height;
  //  regiones.beginDraw();
  //  regiones.image(umbral, x, y, w, h);
  //  regiones.endDraw();
  //  onOff=false;
  //}
  Btn(String pathImg, int x_, int y_) {
    regiones = createGraphics(width, height);

    img=loadImage(pathImg);
    x=x_-img.width/2;//centrarlo sin cambiar las coord
    y=y_-img.height/2;
    w=img.width;
    h=img.height;
    regiones.beginDraw();
    regiones.image(img, x, y, w, h);
    regiones.endDraw();
    onOff=false;
    estadoAnterior=false;
  } 
  Btn(String pathImg, float x_, float y_) {
    regiones = createGraphics(width, height);

    img=loadImage(pathImg);
    x=int(x_);
    y=int(y_);
    w=img.width;
    h=img.height;
    regiones.beginDraw();
    regiones.image(img, x, y, w, h);
    regiones.endDraw();
    onOff=false;
    estadoAnterior=false;
  }

  Btn(String pathImg, int x_, int y_, boolean boundBox_) {
    regiones = createGraphics(width, height);

    img=loadImage(pathImg);
    x=x_-img.width/2;//centrarlo sin cambiar las coord
    y=y_-img.height/2;
    w=img.width;
    h=img.height;
    regiones.beginDraw();
    regiones.image(img, x, y, w, h);
    regiones.endDraw();
    onOff=false;
    estadoAnterior=false;
    boundBox=boundBox_;
  } 
  Btn(String pathImg, float x_, float y_, boolean boundBox_) {
    regiones = createGraphics(width, height);

    img=loadImage(pathImg);
    x=int(x_);
    y=int(y_);
    w=img.width;
    h=img.height;
    regiones.beginDraw();
    regiones.image(img, x, y, w, h);
    regiones.endDraw();
    onOff=false;
    estadoAnterior=false;
    boundBox=boundBox_;
  }
  Btn(String pathImg, String pathAlt, float x_, float y_) {
    regiones = createGraphics(width, height);

    img=loadImage(pathImg);
    imgAlt=loadImage(pathAlt);
    x=int(x_-img.width/2);
    y=int(y_-img.height/2);
    w=img.width;
    h=img.height;
    regiones.beginDraw();
    regiones.image(img, x, y, w, h);
    regiones.endDraw();
    onOff=false;
    estadoAnterior=false;
  }
  void display()
  {
    pushStyle();
    // imageMode(CENTER);
    if (onOff)
    {
      if (imgAlt==null) {
        PImage imgInvert=img.copy();
        imgInvert.filter(INVERT);
        image(imgInvert, x, y, imgInvert.width, imgInvert.height);
        // image(imgInvert, x, y, w, h);
      } else
      {
        image(imgAlt, x, y, imgAlt.width, imgAlt.height);
        // image(imgAlt, x, y, w, h);
      }
    } else
    {
      image(img, x, y, img.width, img.height);
      // image(img, x, y, w, h);
    }

    popStyle();
  }
  void update(){
  estadoAnterior=onOff;
  }
  PImage getImg() {
    return img;
  }
  void setState(boolean b)
  {
    onOff=b;
  }
  void toggle() {
    onOff=!onOff;
  }
 
  void onClicked() {
   // if (mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h) {
     if(this.isInBounds()){
     //if (brightness(regiones.get(mouseX, mouseY))==0) img.filter(INVERT);
      //if (alpha(regiones.get(mouseX, mouseY))==255) { 
      //PrintlnIzq(brightness(img.get(mouseX, mouseY)));
      //PrintlnIzq(alpha(img.get(mouseX, mouseY)));
      if (boundBox) {
        onOff=!onOff;
      } else if (alpha(regiones.get(mouseX, mouseY))==255) { 

        ///if (brightness(img.get(mouseX, mouseY))==0) { 
        //img.filter(INVERT);
        //PrintlnIzq(onOff);
        onOff=!onOff;
      }
      //o en vez de invertir un btn agregarle otra img
    }
  }
  boolean isOn() {
    return onOff;
  }
  boolean isChange() {
    return (estadoAnterior!=onOff);
  }  
  boolean isInBounds(){
      return (mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h) ;
  }
};
