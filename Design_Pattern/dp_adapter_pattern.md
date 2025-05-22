# Adapter Pattern

어댑터 패턴은 **서로 호환되지 않는 인터페이스를 가진 클래스들이 함께 작동할 수 있도록 해주는 구조적 디자인 패턴**이다. 이 패턴은 기존 코드를 수정하지 않고도 새로운 인터페이스와 함께 사용할 수 있게 해주는 중요한 역할을 한다.

일상생활에서 볼수 있는 것들 중 유사한 개념은, 전기 어댑터이다. 예를 들어, 대한민국에서는 220v 를 사용하지만, 일본에서는 110v 를 사용한다. 이때 전기를 공급받고자 사용하는 것이 전기어댑터이다.

![](/Design_Pattern/img/dp_adapter_pattern_electric_adapter.png)

## 구조
- 타겟 인터페이스(Target Interface): 클라이언트가 사용하려는 인터페이스 (e.g. 외부 API)
- 어댑터(Adapter): 타겟 인터페이스를 구현하고, 어댑티의 인터페이스를 호출하여 중간 역할을 수행
- 어댑티(Adaptee): 변환되어야 할 기존 클래스 (기존 애플리케이션 코드에서 사용되던 클래스)
- 클라이언트(Client): 타겟 인터페이스를 사용하는 객체

## 예시

```js
// 기존 API 서비스 (어댑티)
class LegacyUserAPI {
  getUsers() {
    // 레거시 API에서 반환하는 데이터 형식
    return [
      { id: 1, username: "user1", fullName: "User One", role: "admin" },
      { id: 2, username: "user2", fullName: "User Two", role: "editor" }
    ];
  }
}

// 새로운 API 서비스 (어댑티)
class NewUserAPI {
  fetchUserList() {
    // 새로운 API에서 반환하는 데이터 형식
    return {
      status: "success",
      data: [
        { userId: 101, name: "John Doe", email: "john@example.com", permissions: ["read", "write"] },
        { userId: 102, name: "Jane Smith", email: "jane@example.com", permissions: ["read"] }
      ]
    };
  }
}

// 통합 사용자 API 어댑터 (타겟 인터페이스 구현)
class UserAPIAdapter {
  constructor(api) {
    this.api = api;
  }

  getUsers() {
    // LegacyUserAPI 어댑터
    if (this.api instanceof LegacyUserAPI) {
      const users = this.api.getUsers();
      return users.map(user => ({
        id: user.id,
        name: user.fullName,
        username: user.username,
        permissions: user.role === "admin" ? ["read", "write", "delete"] : ["read"]
      }));
    }
    // NewUserAPI 어댑터
    else if (this.api instanceof NewUserAPI) {
      const response = this.api.fetchUserList();
      if (response.status === "success") {
        return response.data.map(user => ({
          id: user.userId,
          name: user.name,
          username: user.email.split('@')[0],
          permissions: user.permissions
        }));
      }
      return [];
    }
  }
}

// 클라이언트 코드
const legacyAPI = new LegacyUserAPI();
const newAPI = new NewUserAPI();

const legacyAdapter = new UserAPIAdapter(legacyAPI);
const newAdapter = new UserAPIAdapter(newAPI);

console.log("Users from Legacy API (adapted):");
console.log(legacyAdapter.getUsers());

console.log("\nUsers from New API (adapted):");
console.log(newAdapter.getUsers());

```