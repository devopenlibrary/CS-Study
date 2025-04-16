# **Factory Pattern**

정확하게는 팩토리 메서드 패턴과 추상 팩토리 패턴이 있다.

## **Simple Factory**
객체를 생성하는 부분을 분리해 불필요한 의존성을 없애는 것을 팩토리 패턴, 심플 팩토리라고 부른다.
심플 팩토리는 정확하게 말하자면 패턴은 아니며 프로그래밍에서 자주 쓰이는 관용구에 가깝다.

아래는 심플 팩토리의 예시다.

```C++
class Pizza
{
public:
    virtual void prepared();
    virtual void bake();
    virtual void cut();
    virtual void box();
}

class CheesePizza : public Pizza
{
    //...
}

class PepperoniPizza : public Pizza
{
    //...
}

class SimplePizzaFactory
{
public:
    virtual Pizza* createPizza(string type)
    {
        Pizza* pizza = nullptr;
        switch(type)
        {
            case "CheesePizza":
                pizza = new CheesePizza();
                break;
            //...
        }
        //...
        return pizza;
    }
}

class PizzaStore
{
    SimplePizzaFactory factory;
public:
    PizzaStore(SimplePizzaFactory factory)
    {
        this.factory = factory;
    }

    static Pizza orderPizza(string type)
    {
        Pizza* pizza = createPizza(type);
        pizza->prepared();
        pizza->bake();
        pizza->cut();
        pizza->box();
        return pizza;
    }
}
```
심플 팩토리에서는 팩토리 클래스로 객체를 생성한다.
하지만 팩토리 클래스는 `prepared()`, `bake()`, `cut()`, `box()`와 같은 후처리 함수의 호출까지는 담당하지 않는다.
이 특징은 객체 생성 후 후처리가 필요한 경우에 문제가 될 수 있다.
후처리 함수를 호출하지 않거나, 함수의 존재를 몰라 새롭게 후처리 코드를 추가하는 일은 흔하게 발생한다.
**팩토리 메소드 패턴**은 이런 문제를 방지할 때 필요하다.

## **Factory Method Pattern**
**팩토리 메소드 패턴**은 구상 팩토리 클래스에 의존하지 않고, 객체 생성에 인터페이스를 제공하는 것이다.
아래는 이해를 돕기 위한 예제다.

```C++
class PizzaStore
{
public:
    Pizza orderPizza(String type)
    {
        Pizza* pizza = createPizza(type);
        pizza->prepared();
        pizza->bake();
        pizza->cut();
        pizza->box();
        return pizza;
    }

    virtual Pizza* createPizza(string type);
}
```

원래는 클래스의 인스턴스를 만드는 일을 `PizzaStore` 클래스에서 전부 처리하는 방식이었다면, 지금은 `PizzaStore`을 상속받는 서브클래스가 처리하는 방식으로 바뀌었다.
팩토리 클래스의 인스턴스에 의존적이었던 기존 코드에서 의존성이 제거되었다.

팩토리 메소드를 정리하자면 다음과 같다.
- 팩토리 메소드 패턴은 객체를 생성할 때 필요한 인터페이스를 만든다.
- 어떤 클래스의 인스턴스를 만들지는 서브클래스에서 결정한다
- 팩토리 메서드 패턴을 사용하면 클래스 인스턴스 생성을 서브클래스에 맡기게 된다.

## **Abstract Factory Pattern**

**추상 팩토리 패턴**은 객체의 생성 과정을 추상 팩토리 객체를 이용해 진행한다.
이 방식은 제품군을 만들 때 유용하다.
예를 들어 컴퓨터를 만드려고 한다면, OS와 모니터, 본체, 주변 기기들을 만드는
팩토리가 필요할 것이다.
OS의 팩토리는 마이크로소프트와 애플이 있을 것이고, 모니터는 LG와 삼성, 주변 기기들도 마찬가지로
다양한 팩토리를 가지고 있을 것이다.
이처럼 구상 팩토리 클래스를 구현하고, 실제로 팩토리를 사용할 때는 추상 팩토리의 인터페이스를 호출함으로서 의존성을 제거한다.

```C++
class AbstractFactory
{
public:
    virtual PartA* CreatePartA();
    virtual PartB* CreatePartB();
}

class ConcreteFactory1
{
public:
    virtual PartA* CreatePartA()
    {
        //...
    }
    
    virtual PartB* CreatePartB()
    {
        //...
    }
}

class ConcreteFactory2
{
public:
    virtual PartA* CreatePartA()
    {
        //...
    }
    
    virtual PartB* CreatePartB()
    {
        //...
    }
}
```

### 참고
- [헤드퍼스트 디자인패턴 개정판](https://www.yes24.com/Product/Goods/108192370?pid=123487&cosemkid=go16481149710577107&utm_source=google_pc&utm_medium=cpc&utm_campaign=book_pc&utm_content=ys_240530_google_pc_cc_book_pc_12203%EB%8F%84%EC%84%9C&utm_term=%ED%97%A4%EB%93%9C%ED%8D%BC%EC%8A%A4%ED%8A%B8%EB%94%94%EC%9E%90%EC%9D%B8%ED%8C%A8%ED%84%B4&gad_source=1&gclid=CjwKCAiA5Ka9BhB5EiwA1ZVtvJslHKzenw6UU2fr3tyJDb4AKzJ7X-O2jE42dZHrC54wdt-Lxu-ZWhoCjasQAvD_BwE)