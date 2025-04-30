# 실행 계획(EXPLAIN) 분석


## EXPLAIN이란?

- SQL 실행 전에 MySQL이 어떤 방식으로 쿼리를 처리할지 예측해주는 명령어입니다.
- 실행 계획을 통해 **쿼리 최적화 포인트를 파악**할 수 있습니다.
- 복잡한 SQL일수록 EXPLAIN은 필수입니다.

```java
# 사용예시
EXPLAIN SELECT * FROM users WHERE age > 30;
```

## EXPLAIN 기본 구성(MySQL 8.0 기준)

- **`id`**
    - `id`는 실행 계획의 각 SELECT 문을 구분하는 고유 식별자입니다.
    - 숫자가 클수록 나중에 실행되며, 동일한 `id` 값을 가진 경우 병렬적으로 실행될 수도 있습니다.
    - 서브쿼리가 포함된 경우 여러 개의 `id`가 표시됩니다
- **`select_type`**
    - `select_type`은 SELECT 문이 어떤 형태로 작성되었는지를 나타냅니다.
    - MySQL 옵티마이저가 쿼리를 어떻게 분류하고 처리하는지를 이해할 수 있는 단서가 됩니다.

  | 값 | 설명 |
      | --- | --- |
  | `SIMPLE` | 서브쿼리나 UNION이 없는 단순 SELECT 문입니다. |
  | `PRIMARY` | 가장 바깥쪽의 SELECT 문입니다. |
  | `SUBQUERY` | WHERE 절이나 SELECT 절 안에 포함된 서브쿼리입니다. |
  | `DERIVED` | FROM 절 안의 서브쿼리입니다. 실행 시 파생 테이블로 처리됩니다. |
  | `DEPENDENT SUBQUERY` | 외부 쿼리 컬럼에 의존하는 서브쿼리입니다. |
  | `UNION` | UNION 또는 UNION ALL 문에서 첫 번째 SELECT 문을 제외한 나머지 SELECT 문입니다. |
  | `DEPENDENT UNION` | 외부 쿼리에 의존하는 UNION SELECT 문입니다. |
  | `UNION RESULT` | UNION 결과를 저장하는 임시 테이블을 SELECT 하는 부분입니다. |
- **`type`**
    - `type`은 옵티마이저가 테이블에 접근하는 방식을 나타냅니다.
    - 실행 계획에서 가장 중요하게 보는 항목 중 하나이며, 쿼리의 성능을 좌우합니다.
    - `type`의 목표는 **최소한 `range` 이상**을 사용하는 것입니다. `ALL`이나 `index`만 사용된다면 인덱스 추가를 고려해야 합니다.

  | 값 | 설명 |
      | --- | --- |
  | `ALL` | 전체 테이블 스캔입니다. 인덱스를 사용하지 않으므로 가장 느립니다. |
  | `index` | 인덱스를 처음부터 끝까지 스캔합니다. ALL 보다는 낫지만 여전히 비효율적일 수 있습니다. |
  | `range` | 인덱스 범위를 검색합니다. (예: `age > 30`) |
  | `ref` | 특정 값에 대해 인덱스를 통해 여러 행을 검색합니다. |
  | `eq_ref` | 유일 인덱스(PK 또는 UNIQUE)에 의해 정확히 하나의 행이 검색됩니다. |
  | `const` | 상수 값을 기반으로 하나의 행만 조회할 때 사용됩니다. |
  | `system` | 하나의 행만 있는 테이블에서 사용됩니다. 거의 사용되지 않습니다. |
- `possible_keys`
    - `possible_keys`는 해당 쿼리에서 사용될 수 있는 인덱스 목록입니다.
    - 옵티마이저가 고려할 수 있는 모든 인덱스를 보여줍니다.
    - 이 값이 `NULL`이면 사용 가능한 인덱스가 없다는 의미이므로, 인덱스 추가를 검토해야 합니다.
