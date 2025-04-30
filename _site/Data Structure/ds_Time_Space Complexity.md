# 알고리즘의 성능 분석: Big-O 표기법과 복잡도 이해하기

## 목차
1. [개요](#개요)
2. [Big-O 표기법이란?](#big-o-표기법이란)
3. [시간 복잡도와 공간 복잡도](#시간-복잡도와-공간-복잡도)
4. [주요 Big-O 표기법 살펴보기](#주요-big-o-표기법-살펴보기)
5. [시간 복잡도 최적화 방법](#시간-복잡도-최적화-방법)

## 개요

알고리즘을 설계하고 구현할 때, 우리는 항상 그 알고리즘이 얼마나 효율적인지 고민합니다. 단순히 "작동한다"는 것을 넘어서, 얼마나 빠르게 실행되는지(시간 복잡도), 얼마나 많은 메모리를 사용하는지(공간 복잡도)를 이해하는 것이 중요합니다. 이러한 성능 분석을 위해 우리는 Big-O 표기법을 사용합니다.

## Big-O 표기법이란?

Big-O 표기법은 알고리즘의 성능을 수학적으로 표현하는 방법입니다. 이는 입력 크기에 따른 알고리즘의 실행 시간이나 공간 요구사항의 상한선을 나타냅니다.

### Big-O 표기법의 특징

- **최악의 경우를 표현**: 알고리즘이 실행될 때 발생할 수 있는 최악의 시나리오를 기준으로 합니다.
- **상수는 무시**: O(2n)과 O(n)은 같은 것으로 간주됩니다.
- **지배적인 항만 고려**: O(n² + n)은 O(n²)으로 표현됩니다.

### 왜 Big-O를 사용하나?

1. **알고리즘 비교가 용이**: 서로 다른 알고리즘의 성능을 객관적으로 비교할 수 있습니다.
2. **확장성 예측**: 입력 크기가 증가할 때 성능이 어떻게 변화할지 예측할 수 있습니다.
3. **최적화 방향 제시**: 알고리즘의 병목 지점을 파악하고 개선할 수 있습니다.

## 시간 복잡도와 공간 복잡도

### 시간 복잡도 (Time Complexity)

시간 복잡도는 알고리즘이 실행을 완료하는 데 필요한 연산 횟수를 나타냅니다.

**특징:**
- 입력 크기에 따른 실행 시간의 증가율을 측정
- 하드웨어의 성능과 무관한 객관적 지표
- 실제 러닝 타임이 아닌 연산 횟수를 기준으로 함

### 공간 복잡도 (Space Complexity)

공간 복잡도는 알고리즘이 실행되는 동안 필요한 메모리 공간의 양을 나타냅니다.

**특징:**
- 입력 크기에 따른 메모리 사용량의 증가율을 측정
- 기본 공간(입력 데이터 저장 공간)과 부가 공간(연산을 위한 추가 공간)으로 구분
- 메모리 효율성을 평가하는 중요한 지표

## 💡 주요 시간 복잡도 분석

### 1. O(1) - 상수 시간
입력 크기와 관계없이 일정한 시간이 소요되는 알고리즘입니다.

```java
public class ConstantTime {
    public int getFirst(int[] array) {
        return array[0];  // 배열의 크기와 관계없이 항상 같은 시간 소요
    }
    
    public void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}
```

### 2. O(log n) - 로그 시간
입력 크기가 2배로 증가할 때마다 한 단계씩 증가하는 알고리즘입니다.

```java
public class LogarithmicTime {
    public int binarySearch(int[] array, int target) {
        int left = 0;
        int right = array.length - 1;
        
        while (left <= right) {
            int mid = left + (right - left) / 2;
            
            if (array[mid] == target) return mid;
            if (array[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }
}
```

### 3. O(n) - 선형 시간
입력 크기에 비례하여 실행 시간이 증가하는 알고리즘입니다.

```java
public class LinearTime {
    public int findMax(int[] array) {
        int max = array[0];
        for (int i = 1; i < array.length; i++) {
            if (array[i] > max) {
                max = array[i];
            }
        }
        return max;
    }
}
```

### 4. O(n log n) - 선형 로그 시간
효율적인 정렬 알고리즘의 시간 복잡도입니다.

```java
public class NLogNTime {
    public void mergeSort(int[] array, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(array, left, mid);      // 분할
            mergeSort(array, mid + 1, right); // 분할
            merge(array, left, mid, right);   // 병합
        }
    }
    
    private void merge(int[] array, int left, int mid, int right) {
        // 병합 로직 구현
    }
}
```

### 5. O(n²) - 이차 시간
중첩된 반복문을 사용하는 알고리즘의 시간 복잡도입니다.

```java
public class QuadraticTime {
    public void bubbleSort(int[] array) {
        int n = array.length;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (array[j] > array[j + 1]) {
                    // swap
                    int temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }
    }
}
```

### 6. O(2ⁿ) - 지수 시간
재귀적으로 모든 경우의 수를 확인하는 알고리즘의 시간 복잡도입니다.

```java
public class ExponentialTime {
    public int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    
    public void generateSubsets(char[] set, int index, String current) {
        if (index == set.length) {
            System.out.println(current);
            return;
        }
        // 현재 원소를 포함하지 않는 경우
        generateSubsets(set, index + 1, current);
        // 현재 원소를 포함하는 경우
        generateSubsets(set, index + 1, current + set[index]);
    }
}
```

## 🔧 자료구조별 시간 복잡도

각 자료구조의 특성과 연산별 시간 복잡도를 이해하면 효율적인 알고리즘 설계가 가능합니다:

```java
// ArrayList vs LinkedList 예시
import java.util.ArrayList;
import java.util.LinkedList;

public class DataStructureComparison {
    public void compareListOperations() {
        ArrayList<Integer> arrayList = new ArrayList<>();  // 인덱스 접근 O(1)
        LinkedList<Integer> linkedList = new LinkedList<>();  // 순차 접근 O(n)
        
        // ArrayList: 끝에 추가 O(1), 중간에 추가 O(n)
        arrayList.add(1);         // O(1)
        arrayList.add(0, 2);      // O(n)
        
        // LinkedList: 끝에 추가 O(1), 중간에 추가 O(1) (위치를 알고 있는 경우)
        linkedList.add(1);        // O(1)
        linkedList.addFirst(2);   // O(1)
    }
}
```

## 🎯 최적화 전략

### 1. 분할 정복 (Divide and Conquer)
큰 문제를 작은 부분 문제로 나누어 해결하는 전략입니다.

```java
public class DivideAndConquer {
    public int power(int x, int n) {
        if (n == 0) return 1;
        
        int half = power(x, n/2);
        if (n % 2 == 0)
            return half * half;
        else
            return half * half * x;
    }
}
```

### 2. 동적 프로그래밍 (Dynamic Programming)
중복 계산을 피하기 위해 결과를 저장하고 재사용하는 전략입니다.

```java
public class DynamicProgramming {
    public int fibonacciDP(int n) {
        if (n <= 1) return n;
        
        int[] dp = new int[n + 1];
        dp[0] = 0;
        dp[1] = 1;
        
        for (int i = 2; i <= n; i++) {
            dp[i] = dp[i-1] + dp[i-2];
        }
        
        return dp[n];
    }
}
```

## 📊 성능 최적화 팁

1. **적절한 자료구조 선택**
   - 검색이 빈번한 경우: HashSet/HashMap (O(1))
   - 정렬이 필요한 경우: TreeSet/TreeMap (O(log n))
   - 순차적 접근이 많은 경우: ArrayList (O(1))

2. **알고리즘 선택 시 고려사항**
   - 입력 데이터의 크기
   - 데이터의 특성 (정렬 여부, 중복 여부 등)
   - 메모리 제약 사항
   - 실행 시간 요구사항

## 시간 복잡도 최적화 방법

### 1. 적절한 자료구조 선택

자료구조별 시간 복잡도를 고려하여 상황에 맞는 최적의 자료구조를 선택합니다:

| 자료구조 | 접근 | 검색 | 삽입 | 삭제 |
|---------|------|------|------|------|
| 배열 | O(1) | O(n) | O(n) | O(n) |
| 연결 리스트 | O(n) | O(n) | O(1) | O(1) |
| 이진 검색 트리 | O(log n) | O(log n) | O(log n) | O(log n) |
| 해시 테이블 | O(1) | O(1) | O(1) | O(1) |

### 2. 알고리즘 최적화 기법

1. **분할 정복 (Divide and Conquer)**
   - 문제를 더 작은 하위 문제로 분할
   - 각 하위 문제를 해결
   - 결과를 합쳐 전체 문제 해결

2. **동적 프로그래밍 (Dynamic Programming)**
   - 중복 계산을 피하기 위한 메모이제이션 활용
   - 하위 문제의 결과를 저장하고 재사용

3. **탐욕 알고리즘 (Greedy Algorithm)**
   - 각 단계에서 최적의 선택
   - 지역적 최적해를 통해 전역적 최적해 도출

### 결론

알고리즘의 성능을 이해하고 최적화하는 것은 소프트웨어 개발에서 매우 중요합니다. Big-O 표기법을 통해 알고리즘의 효율성을 객관적으로 평가하고, 이를 바탕으로 더 나은 해결책을 찾을 수 있습니다. 시간 복잡도와 공간 복잡도를 모두 고려하여 상황에 맞는 최적의 알고리즘을 선택하는 것이 중요합니다.
