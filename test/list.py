from ctypes import *
from random import randint

class List(Structure):
	_fields_ = [('len', c_int), ('cap', c_int), ('elems', c_void_p)]

	def __repr__(self):
		s = "len:  %d\ncap:  %d\n" % (self.len, self.cap)

		return s

libc = CDLL("./list.so")

libc.LIST_create.argtypes = None
libc.LIST_create.restype = POINTER(List)

libc.LIST_push.argtypes = [POINTER(List), c_void_p]
libc.LIST_push.restype = POINTER(List)

libc.LIST_pop.argtypes = [POINTER(List)]
libc.LIST_pop.restype = c_void_p

libc.LIST_get.argtypes = [POINTER(List), c_int]
libc.LIST_get.restype = c_void_p


libc.LIST_delete.argtypes = [POINTER(List), c_void_p]
libc.LIST_delete.restype = None

libc.LIST_len.argtypes = [POINTER(List)]
libc.LIST_len.restype = c_int

pyl = []

print("Creating List")
l = libc.LIST_create()
print(l.contents)

steps = 10000

print("Pushing, Getting and Popping")
correct = 0
total = 0
for _ in range(steps):
	opCount = randint(1, 100)
	for _ in range(opCount):
		val = randint(1, (1<<64) - 1)
		l = libc.LIST_push(l, val)
		pyl.append(val)

	for _ in range(randint(1, 100)):
		index = randint(0, libc.LIST_len(l) - 1)
		expected = pyl[index]
		actual = libc.LIST_get(l, index)
		total += 1
		if expected != actual:
			print("failed! actual: %d; expected %d" % (actual, expected))
		else:
			correct +=1

	opCount = randint(1, len(pyl)//30 + 1)
	for _ in range(opCount):
		expected = pyl.pop()
		actual = libc.LIST_pop(l)
		total += 1
		if expected != actual:
			print("failed! actual: %d; expected %d" % (actual, expected))
		else:
			correct +=1



	print("\r(%d/%d)" % (correct, total), end=" ")

print()

print(l.contents)

print("Popping until empty")
correct = 0
total = 0
while (libc.LIST_len(l) != 0):
	expected = pyl.pop()
	actual = libc.LIST_pop(l)
	total += 1
	if expected != actual:
		print("failed! actual: %d; expected %d" % (actual, expected))
	else:
		correct +=1
	print("\r(%d/%d)" % (correct, total), end=" ")
print()

print(l.contents)

print("Deleting queue")
libc.LIST_delete(l, None)
print("ok")
