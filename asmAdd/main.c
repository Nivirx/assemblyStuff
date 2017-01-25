#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


extern uint64_t asmAdd(uint64_t a, uint64_t b);

int main() {

	uint64_t a = 25;
	uint64_t b = 15;
	uint64_t c = asmAdd(a, b);
	printf("%d + %d = %d\n", a, b, c);
	return 0;
}
