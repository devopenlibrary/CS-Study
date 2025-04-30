# CSRF(Cross-site request forgery, 사이트 간 요청 위조)

> 웹 사이트 취약점 공격 방법 중 하나로, 사용자가 자신의 의지와는 무관하게 공격자가 의도한 행위(수정, 삭제, 등록 등)를 특정 웹사이트에 요청하게 하는 공격을 말한다.

_출처:[위키디피아 - 사이트 간 요청 위조](https://ko.wikipedia.org/wiki/%EC%82%AC%EC%9D%B4%ED%8A%B8_%EA%B0%84_%EC%9A%94%EC%B2%AD_%EC%9C%84%EC%A1%B0)_

## 공격하는 방법

![공격 방법](/Web/img/web_csrf_example1.png)

1. 유저가 브라우저를 통해 A사이트에 접속해 로그인
2. A사이트는 로그인 과정 이후 유저를 식별하기 위해, 쿠키에 유저 식별 정보를 저장
3. 이후 유저가 브라우저를 통해 B사이트에 접속
4. B사이트에서는 유저 몰래 A사이트에 요청을 보냄
5. A사이트에서는 이 요청이 유저가 보낸 요청이라고 생각해 동작

### 왜 가능할까? 이유는 쿠키!

이러한 공격 방법이 가능한 이유는 쿠키의 특성 때문입니다.

> HTTP 쿠키(웹 쿠키, 브라우저 쿠키)란?
> - 서버가 사용자의 웹 브라우저에 전송하는 작은 데이터 조각입니다.
> - 브라우저는 그 데이터 조각들을 저장해 놓았다가, **동일한 서버에 재 요청 시 저장된 데이터를 함께 전송**합니다.

_출처: [MDN - HTTP 쿠키](https://developer.mozilla.org/ko/docs/Web/HTTP/Guides/Cookies)_

> Browsing context
> - 브라우징 컨텍스트는 브라우저가 문서를 표시하는 환경입니다.
>   - e.g. 탭, 창, iframe, 팝업 etc
> - 브라우징 컨텍스트 그룹은 기록, 쿠키, 저장 메커니즘 등과 같은 공통 컨텍스트를 공유하는 브라우징 컨텍스트 들의 집합입니다.

_출처: [MDN - Browsing context](https://developer.mozilla.org/en-US/docs/Glossary/Browsing_context)_

이 내용에서 요점만 요약하자면,
- 쿠키는 동일한 서버에 재요청시 **저장된 내용을 함께 전송**한다.
- 쿠키가 공유되는 **범위는 같은 브라우저의 탭, 창, 팝업 등을 포함**한다.

다시 예시 이해하기 

1. 크롬 브라우저를 이용해 A 사이트에 접속 후 로그인
2. A 사이트의 로그인 정보가 쿠키로 저장
3. 같은 브라우저를 이용해 B 사이트 접속
4. B 사이트에서 A 사이트에 요청
    - **유저가 A 사이트에 요청을 보내는 것처럼 행동 = 공격용 html 등을 이용**
    - e.g. 도착지를 변경하는 요청을 보내는 예시
        ```html
        <img src= "https://travel.service.com/travel_update?.src=Korea&.dst=Hell">
        ```
    - 이용자가 공격용 페이지를 열면, 브라우저는 이미지 파일을 받아오기 위해 공격용 URL을 실행
5. A 사이트는 로그인 정보를 같이 받게 되고, 유저가 요청한 것으로 인식해 요청의 내용을 수행
    - 유저는 이 사실을 모름

### XSS(Cross-Site Scripting)와의 차이

> XSS(Cross-Site Scripting)
> - 공격자가 웹사이트에 악성 클라이언트 사이드 코드를 삽입할 수 있도록 하는 보안 취약점 공격입니다.
> - 이 악성 코드는 피해자에 의해 실행되며 공격자가 접근 제어를 우회하고 사용자로 위장할 수 있게 만들어 줍니다.

_출처: [MDN - XSS](https://developer.mozilla.org/ko/docs/Glossary/Cross-site_scripting)_

XSS는 다양한 공격이 가능하지만, 여기서는 CSRF와 비슷한 공격을 한다고 했을 떄 어떤 차이가 있는지 알아보겠습니다.

![xss 예시](/Web/img/web_csrf_xss_example1.png)
![xss 예시](/Web/img/web_csrf_xss_example2.png)

1. 유저가 브라우저를 통해 A사이트에 접속해 로그인
2. A사이트는 로그인 과정 이후 유저를 식별하기 위해, 쿠키에 유저 식별 정보를 저장 
3. 유저가 브라우저를 통해 B사이트에 접속
4. B사이트에서는 유저 몰래 쿠키에 있는 정보를 탈취해 다른 곳으로 전송
5. 탈취한 정보를 이용해 A사이트에 요청
6. A사이트에서는 이 요청이 유저가 보낸 요청이라고 생각해 동작

차이점
- CSRF는 쿠키에 저장된 정보를 **직접 접근하지 않고**, 브라우저를 이용해 공격한다.
- XSS에서는 쿠키에 저장된 **정보를 가져와**, 이를 이용해 공격한다.

### 공격 예시

- 토렌트 클라이언트가 실행되어있는 상태에서 특정 파일을 자동으로 다운로드하는 요청을 보내, 다운로드 되도록 
- 이메일에 HTML 태그를 포함해서 전송해, 이메일을 열자마자 특정 요청을 보내도록함
- 포럼 글에 댓글로 html태그를 넣어 특정 요청을 보내도록 함

## 대응 방법

이를 해결하기 위한 방법으로는 여러가지 방법이 있고, 조합해서 사용할 수 있습니다.

1. CSRF 토큰(임의의 값) 이용
   ![대응방법](/Web/img/web_csrf_prevention.png)
   1. 임의의 값을 발급해주고, 요청헤더에 포함해 보냄 -> 요청 헤더의 값이 서버가 발급한 값이 맞는지 확인
      - Stateful: 서버에서 자신이 발급한 값이 맞는지 알고 있어야 함
   2. 브라우저에서 임의의 값을 같이 쿠키에 저장하고, 프론트에서는 이를 요청헤더에 포함해 보냄 -> 서버에서는 쿠키의 값과 헤더의 값이 같은지 비교
      - Stateless: 쿠키는 브라우저가 자동으로 같이 보내지만 헤더에 값을 자동으로 추가하지 않음을 이용한 방식으로, 서버에서는 두 개의 값이 같은지만 알면 됨 
2. origin/refer 이용: 서버에서 요청을 보낼 수 있는 origin/refer를 지정함으로써, 그 외에서 보낸 요청은 처리하지 않도록 함
   - origin/refer의 값은 브라우저가 요청을 보낼 때 설정하는 값
   - B사이트에서 브라우저를 이용해 A사이트에 요청을 보낸다면 origin/refer은 B사이트로 설정되어 있음
   > Origin과 Refer
   > 둘 다 요청이 **어디서 시작된 것인지에 대한 정보를 담고, 브라우저에서 자동으로 설정하고 변경이 불가능**합니다.
   > - Refer
   >     - 전체 URL 포함합니다. (e.g. `https://developer.mozilla.org/ko/docs/Web/JavaScript`, `https://example.com/page?q=123`)
   >     - 일부 브라우저, 확장 프로그램, 보안 설정에서 Referer를 생략하거나 마스킹합니다.
   > - Origin
   >     - 프로토콜 + 호스트 + 포트까지만 포함합니다. (e.g. `https://developer.mozilla.org`)
   >     - 보통은 GET에서는 포함되지 않습니다.
   
   _출처: [MDN - Refer](https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Headers/Referer), [MDN - Origin](https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Headers/Origin)_

3. SameSite 설정: 서버에서 쿠키로 인증 정보를 저장할 때, 이 쿠키가 자동으로 전송되는 범위를 설정하는 것
   - 출처(origin)나 요청 메서드의 타입에 따라 쿠키를 보낼지 안보낼지를 설정함
   - 종류 
      - Strict: 출처가 다르면 안보냄
      - Lax: 출처가 다를때는 GET 요청에만 보냄(기본값으로 설정)
      - None: 출처나 요청 메서드를 구분하지 않고 항상 보냄

# 출처
- [위키디피아 - 사이트 간 요청 위조](https://en.wikipedia.org/wiki/Cross-site_request_forgery)
- [MDN - HTTP 쿠키](https://developer.mozilla.org/ko/docs/Web/HTTP/Guides/Cookies)
- [MDN - Browsing context](https://developer.mozilla.org/en-US/docs/Glossary/Browsing_context)
- [MDN - XSS](https://developer.mozilla.org/ko/docs/Glossary/Cross-site_scripting)
- [MDN - Refer](https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Headers/Referer)
- [MDN - Origin](https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Headers/Origin)