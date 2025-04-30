# **CORS**

## 출처(Origin)

![](/Network/img/network_cors_1.png)

[토스](https://docs.tosspayments.com/resources/glossary/cors)

### origin = protocol + host + port

Origin 헤더는 **HTTP 요청이 시작된 출처**를 나타낸다.

프로토콜, 호스트, 포트가 모두 일치하는 경우 같은 출처라고 한다. 

---

## **동일 출처 정책 (Same-origin policy, SOP)**

하나의 출처에서 불러온 문서나 스크립트가 **다른 출처에서 가져온 리소스와 상호 작용할 수 있는 방법을 제한**하는 보안 메커니즘이다. 

하지만 웹 생태계가 발전하며 여러 서비스 간 데이터 교환이 중요해졌다. 기본적으로 서로 다른 출처끼리는 리소스를 주고받지 못하기 때문에, 개발자들은 **JSONP** 같은 우회 방법을 사용해야 했다.

### 만약 동일 출처 정책이 없다면?

1. **악의적인 사이트가 사용자의 정보에 접근**할 수 있다.
    - 쿠키나 세션 정보 같은 인증 정보를 이용해 사용자의 데이터를 탈취할 수 잇다.
2. **민감한 데이터 유출**
    - 사용자가 은행 사이트에 로그인한 상태에서, 악의적인 웹사이트가 은행의 API를 호출해 사용자의 계좌 정보를 가져갈 수 있다.
3. **CSRF 공격**
    - 악의적인 사이트가 다른 출처의 웹사이트에 요청을 보내 사용자가 원하지 않는 행동(예: 송금)을 할 수 있다.

따라서 SOP 정책으로 다른 출처의 스크립트가 실행되지 않도록 브라우저에서 사전에 방지한다. 

---

## **교차 출처 리소스 공유**(Cross-Origin Resource Sharing, **CORS** )

✅ SOP의 한계를 극복하기 위해 등장한 것이 **CORS**

✅ CORS는 막는 것이 아니라 **허용**해주는 메커니즘

CORS(Cross-Origin Resource Sharing)는 **웹 브라우저가** 자신의 출처가 아닌 다른 출처에서 리소스를 요청할 때, 해당 요청을 허용할지 결정하는 HTTP 헤더 기반 웹 보안 메커니즘이다. 브라우저의 기본 보안 정책인 동일 출처 정책(Same-Origin Policy)을 완화하기 위해 등장했다.  

**👉 즉, SOP 정책을 위반해도 CORS 정책에 따르면 다른 출처의 리소스라도 허용한다.**

### **CORS의 필요성**

1. 보안 유지
    - 브라우저가 불필요한 데이터 접근은 막고 서버가 허용한 출처에서만 데이터를 공유한다.
2. 웹 서비스 간 유연성을 확보
    - SOP를 보완하여 보안을 유지하면서도 데이터 공유가 가능하다

### **CORS 동작 원리**

**단순 요청(Simple Request)**

- 다음 조건을 모두 만족하는 요청
    1. HTTP 메서드가 `GET`, `POST`, `HEAD` 중 하나
    2. 커스텀 헤더를 사용하지 않고, 브라우저가 기본적으로 설정하는 헤더만 포함
    3. `XMLHttpRequest`나 `fetch` API를 사용하며 `withCredentials`가 `false`일 때
- 단순 요청의 흐름
    
    ![](/Network/img/network_cors_2.png)
    
1. **브라우저 → 서버 (요청)**
    
    브라우저는 요청을 보낼 때 **`Origin` 헤더**를 포함한다. 
    
    ```
    GET /api/data HTTP/1.1
    Host: server.example.com
    Origin: https://client.example.com
    ```
    
    ⇒ `Origin: https://client.example.com`
    
2. **서버 → 브라우저 (응답)**
    
    서버는 요청을 처리하고, 응답에 **CORS 관련 헤더**를 포함시킨다.
    
    ```
    HTTP/1.1 200 OK
    Access-Control-Allow-Origin: https://client.example.com
    Content-Type: application/json
    
    {"message": "success"}
    ```
    
    ⇒ `Access-Control-Allow-Origin: https://client.example.com`
    

1. **브라우저 검증**
    
    브라우저는 서버 응답에 포함된 `Access-Control-Allow-Origin` 값을 확인한다.
    
    - 요청의 `Origin`과 `Access-Control-Allow-Origin`이 일치하면 리소스를 사용할 수 있다.
    - 일치하지 않으면 CORS 에러를 발생

**Preflight Request**

- 복잡한 요청은 Preflight 단계를 거친다.
- 요청의 흐름
    
    ![](/Network/img/network_cors_3.png)
    
    1. **브라우저 → 서버 (OPTIONS 요청)**
        
        브라우저는 리소스를 요청하기 전에 **OPTIONS 메서드**를 사용하여 서버에 **Preflight** 확인 요청을 보낸다.
        
        ```
        OPTIONS /api/data HTTP/1.1
        Host: server.example.com
        Origin: https://client.example.com
        Access-Control-Request-Method: PUT
        Access-Control-Request-Headers: My-Custom-Header
        ```
        
    2. **서버 → 브라우저 (Preflight 응답)**
        
        서버는 OPTIONS 요청에 대해 허용된 조건들을 응답 헤더에 포함하여 반환한다.
        
        ```
        HTTP/1.1 204 No Content
        Access-Control-Allow-Origin: https://client.example.com
        Access-Control-Allow-Methods: PUT, POST, GET
        Access-Control-Allow-Headers: My-Custom-Header, Authorization
        Access-Control-Max-Age: 86400
        ```
        
    
    1. **브라우저 → 서버 (실제 요청)**
        
        Preflight 요청을 통과하면, 브라우저는 이제 실제 HTTP 요청을 서버로 보낸다.
        
        ```
        PUT /api/data HTTP/1.1
        Host: server.example.com
        Origin: https://client.example.com
        My-Custom-Header: custom-value
        Content-Type: application/json
        
        {"data": "new data"}
        ```
        
    
    1. **서버 → 브라우저 (응답)**
        
        서버는 요청을 처리하고 응답에 CORS 헤더를 포함시킨다.
        
        ```
        HTTP/1.1 200 OK
        Access-Control-Allow-Origin: https://client.example.com
        Content-Type: application/json
        
        {"message": "update success"}
        ```
        
    
    1. **브라우저 검증**
        
        브라우저는 응답의 `Access-Control-Allow-Origin` 값을 확인하고, 일치하면 리소스를 사용할 수 있다.
        

| 구분 | 단순 요청(Simple) | 프리플라이트 요청(OPTIONS) |
| --- | --- | --- |
| HTTP 메서드 | `GET`, `POST`, `HEAD` | `OPTIONS` |
| 추가 헤더 사용 | X | O |
| 요청 흐름 | 직접 요청 | Preflight → 실제 요청 |
| 주요 사용 사례 | 일반적인 API 호출 | `PUT`, `DELETE`, 커스텀 헤더 사용 |

### **CORS 헤더**

**요청**

| Origin | 요청이 시작된 위치 |
| --- | --- |
| Access-Control-Request-Method | 프리플라이트 요청 시, 어떤 HTTP 메서드가 사용될 것인지 서버에 알림 |
| Access-Control-Request-Headers | 프리플라이트 요청 시, 사용될 HTTP 헤더를 서버에 알림 |

**응답**

| Access-Control-Allow-Origin | 응답이 허용될 출처 |
| --- | --- |
| Access-Control-Allow-Credentials | 자격 증명(쿠키, HTTP 인증 헤더, 클라이언트 SSL 인증서 등)을 요청에 포함할 수 있도록 허용하는 옵션 |
| Access-Control-Allow-Headers | 허용된 요청 헤더 |
| Access-Control-Allow-Methods | 허용된 HTTP 메서드 |
| Access-Control-Expose-Headers | 클라이언트가 접근할 수 있는 응답 헤더를 명시. |
| Access-Control-Max-Age | Preflight 요청 결과를 캐싱할 시간 |
- `Access-Control-Allow-Origin: *` 는 보안상 위험이 있으므로 정확한 출처를 지정하는게 좋다.
- `Access-Control-Allow-Credentials: true` 를 사용하면 `Access-Control-Allow-Origin: *` 는 함께 쓸 수 없다

### CORS 에러 해결

- 서버에서 정확한 헤더 설정.
- 프록시 서버 사용.
- 개발 중 로컬 환경에서 브라우저 CORS 비활성화.

👉 [Spring에서 CORS 옵션 넣는 방법](https://spring.io/guides/gs/rest-service-cors)

🍎 참고

https://developer.mozilla.org/ko/docs/Glossary/Origin

https://developer.mozilla.org/ko/docs/Web/Security/Same-origin_policy

https://developer.mozilla.org/ko/docs/Web/HTTP/CORS

https://docs.tosspayments.com/resources/glossary/cors

[https://pallycon.com/ko/blog/cors의-이해와-올바른-구현을-위한-가이드/](https://pallycon.com/ko/blog/cors%EC%9D%98-%EC%9D%B4%ED%95%B4%EC%99%80-%EC%98%AC%EB%B0%94%EB%A5%B8-%EA%B5%AC%ED%98%84%EC%9D%84-%EC%9C%84%ED%95%9C-%EA%B0%80%EC%9D%B4%EB%93%9C/)

[https://velog.io/@nayeon/CORS-개념과-간단한-XSS-CSRF-소개](https://velog.io/@nayeon/CORS-%EA%B0%9C%EB%85%90%EA%B3%BC-%EA%B0%84%EB%8B%A8%ED%95%9C-XSS-CSRF-%EC%86%8C%EA%B0%9C)