# CDN (Content Delivery Network)

- 콘텐츠를 빠르고 효율적으로 제공하기 위한 **전 세계 분산 서버 네트워크**
- 주로 정적 리소스(HTML, CSS, JS, 이미지, 동영상) 전송에 사용
- **사용자와 가까운 서버**에서 응답해 웹사이트 속도를 개선

### 장점

1. 속도 개선
    - 거리 = 느린 속도
        -  서버가 한국에만 있다면, 미국/유럽/남미 사용자는 패킷이 오고 가는 데 수십~수백 ms 더 걸림
        - 패킷 손실, 네트워크 품질 문제 개선
    - 짧은 거리 → 짧은 전송 시간 → **빠른 응답 속도**

2. 서버 부하 분산
    - 트래픽을 **CDN 서버들이 분산 처리** 해서 Origin 서버에 모든 요청이 몰리는 것을 막음
2. 가용성 향상
    - 서버 하나가 죽어도 다른 CDN 서버로 연결
    - 장애에 강한 아키텍처
3. 보안 강화
    - DDoS 완화 (분산 구조)
    - WAF(웹 방화벽), TLS 암호화 제공
4. 글로벌 서비스
    - 세계 어디서든 빠른 접속 가능

### 동장 방식

![](/Web/img/web_cdn_1.png)

1. 사용자가 URL 요청
2. DNS 서버가 사용자에게 가장 가까운 CDN 서버 IP 제공 ([DNS](https://github.com/devopenlibrary/CS-Study/blob/main/Network/network_dns.md))
3. CDN 서버가 리소스 응답
4. 캐시 미스(Cache Miss) 발생 시 원본 서버에서 가져와 저장

### 단점

- 캐시 관리 복잡성
    - 업데이트 빈번한 경우 캐시 갱신 문제 발생
- 비용
    - 기본 웹 호스팅보다 비싸다 (대역폭에 따라 요금 청구)
- 초기 설정 복잡
    - 올바른 캐시 정책과 오리진 설정 필요
    


https://library.gabia.com/contents/infrahosting/8985/

https://www.cloudflare.com/ko-kr/learning/cdn/what-is-a-cdn/