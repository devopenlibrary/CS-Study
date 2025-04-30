## 1. Synchronous?

- 작업이 ‘순차적으로’ 진행되어야 하는 방법.
- 작업이 독집적이지 못한다. 특정 작업에 영향을 받는다. 작업 진행을 호출한 쪽(스레드, 프로세스)이 담당한다.
- 작업은 blocking이 된다.
    - 외부 요인에 의해 작업을 영향 받아서 기다린다.
    - 커널에 요청한 작업 때문에 wait queue에 들어갈 수도 있다.
- 예시
    - A 작업이 끝나야 B 작업이 실행이 된다.
    - API를 호출하고 결과가 오기 전까지 대기한다.
    - API 호출 결과를 알기 위해서 지속적으로 확인해야 한다. (처리 결과를 직접 확인해야 함)

## 2. Asynchronous?

- 작업이 ‘독립적으로’ 진행할 수 있는 방법
- 즉시 리턴이 된다. 시스템 콜의 완료 여부를 기다리지 않는다.
- 작업이 독립적으로 실행되기 위해서는 어떻게 해야할까?
    - **요청한 작업을 호출한 쪽이 신경쓰지 않는다. (non-blocking)**
        - 특정 신호를 통해서 결과 여부를 확인할 수 있다. (**signal**)
            - 신호는 운영체제가 알려준다. (사용자가 관리하지 않음)
            - epoll, iocp 등
        - 호출 처리 담당을 만들어, 나중에 결과를 알려준다. (**asynchrous procedure call)**
            - callback
    - **작업을 여러 개로 쪼개서 독립적으로 실행한다. (concurrent)**
        - 작업을 A,B,C,D로 나눠 각 스레드가 독립적으로 처리한다.
        - Thread-1 : A,B 처리 담당
        - Thread-2 : C,D 처리 담당
        - 결과를 알기 위해서는 따로 확인을 해야한다.

## 3. Blocking & Non-Blocking

- blocking과 non-blocking은 작업 진행이 멈추는가 안 멈추는가 (나 자신의 제어가 아닌 외부에 의해서)
- Blocking
    - 운영체제 관점에서는 스레드가 작업을 요청 후 wait queue에 들어가서 대기함. 요청이 완료되면 요청을 받고 context switch가 되어 작업을 진행한다.
- Non-blocking
    - wait queue에서 대기하지 않고 응답을 받고 돌아간다. (응답 코드, 에러 코드 등)
- 예
    - blocking I/O, non-blocking I/O
    - multi-threading

## 4. Blocking I/O, Non-Blocking I/O

