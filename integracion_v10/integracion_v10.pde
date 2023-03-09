
/**
 GUI_MIDI_Serial
 Created:  2022/09/12
 Version: 1.10
 Authors: Pau Singla Lezcano   ,  Santiago Fernandez
 Contact: pausingla@gmail.com  ,  stfg.prof@gmail.com
 
 Description: Graphical interface for Sketch that allows
 to turn on/off the reception of messages on the Serial port
 and transform them into MIDI messages.
 **/



import processing.serial.*;
import SerialUntref.*;
SerialUntref sUntref;
Serial serial;
import themidibus.*; //Import the library
import lord_of_galaxy.timing_utils.*;


Stopwatch s;//Declare
//long tiempoEspera=5000;//5seg en millis
//long marcaTiempo=0;
long marcaTiempoFlexIzq=0;
long marcaTiempoFlexDer=0;

long tiempoEsperaFlexIzq=200;
long tiempoEsperaFlexDer=200;

long tiempoActual;

Btn piton;
Btn btnIzqAX, btnIzqAY, btnIzqAZ, btnIzqGX;
Btn btnIzqGY, btnIzqGZ, btnIzqPulsador, btnIzqFlex;
Btn izqFlex, iqzPulsador;

Btn btnDerAX, btnDerAY, btnDerAZ, btnDerGX;
Btn btnDerGY, btnDerGZ, btnDerPulsador, btnDerFlex;
Btn derFlex, derPulsador;

Slider slider;
PImage imgPj;
int wBtn=50;
int  hBtn=100;

//posicion btns
int  manoIzqX=136;
int  manoIzqY=150;
int  manoDerX=580;
int  manoDerY=205;

int offstetPichaX=-25;
int offstetPichaY=18;

color colTxt =color(255, 255, 255);
color colBg ; //inicializada en el setup por q esta en HSB
//val para texto
int txtIzqX=50, txtIzqY=20, txtDerX=550, txtDerY=20;
int tamFont=24;
int limChar=9;

StringList consolaIzq, consolaDer;

//int nro = 0; //esto es del ej de seirialStrinProcessing UNTREF - sirve para printeat cuantos msj se recibieron
MidiBus myBus; // The MidiBus
int id[]={0, 1};
int ax[]={0, 1}, ay[]={0, 1}, az[]={0, 1}, gx[]={0, 1}, gy[]={0, 1}, gz[]={0, 1};
int flex[]={0, 1};
boolean boton[]={false, false};
boolean estadoAnteriorFlexIzq=true, estadoAnteriorFlexDer=true;
boolean estadoFlexIzq=true, estadoFlexDer=true;
boolean estadoBtn=false;
boolean estadoAnteriorBtn=false;

