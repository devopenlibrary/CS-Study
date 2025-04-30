![](/Web/img/web_oauth_1.png)

## OAuth

- 안전한 권한 위임 프로토콜
- 내 계정의 일부 권한을 다른 애플리케이션에게 **안전하게 위임**하는 방법
- **ID/PW를 직접 넘기지 않고** 토큰을 통해 인증/권한 부여

1. 직접 ID/PW를 맡기면?
    - 보안 취약 (중간 탈취, 재사용 공격 등)
    - 사용자 신뢰 저하
2. OAuth를 쓰면?
    - 서비스는 **토큰만** 받아서 처리
    - 사용자는 ID/PW를 **자기 서비스에만** 맡김

|  | 역할 |
| --- | --- |
| Resource Owner | 리소스(정보)를 가진 사용자 |
| Client | 정보를 요청하는 앱 |
| Authorization Server | 권한을 부여하는 서버 (ex. Google OAuth Server) |
| Resource Server | 실제 데이터가 있는 서버 (ex. Google API Server) |

## 동작 흐름

![](/Web/img/web_oauth_2.png)

PAYCO OAuth 2.0 프로세스 (출처 : PAYCO 개발자센터)

## Access Token과 Refresh Token

| 종류 | 역할 |
| --- | --- |
| Access Token | 실제 API를 호출할 때 사용하는 짧은 수명 토큰 |
| Refresh Token | Access Token이 만료되었을 때 재발급 받기 위한 토큰 (더 길게 살아있음) |

✅ Refresh Token을 통해 사용자 재로그인 없이 세션 유지 가능

- **Access Token/Refresh Token** 관리가 중요

### Access Token: 권한 증명서

- Access Token: **클라이언트가 API 요청을 할 때 사용하는 열쇠**
- 짧은 수명 (몇 분 ~ 몇 시간)
    - 탈취당했을 때 피해를 줄이기 위함
    - 누군가 중간에서 가로채더라도, 시간이 지나면 자동으로 무효
- API 호출할 때 헤더에 넣어서 보낸다.

```
GET /user/profile
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

### Refresh Token
- Access Token이 만료되었을 때, **새 Access Token을 발급받기 위한 토큰**
- **Access Token보다 긴 수명** (보통 며칠 ~ 몇 달)
- 보통 서버 측에서 **안전하게 저장**해야 한다. 외부에 노출 x
    - Refresh Token이 탈취되면 Access Token을 무한히 재발급 받을 수 있음

| 구분 | Access Token | Refresh Token |
| --- | --- | --- |
| 목적 | API 호출 인증 | Access Token 갱신 |
| 수명 | 짧음 (분~시간) | 김 (일~개월) |
| 사용 위치 | API 서버 호출 시 Authorization 헤더 | Authorization 서버 호출 시 |


https://ksh-coding.tistory.com/62

[https://inpa.tistory.com/entry/WEB-📚-Access-Token-Refresh-Token-원리-feat-JWT?category=889117](https://inpa.tistory.com/entry/WEB-%F0%9F%93%9A-Access-Token-Refresh-Token-%EC%9B%90%EB%A6%AC-feat-JWT?category=889117)