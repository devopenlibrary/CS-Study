# Query Optimization(Slow Query Tuning)

데이터베이스의 성능을 높이기 위해 SQL 쿼리를 분석하고 최적화하는 과정



## **슬로우 쿼리 원인**

1. **인덱스 미사용 또는 잘못된 인덱스**
    - 적절한 인덱스가 없거나 과도한 인덱스를 사용하면 쿼리 성능이 저하
2. **불필요한 풀 테이블 스캔**
    - 적은 양의 데이터를 사용할 경우, 풀 테이블 스캔을 할 경우 성능 저하
3. **잘못된 조인 (JOIN) 순서 및 방식**
    - 조인의 순서나 방식에 따라 성능 차이가 큼
4. **과한 서브쿼리 사용**
    - 서브쿼리는 JOIN, EXISTS, IN으로 변경하는 것이 더 효율적일 수 있음
5. **트랜잭션 및 락 대기**
    - 긴 트랜잭션이 다른 쿼리들의 대기 상태를 유발할 수 있으므로 트랜잭션을 최소화하고 적절한 커밋 시점을 설정해야 함



## 옵티마이저 힌트

옵티마이저 힌트는 **DBMS가 실행 계획을 최적화할 때 개발자가 특정 방식으로 실행하도록 유도하는 방법**

DBMS는 보통 **통계 정보(Statistics)** 를 기반으로 자동으로 최적의 실행 계획을 선택하지만,

- **잘못된 통계 정보**
- **특정 실행 계획을 강제하고 싶을 때**
    
    이런 경우에는 옵티마이저 힌트를 사용해서 직접 실행 계획을 컨트롤할 수 있다.
    

### 대표적인 힌트 종류 (DBMS마다 다름)

| **힌트 종류** | **설명** | **사용 예시** |
| --- | --- | --- |
| **조인 방식 강제** | 특정 조인 방식을 강제함 | `/*+ USE_NL(A B) */` |
| **조인 순서 강제** | 테이블의 조인 순서를 지정함 | `/*+ LEADING(A B C) */` |
| **인덱스 사용 강제** | 특정 인덱스를 사용하도록 강제 | `/*+ INDEX(table index_name) */` |
| **인덱스 사용 방지** | 특정 인덱스를 사용하지 않도록 강제 | `/*+ NO_INDEX(table index_name) */` |
| **병렬 처리 적용** | SQL 실행을 병렬로 수행 | `/*+ PARALLEL(table 4) */`  |
| **FULL 스캔 강제** | 테이블 풀 스캔을 강제 | `/*+ FULL(table) */` |
| **INDEX 스캔 강제** | 특정 인덱스를 통한 검색 강제 | `/*+ INDEX(table index_name) */` |
| **SORT MERGE 조인 강제** | Sort Merge Join 사용 | `/*+ USE_MERGE(A B) */` |
| **CARDINALITY 설정** | 특정 테이블의 예상 행 수를 지정 | `/*+ CARDINALITY(table 1000) */` |
| **FIRST_ROWS / ALL_ROWS** | 응답 속도 또는 전체 처리 속도 최적화 | `/*+ FIRST_ROWS(10) */` |

