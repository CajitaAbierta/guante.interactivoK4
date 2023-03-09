#include <esp_now.h>
#include <WiFi.h>
#include <Wire.h>
#include "I2Cdev.h"
#include "MPU6050.h"
#include <Chrono.h>


#define ID 0
#define ESPERA_ENTRE_ENVIOS 125
#define ESPERA_ENTRE_LECTURA_GYRO 125
#define ESPERA_PULSADOR 100
#define F 0.98
#define UMBRAL_FLEX 1500
#define PIN_PULSADOR 34
#define PIN_FLEX_A 35

#define MIN_FLEX 1700
#define MAX_FLEX 4064
#define MIN_GYRO -800
#define MAX_GYRO 800
#define MIN_ACC -20000
#define MAX_ACC 20000

#define CHANNEL 0

#define DEBUG 1 //comentar debug para que no se imprima 
#include "DebugUtils.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
#include "Wire.h"
#endif

MPU6050 accelgyro;
//data para el sensor de flexión
int sensorPin = 34;
int sensorFlex;
float umbral = 0;
float f = 0.98;

// REPLACE WITH YOUR ESP RECEIVER'S MAC ADDRESS
uint8_t broadcastAddress[] = {0X30, 0XC6, 0XF7, 0X29, 0X5F, 0X5C};


int16_t ax, ay, az;
int16_t gx, gy, gz;
// Structure example to send data
// Must match the receiver structure
Chrono cronometroEnvio;
Chrono cronometroBoton;
Chrono cronometroLecturaGyro;


typedef struct struct_message {
  int id; // must be unique for each sender board
  int Ax;
  int Ay;
  int Az;
  int Gx;
  int Gy;
  int Gz;
  int flex;
  bool pulsador;
} struct_message;

typedef struct val_amortiguar {

  float Ax;
  float Ay;
  float Az;
  float Gx;
  float Gy;
  float Gz;
  float flex;
};
val_amortiguar amortiguaciones;

// Create a struct_message called BME280Readings to hold sensor readings
struct_message MPUReadings;

// Create a struct_message called myData
struct_message myData;

// Create peer interface
esp_now_peer_info_t peerInfo;

// callback when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  DEBUG_PRINTLN("Last Packet Sent to: ");
  DEBUG_PRINTLN(macStr);
  DEBUG_PRINT("\r\nLast Packet Send Status:\t");
  DEBUG_PRINTLN(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

void setup(void) {
  // Init Serial Monitor
  Serial.begin(115200);
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.begin();
#elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
  Fastwire::setup(400, true);
#endif

  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  // Init ESP-NOW
  DEBUG_PRINT(("STA MAC: ")); DEBUG_PRINTLN(WiFi.macAddress());
  //  DEBUG_PRINT("AP MAC: "); DEBUG_PRINTLN(WiFi.softAPmacAddress());
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Trasnmitted packet
  esp_now_register_send_cb(OnDataSent);

  // Register peer
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  // Add peer
  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Failed to add peer");
    return;
  }

  // initialize device
  Serial.println("Initializing I2C devices...");
  accelgyro.initialize();

  // verify connection
  Serial.println("Testing device connections...");
  Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
  myData.id = ID;

  pinMode(PIN_PULSADOR, INPUT);

}

