# Quick Sort

- **분할 정복(divide-and-conquer)** 방식의 정렬 알고리즘의 일종.
- 주어진 배열에서 **피벗(pivot)** 이라는 분할의 기준이 되는 요소를 선택하고, 이를 기준으로 배열을 두 개의 부분 배열(파티션) 로 나누어 정렬하는 방식으로 작동한다.

## 특징

- **시간 복잡도** : 평균적으로 O(n log n) 의 시간 복잡도를 가지지만(n 번 파티션을 나누고, 나눌때마다 탐색 범위가 절반이 되므로), 최악의 경우 O(n^2) (선택하는 모든 피벗이 가장 작은 값일 때) 이 될 수 있다.

- **메모리 사용** : 퀵 정렬은 정렬을 할 때, 추가적인 메모리가 필요없는 **제자리(in-place)** 정렬로, 추가적인 메모리 사용이 최소화된다.

## 단계

### 1. 피벗 선택 과 배열 분할 (분할)

배열에서 **임의의 요소**를 피벗으로 선택한다. 따라서, 피벗은 첫 번째 요소, 마지막 요소, 중간 요소, 또는 배열 내의 여러 요소 중 하나일 수 있다.

### 2. 정렬 (정복)

피벗을 기준으로 배열의 요소를 정렬한다. 피벗보다 작은 요소는 피벗의 왼쪽에, 큰 요소는 오른쪽에 위치하게 한다.

정렬하는 방식은 다음과 같다.

- `left`(혹은 `start`), `right`(혹은 `end`) 포인트를 피벗과 비교한다.
- `left` 가 가리키는 값이 피벗보다 작다면, 무시하고 포인터를 다음으로 이동한다.
- `left` 가 가리키는 값이 크다면, `right` 포인터가 가리기키는 값과 피벗을 비교한다.
  - `right` 가 가리키는 값이 피벗보다 크다면, 무시하고 포인터를 다음으로 이동한다.
  - `right` 가 가리키는 값이 피벗보다 작다면, `left` 가 가리키는 값과 교체(swap) 한다.
- `left` 와 `right` 가 엇갈린다면, 정렬을 멈춘다.

![](/Algorithm/img/ag_quick_sort_parti_1.png)

### 결합(Combine)

정렬된 부분 배열들을 하나의 배열에 합병한다.

```C
# include <stdio.h>
# define MAX_SIZE 9
# define SWAP(x, y, temp) ( (temp)=(x), (x)=(y), (y)=(temp) )

// 1. 피벗을 기준으로 2개의 부분 리스트로 나눈다.
// 2. 피벗보다 작은 값은 모두 왼쪽 부분 리스트로, 큰 값은 오른쪽 부분 리스트로 옮긴다.
/* 2개의 비균등 배열 list[left...pivot-1]와 list[pivot+1...right]의 합병 과정 */
/* (실제로 숫자들이 정렬되는 과정) */
int partition(int list[], int left, int right){
  int pivot, temp;
  int low, high;

  low = left;
  high = right + 1;
  pivot = list[left]; // 임의의 값을 피벗으로 선택(이 경우, 배열의 첫번째 요소를 피벗으로 선택.)

  /* low와 high가 교차할 때까지 반복(low < high) */
  do {
    /* list[low]가 피벗보다 작으면 계속 low를 증가 */
    do {
      low++; // low는 left+1 에서 시작
    } while (low <= right && list[low] < pivot);

    /* list[high]가 피벗보다 크면 계속 high를 감소 */
    do {
      high--; //high는 right 에서 시작
    } while (high >= left && list[high] > pivot);

    // pivot 과 비교하여 값이 크거나 작은 시점.
    // 만약 low와 high가 교차하지 않았으면 list[low]를 list[high] 교환
    if(low < high){
      SWAP(list[low], list[high], temp);
    }
  } while (low < high);

  // low와 high가 교차했으면(엇갈렸다면)ㅣ 반복문을 빠져나와 list[left]와 list[high]를 교환
  SWAP(list[left], list[high], temp);

  // 피벗의 위치인 high를 반환
  return high;
}

// 퀵 정렬
void quick_sort(int list[], int left, int right){

  if(left < right){
    int pivot = partition(list, left, right); // 피벗의 위치

    // 피벗은 제외한 2개의 부분 리스트를 대상으로 순환 호출
    quick_sort(list, left, pivot - 1); // left 부터 피벗 바로 앞 정렬
    quick_sort(list, pivot + 1, right); // 피벗 바로 뒤 부터 right 뒤 정렬
  }

}

void main(){
  int i;
  int n = MAX_SIZE;
  int list[n] = {5, 3, 8, 4, 9, 1, 6, 2, 7};

  quick_sort(list, 0, n-1);
}
```

# 출처

- [[알고리즘] 퀵 정렬(quick sort)이란](https://gmlwjd9405.github.io/2018/05/10/algorithm-quick-sort.html)
- [[자료구조 알고리즘] 퀵정렬(Quicksort)에 대해 알아보고 자바로 구현하기](https://www.youtube.com/watch?v=7BDzle2n47c)