```sql
/*+ USE_NL(A B) */    -- A, B 테이블을 Nested Loop Join 사용
/*+ USE_HASH(A B) */  -- A, B 테이블을 Hash Join 사용, B가 해시 테이블로 올라감

-- NL 조인 강제
SELECT /*+ USE_NL(usr ord) */ 
	usr.이름, ord.상품이름, ord.주문일자
FROM T_USER usr
JOIN T_ORDER ord  ON usr.user_id = ord.user_id

-- 해시 조인 강제
SELECT /*+ USE_HASH(usr ord) */ 
	usr.이름, ord.상품이름, ord.주문일자
FROM T_USER usr
JOIN T_ORDER ord  ON usr.user_id = ord.user_id

/*+ LEADING(A B C) */ -- A → B → C 순서대로 조인 강제

-- ord 테이블을 먼저 읽도록 강제
SELECT /*+ LEADING(ord usr) */ 
	usr.이름, ord.상품이름, ord.주문일자
FROM T_USER usr
JOIN T_ORDER ord  ON usr.user_id = ord.user_id

/*+ INDEX(table index_name) */       -- 테이블의 index_name 사용
/*+ NO_INDEX(table index_name) */    -- 테이블의 index_name 사용x

-- 해시 조인, idx_user_id 인덱스 사용
SELECT /*+ USE_HASH(usr ord) INDEX(usr idx_user_id) */ 
	usr.이름, ord.상품이름, ord.주문일자
FROM T_USER usr
JOIN T_ORDER ord  ON usr.user_id = ord.user_id

/*+ PARALLEL(table 4) */       -- 테이블을 4개의 프로세스가 병렬로 처리하도록 강제

SELECT /*+ PARALLEL(T_ORDER 4) */ 
       user_id, 상품이름, 주문일자
FROM T_ORDER;

-- T_USER와 T_ORDER 테이블을 각각 4개의 프로세스로 병렬 처리
SELECT /*+ PARALLEL(T_ORDER 4) PARALLEL(T_USER 4) */ 
	usr.이름, ord.상품이름, ord.주문일자
FROM T_USER usr
JOIN T_ORDER ord  ON usr.user_id = ord.user_id
```


### 주의점

1. 힌트는 DBMS에 따라 다르다.
2. 힌트를 무조건 쓰면 안된다.
    - 옵티마이저가 최적 실행 계획을 찾는 경우가 많음
    - 장기적으로 유지보수가 어려워질 수 있음



# **쿼리 최적화**

![](/Database/img/db_query_optimization_1.png)

## **1. 실행 계획(EXPLAIN, EXECUTION PLAN) 확인**

**실행 계획을 분석하여 쿼리 성능을 점검**할 수 있다. 

- **MySQL:** `EXPLAIN SELECT ...`
- **Oracle/Tibero:** `EXPLAIN PLAN FOR SELECT ...`
- **PostgreSQL:** `EXPLAIN ANALYZE SELECT ...`

```sql
EXPLAIN PLAN FOR
SELECT /*+ full(user_id)*/ * FROM T_USER
WHERE user_id= 'USER000502'

SELECT 
	SQL_ID
	, OPERATION
	, OBJECT_NAME
	, SEARCH_COLUMNS
	, COST
FROM PLAN_TABLE
WHERE SQL_ID IN ( '51s88agb5q2fw', '5xfxqjnpxhuvw' )
```

![](/Database/img/db_query_optimization_2.png)



## **2. 인덱스 최적화**

✅ 

- WHERE, JOIN, ORDER BY, GROUP BY에서 인덱스를 제대로 활용하고 있는가?
- 불필요한 인덱스가 오히려 성능 저하를 유발하지 않는가?
- 인덱스가 많은 경우 유지 관리 비용을 고려했는가?
- 예상치 못한 TABLE FULL SCAN이 발생하지 않는가?
- 적절한 인덱스 사용으로 풀스캔을 줄였는가?

### **인덱스 최적화 목표**

- 스캔 과정에서 발생하는 비효율 줄이기
- 테이블 액세스 회수 줄이기

```sql
SELECT * FROM T_USER
WHERE user_id= 'USER000502'
// 조건에 해당하는 데이터가 한 건이므로 인덱스를 사용하는 방식이 좋다.

SELECT * FROM T_USER
WHERE 유저구분코드 = 'a001'
// 유저구분코드가 'a001'인 고객 데이터가 100만 건일 때, 풀 스캔 방식이 효과적이다.
```

인덱스는 큰 테이블에서 소량 데이터를 검색할 때 사용한다. (목차)
    ![](/Database/img/db_query_optimization_3.png)

index range scan 을 할 때는 데이터가 정렬되어 있어야 하고 스캔 시작점과 종료점(인덱스 블록에서 스캔하는 양)이 중요

✅ **적절한 인덱스 추가**

```sql
CREATE INDEX idx_user_name ON T_USER(name);
```

- 자주 조회되는 컬럼이나 **조인 조건에 사용되는 컬럼**에 인덱스를 추가

✅ **복합 인덱스**

```sql
CREATE INDEX idx_orders_user_date ON T_ORDER(user_id, order_date);
```

