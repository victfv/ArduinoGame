#include "controller.hpp"
#include <LiquidCrystal.h>

ControllerElement analog1(CTR_ANALOG2);
ControllerElement button1(CTR_DIGITAL);
ControllerElement brk(CTR_DIGITAL);
//ControllerElement button2(CTR_DIGITAL);
ControllerElement pot(CTR_ANALOG1);

const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  pinMode(7, INPUT);
  pinMode(9, INPUT);
  pinMode(8, OUTPUT);
  Serial.begin(74880);
  Serial.setTimeout(1);
  lcd.begin(16, 2);
  lcd.print("H:");
  lcd.setCursor(6, 0);
  lcd.print("N:");
  lcd.setCursor(0, 1);
  lcd.print("C:");
  lcd.setCursor(7, 1);
  lcd.print("S:");
}

bool once0 = false;
bool once1 = false;
int ar0 = -5;
int ar1 = -5;
int pot0 = 0;

bool buzzerOn = true;
bool bonOnce = false;
unsigned long cntr = 0;
int beepState = 0;

//String rec = "200";

uint8_t flash = 255;
float timer = 0;

void loop() 
{
  StatusReader::readStatus();

  if (abs(ar0 - analogRead(A0)) > 10 || abs(ar1 - analogRead(A1)) > 10)
  {
    ar0 = analogRead(A0);
    ar1 = analogRead(A1);
    analog1.sendData(ar1, ar0);
  }

  bool btn = digitalRead(7) == HIGH;
  if (btn && !once0)
  {
    button1.sendData(int(btn));
    brk.sendData(int(!btn));
    once0 = true;
  }
  if (!btn)
  {
    button1.sendData(btn);
    brk.sendData(int(!btn));
    once0 = false;
  }

  int potP = analogRead(A2);
  if (potP != pot0)
  {
    pot0 = potP;
    pot.sendData(pot0);
  }
  /*if (digitalRead(3) == HIGH && !once1)
  {
    button2.sendData(digitalRead(3));
    once1 = true;
  }
  if (once1 && digitalRead(3) == LOW)
  {
    button2.sendData(digitalRead(3));
    once1 = false;
  }*/

  //timer += (255.0 - float(StatusReader::getHealth())) / 3000.0;
  //flash = max(int(sin(timer) * 255), max(StatusReader::getHealth(), 5));

  //analogWrite(5, flash);

  //delay(5);
  //digitalWrite(5, HIGH);
  //rec = Serial.readString();
  //Serial.print(rec);
  //analogWrite(5, rec.toInt());;
  int health = StatusReader::getHealth()/10;
  if (health < 100)
  {
    lcd.setCursor(4, 0);
    lcd.print(" ");
    if (health < 10)
    {
      lcd.setCursor(3, 0);
      lcd.print(" ");
    }
  }


  float spd = float(StatusReader::getSpeed()) / 1000.0;
  /*lcd.setCursor(11, 0);
  lcd.print(" ");
  if (spd < 10)
  {
    lcd.setCursor(10, 0);
    lcd.print(" ");
  }*/

  if (health < 10 && buzzerOn)
  {
    switch(beepState)
    {
      case 0:
        cntr = millis();
        digitalWrite(8, HIGH);
        beepState = 1;
        break;
      case 1:
        if (millis() - cntr > 100)
        {
          cntr = millis();
          digitalWrite(8, LOW);
          beepState = 2;
        }
        break;
      case 2:
        if (millis() - cntr > 300)
        {
          beepState = 0;
        }
    }
  }
  else
  {
    digitalWrite(8, LOW);
  }

  if (digitalRead(9) == HIGH)
  {
    if (!bonOnce)
    {
      buzzerOn = !buzzerOn;
      bonOnce = true;
    }
  }
  else
  {
    bonOnce = false;
  }

  lcd.setCursor(2, 0);
  lcd.print(health);

  lcd.setCursor(8, 0);
  lcd.print(StatusReader::getEnergy());

  lcd.setCursor(2, 1);
  lcd.print(StatusReader::getCargo());

  lcd.setCursor(9, 1);
  lcd.print(spd);

  lcd.setCursor(12, 0);
  lcd.print((float(potP)/1023.0) * 2.0 - 1.0);
}