- **`key`**
    - `key`는 실제로 사용된 인덱스를 나타냅니다.
    - `possible_keys`에 여러 인덱스가 나열되어 있더라도, 그 중 `key`에 표시된 하나만 선택됩니다.
    - `NULL`이면 인덱스를 사용하지 않았음을 의미합니다.
- `key_len`
    - `key_len`은 MySQL이 인덱스를 사용할 때 몇 바이트를 사용했는지를 나타냅니다.
    - 복합 인덱스를 사용하는 경우, 일부 컬럼만 사용되었다면 그에 맞는 길이만 계산됩니다.
    - 해당 값이 작을수록 인덱스 전체가 활용되지 않았을 가능성이 있습니다.
- `ref`
    - `ref`는 인덱스 검색 시 사용된 상수 값이나 컬럼을 의미합니다.
    - 조인 조건에 의해 어떤 방식으로 인덱스를 탐색했는지를 파악할 수 있습니다.
    - 예: `const`, `func`, `table_name.column_name` 등이 표시될 수 있습니다.
- **`rows`**
    - `rows`는 MySQL 옵티마이저가 예측한 탐색 대상 행의 수입니다.
    - 실제 결과 행 수가 아니라, 내부 통계와 조건에 따라 예측된 값입니다.
    - 서브쿼리나 조인에서 이 값이 너무 크면 성능 저하가 발생할 수 있으며, 이 경우 인덱스 추가 또는 쿼리 구조 개선이 필요합니다.
