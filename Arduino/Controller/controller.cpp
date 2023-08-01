#include "Arduino.h"
#include "controller.hpp"

int ControllerElement::cIndex = 0;
int StatusReader::health = 0;
int StatusReader::energy = 0;
int StatusReader::cargo = 0;
int StatusReader::throttle = 0;
int StatusReader::speed = 0;

ControllerElement::ControllerElement(celType type)
{
	this->index = cIndex;
  cIndex += 1;
	this->type = type;
}

void ControllerElement::sendData(int dataA, int dataB, int dataC)
{
  char buffer[32];
  char intBuff[8];
  
  while (Serial.availableForWrite() < 32)
  {
    
  }

  sprintf(buffer, "I:%dT:%dA:%dB:%dC:%d", index, type, dataA, dataB, dataC);

  Serial.println(buffer);

}

void StatusReader::readStatus()
{
  if (Serial.available() > 0)
  {
    //unsigned long millisStart = millis();
    char buff[32];
    String iBuff = "";
    int read = Serial.readBytesUntil('\0', buff, 32);
    int stage = 0;
    for (int i = 0; i < read; i++)
    {
      if (buff[i] == ':')
      {
        int val = iBuff.toInt();
        switch(stage)
        {
          case 0:
            health = val;
            break;
          case 1:
            energy = val;
            break;
          case 2:
            cargo = val;
            break;
          case 3:
            throttle = val;
          case 4:
            speed = val;
        }
        stage += 1;
        iBuff = "";
      }
      else if (buff[i] >= '0' && buff[i] <= '9')
      {
        iBuff += buff[i];
      }
    }
  }
}
int StatusReader::getHealth()
{
  return health;
}
int StatusReader::getEnergy()
{
  return energy;
}
int StatusReader::getCargo()
{
  return cargo;
}

int StatusReader::getThrottle()
{
  return throttle;
}
int StatusReader::getSpeed()
{
  return speed;
}