- WHERE 절에 다중 컬럼을 사용할 경우 사용
- 인덱스 순서도 중요
    - `WHERE user_id = 1 AND order_date = '2024-03-01'`
        - 인덱스 사용 가능
        - user_id로 스캔 범위를 좁힐 수 있음
    - `WHERE order_date = '2024-03-01'`
        - 모든 데이터를 조회해야 할 수 있음
        



## **3. JOIN 최적화**

✅ 

- INNER JOIN이 OUTER JOIN보다 적절한가?
- 조인 순서를 변경하면 성능이 향상되는가?
- 조인 대상 테이블에 적절한 인덱스가 설정되어 있는가?

### **NL(Nested Loops) 조인**

- 인덱스를 이용한 조인
- 작은 테이블을 먼저 읽고, 그 값으로 큰 테이블을 조회
- 인덱스가 잘 활용되지 않으면 성능이 저하될 수 있음

```sql
SELECT a.이름, b.상품이름, b.주문일자
FROM T_USER a, T_ORDER b
WHERE a.user_id = b.user_id
AND a.가입일자 = '20250101'
```

### **NL 조인 동작 방식**

1. T_USER 테이블에서 데이터를 가져옴
    - `가입일자 = '20250101'` 조건을 만족하는 유저 조회
2. 각 유저의 `user_id`로 T_ORDER 테이블을 검색
    - T_USER 에서 가져온 `user_id`를 이용해 `T_ORDER` 테이블에서 해당 유저의 주문 데이터를 조회
3. 반복
    - 위 과정을 모든 유저에 대해 반복 수행
        
        ![](/Database/img/db_query_optimization_4.png)
        

### **실행 계획**

| 단계 | 연산(Operation) | 테이블 | 액세스 방식(Access Method) |
| --- | --- | --- | --- |
| 1 | TABLE ACCESS BY INDEX ROWID | T_USER | `가입일자` 필터링 (INDEX 사용) |
| 2 | INDEX RANGE SCAN | idx_user_join_date | `가입일자` 인덱스 탐색 |
| 3 | NESTED LOOPS |  |  |
| 4 | TABLE ACCESS BY INDEX ROWID | T_ORDER | `user_id` 인덱스를 통한 검색 |
| 5 | INDEX UNIQUE SCAN | idx_order_user_id | `user_id` 인덱스를 사용한 검색 |
- T_USER에서 먼저 가입일자 조건을 필터링 (`INDEX RANGE SCAN`)
- 그 결과를 기반으로 T_ORDER를 NESTED LOOPS 방식으로 반복 조회

✅ **조인 조건에 인덱스 추가**

```sql
CREATE INDEX idx_order_user_id ON T_ORDER(user_id);
```

- `T_ORDER.user_id`에 인덱스를 추가하면 `INDEX UNIQUE SCAN`이 발생하며 빠르게 조인 가능

✅ **드라이빙 테이블 크기 줄이기**

```sql
CREATE INDEX idx_user_join_date ON T_USER(가입일자);
```

- 필터링 조건이 먼저 최적화되어야 `T_USER`의 크기가 줄어들어 NL 조인의 반복 횟수가 감소함

## **Hash Join**

두 개의 테이블 중 **작은 테이블을 메모리에 해시 테이블로 저장**한 후, 큰 테이블을 스캔하면서 해시 테이블과 조인하는 방식

1. NL 조인이 비효율적일 때 (인덱스를 활용하지 못할 때)
    - NL 조인은 데이터가 적을 때는 효율적이지만, **대량 데이터 조인 시 비효율적**일 수 있음
2. 드라이빙 테이블이 작을 때

### **Hash Join동작 방식**

1. **Build**
    - 작은 테이블을 메모리에 올려 **해시 테이블을 생성**
    - 조인 키를 기준으로 해시 값을 계산하여 **버킷**에 저장.
2. **Probe**
    - 큰 테이블을 읽으면서 해시 테이블을 참조하여 매칭되는 행을 탐색
    

```sql
SELECT /*+ USE_HASH(b) */ a.이름, b.상품이름, b.주문일자
FROM T_USER a, T_ORDER b
WHERE a.user_id = b.user_id
AND a.가입일자 = '20250101';
```

