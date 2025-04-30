# GraphQL

- 새로운 API 표준입니다.
- 특정한 데이터베이스나 특정한 스토리지 엔진과 관계되어 있지 않습니다.
- 페이스북에서 개발 및 오픈소스화 되었습니다.

## REST vs GraphQL

### REST

여러 개의 엔드포인트가 있고, 각 엔드포인트에 접근해 데이터를 수집합니다.
필요한 데이터를 가져오기 위해 n번의 요청을 보내야하고, 불필요한 추가 정보를 반환하기 때문에 과도한 페칭이 발생합니다.

![REST API](/Web/img/web_graphql_rest.png)

_REST 흐름, 출처: [GraphQL 문서](https://www.howtographql.com/basics/1-graphql-is-the-better-rest/)_

1. `/users/<id>`: 초기 사용자 데이터를 가져오는 엔드포인트
2. `/users/<id>/posts`: 사용자의 모든 게시물을 반환하는 엔드포인트
3. `/users/<id>/followers`: 사용자별 팔로워 목록을 반환하는 엔드포인트

### GraphQL

구체적인 데이터 요구 사항을 포함하는 단일 쿼리를 GraphQL 서버로 전송하고, 서버는 요구사항에 맞는 JSON 객체를 응답합니다.

![GraphQL](/Web/img/web_graphql_rest.png)

_GraphQL 흐름, 출처: [GraphQL 문서](https://www.howtographql.com/basics/1-graphql-is-the-better-rest/)_

### 비교

![비교](/Web/img/web_graphql_rest_graphql.png)

_REST와 GraphQL 비교, 출처: [카카오 기술 블로그 - GraphQL 개념잡기](https://tech.kakao.com/posts/364)_

- 오버페칭(Overfetching)해결
    - REST에서는 특정 엔드포인트에서 일부 데이터만 필요해도 전부 다 받아야한다.
    - graphQL은 필요한 필드만 명시해 요청이 가능하다.
- 언더페칭(Underfetching)과 N+1 해결
    - REST에서는 각 사용자에 대한 상세 데이터 요청시 사용자 목록 조회 1번과 사용자 상세 데이터에 대한 요청 N번인 N+1번만큼 요청한다.
    - graphQL은 한번으로 조회 가능하다.

## GraphQL의 핵심 개념

### 처리 흐름

![처리 흐름](/Web/img/web_graphql_flow.png)

_다이어그램, 출처:[카카오 기술 블로그 - GraphQL 개념잡기](https://tech.kakao.com/posts/364)_

1. GraphQL Query: 클라이언트가 GraphQL 쿼리를 서버에 전송합니다. 이 쿼리는 필요한 데이터의 구조와 필드를 정확히 명시합니다.
2. Query Language Processor: 쿼리 언어 프로세서는 받은 쿼리를 파싱하고 유효성을 검사합니다. 이 단계에서 쿼리의 문법적 오류나 스키마와의 불일치를 확인합니다.
3. GraphQL Resolver: 개발자가 구현해야 하는 부분으로, 실제 데이터를 가져오는 로직이 포함됩니다. 리졸버는 다양한 데이터 소스(오른쪽에 표시된)와 연결하여 요청된 데이터를 검색합니다:
    - RDB (관계형 데이터베이스)
    - NoSQL 데이터베이스
    - In-memory DB (메모리 내 데이터베이스)
    - REST/SOAP API 등 다른 웹 서비스
4. Output (JSON): 최종적으로 처리된 데이터는 JSON 형식으로 클라이언트에 반환됩니다.

### 쿼리 & 뮤테이션

gql에서는 굳이 쿼리와 뮤테이션을 나누는데 내부적으로 들어가면 사실상 이 둘은 별 차이가 없습니다.
쿼리는 데이터를 읽는데® 사용하고, 뮤테이션은 데이터를 변조(CUD) 하는데 사용한다는 개념 적인 규약을 정해 놓은 것 뿐입니다.

> - 쿼리: 데이터를 읽어오는 요청
> - 뮤테이션: 데이터를 변경하는 요청

#### 쿼리

데이터를 읽어오는 요청과 그에 대한 응답의 예시를 보며 이해합니다.

- 기본 요청
    - 요청
        ```graphQL
        {
          hero {
            name
          }
        }
        ```
    - 결과
        ```json
        {
          "data": {
            "hero": {
              "name": "R2-D2"
            }
          }
        }
        ```
- 인자: 특정 필드의 값을 지정
    - 요청: id가 1000인 사람의 이름과 키를 조회
        ```graphQL
        {
          human(id: "1000") {
            name
            # 키는 열거형 타입으로 사용
            height(unit: METER)
          }
        }
        ```
    - 결과
        ```json
        {
          "data": {
            "human": {
                "name": "Luke Skywalker",
                "height": 1.72
            }
          }
        }
        ```
- 별칭: 결과에 필드명을 별칭으로 지정
  - 요청: EMPIRE 에피스드의 영웅과 JEDI 에피소드의 영웅을 조회
    ```graphQL
    {
      empireHero: hero(episode: EMPIRE) { # empireHero이라는 별칭 사용
        name
      }
      jediHero: hero(episode: JEDI) { # jediHero이라는 별칭 사용
        name
      }
    }
    ```
  - 결과
    ```json
    {
      "data": {
        "empireHero": { # 지정한 필드명으로 나옴
          "name": "Luke Skywalker"
        },
        "jediHero": {
          "name": "R2-D2"
        }
      }
    }
    ```
- 프래그먼트: 재사용 가능한 필드 묶음을 선언해 사용
  - 요청
    ```graphql
    {
        leftComparison: hero(episode: EMPIRE) {
            ...comparisonFields
        }
        rightComparison: hero(episode: JEDI) { # rightComparison이라는 별칭 사용
            ...comparisonFields # ...을 붙여서 프래그먼트를 사용
        }
    }
    
    fragment comparisonFields on Character { # 재사용 가능한 필드 묶음을 선언
        name
        appearsIn
        friends {
            name
        }
    }
    ```
  - 응답
    ```json
    {
      "data": {
        "leftComparison": {
          "name": "Luke Skywalker",
          "appearsIn": [
            "NEWHOPE",
            "EMPIRE",
            "JEDI"
          ],
          "friends": [
            {
              "name": "Han Solo"
            },
            {
              "name": "Leia Organa"
            },
            {
              "name": "C-3PO"
            },
            {
              "name": "R2-D2"
            }
          ]
        },
        "rightComparison": {
          "name": "R2-D2",
          "appearsIn": [
            "NEWHOPE",
            "EMPIRE",
            "JEDI"
          ],
          "friends": [
            {
              "name": "Luke Skywalker"
            },
            {
              "name": "Han Solo"
            },
            {
              "name": "Leia Organa"
            }
          ]
        }
      }
    }
    ```

- 작업 이름: 작업의 이름을 지정해 명시
  - 요청
    ```graphql
    query HeroNameAndFriends { # HeroNameAndFriends라는 작업이름 지정, query는 작업 타입을 의미
      hero {
        name
        friends {
          name
        }
      }
    }
    ```
  - 응답
    ```json
    {
      "data": {
        "hero": {
          "name": "R2-D2",
          "friends": [
            {
              "name": "Luke Skywalker"
            },
            {
              "name": "Han Solo"
            },
            {
              "name": "Leia Organa"
            }
          ]
        }
      }
    }
    ```
- 변수: 작성한 쿼리에 변수를 넣어, 쿼리를 동적으로 사용
  - 요청: 
    ```graphql
    # 쿼리 정의
    query HeroNameAndFriends($episode: Episode) { # 외부에서 전달받을 인수를 '$'을 붙여 지정, 타입은 Episode 으로 지정
      hero(episode: $episode) {
        name
        friends {
          name
        }
      }
    }
    
    # 쿼리에 대한 변수
    {
      "episode": "JEDI"
    }
    ```
  - 응답
    ```json
    {
      "data": {
        "hero": {
          "name": "R2-D2",
          "friends": [
            {
              "name": "Luke Skywalker"
            },
            {
              "name": "Han Solo"
            },
            {
              "name": "Leia Organa"
            }
          ]
        }
      }
    }
    ```
- 지시어
  - 요청
  - 응답

#### 뮤테이션

데이터를 변경하는 요청의 예시와 그에 대한 응답 예시를 통해 이해합니다.

- 기본 요청
  - 요청
      ```graphql
      mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
        createReview(episode: $ep, review: $review) {
          stars
          commentary
        }
      }
  
  
      {
        "ep": "JEDI",
        "review": {
          "stars": 5,
          "commentary": "This is a great movie!"
        }
      }
      ```
  - 응답
    ```json
    {
      "data": {
        "createReview": {
          "stars": 5,
          "commentary": "This is a great movie!"
        }
      }
    }
    ```

### 스키마와 타입

- 스키마는 API의 기능을 명시하고, 클라이언트가 데이터를 요청하는 방식을 정의합니다.

- GraphQL은 API 스키마를 정의하기 위해 자체 타입 시스템을 사용하며, 이때 사용하는 문법을 스키마 정의 언어(SDL: Schema Definition Language)라고 합니다. 
    - GraphQL 스키마 언어(SDL)를 사용하여 쿼리 가능한 데이터의 구조와 타입을 정의합니다.

#### 데이터 타입


- 기본 타입: 스칼라 타입
    - Int: 부호가 있는 32비트 정수.
    - Float: 부호가 있는 부동소수점 값.
    - String: UTF-8 문자열.
    - Boolean: true 또는 false.
    - ID: ID 스칼라 타입은 객체를 다시 요청하거나 캐시의 키로써 자주 사용되는 고유 식별자를 나타냅니다. ID 타입은 String 과 같은 방법으로 직렬화되지만, ID 로 정의하는 것은 사람이 읽을 수 있도록 하는 의도가 아니라는 것을 의미합니다.

- 객체 타입(object)
    ```graphql
    type Character {
      name: String!
      appearsIn: [Episode]!
    }
    ```

    - `Character`: GraphQL 객체 타입 입니다. 즉, 필드가 있는 타입입니다. 스키마의 대부분의 타입은 객체 타입입니다.
    - `name`
        - `Character` 타입의 필드
        - String 타입으로 내장된 스칼라 타입 중 하나입니다.
        - `!`: 필드가 non-nullable임을 의미합니다.
    - `appearsIn`
        - `Character` 타입의 필드
        - `!`: 필드가 non-nullable 임을 의미합니다.
        - `[]`: 필드가 배열(array)임을 나타냅니다.


- 열거형 타입(enum): 타입의 인자가 허용된 값 중 하나임
    ```graphql
    enum Episode {
      NEWHOPE
      EMPIRE
      JEDI
    }
    ```
  
- 인터페이스(interface): 구현하기 위해 타입이 포함해야하는 특정 필드들을 포함하는 추상 타입, 공통 필드를 정의하는 추상 타입
  - 정의
    ```graphql
    interface Character {
      id: ID!
      name: String!
      friends: [Character]
      appearsIn: [Episode]!
    }
    ```
    
  - 사용 예시
    ```graphql
    type Human implements Character {
      id: ID!
      name: String!
      friends: [Character]
      appearsIn: [Episode]!
      starships: [Starship]
      totalCredits: Int
    }
    
    type Droid implements Character {
      id: ID!
      name: String!
      friends: [Character]
      appearsIn: [Episode]!
      primaryFunction: String
    }
    ```

- 유니온 타입(union): 인터페이스와 매우 유사하지만, 타입 간에 공통 필드는 없습니다.
    ```graphql
    union SearchResult = Human | Droid | Starship
    ```
  - enum은 나열한 값 중 하나를 선택해야하고, interface는 공통 필드가 있어야 한다.
  - 유니온은 이와 달리 단순히 값을 묶는 의미로, 3개는 각각 다른 필드를 가질 수 있으며 결과 값으로 3개의 값 중 하나를 **반환 하겠다**는 의미 

- 입력 타입(input type): 객체 타입과 같지만, `type`이 아닌 `input`을 사용하는 점이 다릅니다.
    - 정의 
        ```graphql
        input ReviewInput {
            stars: Int!
            commentary: String
        } 
        ```

    - 사용
  
        ```graphql
        mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
          createReview(episode: $ep, review: $review) {
            stars
            commentary
          }
        }
        
        {
          "ep": "JEDI",
          "review": {
            "stars": 5,
            "commentary": "This is a great movie!"
          }
        }
        ```
    
        ```json
        {
          "data": {
            "createReview": {
              "stars": 5,
              "commentary": "This is a great movie!"
            }
          }
        }
        ```
#### 요청 타입

GraphQL 서비스는 반드시 `Query` 타입을 포함하며, `Mutation` 타입은 선택적으로 포함할 수 있습니다.
이 타입들은 일반적인 객체 타입과 구조는 같지만, 모든 GraphQL 요청의 진입점(entry point) 역할을 하므로 특별한 의미를 가집니다.

- Query: 읽기 전용 요청
- Mutation: 쓰기/변경 요청
- Subscription: 실시간 데이터 스트림

## GraphQL 아키텍처 구성 방식

### 연결된 데이터베이스가 있는 GraphQL 서버

![일반적인 방법](/Web/img/web_graphql_db.png)

_일반적인 방법, 출처:[GraphQL 문서](https://www.howtographql.com/basics/3-big-picture/)_

쿼리 해결(resolving)

1. 클라이언트로부터 쿼리가 도착
2. 서버는 해당 쿼리의 페이로드를 해석
3. 데이터베이스에서 필요한 정보를 조회 


특징
- GraphQL은 전송 계층에 구애받지 않기 때문에, 모든 네트워크 프로토콜(TCP, 웹소켓 등)과 함께 사용할 수 있습니다.
- 데이터베이스나 데이터 저장 형식에 구애받지 않기 떄문에, Nosql DB를 사용할 수 있습니다.

### 기존 시스템을 통합하는 GraphQL 계층

단일하고 일관된 GraphQL API를 기반으로 여러 기존 시스템을 통합하는 방식

실제 서비스는 여러 개인데, GraphQL이라는 단인 API로 감싸서 간단하게 사용하도록 만듬

![레거시 통합](/Web/img/web_graphql_legacy.png)

_여러 서비스 통합, 출처:[GraphQL 문서](https://www.howtographql.com/basics/3-big-picture/)_

마이크로서비스, 레거시 인프라 또는 타사 API와 같은 기존 시스템의 복잡성을 단일 GraphQL 인터페이스 뒤에 숨길 수 있습니다.

### 하이브리드 방식 (DB + 기존 시스템 통합)


위에서 설명한 두 가지 접근 방식을 결합하는 방식으로, 연결된 DB가 있지만 다른 시스템과도 통신하는 서버를 만듬

![하이브리드 방식](/Web/img/web_graphql_db_legacy.png)

_하이브리드 방식, 출처:[GraphQL 문서](https://www.howtographql.com/basics/3-big-picture/)_

## 리졸버(Resolver)

이렇게 GraphQL이 유연할 수 있는 이유로, 요청을 보내면 **각 필드마다 실행되는 함수**를 리졸버 함수라고 합니다.

![리졸버](/Web/img/web_graphql_resolver.png)

_요청(좌), 실행되는 리졸버(우), 출처:[GraphQL 문서](https://www.howtographql.com/basics/3-big-picture/)_

### 연쇄 호출

- 객체 타입을 조회할 때마다 그 객체의 필드를 다시 조회하는 방식으로 동작합니다. 
- 쿼리의 구조를 따라 DFS(Depth First Search) 방식으로 리졸버를 호출됩니다.
    - 이 방식은 마치 그래프 구조를 탐색하는 것과 유사하기 때문에 "Graph"QL이라는 이름과도 잘 어울립니다.

1. user(id: 123)를 조회: user 리졸버가 실행, User 반환
2. name 필드 조회: 스칼라 타입 -> 호출 종료
3. followers 필드 조회: 객체 타입 -> User[] 반환 ->다시 followers 리졸버 호출
4. followers.name과 followers.age 조회: 배열 내 객체마다 필드 조회하는 리졸버 실행, 스칼라 값 -> 리졸버 종료

# 출처

- [GraphQL 문서](https://graphql-kr.github.io/learn/)
- [카카오 기술 블로그 - GraphQL 개념잡기](https://tech.kakao.com/posts/364)