void loop() {
  if (cronometroLecturaGyro.hasPassed(ESPERA_ENTRE_LECTURA_GYRO))//rspera de un siguiente pulso cada n° tiempo
  {
    // read raw accel/gyro measurements from device
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);


    /* Display the results (acceleration is measured in m/s^2) */
    DEBUG_PRINT("\t\tAccel X: ");
    DEBUG_PRINT(ax);
    DEBUG_PRINT(" \tY: ");
    DEBUG_PRINT(ay);
    DEBUG_PRINT(" \tZ: ");
    DEBUG_PRINT(az);
    DEBUG_PRINTLN(" m/s^2 ");

    /* Display the results (rotation is measured in rad/s) */
    DEBUG_PRINT("\t\tGyro X: ");
    DEBUG_PRINT(gx);
    DEBUG_PRINT(" \tY: ");
    DEBUG_PRINT(gy);
    DEBUG_PRINT(" \tZ: ");
    DEBUG_PRINT(gz);
    DEBUG_PRINTLN(" radians/s ");
    DEBUG_PRINTLN();

    amortiguaciones.Ax = ax * (1. - F) + amortiguaciones.Ax * F;
    amortiguaciones.Ay = ay * (1. - F) + amortiguaciones.Ay * F;
    amortiguaciones.Az = az * (1. - F) + amortiguaciones.Az * F;
    amortiguaciones.Gx = gx * (1. - F) + amortiguaciones.Gx * F;
    amortiguaciones.Gy = gy * (1. - F) + amortiguaciones.Gy * F;
    amortiguaciones.Gz = gz * (1. - F) + amortiguaciones.Gz * F;

    myData.Ax = map(amortiguaciones.Ax, MIN_ACC, MAX_ACC, 0, 127);
    myData.Ay = map(amortiguaciones.Ay, MIN_ACC, MAX_ACC, 0, 127);
    myData.Az = map(amortiguaciones.Az, MIN_ACC, MAX_ACC, 0, 127);
    myData.Gx = map(amortiguaciones.Gx, MIN_GYRO, MAX_GYRO, 0, 127);
    myData.Gy = map(amortiguaciones.Gy, MIN_GYRO, MAX_GYRO, 0, 127);
    myData.Gz = map(amortiguaciones.Gz, MIN_GYRO, MAX_GYRO, 0, 127);
    cronometroLecturaGyro.restart();

  }
  //--------flex---------
  int sensorFlex = analogRead(PIN_FLEX_A);

  amortiguaciones.flex = sensorFlex * (1 - F) + amortiguaciones.flex * F;

  myData.flex = map(amortiguaciones.flex, MIN_FLEX, MAX_FLEX, 0, 127);

  //--------boton---------
  bool lecturaPulsador = digitalRead(PIN_PULSADOR);

  myData.pulsador = lecturaPulsador;
  /*
    if (cronometroBoton.hasPassed(ESPERA_PULSADOR))//rspera de un siguiente pulso cada n° tiempo
    {
      bool lecturaPulsador = !digitalRead(PIN_PULSADOR);
      myData.pulsador = lecturaPulsador;
      if (lecturaPulsador) { //resetea el cronometro si fue pulsado
        cronometroBoton.restart();
      }

    }
  */
  //-----------------------------------------------------
  //-------ENVIO-------ENVIO-------ENVIO-------ENVIO-----
  //-----------------------------------------------------
  if (cronometroEnvio.hasPassed(ESPERA_ENTRE_ENVIOS))
  {
    // Send message via ESP-NOW
    esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &myData, sizeof(myData));

    if (result == ESP_OK) {
      DEBUG_PRINTLN("Success");
    } else if (result == ESP_ERR_ESPNOW_NOT_INIT) {
      // How did we get so far!!
      DEBUG_PRINTLN("ESPNOW not Init.");
    } else if (result == ESP_ERR_ESPNOW_ARG) {
      DEBUG_PRINTLN("Invalid Argument");
    } else if (result == ESP_ERR_ESPNOW_INTERNAL) {
      DEBUG_PRINTLN("Internal Error");
    } else if (result == ESP_ERR_ESPNOW_NO_MEM) {
      DEBUG_PRINTLN("ESP_ERR_ESPNOW_NO_MEM");
    } else if (result == ESP_ERR_ESPNOW_NOT_FOUND) {
      DEBUG_PRINTLN("Peer not found.");
    } else {
      DEBUG_PRINTLN("Not sure what happened");
    }

    cronometroEnvio.restart(); // restart the crono so that it triggers again later

    //-----------------------------------------------------
    //-------DEBUG-------DEBUG-------DEBUG-------DEBUG-----
    //-----------------------------------------------------
    DEBUG_PRINT("X= ");
    DEBUG_PRINTLN(myData.Ax);
    DEBUG_PRINT("Y= ");
    DEBUG_PRINTLN(myData.Ay);
    DEBUG_PRINT("Z= ");
    DEBUG_PRINTLN(myData.Az);
    DEBUG_PRINTLN();
    DEBUG_PRINT("X= ");
    DEBUG_PRINTLN(myData.Gx);
    DEBUG_PRINT("Y= ");
    DEBUG_PRINTLN(myData.Gy);
    DEBUG_PRINT("Z= ");
    DEBUG_PRINTLN(myData.Gz);
    DEBUG_PRINTLN();
    DEBUG_PRINT("FLEX= ");
    DEBUG_PRINTLN(myData.flex);
    DEBUG_PRINTLN();
    DEBUG_PRINT("PULSADOR= ");
    DEBUG_PRINTLN(myData.pulsador);
    DEBUG_PRINTLN();
  }


}
