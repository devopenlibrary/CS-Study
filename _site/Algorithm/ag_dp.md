## DP (Dynamic Programming)

- 여러 개의 하위 문제를 풀고 **그 결과를 기록하고 이용해 문제를 해결**하는 알고리즘
- 핵심
    - **중복 계산 방지** (Memoization, Tabulation)
    - **최적 부분 구조** (Optimal Substructure)
    
    ![](/Algorithm/img/ag_dp_1.png)
    

    ```java
    Fibo(1) = 1
    Fibo(2) = 1
    Fibo(3) = Fibo(1) + Fibo(1) = 1 + 1 = 2
    Fibo(4) = Fibo(3) + Fibo(2) = 2 + 1 = 3
    Fibo(5) = Fibo(4) + Fibo(3) = 3 + 2 = 5
    Fibo(6) = Fibo(5) + Fibo(4) = 5 + 3 = 8
    ...
    Fibo(n) = Fibo(n - 1) + Fibo(n-2) 

    중복된 작업을 반복적으로 실행되므로 이미 했던 일을 기록할 필요가 생김
    👉 **Memoization**

    memo = {
        1: 1,
        2: 1,
        3: 2
        ...
    }
    ```

---

## LIS (Longest Increasing Subsequence, 최장 증가 부분 수열)

- 증가 부분 수열: 선택한 원소들이 오름차순을 이루는 부분 수열
- LIS 문제는 이러한 증가 부분 수열 중 **가장 긴 길이를 찾는 것**이 목표

### 1. DP 방식 (O(n²))

- `dp[i]`: i번째 요소를 끝으로 하는 LIS의 최대 길이
    
    ```
    dp[i] = max(dp[j] + 1)  (j < i, arr[j] < arr[i])
    ```
    
    ```java
    public static int lis(int[] arr) {
        int n = arr.length;
        int[] dp = new int[n];  // dp[i]: i번째 요소를 끝으로 하는 LIS 길이
        Arrays.fill(dp, 1);     // [1, 1, 1, 1, 1, 1]
    
        for (int i = 1; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (arr[j] < arr[i]) {  // 증가하는 경우
                    dp[i] = Math.max(dp[i], dp[j] + 1);  
                }
            }
        }
        
        return Arrays.stream(dp).max().getAsInt();
    }
    ```
    
    ```java
    dp[1] = max(dp[0] + 1) = 2 // (10 → 20)
    dp[3] = max(dp[1] + 1) = 3 // (10 → 20 → 30)
    dp[5] = max(dp[3] + 1) = 4 // (10 → 20 → 30 → 50)
    // dp: [1, 2, 1, 3, 2, 4]`
    
    입력: [10, 20, 10, 30, 20, 50]
    결과: 4
    dp: [1, 2, 1, 3, 2, 4]
    ```
    

### 2. DP + 이분 탐색 방식 (O(n log n))

- `list[i]`: 길이가 `i+1`인 증가 부분 수열의 최소 마지막 값
- 이분 탐색을 활용하여 `list`를 갱신
    
    ```java
    public static int lisBinarySearch(int[] arr) {
    		ArrayList<Integer> list = new ArrayList<>();
    		for (int num : arr) {
    		    int pos = Collections.binarySearch(list, num); // num의 위치 탐색
    		    
    		    if (pos < 0) pos = -pos - 1;  // 음수 값이면 삽입 위치 변환
    		    
    		    if (pos == list.size()) list.add(num);
    		    
    		    else list.set(pos, num);  // 기존 값 갱신
    		}
    		
    		return list.size();
    }
    ```
    
    | 단계 | num 값 | pos 값 | list 변화 |
    | --- | --- | --- | --- |
    | 1 | 10 | 0 | [10] |
    | 2 | 20 | 1 | [10, 20] |
    | 3 | 10 | 0 | [10, 20]  |
    | 4 | 30 | 2 | [10, 20, 30] |
    | 5 | 20 | 1 | [10, 20, 30]  |
    | 6 | 50 | 3 | [10, 20, 30, 50] |

**활용**

- **데이터 압축**: LCS(최장 공통 부분 수열)와 함께 사용하여 중복 제거
- **자연어 처리**: 문장 내 의미 흐름을 분석하여 키워드 추출

---

## LCA (Lowest Common Ancestor, 최소 공통 조상)

- 트리에서 **두 노드의 가장 가까운 공통 조상**을 찾는 문제

### 예제 트리

```java
          1
        /   \
       2     3
      / \   / \
     4   5 6   7
    
    
 1 = LCA(4, 6, { -1, -1, 1, 1, 2, 2, 3, 3 })
			ancestors = {4, 2, 1}
