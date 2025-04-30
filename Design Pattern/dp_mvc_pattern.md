## MVC 패턴

### MVC란?

MVC(Model-View-Controller) 패턴은 어플리케이션을 **Model(모델)**, **View(뷰)**, **Controller(컨트롤러)**의 세 가지 역할로 구분하여 개발하는 소프트웨어 디자인 패턴입니다.

이렇게 역할을 분리하면 **유지보수**와 **확장성**이 용이해지고, **협업** 시에도 역할을 명확히 나눌 수 있어서 효율적인 개발이 가능합니다.

![](/Design%20Pattern/img/dp_mvc_1.png)

## MVC의 구성 요소

### Model

- **데이터(상태) 및 비즈니스 로직**을 담당합니다.
- 데이터베이스와의 연동이나 핵심 로직을 수행하며, **뷰**나 **컨트롤러**는 모델에 직접 접근해 데이터를 얻거나 변경합니다.
- 예) 회원 정보, 게시글 정보, 상품 정보 등

### View

- **사용자에게 보이는 화면(UI)**을 담당합니다.
- 모델에서 받은 데이터를 시각적으로 표현하며, 사용자의 입력(이벤트) 또한 받아들입니다.
- 예) HTML, JSP, Swing, JavaFX 등의 화면 요소

### Controller

- **사용자의 요청 처리** 및 **흐름 제어**를 담당합니다.
- 사용자의 입력을 받아서 어떤 모델을 사용할지 결정하고, 모델에 명령을 내려 데이터를 변경하거나 조회한 뒤, 결과를 뷰에 전달합니다.
- 예) Servlet, Spring Controller 등

## MVC의 동작 흐름

1. **View**(사용자 화면)에서 이벤트(버튼 클릭, 폼 제출 등)가 발생합니다.
2. 이벤트를 **Controller**가 받아서 요청에 맞는 모델을 찾고, 필요한 연산을 수행하도록 지시합니다.
3. **Model**은 요구된 연산을 수행하거나 데이터베이스와 연동해 결과 데이터를 생성(또는 갱신)합니다.
4. **Model**에서 처리된 결과를 **Controller**가 받아, 적절한 **View**를 선택합니다.
5. 최종 결과를 담은 **View**가 사용자에게 렌더링되어 보여집니다.

![](/Design%20Pattern/img/dp_mvc_2.png)

## MVC의 장점

- **역할 분리로 인한 유지보수 용이**: 비즈니스 로직(Model)과 화면(View), 흐름 제어(Controller)가 분리되어 있어 각 부분을 독립적으로 수정하거나 교체하기가 쉽습니다.
- **확장성**: 특정 기능만 바꿔야 할 때 전체 코드를 수정하지 않고, 해당 모듈(예: Model, View, Controller 중 하나)만 수정하면 됩니다.

## MVC의 단점

- **구조가 복잡해짐**: 작은 규모의 프로젝트에서는 파일이 많아지고 구조가 복잡해져 오히려 비효율적일 수 있습니다.
- **데이터 바인딩/상호 의존성**: 모델과 컨트롤러, 뷰가 상호 의존관계를 가지면서 긴밀히 연결되면, 수정 시 영향 범위가 넓어질 수 있습니다.

## Java 예시 (간단 구조)

아래 예시 코드는 MVC 구조를 아주 단순화해서 나타냈습니다.
```java
// Model: User.java
public class User {
    private String name;
    private int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Getter & Setter
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}

// View: UserView.java
public class UserView {
    public void printUserDetails(String name, int age) {
        System.out.println("User: " + name + ", Age: " + age);
    }
}

// Controller: UserController.java
public class UserController {
    private User model;
    private UserView view;

    public UserController(User model, UserView view) {
        this.model = model;
        this.view = view;
    }

    public void setUserName(String name) {
        model.setName(name);
    }

    public String getUserName() {
        return model.getName();
    }

    public void setUserAge(int age) {
        model.setAge(age);
    }

    public int getUserAge() {
        return model.getAge();
    }

    public void updateView() {
        view.printUserDetails(model.getName(), model.getAge());
    }
}

// Main: Main.java
public class Main {
    public static void main(String[] args) {
        // 모델 생성
        User user = new User("Alice", 20);
        // 뷰 생성
        UserView view = new UserView();
        // 컨트롤러에 모델과 뷰 전달
        UserController controller = new UserController(user, view);

        // 초기 상태 출력
        controller.updateView();

        // 모델 정보 변경
        controller.setUserName("Bob");
        controller.setUserAge(30);

        // 변경 후 출력
        controller.updateView();
    }
}

// 출력 결과
User: Alice, Age: 20
User: Bob, Age: 30
```

1. `User`(Model)은 사용자 데이터를 가지고 있습니다.
2. `UserView`(View)는 데이터를 출력하는 역할을 수행합니다.
3. `UserController`(Controller)는 모델과 뷰를 연결하여 데이터 변경 또는 뷰 업데이트를 담당합니다.

## MVC와 관련이 깊은 내용들

### 1. Spring MVC

- **Spring** 프레임워크에서 제공하는 MVC 구조를 이용해, **DispatcherServlet**이 컨트롤러의 역할을 수행하고, **Model**과 **View**를 각각 쉽게 관리합니다.
- 컴포넌트 스캔, 의존성 주입(DI) 등을 통해 애플리케이션 전반을 구조화할 수 있습니다.

### 2. JSP & Servlet

- Java 웹 프로그래밍에서 기본적으로 MVC를 구현할 수 있는 기술 스택입니다.
    - **Servlet**: Controller 역할(사용자 요청 처리, 로직 수행 후 JSP에 데이터 전달)
    - **JSP**: View 역할(모델에서 전달된 데이터를 표현, 화면 구성)
    - **Model**: DTO, DAO, Service 계층 등을 분리해 구성 가능

### 3. ASP.NET MVC

- Microsoft의 .NET 프레임워크 기반 웹 개발에서 사용되는 MVC 구현체입니다.
- Controller, Model, View를 명확히 나누어 개발하도록 구조화되어 있습니다.

### 4. Ruby on Rails

- Ruby 언어 기반의 웹 프레임워크로, MVC 패턴을 강력히 지원하며 **Convention over Configuration**(관례가 많은 부분을 대신 처리) 철학을 갖고 있습니다.

## 참고 자료

1. [면접을 위한 CS 전공지식 노트, 주홍철]
2. [Spring 공식 문서 (Spring MVC)](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#spring-web)
3. [Microsoft Docs (ASP.NET MVC)](https://learn.microsoft.com/aspnet/mvc)
4. [Ruby on Rails 공식 사이트](https://rubyonrails.org/)