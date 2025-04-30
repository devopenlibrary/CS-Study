## 노출모듈 패턴 정의

즉시 실행 함수를 통해 private, public같은 접근 제어자를 만드는 패턴

객체와 함수를 활용하여 모듈을 구조화하고 필요한 부분만을 외부에 노출시키는 방식으로 동작함

## 노출 모듈 패턴의 구성 요소

1. **즉시 실행 함수(IIFE) ::** 노출 모듈 패턴은 즉시 실행 함수를 사용하여 모듈을 생성합니다. 이를 통해 모듈 내부의 변수와 함수들은 함수 스코프 내에 감춰져 외부에서 직접 접근할 수 없게 됩니다.
2. **프라이빗 변수 및 함수 ::** 모듈 내부에서는 외부에서 직접 접근되지 않을 프라이빗 변수와 함수들이 정의됩니다. 이들은 모듈 내부에서만 사용되며 외부에서는 접근할 수 없습니다.
3. **퍼블릭 변수 노출 ::** 모듈 외부에서 접근 가능한 변수를 명시적으로 지정하여 외부에 노출합니다. 이는 모듈의 인터페이스를 정의하며, 모듈 외부에서 사용 가능한 기능을 결정합니다.

## **노출 모듈 패턴의 장점**

- **유연성과 확장성**

노출 모듈 패턴은 모듈 내부의 구현을 변경하더라도 외부 인터페이스를 그대로 유지할 수 있습니다. 이는 모듈의 구현을 수정하더라도 클라이언트 코드를 변경하지 않고도 호환성을 유지할 수 있게 함

- **테스트 용이성**

노출 모듈 패턴을 사용하면 모듈의 내부 상태와 동작을 캡슐화하고, 외부에는 필요한 기능만을 노출하기 때문에 모듈의 단위 테스트가 더 쉬워짐

- **정보 은닉**

오로지 공개된 인터페이스만 외부에 노출하여 사용자가 모듈을 좀 더 쉽고 안전하게 사용할 수 있음.

## 노출 모듈 패턴의 단점

- **모듈 간 종속성**

각 모듈이 다른 모듈의 내부 구현에 의존하는 경우, 이는 모듈 간의 결합도를 증가시킬 수 있습니다. 이는 모듈의 재사용성과 독립성을 감소시킬 수 있습니다.

## 구현 예시

```jsx
var MyModule = (function() {
  var privateVariable = "This is a private variable";

  function privateFunction() {
    console.log("This is a private function");
  }

  function publicFunction() {
    console.log("This is a public function");
  }

  // 외부로 노출할 멤버를 객체로 반환합니다.
  return {
    publicFunction: publicFunction
  };
  
})();

// MyModule은 publicFunction만 외부에 노출됩니다.
MyModule.publicFunction(); // 출력: "This is a public function"
MyModule.privateVariable; // undefined (privateVariable은 외부에서 접근 불가능)
MyModule.privateFunction(); // 오류 (privateFunction은 외부에서 접근 불가능)
```

---

출처

https://geumjulee.tistory.com/52

https://velog.io/@juijeong8324/Design-Pattern-8

https://reveur1996.tistory.com/156