![figure1.gif](https://developer.ibm.com/developer/default/articles/l-async/images/figure1.gif)

- Boost application performance using asynchronous I/O - ibm에서 설명하는POSIX IO 설명
- 4분면은 IO를 설명하기 위해서 사용함.

### 4.1 Sync-blocking I/O

![sync-blocking.png](https://developer.ibm.com/developer/default/articles/l-async/images/figure2.gif)

- 단순한 IO 모델
- 유저 스레드가 커널 스레드에게 요청을 보내면 유저 스레드는 대기한다.

### 4.2 Syn-non blocking I/O

![sync-non-blocking.png](https://developer.ibm.com/developer/default/articles/l-async/images/figure3.gif)

- IO 작업이 요청이 blocking을 하지 않고 현재 작업에 대한 에러 코드를 전달한다.
- 커널 스레드에서 유저 스레드로 권환이 돌아오기 때문에 유저 스레드는 자신의 작업을 계속 진행할 수 있다.
- 하지만 유저 스레드는 작업의 완료 여부를 지속적으로 확인해야 한다.

### 4.3 Async -blocking (애매한 표현)

![figure4.gif](https://developer.ibm.com/developer/default/articles/l-async/images/figure4.gif)

- 위 모델은 notify 기반으로 동작하는 모델
- IO mulitplexing을 통해서 하나의 소켓이 여러 file descirptor를 가지고 있다.
- file descriptor에 데이터가 준비가 되면 스레드에게 통지하는 모델
- select(), epoll()은 non blocking라고 설명이 되어 있는데, ibm에서는 blocking으로 분류
    - 만약 통지가 오기 전까지 유저 스레드가 작업을 멈추면, 그럴 수도 있다.
    - 다른 작업을 하다가 통지를 받으면 그렇지 않을 수도 있다.

### 4.4 Aysnc-non blocking

![figure5.gif](https://developer.ibm.com/developer/default/articles/l-async/images/figure5.gif)

- aio, select, epoll, kqueue이 동작하는 방식이 위 사진처럼 동작함.
- 작업은 callback, signal을 통해서 유저 스레드에게 통지가 된다.

## 5. 자바에서는 IO를 어떻게 사용할까?

- io 패키지에 있는 input stream, output stream이 위에 있는 blocking io 방식
- 소켓이 열리면 데이터가 올 때까지 대기한다.
- nio는 selector 라는 객체가 채널을 관리하면서 데이터 전달을 한다.
    - 이 selector는 sun에서 구현한 poll 방식의 시스템 콜을 사용한다. 통지 방식으로 구현됨.
    ```
    Selector selector = Selector.open();
    ServerSocketChannel serverSocket = ServerSocketChannel.open();
    serverSocket.bind(new InetSocketAddress("localhost", 5454));
    serverSocket.configureBlocking(false);
    serverSocket.register(selector, SelectionKey.OP_ACCEPT);

    while (true) {
        selector.select(); // select() 호출과 동일한 블로킹 방식
        
        Set<SelectionKey> selectedKeys = selector.selectedKeys();
        Iterator<SelectionKey> iter = selectedKeys.iterator();
        
        while (iter.hasNext()) {
            SelectionKey key = iter.next();
            
            if (key.isAcceptable()) {
                // 새로운 연결 수락
                SocketChannel client = serverSocket.accept();
                client.configureBlocking(false);
                client.register(selector, SelectionKey.OP_READ);
            }
            
            if (key.isReadable()) {
                // 데이터 읽기
                SocketChannel client = (SocketChannel) key.channel();
                ByteBuffer buffer = ByteBuffer.allocate(1024);
                client.read(buffer);
            }
            iter.remove();
        }
    }
    ```

### 5.1 Servlet 3.0

- non-blocking io를 지원하기 시작한 서블릿 버전
- 기존 서블릿은 io 패키지에 있는 input, out stream을 사용
- servlet 3.0 부터 AsyncEvent, AysncListener을 통해서 서블릿 기능을 확장
    - 어뎁터 패턴으로 기능을 확장함.
    - 정확히 어떠한 원리로 동작하는지는 모르겠음.
        - 내부에 atomicBoolean과 onEvent, onError가 구현되는 것을 보아 데이터가 준비되면 시그널, 콜백으로 전달하고 아닐 경우 에러를 처리하는 방식?
        - 동시성 때문에 시그널은 atomicBoolean으로 관리

### 5.2 Future

- 비동기적 연산을 지원함
    - 여기서 비동기 연산은 non-blocking io를 활용하는 것이 아닌 multi-thread를 활용하는 방식
    - 이유 : future는 excutor에 의해 실행이 된다. runnable을 파라미터로 받음.
    - 여기서 비동기 연산을 넣어 실행하면 정상일 때, 비정상일 때 처리 로직, 고계함수로 엮으면 복잡한 코드가 완성됨.
    - future로 작업을 얻기 위해서 get을 호출하는데 이 때, blocking이 발생.
    - 좀 더 우아한? 처리를 위한 것이 CompletableFuture

## 참고
- https://developer.ibm.com/articles/l-async/
- https://interconnection.tistory.com/141
- https://joooing.tistory.com/entry/동기비동기-블로킹논블로킹