1. **`T_USER`(작은 테이블)에서 `가입일자 = '20250101'` 필터링**
    
    ```sql
    SELECT user_id, 이름
    FROM T_USER
    WHERE 가입일자 = '20250101';
    ```
    
    - 이 결과를 해시 테이블로 메모리에 저장
    
2. **`T_ORDER`(큰 테이블)를 스캔하며 `user_id`를 해시 테이블과 비교**
    
    ```sql
    SELECT 상품이름, 주문일자
    FROM T_ORDER
    WHERE user_id IN (해시 테이블);
    ```
    
    - `T_ORDER.user_id`를 해시 테이블에서 찾으며 빠르게 조인

✅ **드라이빙 테이블(작은 테이블) 크기를 줄이기**

```sql
SELECT /*+ USE_HASH(b) */ a.이름, b.상품이름, b.주문일자
FROM (SELECT user_id, 이름 FROM T_USER WHERE 가입일자 = '20250101') a
JOIN T_ORDER b
ON a.user_id = b.user_id;
```

- `T_USER`에서 미리 필터링하여 **해시 테이블 크기를 줄임** → 더 빠른 해시 매칭 가능.

✅ **해시 테이블이 너무 클 경우, Hash Partitioning 사용**

```sql
ALTER TABLE T_ORDER PARTITION BY HASH (user_id);
```

- 해시 파티셔닝을 통해 데이터 분산 → 메모리 사용 최적화.


## Join Q&A

### 1. NoSQL에서는 쿼리 최적화가 있는지?
✅ NoSQL에서도 쿼리 최적화는 필요 

    NoSQL은 스키마가 유연하고 조인이 적다는 특성이 있지만, 
    데이터가 많아지면 느려지는 쿼리를 최적화해야 하는 건 같다.

    - RDBMS → 실행 계획 & 인덱스 튜닝을 통해 최적화
    - NoSQL → 적절한 데이터 모델링 + 인덱싱 + 샤딩(Sharding) + 캐싱

### 2. NL 조인, Hash Join도 inner join 같은 건가?
✅ NL 조인, Hash Join 은 join의 실행방식 중 하나

    NL 조인과 해시 조인은 조인의 실행 방식이 다른 알고리즘으로 
    같은 조인을 수행하지만, 데이터를 매칭하는 방식이 다른 것

### 3. 만약 큰 테이블과 작은 테이블이 같은 경우는 어떤 조인을 사용하는게 좋을지?
✅ 상황(인덱스, 메모리..) 에 따라 다름

**NL 조인 vs 해시 조인**

| 기준 | NL 조인 | 해시 조인 |
| --- | --- | --- |
| **인덱스** | 인덱스가 있을 때 유리 (빠름) | 인덱스 없어도 빠름 |
| **데이터 양** | 작은 테이블 + 큰 테이블 | 두 테이블 크기가 비슷할 때 |
| **조인 방식** | 한쪽 테이블을 읽으며 다른 테이블 검색 (반복문) | 한쪽을 해시 테이블로 변환 후 조인 |
| **메모리 사용** | 적음 (인덱스 기반) | 많음 (해시 테이블 생성) |
| **성능** | 인덱스 최적화 시 매우 빠름 | 대량 데이터에서 빠름 |

    인덱스가 있고 최적화 되어 있다 → NL
    인덱스가 없다 → 해시 조인
    메모리가 충분하다 → 해시 조인

    결국 실행 환경에 따라 다르기 때문에 EXPLAIN PLAN을 확인해서 
    실제 DB에서 어떤 방식이 최적화되는지 봐야 함.


## **4. 서브쿼리 최적화**

✅ 

- 서브쿼리를 JOIN 또는 EXISTS로 변경하면 성능이 향상되는가?
- IN 대신 EXISTS를 사용하면 더 효율적인가?


### 서브쿼리 문제점

| 문제점 |  | 예시 |
| --- | --- | --- |
| **반복 실행** | **상관 서브쿼리**는 메인 쿼리의 각 행마다 서브쿼리를 반복 실행함 | `WHERE EXISTS (SELECT ... WHERE o.user_id = u.user_id)` |
| **옵티마이저가 최적화하기 어려움** | 옵티마이저는 블록 단위로 계획을 세우는데, **서브쿼리 내부는 다른 블록**이라 예측 어려움 | 옵티마이저가 조인 방식 선택 실패 가능 |
| **인덱스 활용이 어려움** | 복잡하거나 상관된 서브쿼리는 **풀스캔 유도** 가능성 높음 | `IN (SELECT ...)` 구조에서 옵티마이저가 인덱스를 포기할 수 있음 |