- **`Extra`**
    - `Extra`는 쿼리 실행 과정에서 발생하는 추가적인 정보나 조건을 설명합니다.
    - 쿼리 성능에 큰 영향을 미치는 힌트들이 포함되므로, 반드시 주의 깊게 확인해야 합니다.

  | 값 | 설명 |
      | --- | --- |
  | `Using where` | WHERE 절을 통해 조건을 필터링하고 있습니다. |
  | `Using index` | 인덱스만으로 데이터를 처리하였으며, 테이블 접근이 발생하지 않습니다. (커버링 인덱스) |
  | `Using temporary` | 쿼리 수행 시 임시 테이블을 사용하고 있습니다. (GROUP BY, ORDER BY 등에서 발생) |
  | `Using filesort` | 정렬 작업을 위해 메모리나 디스크 기반 정렬을 수행하고 있습니다. 성능 저하의 주요 원인입니다. |
  | `Range checked for each record` | 조인 대상 테이블에 적절한 인덱스가 없어, 각 레코드마다 범위 조건을 검사하고 있습니다. |
  | `Using join buffer` | 조인 버퍼를 사용하여 블록 단위 조인을 수행하고 있습니다. |
  | `Not exists` | LEFT JOIN 시 조건을 만족하는 행을 찾으면 이후 탐색을 중단합니다. |
  | `Distinct` | 중복을 제거하기 위해 이미 처리한 값과 동일한 Row는 건너뜁니다. |
  | `Using index for group-by` | GROUP BY 작업이 인덱스를 통해 처리되어 효율적으로 동작합니다. |

  ## 예시1)  WHERE 조건에 인덱스가 없는 경우

  ### - 쿼리문

    ```sql
    SELECT * FROM employees WHERE last_name = 'Kim';
    ```

  ### - EXPLAIN 결과

  | id | select_type | table | type | key | rows | Extra |
      | --- | --- | --- | --- | --- | --- | --- |
  | 1 | SIMPLE | employees | ALL | NULL | 300000 | Using where |

  ### - 해석

    - `table = employees`
        - employees 테이블을 대상으로 탐색합니다.
    - `select_type = SIMPLE`
        - 서브쿼리나 UNION 없는 단순 SELECT입니다.
    - `type = ALL`
        - **Full Table Scan**입니다.
        - 인덱스를 사용하지 않고 테이블 전체를 처음부터 끝까지 훑습니다.
    - `key = NULL`
        - **사용된 인덱스가 없습니다**.
    - `rows = 300000`
        - **MySQL 옵티마이저가 예상하는 탐색 대상 행의 수**입니다.
        - **MySQL 옵티마이저가 내부 통계정보를 기반으로 계산한 추정값**입니다.
    - `Extra = Using where`
        - 조건문을 사용하여 필터링을 하고 있습니다.

  ### - 문제점

    - `type = ALL`: 전체 테이블 스캔
    - `key = NULL`: 인덱스 미사용
    - 데이터 건수가 많을 경우 성능 저하

  ### - 개선 방법

    - `last_name` 컬럼에 인덱스를 생성합니다.

  ### - 개선 후 Explain 결과

  | id | select_type | table | type | key | rows | Extra |
      | --- | --- | --- | --- | --- | --- | --- |
  | 1 | SIMPLE | employees | ref | idx_last_name
    (앞서 생성해준 인덱스) | 50 | Using where |

  ## 예시 2) ORDER BY + LIMIT 시 정렬 인덱스 없는 경우

  ### - 쿼리문

    ```sql
    SELECT * FROM employees ORDER BY hire_date DESC LIMIT 10;
    ```

  ### - EXPLAIN 결과

  | id | select_type | table | type | key | rows | Extra |
      | --- | --- | --- | --- | --- | --- | --- |
  | 1 | SIMPLE | employees | ALL | NULL | 300000 | Using filesort |

  ### - 해석

    - `table = employees`
        - employees 테이블을 대상으로 탐색합니다.
    - `select_type = SIMPLE`
        - 서브쿼리나 UNION 없는 단순 SELECT입니다.
    - `type = ALL`
        - **Full Table Scan**입니다.
        - 인덱스를 사용하지 않고 테이블 전체를 처음부터 끝까지 훑습니다.
    - `key = NULL`
        - **사용된 인덱스가 없습니다**.
    - `rows = 300000`
        - **MySQL 옵티마이저가 예상하는 탐색 대상 행의 수**입니다.
        - **MySQL 옵티마이저가 내부 통계정보를 기반으로 계산한 추정값**입니다.
    - `Extra = Using filesort`
        - `Using filesort`는 MySQL이 **ORDER BY 절에 의해 정렬을 직접 수행해야 할 때** 표시됩니다.
        - 즉, 원하는 정렬 순서를 만들기 위해 **메모리나 디스크에 데이터를 임시로 정렬**하는 과정을 거친다는 뜻입니다.
        - 정렬에 사용된 컬럼이 인덱스에 포함되어 있고, 그 인덱스 순서대로 정렬이 가능하다면 filesort를 사용하지 않습니다.

  ### - 문제점

    - 정렬 인덱스 없습니다.
    - 데이터 건수가 많을 경우 성능 저하문제가 발생합니다.

  ### - 개선 방법

    - 정렬 기준 컬럼에 **정렬 방향까지 포함된 인덱스**를 생성합니다.

    ```sql
    CREATE INDEX idx_hire_date_desc ON employees(hire_date DESC);
    ```

  ### - 개선 후 EXPLAIN 결과

  | id | select_type | table | type | key | rows | Extra |
      | --- | --- | --- | --- | --- | --- | --- |
  | 1 | SIMPLE | employees | index | idx_hire_date_desc | 10 | Using index |

  ## 정리

    - `id`, `select_type`, `type`, `key`, `rows`, `Extra` 컬럼을 중심으로 실행 계획을 분석합니다.
    - 특히 `type`이 `ALL`(Full Table Scan)이거나 `Extra`에 `Using filesort`, `Using temporary`가 있다면 쿼리 성능 개선이 필요합니다.
    - 인덱스가 어떻게 사용되었는지를 `possible_keys`, `key`, `key_len`, `ref`를 통해 정밀하게 확인해야 합니다.