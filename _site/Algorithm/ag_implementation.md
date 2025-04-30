## 구현(Implementation)

### 구현(Implementation)이란?
알고리즘을 작성할 때, 특정 알고리즘 개념이나 자료구조보다 **구현의 정확성**이 더 큰 비중을 차지하는 문제들이 있습니다. 이처럼 문제에서 요구하는 과정을 단계별로 **직접 코드로 옮기는 작업**을 중시하는 것을 구현 문제라 합니다.

예컨대, 시뮬레이션을 하듯 문제에서 제시한 규칙을 하나씩 적용해가며, 최종적으로 원하는 결과를 출력해야 하는 유형 등이 대표적입니다.

## 구현 문제의 특징
1. **알고리즘의 난이도보다는 꼼꼼함이 요구**됨  
   - 복잡한 알고리즘을 요구하지 않고, 주어진 로직을 그대로 따라가거나 시뮬레이션하는 형식이 많습니다.
2. **에지 케이스(Edge Case) 처리**가 중요  
   - 예상치 못한 입력이나 극단적인 범위에서의 동작을 제대로 처리하지 않으면 오답이 됩니다.
3. **다양한 자료구조나 언어 기능 사용**  
   - 문자열 파싱, 배열 인덱스 처리, 조건문 등 다양하게 사용합니다.
4. **실수가 발생하기 쉬움**  
   - 일반적으로 구현 문제는 조건이 복잡하게 구성되어 있기 때문에 실수가 많이 발생합니다. 또한 인덱스 범위, 조건 분기, 변수 초기화 실수 등 사소한 부분에서 오류가 날 가능성이 높으므로 디버깅 시간이 많이 소요됩니다. 

## 구현 시 주의사항
1. **문제에서 요구하는 입출력 형식을 정확히 지키기**  
   - "공백 하나" 또는 "줄바꿈" 하나 차이로 오답이 될 수 있습니다.
2. **에지 케이스를 고려한 충분한 테스트**  
   - 최소/최대 범위의 입력, 빈 문자열 처리, 음수나 0이 포함될 때 등 평소에 놓치기 쉬운 케이스에 대한 검증이 필요합니다.
3. **코너 케이스에 대한 조건 처리**  
   - 예를 들어, 반복문에서 인덱스가 -1이 되거나 배열 크기를 초과하는지, 문자열의 끝까지 도달했는지 등을 항상 점검합니다.
4. **변수 사용에서의 오탈자와 자료형 범위**  
   - int/long과 같은 자료형 범위 부족, 혹은 중복된 변수명 등 기본적인 실수에 유의합니다.

## 구현 문제 예시 유형

### 1. 시뮬레이션(Simulation) 유형
- 주어진 규칙에 따라 객체나 지점이 **어떻게 이동**하거나 **상태가 변화**하는지를 단계별로 직접 따라가며 구현합니다.
- 예: 보드 게임 시뮬레이션, 로봇 명령 실행, 2D 격자에서의 이동 등

#### 간단 예시 (자바)

```java
import java.util.Scanner;

public class SimulationExample {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // 1. 보드의 크기 입력 (예: n=5 -> 5x5 좌표)
        int n = sc.nextInt(); 
        sc.nextLine();  // nextInt() 후의 줄바꿈 제거

        // 2. 시작 위치 (문제 가정상 0,0에서 시작한다고 가정)
        int x = 0, y = 0;

        // 3. 이동 명령어 입력 (예: "R R U D L")
        String moves = sc.nextLine();

        // 4. 이동 처리
        //    moves를 공백 기준으로 분리 -> R, L, U, D 각각에 맞춰 위치 변경
        //    단, 보드를 벗어나는 경우 이동 무시
        for (String move : moves.split(" ")) {
            System.out.println("현재 move: " + move + ", 이전 위치: (" + x + ", " + y + ")");

            switch(move) {
                case "R":
                    // 오른쪽 이동 시 y를 +1, 단 y+1 < n 이어야 유효
                    if (y + 1 < n) {
                        y += 1;
                    }
                    break;
                case "L":
                    // 왼쪽 이동 시 y를 -1, 단 y-1 >= 0 이어야 유효
                    if (y - 1 >= 0) {
                        y -= 1;
                    }
                    break;
                case "U":
                    // 위로 이동 시 x를 -1, 단 x-1 >= 0 이어야 유효
                    if (x - 1 >= 0) {
                        x -= 1;
                    }
                    break;
                case "D":
                    // 아래로 이동 시 x를 +1, 단 x+1 < n 이어야 유효
                    if (x + 1 < n) {
                        x += 1;
                    }
                    break;
                default:
                    // R, L, U, D 외의 잘못된 명령어인 경우 처리 (여기선 무시)
                    break;
            }

            System.out.println("이동 후 위치: (" + x + ", " + y + ")");
            System.out.println("-----------------------------------");
        }

        // 5. 최종 위치 출력
        System.out.println("최종 위치는 (" + x + ", " + y + ") 입니다.");
    }
}

// 입력
5
R R U U L D D R

// 출력
현재 move: R, 이전 위치: (0, 0)
이동 후 위치: (0, 1)
-----------------------------------
현재 move: R, 이전 위치: (0, 1)
이동 후 위치: (0, 2)
-----------------------------------
현재 move: U, 이전 위치: (0, 2)
이동 후 위치: (0, 2)    // 범위를 벗어나므로 이동 무시
-----------------------------------
현재 move: U, 이전 위치: (0, 2)
이동 후 위치: (0, 2)    // 다시 무시
-----------------------------------
현재 move: L, 이전 위치: (0, 2)
이동 후 위치: (0, 1)
-----------------------------------
현재 move: D, 이전 위치: (0, 1)
이동 후 위치: (1, 1)
-----------------------------------
현재 move: D, 이전 위치: (1, 1)
이동 후 위치: (2, 1)
-----------------------------------
현재 move: R, 이전 위치: (2, 1)
이동 후 위치: (2, 2)
-----------------------------------
최종 위치는 (2, 2) 입니다.

```

