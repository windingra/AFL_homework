#include <stdio.h>
#include <stdlib.h>

int main() {
  unsigned char b[8] = {0};
  size_t n = fread(b, 1, sizeof(b), stdin);

  if (n > 0 && b[0] == 'F') {
    if (n > 1 && b[1] == 'U') {
      if (n > 2 && b[2] == 'Z') {
        if (n > 3 && b[3] == 'Z') {
          volatile int *p = 0;  // crash
          *p = 1;
        }
      }
    }
  }
  return 0;
}