```

### 1. 기본 방식 (O(N))

- 부모를 계속 따라가며 공통 조상을 찾음
    
    ```java
    u와 v: LCA를 찾고자 하는 두 노드의 값.
    parent: 각 노드의 부모 노드 정보를 저장하는 배열. 
    parent[2] = 노드 1
    // parent = { -1, -1, 1, 1, 2, 2, 3, 3 };
    
    public static int LCA(int u, int v, int[] parent) {
    		
    		
        Set<Integer> ancestors = new HashSet<>();
        
        // u의 조상 집합 생성
        while (u != -1) {
            ancestors.add(u);
            u = parent[u];
        }
        
        // v의 조상 확인
        while (v != -1) {
            if (ancestors.contains(v)) return v;
            v = parent[v];
        }
        return -1;
    }
    ```
    
- 노드의 개수에 비례하여 조상을 찾기 때문에 최악의 경우 모든 노드를 탐색해야 할 수 있음

### 2. 희소 테이블을 이용한 방식 (O(log N))

- **`sparseTable[i][j]`를 사용하여 2^j 번째 부모를 저장**
    1. LOG(한 번에 이동할 수 있는 최대 점프 크기) 값 계산
    2. DFS로 깊이 설정 후 희소 테이블 초기화
    3. 희소 테이블(`parent[i][j]`) 저장
    
    ```java
    static int[][] parent; //노드 i의 2^j번째 부모를 저장하는 배열 (희소 테이블)
    static int[] depth; // 노드 i의 깊이 (루트로부터의 거리)
    static int LOG; // 최대 2^j 범위를 구하기 위한 log2(N)
    
    // 전처리 함수
    static void init(int n, List<Integer>[] tree) {
        LOG = (int) (Math.log(n) / Math.log(2)) + 1;
        parent = new int[n + 1][LOG];
        depth = new int[n + 1];
        
        dfs(1, -1, 0, tree); // (루트에서 시작)
        
        for (int j = 1; j < LOG; j++) {
            for (int i = 1; i <= n; i++) {
                if (parent[i][j - 1] != -1)
                    parent[i][j] = parent[parent[i][j - 1]][j - 1];
            }
        }
    }
    
    // 깊이 저장
    static void dfs(int node, int par, int dep, List<Integer>[] tree) {
        parent[node][0] = par;
        depth[node] = dep;
        
        for (int next : tree[node]) {
            if (next != par) dfs(next, node, dep + 1, tree);
        }
    }
    
    // LCA 찾기
    static int lca(int u, int v) {
        if (depth[u] < depth[v]) {
            int temp = u; 
            u = v; 
            v = temp;
        }
        
        // u의 깊이를 v의 깊이에 맞추기 위해 u를 조상으로 이동
        for (int j = LOG - 1; j >= 0; j--) {
        
            // u의 깊이가 v의 깊이보다 크거나 같으면 u의 2^j 번째 부모로 이동
            if (depth[u] - (1 << j) >= depth[v]) 
                u = parent[u][j];
        }
        
        if (u == v) return u;
        
        // u와 v가 다를 때, 두 노드의 조상을 찾음
        for (int j = LOG - 1; j >= 0; j--) {
            // u와 v의 2^j 번째 부모가 다를 때, 두 노드를 각각의 부모로 이동
            if (parent[u][j] != parent[v][j]) {
                u = parent[u][j];
                v = parent[v][j];
            }
        }
        
        return parent[u][0];
    }
    
    ```
    
    ```java
    parent[i][j]
    
    노드 번호(i)   →  1   2   3   4   5   6   7
    ------------------------------------------------
    j = 0 (1칸 위)   -1   1   1   2   2   3   3  
    j = 1 (2칸 위)   -1  -1  -1   1   1   1   1  
    j = 2 (4칸 위)   -1  -1  -1  -1  -1  -1  -1  
    ```
    

**활용**

- **네트워크 라우팅**: 네트워크 트리 구조에서 최단 경로 탐색
- **파일 시스템**: 디렉터리 구조에서 공통 최상위 폴더 찾기

---

### LIS vs. LCA

| 개념 | LIS (최장 증가 부분 수열) | LCA (최소 공통 조상) |
| --- | --- | --- |
| 구조 | 배열 기반 문제 | 트리 기반 문제 |
| 알고리즘 | DP + 이분 탐색 | DFS + DP (희소 테이블) |
| 시간 복잡도 | O(n log n) | O(log N) |
| 활용 예시 | 수열 최적화 문제 | 트리 탐색 문제 |


https://galid1.tistory.com/507

https://chanhuiseok.github.io/posts/algo-49/

https://loosie.tistory.com/364

[https://velog.io/@ddongh1122/알고리즘-LCA-알고리즘](https://velog.io/@ddongh1122/%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-LCA-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98)