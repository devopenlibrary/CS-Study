# MVP Architecture Pattern

MVP(Model-View-Presenter) 아키텍처 패턴 은 사용자 인터페이스 구축에 주로 사용되는 **MVC(Model-View-Controller) 아키텍처 패턴의 파생형** 이다. MVC 패턴의 **`Controller` 의 자리에** 중개자 역할을 하는, **`Presenter` 라는 것이 위치**하게 된다.

![](/Design%20Pattern/img/dp_mvp_pattern_diagram.png)

- **`Model`**: 데이터와 비즈니스 로직을 처리하는 계층. API 사용, 데이터 캐싱, 데이터베이스 관리 와 같은 기능 담당.
- **`View`** : 데이터를 표시하고, 유저 이벤트를 처리하는 계층. 유저 이벤트가 발생하면, `Presenter` 의 메서드를 호출한다.
- **`Presenter`** : `View` 와 `Model` 사이의 중개자 역할을 하는 계층이다. `Model` 에서 데이터를 가져와 포맷팅한 후 `View`에 반환한다. 또한 `View` 인터페이스를 통한 사용자 상호작용에 반응하여 `Model`을 업데이트한다.

# MVC 패턴 사용 이유와 한계점

![](/Design%20Pattern/img/dp_mvp_pattern_mvc_why.png)

하나의 파일안에 계속 코드를 작성하면, 어떤 코드가 어디에 있는지 확인하기 어려워, 유지 보수, 변경이 어려워진다.

이런 점을 개선하기 위해 각각의 역할(`Model`, `View`, `Controller`) 에 따라 코드를 나누기 위해 MVC 패턴이 사용된다.

---

새로운 안드로이드 프로젝트를 생성하면 MVC 패턴 의 각각의 역할에 해당하는 다음과 같은 파일들이 생성된다.

![](/Design%20Pattern/img/dp_mvp_pattern_android.png)

하지만 실질적으로 안드로이드 프로젝트에서 **`Controller` 는 `View` 와 상당히 밀접하게 연결**되어 있다. 따라서, 사실상 `Controller` 는 `View` 에 속해있는 것에 가깝다고 볼 수 있다.

![](/Design%20Pattern/img/dp_mvp_pattern_android_2.png)

이러한 점 때문에,

- `Controller` 와 `View` 가 밀접하게 연결 되어 있어
  - **역할에 따른 분리가 실질적으로 명확하게 일어나지 않는 다는 점**
  - **테스트가 어렵다**는 점
- `Controller` 가 `View` 와 `Model` 을 모두 참조하기에, **프로젝트가 커질 수록 쉽게 비대**해 질 가능성 ⬆️
- **데이터와 비즈니스 로직을 처리**하는 `Model` 과 **UI 를 담당**하는 `View` 사이의 **의존성 발생**

과 같은 한계점이 발생하게 된다.

# MVC 패턴과의 차이 및 개선점

- 가장 큰 개선점으로는 **비즈니스 로직을 처리하는 계층과 UI 를 처리하는 계층을 분리** 했다는 것에 있다. `View` 와 `Model` 사이의 중개자 역할을 하는 `Presenter` 의 등장으로, 기존 MVC 패턴 의 `View` 와 `Model` 사이에 있었던 의존성을 제거하게 되었다.

- MVC 패턴에서는 `Controller` 가 유저 이벤트를 처리하지만, MVP 패턴에서는 이를 `View` 가 처리한다. 유저 이벤트에 대한 책임을 좀 더 명확하게 분산한다.

# 한계점

- `View` 와 `Presenter` 가 밀접하게 연결되어 있다는 점
  - 이로 인해 여전히 테스트가 어렵다는 점
- **보일러플레이트**(View 와 Presenter 에 대한 인터페이스) 발생

# 코드로 표현한 MVP 패턴

1.  `View` 와 `Presenter` 의 인터페이스 를 포함하는 `Contract` 인터페이스 를 생성한다.

```kotlin
// Boilerplate
interface Contract {
    // `View` 인터페이스
    interface `View` {
        fun showToast()
    }

    // `Presenter` 인터페이스
    interface `Presenter` {
        fun onButtonClick()
    }
}
```

2.  `Contract.Presenter` 인터페이스를 상속받는 `Presenter` 클래스 와 `Contract.View` 인터페이스를 상속받는 `Activity` 클래스를 생성한다.

```kotlin
// Contract.View 인터페이스를 상속받는 Activity 클래스
// 행위에 대한 구체적인 내용 추가
class MainActivity: AppCompatActivity(), Contract.View {
    lateinit var presenter: MainPresenter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        presenter = MainPresenter(this)

        // 버튼 클릭 리스너가 호출 되면,
        btn.setOnClickListener {
            // Presenter 에게 "버튼이 클릭되었다" 라고 알려줌
            presenter.onButtonClick()
            // Presenter 는 필요시, Model 업데이트와 같은 로직 실행
        }
    }

    // 유저에게 보여줄 데이터
    override fun showToast() {
        Toast.makeText(this, "Button pressed", Toast.LENGTH_SHORT). show()
    }
}
```

```kotlin
// Contract.Presenter 인터페이스를 상속받는 Presenter 클래스

class MainPresenter (
    private var view: Contract.View
): Contract.Presenter {

    override fun onButtonClick() {
        // View 에게 "토스트를 보내줘" 라고 알려줌.
        view.showTest()
    }
}
```

# 출처

- [What is MVP Design Pattern?](https://medium.com/huawei-developers/what-is-mvp-design-pattern-c587feea27d7)
- [Android Architecture Patterns: MVC vs MVVM vs MVP](https://daily.dev/blog/android-architecture-patterns-mvc-vs-mvvm-vs-mvp)
- [[10분 테코톡] 악어의 안드로이드 MVC 부터 MVVM 까지](https://www.youtube.com/watch?v=OPXf00DX4b0&t=12s)