int valorSend;
void setup()
{
  //initialize window
  surface.setTitle("PhantomHand™");
  PImage icon = loadImage("icono.png");
  surface.setIcon(icon);
  size(800, 400);

  pushStyle();
  colorMode(HSB);
  colBg =color(25, 100, 175);
  popStyle();

  //imgPj=loadImage("deliriumDetail.png");
  imgPj=loadImage("deliriumDetailSensa.png");

  //GUI
  //esto en un futuro deveria ser agregar a un array o a un map dentro de la clase gui!!

  PVector [] vec=listCoordPoligono(100, 8, HALF_PI);//esto no ciera
  //IZQ
  btnIzqAX=new Btn("ax.png", vec[0].x+manoIzqX, vec[0].y+manoIzqY, true);
  btnIzqAY=new Btn("ay.png", vec[1].x+manoIzqX, vec[1].y+manoIzqY, true);
  btnIzqAZ=new Btn("az.png", vec[2].x+manoIzqX, vec[2].y+manoIzqY, true);
  btnIzqGX=new Btn("gx.png", vec[3].x+manoIzqX, vec[3].y+manoIzqY, true);
  btnIzqGY=new Btn("gy.png", vec[4].x+manoIzqX, vec[4].y+manoIzqY, true);
  btnIzqGZ=new Btn("gz.png", vec[5].x+manoIzqX, vec[5].y+manoIzqY, true);
  btnIzqFlex=new Btn("flex.png", vec[6].x+manoIzqX, vec[6].y+manoIzqY, true);
  btnIzqPulsador=new Btn("btn.png", vec[7].x+manoIzqX, vec[7].y+manoIzqY, true);

  //DER
  btnDerAX=new Btn("ax.png", vec[0].x+manoDerX, vec[0].y+manoDerY, true);
  btnDerAY=new Btn("ay.png", vec[1].x+manoDerX, vec[1].y+manoDerY, true);
  btnDerAZ=new Btn("az.png", vec[2].x+manoDerX, vec[2].y+manoDerY, true);
  btnDerGX=new Btn("gx.png", vec[3].x+manoDerX, vec[3].y+manoDerY, true);
  btnDerGY=new Btn("gy.png", vec[4].x+manoDerX, vec[4].y+manoDerY, true);
  btnDerGZ=new Btn("gz.png", vec[5].x+manoDerX, vec[5].y+manoDerY, true);
  btnDerFlex=new Btn("flex.png", vec[6].x+manoDerX, vec[6].y+manoDerY, true);
  btnDerPulsador=new Btn("btn.png", vec[7].x+manoDerX, vec[7].y+manoDerY, true);

  piton=new Btn("pizeta.png", width/2+offstetPichaX, height/2+offstetPichaY, true);


  consolaIzq= new StringList();
  consolaDer= new StringList();
  textSize(tamFont);

  //Comunication
  println(Serial.list());
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 115200);
  sUntref = new SerialUntref();
  MidiBus.list();

  myBus = new MidiBus(this, -1, 6);

  //Creating a stopwatch to keep time
  s = new Stopwatch(this);

  //Start the stopwatch
  s.start();
  marcaTiempoFlexIzq=s.time();
  marcaTiempoFlexDer=s.time();

  //for (int i =0; i<limChar; i++) {
  //  PrintlnIzq("testeando IZQ");
  //  PrintlnDer("testeando DER");
  //}
}
void draw()
{
  tiempoActual= s.time();
  //UNTREF SERIAL COMUNICATION


  //en teoria no hace falta reenviar la data por eso lo comento
  sUntref.newPackage();
  //acel
  sUntref.addInt(sUntref.getInt(0));
  sUntref.addInt(sUntref.getInt(1));
  sUntref.addInt(sUntref.getInt(2));
  //giro
  sUntref.addInt(sUntref.getInt(3));
  sUntref.addInt(sUntref.getInt(4));
  sUntref.addInt(sUntref.getInt(5));
  //sensor flex
  sUntref.addInt(sUntref.getInt(6));
  //boton activo
  sUntref.addBool(sUntref.getBool(7));

  // sUntref.addFloat(sUntref.getFloat(6));
  sUntref.endPackage();
  for (int i = 0; i < sUntref.dataOutSize; i++) {
    serial.write(sUntref.getDataOut(i));
  }

  int tempId=0;
  while ( serial.available() > 0) {  // If data is available,
    int a = serial.read();
    if (sUntref.newDataIn(a)) {
      tempId=sUntref.getInt(0);
      id[tempId]=tempId;
      ax[tempId]=sUntref.getInt(1);
      ay[tempId]=sUntref.getInt(2);
      az[tempId]=sUntref.getInt(3);
      gx[tempId]=sUntref.getInt(4);
      gy[tempId]=sUntref.getInt(5);
      gz[tempId]=sUntref.getInt(6);
      flex[tempId]=sUntref.getInt(7);
      boton [tempId]= sUntref.getBool(8);
      //nro++;
      if (tempId== 0) {
        PrintlnIzq("iZqUiErDa");
        PrintlnIzq("Id: " +id[tempId]);
        PrintlnIzq("Ax: " + ax[tempId]);
        PrintlnIzq("Ay: " + ay[tempId]);
        PrintlnIzq("Az: " + az[tempId]);
        PrintlnIzq("Gx: " + gx[tempId]);
        PrintlnIzq("Gy: " + gy[tempId]);
        PrintlnIzq("Gz: " + gz[tempId]);
        PrintlnIzq("Flex, no picolini: " + flex[tempId]);
        PrintlnIzq("Pulsador: " + boton[tempId]);
      } else if (tempId==1) {
        PrintlnDer("DeReChA");
        PrintlnDer("Id: " +id[tempId]);
        PrintlnDer("Ax: " + ax[tempId]);
        PrintlnDer("Ay: " + ay[tempId]);
        PrintlnDer("Az: " + az[tempId]);
        PrintlnDer("Gx: " + gx[tempId]);
        PrintlnDer("Gy: " + gy[tempId]);
        PrintlnDer("Gz: " + gz[tempId]);
        PrintlnDer("Flex, no picolini: " + flex[tempId]);
        PrintlnDer("Pulsador: " + boton[tempId]);
      }
    }
  }



  //------------------------------------------------------------------------------------------------------------------------------
  //Esto es lo que necesito activar desactivar cuando se pulse la flechita del mapeo en la interfaz
  //MIDI MANO IZQUIERDA

  // ACELEROMETRO Y GIROSCOPIO

  if (btnIzqAX.isOn())
  {
    myBus.sendControllerChange(1, 60, ax[0]);
  }
  if (btnIzqAY.isOn())
  {

    myBus.sendControllerChange(1, 61, ay[0]);
  }
  if ( btnIzqAZ.isOn())
  {

    myBus.sendControllerChange(1, 62, az[0]);
  }
  if (btnIzqGX.isOn())
  {

    myBus.sendControllerChange(1, 63, gx[0]);
  }
  if (btnIzqGY.isOn())
  {

    myBus.sendControllerChange(1, 64, gy[0]);
  }
  if (btnIzqGZ.isOn())
  {

    myBus.sendControllerChange(1, 65, gz[0]);
  }
  //PULSADOR Y FLEXO

  if (btnIzqPulsador.isOn())
  {
    //programar random seed 0-127 cada vez que bool = 1
  }
  if (btnIzqFlex.isOn())
  {
    float umbralFlex= 20;
    estadoFlexIzq=flex[0] < umbralFlex;
    if (estadoAnteriorFlexIzq!=estadoFlexIzq && estadoFlexIzq) {
      //Programar flex on off note en un umbral
      myBus.sendControllerChange(3, 15, flex[0]);

      // myBus.sendNoteOn(3, 15, 255); // Send a Midi noteOn
      //delay(200); //esto sería el tiempo en el que el flex está por debajo del umbral
    }
    if ( estadoAnteriorFlexIzq!=estadoFlexIzq &&(false == estadoFlexIzq))
    {
      myBus.sendControllerChange(3, 15, 255);

      // myBus.sendNoteOn(3, 15, 0); // Send a Midi noteOn
    }

    estadoAnteriorFlexIzq=estadoFlexIzq;

    //println("estadoFlex");
    //println(estadoFlex);
    //println("estadoAnteriorFlexIzq");
    //println(estadoAnteriorFlexIzq);
  }

  //------------------------------------------------------------------------------------------------------------------------
  //MIDI MANO DERECHA

  if (btnDerAX.isOn())
  {
    myBus.sendControllerChange(2, 70, ax[1]);
  }
  if (btnDerAY.isOn())
  {

    myBus.sendControllerChange(2, 71, ay[1]);
  }
  if ( btnDerAZ.isOn())
  {

    myBus.sendControllerChange(2, 72, az[1]);
  }
  if (btnDerGX.isOn())
  {

    myBus.sendControllerChange(2, 73, gx[1]);
  }
  if (btnDerGY.isOn())
  {

    myBus.sendControllerChange(2, 74, gy[1]);
  }
  if (btnDerGZ.isOn())
  {

    myBus.sendControllerChange(2, 75, gz[1]);
  }
  //PULSADOR Y FLEXO

  if (btnDerPulsador.isOn())
  {

    estadoBtn=boton[1] ;
    if (estadoAnteriorBtn!=estadoBtn && estadoBtn) {
      //Programar flex on off note en un umbral
      println("ONNNNN");
      valorSend= int( random(10));
      myBus.sendNoteOn(5, valorSend, 255); // Send a Midi noteOn
    }
    if ( estadoAnteriorBtn!=estadoBtn &&(false==estadoBtn))
    {
      println("OFFFFF");
      myBus.sendNoteOff(5, valorSend, 255); // Send a Midi noteOn
    }

    estadoAnteriorBtn=estadoBtn;

    //programar random seed 0-127 cada vez que bool = 1

    //myBus.sendNoteOn(3, 60, 255); // Send a Midi noteOn
    //if (tiempoActual>marcaTiempoFlexDer+tiempoEsperaFlexDer)
    //{
    //  myBus.sendNoteOn(3, 60, 255); // Send a Midi noteOff
    //  marcaTiempoFlexDer=tiempoActual;
    //}
  }
  if (btnDerFlex.isOn())
  {
    float umbralFlex=10;
    estadoFlexDer=flex[1] < umbralFlex;
    if (estadoAnteriorFlexDer!=estadoFlexDer && estadoFlexDer) {
      //Programar flex on off note en un umbral
      myBus.sendControllerChange(7, 15, flex[1]);

      // myBus.sendNoteOn(7, 15, 255); // Send a Midi noteOn
      println("ESTAAAAA PRENDIDrOOOO");

      //delay(200); //esto sería el tiempo en el que el flex está por debajo del umbral
    }
    if ( estadoAnteriorFlexDer!=estadoFlexDer &&(false == estadoFlexDer))
    {
      //myBus.sendNoteOn(7, 15, 255); // Send a Midi noteOn
      myBus.sendControllerChange(7, 15, 255);

      println("ESTAAAAA APAGADUUU");
    }

    estadoAnteriorFlexDer=estadoFlexDer;
    println("estadoFlexDer");
    println(estadoFlexDer);
    println("estadoAnteriorFlexDer");
    println(estadoAnteriorFlexDer);
  }



  //GUI

  background(colBg);

  // FAKE CONSOLE
  pushStyle();
  fill(colTxt);

  if (consolaIzq.size()>0) {
    for (int i=0; i< consolaIzq.size(); i++)
    {
      text(consolaIzq.get(i), txtIzqX, 22+textAscent()*i+ txtIzqY);
    }
  }
  if (consolaDer.size()>0) {
    for (int i=0; i< consolaDer.size(); i++)
    {
      text(consolaDer.get(i), txtDerX, 22+textAscent()*i+txtDerY);
    }
  }
  popStyle();
  displayGui();


  //un unico btn con rastreo de cambio de estado:
  piton.update();
}

void mouseClicked() {
  onClickGui();
  if (piton.isChange()) {
    // toggleBtns(); 
    if (piton.isOn()) {
      setBtns(true);
    } else if (!piton.isOn()) {
      setBtns(false);
    }

    println("PITON CAMBIO!");
  }
}
