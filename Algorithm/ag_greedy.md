# 그리디 (Greedy)

- 각 단계마다 최적이라고 생각되는 것을 선택 해 나가, 최종적으로 해답에 도달하는 알고리즘.

  - 항상 최적의 값을 보장하는것이 아니라 최적의 값의 ‘근사한 값’을 찾는 것을 목표로 한다.

- 예를 들어, 노드에서 가장 합이 높은 값을 선택하는 방법
  ![](/Algorithm/img/ag_greedy_ex_1.png)

  ✅ 그리디
  ![](/Algorithm/img/ag_greedy_ex_2.png)

# 조건

- **탐욕 선택 속성** (Greedy Choice Property) : **각 단계에서 가장 최적인 선택**을 하는 것으로, **전체적으로 최적의 결과**를 가져올 수 있어야 한다.

- **최적 부분 구조** (Optimal Substructure) : 전체 문제를 작은 부분 문제로 나누어 **각각의 부분 문제에서 최적의 해**를 구한 후 이를 조합하여 **전체 문제의 최적해**를 구할수 있어야 한다.

# 단계

1. 선택 절차 (Selection Procedure) : 현재 상태 에서 **최적인 선택**을 한다. 이 선택은 이후에는 바뀌지 않는다.
2. 적절성 검사(Feasibility Check) : **현재 선택이 문제의 조건을 만족시키는지 확인**한다. 조건을 만족시키지 않으면 해당 항목은 제외된다.

# 예제

_한 상점에서 사탕을 할인 판매하고 있습니다. 두 개의 사탕을 판매할 때마다 상점은 세 번째 사탕을 무료로 제공합니다.
고객은 구매한 두 개의 사탕 중 최소 비용 이하의 가격을 가진 사탕이라면 어떤 사탕이든 무료로 선택할 수 있습니다._

_예를 들어, 비용이 1, 2, 3, 4인 4개의 사탕이 있고 고객이 비용 2와 3인 사탕을 구매한다면, 비용 1인 사탕을 무료로 가져갈 수 있지만 비용 4인 사탕은 가져갈 수 없습니다._

_0부터 시작하는 정수 배열 cost가 주어지며, cost[i]는 i번째 사탕의 비용을 나타냅니다. 모든 사탕을 구매하는 데 필요한 최소 비용을 반환하세요._

---

**각 단계 에서 최적의 선택(3(혹은 1, 2) 개의 사탕마다, 최소의 비용으로 구매) 을 하여, 전체 문제의 최적의 결과 (모든 사탕을 최소 비용으로 구매) 이 가능하기 에, 그리디 알고리즘 으로 문제 해결 가능.**

```javascript
/**
 * @param {number[]} cost
 * @return {number}
 */
const minimumCost = (cost) => {
  const len = cost.length;
  if (len === 1) return cost[0];

  // 1. 선택 절차
  cost.sort((a, b) => b - a);
  let ans = cost[0] + cost[1];

  // 루프 를 통해, 각 단계 에서 최적의 선택을 구한다.
  for (let i = 3; i < len; i += 3) {
    // 무료로 얻을 수 있는 캔디 중, 가장 비싼 캔디를 skip 하고

    // 2. 적절성 검사
    if ((i + 1) % 3 === 0) {
      continue;
    }

    // 나머지 캔디를 구매
    ans += cost[i];

    if (i + 1 < len) {
      ans += cost[i + 1];
    }
  }
  return ans;
};
```

1. 선택 절차

- 모든 사탕을 구매해야 하기 때문에, 무료로 구매하는 사탕의 가격을 최대한으로 높여야한다.
- 그 방법으로 내림차순으로 정렬한다. 그렇게 되면, 각 세번째 사탕(무료) 은 가장 높은 순으로 정렬하게 된다.
- 또한, 2개의 사탕 중 최소 비용 이하의 가격을 가진 사탕만 가져야하는 문제의 조건도, 만족하게된다. 따라서, 이는 2. 적절성 검사 만족하게 한다.

  ```javascript
  cost.sort((a, b) => b - a);
  let ans = cost[0] + cost[1];
  ```

2. 적절성 검사

- 세 번째 사탕은 무료로 제공하기 때문에, 구매해선 안된다. 구매하는 경우는 제외한다.

  ```javascript
      if ((i + 1) % 3 === 0) {
      continue;
      }
  ```

# 출처

- [[Java/알고리즘] 그리디 알고리즘(탐욕법, Greedy Algorithm) 이해하기](<https://adjh54.tistory.com/212#2%EB%8B%A8%EA%B3%84%20%3A%20%EC%A0%81%EC%A0%88%EC%84%B1%20%EA%B2%80%EC%82%AC(Feasibility%20Check)-1-6>)
- [그리디 알고리즘(Greedy Algorithm, 탐욕법)](https://velog.io/@kyunghwan1207/%EA%B7%B8%EB%A6%AC%EB%94%94-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98Greedy-Algorithm-%ED%83%90%EC%9A%95%EB%B2%95#%EB%AC%B8%EC%A0%9C1-1%EC%9D%B4-%EB%90%A0-%EB%95%8C%EA%B9%8C%EC%A7%80)
- [Minimum Cost of Buying Candies With Discount](https://leetcode.com/problems/minimum-cost-of-buying-candies-with-discount/description/)
