#include "list.h"

#include <stdio.h>
#include <stdlib.h>

struct list {
	int len;
	int capacity;
	void *data[];
};

List *LIST_create() {
	List *s = malloc(sizeof(struct list) + sizeof(void *) * INIT_CAPACITY);

	s->len = 0;
	s->capacity = LIST_INIT_CAPACITY;

	return s;
}

List *LIST_push(List *s, void* val) {
	if (s->len == s->capacity) {
		s->capacity <<= 1;
		s = realloc(s, sizeof(struct list) + sizeof(void *) * s->capacity);
	}

	s->data[s->len++] = val;

	return s;
}

void *LIST_pop(List *s) {
	return s->data[--s->len];
}

int LIST_len(List *s) { return s->len; };
