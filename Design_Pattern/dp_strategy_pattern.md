
## 전략패턴(Strategy Pattern) 개요

### 전략 패턴이란?

> 전략 패턴은 실행 중, 즉 런타임에 원하는 알고리즘 전략을 선택하여 동적으로 동작을 변경할 수 있도록 하는 행위 디자인 패턴입니다.
>

여기서 ‘**전략**’ 이란, **특정 목표를 달성하기 위한 행동 계획**을 의미합니다.
즉, 어떤 일을 수행하기 위한 여러 알고리즘이 존재할 때, 전략 패턴을 통해 필요에 따라 손쉽게 알고리즘 교체할 수 있습니다.

### 전략패턴 구조

![strategy.png](https://github.com/user-attachments/assets/d2f7f956-d894-4017-b7b1-49eb07903084)

- 전략 알고리즘 구현체 : 알고리즘, 행위, 동작을 정의한 구현체
- 전략 인터페이스 : 모든 전략 구현체에 대한 공용 인터페이스
- 컨텍스트 : 날고리즘을 실행해야할 때마다 해당 알고리즘과 연결된 전략 객체의 메서드를 호출
- 클라이언트 : 특정 전략 객체를 컨텍스트에 전달함으로써 전략을 등록하거나 변경하여 전략 알고리즘을 실행한 결과를 얻음

### GoF의 디자인 패턴 책에서는 전략패턴

1. 동일 계열의 알고리즘 군을 정의하고 → 전략 알고리즘 구현체로 정의
2. 각각의 알고리즘을 캡슐화하여 → 인터페이스로 추상화 (추상화된 알고리즘)
3. 이들을 상호 교환이 가능하게 만든다. → 합성(composition)으로 구현
4. 알고리즘을 사용하는 컨텍스트와 상관없이 독립적으로 → 컨텍스트 객체를 수정하지 않고
5. 알고리즘을 변경할 수 있게 한다. → 새로운 전략 객체를 추가하여 메소드 동작을 변경할 수 있다.

---

## 전략 패턴 특징

### 전략 패턴 사용 시기

- 전략 알고리즘의 여러 버전 또는 변형이 필요할때 클래스화를 통해 관리
- 알고리즘의 동작이 런타임에 실시간으로 교체되어야할

### 전략 패턴 주의점

- 알고리즘(전략 구현체)이 많아 질수록 관리해야할 객체의 수가 늘어난다는 단점
- 알고리즘이 많지 않고 자주 변경되지 않는다면, 전략패턱은 프로그램의 복잡도만 높일 수 있음
- 개발자는 적절한 전략을 선택하기 위해 각 전략 간의 차이점을 파악해야 함

---

## 간단한 전략 패턴 예제

> 사람은 인사를 하는 프로그램 작성
>
> - 다양한 방식으로 인사할 수 있어야한다.
> - 인사의 종류는 다양하다.
    >     - 예를 들어 정중한 인사와 캐주얼한 인사가 있다.
>     - 유행에 따라 새로운 인사법이 추가 될 수 있다.

![strategy_sample.png](https://github.com/user-attachments/assets/ca98bcf8-0f68-4d8b-b840-014d33e17030)

- **Person 클래스**는 인사 행동을 수행할 수 있는 컨텍스트 역할을 하며,
- **GreetingStrategy** 인터페이스를 통해 다양한 인사 방법(전략)을 캡슐화하고,
- **FormalGreeting**과 **CasualGreeting** 같은 구체적 전략 클래스를 만들어,
- 필요에 따라 인사 방식을 동적으로 교체할 수 있도록 구현할 수 있습니다.

---

## 실무에서 찾아보는 Strategy 패턴

### Java

- Collections의 sort() 메서드
    - **컨텍스트(Context):**
        - `Collections.sort()`는 정렬 알고리즘을 내부적으로 실행하는 **컨텍스트**
        - 이 메서드는 정렬 방식을 직접 구현하는 대신, 외부에서 전달받은 `Comparator` 객체에 의존하여 정렬 기준을 결정
    - **전략(Strategy):**
        - `Comparator` 인터페이스는 두 객체를 비교하는 `compare()` 메서드를 정의
        - 이 메서드의 구현이 **구체적인 전략(Concrete Strategy)** 역할을 합니다.
    - **동적 교체:**
        - 실행 중에 서로 다른 `Comparator` 구현체를 전달함으로써 정렬 기준(전략)을 쉽게 변경 가능

```java
public class StrategyInJava {
	
	public static void main(String[] args) {
		List<Integer> numbers = new ArrayList<>();
		numbers.add(2);
		numbers.add(1);
		numbers.add(3);
		numbers.add(5);
		numbers.add(4);

		Collections.sort(numbers, new IntegerComparator());

		System.out.println(numbers);
	}
}

class IntegerComparator implements Comparator<Integer> {

	public IntegerComparator() {
	}

	@Override
	public int compare(Integer o1, Integer o2) {
		return o1 - o2;
	}
}
```