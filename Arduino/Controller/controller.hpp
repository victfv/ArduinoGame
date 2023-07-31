#ifndef CONTROLLER_EL_HPP
#define CONTROLLER_EL_HPP

#include <string.h>

enum celType {CTR_DIGITAL, CTR_ANALOG1, CTR_ANALOG2, CTR_ANALOG3};

class ControllerElement
{
  public:
    ControllerElement(celType type);
	void sendData(int dataA = 0, int dataB = 0, int dataC = 0);
  protected:
	static int cIndex;
  private:
	int index;
	celType type;
};

class StatusReader
{
  public:
      StatusReader();
    static void readStatus();
    static int getHealth();
    static int getEnergy();
    static int getCargo();
  
  protected:
    static int health;
    static int energy;
    static int cargo;

};

#endif