# Thread

### 스레드란?
스레드는 프로세스의 실행 가능한 가장 작은 작업 단위입니다. 하나의 프로세스는 여러 개의 스레드를 가질 수 있고, 각 스레드는 독립적인 실행 흐름을 가집니다.
스레드는 코드, 데이터, 힙을 스레드끼리 공유합니다. 그 외의 영역은 각각 생성됩니다.

## 스레드의 주요 특징
- 독립적인 실행 흐름: 스레드는 독립적으로 실행됩니다.
- 자원 공유: 같은 프로세스 내의 스레드들은 메모리 공간(Code, Static data, Heap)을 공유합니다.
- 경량 프로세스: 스레드는 프로세스보다 생성 및 관리 비용이 적습니다.
- *컨텍스트 스위칭(Context Switching): CPU가 여러 스레드 간에 작업을 전환할 수 있습니다.

```plain text
*컨텍스트 스위칭(Context Swtiching)
- CPU가 현재 실행 중인 작업(프로세스 혹은 스레드)의 상태(레지스터, 프로그램 카운터 등)를 저장하고,
새로운 작업의 상태를 로드하여 실행 흐름을 전환하는 과정을 의미합니다.

스레드와 컨텍스트 스위칭의 관계
- 스케줄러가 한 스레드를 멈추고 다른 스레드를 실행시킬 때, 이전 스레드의 상태(레지스터, 프로그램 카운터 등)를 저장하고,
새 스레드의 상태를 복원하는 Context Switching이 일어납니다.

- 스레드끼리는 주소 공간을 공유하기에 프로세스 간 전환보다 Context Switching 비용이 작을 수 있지만,
여전히 레지스터나 스택 포인터 등을 저장·복원해야 하므로 오버헤드가 전혀 없지는 않습니다.
```

### 스레드의 구성 요소
- 스레드 ID
- 프로그램 카운터 (PC)
- 레지스터 집합: CPU가 사용 중인 레지스터 상태(PC, Stack Pointer, 일반 register 등)는 스레드마다 달라집니다.
- 스택: 스레드는 각각 고유한 스택을 가집니다. 지역변수, 함수 호출 기록(call stack) 등이 저장됩니다.

![](/OS/img/os_thread_1.png)

# Multithreading

### 멀티스레딩이란?
하나의 프로세스 내에서 여러 개의 스레드를 동시에 실행하는 기술입니다.
CPU의 사용률을 극대화하고 프로그램의 효율성을 높이기 위해 사용됩니다.

## 멀티스레딩의 주요 특징
- 동시성
  - 두 개 이상의 스레드가 "거의 동시에" 실행되는 느낌을 줍니다.
  - 실제 싱글 코어 환경에서는 빠른 스위칭, 멀티코어 환경에서는 물리적 병렬 처리로 인해 출력이 뒤섞여 나옵니다.
- 비결정적 출력 순서
  - 실행할 때마다 콘솔에 찍히는 순서가 달라질 수 있습니다. 이는 스케줄러가 각 스레드에 CPU를 할당하는 시점이 매번 다르기 때문입니다.
- 스레드 간 독립적 실행 흐름
  - 각 스레드는 자신만의 for 루프를 진행하면서, 독립적으로 index를 증가시킵니다.
  - 이 때, 공유 자원을 건드리지 않으므로 동기화 이슈가 발생하지 않지만 만약 공유 자원을 쓰게 된다면 동기화가 필요해집니다.
- 메인 스레드
  - main() 메서드를 실행하는 것이 '메인 스레드'인데, t1.join()과 t2.join()을 통해 나머지 스레드가 종료될 때까지 기다렸다가 "Main thread finished"를 출력합니다.
  - 만약 join()을 사용하지 않으면, 메인 스레드가 먼저 종료된 뒤에도 다른 스레드가 뒤이어 계속 동작할 수도 있습니다.

