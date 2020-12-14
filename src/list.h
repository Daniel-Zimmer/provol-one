#ifndef LIST_H
#define LIST_H

#define LIST_INIT_CAPACITY 16

typedef struct list List;

List *LIST_create();
List *LIST_push(List *s, void* val);
void *LIST_pop(List *s);
int   LIST_len(List *s);

#endif // LIST_H