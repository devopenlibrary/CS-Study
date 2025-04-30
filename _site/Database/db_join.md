## 조인(JOIN)

### 조인이란?
조인이란 데이터베이스에서 두 개 이상의 테이블을 연결(결합)하여 데이터를 조회하는 방법을 말합니다. 보통 두 테이블 간에 공통으로 갖고 있는 컬럼(키 값)을 이용해, 하나의 테이블처럼 데이터를 추출하는 데에 사용됩니다.

### 조인의 종류
조인은 크게 다음과 같은 유형으로 나눌 수 있습니다.

1. **INNER JOIN (내부 조인)**
2. **LEFT (OUTER) JOIN (왼쪽 외부 조인)**
3. **RIGHT (OUTER) JOIN (오른쪽 외부 조인)**
4. **FULL (OUTER) JOIN (전체 외부 조인)** - MySQL에서는 직접 지원하지 않음
5. **CROSS JOIN (교차 조인)**

아래에서 각각의 조인 유형과 MySQL 예시를 살펴보겠습니다.

---

## 1. INNER JOIN (내부 조인)
두 테이블에서 조인 조건에 일치하는 행만 반환합니다.  
즉, 두 테이블 모두 조건에 부합하는 데이터가 있을 때만 결과가 나옵니다.

#### 문법
```sql
SELECT [칼럼 목록]
FROM 테이블A
INNER JOIN 테이블B
    ON 테이블A.조인컬럼 = 테이블B.조인컬럼;
```

#### 예시
```sql
-- 예시로 'employees' 테이블과 'departments' 테이블이 있다고 가정
-- employees(department_id), departments(department_id)
SELECT e.employee_id, e.name, d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.department_id;
```
- `employees` 테이블과 `departments` 테이블에서 `department_id`가 동일한 행만 추출합니다.
- `employees` 테이블에 있는 부서 정보와, `departments` 테이블에 있는 상세 부서명을 함께 조회할 수 있습니다.

![](/Database/img/db_join_1.png)

---

## 2. LEFT (OUTER) JOIN (왼쪽 외부 조인)
왼쪽 테이블(LEFT에 명시된 테이블)을 기준으로, 조인 조건에 맞는 행은 매칭하고, 맞지 않는 행이 있어도 왼쪽 테이블의 데이터는 모두 반환합니다(오른쪽 테이블에서 매칭되는 값이 없으면 NULL로 표시).

#### 문법
```sql
SELECT [칼럼 목록]
FROM 테이블A
LEFT JOIN 테이블B
    ON 테이블A.조인컬럼 = 테이블B.조인컬럼;
```

#### 예시
```sql
SELECT e.employee_id, e.name, d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;
```
- `employees` 테이블 기준으로 모든 직원을 보여줍니다.
- 직원이 소속된 부서가 존재하지 않는 경우(매칭되는 `department_id`가 없는 경우), `department_name` 컬럼은 NULL이 됩니다.

![](/Database/img/db_join_2.png)

---

## 3. RIGHT (OUTER) JOIN (오른쪽 외부 조인)
LEFT JOIN과 반대로, 오른쪽 테이블(RIGHT에 명시된 테이블)을 기준으로 모든 행을 반환합니다.  
조인 조건이 맞지 않는 경우 왼쪽 테이블 값이 NULL로 표시됩니다.

#### 문법
```sql
SELECT [칼럼 목록]
FROM 테이블A
RIGHT JOIN 테이블B
    ON 테이블A.조인컬럼 = 테이블B.조인컬럼;
```

#### 예시
```sql
SELECT e.employee_id, e.name, d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;
```
- `departments` 테이블에서 모든 부서를 다 보여주고, 소속 직원을 조인합니다.
- 어떤 부서에 소속된 직원이 없다면, 해당 부서 행의 직원 정보(employee_id, name)는 NULL이 됩니다.

![](/Database/img/db_join_3.png)

---

## 4. FULL (OUTER) JOIN (합집합 조인)
두 테이블에서 일치하는 모든 행 + 왼쪽 테이블만 갖는 행 + 오른쪽 테이블만 갖는 행을 모두 보여주는 조인입니다. 즉, 조건에 만족하지 않는 행까지 모두 표기합니다. 
**MySQL에서는 FULL OUTER JOIN을 직접 지원하지 않기 때문에**, 다음과 같은 방식으로 `LEFT JOIN`과 `RIGHT JOIN`을 `UNION`으로 결합해 구현할 수 있습니다.

#### 예시
```sql
SELECT e.employee_id, e.name, d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id

UNION

SELECT e.employee_id, e.name, d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;
```
- 이렇게 하면 두 결과를 합쳐서 완전한 조인 효과를 낼 수 있습니다.

![](/Database/img/db_join_4.png)

---

## 5. CROSS JOIN (교차 조인)
교차 조인은 두 테이블의 모든 행을 곱(Cartesian Product)하여 반환합니다.  
테이블 A에 n개 행, 테이블 B에 m개 행이 있으면 결과는 n×m행이 됩니다.

#### 문법
```sql
SELECT [칼럼 목록]
FROM 테이블A
CROSS JOIN 테이블B;
```

#### 예시
```sql
SELECT e.name, d.department_name
FROM employees e
CROSS JOIN departments d;
```
- `employees` 테이블의 모든 직원과 `departments` 테이블의 모든 부서가 조합된 형태로 결과가 나옵니다.
- 실제 비즈니스 로직에서는 잘 사용되지 않지만, 특정 경우(모든 가능한 조합이 필요한 경우)에만 사용합니다.

## 간단 정리
- **INNER JOIN**: 조건에 맞는 행만
- **LEFT JOIN**: 왼쪽 테이블 기준으로 모두 + 오른쪽 일치
- **RIGHT JOIN**: 오른쪽 테이블 기준으로 모두 + 왼쪽 일치
- **FULL JOIN**: 양쪽 테이블 모두(단, MySQL에서는 LEFT + RIGHT + UNION으로 사용)
- **CROSS JOIN**: 카테시안 곱(조건 없이 모든 행 조합)

## 참고 자료
- MySQL 공식 문서: https://dev.mysql.com/doc/  
- 면접을 위한 CS 전공지식 노트, 주홍철  
