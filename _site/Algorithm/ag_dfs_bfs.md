## DFS와 BFS

그래프 탐색에서 가장 기본이 되는 방법 두 가지가 바로 **DFS(Depth First Search)**와 **BFS(Breadth First Search)**입니다. DFS는 그래프에서 한 방향으로 갈 수 있는 곳까지 깊이 들어가며 탐색하고, BFS는 시작 정점으로부터 가까운 순으로(너비 우선으로) 탐색을 진행합니다.

![](/Algorithm/img/ag_dfs_bfs_1.png)

---

## DFS (Depth First Search)

### DFS란?
- **깊이 우선 탐색**: 시작 정점에서 한 방향으로 갈 수 있는 정점 끝까지 탐색을 마친 뒤, 다시 돌아와 다른 방향을 탐색하는 방식입니다.
- **재귀**나 **스택**을 이용해 구현 가능합니다.

### DFS의 특징
- 트리나 그래프의 한 갈래를 먼저 끝까지 탐색
- 백트래킹(Backtracking)과 함께 사용되어 그래프, 트리 문제를 효율적으로 해결 가능
- BFS에 비해 경로를 찾거나 (예: 미로 찾기) 모든 경로를 조사해야 할 때 유용

### DFS 동작 과정 예시
1. **시작 정점 방문**: 시작 정점을 방문하고, 방문했다고 표시
2. **인접한 정점 순회**: 해당 정점에 연결된(인접한) 정점을 하나씩 방문 (재귀 혹은 스택 사용)
3. **갈 수 있는 곳까지 깊이 탐색**: 더 이상 진행할 수 없으면 이전 경로로 돌아와(백트래킹) 탐색 안 한 경로를 다시 진행

### DFS 기본 구조 (Java)
```java
public class DFSMatrix {
    static int[][] graph;    // 인접 행렬
    static boolean[] visited; 
    static int n = 5;        // 노드 개수(0~4)
    
    public static void main(String[] args) {
        graph = new int[n][n];
        visited = new boolean[n];

        // 그래프 연결 정보 (무방향)
        // 0 ↔ 1
        graph[0][1] = 1; 
        graph[1][0] = 1;
        
        // 0 ↔ 2
        graph[0][2] = 1;
        graph[2][0] = 1;
        
        // 1 ↔ 3
        graph[1][3] = 1;
        graph[3][1] = 1;
        
        // 2 ↔ 4
        graph[2][4] = 1;
        graph[4][2] = 1;
        
        // 3 ↔ 4
        graph[3][4] = 1;
        graph[4][3] = 1;

        // DFS 수행 (시작 노드: 0)
        System.out.print("DFS 방문 순서: ");
        dfs(0);
        System.out.println();
    }

    // 재귀 함수를 사용한 DFS
    public static void dfs(int node) {
        visited[node] = true;
        System.out.print(node + " ");

        // 인접 노드 탐색
        for (int next = 0; next < n; next++) {
            // 연결되어 있고, 아직 방문하지 않은 노드라면 재귀 호출
            if (graph[node][next] == 1 && !visited[next]) {
                dfs(next);
            }
        }
    }
}
```
- 방문 순서: `0 -> 1 -> 3 -> 4 -> 2`

---

## BFS (Breadth First Search)

### BFS란?
- **너비 우선 탐색**: 시작 정점으로부터 가까운 정점을 먼저 방문하고, 점차 멀리 있는 정점을 방문해 나가는 방식입니다.
- **큐(Queue)**를 이용해 구현할 수 있습니다.

### BFS의 특징
- 최단 경로 문제에서 유용  
  (가중치가 동일한 그래프에서 **시작 정점으로부터 최단 거리**를 구할 때)
- 방문 순서를 인접한 정점들부터 차례대로(너비 우선) 처리

### BFS 동작 과정 예시
1. **시작 정점을 큐에 삽입**하고, 방문했다고 표시
2. **큐에서 정점을 꺼냄** → 해당 정점과 인접한(연결된) 정점들을 큐에 삽입 (아직 방문 안 했을 경우)
3. 큐가 빌 때까지 2번 과정을 반복

### BFS 기본 구조 (Java)
```java
import java.util.LinkedList;
import java.util.Queue;

public class BFSMatrix {
    static int[][] graph;    
    static boolean[] visited;
    static int n = 5;        // 노드 개수(0~4)

    public static void main(String[] args) {
        graph = new int[n][n];
        visited = new boolean[n];

        // 그래프 연결 정보 (무방향)
        // 0 ↔ 1
        graph[0][1] = 1;
        graph[1][0] = 1;
        
        // 0 ↔ 2
        graph[0][2] = 1;
        graph[2][0] = 1;
        
        // 1 ↔ 3
        graph[1][3] = 1;
        graph[3][1] = 1;
        
        // 2 ↔ 4
        graph[2][4] = 1;
        graph[4][2] = 1;
        
        // 3 ↔ 4
        graph[3][4] = 1;
        graph[4][3] = 1;

        // BFS 수행 (시작 노드: 0)
        System.out.print("BFS 방문 순서: ");
        bfs(0);
        System.out.println();
    }

    public static void bfs(int start) {
        Queue<Integer> queue = new LinkedList<>();
        visited[start] = true;
        queue.offer(start);

        while (!queue.isEmpty()) {
            int node = queue.poll();
            System.out.print(node + " ");

            // 인접 노드 탐색
            for(int next = 0; next < n; next++) {
                // 연결되어 있고, 아직 방문하지 않은 노드
                if (graph[node][next] == 1 && !visited[next]) {
                    visited[next] = true;
                    queue.offer(next);
                }
            }
        }
    }
}
```
- 방문 순서: `0 -> 1 -> 2 -> 3 -> 4`
---

## DFS와 BFS의 비교

| 특징               | DFS                                                     | BFS                                                     |
|--------------------|---------------------------------------------------------|---------------------------------------------------------|
| **탐색 방향**     | 시작 정점에서 갈 수 있는 곳까지 깊게 들어감             | 시작 정점에서 가까운 정점부터 순차적으로 방문           |
| **자료구조**       | 재귀(스택)                                              | 큐(Queue)                                              |
| **최단 경로**      | 경로를 모두 탐색하며 찾을 수 있으나, 일반적으로 BFS보다<br>빠른 최단 경로 확인은 어려움 | 동일 가중치 그래프에서<br>최단 경로 찾기에 적합         |
| **적용 예시**     | 백트래킹, 사이클 여부 확인, 위상 정렬(변형) 등           | 최단 거리 계산, 층(level)별 탐색, 너비 우선 검색 등      |
| **구현 난이도**   | 재귀나 반복(스택)로 비교적 단순                           | 큐를 사용하기 때문에 구조는 간단하지만<br>코드가 약간 더 길어질 수 있음 |

---

## 참고 자료
1. [백준 온라인 저지 - 그래프 탐색](https://www.acmicpc.net/problemset?sort=ac_desc&algo=7)  
2. [GeeksforGeeks - DFS](https://www.geeksforgeeks.org/depth-first-search-or-dfs-for-a-graph/)  
3. [GeeksforGeeks - BFS](https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/)

---

위 예시 코드를 참고하여 **그래프를 어떻게 표현(인접 리스트/인접 행렬)하느냐**에 따라 구현이 조금씩 달라질 수 있습니다. 실제 프로젝트나 문제 풀이에서, 그래프의 특성(노드 개수, 간선 개수, 가중치 유무 등)에 맞춰 적절한 방식으로 DFS와 BFS를 활용하면 됩니다.