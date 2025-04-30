# RESTful API 설계 원칙과 네이밍 컨벤션



##  1. RESTful API란?

**RESTful API**는 REST(Representational State Transfer) 아키텍처 스타일을 따르는 API입니다.  
HTTP 프로토콜을 기반으로 자원(Resource)을 URI로 식별하고, HTTP 메서드를 통해 자원에 대한 행위(CRUD)를 정의합니다.

### REST의 핵심 개념
- **자원(Resource)**: URI로 식별되는 객체 (예: `/users`)
- **행위(Verb)**: HTTP Method로 표현 (GET, POST, PUT, DELETE)
- **표현(Representation)**: JSON, XML 등으로 자원의 상태 전달
- **무상태성(Stateless)**: 요청 간 상태를 서버에 저장하지 않음



## 2. RESTful API 설계 원칙

### 2.1 자원은 URI로 고유하게 식별
- URI는 자원의 위치가 아닌 **식별자** 역할
- 예시:
    - `/users` → 사용자 컬렉션
    - `/users/1` → 특정 사용자



### 2.2 HTTP 메서드를 목적에 맞게 사용

| 메서드   | 목적             | 설명                              |
|----------|------------------|-----------------------------------|
| GET      | 조회 (Read)       | 자원 조회. 멱등성 O,        |
| POST     | 생성 (Create)     | 새 자원 생성. 멱등성 X             |
| PUT      | 전체 수정 (Update)| 자원 전체 수정. 멱등성 O           |
| PATCH    | 부분 수정         | 자원 일부 수정. 멱등성 X        |
| DELETE   | 삭제 (Delete)     | 자원 삭제. 멱등성 O                |

> 💡 멱등성: 동일 요청을 여러 번 보내도 결과가 같음



### 2.3 무상태(Stateless) 구조
- 각 요청은 **독립적**이어야 함
- 서버는 클라이언트의 이전 상태를 **저장하지 않음**
- 인증은 `Authorization` 헤더에 토큰(JWT 등)으로 전달



### 2.4 일관된 자원 표현 사용
- 주로 JSON 형식을 사용
- 응답 구조는 통일성 있게 유지
- 클라이언트는 `Accept` 헤더로 원하는 포맷 지정 가능

#### 예시 응답(JSON)

```json
{
  "id": 1,
  "name": "Seunga",
  "email": "seunga@example.com"
}
```

## 3. RESTful API 네이밍 컨벤션

### 3.1 자원명은 **명사**로 표현
- 자원의 의미가 명확하게 드러나야 함
- `/getUser`(X) → `/users` (O)



### 3.2 자원은 **복수형**으로 사용

| 패턴               | 예시               | 설명                    |
|--------------------|--------------------|-------------------------|
| 복수 자원 조회     | `/users`           | 사용자 목록 조회        |
| 단일 자원 접근     | `/users/1`         | ID가 1인 사용자 조회    |
| 하위 자원 조회     | `/users/1/posts`   | 사용자 1의 게시글 목록  |

> 💡셀 수 없는 명사(data, info 등)는 단수 그대로 사용



### 3.3 소문자 사용
- URI는 모두 **소문자**로 구성  
  - (O) `/user-posts`  
  - (X) `/UserPosts`



### 3.4 단어 구분은 하이픈(-) 사용
- 가독성과 URI 표준을 위해 하이픈 사용  
  - (O) `/user-posts`  
  - (X) `/userPosts`, `/user_posts`



### 3.5 계층 구조로 관계 표현
- 자원 간 포함 관계를 계층 구조로 표현
  -   `/users/1/posts/2/comments`

### 3.6 쿼리 파라미터는 필터링, 정렬 등에 사용
- `GET /users?page=2&limit=20&sort=name` 

## 4. 응답 및 상태 코드 규칙

### 4.1 HTTP 상태 코드

| 상태 코드 | 의미                           |
|-----------|--------------------------------|
| 200 OK    | 요청 성공                      |
| 201 Created | 자원 생성 성공              |
| 204 No Content | 요청 성공, 본문 없음     |
| 400 Bad Request | 잘못된 요청              |
| 401 Unauthorized | 인증 실패               |
| 403 Forbidden | 권한 없음                 |
| 404 Not Found | 자원 없음                 |
| 500 Internal Server Error | 서버 내부 오류 |

### 4.2 에러 응답 포맷 예시

```json
{
  "status": 400,
  "message": "Invalid request parameter",
  "errorCode": "ERR_BAD_REQUEST"
}
```

## 5. 결론
RESTful API는 표준 HTTP 프로토콜을 바탕으로 자원 중심의 설계를 통해
API를 일관성 있게, 예측 가능하게, 확장 가능하게 만듭니다.
>  💡RESTful하게 설계하되, 상황에 따라 유연하게 적용하는 것이 가장 중요합니다.