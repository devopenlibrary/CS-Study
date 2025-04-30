## Set

### Set이란?
Set(집합)은 중복을 허용하지 않는 요소들의 모음으로, 특정 요소의 존재 여부를 빠르게 확인할 수 있는 자료구조입니다. 일반적으로 해시 기반으로 구현되어 있으며, 수학적인 집합 연산(합집합, 교집합, 차집합 등)을 효율적으로 수행할 수 있습니다.

대표적인 Set 자료구조로는 다음과 같은 것들이 있습니다.

- HashSet (해시 집합): 해시 테이블을 사용하여 요소를 저장하는 방식 (Java의 HashSet, Python의 set)
- TreeSet (트리 집합): 이진 탐색 트리를 사용하여 요소를 저장하는 방식 (Java의 TreeSet, C++의 std::set)
- LinkedHashSet (연결 리스트 기반 집합): 요소의 삽입 순서를 유지하는 집합 (Java의 LinkedHashSet)

## Set의 장단점
### ✅ 장점
- 중복 없는 데이터 관리
- Set은 기본적으로 중복을 허용하지 않기 때문에, 중복 요소를 자동으로 제거하는 용도로 활용할 수 있습니다.
- 빠른 탐색 성능
    - 해시 기반의 Set(HashSet)을 사용하면 평균적으로 O(1)의 시간 복잡도로 요소를 검색할 수 있습니다.
    - 트리 기반의 Set(TreeSet)을 사용하면 O(log n)의 시간 복잡도로 탐색이 가능합니다.
- 집합 연산 지원
    - 합집합, 교집합, 차집합 등 수학적인 집합 연산을 효과적으로 수행할 수 있습니다.

### ❌ 단점
- 인덱스를 이용한 접근 불가
- 리스트(List)와 달리 특정 인덱스의 요소에 직접 접근할 수 없습니다.
정렬이 필요한 경우 추가 비용 발생
- HashSet은 내부적으로 정렬되지 않으며, TreeSet과 같은 정렬된 Set을 사용해야 하지만, 삽입/삭제 시 O(log n)의 추가 비용이 발생합니다.
메모리 사용량 증가
- 해시 기반 Set(HashSet)은 내부적으로 해시 테이블을 사용하므로, 같은 데이터를 리스트(List)에 저장하는 것보다 더 많은 메모리를 사용합니다.

### Set의 활용 사례
1. 중복 제거 - 배열이나 리스트에서 중복된 값을 제거할 때 Set을 활용하면 간단하게 해결할 수 있습니다.
```java
import java.util.HashSet;

public class SetExample {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 3, 2, 1, 5};
        HashSet<Integer> uniqueNumbers = new HashSet<>();

        for (int num : numbers) {
            uniqueNumbers.add(num);
        }

        System.out.println(uniqueNumbers); // [1, 2, 3, 4, 5]
    }
}
```

2. 빠른 포함 여부 검사
```java
import java.util.HashSet;

public class MembershipCheck {
    public static void main(String[] args) {
        HashSet<String> dictionary = new HashSet<>();
        dictionary.add("apple");
        dictionary.add("banana");
        dictionary.add("cherry");

        System.out.println(dictionary.contains("banana")); // true
        System.out.println(dictionary.contains("grape"));  // false
    }
}
```
- 특정 요소가 존재하는지 확인하는 contains() 메서드는 O(1)의 성능을 보이며, 리스트(List)의 contains() (O(n))보다 훨씬 빠릅니다.

3. 집합 연산 (합집합, 교집합, 차집합)
```java
import java.util.HashSet;

public class SetOperations {
    public static void main(String[] args) {
        HashSet<Integer> setA = new HashSet<>();
        HashSet<Integer> setB = new HashSet<>();

        setA.add(1); setA.add(2); setA.add(3);
        setB.add(2); setB.add(3); setB.add(4);

        // 합집합 (Union)
        HashSet<Integer> union = new HashSet<>(setA);
        union.addAll(setB);
        System.out.println("합집합: " + union); // [1, 2, 3, 4]

        // 교집합 (Intersection)
        HashSet<Integer> intersection = new HashSet<>(setA);
        intersection.retainAll(setB);
        System.out.println("교집합: " + intersection); // [2, 3]

        // 차집합 (Difference)
        HashSet<Integer> difference = new HashSet<>(setA);
        difference.removeAll(setB);
        System.out.println("차집합: " + difference); // [1]
    }
}
```
- 두 개의 Set을 이용해 간단하게 합집합, 교집합, 차집합 연산을 수행할 수 있습니다.

4. 로그 분석 (중복된 IP 제거)
- 서버 로그에서 중복된 IP 주소를 제거하여 고유 방문자 수를 구할 때 Set을 사용할 수 있습니다.

## 자료구조로서의 성능

| 연산            | HashSet (해시 테이블 기반) | TreeSet (이진 탐색 트리 기반) |
|----------------|-------------------------|--------------------------|
| **삽입 (Insertion)** | 평균 O(1), 최악 O(n)     | O(log n)                 |
| **삭제 (Deletion)** | 평균 O(1), 최악 O(n)     | O(log n)                 |
| **검색 (Search)**   | 평균 O(1), 최악 O(n)     | O(log n)                 |
| **정렬 유지 여부**  | ❌ (정렬되지 않음)       | ✅ (자동 정렬)            |

- HashSet은 내부적으로 해시 테이블을 사용하여 O(1)의 빠른 탐색 성능을 제공하지만, 해시 충돌이 발생할 경우 O(n)까지 성능이 저하될 수 있습니다.
- TreeSet은 이진 탐색 트리를 사용하여 자동 정렬되며 O(log n)의 성능을 유지하지만, 해시 기반 Set보다 삽입/삭제가 느립니다.

### ✔ 어떤 Set을 선택해야 할까?
- 순서가 중요하지 않고 빠른 탐색이 필요할 때 → HashSet
- 정렬이 필요한 경우 → TreeSet
- 삽입 순서를 유지해야 할 때 → LinkedHashSet

