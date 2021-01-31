#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <io.h>
#define TELEM_BASE 0x00081040
#define SERVO_BASE 0x00081020
#include "system.h"

int main()
{
	unsigned i = 0;
	unsigned direction = 1;
	IOWR(SERVO_BASE, 0, 0);
	unsigned tableau[181];

	usleep(100);
  while(1){

	  usleep(100);

	  if(direction)
		  i++;
	  else
		  i--;

	  if(i == 84960 || i == 0)
		  direction = !direction;

	  if(!(i%472)){
		  unsigned read = IORD(TELEM_BASE, 0);
		  tableau[(int)(i/472)] = read & 255;
	  }

	  if(i == 84960){
		  printf("\n\nRadar:\n");
		  printf("[%03d]\n", tableau[0]);
		  for(int a = 0; a<10; a++){
			  printf("[%03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d, %03d]\n",
					  tableau[a*18+1], tableau[a*18+2], tableau[a*18+3], tableau[a*18+4], tableau[a*18+5], tableau[a*18+6], tableau[a*18+7], tableau[a*18+8], tableau[a*18+9], tableau[a*18+10], tableau[a*18+11], tableau[a*18+12], tableau[a*18+13], tableau[a*18+14], tableau[a*18+15], tableau[a*18+16], tableau[a*18+17], tableau[a*18+18]);
		  }

	  }
	  IOWR(SERVO_BASE, 0, i);

  }
  return 0;
}