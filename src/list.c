#include "list.h"

#include <stdlib.h>

struct list {
	int len;
	int cap;
	void *data[];
};

List *LIST_create() {
	List *l = malloc(sizeof(struct list) + sizeof(void *) * LIST_INIT_CAPACITY);

	l->len = 0;
	l->cap = LIST_INIT_CAPACITY;

	return l;
}

List *LIST_push(List *l, void* val) {
	if (l->len == l->cap) {
		l->cap <<= 1;
		l = realloc(l, sizeof(struct list) + sizeof(void *) * l->cap);
	}

	l->data[l->len++] = val;

	return l;
}

void *LIST_pop(List *l) {
	return l->data[--l->len];
}

void *LIST_get(List *l, unsigned int i) {
	if (i < l->len) {
		return l->data[i];
	}
	return NULL;
}

void LIST_set(List *l, unsigned int i, void *val) {
	if (i < l->len) {
		l->data[i] = val;
	}
}

void LIST_delete(List *l) {
	free(l);
}

int LIST_len(List *l) { return l->len; };