### 멀티스레딩의 자바 코드
- 코드
```java
class MyThread extends Thread {
    private final String threadName;

    public MyThread(String name) {
        this.threadName = name;
    }

    @Override
    public void run() {
        // 스레드가 실제로 동작하고 있음을 확인하기 위해 숫자를 반복 출력
        for (int i = 0; i < 5; i++) {
            System.out.println(threadName + " : " + i);
            try {
                // 다른 스레드에게 CPU 사용 기회를 주기 위해 잠시 대기
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println(threadName + " finished");
    }
}

public class MultiThreadDemo {
    public static void main(String[] args) {
        MyThread t1 = new MyThread("Thread-A");
        MyThread t2 = new MyThread("Thread-B");

        // 스레드 시작
        t1.start();
        t2.start();

        // 메인 스레드는 두 스레드가 끝날 때까지 대기
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Main thread finished");
    }
}
```

- 실행 결과 예시

⚠️ 실행 순서는 매번 달라집니다. ⚠️

```mathematica
Thread-A : 0
Thread-A : 1
Thread-B : 0
Thread-A : 2
Thread-B : 1
Thread-A : 3
Thread-B : 2
Thread-B : 3
Thread-A : 4
Thread-B : 4
Thread-A finished
Thread-B finished
Main thread finished
```


## 멀티스레딩의 장단점
### 장점
- 병렬 처리: 여러 작업을 동시에 실행하여 성능을 개선합니다.
- 자원 공유: 동일한 프로세스 안에서 동작하므로, 메모리 공간을 공유하여 메모리 사용을 절감합니다.
- 응답성 개선: 하나의 스레드가 중단(blocked) 되어도 다른 스레드가 실행(running)할 수 있습니다.
### 단점
- 동기화 문제: 공유 자원에 여러 스레드가 동시에 접근하면 Race Condition, 데드락(Deadlock) 등이 발생할 수 있습니다.
- 디버깅 및 테스트 복잡도 증가: 스레드 간 비동기적 상호 작용으로 인해, 에러 발생 조건이 복잡해지고 재현이 어렵습니다. 디버거로 일시중지 시, 다른 스레드의 상태와 타이밍을 모두 고려해야 합니다.
- Context Switching 오버헤드: 스레드가 많아질수록 Context 전환 빈도가 늘어나, CPU에 부하가 커질 수 있습니다. 과도한 스레드 생성이 역효과를 초래할 수 있기 때문에 스레드 풀 사용을 권장합니다.

## 멀티스레딩의 동작 원리
- 스케줄링: CPU가 여러 스레드를 빠르게 전환(Context Switching)해서 실행하거나, 멀티코어 환경에서는 여러 스레드를 물리적으로 동시에 실행합니다.
  - 스레드가 I/O 대기나 Sleep 상태일 때, 다른 스레드가 CPU를 차지할 수 있습니다. -> 자원 활용도 개선
- 멀티스레딩은 Context Switching을 통해 병렬 실행을 구현합니다.

## 스레드 동기화
- Race Condition(경합 상태)
  - 여러 스레드가 동시 접근하여 값을 읽고 쓸 때, 실행 순서에 따라 결과가 달라지는 문제
  - ex. 하나의 변수 `count`를 동시에 업데이트할 때, 덮어쓰기 문제 발생 가능
- 임계 영역(Critical Section)
  - 공유 자원에 접근하는 부분
  - 동시 접근 시 동기화가 적절하게 되어 있지 않으면 Race Condition 발생
- 동기화 기법
  - 뮤텍스(Mutex): 한 번에 하나의 스레드만 임계 영역 진입 가능
  - 세마포어(Semaphore): 카운터를 통해 동시에 진입할 수 있는 스레드 수를 제한
  - 모니터(Monitor): 객체 단위로 lock을 거는 고수준 구조(ex. 자바의 synchronized)
- 데드락(Deadlock)
  - 스레드들이 서로 자원을 기다리면 영원히 대기 상태에 빠지는 현상
  - `상호 배제` + `점유 대기` + `비선점` + `순환 대기` 조건이 동시에 만족할 때 발생

## 참고 자료
1. 면접을 위한 CS 전공지식 노트, 주홍철
2. Operating System Concepts, Abraham Silberschartz
