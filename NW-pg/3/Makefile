com1:	
	gcc -o server1 server1.c
	gcc -o client1 client1.c
com2:
	gcc -o server2 server2.c
	gcc -o client2 client2.c
start1:
	./server1 &
	./client1 127.0.0.1
start2:
	./server2 &
	./client2 127.0.0.1
send1:
	./client1 127.0.0.1
send2:
	./client2 127.0.0.1