#include <stdio.h>

// Echo inspired by Nim but functionally slightly different
void c_echo(const char *s) {
    fputs(s, stdout);
    fflush(stdout);
}

// Say is inspired by Perl
void c_say(const char *s) {
    fputs(s, stdout);
    fputc('\n', stdout);
}