💡 서브쿼리는 "옵티마이저가 잘 예측하지 못하는" 특성이 있어 주의가 필요



### 옵티마이저는 쿼리 블록 단위로 최적화를 수행한다.

- 쿼리 블록 단위로 최적화됨 → `EXISTS`, `IN`, `JOIN`은 다른 블록처럼 처리됨
- 서브쿼리의 실행 시점은 메인 쿼리 이후인 경우가 많음
- 특히 상관 서브쿼리는 메인 쿼리 한 줄당 서브쿼리 한 번 실행되므로 매우 비효율적
    
    ```sql
    SELECT 이름
    FROM T_USER u
    WHERE 가입일자 = '20250101'
    AND EXISTS (
        SELECT 1
        FROM T_ORDER o
        WHERE o.user_id = u.user_id
        AND o.상품이름 = '라면'
    );
    
    <블록 1>
    SELECT 이름
    FROM T_USER u
    WHERE 가입일자 = '20250101'
    
    <블록 2>
    SELECT 1
    FROM T_ORDER
    WHERE user_id = :user_id -- 블록 1의 user_id 값을 하나씩 바인딩 받아 실행
    AND 상품이름 = '라면'
    ```
    



### 예시
### 서브쿼리 (느릴 수 있음)

```sql
SELECT 이름
FROM T_USER
WHERE user_id IN (
    SELECT user_id
    FROM T_ORDER
    WHERE 상품이름 = '라면'
)
```

- `T_ORDER` 먼저 수행
- `T_USER`를 조건 비교로 필터링
- 옵티마이저가 **인덱스 사용 안 할 수 있음**
- **대용량 비추**, 소규모라면 괜찮음

### JOIN (일반적으로 더 효율적)

```sql
SELECT DISTINCT u.이름
FROM T_USER u
JOIN T_ORDER o ON u.user_id = o.user_id
WHERE o.상품이름 = '라면'
```

- 옵티마이저가 **해시 조인 / NL 조인 / 병렬 처리 등 다양한 선택 가능**
- 인덱스 사용 가능
- **전체적으로 가장 안정적이고 빠름**

### EXISTS (조건만 확인)

```sql
SELECT 이름
FROM T_USER u
WHERE EXISTS (
    SELECT 1
    FROM T_ORDER o
    WHERE o.user_id = u.user_id
    AND o.상품이름 = '라면'
);
```

- `T_USER` 한 건씩 조회하며 `T_ORDER`에 조건 만족하는 것 있으면 탈출
- 조건이 **존재 여부**일 때 매우 효율적
- **중복 제거 불필요**, 빠른 탈출 덕분에 쿼리 시간 단축 가능


### 비교

|  | JOIN | EXISTS | IN |
| --- | --- | --- | --- |
| 가장 효율적인 기본 방식 | ✅ | ✅ (존재 확인) | ❌ (옵티마이저 예측 어려움) |
| 대용량 적합 | ✅ | 주의 필요 | ❌ |
| 인덱스 활용 | 최적화됨 | 가능 | 어려움 |
| 실행계획 최적화 | 유리 | 비교적 유리 | 불리 |
| 추천 상황 | **실제 데이터를 함께 보여줄 때** | 조건 충족하는 데이터가 **존재하는지만 확인**할 때 | 서브쿼리 결과가 **작고 고정된 범위**일 때 |

**서브쿼리** → 간단한 조건이나 상관관계 없는 서브쿼리 일 때 추천


## 트랜잭션 및 락 대기
✅ 

- 트랜잭션 유지 시간을 최소화하여 락 대기를 줄였는가?
- 적절한 커밋 타이밍을 설정하여 롤백 부담을 줄였는가?

