# 이분 탐색 (Binary Search)

![](/Algorithm/img/ag_binary_search.gif)

- **정렬되어 있는 리스트** 에서 **탐색 범위를 절반씩 나누어가며 데이터를 탐색** 하는 알고리즘.

- 탐색 할 때마다 탐색 범위가 절반씩 좁혀가기 때문에, O(log n) 까지 속도를 줄 일 수 있다.

# 구현

_오름차순으로 정렬된 정수 배열 nums와 정수 target이 주어졌을 때, nums에서 target을 검색하는 함수를 작성하시오. target이 존재하면 그 인덱스를 반환하고, 존재하지 않으면 -1을 반환하시오._

- 범위의 **경계(최소, 최대)** 를 나타내는 변수 `lo`, `hi`
- 범위의 **중간 요소** 를 나타내며, 범위를 **절반으로 나는 기준**이 되는 변수 `mid`. 타겟 과 비교하며, 타겟 이 속하는 범위를 판단한다.

  1.  타겟이 크다면, 최소 경계인 `lo` 를 변경
  2.  타겟이 작다면, 최대 경계인 `hi` 를 변경
  3.  타겟이 같다면, 탐색 성공

- **타겟과 `mid` 의 값을 비교** 하며, **범위의 경계(`lo`, `hi`) 를 변경**하여 타겟이 속하는 범위를 점차 좁혀나가, 타겟이 위치한 인덱스를 찾아낸다.

## 구현 방법 1 - 재귀

```javascript
const search = (nums, target) => {
  const lo = 0;
  const hi = nums.length - 1;

  return binary_search(nums, target, lo, hi);
};

const binary_search = (nums, target, lo, hi) => {
  if (lo > hi) return -1;

  // 범위 중간요소 mid 계산
  const mid = lo + Math.floor((hi - lo + 1) / 2);

  // 타겟이 같다면, 탐색 성공
  if (nums[mid] === target) {
    return mid;
  }

  // 타겟이 작다면, 최대 경계인 hi 를 변경
  if (nums[mid] > target) {
    return binary_search(nums, target, lo, mid - 1);
  }

  // 타겟이 크다면, 최소 경계인 lo 를 변경
  if (nums[mid] < target) {
    return binary_search(nums, target, mid + 1, hi);
  }
};
```

## 구현 방법 2 - 반복

- 앞선 재귀와 다르게,

```javascript
const search = (nums, target) => {
  let lo = 0;
  let hi = nums.length - 1;

  // 타겟이 같다면 (lo === hi), 탐색 성공
  while (lo < hi) {
    let mid = lo + Math.floor((hi - lo + 1) / 2);

    if (target < nums[mid]) {
      // 타겟이 작다면, 최대 경계인 hi 를 변경
      hi = mid - 1;
    } else if (target >= nums[mid]) {
      // 타겟이 크다면, 최소 경계인 lo 를 변경
      lo = mid;
    }
  }

  return nums[lo] === target ? lo : -1;
};
```

# 출처

- [이분 탐색(Binary Search) 헷갈리지 않게 구현하기](https://www.acmicpc.net/blog/view/109)
- [Binary Search 101](https://leetcode.com/problems/binary-search/solutions/423162/binary-search-101-by-aminick-kkch/)
