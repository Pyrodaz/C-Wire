CC = gcc
CFLAGS = -Wall -Wextra

SRCS=$(wildcard *.c)
OBJS=$(SRCS:.c=.o)
DEPS=$(wildcard *.h) 
EXEC = main

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ 
	rm -f $(OBJS) 

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(EXEC)



