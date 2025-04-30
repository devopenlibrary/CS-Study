## GCD(Greatest Common Divisor) 알고리즘
> GCD란 영어 단어 그대로 최대공약수라는 뜻입니다. 최대공약수는 공약수 중에서 가장 큰 값을 의미합니다.

### 공약수
> 사전에서는 둘 이상의 정수에 공통된 약수라고 정의되어 있습니다. 정수 두 개를 놓고 보았을 때, 둘 다 나누어 떨어지게 만들 수 있는 수를 공약수라고 합니다.

예시

- 16의 약수: 1, 2, 4, 8, 16
- 24의 약수: 1, 2, 3, 4, 6, 8, 12, 24

16과 24의 공약수는 1, 2, 4, 8이고, 최대공약수는 8입니다.

### 유클리드 호제법(Euclidean algorithm)
- 최대공약수를 구하는 알고리즘입니다.
- 2개의 자연수 a, b(a > b)에 대해서 a를 b로 나눈 나머지를 r이라고 했을 때, a와 b의 최대 공약수는 b와 r의 최대공약수와 같습니다.
  - `(a, b) = (b, a % b)`
  - 이 방법을 나머지가 0이 될 때까지 반복하면 a와 b의 최대공약수가 됩니다.

예시
- 16과 24의 최대공약수를 구하면 (24, 16) = (16, 8) = (8, 0)로 이전 계산과 같습니다.

### GCD Algorithm(Euclidean algorithm)의 자바 코드
- b와 a를 b로 나눈 나머지의 값을 b의 인자로 계속 보내주면서 b 인자 자리에 위치한 값이 0이 될 때까지 재귀적으로 호출하는 코드입니다.

```java
// 재귀 함수
public static int gcd(int a, int b) {
	if (b == 0) return a;
	return gcd(b, a % b);
}

// 반복문
public static int gcd(int a, int b) {
    int c;
    while(b != 0) {
    	c = a % b;
        a = b;
        b = c;
    }
    return a;
}
```

## LCM(Least common multiple) 알고리즘
> 최소공배수라는 뜻으로 최소공배수는 공배수 중에서 가장 작은 값을 의미합니다.

### 공배수
> 공배수는 두 개 이상인 자연수의 공통인 배수라는 뜻입니다. 쉽게 말해 여러 개의 수가 있을 때, 공통적으로 배수가 되는 수를 말하는 것입니다. 두 개 이상의 모든 공배수는 최소공배수의 배수입니다.

예시
- 3의 배수: 3, 6, 9, 12, 15, 18, 21, 24, ...
- 4의 배수: 4, 8, 12, 16, 20, 24, ...

3과 4의 공배수는 12와 24이고, 최소공배수는 12입니다.

### GCD와 LCM 사이의 관계
두 자연수 A와 B의 최대공약수를 G, 최소공배수를 L이라고 하면, `A = G x a, B = G x b(a, b는 서로소)`로 나타낼 수 있습니다.

- `L = G x a x b`
- `A x B = (a x G) x (b x G) = (a x b x G) x G = L x G`
- 식은 `A x B = L x G`로 간단하게 나타낼 수 있고, `L = A x B / G`라고 표현할 수도 있습니다.

![](/Algorithm/img/ag_gcd_lcm_1.png)

예시 - 16과 24
최대공약수 G는 8이 되고, 이를 바탕으로 최소공배수 L은 48이 됩니다.

- G = 8
- A = 8 x 3 = 24
- B = 8 x 2 = 16

위 값을 기준으로 LCM을 구하면 아래 두 방법으로 구할 수 있고, 2번은 GCD를 활용한 방식입니다.
1. L = 8 x 3 x 2 = 48
2. L = 24 x 16 / 8 = 48

### LCM 식
앞서 GCD를 구하는 알고리즘을 알고 있다는 가정 하에 아래의 식을 통해 구할 수 있습니다.
- `LCM(a, b) = a x b / GCD(a, b)`

### LCM 알고리즘
- GCD 알고리즘을 기반으로 구할 수 있습니다.
```java
public static int lcm(int a, int b) {
    return a * b / gcd(a, b);
}
```

## 참고 자료
[GeeksforGeeks - GCD](https://www.geeksforgeeks.org/program-to-find-gcd-or-hcf-of-two-numbers/)