# Map

- 키 하나 - 값 하나 연관되어 있는 형태의 데이터 구조.
- 키를 통해 연관되는 값을 얻을 수 있다.
- 연관 배열, 딕셔너리 이라고도 부른다.

![](/Data%20Structure/img/ds_map.png)

# 필요성

- 키를 통해 연관되는 값을 바로 조회할 수 있는 구조 특성상, O(1) 의 시간복잡도 의 **빠른 시간으로 조회**를 할 수 있다. 저장, 삭제 또한 평균적으로 O(1) 또는 O(log n) 의 시간복잡도 로 가능하다.
- 키가 문자, 숫자, 객체 등 어떠한 값도 될 수 있기에, **유연한 데이터 관리**가 가능하다.

# 특징

- 기본적으로 **키 는 유일**해야 하며, **값 은 중복**될 수 있다.
  - 중복된 키에 값이 쓰일 경우, 일반적으로 덮어씌워진다.
- 키의 데이터 타입 은 어떠한 것이든 될 수 있으나, 하나의 맵 내에서는 일관되어야 한다.
  - Python 의 `Dictionary` 는 여러 타입의 키를 가질 수 있지만, 권장되지 않는다.
- 순서가 없으며, 정렬되어있지 않다.

# 정렬된 (Ordered) / 정렬되지 않은 (Unordered) 맵

- 정렬되지 않은 맵
  - **일반적인 맵의 형태** 이다.키-값 쌍의 순서를 유지하지 않는다. 따라서 맵을 순회할 때 요소가 반환되는 순서는 보장되지 않으며, 실행마다 다를 수 있다.
  - 조회 속도는 평균 O(1)
  - 일반적으로 해시 테이블(Hash Table) 을 사용하여 구현된다.
- 정렬된 맵
  - **키-값 쌍이 삽입된 순서를 유지**한다. 따라서 맵을 순회(iterate)하면 삽입된 순서대로 요소가 반환된다.
  - 일반적으로 자가 균형 이진 탐색 트리(예: 레드-블랙 트리) 를 사용하여 구현된다.
  - - 조회 속도는 O(log n)
  - **요소의 순서가 중요한 경우라면 적합**할 수 있다. (e.g. 이벤트 로그 를 저장하는 경우)

## 정렬된 맵이 정렬되지 않은 맵보다 조회 속도가 느린 이유

- 보통 구현하는 방식에 의해 발생한다. 정렬된 맵은 보통 자가 균형 이진 탐색 트리를 사용 하여 구현하기 때문에, 트리 구조를 따라 조회해야하는 것이 그 이유.
- 따라서, 키를 알면 값을 알 수 있는 일반적인 맵의 장점은 정렬된 맵에는 적용되지 않는 다고 볼 수 있다.

# 프로그래밍 언어 에서의 맵

## C++

- `std::map` : 정렬된 맵
- `std:unordered_map` : 정렬되지 않은 맵

## Java

- `HashMap` : Java 에서 가장 일반적으로 사용되는 맵 구현체. Hash Table 을 통해 구현한다. 스레드 세이프 하지않아 추가적인 동기화 작업이 필요하다.
- `ConcurrentHashMap`: 여러 스레드에서 동시에 접근할 수 있도록 설계된 스레드 안전한 맵 구현체 이다. 외부 동기화 없이도 동시 접근이 가능하여, 멀티스레드 환경에서 사용하기 적합하다.
- `TreeMap` : 정렬된 맵.

### Hashmap, Hashtable

- 데이터 구조 단계에서 둘은 동일하지만, Java 에서 구현체로 사용될때 동기화를 지원하느냐, 하지않느냐 의 차이점을 가진다.
- 따라서, Hashmap 은 스레드 세이프 하지않고, HashTable 은 스레드 세이프 하다.
- HashMap 은 보조해시를 사용하기 때문에 보조 해시 함수를 사용하지 않는 Hashtable 에 비하여 해시 충돌이 덜 발생할 수 있어 상대적으로 성능상 이점이 있다.

## Python

- `dict` : Python 의 가장 기본적인 맵 구현체. 정렬되지 않은 맵.
- `collections.defaultdict`: 존재하지 않는 키에 대해 기본값을 지정할 수 있는 dict의 확장형이다. 존재하지 않는 키에 접근하면 KeyError가 발생하는 대신 기본값이 반환된다.
- `collections.OrderedDict`: 정렬된 맵.

# 출처

- [Hashmap vs. Hash Table: Understanding the Differences](https://ethans.co.in/blogs/hashmap-vs-hash-table-understanding-the-differences/#:~:text=The%20main%20difference%20between%20HashMaps,is%20a%20key%2Dvalue%20pair.)
- [Introduction to Map – Data Structure and Algorithm Tutorials
  ](https://www.geeksforgeeks.org/introduction-to-map-data-structure/)
