
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////LIBRERIAS///////LIBRERIAS///////LIBRERIAS///////LIBRERIAS///////LIBRERIAS///////LIBRERIAS///////LIBRERI
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <Chrono.h>
#include <esp_now.h>
#include <WiFi.h>
#include <SerialUntrefEsp.h>


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////DEFINES//////DEFINES//////DEFINES//////DEFINES//////DEFINES//////DEFINES//////DEFINES//////DEFINES//////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define ESPERA_ENTRE_ENVIOS 125
#define CANTIDAD_DE_PLACAS 2
//en caso de que los ides quieras que lleguen del 1 al 3 y no del 0 al 2 dejo un offset pero lo mejor es que las placas funcionen contando desde el 0
#define OFFSET_ID 0   
//#define CHANNEL 0

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////VARIABLES GLOBALES/////VARIABLES GLOBALES//////////VARIABLES GLOBALES//////////VARIABLES GLOBALES////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
Chrono cronometroEnvio;
SerialUntrefEsp sUntref;

//me queda en duda realmente por que enviar float a processing?
typedef struct struct_message {
  int id; // must be unique for each sender board
  int ax;
  int ay;
  int az;
  int gx;
  int gy;
  int gz;
  int flex;
  bool pulsador;
};

struct_message myData;
// Create an array with all the structures
struct_message boardsStruct[CANTIDAD_DE_PLACAS] ;

int puntero=0;

// callback function that will be executed when data is received
void OnDataRecv(const uint8_t * mac_addr, const uint8_t *incomingData, int len) {
//  char macStr[18];
//  // Serial.print("Packet received from: ");
//  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
//           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
//  //Serial.println(macStr);
  memcpy(&myData, incomingData, sizeof(myData));
  //Serial.printf("Board ID %u: %u bytes\n", myData.id, len);
  // Update the structures with the new incoming data
  
  boardsStruct[myData.id].id = myData.id;
  boardsStruct[myData.id].ax = map (myData.ax, 59,63,0,127);
  boardsStruct[myData.id].ay = map (myData.ay, 59,63,0,127);
  boardsStruct[myData.id].az = map (myData.az, 59,63,0,127);
  boardsStruct[myData.id].gx = myData.gx;
  boardsStruct[myData.id].gy = myData.gy;
  boardsStruct[myData.id].gz = myData.gz;
  boardsStruct[myData.id].flex = myData.flex;
  boardsStruct[myData.id].pulsador = myData.pulsador;


//    Serial.printf("");
//    Serial.printf("id value: %d \n",boardsStruct[myData.id].id);
//    Serial.printf("ax value: %d \n",boardsStruct[myData.id].ax);
//    Serial.printf("ay value: %d \n", boardsStruct[myData.id].ay);
//    Serial.printf("az value: %d \n", boardsStruct[myData.id].az);
//    Serial.printf("gx value: %d \n", boardsStruct[myData.id].gx);
//    Serial.printf("gy value: %d \n", boardsStruct[myData.id].gy);
//    Serial.printf("gz value: %d \n", boardsStruct[myData.id].gz);
//   Serial.printf("flex value: %d \n", boardsStruct[myData.id].flex);
//   Serial.printf("flex value: %d \n", boardsStruct[myData.id].pulsador);
//   Serial.println();
}

void setup() {
  //Initialize Serial Monitor
  Serial.begin(115200);

  //Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);
 Serial.print("STA MAC: "); Serial.println(WiFi.macAddress());//
//  Serial.print("AP MAC: "); Serial.println(WiFi.softAPmacAddress());
  //Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info
  esp_now_register_recv_cb(OnDataRecv);

//por las dudas seteo todos los balores a cero salvo el ID
  for(int i=0;i<CANTIDAD_DE_PLACAS;i++){
  boardsStruct[i].id = i;
  boardsStruct[i].ax = 0;
  boardsStruct[i].ay = 0;
  boardsStruct[i].az = 0;
  boardsStruct[i].gy = 0;
  boardsStruct[i].gz = 0;
  boardsStruct[i].flex = 0;
  boardsStruct[i].flex = false;
  }
}

void loop() {


 //esto puede eviarse por paquetes que me parece lo mas logico 
 //o como tren de datos (quzias mas rapido pero complejo de desarmar)
 //ya que en este caso el id lo tiene que identificar processing y lo que hay que evitar es que sarute,
 //los timpos pueden reducirse mucho pero no se cuanta es la exijencia y esa necesidad a mas velocidad mas error
  
  if (cronometroEnvio.hasPassed(ESPERA_ENTRE_ENVIOS))
  {
    sUntref.newPackage();
    sUntref.addInt(boardsStruct[puntero].id + OFFSET_ID); 
    sUntref.addInt(boardsStruct[puntero].ax);
    sUntref.addInt(boardsStruct[puntero].ay);
    sUntref.addInt(boardsStruct[puntero].az);
    sUntref.addInt(boardsStruct[puntero].gx);
    sUntref.addInt(boardsStruct[puntero].gy);
    sUntref.addInt(boardsStruct[puntero].gz);
    sUntref.addInt(boardsStruct[puntero].flex);
    sUntref.addBool(boardsStruct[puntero].pulsador);
    sUntref.endPackage();
    for (int i = 0; i < sUntref.dataOutSize; i++) {
      Serial.write(sUntref.getDataOut(i));
    }

    cronometroEnvio.restart(); // restart the crono so that it triggers again later
    puntero++;
    if(puntero==CANTIDAD_DE_PLACAS)puntero=0;
  }


}
