# 싱글톤 패턴

## 싱글톤 패턴(Singleton Pattern)

### 1. 싱글톤 패턴 개요

**싱글톤 패턴**은 특정 클래스에 대해 **단 하나의 인스턴스만 존재**하도록 보장하는 디자인 패턴입니다. 이 패턴은 **메모리 최적화**와 **자원 공유**가 필요한 경우에 유용합니다.

- **주요 특징**:
    - **하나의 인스턴스만 존재**: 동일 클래스에서 객체가 중복 생성되지 않도록 보장
    - **전역 접근**: 애플리케이션 어디서든 동일한 객체를 접근 가능
    - **객체 재사용**: 한 번 생성된 인스턴스를 재사용하여 리소스 절약

### 2. 싱글톤 패턴 구현 원리

![class.jpg](https://github.com/user-attachments/assets/16408d65-183b-4f83-ae3e-43d80c2474e5)
- 생성자 private 설정 : 외부에서 `new`로 인스턴스를 생성할 수 없도록 제한
- `getInstance()` 메서드 이용:  이미 생성된 인스턴스를 반환하는식으로 구성

### 3. 싱글톤 패턴 구현 기법

모두 싱글톤을 지향한다는 점은 같지만 장단점이 존재합니다. 각 코드 기법들은 단점들이 존재하며, 최종적으로는 6번, 7번을 사용하여 싱글톤을 구현하는것을 권장합니다.

1. Eager Initialization
2. Static block initialization
3. Lazy initialization
4. Thread safe initialization
5. Double-Checked Locking
6. Bill Pugh Solution
7. Enum

### 4. 각 기법 설명

### (1) **Eager Initialization**

- 한번만 미리 만들어두는, 가장 직관적인 방법
- 객체가 사용 되기 전에 즉시 초기화가 이루어져, 애플리케이션 실행 초기에 메모리 적재

```java
class Singleton {
    
    // 싱글톤 클래스 객체를 담을 인스턴스 변수
    private static final Singleton INSTANCE = new Singleton();

    // 생성자를 private로 선언 (외부에서 new 연산자 X)
    private Singleton() {}

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

- 장점
    - `멀티 쓰레드 환경`에서도 안전 : 인스턴스가 `static final` 변수
- 단점
    - 메모리 낭비 : 인스턴스를 사용하지 않더라도 메모리에 적재
    - 예외 처리 불가 : 애플리케이션의 **시작 시점**에 싱글톤 인스턴스 생성에 실패한 경우

### (2) Static block Initialization

- `static block`을 이용해 예외를 잡는 방법
    - static block : 클래스가 로딩되고 클래스 변수가 준비된 후 자동으로 실행되는 블록을 말합니다.
- 싱글톤 인스턴스는 클래스가 로딩 되는 시점에 생성

```java
class Singleton {
    // 싱글톤 클래스 객체를 담을 인스턴스 변수
    private static Singleton instance; // final X

    // 생성자를 private로 선언 (외부에서 new 사용 X)
    private Singleton() {}
    
    // static 블록을 이용해 예외 처리
    static {
        try {
            instance = new Singleton();
        } catch (Exception e) {
            throw new RuntimeException("싱글톤 객체 생성 오류");
        }
    }

    public static Singleton getInstance() {
        return instance;
    }
}
```

- 장점
    - 예외 처리 가능 : static block
- 단점
    - (이론상) 메모리 낭비  : 클래스 로딩과 동시에 객체가 생성되기 때문에 초기화 시점과 실제 사용 시점이 맞지 않으면 메모리 낭비 이슈 존재

### (3) Lazy Initialization

- 객체 생성에 대한 관리를 내부적으로 처리하는 방식
- 외부에서 `getInstance()`를 호출 했을 때,  초기화 진행
    - 인스턴스 변수의 null 유무에 따라 초기화 하거나 이미 만들어진 인스턴스를 반환하도록 설계

```java
class Singleton {
    // 싱글톤 클래스 객체를 담을 인스턴스 변수
    private static Singleton instance;

	  // 생성자를 private로 선언 (외부에서 new 연산자 X)
    private Singleton() {}
	
    // 외부에서 정적 메서드를 호출하면 그제서야 초기화 진행 (lazy)
    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton(); // 오직 1개의 객체만 생성
        }
        return instance;
	}
}
```

- 장점
    - 초기화 지연 : 위의 자원낭비(메모리 낭비)의 한계점을 극복
- 단점
    - `Thread Safe` 하지 않음 : 멀티쓰레드 환경에서 싱글톤을 지킬 수 없음
        1. `스레드 A`, `스레드 B`가 존재한다고 가정
        2. `스레드 A`가 If문을  평가하고 인스턴스 생성 코드로 진입 (instance가 null)
        3. `쓰레드 A`가 인스턴스를 생성하기 전에 `스레드 B`가 If문을 평가하게 된다면?
        4. `스레드 B`가 If문을 평가하는 시점에도 instanc가 null이기 때문에 인스턴스 생성 코드로 진입
        5. 결과적으로 스레드 A와 B가 인스턴스 초기화 코드를 두번 실행 (원자성 결여)
- Test Code

```java

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class SingletonTest {

	@Test
	void multi_thread() throws InterruptedException {
		// 여러 스레드를 만들어서 동시에 Singleton.getInstance() 호출
		Runnable task = () -> {
			Singleton instance = Singleton.getInstance();
			System.out.println("Thread: " + Thread.currentThread().getName() + " - Instance: " + instance);
			
			// 객체 주소가 동일한지 확인 (모든 스레드에서 동일한 객체를 참조해야 함)
			assertSame(Singleton.getInstance(), instance);
		};

		// 10개의 스레드 실행
		Thread[] threads = new Thread[10];
		for (int i = 0; i < 10; i++) {
			threads[i] = new Thread(task);
			threads[i].start();
		}

		// 모든 스레드가 끝날 때까지 기다리기
		for (int i = 0; i < 10; i++) {
			threads[i].join();
		}
	}

}
```

- 결과

![testResult.jpg](https://github.com/user-attachments/assets/9ac784b7-8638-4d4a-aede-c37d85568d2e)

### (4) Thread safe initialization

- `getInstance()` 메서드 `synchronized` 키워드를 사용: 쓰레드들이 하나씩 접근하여 인스턴스를 반환받음

  > synchronized 키워드는 멀시 쓰레드 환경에서 각 쓰레드가 순차적으로 접근하도록 합니다. 즉 쓰레드가 해당 메서드를 실행하는 동안 다른쓰레드가 접근하지 못하도록 lock을 걸어서 경쟁상태(race condition)이 발생하지 않도록 합니다.
  >
  >
  > ![multiThread.jpg](https://github.com/user-attachments/assets/f7c18228-0a75-478e-89db-edba11100e71)
>

```java

