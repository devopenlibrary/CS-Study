# 이벤트 소싱(Event Sourcing)과 CQRS(Command Query Responsibillity Segregation)

## 이벤트 소싱(Event Sourcing)

이벤트 소싱은 도메인에서 발생하는 변경 사항을 추가 전용 로그에 이벤트로 변경 불가능하게 저장하는 아키텍처 설계 패턴입니다.

이벤트에는 변화의 맥락(무엇, 언제, 왜, 누가)이 포함되어있고, 각 변경 사항이 발생한 순서대로 있어서 도메인의 현재 상태 이상을 볼 수 있습니다.

![alt text](/Database/img/db_event_sourcing_cqrs_1.png)

_이벤트 소싱으로 알 수 있는 상태, 출처[Kurrent - What is Event Sourcing?](https://www.kurrent.io/event-sourcing)_

### 예시

주문 프로세스로 알아보는 이벤트 소싱

- 기존 방식

  ![alt text](/Database/img/db_event_sourcing_cqrs_5.png)

  1. ORDER 생성: 고객이 200달러의 상품 주문해 청구서 발행
  2. ORDER 업데이트: 청구서를 받은 고객이 비용을 지불함

  ORDER의 상태가 변함

- 이벤트 소싱
  
  ![alt text](/Database/img/db_event_sourcing_cqrs_6.png)

  1. ORDER 추가: 고객이 200달러의 상품을 주문해 청구서 발행
  2. ORDER PAYMENT RECEIVED 추가: 고객이 비용을 지불
  3. 업데이트 된 ORDER 추가: 지불된 내용을 적용

  ORDER PAYMENT RECEIVED라는 이벤트가 캡처되어 순서대로 저장

- 만약 50달러가 할인 행사가 있다면?
  
    ![alt text](/Database/img/db_event_sourcing_cqrs_7.png)
  
  - 기존 방식: ORDER에서는 200달러의 상품을 150달러에 구매했다는 사실은 알지만, 왜 그렇게 되었는지는 알 수 없습니다.
  - 이벤트 소싱: 50달러 할인의 내용이 DISCOUNT APPLIED 의 이벤트로 캡처되어 저장되기 떄문에, 이유에 대해서도 알 수 있습니다.

특징

- 데이터 복구 및 디버깅에 유용합니다.
- 구현 복잡도고 높고, 이벤트가 많아질수록 성능 관리가 필요합니다.
- 데이터 동기화 및 이벤트 스키마 변경 관리가 필요합니다.

### 핵심 내용

- 이벤트(Event)

    ![alt text](/Database/img/db_event_sourcing_cqrs_8.png)

  - 도메인에서 발생한 사실을 의미하며, 과거 시제로 언급됩니다.
  - 단순히 "발생됐다" 보다는 "확실히 변경되었음"의 의미입니다.
  - 일반적으로 이벤트 타임스탬프, 주체의 고유 식별자 등과 같은 고유한 메타데이터를 포함합니다.
  - 불변(immutable)데이터입니다.
- 이벤트 스토어(Event Store)

    ![alt text](/Database/img/db_event_sourcing_cqrs_9.png)

  - 각 이벤트는 DB에 기록되며, 기존 DB는 "현재 상태"를 저장하고, 이벤트 스토어는 "상태 변경 기록"을 저장합니다.
  - 기존 DB에서 데이터는 수정할 수 있지만, 모든 상태 변경은 새로운 이벤트로 추가되며 기존 이벤트를 유지합니다.
    - 예시: 잘못된 주소로 청구서 발행 이벤트 발생 -> 기존 청구서 무효 이벤트 발생 -> 제대로 된 주소로 청구서 발행 이벤트 발생 => 수정하는 것이 아니라 3개의 이벤트를 저장
  - 시간순으로 저장되며, 현재 상태는 저장된 이벤트를 재생(replay)하여 계산됩니다.
    - 예시: 현재 계좌 잔액이라는 현재 상태는 입금과 출금 이벤트를 순차적으로 처리해 계산됩니다.
- 스트림(Stream)

    ![alt text](/Database/img/db_event_sourcing_cqrs_10.png)

  - 특정 객체와 관련된 모든 이벤트를 시간 순서대로 저장한 묶음입니다.
  - 특정 객체는 고유 식별자(보통은 auto increment)를 가지며, 상태를 검색하는 동안 이벤트 순서를 정의하는데 사용하거나 동시성 문제를 감지하는데 사용됩니다.
  - 특정 객체 내의 이벤트는 스트림 내에서 고유한 위치를 갖습니다.
- 프로젝션(Projections)

  ![alt text](/Database/img/db_event_sourcing_cqrs_2.png)

  - 이벤트 스트림을 기반으로 특정 상태를 계산하거나, 읽기 모델(Read Model)을 생성하는 과정입니다.
  - 이벤트 데이터를 사용하여 현재 상태를 보여주는 "뷰(View)"를 만드는 것입니다.
  - 읽기 모델(Read Model)에서 프로젝션
  
    ![alt text](/Database/img/db_event_sourcing_cqrs_3.png)

    - 쓰기 모델에서 생성된 이벤트를 가져와 읽기 모델 뷰를 계산한 것을 의미하며,이 내용은 다른 DB에 저장되어 사용될 수 있습니다.
    - 변환(Transformation): 기존 이벤트 데이터를 기반으로 새로운 이벤트를 생성하거나 다른 스트림(Stream)에 추가하는 과정을 의미합니다.
      1. 주문 스트림(상품 추가 -> 제거 -> 추가 ...)
      2. 변환 과정: 주문의 모든 이벤트를 처리 후 요약(e.g. 가격 합산)을 생성
      3. 새로운 결제 이벤트 생성: 2번 과정의 결과를 기반으로 새로운 이벤트 생성
      4. 결제 스트림(결제 수단 선택 -> 결제 요청 -> 완료 ...)
  - 쓰기 모델(Write Model)에서 프로젝션: 스트림 집계(Stream Aggregation)
    - 이벤트를 순서대로 처리하여 도메인 객체의 현재 상태를 계산하는 과정으로, 주요 목적은 명령(Command)이 실행되기 전에 현재 상태를 다시 계산하여 검증하는 것입니다.
      - 예를 들어, 상품을 배송하려면 재고가 충분한지 확인해야 하므로, 모든 재고 관련 이벤트를 처리해 현재 재고 상태를 계산합니다.
    - 프로젝션은 임시적인 데이터로, 언제든 삭제하거나 다시 생성할 수 있습니다.
    - 프로젝션은 특정 목적에 맞게 해석된 임시적인 뷰로, 현재 상태가 아닙니다.

### 주의점

- 지연
  - 시스템은 다양한 시나리오에서 최종 일관성을 고려해 설계해야합니다.
  - event 게시 과정(application -> event store)과 event에 따라 처리되는 과정을 진행하는 중 추가 변경을 위한 이벤트가 게시되는 상황
- 동시성
  - 다중 스레드 혹은 여러 애플리케이션이 동시에 이벤트를 저장하려고 할 수 있는데, 이때 순서가 바뀔 수 있고 이를 주의해야합니다.
  - 대부분은 모든 이벤트에 timestamp를 추가하는 것으로 방지할 수 있습니다.
- 조회
  - 조회시에는 재생(replay)해야지만 확인할 수 있습니다.
- 스트림의 길이
  - 스트림이 큰 경우, 특정 간격으로 스냅샷을 만드는 것이 좋습니다.
  - 모든 이벤트를 재생(replay)하지 않고, 가장 가까운 스냅샷부터 이벤트를 재생하면 현재 상태를 확인할 수 있습니다.
- 불일치
  - 충돌이 아니더라도, 일관성과 트랜잭션 부족에서 발생하는 불일치를 해결해야합니다.
  - 예를 들어, 고객이 해당 품목을 주문하는 동안 재고 감소를 알리는 이벤트가 데이터 저장소에 도착할 수 있습니다.

## CQRS(Command Query Responsibillity Segregation)

애플리케이션에 따라 쓰기 작업의 비율 차이가 높다거나, 쓰기에 대한 데이터와 읽기에 대한 데이터가 다른 등의 이유로 CRUD 아키텍처가 성능을 저하시킬 수 있습니다.

CQRS는 명령(Command)과 조회(Query)의 책임(Responsibillity)을 분리(Segregation)하여 각각의 작업에 최적화된 모델을 사용하는 아키텍처 패턴입니다.

- 명령(Command)
  - 시스템 상태를 변경하는 작업으로, 성공한다면 시스템의 상태가 변경됩니다.
  - 예시: 데이터의 변경(create, update, delete 요청), 비즈니스 로직과 트랜잭션 관리
- 조회(Query)
  - 데이터를 조회하는 작업으로, 비즈니스 로직 없이 데이터를 가져오는 것에 초점되어있으며, 시스템 상태를 변경하지 않고 실행시마다 동일한 결과를 반환합니다.
  - 데이터의 조회(query 부분)

![CQRS의 흐름](/Database/img/db_event_sourcing_cqrs_4.png)

_CQRS의 흐름, 출처: [AWS Prescriptive Guidance - CQRS 패턴](https://docs.aws.amazon.com/ko_kr/prescriptive-guidance/latest/modernization-data-persistence/cqrs-pattern.html)_

1. 비즈니스에서는 애플리케이션의 write API를 통해 명령(데이터 추가, 삭제 등)을 전달합니다.
2. 애플리케이션은 들어온 명령에 따라, 작업(검증, 승인, 실행 등)을 진행합니다.
3. 애플리케이션은 write DB에 데이터의 쓰기 명령을 저장합니다.
4. 데이터 쓰기가 write DB에 저장된 후, 이벤트가 트리거 되어 read DB가 업데이트 됩니다.
5. read DB에서도 데이터 쓰기가 저장됩니다.
6. 비즈니스에서는 애플리케이션의 read API를 통해 조회를 진행합니다.
7. 애플리케이션은 조회 쿼리를 read DB에서 실행합니다.

### 구성 방법

#### 단일 데이터 저장소

![alt text](/Database/img/db_event_sourcing_cqrs_11.png)

- 쓰기 모델
  - 데이터를 업데이트하거나 유지하는 명령을 처리하도록 설계
  - 검증 및 도메인 로직, 트랜잭션 무결성, 비즈니스 프로세스 최적화가 포함됩니다.
- 읽기 모델
  - 데이터 검색을 위한 쿼리를 제공하도록 설계
  - 프레젠테이션 계층에 최적화된 DTO, 프로젝션(view)을 생성하는데 중점을 둡니다.
  - 도메인 로직을 피함으로써 쿼리 성능과 응답성을 향상 시킵니다.

### 분리된 데이터 저장소

별도의 데이터 저장소를 사용하는 경우 둘 다 동기화 상태를 유지해야 합니다.

일반적으로 쓰기 모델이 데이터베이스를 업데이트할 때 이벤트를 게시하고 읽기 모델이 이를 사용하여 데이터를 새로 고치는 방식입니다.

![alt text](/Database/img/db_event_sourcing_cqrs_12.png)

- 읽기 데이터 저장소
  - 쿼리에 최적화된 자체 데이터 스키마를 사용할 수 있습니다.
  - 쓰기 저장소의 읽기 전용 복제본이거나 다른 구조를 가질 수 있습니다.

### 특징

- 각각 최적화: 쓰기와 읽기 작업의 성격이 다르기 때문에, 각각에 최적화된 데이터 모델이나 기술을 사용하는 것이 좋습니다.
  - 명령에는 nosql, 읽기에는 RDB와 같이 DB 조합해 구현할 수 있다.
  - 읽기 데이터 저장소: 실체화된 뷰를 저장하면 애플리케이션은 쿼리할 때 복잡한 조인을 피할 수 있습니다.
- 관심사 분리: 쓰기 측은 일반적으로 복잡한 비즈니스 로직을 처리, 읽기 측은 단순하게 유지하고 쿼리 효율성에 집중
- 메시징 과제: 동기화 유지시 메시징 처리에 대한 문제를 고려해야합니다.
- 일관성 문제: 저장소가 분리된 방식에서는 일관성 문제가 발생할 수 있습니다.

## 이벤트 소싱과 CQRS의 관계

> “You need to look at CQRS not as being the main thing. CQRS was a product of its time and meant to be a stepping stone towards the ideas of Event Sourcing.”
>
> : (번역 내용을 간단히 요약하자면)CQRS가 중요한게 아니다. CQRS는 이벤트 소싱을 향한 디딤돌이였다.
>
> "A Decade of DDD, CQRS, Event Sourcing"에서 Greg Young

이벤트 소싱은 시스템 상태를 이벤트로 저장하며, CQRS와 결합하면 강력한 확장성과 유연성을 제공합니다.

![alt text](/Database/img/db_event_sourcing_cqrs_13.png)

- 쓰기 측(Write Side): 상태 변경이 일어나는 곳으로, 상태변경을 이벤트 생성하고 저장합니다.
  - e.g. check out
- 읽기 측(Read Side): 조회하는 작업을 하는 곳으로, 저장된 이벤트를 기반으로 데이터를 조회하기 위한 읽기 모델을 생성합니다.
  - e.g. Get order overview

![alt text](/Database/img/db_event_sourcing_cqrs_14.png)

- 사용자가 명령(Command)을 실행하면 쓰기 측에서 이벤트가 생성됩니다.
- 생성된 이벤트는 이벤트 저장소에 기록되며, 프로젝션이 이를 구독하여 읽기 모델을 업데이트합니다.
- 읽기 모델은 사용자 인터페이스(UI)나 보고서에서 데이터를 빠르게 조회할 수 있도록 최적화된 형태로 제공됩니다.

![alt text](/Database/img/db_event_sourcing_cqrs_15.png)

- 프로젝션은 원래 단일 스트림만 구독해 특정 데이터를 터리했지만, 실제 비스니스 요구상황에서는 여러 개의 스트림을 읽어 읽기 모델을 생성해야하는 경우가 많습니다.

![alt text](/Database/img/db_event_sourcing_cqrs_16.png)

- 더 확장한다면, 이처럼 모든 이벤트 스트림을 읽어야하는 경우도 발생합니다. (e.g. dashboard)
- 이런 상황에서는 집계 아이디(Aggregate ID)가 매우 중요합니다.
  - 각 이벤트는 특정 도메인 객체(e.g. 고객, 주문 etc)와 연관되어있습니다.
  - 이 연관성을 나타내는 것이 집계 아이디(Aggregate ID) 또는 식별자 입니다.
  - 프로젝션은 여러 이벤트 스트림에서 데이터를 가져올 때, 이 식별자를 기준으로 데이터를 연결하고 통합합니다.

## 출처

- [Kurrent - What is Event Sourcing?](https://www.kurrent.io/event-sourcing)
- [Kurrent - Event Sourcing and CQRS](https://www.kurrent.io/blog/event-sourcing-and-cqrs)
- [AWS Prescriptive Guidance - CQRS 패턴](https://docs.aws.amazon.com/ko_kr/prescriptive-guidance/latest/modernization-data-persistence/cqrs-pattern.html)
- [microsoft learn- event-sourcing](https://learn.microsoft.com/ko-kr/azure/architecture/patterns/event-sourcing)
- [microsoft learn- CQRS](https://learn.microsoft.com/ko-kr/azure/architecture/patterns/cqrs)

출처는 아니지만 관련된 글

- [우아한형제들 기술블로그 - [배민스토어] 배민스토어에 이벤트 기반 아키텍처를 곁들인…](https://techblog.woowahan.com/13101/)
- [AWS Prescriptive Guidance - 이벤트 소싱 패턴](https://docs.aws.amazon.com/ko_kr/prescriptive-guidance/latest/cloud-design-patterns/event-sourcing.html)