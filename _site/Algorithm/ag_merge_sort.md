# 합병 정렬(Merge Sort)

## 합병정렬

`존 폰 노이만(John von Neumann)`이라는 사람이 제안한 방법으로 분할 정복 알고리즘 중 하나입니다.
기본 원리는 하나의 리스트를 두개의 균등한 크기로 분할하고, 분할된 부분 리스트를 정렬한 다음 두개의 정렬된 부분 리스트를 합하여 전체가 정렬된 리스트가 되게하는 방법입니다.

```
분할 정복
- 문제를 작은 2개의 문제로 분리하고 각각을 해결한 다음, 결과를 모아서 문제를 해결하는 방법
- 대개 순환 호출을 이용하여 구현
```

- 과정 설명
    - 리스트의 길이가 0 또는 1이면 이미 정렬된 것으로 본다.
    - 그렇지 않은 경우 정렬되지 않은 리스트로 본다.
    - 정렬되지않은 리스트를 절반으로 잘라 비슷한 크기의 두 부분 리스트로 나눈다
    - 각 부분 리스트를 재귀적으로 합병 정렬을 이용해 정렬한다.
    - 두 부분 리스트를 다시 하나의 정렬된 리스트로 합병한다.
- 예시

  ![image.png](https://github.com/user-attachments/assets/b6b0560d-2d88-4450-b896-88ef50caee9c)

  ![image.png](https://github.com/user-attachments/assets/9d52a065-0149-4286-8f85-387c10396e49)


## 합병정렬 알고리즘

- 합병 정렬은 크게 3단계로 이뤄집니다.
    - `분할(Divide)`
        - 정렬할 배열을 비슷한 크기의 두 부분 배열로 분할합니다.
        - 리스트를 더 이상 나눌 수 없는 단위(크기가 1인)리스트 까지 쪼개는 단계입니다.
    - `정복(Concuer)`
        - 분할된 각 부분(크기가 1인 리스트)이 정렬된 상태임을 전제로, 재귀적으로 정렬하는 과정을 포함하는 단계입니다.
        - 크기가 1인 리스트는 본질적으로 정렬된 상태이기 때문에, 이 단계에서는 별도의 정렬 작업 없이 바로 결합 단계로 넘어갑니다.
    - `결합(Combine)`
        - 분할과 정복을 통해 얻은 정렬된 부분 리스트들을 서로 병합하여 하나의 정렬된 리스트로 만드는 단계입니다.
        - 실제 정렬이 일어나는 부분이라고 볼 수 있습니다.

## 합병정렬 시간복잡도

합병 정렬의 시간복잡도는 최선, 평균, 최악 모두  `O(NlogN)`입니다.

- 분할 단계 : 리스트를 반씩 나누므로 재귀 호출의 깊이는 약 log₂n이 됩니다.
- 병합 단계 : 각 재귀 단계 마다 두 부분 리스트를 합치는 데 전체 원소 n에 대한 선형시간이 소요됩니다.
    - 두개의 정렬된 부분 배열에서 각 원소를 한번씩 비교하여 정렬된 순서로 합침
- 따라서 전체 시간복잡도는 O(n) × O(log n) = O(n log n)입니다.

![image.png](https://github.com/user-attachments/assets/8cebc734-a2d4-422d-948d-9dd2a30aef9e)

## 합병정렬 특징
- 장점 
  - 합병 정렬은 병합 과정에서 동일한 값의 순서를 보존함으로써 안정적인 정렬입니다.
  - 데이터의 분포에 영향을 덜 받습니다. 입력데이터가 어떻게 구성되어있든지 간에 log₂n이 보장됩니다.
  - 연결리스트(Linked List)로 구성하면, 링크 인덱스만 변경되므로 데이터 이동은 무시될 만큼 작아집니다.
- 단점
  - 데이터가 배열로 구성된 경우 추가적인 메모리 임시 배열이 필요합니다.
  - 배열 기반 합병 정렬에서는 데이터가 클 경우 반복적인 복사(이동)로 인한 오버헤드가 발생할 수 있습니다.
  
## 합병정렬 구현

```java
import java.util.Arrays;

public class MergeSort {

	// 두 정렬된 배열(left와 right)을 병합하여 하나의 정렬된 배열을 반환하는 메서드
	public static int[] merge(int[] left, int[] right) {
		int[] merged = new int[left.length + right.length]; // 병합 결과를 저장할 배열
		int leftPointer = 0;    // left 배열의 현재 인덱스
		int rightPointer = 0;   // right 배열의 현재 인덱스
		int mergeIndex = 0;     // merged 배열의 현재 인덱스

		// 두 배열의 요소를 비교하여 작은 값부터 merged 배열에 추가
		while (leftPointer < left.length && rightPointer < right.length) {
			if (left[leftPointer] > right[rightPointer]) {
				merged[mergeIndex++] = right[rightPointer++];
			} else {
				merged[mergeIndex++] = left[leftPointer++];
			}
		}

		// left 배열에 남은 요소들을 merged 배열에 추가
		while (leftPointer < left.length) {
			merged[mergeIndex++] = left[leftPointer++];
		}

		// right 배열에 남은 요소들을 merged 배열에 추가
		while (rightPointer < right.length) {
			merged[mergeIndex++] = right[rightPointer++];
		}

		return merged;  // 정렬된 병합 배열 반환
	}

	// 합병 정렬(Merge Sort) 재귀 메서드
	// 주어진 배열을 재귀적으로 반으로 나누고, 각 부분을 정렬 후 병합하여 전체 배열을 정렬
	public static int[] mergeSort(int[] arr) {
		// 배열의 길이가 1 이하이면 이미 정렬된 상태이므로 그대로 반환
		if (arr.length <= 1) {
			return arr;
		}

		// 배열을 두 부분으로 분할
		int mid = arr.length / 2;
		int[] left = Arrays.copyOfRange(arr, 0, mid);          // 왼쪽 부분 배열
		int[] right = Arrays.copyOfRange(arr, mid, arr.length);  // 오른쪽 부분 배열

		// 재귀적으로 각각의 부분 배열을 정렬
		left = mergeSort(left);
		right = mergeSort(right);

		// 정렬된 두 부분 배열을 병합하여 하나의 정렬된 배열로 반환
		return merge(left, right);
	}

	// 메인 메서드: 합병 정렬을 테스트하는 용도
	public static void main(String[] args) {
		int[] arr = {5, 4, 1, 9, 3, 7, 2, 6};  // 정렬할 배열
		int[] sorted = mergeSort(arr);           // 배열 정렬 수행
		System.out.println(Arrays.toString(sorted)); // 정렬된 배열 출력
	}
}


```

## 참고 자료

[알고리즘 합병정렬(Merge sort) 그림으로 쉽게 이해하기](https://rosweet-ai.tistory.com/52)

[[알고리즘] 합병 정렬(merge sort)이란 - Heee's Development Blog](https://gmlwjd9405.github.io/2018/05/08/algorithm-merge-sort.html)

[자료구조알고리즘-합병병합정렬](https://velog.io/@roro/%EC%9E%90%EB%A3%8C%EA%B5%AC%EC%A1%B0%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%ED%95%A9%EB%B3%91%EB%B3%91%ED%95%A9%EC%A0%95%EB%A0%AC)