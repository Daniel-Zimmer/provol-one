#ifndef LIST_H
#define LIST_H

#define LIST_INIT_CAPACITY 16

typedef struct list List;

List *LIST_create();

List *LIST_push(List *l, void* val);
void *LIST_pop(List *l);
void *LIST_get(List *l, unsigned int i);
void  LIST_set(List *l, unsigned int i, void *val);
void  LIST_delete(List *l);
int   LIST_len(List *l);

#endif // LIST_H