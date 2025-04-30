## **스택 & 큐**

|  | **스택 (Stack)** | **큐 (Queue)** |
| --- | --- | --- |
| **구조** | LIFO (Last In, First Out) | FIFO (First In, First Out) |
| **시간복잡도** | `push()` → `O(1)`, `pop()` → `O(1)` | `enqueue()` → `O(1)`, `dequeue()` → `O(1)` |
| **사용** | 되돌리기(Undo), 백트래킹, 재귀 호출 대체 | 처리 순서가 중요한 경우, 탐색, 스케줄링 |
| **주요 알고리즘** | Monotonic Stack, 백트래킹, DFS | 슬라이딩 윈도우, BFS , 위상 정렬 |

## 스택 예제

### **Monotonic Stack**: `O(N)`

- 다음 큰 수 찾기 → 주식 가격 상승 분석, 온도 변화 예측
- 히스토그램에서 가장 큰 직사각형

**예제 - 다음 큰 수 찾기**

**🚫 기존 방식 (브루트포스 O(N²))**

- 모든 요소에 대해 오른쪽 숫자들과 비교해서 큰 수를 찾으면 O(N²) 걸림.

```java
public int[] nextGreaterElement(int[] nums) {
    int[] result = new int[nums.length];
    Arrays.fill(result, -1);

    for (int i = 0; i < nums.length; i++) {
        for (int j = i + 1; j < nums.length; j++) {
            if (nums[j] > nums[i]) {
                result[i] = nums[j];
                break;
            }
        }
    }
    return result;
}

```

**문제점**

1. 모든 숫자 쌍을 비교해야 하므로 느림 **O(N²)**
2. 데이터가 커질수록 연산량이 많음

```java
public int[] nextGreaterElement(int[] nums) {
    Stack<Integer> stack = new Stack<>();
    int[] result = new int[nums.length];
    Arrays.fill(result, -1);

    for (int i = 0; i < nums.length; i++) {
        while (!stack.isEmpty() && nums[stack.peek()] < nums[i]) {
            result[stack.pop()] = nums[i];
        }
        stack.push(i);
    }
    return result;
}
```

👉 스택을 활용하면

1.  한 번만 스캔 (push & pop: O(N)) 
2. 불필요한 비교를 제거

---

## 큐 예제

### **Sliding Window Maximum**: `O(N)`

- CPU 부하 측정, 실시간 온도 변화 감지, 주식 가격 분석

**코드 예제 - 슬라이딩 윈도우 최댓값 찾기**

**🚫 기존 방식 (브루트포스 O(N))**

- 슬라이딩 윈도우 범위 내에서 최대값을 찾기 위해 매번 `max()`를 호출

```java
public int[] maxSlidingWindow(int[] nums, int k) {
    int[] result = new int[nums.length - k + 1];

    for (int i = 0; i <= nums.length - k; i++) {
        int max = Integer.MIN_VALUE;
        for (int j = i; j < i + k; j++) {
            max = Math.max(max, nums[j]);
        }
        result[i] = max;
    }
    return result;
}

```

**문제점**

1. 매 윈도우마다 `max()`를 다시 계산 **O(NK)**
2. 윈도우 크기가 크면 연산량이 많음

```java
public int[] maxSlidingWindow(int[] nums, int k) {
    Deque<Integer> deque = new LinkedList<>();
    int[] result = new int[nums.length - k + 1];
    int idx = 0;

    for (int i = 0; i < nums.length; i++) {
        while (!deque.isEmpty() && deque.peekFirst() < i - k + 1) {
            deque.pollFirst(); // 범위를 벗어난 값 제거
        }
        while (!deque.isEmpty() && nums[deque.peekLast()] <= nums[i]) {
            deque.pollLast(); // 현재 값보다 작은 값 제거
        }
        deque.addLast(i);
        if (i >= k - 1) result[idx++] = nums[deque.peekFirst()];
    }
    return result;
}
```

👉 큐를 활용하면 

1. 한 번만 스캔 (O(N))  
2. 불필요한 비교 제거
3. 윈도우가 이동할 때마다 새로 정렬 x  → 시간 절약

https://upcurvewave.tistory.com/724

https://velog.io/@corone_hi/75.-Sliding-Window-Maximum