- 이동 과정이나 조건을 단계별로 직접 구현하는 시뮬레이션 문제는, 조건 분기와 인덱스 범위 체크가 관건입니다.

### 2. 문자열 처리(String Manipulation) 유형
- 문자열을 주어진 형식에 맞추어 **파싱**, **토큰화**, **변환**하는 등의 작업이 주가 됩니다.
- 예: 구분자로 나누어 단어 단위로 역순 배치, 특정 규칙에 따라 문자열 변환, 중복 제거 등

#### 간단 예시 (자바)

```java
import java.util.Scanner;

public class StringParsingExample {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // 1. 문장 입력 받기
        System.out.print("문장을 입력하세요: ");
        String sentence = sc.nextLine();
        System.out.println("입력된 문장: " + sentence);
        
        // 2. 공백을 기준으로 단어 배열 생성
        //    "Hello World Program" 입력 시 -> ["Hello", "World", "Program"]
        String[] words = sentence.split(" ");
        
        // 중간 과정 출력: split으로 나눈 단어 배열 상태
        System.out.println("split으로 나눈 단어 배열 상태: ");
        for (int i = 0; i < words.length; i++) {
            System.out.println("  words[" + i + "]: " + words[i]);
        }
        System.out.println("-----------------------------------");

        // 3. 배열을 뒤집어서 저장하기
        //    reversed[0] <- words[마지막], reversed[1] <- words[마지막-1], ...
        String[] reversed = new String[words.length];
        int j = 0;
        for (int i = words.length - 1; i >= 0; i--) {
            reversed[j++] = words[i];
        }

        // 중간 과정 출력: 뒤집힌 단어 배열 상태
        System.out.println("뒤집힌 단어 배열 상태: ");
        for (int i = 0; i < reversed.length; i++) {
            System.out.println("  reversed[" + i + "]: " + reversed[i]);
        }
        System.out.println("-----------------------------------");

        // 4. 결과값(최종 문자열) 생성
        //    reversed 배열을 다시 하나의 문자열로 합침
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < reversed.length; i++) {
            sb.append(reversed[i]);
            if (i < reversed.length - 1) {
                sb.append(" ");
            }
        }

        // 최종 결과 출력
        System.out.println("최종 결과: " + sb.toString());
    }
}

// 입력
문장을 입력하세요: Hello World Program

// 출력
입력된 문장: Hello World Program
split으로 나눈 단어 배열 상태: 
  words[0]: Hello
  words[1]: World
  words[2]: Program
-----------------------------------
뒤집힌 단어 배열 상태: 
  reversed[0]: Program
  reversed[1]: World
  reversed[2]: Hello
-----------------------------------
최종 결과: Program World Hello

```
- 공백, 구분자 처리 등을 어떻게 다루느냐가 핵심이며, 문자열 길이가 0이거나 매우 클 경우 등의 케이스를 주의해야 합니다.

## 구현 문제 해결 팁
1. **문제에서 제공하는 예제 입력/출력 먼저 모두 테스트**  
   - 예시를 통해 기본 로직이 맞는지 검증합니다.
2. **추가로 에지 케이스를 만들어서 테스트**  
   - 가장 작은 입력(예: 1×1, 0개 요소 등), 가장 큰 입력(배열 최대 크기, 문자열 최대 길이)을 직접 가정하여 돌려봅니다.
3. **변수와 배열의 범위**  
   - 구현 문제라고 해도 입력 크기가 매우 커질 수 있으므로, int 범위를 넘어갈 수 있는지 반드시 확인합니다.
4. **기록하며 구현**  
   - 실수가 잦은 경우, 단계별로 출력 값을 확인하거나 디버깅 코드를 잠시 추가해 작업 과정을 추적해보는 것도 좋습니다.

## 결론
> 구현(Implementation) 문제는 알고리즘적으로는 간단해 보이지만, **사소한 실수가 치명적**인 유형입니다. 입력을 파싱하고, 조건에 맞춰 로직을 단계별로 처리하고, 예외 상황까지 꼼꼼하게 챙기는 과정이 필수입니다.  

## 참고 자료
1. [Baekjoon Online Judge](https://www.acmicpc.net/) (구현 문제 태그 참고)
2. [LeetCode](https://leetcode.com/) (String, Simulation 카테고리)