| 트랜잭션 | 하나의 논리적 작업 단위 (`BEGIN ~ COMMIT/ROLLBACK`) | DB에 변경이 필요한 최소 범위로 한정 |
| --- | --- | --- |
| 락(Lock) | 데이터 무결성을 위한 배타 제어 수단 | 행 단위 락(Row-level Lock)을 유도하도록 SQL 설계 |
| 락 대기(Lock Wait) | 선행 트랜잭션이 락을 해제하지 않아서 후속 쿼리가 멈추는 현상 | 락이 오래 지속되면 블로킹 발생 |
| 블로킹 | 특정 트랜잭션이 다른 트랜잭션의 실행을 막는 상태 | 보통 `COMMIT` 또는 `ROLLBACK`으로 해제됨 |
| 교착 상태(Deadlock) | 두 트랜잭션이 서로의 락을 기다리며 영원히 대기 | DBMS가 한 트랜잭션을 강제 종료시켜 회피함 |

### 왜 트랜잭션이 길면 위험할까?

```sql
-- 사용자 A
BEGIN;
UPDATE T_ORDER SET 상태 = '배송중' WHERE 주문번호 = 12345;
-- commit; (여기서 커밋 안 함)

-- 사용자 B (다른 세션)
UPDATE T_ORDER SET 상태 = '완료' WHERE 주문번호 = 12345;
-- B는 A가 커밋하기 전까지 '락 상태'

```
- 락이 오래 유지되면 다른 사용자도 모두 기다림
- 트랜잭션 안에서 많은 작업을 하면, **롤백 시 복구 비용**도 커짐
- 트랜잭션이 복잡해질수록 교착 상태 발생 확률도 높아짐


### 비관적 락 vs 낙관적 락

|  | 비관적 락 | 낙관적 락 |
| --- | --- | --- |
| 개념 | 미리 락을 걸어 충돌을 방지 | 충돌이 날 경우 롤백 |
| 방법 | `SELECT ... FOR UPDATE` | `version`, `updated_at` 등 비교 |
| 장점 | 충돌 확실히 방지 | 락을 걸지 않아 성능 우수 |
| 단점 | 락 유지 시간 증가 → 성능 저하 | 충돌 시 재시도 필요 |
| 추천 상황 | 동시 수정 가능성 높을 때 | 대부분 읽기 전용, 충돌 드물 때 |

### 정리

| 트랜잭션 최소화 | 트랜잭션 범위를 최대한 좁힘 |
| --- | --- |
| 빠른 커밋 | 처리 로직 후 즉시 커밋 |
| SELECT는 트랜잭션 고려 | 가능하다면 조회 쿼리는 락을 걸지 않음 |
| 비관적 락 | `SELECT ... FOR UPDATE` → 락 걸린 상태로 트랜잭션 보장  (동시 수정 우려가 클 때) |
| 낙관적 락| 버전/타임스탬프로 변경 감지 → 충돌 시 롤백 유도 (충돌이 드물 때) |
| 파티셔닝 고려 | 핫스팟 테이블은 파티션 설계 |
| 인덱스 설계 | 불필요한 테이블 락 유발 방지 |
| 타임아웃 설정 | 일정 시간이 지났는데도 작업이 완료되지 않으면 강제로 중단 |


---

[친절한SQL튜닝](https://www.yes24.com/product/search?query=%25EC%25B9%259C%25EC%25A0%2588%25ED%2595%259CSQL%25ED%258A%259C%25EB%258B%259D)

https://escapefromcoding.tistory.com/777

[https://bommbom.tistory.com/entry/ROWID와-클리스터링-팩터CF의-관계는](https://bommbom.tistory.com/entry/ROWID%EC%99%80-%ED%81%B4%EB%A6%AC%EC%8A%A4%ED%84%B0%EB%A7%81-%ED%8C%A9%ED%84%B0CF%EC%9D%98-%EA%B4%80%EA%B3%84%EB%8A%94)

[https://velog.io/@yooha9621/SQLP4장-인덱스와-조인-3.-조인-기본원리](https://velog.io/@yooha9621/SQLP4%EC%9E%A5-%EC%9D%B8%EB%8D%B1%EC%8A%A4%EC%99%80-%EC%A1%B0%EC%9D%B8-3.-%EC%A1%B0%EC%9D%B8-%EA%B8%B0%EB%B3%B8%EC%9B%90%EB%A6%AC)

https://sabarada.tistory.com/175