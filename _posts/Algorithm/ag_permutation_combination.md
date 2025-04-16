# 순열 & 조합

## 순열(Permutation)

> 서로 다른 n개 중에서 r개를 뽑아 순서를 고려하여 정렬하는 경우의 수
>
- 순서를 중요하게 생각함 → `[1, 2]`와 `[2, 1]`은 다른 경우로 취급
- 공식:

![permutation.png](https://github.com/user-attachments/assets/2af8c3f2-3545-4bf8-a486-fa54fefce0a4)

- 예시
  - `{1, 2, 3}`에서 2개를 뽑는 순열 → `(1,2), (1,3), (2,1), (2,3), (3,1), (3,2)` → 총 `6`가지 경우
- 구현

```java
public class Permutation {
	static int[] answer; // 선택된 숫자들을 저장할 배열 (순열 결과)
	static int r; // 순열으로 뽑을 숫자의 개수 (r)
	static int[] arr; // 순열의 대상이 되는 배열 (총 n개 중 선택)
	static int[] visited; // 각 숫자의 선택 여부를 표시합니다 (1: 선택됨, 0: 미선택)

	// index는 현재 순열에서 채울 위치(0부터 시작)
	private static void permutation(int index) {
		// 선택된 숫자의 개수가 r과 같으면 순열 완성 → 출력 후 종료
		if (index == r) {
			for (int i = 0; i < r; i++) {
				System.out.print(answer[i] + " ");
			}
			System.out.println();
			return;
		}
		
		// arr 배열의 모든 숫자에 대해 반복
		for (int i = 0; i < arr.length; i++) {
			// 만약 arr[i]가 이미 선택되었으면 건너뜁니다.
			if (visited[i] == 1) {
				continue; // 이미 선택된 경우 skip
			}

			answer[index] = arr[i]; // 숫자 선택
			visited[i] = 1; // 숫자 선택 여부
			permutation(index + 1); // 다음 숫자 선택 (재귀)
			visited[i] = 0; // 숫자 선택 취소
		}
	}

	public static void main(String[] args) {
		arr = new int[]{1, 2, 3};
		r = 2;
		
		answer = new int[n];
		visited = new int[arr.length];

		permutation(0);
	}
}

```

## 중복 순열(Repeated Permutation)

> 서로 다른 n개 중에서 r개를 뽑아, 중복을 허용하고 순서를 고려하는 경우의 수
>
- 같은 원소를 여러 번 선택할 수 있음
- 공식:

![repeatedPermutation.png](https://github.com/user-attachments/assets/d478d16c-e303-466e-af56-aaa9af2413e0)

- 예시
  - `{1, 2, 3}`에서 2개를 뽑는 중복 순열 → `(1,1), (1,2), (1,3), (2,1), (2,2), (2,3), (3,1), (3,2), (3,3)` → 총 `9`가지 경우
- 구현
  - 순열에서 중복을 체크하는 부분을 삭제해주면 됨

```java
public class RepeatedPermutation {
	static int[] answer; // 선택된 숫자들을 저장할 배열 (순열 결과)
	static int r; // 순열으로 뽑을 숫자의 개수 (r)
	static int[] arr; // 순열의 대상이 되는 배열 (총 n개 중 선택)
	
	// 재귀적으로 순열(중복 허용)을 생성합니다.
  // index는 현재 선택할 위치를 나타냅니다.
	private static void permutation(int index) {
		// 현재까지 선택한 숫자의 개수가 n과 같으면, 출력
		if (index == r) {
			for (int i = 0; i < r; i++) {
				System.out.print(answer[i] + " ");
			}
			System.out.println();
			return;
		}
		
		// arr 배열의 모든 숫자에 대해 반복합니다.
    // 중복 선택이 허용되므로, 매번 전체 배열을 순회합니다.
		for (int i = 0; i < arr.length; i++) {
			answer[index] = arr[i]; // 숫자 선택
			permutation(index + 1); // 다음 숫자 선택 (재귀)
		}
	}

	public static void main(String[] args) {
		arr = new int[]{1, 2, 3};
		r = 2;

		answer = new int[n];

		permutation(0);
	}
}
```

## 조합(Combination)

> 서로 다른 n개 중에서 r개를 뽑아 순서를 고려하지 않는 경우의 수
>
- 순서는 고려하지 않음 → `[1, 2]`와 `[2, 1]`은 같은 경우로 취급
- **공식**:

![combination.png](https://github.com/user-attachments/assets/87f5331b-5764-4c0d-8838-5501f308633a)

- **예시**
  - `{1, 2, 3}`에서 2개를 뽑는 조합 → `{1,2}, {1,3}, {2,3}` → 총 `3`가지 경우
- 구현

```java

public class Combination {
	static int[] answer; // 선택된 숫자들을 저장할 배열 (조합 결과)
	static int r; // 조합으로 뽑을 숫자의 개수 (r)
	static int[] arr; // 조합의 대상이 되는 배열 (총 n개 중 선택)

	// combination 메서드:
	// start: 탐색 시작 인덱스
	// size: 현재까지 선택된 숫자의 개수
	private static void combination(int start, int size) {
		if (size == r) {
			// 완성된 조합을 출력
			for (int i = 0; i < r; i++) {
				System.out.print(answer[i] + " ");
			}
			System.out.println();
			return;
		}

		// start부터 배열의 끝까지 반복
		// 순서를 고려하지 않으므로, 이전에 선택한 숫자보다 인덱스가 큰 숫자들만 선택
		for (int i = start; i < arr.length; i++) {
			// 현재 위치에 arr[i]를 선택하여 저장
			answer[size] = arr[i];
			// 다음 숫자를 선택하기 위해 재귀 호출 (i+1로 다음 인덱스부터 탐색)
			combination(i + 1, size +1);
		}

	}

	public static void main(String[] args) {
		arr = new int[] {1, 2, 3};
		r = 2;
		answer = new int[r];
		combination(0,0);
	}

}

```

## 중복 조합(Repeated Combination)

> 서로 다른 n개 중에서 r개를 뽑아, 중복을 허용하지만 순서를 고려하지 않는 경우의 수
>
- 같은 원소를 여러 번 선택할 수 있음.
- 공식:

![repeatedCombination.png](https://github.com/user-attachments/assets/e681b6ba-998c-4eb2-8e4b-361603c7985a)

- 예시
  - `{1, 2, 3}`에서 2개를 뽑는 중복 조합 → `(1,1), (1,2), (1,3), (2,2), (2,3), (3,3)` → 총 6가지 경우
- 구현

```java

public class RepeatedCombination {
	static int[] answer; // 선택된 숫자들을 저장할 배열 (조합 결과)
	static int r; // 조합으로 뽑을 숫자의 개수 (r)
	static int[] arr; // 조합의 대상이 되는 배열 (총 n개 중 선택)

	// start: 탐색 시작 인덱스
	// size: 현재까지 선택된 숫자의 개수
	private static void repeatedCombination(int start, int size) {
		if (size == r) {
			// 완성된 조합을 출력
			for (int i = 0; i < r; i++) {
				System.out.print(answer[i] + " ");
			}
			System.out.println();
			return;
		}

		// start 인덱스부터 배열의 끝까지 반복
		// 중복 조합이므로, 동일한 원소를 다시 선택할 수 있도록 i를 start부터 시작 (즉, 인덱스의 중복 허용)
		for (int i = start; i < arr.length; i++) {
			answer[size] = arr[i];
			repeatedCombination(i, size + 1);

		}

	}

	public static void main(String[] args) {
		arr = new int[]{1, 2, 3};
		r = 2;
		answer = new int[r];
		repeatedCombination(0,0);
	}

}

```

### 참고

[Permutation Algorithm(순열 알고리즘) & Combination Algorithm(조합 알고리즘)](https://rutgo-letsgo.tistory.com/entry/Permutation-Algorithm%EC%88%9C%EC%97%B4-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-Combination-Algorithm%EC%A1%B0%ED%95%A9-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98)

[[알고리즘] 순열과 조합](https://velog.io/@chancehee/%EC%88%9C%EC%97%B4%EA%B3%BC-%EC%A1%B0%ED%95%A9)