class Singleton {
    private static Singleton instance;

    private Singleton() {}

    // synchronized 메서드
    public static synchronized Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

- 장점
    - Thread Safe
- 단점
    - 동기화 처리작업으로 `Overhead` 발생

### (5) Double-Checked Locking

- 인스턴스를 호출할 때마다 `synchronized` 동기화가 실행되지 않고, 최초 초기화시에만 동기화가 실행되도록 설계
- 인스턴스 필드에 `volatile` 키워드를 붙여주어야 함

```java
class Singleton {
    private static volatile Singleton instance; // volatile 키워드 적용

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
        	// 메서드에 동기화 거는게 아닌, Singleton 클래스 자체를 동기화 걸어버림
            synchronized (Singleton.class) { 
                if(instance == null) { 
                    instance = new Singleton(); // 최초 초기화만 동기화 작업이 일어나서 리소스 낭비를 최소화
                }
            }
        }
        return instance; // 최초 초기화가 되면 앞으로 생성된 인스턴스만 반환
    }
}
```

- 장점
    - 성능 향상 : 이미 인스턴스가 생성된 경우 동기화 작업이 필요 없음
- 단점
    - `Thread Safe` 이슈 : JVM에 따라서 여전히 Thread Safe 하지 않은 경우가 발생하기 때문에 사용을 지양

### (6) Bill Push Solution(LazyHolder)

- 권장되는 두가지 방법 중 하나
- 클래스 안에 내부 클래스(holder)를 두어 클래스가 로드되는 시점을 이용한 방법
    - 내부 클래스인 `SingleInstanceHolder`는 `getInstance()` 호출시에 클래스 로드 및 초기화
- 멀티쓰레드 환경에서 안전하고 `Lazy Loading`(나중에 객체 생성)도 가능한 완벽한 싱글톤 기법
- static 메서드에서는 static 멤버만 호출 할 수 있기 때문에 내부 클래스를 static으로 설정

```java
class Singleton {

    private Singleton() {}

    // static 내부 클래스를 이용
    // Holder로 만들어, 클래스가 메모리에 로드되지 않고 getInstance 메서드가 호출되어야 로드됨
    private static class SingleInstanceHolder {
        private static final Singleton INSTANCE = new Singleton();
    }
		
		// 해당 메서드 호출시 SingleInstanceHolder 클래스 초기화 
    public static Singleton getInstance() {
        return SingleInstanceHolder.INSTANCE;
    }
}
```

- 세부 설명
    1. 내부 클래스를 static으로 선언하여, 싱글톤 클래스가 초기화되어도 `SingleInstanceHolder` 내부 클래스는 메모리에 로드되지 않음
    2. `getInstnce()` 메서드를 외부에서 호출할 때, `SingleInstanceHolder` 내부 클래스의 `static 멤버를 반환`하게 되는데, 이 때 내부 클래스가 한번 초기화되면서 싱글톤 객체를 최초 생성 및 리턴
    3. 마지막으로 `final`을 지정함으로서 재할당 방지
- 한계점
    - `Reflection API`, `직렬화/역직렬화`를 이용하면 임의로 싱글톤 파괴할 수 있음

### (7) Enum 이용

- 권장되는 두가지 방법 중 하나
- `enum` 클래스 : 애초에 멤버를 만들때 private으로 만들고 한번만 초기화하기 때문에 `Thread safe`
- `enum`내에서 상수 뿐만아니라 변수나 메서드를 선언해 사용할 수 있기 때문에 이를 활용하여 싱글톤 클래스처럼 응용이 가능

```java
enum SingletonEnum {
    INSTANCE;

    private final Client dbClient;
	
    SingletonEnum() {
        dbClient = Database.getClient();
    }

    public static SingletonEnum getInstance() {
        return INSTANCE;
    }

    public Client getClient() {
        return dbClient;
    }
}
```

- 장점
    - `Reflection`을 통한 공격에도 안전
- 단점
    - `Enum` 클래스는 `Enum` 클래스 외에는 상속이 불가능
    - 멀티톤 클래스로 마이그레이션 해야할 때 처음부터 코드를 다시 짜야함

### 5. 싱글턴 패턴의 문제점

- 모듈간의 의존성
    - 하나의 인스턴스를 여러 개의 모듈에서 참조하는 경우 클래스간 결합도가 높아짐
- 테스트 어려움 :
    - 생성 방식이 제한적이기 때문에 Mock으로 대체하기 어려움
    - 다른 객체들과 자원을 공유하고 있기 때문에, 테스트시 항상 인스턴스 상태 초기화 필요
- 다중 서버
    - 다중 서버인 경우 독립적으로 다른 메모리 공간에 있기 때문에 싱글톤 객체의 유일성을 보장받을 수 없음

### 6. 결론

- 싱글톤 패턴은 **효율적인 자원 관리에** 유용하지만, 위에서 언급한 **문제점**들을 충분히 고려
- **직접 구현**하는 대신, **검증된 프레임워크**나 **라이브러리**를 사용하여 싱글톤을 관리하는 것이 더 안전하고 효율적
    - 예를 들어, `Spring Framework`에서는 의존성 주입(DI)을 통해 싱글톤 패턴을 안전하게 관리할 수 있으며, **멀티스레드 환경**과 **분산 시스템**을 고려한 다양한 기능을 제공

### 6. 참고

- [Java 객체 지향 디자인패턴  - 한빛 미디어](https://product.kyobobook.co.kr/detail/S000001057516)
- [헤드 퍼스트 디자인패턴 - 한빛 미디어](https://product.kyobobook.co.kr/detail/S000001810483)
- [싱글톤Singleton-패턴-꼼꼼하게-알아보자](https://inpa.tistory.com/entry/GOF-%F0%9F%92%A0-%EC%8B%B1%EA%B8%80%ED%86%A4Singleton-%ED%8C%A8%ED%84%B4-%EA%BC%BC%EA%BC%BC%ED%95%98%EA%B2%8C-%EC%95%8C%EC%95%84%EB%B3%B4%EC%9E%90)
- [GoF 디자인 패턴: 싱글톤 패턴](https://www.youtube.com/watch?v=OwOEGhAo3pI&list=PLfI752FpVCS_v_sc8Q6V9QQN7GhoyktKD)