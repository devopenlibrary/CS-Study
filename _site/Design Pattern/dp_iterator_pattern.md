# Iterator pattern

반복자 패턴은 반복 작업을 캡슐화하는 패턴이다.
개발을 하다보면 자료구조 안에 있는 객체에 일일이 접근해야하는 상황이 있다.
어떻게 저장했느냐에 따라 객체에 접근하는 방식이 다른데, 반복자 패턴은 객체 저장 방식을 숨기면서도 객체에 일일이 접근할 수 있게 해준다.

먼저 반복자 인터페이스를 정의한다.
```C++
template <class T>
class Iterator 
{
public:
    virtual bool hasNext();
    virtual T next();
    virtual void remove();
}
```

그 다음 구상 클래스를 만든다

```C++
class ArrayIterator : Iterator<int>
{
    int currentIndex = -1;
    vector<int> myArr;
public:
    ArrayIterator(vector<int> myArr)
    {
        this->myArr = myArr;
    }

    bool hasNext()
    {
        return currentIndex + 1 < myArr.size();
    }

    int next()
    {
        return myArr[++currentIndex];
    }

    void remove()
    {
        myArr.erase(myArr.begin() + currentIndex--);
    }
};

class StackIterator : Iterator<int>
{
    stack<int> myStack;
public:
    StackIterator(stack<int> myStack)
    {
        this->myStack = myStack;
    }

    bool hasNext()
    {
        return !myStack.empty();
    }

    int next()
    {
        int result = myStack.top();
        myStack.pop();
        return result;
    }

    void remove()
    {
        myStack.pop();
    }
};
```

이렇게 구현하고 나면 저장 방법과 데이터 타입에 구애받지 않고 반복자 패턴으로 개별 요소에 하나씩 접근할 수 있게 된다.

# 참고
- [헤드퍼스트 디자인패턴 개정판](https://www.yes24.com/Product/Goods/108192370?pid=123487&cosemkid=go16481149710577107&utm_source=google_pc&utm_medium=cpc&utm_campaign=book_pc&utm_content=ys_240530_google_pc_cc_book_pc_12203%EB%8F%84%EC%84%9C&utm_term=%ED%97%A4%EB%93%9C%ED%8D%BC%EC%8A%A4%ED%8A%B8%EB%94%94%EC%9E%90%EC%9D%B8%ED%8C%A8%ED%84%B4&gad_source=1&gclid=CjwKCAiA5Ka9BhB5EiwA1ZVtvJslHKzenw6UU2fr3tyJDb4AKzJ7X-O2jE42dZHrC54wdt-Lxu-ZWhoCjasQAvD_BwE)