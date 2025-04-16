# Memory

# CPU 와 메모리

**CPU** 는 컴퓨터의 명령 해석, 데이터 처리를 **실행** 하는 장치 이다. **메모리** 는 이러한 CPU 가 처리할 데이터, 혹은 프로세서가 빠르게 접근할 수 있도록 명령어를 **저장** 하는 장치 이다.

CPU 는 메모리에 직접 접근할 수 있다. 따라서 CPU 에서 메모리에 접근하여 데이터를 읽고 쓰는 속도가 프로그램 실행 속도, 즉 컴퓨터의 성능에 큰 영향을 미친다.

![](/OS/img/os_memory_cpu_and_memory.png)
출처 : [Understanding your Computer Memory and CPU](https://scottc130.medium.com/understanding-your-computer-memory-and-cpu-3a992aa60577)

# 종류

메모리는 크게 RAM(Random Access Memory)과 ROM(Read Only Memory)으로 나뉘며, 이 둘은 주 메모리(Main Memory) 라고도 불린다.

### RAM

- 현재 실행중인 프로그램, 데이터와 명령어를 저장하는 휘발성(일시적) 메모리. 모든 실행되는 프로그램이 존재하기 때문에 속도가 빨라야한다.
- 1차 메모리라고도 불리운다.
- 프로세스가 적재되는 메모리 는 RAM 을 의미한다.
- 일반적으로 "메모리" 는 보통 RAM 을 의미한다고 볼 수 있다.

### ROM

- 비휘발성 메모리로, 전원이 꺼져도 데이터가 유지. RAM 에 비해 속도가 느리다.
- 부팅 과정에서 필요한 필수 명령어를 저장하는 데 사용.

### HDD (Hard Disk Drive)

- 속도가 느리다. 2차 저장장치 혹은 보조 기억 장치 라고도 불리운다.
- ROM 과 마찬가지로 비휘발성 메모리이다.

# 주소

메모리(물리 메모리) 는 1바이트 의 크기를 가지는 주소 라는 것으로 이루어진다.

## 물리 / 논리 주소

- 물리 주소는 RAM 사용하는 주소 를 의미한다.
- 논리 주소는 CPU와 실행중인 프로그램(프로세스)가 참조하는 주소이다.

즉, RAM 을 구성하고 있는 주소는 물리 주소, 프로세스를 구성하고 있는 주소는 논리 주소 임을 알 수 있다.

## 논리 주소 -> 물리 주소

CPU 는 논리 주소를 참조한다. RAM 에 접근하려면 논리 주소를 물리 주소로 변환하는 과정이 필요하다. 이를 실행하는 유닛이 MMU(Memory Management Unit, 메모리 관리 장치) 이다.

![](/OS/img/os_memory_cpu_memory_process.png)
출처 : [[10분 테코톡] 채채의 가상 메모리](https://www.youtube.com/watch?v=_SyFgWccEs8)
이미지에는 페이지 테이블 이라고 적혀있는데

# 메모리 관리

메모리 관리 작업은 크게 가져오기(Fetch), 배치(Placement), 재배치(Replacement)로 구분된다.

- 메모리 가져오기 : 실행할 프로세스와 데이터를 메모리로 가져오는 작업
- 메모리 배치 : 가져온 프로세스와 데이터를 메모리의 어떤 부분에 올려놓을지 결정하는 작업. 그리고 메모리를 어떤 크기로 나누는 지 결정하는 작업. 페이징, 세그먼테이션이 메모리 배치 방법에 해당한다.
- 메모리 재배치 : 꽉 찬 메모리에 새로운 프로세스를 가져오기 위해 오래된 프로세스를 내보내는 작업

## 메모리 배치 전략

- 가변 분할 방식 (세그멘테이션) : 프로세스의 크기에 따라 프로세스 별로, 메모리를 나누는 방식. 세그먼트 라는 단위로 나뉘게 된다.
- 고정 분할 방식 (페이징) : 페이지라고 불리우는 영역으로 모든 메모리를 0부터 시작하여 고정적인 값으로 번호를 매겨 관리. 페이지 라는 단위로 나뉘게 된다.

  ![](/OS/img/os_memory_segmentation_paging.png)

# 물리 메모리 (Physical Memory)

- RAM (혹은 때때로 RAM 에 존재하는 데이터)을 의미한다. 물리 메모리는 이러한 가상 메모리를 설명할 때, 가상 메모리와 구분하기 위한 의미로 사용되는 용어 라고 볼 수 있다.
- 독자적인 의미를 띄기도 하지만, 가상 메모리 라는 개념을 설명하는 것에서 비롯되어 가상 메모리와 구분하기 위한 의미로 사용되는 용어라고 볼 수 있다.

## 주소

- 하나의 프로세스에 해당하는 주소 공간이 연속적으로 이어진 구조이다. 따라서, 보통 세그먼테이션 방식으로 분할되어 세그먼트 단위로 나뉘게 된다.
- 물리 메모리를 구성하는, 혹은 물리 메모리를 관리할 수 있는 최소 단위는 1바이트 이다. 이 1바이트 마다 주소 라는 것이 할당된다.
- 주소가 저장할 수 있는 크기는 CPU, OS 에 의존한다. 예를 들어 주소가 32비트 를 저장할 수 있다면, 해당 CPU 의 최대 메모리크기는 4GB 가 된다. (32비트가 표현할 수 있는 정보의 가지수는 4,294,967,296, 이를 바이트로 환산하면 4GB 이다.)

# 가상 메모리 (Virtual Memory)

- 제한된 메모리(물리 메모리) 로 더 많은 프로그램을 실행시키기 위한 기술 혹은 개념

  > 물리 메모리는 RAM (혹은 때때로 RAM 에 존재하는 데이터) 를 의미한다. 물리 메모리는 이러한 가상 메모리를 설명할 때, 가상 메모리와 구분하기 위한 의미로 사용되는 용어 라고 볼 수 있다.

- 사용 가능한 메모리의 범위를 RAM 에서, Swap 영역(HDD) 를 포함하는 것으로 확장시키는 추상화의 개념이라고 볼 수 있다.

  > Swap 영역은 주 메모리 의 용량이 부족할 때, 문제가 생기는 것을 방지하고자 2차 기억장치(보조 기억 장치)인 HDD 의 공간을 활용하여 메모리 역할을 할 수 있도록 도와주는 영역을 의미한다.

  ![](/OS/img/os_memory_swap_1.png)
  ![](/OS/img/os_memory_swap_2.png)
  출처 : [[10분 테코톡] 채채의 가상 메모리](https://www.youtube.com/watch?v=_SyFgWccEs8)

- 가상(Virtual) === 논리(Logical) 라고 볼 수 있다.

## 주소

- 어느 위치에 있던, 항상 0부터 시작한다.
- 이론적으로는 가상 메모리의 크기는 무한대이지만, 실제로 가상 메모리의 최대 크기는 컴퓨터 시스템이 가진 물리 메모리의 최대 크기로 한정된다. 즉, CPU 비트에 따라 결정된다.
- 주로 세그멘테이션 과 페이징 을 혼용한 기법을 많이 사용한다.

## 페이징 기법 에서의 가상 주소를 물리 주소로 변환하는 방법

### 필요한 이유

앞서 얘기했 듯, 가상 메모리는 고정 분할 방식으로 나누어져 주소는 위치에 상관 없이 항상 0부터 시작한다. 하지만 물리 메모리의 주소는 가변 분할 방식으로 나누어지며 연속적이다.

_예를 들어 프로세스 1, 2, 3 이 적재된 가상 메모리가 3개 있다. 각 가상 메모리에서는 같은 주소, 100번의 주소에 데이터를 가지고 있다. 하지만 이를 물리 메모리에서 생각하면, 각 데이터는 100번의 주소에 있다고 생각할 수없을 것이다. 앞서 얘기했듯, 메모리를 나누는 방식이 다르기 때문이다._

따라서 가상 메모리의 페이지를, 물리 메모리의 세그먼트와 맵핑하여 변환하는 기능이 필요하다.

### 작동 원리

> 페이지 테이블이란 페이지를 실제 물리 주소 정보와 매핑한 표를 담고 있는 테이블 이다. 프로세스 마다 하나씩 가지고 있다.

![](/OS/img/os_memeory_page_table.png)

## 요구 페이징

필요한 프로그래만만 메모리에 올려 실행하고 나머지 프로그램은 사용자가 특정 기능을 요구할 때와 같이 필요하다고 판단될 때 메모리로 불러온다. 이렇게 사용자가 요구할 때 해당 페이지를 메모리로 가져오는 것을 요구 페이징이라고 한다. 페이징은 메모리 배치 전략의 일종이었다면, 이러한 요구 페이징은 메모리를 가져올 때 고려하는 메모리 가져오기 전략의 일종이다.

### 운영체제에서 중요한 이유

- 물리 메모리에 대한 의존성 제거
  - 컴퓨터 마다 물리 메모리의 크기는 다르다. 만약 소프트웨어가 이러한 물리 메모리에 의존한다면, 크기가 다른 컴퓨터마다 다른 버젼의 소프트웨어를 사용해야할 것이다. 첫번째로 가상메모리는 이러한 소프트웨어의 물리메모리에 대한 의존성을 없애준다.
- 메모리를 관리하는 측면에서 의의가 있다. MMU 역시 운영체제에서 중요한 역할을 한다고 볼 수 있다. 현대 메모리는 프로그램을 실행하는 공간이기에, 메모리 를 관리하는 것은 여러 프로그램을 실행하는 멀티프로그래밍 환경에서 아주 중요한 부분이다. 가상 메모리는 물리 메모리의 크기와 프로세스가 올라갈 메모리의 위치를 신경 쓰지 않고 프로그래밍하도록 지원한다는 것이다.

---

더 깊게 살펴보고싶다면 아래 링크를 추천합니다!

[가상 메모리 개요](https://www.youtube.com/watch?v=-jlzaslp-w4),[[운영체제] 물리 메모리 관리](https://rob-coding.tistory.com/32), [[운영체제] 가상 메모리 ](https://rob-coding.tistory.com/33)

# 출처

- [What is computer memory?](https://www.lenovo.com/us/en/glossary/computer-memory/?orgRef=https%253A%252F%252Fwww.google.com%252F&srsltid=AfmBOooZPjiaAitoO96hpjhnxvr0nqkB0-dNTguCss0s2Tti6xtILrIw)
- [컴퓨터 구조의 이해: CPU와 메모리](https://f-lab.kr/insight/understanding-cpu-and-memory)
- [What is the difference between physical memory, main memory, secondary memory, virtual memory, and hard disk? I’m studying operating system and I am very confused between these terms.
  ](https://www.quora.com/What-is-the-difference-between-physical-memory-main-memory-secondary-memory-virtual-memory-and-hard-disk-I-m-studying-operating-system-and-I-am-very-confused-between-these-terms)

- [가상 메모리 개요](https://www.youtube.com/watch?v=-jlzaslp-w4)
- [운영 체제의 가상 메모리](https://www.geeksforgeeks.org/virtual-memory-in-operating-system/)
- [[운영체제] 물리 메모리 관리](https://rob-coding.tistory.com/32)
- [[운영체제] 가상 메모리 ](https://rob-coding.tistory.com/33)
- [[10분 테코톡] 채채의 가상 메모리](https://www.youtube.com/watch?v=_SyFgWccEs8)
