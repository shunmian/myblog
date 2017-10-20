---
layout: post
title: Redux Part I：TodoList App
categories: [04 Web Development]
tags: [Redux]
number: [3.7.7]
fullview: false
shortinfo: 本文是对Rudex框架的介绍。通过一个TodoList App从零开始的构建，读者可以对Redux的主要结构有一个全面的了解。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Getting start with the redux

### 1.1 Three Principles of Reudx

1. **The entire state of the application will be represented by one JavaScrip object**. All changes and mutations to the application are explicit. These mutations, which include the data and the UI stae, are contained in a single object we call the **state**.Since the entire state is represented in a single object, we are able to keep track of changes over time.

2. **The state tree is read only and can only be modified by dispatching actions**. Any time you want to change the state, you have to dispatch an **action**. An action is a plain JS object describing the change. Just like the state is the minimal represenation of the data, the action is the minimal representation of the change to that data.The only requirement for an action is that it has a type property (conventionally a String).For example, in a counter app, there are `INCREMENT` and `DECREMENT` actions. In the case of a ToDo app, the display components don't know how an item was added to the list--all they know is that an `ADD_TODO` action was dispatched, with `text` content "hey" and a sequential `id`.

3. **To describe state mutations you have to write a function that takes the previous state of the app and the action being dispatched, then returns the next state of the app. This function is called the `Reducer`**. React introduced the idea that the UI layer is most predictable when it is described as a pure function of the application's state.Redux complements this approach by requiring that state mutations in your app need to be described by a pure function that takes the previous state and the action being dispatched, and returns the next state of your application.**Inside a Redux application there is one particular function that takes the previous state and the action deing dispatched, and returns the next state of the whole application**. It is important that the function is pure(i.e. the state being given to it isn't modified) because it has to return the new object representing the application's new state.Even in large applications, there is still just a single function that calculates the new state of the application. It doesn't have to be slow--if certain parts of the state haven't changed, their references can stay as-is. In the Todo app example, when changing the visibility between "All/Component/Active" the actual items themselves haven't changed, so the reference to the previous version of the `todos` array is left intact.


### 1.2 Reducer and Store

#### 1.2.1 Writing a Counter Reducer with Tests

The first function we will write is the reducer for the counter example. We will also use the `expect library` to make assertions.

{% highlight js linenos %}
function counter(state, action) {
  if (typeof state === 'undefined') {
    return 0; // If state is undefined, return the initial application state
  }

  if (action.type === 'INCREMENT') {
    return state + 1;
  } else if (action.type === 'DECREMENT') {
    return state - 1;
  } else {
    return state; // In case an action is passed in we don't understand
  }
}

expect (
  counter(0, { type: 'INCREMENT' })
).toEqual(1);

expect (
  counter(1, { type: 'INCREMENT' })
).toEqual(2);

expect (
  counter(2, { type: 'DECREMENT' })
).toEqual(1);

expect (
  counter(1, { type: 'DECREMENT' })
).toEqual(0);

expect (
    counter(1, { type: 'SOMETHING_ELSE' })
).toEqual(1);
{% endhighlight %}

When writing a reducer, if `state` is not defined, return an object representing the initial state. In this counter example, we return `0` since our count will start from there. If the `action` being passed in isn't one the reducer recognizes, we just return the current `state`.

The above code can be rewrittern more consisely using ES6 arrow notation and a switch statement:

{% highlight js linenos %}
const counter = (state = 0, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}
// ... `expect` statements as above ...
{% endhighlight %}

#### 1.2.2 Store Methods:`getState()`,`dispatch()`,and `subscribe()`

This section make uses of functions built int Redux. We bring in `createStore` in redux framework using the ES6 destructuring syntax.

{% highlight js linenos %}
const counter = (state = 0, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}

const { createStore } = Redux; // Redux CDN import syntax
// import { createStore } from 'redux' // npm module syntax

const store = createStore(counter);
{% endhighlight %}
    
The store binds together the 3 principles of Redux:
1. Holdes one single state for the whole application;

2. The state is read-only;

3. When you create it, you need to specify the reducer that tells how state is updated with actions.

In this example,we call `createStore` with `counter` as the reducer that manages the `state` updates.

**`store` has 3 important methods:**

{% highlight js linenos %}
// ... `counter` reducer as above ...

const { createStore } = Redux;
const store = createStore(counter);

store.subscribe(() => {
  document.body.innerText = store.getState();
});

document.addEventListener('click', () => {
    store.dispatch({ type : 'INCREMENT' })
});`
{% endhighlight %}

1. `getState()` retrieves the current state of the Redux store. If we ran `console.log(store.getState())` with the code above, we could get `0` since it is the initial state of our application.

2. `dispatch()` is the most commonly used. It is how we dispatch actions to change the state of the application. If we run `store.dispatch({type:'INCREMENT'});` we will get `1` at first.

3. `subscribe()` registers a callback that the redux store will call any time an action has been dispatched so you can update the UI of your application to reflext the current application state.


### 1.3 Implementating Store From Scratch

We just used the `creatStore()` function, but in order to understand it better, let's write it from scratch!

We know that we need to pass in the `reducer` function, and that `getState()` will return the current value of `state`. We also know that we need to be able to dispatch actions and subscribe.

Because the `subscribe()` function can be called many times, we need to keep track of all the change listeners, so we create an array (listeners), when called, will push in the new ilstener to the array.

Dispatching an action is the only way to change the internal state, so we calculate the new state as the result of calling `reducer()` with the current `state` and the `action` being dispatched. After the `state` is updated, we notify every change listener by calling them.

In order to unsubscribe an event listener, we'll return a function from the `subscribe()` method that removes the listener from the listeners array.

By the time the store is returned, we want the initial state to be populated. We are going to dispatch a dummy action just to get the reducer to return the initial value.
{% highlight js linenos %}
const createStore = (reducer) => {
  let state;
  let listeners = [];

  const getState = () => state;

  const dispatch = (action) => {
    state = reducer(state, action);
    listeners.forEach(listener => listener());
  };

  const subscribe = (listener) => {
    listeners.push(listener);
    return () => {
      listeners = listeners.filter(l => l !== listener);
    }
  };

  dispatch({}); // dummy dispatch

  return { getState, dispatch, subscribe };

};
{% endhighlight %}

### 1.4 React Counter Example
略。
### 1.5 Avoiding Array Mutations

Note: This code uses Expect and Deep-Freeze libraries for testing and mutation checking respectively.

Say we want to implement a counter list application. We will need to write a few functions to operate on its state, which is an array of numbers representing the individual counters.

{% highlight js linenos %}
const addCounter = (list) => {
  list.push(0);
  return list;
};

const testAddCounter = () => {
  const listBefore = [];
  const listAfter = [0];

  deepFreeze(listBefore);

  expect(
    addCounter(listBefore)
  ).toEqual(listAfter);
};

testAddCounter();
console.log('All tests passed')
{% endhighlight %}

As this code stands now, the test fails because we can't push 0 onto a frozen object.

Instead, we need to use concat, because it doesn't modify the original object:

{% highlight js linenos %}
const addCounter = (list) => {
  // return list.concat([0]); // old way
  return [...list, 0]; // ES6 way
};

In this application we also want to be able to remove counters:

const removeCounter = (list, index) => {
  list.splice(index, 1);
  return list;
}
.
.
.
const testRemoveCounter = () => {
  const listBefore = [0, 10, 20];
  const listAfter = [0, 20];

  expect (
    removeCounter(listBefore, 1)
  ).toEqual(listAfter);
};
{% endhighlight %}

This works, but `splice` is also a mutating method. We need to use `slice` instead:

{% highlight js linenos %}
const removeCounter = (list, index) => {
  // Old way:
  //return list
  //  .slice(0, index)
  //  .concat(list.slice(index + 1));

  // ES6 way:
  return [
    ...list.slice(0, index),
    ...list.slice(index + 1)
  ];
};
{% endhighlight %}
    
Now let's implement incrementing the counter. The function will take in the array and the index of the counter that we are incrementing.

{% highlight js linenos %}
const incrementCounter = (list, index) => {
  list[index]++;
  return list;
};

const testIncrementCounter = () => {
  const listBefore = [0, 10, 20];
  const listAfter = [0, 11, 20];

  deepFreeze(listBefore);

  expect(
    incrementCounter(listBefore, 1)
  ).toEqual(listAfter);
};
{% endhighlight %}

This fails because we are mutating. The correct approach is similar to how we removed an item-- we will slice up to the item we want to increment, concat with a single item that we have incremented, then concat the rest of the original array.

{% highlight js linenos %}
const incrementCounter = (list, index) => {
  // Old way:
  // return list
  //  .slice(0, index)
  //  .concat([list[index] + 1])
  //  .concat(list.slice(index + 1));

  // ES6 way:
  return [
    ...list.slice(0, index),
    list[index] + 1,
    ...list.slice(index + 1)
  ];
};
{% endhighlight %}

### 1.6 Avoiding Object Mutations

Like the previous example, this code uses the Expect and DeepFreeze libraries.

We are going to test a function `toggleTodo()` that takes a Todo item and toggles its "completed" field.

{% highlight js linenos %}
const toggleTodo = (todo) => {
  // Mutated version:
  todo.completed = !todo.completed
  return todo;
}

const testToggleTodo = () => {
  const todoBefore = {
    id: 0,
    text: 'Learn Redux',
    completed: false
  };
  const todoAfter = {
    id: 0,
    text: 'Learn Redux',
    completed: true
  };

  deepFreeze(todoBefore);

  expect(
    toggleTodo(todoBefore)
  ).toEqual(todoAfter);
};

testToggleTodo();
console.log('All tests passed.');
{% endhighlight %}

One way to do this without mutation is to copy the object with the "completed" value flipped:

{% highlight js linenos %}
const toggleTodo = (todo) => {
  return {
      id: todo.id,
      text: todo.text,
      completed: !todo.completed
  };
}
{% endhighlight %}


However, if we add new properties later, we may forget to update this piece of code. This is why we should use ES6's `Object.assign()`. This lets you assign properties of several objects onto the target object.

{% highlight js linenos %}
const toggleTodo = (todo) => {
  return Object.assign({}, todo, {
    completed: !todo.completed
  });
};

{% endhighlight %}

Note how the argument order to `Object.assign()` corresponds to the JavaScript assignment operator order.

The left argument is the one whose properties are going to be assigned, so we pass in an empty object(`{}`) because it will be mutated (remember, we don't want to mutate any existing data).

Every further argument to `Object.assign()` is considered a source object whose properties will be copied to the target (in this case, the target is our blank object provided as the first argument).

If there are multiple occurrences of the same property/properties, the last occurrence "wins". In this case, the `{completed:!todo.completed}` we specify in the thrid overwrites the `completed` contained within the `todo` in the second argument.

Another option todo the same thing is with the `spread` operator proposed for ES7:

{% highlight js linenos %}
const toggleTodo = (todo) => {
  return {
    ...todo,
      completed: !todo.completed
  };
};
{% endhighlight %}

### 1.7 Writing a Todo List Reducer

#### 1.7.1 Writing a Todo List Reducer (Adding a Todo)

We are again using DeepFreeze and Expect.

In this section we are going to write a reducer for our Todo List application.

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        {
          id: action.id,
          text: action.text,
          completed: false
        }
      ];
    default:
      return state;
  }
};

const testAddTodo = () => {
  const stateBefore = [];
  const action = {
      type: 'ADD_TODO',
      id: 0,
      text: 'Learn Redux'
  };
  const stateAfter = [{
      id: 0,
      text: 'Learn Redux',
      completed: false
  }];

  deepFreeze(stateBefore);
  deepFreeze(action);

  expect(
    todos(stateBefore, action)
  ).toEqual(stateAfter);
};

testAddTodo();
console.log('All tests passed')
{% endhighlight %}

**Data Flow:**

First, we create an empty state array (`stateBefore`) and our `action` object inside the test fucntion. Next they are passed into our `todos` reducer function, which notices that our action type of `ADD_TODO` is recognized. The reducer returns a new array containing the same items as the old array, as well as a new item representing the Todo we just added. Note that since we passed in an empty array (`stateBefore=[]`) we are returned a single item array. Finally, our new array is compared with our expected array with our single Todo item.




#### 1.7.2 Writing a Todo List Reducer (Toggling a Todo)

Now we will handle toggling Todos by adding to our above code.

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      // ... ADD_TODO logic as above
    case 'TOGGLE_TODO':
      return state.map(todo => {
        if (todo.id !== action.id) {
          return todo;
        } else {
// for the todo that matches the action id return all other information the same
// but change the completed property to the opposite of what it was previously
          return {
            ...todo,
            completed: !todo.completed
          };
        }
      });
    default:
      return state;
  }
};

const testToggleTodo = () => {
  const stateBefore = [
    {
      id: 0,
      text: 'Learn Redux',
      completed: false
    },
    {
      id: 1,
      text: 'Go Shopping',
      completed: false
    }
  ];
  const action = {
      type: 'TOGGLE_TODO',
      id: 1
  };

  const stateAfter = [
    {
      id: 0,
      text: 'Learn Redux',
      completed: false
    },
    {
      id: 1,
      text: 'Go Shopping',
      completed: true
    }
  ];

  deepFreeze(stateBefore);
  deepFreeze(action);

  expect(
    todos(stateBefore, action)
  ).toEqual(stateAfter);
};

testAddTodo();
testToggleTodo();
console.log('All tests passed.');
{% endhighlight %}

Note that inside our `TOGGLE_TODO` reducer that we return the existing todo item if the `id` doesn't match the `id` of the todo we are toggling. If the `id` does match, we use the spread operator to return a new object with all the properties of the existing `todo` object, along with an inverted `completed` value.


### 1.8 Reducer Composition 

#### 1.8.1 with Array 

We left off with code for a `todos` reducer.

The code is somewhat difficult to read because it mixes 2 different concerns:updating the todos array, as well as updating an individual todo item:

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        {
          id: action.id,
          text: action.text,
          completed: false
        }
      ];
    case 'TOGGLE_TODO':
      return state.map(todo => {
        if (todo.id !== action.id) {
          return todo;
        }

        return {
          ...todo,
          completed: !todo.completed
        };
      });
  }
}
{% endhighlight %}
    
Every time a function does too many things, it's best to break them up into other functions that each address only one concern.

In this case "creating and updating a todo" is a separate task to undertake, so we'll bring this code into a new funciton that has two arguments: the current state, and the aciton being dispatched.

**Note that in this new funcitons that `state` referes to the individual todo, and not the list of  todos**

{% highlight js linenos %}
const todo = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        id: action.id,
        text: action.text,
        completed: false
      };
    case 'TOGGLE_TODO':
      if (state.id !== action.id) {
        return state;
      }

      return {
        ...state,
        completed: !state.completed
      };
    default:
      return state;
  }
}
{% endhighlight %}

Now that we've extracted our `todos` reducer, we have to call it for every todo item and assemble the results into an array:

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        todo(undefined, action)
      ];
    case 'TOGGLE_TODO':
      return state.map(t => todo(t, action));
    default:
      return state;
  }
};
{% endhighlight %}

Remember to have a `default` case where `state` is returned to avoid odd bugs in the future.

What we've just done is a common Redux practice called **reducer composition**. Different reducers specify how different aprts of the state tree are updated in response to actions. Since reducers are normal JS functions, they can call other reducers to delegate & abstract away updates to the state.

Reducer composition can be applied many times. While there's a single top-level reducer managing the overall state of the app, it's encouraged to have reducers call each other as needed to manage the state tree.

#### 1.8.2 with Object
In the last section, we used reducer composition to manage Todos in an array. While storing the application's state with just an array may work for small applications, we can use objects to store more information.

For example, we can add a visibility filter to our Todo application. The state of the visibility filter is a simple string representing the current filter. The filter is changed via the `SET_VISIBILITY_FILTER` action.

{% highlight js linenos %}
const visibilityFilter = (
    state = 'SHOW_ALL',
    action
) => {
    switch (action.type) {
      case 'SET_VISIBILITY_FILTER':
        return action.filter;
      default:
        return state;
    }
};
{% endhighlight %}
    
**To store this new information, we don't need to change the existing reducers.** We will use reducer composition to create a new reducer that calls existing reducers to manage their parts of the state, then combine the parts into single state object.

{% highlight js linenos %}
const todoApp = (state = {}, action) => {
  return {
     // Call the `todos()` reducer from last section
     todos: todos(
      state.todos,
      action
    ),
    visibilityFilter: visibilityFilter(
      state.visibilityFilter,
      action
    )
  };
};
{% endhighlight %}

Note that the first time it runs, it will pass undefined as the state the child reducers because the initial state of the combined reducer is an empty object, so all its fields are undefined. Remember that when we call reducers with `undefined` that they return their initial states, thus populating the `state` for the first time.

When an action comes in, it calls the reducers with the parts of the state that they manage & the aciton then combines the results into the new `state` object.

Now that we have composed this new `todoApp` reducer, we will use it to create he store:

{% highlight js linenos %}
// You've already imported Redux earlier in the app...
const store = createStore(todoApp);
{% endhighlight %}
    
This pattern helps to scale Redux development, since different team members can work on different reducers that work with the same actions, without stepping on each other's toes.

#### 1.8.3 with Combination

Since reducer composition is so common in Redux, there's a helper function `combineReducers()`, so now instead of this:

{% highlight js linenos %}
const todoApp = (state = {}, action) => {
  return {
     todos: todos(
      state.todos,
      action
    ),
    visibilityFilter: visibilityFilter(
      state.visibilityFilter,
      action
    )
  };
};
{% endhighlight %}

We can do this:

{% highlight js linenos %}
const { combineReducers } = Redux; // CDN Redux import

const todoApp = combineReducers({
  todos: todos,
  visibilityFilter: visibilityFilter
});
{% endhighlight %}
    
This code generates our top level reducer. The only argument to `combineReducers()` is an object that specifies the mapping between the state field names and the reducers that manage them.

The return value of `combineReducers()` is a reducer function that is pretty much equivalent to what we wrote ealier. **By convention, the state keys should be named after the reducers that manage them**. Because of this, we can use ES6 object literal shorthand notation to accomplish the same thing like this:

{% highlight js linenos %}
const todoApp = combineReducers({
  todos,
  visibilityFilter
});
{% endhighlight %}

### 1.9 Implementing combineReducers From Scratch

Now that we know how to use `combineReducers()` to save us some time, let's implement it from scratch in order to understand it deeper. Recall that the only argument to `combineReducers()` is a function declaration to map through our reducers, so we'll start by writing a function that accepts a parameter we'll call "reducers". Since `combineReducers()` returns a reducer function, it must have the signature of a reducer function(the state and an action). Inside of our return reducer, we call the `Object.keys()` function to get all the keys from our `reducers` object (in our example, this is `todos` and `visibilityFilter`). We then run `reduce()` on the keys because we want to produce a single value that represents the next state. We do this by accumulating over every key and running its associated reducer. Since each reducer that is run through `combineReducers()` is responsible for only part of the application's overall state, we say that the next state for a given key can be calculated by calling the corresponding reducer for the given key with the current state (for the given key) & the action. The array reduce wants us to return the next accumulated value from the callback (i.e. `nextState`). We also specify an empty object as the initial next state before all the keys are processed.

{% highlight js linenos %}
const combineReducers = reducers => {
  return (state = {}, action) => {

    // Reduce all the keys for reducers from `todos` and `visibilityFilter`
    return Object.keys(reducers).reduce(
      (nextState, key) => {
        // Call the corresponding reducer function for a given key
        nextState[key] = reducers[key] (
          state[key],
          action
        );
        return nextState;
      },
      {} // The `reduce` on our keys gradually fills this empty object until it is returned.
    );
  };
};
{% endhighlight %}
    
Call combineReducers with an object whose values are the reducer functions and keys are state fields they manage.

{% highlight js linenos %}
const todoApp = combineReducers({
  todos,
  visibilityFilter
});
{% endhighlight %}

It's okay that we are mutating the empty object representing `nextState`, because it was created within the `combienReducers()` function and not passed in from the outside. Thus, our funciton remains pure.

It's important to understand functional programming -- functions can take other functions as arguments and return other functions. Knowing this will increase productivity with Redux in the long term.


## 2 Todo List Example: Basics



### 2.1 React Todo List Example 

#### 2.1.1 Adding a Todo

Now that we are managing our store and our actions, let's implement a view layer using React.

{% highlight js linenos %}
Existing code:
const todo = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        id: action.id,
        text: action.text,
        completed: false
      };
    case 'TOGGLE_TODO':
      if (state.id !== action.id) {
        return state;
      }

      return {
        ...state,
          completed: !state.completed
      };
    default:
      return state;
  }
};

const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        todo(undefined, action)
      ];
    case 'TOGGLE_TODO':
      return state.map(t =>
        todo(t, action)
      );
    default:
      return state;
  }
};

const visibilityFilter = (
  state = 'SHOW_ALL',
  action
) => {
  switch (action.type) {
    case 'SET_VISIBILITY_FILTER':
      return action.filter;
    default:
      return state;
  }
};

const { combineReducers } = Redux;
const todoApp = combineReducers({
  todos,
  visibilityFilter
});

const { createStore } = Redux;
const store = createStore(todoApp);
{% endhighlight %}

Hopefully you already know a bit about React, JSX, props, etc.

**React-specific JS**

{% highlight js linenos %}
const { Component } = React;

let nextTodoId = 0;
class TodoApp extends Component {
  render() {
    return (
      <div>
        <button onClick={() => {
            store.dispatch({
              type: 'ADD_TODO',
              text: 'Test',
              id: nextTodoId++
            });
          }}>
          Add Todo
        </button>
        <ul>
          {this.props.todos.map(todo =>
            <li key={todo.id}>
              {todo.text}
            </li>
          )}
        </ul>
      </div>
    )
  };
}

// See Section 8 for earlier `render()` example
const render = () => {
  ReactDOM.render(
    // Render the TodoApp Component to the <div> with id 'root'
    <TodoApp
      todos={store.getState().todos}
    />,
    document.getElementById('root')

  )
};

store.subscribe(render);
render();
HTML:
<!DOCTYPE html>
<html>
<head><!-- ... CDN imports for Redux and React ... --></head>

<body>
  <!-- This is where our React application will be rendered -->
  <div id='root'></div>
</body>
</html>
{% endhighlight %}

**Recap of how the application works:**

We start with the `todoApp` component. This component isn't aware of how todos are being added, but what it can do is express its desire to mutate the state by dispatching an action with a type of `ADD_TODO`. The `text` field for the todo item to be added is taken fromt he input box, along with an incrementing `id` for the todo item's id. It is common for React components to dispatch actions in Redux apps, however it's equally important to be able to render the current state. The `TodoApp` component assumes that it will receive `todos` as a prop, and it maps the items to display a list, using the `id` as a key(see the `<ul>` seciton in `TodoApp`).

We render the `TodoApp` component inside the `render()` function that runs any time the state changes (as well as when the app is initilized). The `render()` function reads the current state of the store and passes the array of todos to the TodoApp component as a prop via the line `<TodoApp todos={store.getState().todos} />`. The `render()` function is called every time there is a change to the store, so the `todos` prop is always up to date.

**Recap of how mutations work in Redux**:

Any change to state is cuased by a `store.dispatch()` call somewhere in the component. When an action is dispatched, the `store` calls the reducer it was created with the current state & the action being dispatched. In the case of this example, this is the `todoApp` reducer that we obtained by `const todoApp = combineReducers({todos,visibilityFilter})`.

Continuing with our example, the `ADD_TODO` action type is matched in the wsitch statement inside the `todos()` reducer, so the child `todo()` reducer is called. The `todo()` child reducer is passed `undefined`(because there is no `state` for a new todo) and the action `ADD_TODO`. Inside of the `todo()` child reducer, we have a similar switch statement. Since `ADD_TODO` is matched, the reducer returns the initial state of the todo item (the `id` from `nextTodoId++` and `text` from the input box inside the `TodoApp` component, along with `completed: false`).

The `todos()` reducer that just called the child `todo()` reducer will then return a new array built from the existing items along with the newly created item added to the end (remember, this array is built using ES6's `...` spread operator).

Now our combined reducer `todoApp` will use this new todos array as the new value for the `todos` field in the global state object. So, it's going to return a new `state` object where the `todos` field corresponds to the array with the newly added todo item.

The `todoApp` reducer is the `root reducer` in this application. It is the one the store was created with, so its next state is the next state of the Redux store, and all the listeners are notified.

The `render()` funciton is subscribed to the store's change, so it is called again and gets the fresh state with `store.getState()` and passes the udpated `todos` as a prop to the `TodoApp` component.

Now the cycle can be repeated.

#### 2.1.2 Toggling a Todo

Bulding onto what we've been working on, it's time to dispatch our `TOGGLE_TODO` action. We will do this by clicking on the individual todo items in our bulleted list.

Inside of our `TodoApp` component, we map each of the todo items into an `<li>`. We add a click handler so that when a user clicks on an item, we will dispatch an action to the store of type `TOGGLE_TODO` along with the `id` to be toggled (we get the `id` from the `todo` object.)

In the UI, we want the todo item to appear as crossed out if it has been completed, so we'll use the `textDecoration` style property.

{% highlight js linenos %}
.
. // TodoApp component stuff
.
<ul>
  {this.props.todos.map(todo =>
    <li key={todo.id}
        onClick={() => {
          store.dispatch({
            type: 'TOGGLE_TODO',
            id: todo.id
          });
        }}
        style={{
          textDecoration:
            todo.completed ?
              'line-through' :
              'none'
        }}>
      {todo.text}
    </li>
  )}
</ul>
.
. // More TodoApp component stuff
.
{% endhighlight %}


**Recap of how toggling a todo item works**

Inside the click handler, we dispatch the `TOGGLE_TODO` and the `id` of the todo being rendered. When an action is dispatched, the store will call the root reducer, which will call the `todos()` reducer with the array of todos & the action. Since this action is of type `TOGGLE_TODO`, the `todos()` reducer delegates the handling of every todo item to the `todo()` reducer by using the `map()` funciton to call it for every todo item in `state`:

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    // case 'ADD_TODO' stuff
    case 'TOGGLE_TODO':
      return state.map(t =>
        todo(t, action)
      );
    // default case stuff
  }
}
{% endhighlight %}

The `todo{}` reducer receives the todo item as `state`, and 'TOGGLE_TODO' as `action`. For every todo item whose `id` doesn't match the `id` in the action (remember the action's `id` was supplied by clicking the `<li>`), we just return the previous state (i.e. the `todo` object as it was).

However, if the `id` of the todo matches the `id` of the action, we'll use ES6 notation to return a new object with all the properteis of the original todo, but with the `completed` field toggled.

{% highlight js linenos %}
const todo = (state, action) => {
  // case 'ADD_TODO' stuff
  case 'TOGGLE_TODO':
    if (state.id !== action.id) {
      return state;
    }

    return {
      ...state,
      completed: !state.completed
    };
  // default case stuff
};
{% endhighlight %}

The updated todo item will be included in the `todos` field under the new application `state`, and because we subscribe to the `render()` funciton, it's going to get the next state of the application via `store.getState()` and pass the new version of the the `todos` array to the `TodoApp` component to be mapped and rendered as a bulleted list (where completed items have a line through them).

{% highlight js linenos %}
const render = () => {
  ReactDOM.render(
    <TodoApp
      todos={store.getState().todos}
    />,
    document.getElementById('root')
  );
};

store.subscribe(render);
render();
{% endhighlight %}

Thus, our cycle is complete again.



#### 2.1.3 Filtering Todos

We've created a user interface for our Todo list that lets us add and toggle todo items. Now we will implement the visibility filter to show only the items that the user wants to see. We will start by creating a new `FilterLink` component that the user will click to switch the current visible items. This component accepts the `filter` prop (just a string) & `children` (the contents of the link). THe component will be a simple `<a>` tag that when clicked will dispatch an aciton of type `'SET_VISIBILITY_FILTER'` along with a fitler prop so the reducer knows which filter is being clicked.

We pass the `children` down to the `<a>` tag so the text of the link can be specified.

{% highlight js linenos %}
.
. // Reducer code, etc.
.
const FilterLink = ({
  filter,
  children
}) => {
  return (
    <a href='#'
       onClick={e => {
         e.preventDefault();
         store.dispatch({
           type: 'SET_VISIBILITY_FILTER',
           filter
         });
       }}
    >
      {children}
    </a>
  )
}
.
.
.
{% endhighlight %}

Now that we have created `FilterLink`, we can use it in our `TodoApp` component:

{% highlight js linenos %}
.
. // TodoApp component stuff including the the <ul> of todo items...
. // This <p> tag is to be rendered below the list.
<p>
  Show:
  {' '}
  <FilterLink
    filter='SHOW_ALL'
  >
    All
  </FilterLink>
  {' '}
  <FilterLink
    filter='SHOW_ACTIVE'
  >
    Active
  </FilterLink>
  {' '}
  <FilterLink
    filter='SHOW_COMPLETED'
  >
    Completed
  </FilterLink>
</p>
.
. // close the containing `<div>` and the TodoComponent
.
{% endhighlight %}

Now we've got some links to select the filter, but they don't have a visible effect yet because we don't interpret the value of the visibility filter. We need to create a `getVisibleTodos()` function that will help us filter the todos according to the filter value. `getVisibleTodos()` will take two arguments: the list of `todos` and the `filter`. Inside will be a switch statement that operates based on the current filter value.

{% highlight js linenos %}
.
. // FilterLink component creation
.

const getVisibleTodos = (
  todos,
  filter
) => {
  switch (filter) {
    case 'SHOW_ALL':
      return todos;
    case 'SHOW_COMPLETED':
      // Use the `Array.filter()` method
      return todos.filter(
        t => t.completed
      );
    case 'SHOW_ACTIVE':
      return todos.filter(
        t => !t.completed
      );
  }
}
{% endhighlight %}


Now we need to call `getVisibleTodos()` from our `TodoApp` component before we render the list. Inside the `render()` function fo the `TodoApp` compnent, we get the visible todos by calling `getVisibleTodos()` with the list of `todos` and the `visibilityFitler` from our props. We will now use `visibleTodos` instead of `this.props.todos` when rendering our list.

{% highlight js linenos %}
.
.
.
class TodoApp extends Component {
  render() {
    const visibleTodos = getVisibleTodos(
      this.props.todos,
      this.props.visibilityFilter
    );
    .
    . // Input and Button stuff
    .
    <ul>
      {visibleTodos.map(todo =>
        .
        . // `<li>` click handling and item rendering
        .
      )}
    </ul>
    .
    . // `<p>` filter selection stuff
    .
  }
}
{% endhighlight %}
    
In order to use the `visibilityFilter` inside of our `TodoApp` component, we must pass it as a prop inside of our `render()` function. We could do this explicitly, but it's faster to spread over all of the straight fields inside the `state` object and pass all of them as props to the `TodoApp` component.

{% highlight js linenos %}
const render = () => {
  ReactDOM.render(
    <TodoApp
      {...store.getState()}
    />,
    document.getElementById('root')
  );
};

store.subscribe(render);
render();
{% endhighlight %}

Now when we add some todo items and then "complete" them, we can show the list according to our selected visibility filter.

However, it would be nice to differentiate between our filter links by showing which one we have selected.

We'll start by using ES6 destructuring inside of the `TodoApp` component to extract `todos` and `visibilityFilter` from the props. Now we can access them directly instead of having to type "`this.props.`" every time.

{% highlight js linenos %}
class TodoApp extends Component {
  render() {
    const {
      todos,
      visibilityFilter
    } = this.props;
    const visibleTodos = getVisibleTodos(
      todos,
      visibilityFilter
    );
    return (
     .
     . // input, button, and list stuff
     .
{% endhighlight %}

Now we'll include the current `visibilityFilter` with our `FilterLink`s so it can know which is the current one and apply different styles accordingly.

{% highlight js linenos %}
<p>
  Show:
  {' '}
  <FilterLink
    filter='SHOW_ALL'
    currentFilter={visibilityFilter}
  >
    All
  </FilterLink>
  {' '}
  <FilterLink
    filter='SHOW_ACTIVE'
    currentFilter={visibilityFilter}
  >
    Active
  </FilterLink>
  {' '}
  <FilterLink
    filter='SHOW_COMPLETED'
    currentFilter={visibilityFilter}
  >
    Completed
  </FilterLink>
</p>
{% endhighlight %}

Now that we've included the `visibilityFilter`, we go back to our `FilterLink` declaration to add `currentFitler` as a prop along with a condition that says when the filter is the current filter, it will become static text.

{% highlight js linenos %}
    const FilterLink = ({
      filter,
      currentFilter,
      children
    }) => {
      if (filter === currentFilter) {
        return <span>{children}</span>
      }
      .
      . // rest of `FilterLink` as defined earlier
      .
    }
{% endhighlight %}

**To review how changing a visibility filter works...**

Clicking one of the filter types dispatches an action of type `SET_VISIBILITY_FILTER` and passes `filter` which is a prop to the `FilterLink` component (every one of the 3 links will have a different `filter` prop). The `store.dispatch()` function calls our `todoApp()` root reducer with the state and the aciton, which in turn calls the `visibilityFitler()` reducer with the part of the state and the aciton. Note that when the action is of type`'SET_VISIBILITY_FILTER'`, it doesn't care about the previous state. It just returns `action.filter` as the next state of the `visibilityFitler()` reducer. The root reducer will use this new field as part of its new `state` object.

Because the `render()` function is subscribed to changes in `store`, it's going to get the new `state` object and pass all its keys as props to the `TodoApp` component.

The `TodoApp` component receives all the `todos` as well as the newly updated `visibilifyFilter` as its props, which are then passed to the `getVisibilityTodos()` function. The currently visible `todos` are calculated based on the current visibility filter (`'SHOW_ALL'`,`'SHOW_COMPLETED'`,or`'SHOW_ACTIVE'`). Depending on which filter is selected, `getVisibleTodos()` may return a brand new array of `todos` containing only the appropriate items. This returned array is then enumerated and rendered insidie of `TodoApp`'s `render()` function. The `visibilityFilter` field is also used by the `FilterLinks` as the `currentFilter` because the `FilterLink` wants to know if its filter is the current one so it can render the style appropriately (i.e. the current filter is active, so the user shouldn't be able to click it).
...thus the cycle is complete. 


### 2.2 Extracting Presentational Components

#### 2.2.1 Todo, Todolist

We have a working example of our app now, but our `TodoApp` component has the input, button, list of todos, and filter links all inside of it. We are going to refactor this single component into separate pieces so that they can be tested and worked on individually from one another.

**Current `TodoApp` Component Code:**

{% highlight js linenos %}
class TodoApp extends Component {
  render () {
    const {
      todos,
      visibilityFilter
    } = this.props;

    const visibleTodos = getVisibleTodos(
      todos,
      visibilityFilter
    );

    return (
      <div>
        <input ref={node => {
          this.input = node;
        }} />
        <button onClick={() => {
          store.dispatch({
            type: 'ADD_TODO',
            text: this.input.value,
            id: nextTodoId++
          });
          this.input.value = '';
        }}>
          Add Todo
        </button>
        <ul>
          {visibleTodos.map(todo =>
              <li key={todo.id}
                  onClick={() => {
                    store.dispatch({
                      type: 'TOGGLE_TODO',
                      id: todo.id
                    });
                  }}
                  style={{
                    textDecoration:
                      todo.completed ?
                        'line-through' :
                        'none'
                  }}
              >
                {todo.text}
              </li>
          )}
        </ul>
        <p>
          Show:
          {' '}
          <FilterLink
            filter="SHOW_ALL"
            currentFilter={visibilityFilter}
          >
            All
          </FilterLink>
          {', '}
          <FilterLink
            filter='SHOW_ACTIVE'
            currentFilter={visibilityFilter}
          >
            Active
          </FilterLink>
          {', '}
          <FilterLink
            filter='SHOW_COMPLETED'
            currentFilter={visibilityFilter}
          >
            Completed
          </FilterLink>
        </p>
      </div>
    );
  }
}
{% endhighlight %}


**Refactoring for a Single Todo Item**
First, we will extract the Todo component that renders a single list item. We will declare the Todo item as a funciton, which is available in React 14. We can remove the `key` property, since it's only neede when we enumerate an array (we'll use it later when we have to enumerate many todos).

Previously we had hardcoded a click handler that dispatched`'TOGGLE_TODO'`. It's best practice with React to have several components that don't specify any behaviors, and only are concerned with how things are rendered (how they look). These are called `presentational components`.

Because we want our list to be a presentational component, we "promote" the `onClick` handler to become a prop. 

We also want to be more explicit about what the data is that the component needs to render. Instead of passing a `todo` object, we will pass `completed` and `text` fields as separate props.

{% highlight js linenos %}
const Todo = ({
  onClick,
  completed,
  text
}) => (
  <li
    onClick={onClick}
    style={{
      textDecoration:
        completed ?
          'line-through' :
          'none'
    }}
  >
    {text}
  </li>
);
{% endhighlight %}

Now our `Todo` component is purely presentational. It doesn't specify any behavior, but it knows how to render a single todo item.

**Refactoring for the Todo List**

The `TodoList` component will accept an array of todos, and will render them into a `<ul>` by using the `todos.map()` function to render a `Todo` component for each todo item.

We tell React to use each todo's id as the unique `key` for the elements, and we'll use the pread operator to send the `todo` object's `text` and `completed` properteis are sent as props to the `Todo` component. We need to specify what happens when a `Todo` is clicked. Since we want to keep this as a presentational component, instead of dispatching an action, we'll specify a function `onTodoClick()` and pass it `todo.id` so it can decide what needs to happen. We will also pass `onTodoClick` as a prop to the `Todo` component.

{% highlight js linenos %}
const TodoList = ({
  todos,
  onTodoClick
}) => (
  <ul>
    {todos.map(todo =>
      <Todo
        key={todo.id}
        {...todo}
        onClick={() => onTodoClick(todo.id)}
      />
    )}
  </ul>
)
{% endhighlight %}

**Comtainer Components (TodoApp)**

While presentational components just display data, we need a way to actually pass data from the store. This is where container components come in-- they can specify behavior and pass data.

In our exmapke, `TodoApp` is our container component.

Now that we've created `todoList` and `Todo` presentational components, we can put them into our `TodoApp` container component.

Our `TodoApp` will render our `TodoList` with `visibleTodos` as the `todos`, along with a callback that says when `onTodoClick` is called with a todo `id`, we should dispatch an action ont he store of type `TOGGLE_TODO` along with the `id` of the todo.

{% highlight js linenos %}
class TodoApp extends Component {
    render () {
    const {
      todos,
      visibilityFilter
    } = this.props;

    const visibleTodos = getVisibleTodos(
      todos,
      visibilityFilter
    );

    return (
      <div>
        <input ref={node => {
          this.input = node;
        }} />
        <button onClick={() => {
          store.dispatch({
            type: 'ADD_TODO',
            text: this.input.value,
            id: nextTodoId++
          });
          this.input.value = '';
        }}>
          Add Todo
        </button>
        <TodoList
          todos={visibleTodos}
          onTodoClick={id =>
            store.dispatch({
              type: 'TOGGLE_TODO',
              id
            })
          } />
      .
      . // FilterLink stuff
      .
      </div>
    );
  }
}
{% endhighlight %}
    
**To Recap...**
The `TodoApp` component renders a `TodoList` and passes it a function that can dispatch an action. The `TodoList Component` renders the `Todo` component and passes an `onClick` prop which calls `onTodoClick()`. The `Todo` component uses the `onClick` prop it receives and binds it to the list item's `onClick`. This way when it's called, the `onTodoClick()` is called, which in turen dispatches the aciton, which in turn updates the visible todos, since the action udpates the store.

#### 2.2.2 AddTodo, Footer, FilterLink

We've refactored `TodoApp` to use a `TodoList` component. Let's keep working on separating the looks from the behavior.

**Extracting the Input and the Button into `AddTodo`**

We will combine the input and the button into one new component called `AddTodo`. Functional components don't have instances, so instead of using `this`, we will use a variable called `input` that we will close over so we can write to it inside of the function. Since we want `AddTodo` to be a presentational component, we will have the button call an `onAddClick()` function with `input`'s value as its parameter. We also make `onAddClick` a prop so that the component that uses `AddTodo` can specify what happens when the `Add Todo` button is clicked. 

{% highlight js linenos %}
const AddTodo = ({
  onAddClick
}) => {
  let input;

  return (
    <div>
      <input ref={node => {
        input = node;
      }} />
      <button onClick={() => {
        onAddClick(input.value);
        input.value = '';
      }}>
        Add Todo
      </button>
    </div>
  );
};
{% endhighlight %}

Now we need to update the `TodoApp` container component by replacing the `<input>` and `<button>` entries with our new `AddTodo` component.

We will also specify our `onAddClick` function to dispatch an aciton of type `ADD_TODO` along with the corresponding `text` and next `id`

{% highlight js linenos %}
.
. // inside `TodoApp`'s `render` method
.
return (
  <div>
    <AddTodo
      onAddClick={text =>
        store.dispatch({
          type: 'ADD_TODO',
          id: nextTodoId++,
          text  
        })
      }
    />
.
.
.
{% endhighlight %}


**Extracting the `FilterLink` Footer Elements**

Now we will create a new funcitonal component called `Footer`. Since each `FilterLink` needs to know the `visibilityFilter`, we will make that a prop. We want the `Filter` and `FilterLink` to be presentational components, but in its current implementation each of the `FilterLink`s contain a `store.dispatch()` call. This call will be replaced by an `onClick` call that will take a single parameter with the filter. We also add `onClick` to `FilterLink`'s props. Since `onClick` is now a prop for `FilterLink`, we need to specify it every time that `Filter Link` is used in our `Footer`. Adding `onClick={onFIlterClick}` makes sure that `onClick` makes it to `FilterLink` as a prop.

{% highlight js linenos %}
// FilterLink was built in a previous section
const FilterLink = ({
  filter,
  currentFilter,
  children,
  onClick
}) => {
  if (filter === currentFilter) {
    return <span>{children}</span>
  }

  return (
    <a href='#'
      onClick={e => {
        e.preventDefault();
        onClick(filter);
      }}
    >
      {children}
    </a>
  );
};

const Footer = ({
  visibilityFilter,
  onFilterClick
}) => (
  <p>
    <FilterLink
      filter='SHOW_ALL'
      currentFilter={visibilityFilter}
      onClick={onFilterClick}
    >
      All
    </FilterLink>
    {', '}
    <FilterLink
      filter='SHOW_ACTIVE'
      currentFilter={visibilityFilter}
      onClick={onFilterClick}
    >
      Active
    </FilterLink>
      {', '}
    <FilterLink
      filter='SHOW_COMPLETED'
      currentFilter={visibilityFilter}
      onClick={onFilterClick}
    >
      Completed
    </FilterLink>
  </p>
);
{% endhighlight %}

**Adding `Footer` to `TodoApp` **

When adding the `Footer` component into `TodoApp`, we nned to pass two props. First, `visibilityFilter` to highlight the active link. The second prop is `onFilterClick`, which will dispatch an aciton of type `SET_VISIBILITY_FILTER` along with the `filter` being clicked.

{% highlight js linenos %}

.
. // inside `TodoApp`'s `render` method
.
return (
  <div>
    // `<AddTodo>` component
    // `<TodoList>` component
    <Footer
      visibilityFilter={visibilityFilter}
      onFilterClick={filter =>
        store.dispatch({
          type: 'SET_VISIBILITY_FILTER',
          filter
        })
      }
    />
  </div>
.
.
.
{% endhighlight %}

**Changing `TodoApp` into a function**

It is possible to change `TodoApp` from a class into a function. This allows us to eliminate the destructuring of `todos` and `visibilityFilter` from `this.props` inside the `render` function. Instead, we can do this inside the argument to the `TodoApp` function. We can also do away with the `render()` declaration. Since the `visibleTodos` are only used in a single place, we can move its declaration into the `TodoList` `todos` prop declaration.

{% highlight js linenos %}
const TodoApp = ({
  todos,
  visibilityFilter
}) => {
  return (
    <div>
      <AddTodo
        onAddClick={text =>
          store.dispatch({
            type: 'ADD_TODO',
            id: nextTodoId++,
            text
          })
        }
      />
      <TodoList
        todos={
          getVisibleTodos(
            todos,
            visibilityFilter
          )
        }
        onTodoClick={id =>
          store.dispatch({
            type: 'TOGGLE_TODO',
            id
          })
        }
      />
      <Footer
        visibilityFilter={visibilityFilter}
        onFilterClick={filter =>
          store.dispatch({
            type: 'SET_VISIBILITY_FILTER',
            filter
          })
        }
      />
    </div>
  );
}
{% endhighlight %}

**Recap of Data Flow**

We've now finished the initial refactor of our application into a single continer component with many presentational components inside of it.

Separation of presentational components isn't required in Redux, but it's a good pattern to follow because it decoupled our rendering from Redux. This way, if we choose to move to another framework like Relay, we can keep our presentation components as-is.

One of the downsides to having separate presentational components is that we have to move around a lot of props, including the callbacks. However, we can easily solve thi sprobelm by introducing many intermediate container components, which we will start on in the next seciton.
    .

### 2.3 Extracting Container Components

#### 2.3.1 FilterLink

In the previous section, we separated presentational components from our main container component. `TodoApp` specifies the behaviors when buttons are clicked, items are added, and filters are applied. The individual presentational components, such as AddTodos, Footer, TodoList, etc don't dispatch actions, but instead call their callback functions in the props. Therefore ehry are only responsible for the looks not the behavior.

The downside of this approach is that lots of props must be passed down the tree even when intermediate components don't really use them. For example, the `FilterLink` needs to know the current filter so it can change its appearance when it's active. However, in order for it to receive the current filter, it has to be apssed down from the top. This is why `Footer` has to be given `visibilityFilter` so it can be passed to a `FilterLink`. In a way this breaks encapsulation because the parent components need to know too much about what data the child components need. To fix this, we are going to extract some more container components.

**Extracting the `Footer` Component**

Currently the `Footer` component accepts the `visibilityFilter` and `onFilterClick()` callback as its props, but it doesn't actually use either of them. It just passes down to the `FilterLink`. We can only do this because we know that the `Footer` component doesn't care about the values of tis props, as they only exist to pass down to `FilterLink`. 

We Start by removing the props definition from the `Footer` component, and removing them from the `FilterLink`s as well.

{% highlight js linenos %}
    const Footer = () => (
      <p>
        Show:
        {' '}
        <FilterLink
          filter='SHOW_ALL'
        >
          All
        </FilterLink>
        {', '}
        <FilterLink
          filter='SHOW_ACTIVE'
        >
          Active
        </FilterLink>
        {', '}
        <FilterLink
          filter='SHOW_COMPLETED'
        >
          Completed
        </FilterLink>
      </p>
    )
{% endhighlight %}

**Refactoring `FilterLink`**

Inside of the `FilterLink` definition, we don't currently specify behavior for clicking on the link. It also needs to know the current `filter` so it can render the item appropriately. Because of this, we can't say `FilterLink` is presentational, becuase it is inseparable from its behavior. The only reasonable behavior is to dispatch an aciton (`SET_VISIBILITY_FILTER`) upon clicking. This is an opportunity to split this into a more concise presentational component, with a wrapping container component to manage the logic, with the presentational component being used for rendering. Therefore, we will start by converting our current `FilterLink` into a presentational component called `Link`.

The new `Link` presentational component doesn't know anything about the filter-- it only accpets the active prop and calls `onClick` handler. `Link` is only concerned with rendering.

**The New `FilterLink`**

The new `FilterLink` will be a class that renders the `Link` with the current data from the `store`. It's goint to read the component `props` and read the `state`. **Note**:this doesn't mean React's state, but instead the redux store's state that it gets by calling `store.getState()`.

As a container component, `FilterLink` doesn't have its own markup, and it delegates rendering to the `Link` presentational component. In this case, it calculates its `active` prop by comparing its own `filter` prop with the `visibilityFilter` in the Redux store's `state`.

The `filter` prop is the one that is apssed to the `FilterLink` from the `Footer`. The `visibilityFilter` comrresponds to the current chosen visibility  filter that is held in Redux store's `state`. If they match, we want the link to appear active.

The container component also needs to specify the behavior. In this case, the `FilterLink` specifies that when a particluar `Link` is clicked, we should dispatch an aciton of the type `SET_VISIBILITY_FILTER` along with the `filter` value that we take from the props.

The `FilterLink` may accept children, which will be used as the contents of the `Link`. So we are goint to pass the children down to the `Link` component, which is going to render them inside of the `<a>` tag.

{% highlight js linenos %}
class FilterLink extends Component {
  render () {
    const props = this.props;
    // this just reads the store, is not listening
    // for change messages from the store updating
    const state = store.getState();

    return (
      <Link
        active={
          props.filter ===
          state.visibilityFilter
        }
        onClick={() =>
          store.dispatch({
            type: 'SET_VISIBILITY_FILTER',
            filter: props.filter
          })
        }
      >
        {props.children}
      </Link>
    );
  }
}
{% endhighlight %}

There is a small problem with this implementatin of `FilterLink`. Inside the `render()` method it reads the current `state` of the Redux store, however, it does not subscribe to the store. So if the aprent component doesn't udpate when the store is updated, the correct value won't be rendered.

Also, we currently re-render the entire application when the state changes, which isn't very efficient. In the future, we will move subscription to the React lifecycle methods of the container components.

React provides a special `forceUpdate()` method on the Component instances to force them to re-render. We can use it in combination with the `store.subscribe()` method so that any time the store changes we force the container component to update.

We can start by implementing this inside `FilterLInk`:

{% highlight js linenos %}
class FilterLink extends Component {
  componentDidMount() {
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }

  // Since the subscription happens in `componentDidMount`,
  // it's important to unsubscribe in `componentWillUnmount`.
  componentWillUnmount() {
    this.unsubscribe(); // return value of `store.subscribe()`
  }
.
. // `render()` method as above...
{% endhighlight %}

#### 2.3.2 VisibleTodoList, AddTodo

Now let's work with the `TodoList` component. We want to keep it as a presentational component, but we want to excapsulates reading the currently visible todos into a separate container component that connects the `TodoList` to the Redux store.

This component will be called `VisibleTodoList`. Just like when we created the `FilterLink` component, the data for `VisibleTodoList` will be calculated by using the current state. We will use the `getVisible Todos()` function to go through all of the `todos` in the Redux store and determine which ones should be shown according to the `visibilityFilter`.

We also will specify the behavior of `onTodoClick()` to dispatch an action of type `TOGGLE_TODO` along with the `id`.

The Same subscription logic we used in our `FilterLink` component needs to be included as well.

{% highlight js linenos %}
class VisibleTodoList extends Component {
  componentDidMount() {
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  render() {
    const props = this.props;
    const state = store.getState();

    return (
      <TodoList
        todos={
          getVisibleTodos(
            state.todos,
            state.visibilityFilter
          )
        }
        onTodoClick={id =>
          store.dispatch({
            type: 'TOGGLE_TODO',
            id
          })
        }
      />
    );
  }
}
{% endhighlight %}

Remember, the job of all container components is similar-- connect a presentational component to the Redux store, and specify the data and behavior it needs. Now we can replace `TodoList` in our `TodoApp` with our newly created `VisibleTodoList`.

**Changing `AddTodo` to a Container**

In the last section we made `AddTodo` into a presentational component. Now we will backtrack on this. We start by moving the `onClick` handler from `TodoApp` into the `AddTodo` component. We're doing this because there isn't a lot of presentation or behavior here, and it's easier to keep them together until we figure out how to split the presentation from the behavior. For example, in the future we may decide to have a `Form` component

{% highlight js linenos %}
const AddTodo = () => {
  let input;

  return (
    <div>
      <input ref={node => {
        input = node;
      }} />
      <button onClick={() => {
          store.dispatch({
            type: 'ADD_TODO',
            id: nextTodoId++,
            text: input.value
          })
        input.value = '';
      }}>
        Add Todo
      </button>
    </div>
  );
};
{% endhighlight %}
    
**Refactored `TodoApp`**

Now that we've refactored our components, it's become clear that none of the containers need props from `TodoApp`! We can also get rid of `TodoApp`'s `render()` function that rendered the current state of the store. We can get rid of the `render()` function because the container components inside of `TodoApp` are now set up to get state and update themselves as needed, therefore, we only need to render `TodoApp` once on initialization.

{% highlight js linenos %}
const TodoApp = () => (
  <div>
    <AddTodo />
    <VisibleTodoList />
    <Footer />
  </div>
);

// Note this render does not belong to `TodoApp`
ReactDOM.render(
  <TodoApp />,
  document.getElementById('root')
);
{% endhighlight %}


### 2.4 Passing the Store Down

#### 2.4.1 Explicityly via Props

So far we've been creating a variable called `store` by passing our combined `todoApp` reducers into Redux's `createStore()` function:

{% highlight js linenos %}
const { combineReducers, createStore } = Redux;

const todoApp = combineReducers({
  todos,
  visibilityFilter
});

const store = createStore(todoApp);
{% endhighlight %}
    
Once the store has been created, our container components get data from it by calling `store.getState()`, subsribe to changes by calling `store.subscribe()`, and dispatch actions by calling `store.dispatch()`. Having all of our code in a single file works well for a simple example, but it doesn't scale very well.

First, it makes our components harder to test because they'll reference a specific store, but we may want to provide a different mock store in the tests. Second, it makes it hard to implement the universal applications that are rendered on the server, because on the server we'll want to supply a different `store` instance for every request, because different requests have different data. To start fixing this, we'll move the code related to creating the store to the bottom of the file, and pass the store we create as a prop to `TodoApp`.

**Before**

{% highlight js linenos %}
const store = createStore(todoApp);

ReactDOM.render(
  <TodoApp />,
  document.getElementById('root')
);

**After**

ReactDOM.render(
  <TodoApp store={createStore(todoApp)} />,
  document.getElementById('root')
);
{% endhighlight %}

The `store` is now injected into `TodoApp`

**Refactoring `TodoApp` to accept `store`**
Every container component needs a reference to `store`, and unfortunately the only way to make this happen (for now) is by passing it down to every component as a prop. Hoever, this is less effort than passing different data to every com

{% highlight js linenos %}
const TodoApp = ({ store }) => (
  <div>
    <AddTodo store={store} />
    <VisibleTodoList store={store} />
    <Footer store={store} />
  </div>
);
{% endhighlight %}

The problem with doing it this way is that the container components need to have the `store` instance to get `state` from it, dispatch actions, and subscribe to changes. 

Now inside of each of the components inside of `TodoApp` we need to adjust our container components to take the `store` from the `props` in both `componentDidMount()` and `render()`:

{% highlight js linenos %}
class VisibleTodoList extends Component {
  componentDidMount() {
    const { store } = this.props;
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }
  .
  . // Rest of component as before to `render()` method
  .

  render() {
    const props = this.props;
    const { store } = props;
    const state = store.getState();
    .
    .
    .
  }
}

const AddTodo = ({ store }) => {
  .
  . // Rest of component as before
  .
}
{% endhighlight %}

Though `Footer` itself does not need the store, we must give it to `Footer` so we can pass it to `FilterLink`

{% highlight js linenos %}
const Footer = ({ store }) => {
  <p>
    <FilterLink
      filter='SHOW_ALL'
      store={store}
    >
      All
    </FilterLink>
    .
    . // Follow this pattern for the other `FilterLink` component references
    .
}

class FilterLink extends Component {
  componentDidMount() {
    const { store } = this.props;
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }
  .
  . // Rest of component as before down to `render()`
  .
  render() {
    const props = this.props;
    const { store } = props
    const state = store.getState()
    .
    . // Rest of component as before
    .
  }
}
{% endhighlight %}

Now all of our components are receiving `state` via their props instead of relying on a top level variable. Note that this change did not change the behavior of the data flow of the application. The containers subscribe to `store` and update like they did before. What changed is how they get the store.

Soon we will see how to pass `store` to the container  components implicitly, but for now, this is where we're at.

#### 2.4.2 Implicitly via Context

In the last section we refactored our code to pass `store` around as a prop. This requires a lot of boilerplate code. However, there is an easier way: user React's context feature.

To illustrate, we'll start by creating a new `Provider ` component. From its `render()` method, it just returns what its child is. This mean we can wrap any component in a `Provider`, and it's going to render that component.

{% highlight js linenos %}
class Provider extends Component {
  render() {
    return this.props.children;
  }
}
{% endhighlight %}

Now we need to change our `ReactDOM.render()` call to render `TodoApp` inside of our new `Provider`. We also now pass `state` as a prop to `Provider` instead of `TodoApp`

{% highlight js linenos %}
ReactDOM.render(
  <Provider store={createStore(todoApp)}>
    <TodoApp />
  </Provider>,
  document.getElementById('root')
);
{% endhighlight %}   

Now we will update our `Provider` component to user React's context feature. This is what makes the store available to any component that it renders. Now the `store` will be available to any of the children and grandchildren of the components `Provider` renders (in our example, this is `TodoApp` and all of the other components and containers we've bult inside of it!)

There is an important condition that must be added to make it work. We have to provide`childContextTypes` on the component that provides child context. This is similar to React's `PropTypes` definition that helps you when writing your app, except that in this case it si required in order for the dhild components to receive context.

{% highlight js linenos %}
class Provider extends Component {
  getChildContext() {
    return {
      store: this.props.store // This corresponds to the `store` passed in as a prop
    };
  }
  render() {
    return this.props.children;
  }
}

Provider.childContextTypes = {
  store: React.PropTypes.object
}
{% endhighlight %}

**Refactore Components to get `store` from `context` instead of `props`**

In each of our components, we need to change how `state` is received.

{% highlight js linenos %}
class VisibleTodoList extends Component {
  componentDidMount() {
    const { store } = this.context;
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }
  .
  . // Rest of component as before to `render()` method
  .

  render() {
    const props = this.props;
    const { store } = this.context;
    const state = store.getState();
    .
    .
    .
  }
}
{% endhighlight %}

**Note:** The `context` is opt-in for all components, so we have to specify `contextTypes`. If you don't specify this, the component won't receive the relevant context, so it is essential to declare them!

{% highlight js linenos %}
VisibleTodoList.contextTypes = {
  store: React.PropTypes.object
}
{% endhighlight %}

**Updating our Functional Components for `context`**

Our functional components don't have `this`, so how will we give them `context`? It turns out that they receive context as a second argument(after `props`). We also need to add `contextTypes` for the component that specifies which context we want to recieve(in this case, `store` from `Provider`). Context can be passwed down to any level, so you can think of it as creating a 'wormhole' to whatever component that uses it. However, you must remember to opt-in by declaring the contextTypes.

{% highlight js linenos %}
const AddTodo = (props, { store }) => {
  .
  . // Rest of component as before
  .
}

AddTodo.contextTypes = {
  store: React.PropTypes.object
}
{% endhighlight %}

We must also convert `FilterLink` to accept the store form context and provide the contextTypes.

**Updating `FilterLink`**

{% highlight js linenos %}
class FilterLink extends Component {
  componentDidMount() {
    const { store } = this.context;
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }
  .
  . // Rest of component as before down to `render()`
  .
  render() {
    const props = this.props;
    const { store } = this.context;
    const state = store.getState();
    .
    . // Rest of component as before
    .
  }
}
FilterLink.contextTypes = {
  store: React.PropTypes.object
}
{% endhighlight %}

**Note**: `Footer` and individual `<FilterLink>` elements don't need `store` as a prop anymore as we don't need to pass it down, so we can remove that from the props:

{% highlight js linenos %}
const Footer = () => {
  <p>
    <FilterLink
      filter='SHOW_ALL'
    >
      All
    </FilterLink>
    .
    . // Follow this pattern for the other `FilterLink` component references
    .
}
{% endhighlight %}

We can also get rid of the store prop for `TodoApp` because it no longer needs to be passed down to the containers.


{% highlight js linenos %}
    const TodoApp = () => (
      <div>
        <AddTodo />
        <VisibleTodoList />
        <Footer />
      </div>
    )
{% endhighlight %}


**Recap**

Now we are implicitly passing `store` down via context instead of havin gto explicitly todo via props.

Context is a powerful feature, but in a way it contradicts the React philosophy of having an explicit data flow. The context essentially allows global varaibles across the component tree. Global variables are usually a bad idea, and you shouldn't use the context feature in this way. You should only  use context if you're using it for dependency injection (like in our case where we need to make a single object available to all components).

Finally, it is important to note that the `context` API is not stable in React. It has changed before, and it is likely to change again, so it is probably best to not rely on it too much.

#### 2.4.3 with `<Provider>` from React Redux

In the last section, we implemented a `Provider` component to pass `store` implicitly with React's `context` feature. It was really convenient.

In fact, it swas so comvenient that we don't need to write `Provider` ourselves-- we can import it from the `react-redux` library that gives React bindings to the Redux library.

Start by importing `Provider` from `react-redux`

{% highlight js linenos %}
    // CDN style
    const { Provider } = ReactRedux;
    // npm style
    import { Provider } from 'react-redux';

{% endhighlight %}

Just like the `Provider` we wrote before, the `Provider` that comes with `react-redux` exposes store as a prop on the context


### 2.5 Generating Containers with `connect()` from `'react-redux'`

#### 2.5.1 VisibleTodoList

Now that we have `react-redux`, we are using its `Provider` component to pass `store` down via context.

Our container components are similar: they need to re-render when the store's state changes, they need to unsubscribe from the store when they unmounted and they take the current state from the Redux `store` and use it to render the presentational componenets with some props that they calculate. They also need to specify the `contextTypes` to get the store from the context. We're going to write `VisibleTodoList` in a different way now. We'll start by writing a function `mapStateToProps` which takes the Redux store's state, and returns the props that we need to pass to the presentational `TodoList` component so it can be renderd with the current `state`.

In this case `TodoList` only takes a prop called `todos` so we can move the expression into our `mapStateToProps` function. It returns the props that depend ont hecurrent state of the Redux store, which in this case is just the `todos`.

{% highlight js linenos %}
const mapStateToProps = (state) => {
  return {
    todos: getVisibleTodos (
      state.todos,
      state.visibilityFilter
    )
  };
}
{% endhighlight %}

Now we'll create another function called `mapDispatchToProps` that accepts the `dispatch()` from `store` as its only only argument. It returns the props that should be passed to the `TodoList` component that depend on the `dispatch()` method. In the case of `TodoList`, the only prop that `TodoList` took that requires `store.dispatch()` is `onTodoClick`. So we will remove `onTodoClick from` `TodoList` and put it into `mapDispatchToProps`'s `return`. Note that we don't nedd the reference to `store` anymore, and can just change `store.dispatch()` to just `dispatch()`, which is provided as an argument to `matchDispatchToProps`.

{% highlight js linenos %}
    const mapDispatchToProps = (dispatch) => {
      return {
        onTodoClick: (id) => {
          dispatch({
            type: 'TOGGLE_TODO',
            id
          })
        }
      };
    };
{% endhighlight %}


**Recap**
We now have two functions: A function `mapStateToProps` that maps the Redux store's state to the props of the `TodoList` component that are related to the data from the Redux store. These props will be updated any time the state changes. We also created a function `mapDispatchToProps` that maps the store's `dispatch()` method and returns the props that use the dispatch method to disptach actions. So it returns the callback props needed by the presentational component. It specifies the behavior of which callback prop dispatches which action.

**The `connect()` function**

Together, these two new function describe a container component so well that insted of writing it we can generate it by using the `connect()` function provided by `react-redux`.

Now instead of creating a `VisibleTodoList` class, we can declare a variable and use the `connect()` method to obtain it. We'll pass in `mapStateToProps` as the first argument, and `mapDispatchToProps` as the second. As this is a **curreid function**, we must call it again, passing in the presentational component that we want it to wrap and pass the props, thereby connecting to the redux store(in this case, `TodoList`).

The result of the connect call is the container component that is going to render the presentational component. It will calculate the props to pass to the representational by merging the objects returned form `mapStateToProps`,`mapDispatchToProps`, and its own props.

{% highlight js linenos %}
    const { connect } = ReactRedux;
    // import { connect } from 'react-redux';

    const VisibleTodoList = connect(
      mapStateToProps,
      mapDispatchToProps
    )(TodoList)
{% endhighlight %}

The `connect()` function will generate the component just like the one we wrote by hand, so we don't have to write the code to subscribe to the store or to specify the context types manually.


#### 2.5.2 AddTodo

In the last section we used `connect()` to set up our `VisibleTodoList` component. Since these examples have all of our JavaScript written in a single file. we need to rename our `mapStateToProps` and `mapDispatchToProps` funcitons to be more specific. Note that this doesn't need to be done if we keep all of our components in separate files.

Recall that our `AddTodo` component wasn't clearly a presentational or container component. However, it dose rely on `store` and `dispatch()` function. Instead of reading `store` for the context, we are going to refactor `AddTodo` to read `dispatch` from the props. This is because `AddTodo` only needs `dispatch()` not the whole store. We will be creating a container component using `connect()` that will inject the dispatch function as a prop. We will remove `AddTodo.contextTypes` because the component generated by the `connect()` function will take care of reading the store from the context.

**Before:**

{% highlight js linenos %}
const AddTodo = (props, { store }) => {
  .
  . // inside `return`
  .
    <button onClick={() => {
      store.dispatch({
      .
      .
      .

}
AddTodo.contextTypes = {
  store: React.PropTypes.object
}
**After:**

let AddTodo = ({ dispatch }) => {
  .
  . // inside `return`
  .
    <button onClick={() => {
      dispatch({
      .
      .
      .
}
// No more `AddTodo.contextTypes`
{% endhighlight %}


Notice that we changed `const` to `let` in our declaration. This lets us reassign `AddTodo` so the consuming component doesn't need to specify the `dispatch` as a prop because it will be injected by the component generated by the `connect` call.

The first argument to `connect()` is a `mapStateToProps`, but there aren't any props for our `AddTodo` component that depend on the current state. Because of this, we'll have our first parameter return an empty object. The second argument to `connect()` `mapDispatchToProps`, but `AddTodo` doesn't need any callback props. Because of this, we'll just return the `dispatch` function itself as a prop with the same name.

We'll call the function a second time to specify the component we want to wrap (in this case `AddTodo` itself).

{% highlight js linenos %}
AddTodo = connect(
  state => {
    return {};
  },
  dispatch => {
    return { dispatch };
  }
)(AddTodo);
{% endhighlight %}

Now `AddTodo` won't pass any props dependent on `state`, but it will pass `dispatch()` itself as a function so that the component can read from the props and use it without worring about context or specifying any `ContextTypes`.

**But it's wasteful...**

Why subscribe to the store if we are't going to calculate props from the state? Because we don't need to subscribe to the store, we can call `connect()` without `mapStateToProps` as an argument, instead passing in `null`. What this does is tell `connect` that **there is no need to subscribe to the store**. It's a common pattern to inject just the `dispatch` function, so if `connect()` sees that the second argument is null (for any flasey value), you'll get `dispatch` injected as a prop. What this means is that we can accomplish the same effect as the above code by removing the arguments from the `connect` function:

    AddTodo = connect()(AddTodo)
Now the defaul behavior to not subscribe to the store and inject `dispatch` as a prop.

#### 2.5.3 FooterLink

Now let's use connect() on our `FooterLink` component. Recall that our `FilterLink` component renders a `Link` with an `active` prop and an `onClick` handler.


We'll start by writing our `mapStateToProps` function which we will call `mapStateToLinkProps` because everything is in a single file, remember? It will accept the state of the Redux store and return the props that should be passed to the `Link` component. The only prop in `Link` is `active`, which determines the styling based on the `visibilityFilter`. We remove the definition from `Link`'s `active` prop and move it into `mapStateToLinkProps`.

{% highlight js linenos %}
const mapStateToLinkProps = (
  state
) => {
  return {
    active:
      props.filter ===
      state.visibilityFilter
  }
};
{% endhighlight %}


Notice that `active` noew references the `filter` prop of the `FilterLink` component. In order to tell if a `Link` is active or not, we need to compare this prop with the `visibilityFilter` in the Redux store's stata. It's common to use the container props when calculating the child props, so we pass them in as a second argument to `mapStateToProps`. In this case, we'll rename it to `ownProps` to make it more clear that we are tlaking about the container component's own props, and not the props that are passed to the child, which is the return value of `mapStateToProps`.

{% highlight js linenos %}
const mapStateToLinkProps = (
  state,
  ownProps
) => {
  return {
    active:
      ownProps.filter ===
      state.visibilityFilter
  }
};
{% endhighlight %}

Again, we wil rename `mapDispatchToProps` function to `mapDispatchToLinkProps` to avoid name collisions. Initially we know our first argument is the `dispatch` function. To see what other arguments we need, we will to look at the container component to tsee what props depend on the `dispatch` function. In this case, we only have the `onClick()` where we dispatch the action type `'SET_VISIBILITY_FILTER'` along with the `filter` type. Since there is another reference to `props`, we will add `ownProps` as our second argument to `mapDispatchToLinkProps`.

{% highlight js linenos %}
const mapDispatchToLinkProps = (
  dispatch,
  ownProps
) => {
  return {
    onClick: () => {
      dispatch({
        type: 'SET_VISIBILITY_FILTER',
        filter: ownProps.filter
      });
    }
  };
}
{% endhighlight %}


**`connect()` it up ** 

{% highlight js linenos %}
const FilterLink = connect(
  mapStateToLinkProps,
  mapDispatchToLinkProps
)(Link);
{% endhighlight %}

Now that we've used `react-redux`'s `connect()`, we can remove our old `FilterLink` implementation, including the `contextTypes`.


### 2.6 Extracting Action Creators

So far we've covered container components, presentational coponents, reduers, and the store...but we haven't covered action creators.

In our current `AddTodo` component, we dispatch an action type `ADD_TODO` when the "Add Todo" button is cliced. However, it references the `nextTodoId` variable which is delcared alongside the component. Normally it would be local, but what if another component wants to be able to dispatch 'ADD_TODO'? The component would need to have access to `nextTodoId`.

**Existing `AddTodo` Code**

{% highlight js linenos %}
let nextTodoId = 0;
let AddTodo = ({ dispatch }) => {
  let input;

  return (
    <div>
      <input ref={node => {
        input = node;
      }} />
      <button onClick={() => {
        dispatch({
          type: 'ADD_TODO',
          id: nextTodoId++,
          text: input.value
        })
        input.value = '';
      }}>
        Add Todo
      </button>
    </div>
  );
};
{% endhighlight %}

In order to allow other components to dispatch the `ADD_TODO` action, it would be best if `ADD_TODO` didn't have to worry about specifying the `id`. The only information that really is passed is the `text` of the todo being added. We don't want to generate the `id` inside of the reducer because that would make it **non-deterministic**.

**Action Creator**

Our first action creator will be `addTodo`. This wi be a function that takes the `text` of the todo and constructs an action object representing the `ADD_TODO` action.

Replace the code inside the `dispatch()` call inside of the `AddTodo` component will call `addTodo()`

{% highlight js linenos %}
// inside `AddTodo` component
<button onClick={() => {
  dispatch(addTodo(input.value))
  input.value = '';
}}>
.
.
.
{% endhighlight %}

Action creators are typically kept separate from components and reducers in order to help with maitainability. In this case, we'll put all of our action creators together near the top of the file.

We have other actions we can extract from our components:

**'SET_VISIBILITY_FILTER' inside of `mapDispatchToLinkProps`:**

Before:

{% highlight js linenos %}
const mapDispatchToLinkProps = (
  dispatch,
  ownProps
) => {
  return {
    onClick: () => {
      dispatch({
        type: 'SET_VISIBILITY_FILTER',
        filter: ownProps.filter
      });
    }
  };
}
{% endhighlight %}
After:
{% highlight js linenos %}
const setVisibilityFilter = (filter) => {
  return {
    type: 'SET_VISIBILITY_FILTER',
    filter
  };
};

.
. // Further down the file...
.
const mapDispatchToLinkProps = (
  dispatch,
  ownProps
) => {
  return {
    onClick: () => {
      dispatch(
        setVisibilityFilter(ownProps.filter)
      );
    }
  };
}
{% endhighlight %}

**`TOGGLE_TODO` inside of `mapDispatchToTodoListProps`:**

after:

{% highlight js linenos %}
const toggleTodo = (id) => {
  return {
    type: 'TOGGLE_TODO',
    id
  };
};
.
. // Further down the file...
.
const mapDispatchToTodoListProps = (
  dispatch
) => {
  return {
    onTodoClick: (id) => {
      dispatch(toggleTodo(id));
    }
  };
}
{% endhighlight %}

**Recap**

Keeping all of our aciton creators together in  one place helps to inform others who look at our code what actions capable of taking place. They can also be used by different components, as well as in tests.

Whether you use action creators or not, the data flow is the same.

## 3 TodoList Example: Advanced ##

### 3.1 Persistent via `localStorage`###

#### 3.1.1 Simplifying the Arrow Functions ####

Since action creators are just reguar JavaScript functions, you can define them any way you like. For example, if you don't like arrow notation, you can replace it with the traditional function declaration syntax:

**Arrow Function Syntax**

{% highlight js linenos %}
export const addTodo = (text) => {
  return {
    type: 'ADD_TODO',
    id: (nextTodoId++).toString(),
    text,
  };
};
{% endhighlight %}

**Traditional Function Syntax**

{% highlight js linenos %}
export function addTodo(text) {
  return {
    type: 'ADD_TODO',
    id: (nextTodoId++).toString(),
    text,
  };
}
{% endhighlight %}

However, if you like using arro function, they can be made even more concise. Looking at our arrow function above, we can see that our function starts and ends with a curly brace, and contains a `return` statement inside. Since the return statement is all that is inside our function, we can use it as the body of the arrow function. We can remove the block in favor of the object expression:

{% highlight js linenos %}
export const addTodo = (text) => ({
  type:'ADD_TODO',
  id: (nextTodoId++).toString(),
  text,
})
{% endhighlight %}

Note: It is important to wrap the expression in parens so that the parser understands this as an expression instead of a block. These steps can be repeated for any function that just returns an object; just remove the `return` statement, and change the body into an expression. This process can be used outside of Action Creators as well. For example, it is common for `mapStateToProps` and `mapDispatchToProps` to just return objects;

**Before:**

{% highlight js linenos %}
const mapStateToProps = (state, ownProps) => {
  return {
    active: ownProps.filter === state.visibilityFilter
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onClick: () => {
      dispatch(setVisibilityFilter(ownProps.filter))
    }
  }
}
{% endhighlight %}

**After:**

{% highlight js linenos %}
const mapStateToProps = (state, ownProps) => ({
    active: ownProps.filter === state.visibilityFilter
})

const mapDispatchToProps = (dispatch, ownProps) => ({
    onClick: () => {
      dispatch(setVisibilityFilter(ownProps.filter))
    }
})
{% endhighlight %}

We can make `mapDispatchToProps` even more compact by replacing the arrow function with a concise method notation that is part of ES6 and is available when a funciton is defined inside an object.

{% highlight js linenos %}
const mapDispatchToProps = (dispatch, ownProps) => ({
    onClick() {
      dispatch(setVisibilityFilter(ownProps.filter))
    }
})
{% endhighlight %}

#### 3.1.2 Supplying the Initial State ####

When you create a Redux store, its initial state is determined by the root reducer. In this case, the root reducer is the result of caling `combineReducers` on `todos` and `visibilityFilter`.

**Inside `src/index.js`**

{% highlight js linenos %}
const store = createStore(todoApp)
{% endhighlight %}

**Inside `src/reducers/index.js`**

{% highlight js linenos %}
const todoApp = combineReducers({
  todos,
  visibilityFilter
})
{% endhighlight %}

Since reducers are autonomous, each of them specifies its own initial state as the default value of the `state` argument.

In `const todos = (state=[],action)...` the default state is an empty array; the default state value in `const visibilityFilter = (state='SHOW_ALL',action)...` is a string. Therefore, our initial state of the combined reducer is going to be an object containing an empty array under the `todos` key, and a string `SHOW_ALL` under the `visibilityFilter` key:

**Initial State:**

{% highlight js linenos %}
const todoApp = combineReducers({
    todos,
    visibilityFilter
})
{% endhighlight %}

However, sometimes we want to load data into the store synchronously before the application starts. For example, there may be Todos left from the previous session. Redux let us pass a `persistedState` as the second argument to the `createStore` function:

{% highlight js linenos %}
const persistedState = {
  todos: [{
    id: 0,
    text: 'Welcome Back!',
    completed: false
  }]
}

const store = createStore(
  todoApp,
  persistedState
)
{% endhighlight %}

When passing in a `persistedState`, it will overwrite the default values set in the reducer as applicable. In this example, we've provided `todos` with an array, but since we didn't specify a value for `visibilityFilter`, the default `SHOW_ALL` will be used.

Since the `persistedState` that we provided as a second argument to `createStore()` was obtained from Redux itself, it doesn't break encapsulation reducers. It may be tempting to supply an initial state for your entire store inside of `persistedState`, but it is not recommended. If you were to do this, it would become more difficult to test and change your reducers later.

#### 3.1.3 Persisting the State to the Local Storage ####

In this example, we want to be able to persis the state of the application using the browser's `localStorage` API. We will write a function called `loadState()` and a new model called `localStorage.js`

The `loadState` function is going to look into `localStorage` by key, retrieve a string, and try to parse it as JSON. This code needs to be wrapped into a `try/catch` because it's possible that the user's browser disallows usage of the `localStorage` API.

**`localStorage.js`**

{% highlight js linenos %}
export const loadState = () => {
  try {
    const serializedState = localStorage.getItem('state');
    if (serializedState === null) {
      return undefined;
    }
    return JSON.parse(serializedState);
  } catch (err) {
    return undefined;
  }
};
{% endhighlight %}

In our `loadState` function, if the `serializedState` is `null`, it means that the key doesn't exist, so we return `undefined` which lets the reducers set the state instead. However, if the `serializedState` string exists, we'll use `JSON.parse(serializedState)` in order to return it into the `state` object. Since we have a function for loading state, we should have one for saving state to localStorage:

Since we have a function for loading state, we should have one for saving state to localStorage:

{% highlight js linenos %}
export const saveState = (state) => {
  try {
    const serializedState = JSON.stringify(state);
    localStorage.setItem('state', serializedState);
  } catch (err) {
    // Ignore write errors.
  }
};
{% endhighlight %}

Our `saveState` function accept our `state` as an argument, and does the exact opposite thing as our `loadState` function. First, we use `JSON.stringify(state)` to serrialize our state to a stirng. This will only work if the state is seriaizable, but if you're following suggested Redux practics, you'll be good to go. We catch any errors, since either `JSON.stringify()` or `localStorage.setItem()` can fail.

**Using `localStorage.js`**

Back in our `index.js` file, we will import the funcitons we just wrote:

{% highlight js linenos %}
import { loadState, saveState } from './localStorage'
{% endhighlight %}

In order to save our state any time the store changes, we will use the `store`'s `subscribe()` method to add a listener that will be invoked on any state change, passing in the current state of the store into the `save state` function:

{% highlight js linenos %}
// Inside of index.js ...
store.subscribe(() => {
  saveState(store.getState())
})
{% endhighlight %}

Now we have our state being preserved across reloads. However, it isn't just our complete & incomplete Todo items being tracked, but the visbility filter as well. To fix this, we'll adjust `store.subscribe()`:

{% highlight js linenos %}
// Inside of index.js ...
store.subscribe(() => {
  saveState({
    todos: store.getState().todos
  })
})
{% endhighlight %}

Now that we are only saving the `todos` portion of our state, when we refresh the page our `visibilityFilter` will be set to the default of `SHOW_ALL` by its reducer.

**But we have a bug ...**

With the way our code is currently written, when we try to add a new Todo item, React will error with `Encountred two children with the same key, 0`. This is because in our `TodoList` component we use `todo.id` as our key, which is assigned in the `addTodo` action creator inside of `action.js`. The `addTodo` action creator uses a local variable `nextTodoId` that is assigned to `0` by default.

**`addTodo` Before: **

{% highlight js linenos %}
let nextTodoId = 0

export const addTodo = (text) => ({
  type: 'ADD_TODO',
  id: (nextTodoId++).toString(),
  text
})
{% endhighlight %}

To get around this, we will use an npm module called `node-uuid` by entering`$ npm install --save node-uuid`. To use the module, we import `v4` from `node-uuid` and call it instead of `(nextTodoId++)`. Note `v4` is just the name of th standard.

**addTodoAfter:**

{% highlight js linenos %}
import { v4 } from 'node-uuid'

export const addTodo = (text) => ({
  type: 'ADD_TODO',
  id: v4(),
  text
})
{% endhighlight %}

**Throttling `saveState()`**

We currently call `saveState()` inside the subscribe listener so it is called every time the storage state changes. We want to avoid calling it too often because it uses the expensive `stringify` operation. We wil fix this by using another npm module `lodash` that includes a `throttle` utility by calling `$ npm install --save lodash`

**`store.subscribe()` Before: **

{% highlight js linenos %}
store.subscribe(() => {
  saveState({
    todos: store.getState().todos
  })
})
{% endhighlight %}

By wrapping our calback in a `throttle` call, we can insure that the inner function we pass is not going to be called more often than our specified number of milliseconds. We'll import just `throttle` directly from `lodash`, instead of bringing in the entire library to use a single function.

**`store.subscribe()` After:**

{% highlight js linenos %}
// top of index.js
import throttle from 'lodash/throttle'
.
.
.
store.subscribe(throttle(() => {
  saveState({
    todos: store.getState().todos
  })
}, 1000))
{% endhighlight %}

Now, even if the store gets updated really fast, we have a guarantee that we ony write to `localStorage` once a second at most.


#### 3.1.4 Refactoring the Entry Point ####

In this lesson we will extract the logic necessary for creating & subscribing to the store into a separate file.

**index.js Before**

{% highlight js linenos %}
import 'babel-polyfill'
import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import throttle from 'lodash/throttle'
import todoApp from './reducers'
import App from './components/App'
import { loadState, saveState } from './localStorage'

const persistedState = loadState()
const store = createStore(
  todoApp,
  persistedState
);

store.subscribe(throttle(() => {
  saveState({
    todos: store.getState().todos,
  })
}, 1000))

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
{% endhighlight %}

We will call our new file `configureStore.js`, and start by creating a function `configureStore` that will contain the store creation & persistance logic.

We do this because this way our app doesn't have to know exactly the store is created and whether or not we have subscribe handlers. It can just use the returned store in the `index.js` file.

**configureStore.js**


{% highlight js linenos %}
import { createStore } from 'redux'
import throttle from 'lodash/throttle'
import todoApp from './reducers'
import { loadState, saveState } from './localStorage'

const configureStore = () => {
  const persistedState = loadState()
  const store = createStore(todoApp, persistedState)

  store.subscribe(throttle(() => {
    saveState({
      todos: store.getState().todos
    })
  }, 1000))

  return store
}

export default configureStore
{% endhighlight %}

By exporting `configureStore` instead of just `store`, we will be able to create as many store instances as we want for testing.

**index.js After**

{% highlight js linenos %}
import 'babel-polyfill'
import React from 'react'
import { render } from 'react-dom'
import Root from './components/Root'
import configureStore from './configureStore'

const store = configureStore()
render(
  <Root store={store} />,
  document.getElementById('root')
);
{% endhighlight %}

Note that we have also extracted the root rendered element into a separate component called `Root`. It accepts `store` as a prop, and will be defined in a separate file in our `src/components` folder.

**`Root` Component **

{% highlight js linenos %}
import React, { PropTypes } from 'react';
import { Provider } from 'react-redux';
import App from './App';

const Root = ({ store }) => (
  <Provider store={store}>
    <App />
  </Provider>
);

Root.propTypes = {
  store: PropTypes.object.isRequired,
};

export default Root;
{% endhighlight %}

We've defined a stateless functional component that just takes the `store` as a prop and returns `<App />` inside of `react-redux`'s `Provider`.

Now inside of `index.js`, we can remove our `Provider` import as welas replacing the `App` component imported with our `Root` component import.

### 3.2 Router via `'react-router'`####

#### 3.2.1 Adding React Router to the project

In this lesson, we will add React Router.

**`Root.js` Before**

{% highlight js linenos %}
import React, { PropTypes } from 'react';
import { Provider } from 'react-redux';
import App from './App';

const Root = ({ store }) => (
  <Provider store={store}>
    <App />
  </Provider>
);
.
.
.
{% endhighlight %}

To add React Router to the project, run: `$ npm install --save react-router`

Inside of `Root.js` we will import the `Router` and `Route` components. We also replace our `<App />` with `<Router />`. It's important that it is still inside of `<Provider />` so that any components rendered by the router still have access to the store.

Inside of `<Router />` we will put a single `<Route />` element that tells React Router that we want to render our `<App />` component at the root path (`/`) in the browser's address bar.

**`Root.js` After**

{% highlight js linenos %}
import React, { PropTypes } from 'react';
import { Provider } from 'react-redux';
import { Router, Route, browserHistory } from 'react-router';
import App from './App';

const Root = ({ store }) => (
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route path="/" component={App} />
    </Router>
  </Provider>
);
.
.
.
{% endhighlight %}


#### 3.2.2 Navigating the React Router `<Link>`

In this lesson we will update the "links" that control the visibility filter to behave more like real links. We're going to change it so our browser's "Back" button works, and the URL changes when we swtich filters.

We'll start by adding a parameter to the Route `path` called `filter`. We wrap it in parens to tell React Router that it's optional (we want all Todos shown by default).

**update `Root.js`**

{% highlight js linenos %}
const Root = ({ store }) => (
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route path="/(:filter)" component={App} />
    </Router>
  </Provider>
);
.
.
.
{% endhighlight %}


**Update Links in `Footer.js`**

We also need to update our visibility filter links inside of the footer.

**`Footer.js` Before**

{% highlight js linenos %}
...
const Footer = () => (
  <p>
    Show:
    {" "}
    <FilterLink filter="SHOW_ALL">
      All
    </FilterLink>
    {", "}
    <FilterLink filter="SHOW_ACTIVE">
      Active
    </FilterLink>
    {", "}
    <FilterLink filter="SHOW_COMPLETED">
      Completed
    </FilterLink>
  </p>
);

export default Footer;
{% endhighlight %}

The previous implementation used the convention for the `filter` prop, but we will update them to align with the "active" and "completed" paths we want displayed in the address bar.

**`Footer.js` after**

{% highlight js linenos %}
// Rest as above...
<p>
  Show:
  {" "}
  <FilterLink filter="all">
    All
  </FilterLink>
  {", "}
  <FilterLink filter="active">
    Active
  </FilterLink>
  {", "}
  <FilterLink filter="completed">
    Completed
  </FilterLink>
</p>

export default Footer;

{% endhighlight %}

We use a null string to signify the default path and avoid passing an empty string.

**Update `FilterLink.js` Implementation**

In our current implementation, the `FilterLink` component dispatches an action every time that it's clicked, then reads its active state from the store and compares its `filter` prop to the `visibilityFilter` in the store.

**`FilterLink.js` Before**


{% highlight js linenos %}
...
const mapStateToProps = (state, ownProps) => ({
  active: ownProps.filter === state.visibilityFilter,
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick() {
    dispatch(setVisibilityFilter(ownProps.filter));
  },
});

const FilterLink = connect(
  mapStateToProps,
  mapDispatchToProps
)(Link);

export default FilterLink;
{% endhighlight %}

However, we no longer need this implementation since we want the router to be in control of any state that is in the URL. We'll import `Link` from `react-router` and use it in our new implemenation.

`FilterLink` now accepts `filter` as a prop, and render it through React Router's `Link`.

The `to` prop corresponds to path we want the link to point to , so if the `filter` is `all`, we're going to use the root path, otherwise we will use `filter` itself as the URL's path.

We also will use the `activeStyle` prop to style it differently when its `to` prop matches the current path. We pass `children` to the `Link` itself, and add `children` as a prop to `FilterLink` so that the parent component can specify the children.

**`FilterLink.js` After**

{% highlight js linenos %}
import React, { PropTypes } from 'react';
import { Link } from 'react-router';

const FilterLink = ({ filter, children }) => (
  <Link
    to={filter === 'all' ? '' : filter}
    activeStyle={{
      textDecoration: 'none',
      color: 'black',
    }}
  >
    {children}
  </Link>
);

FilterLink.propTypes = {
  filter: PropTypes.oneOf(['all', 'completed', 'active']).isRequired,
  children: PropTypes.node.isRequired,
};

export default FilterLink;
{% endhighlight %}

**More Cleanup to Do...**

We are no longer using the `setVisibilityFilter` action creator, so it can be removed from `src/action/index.js`, leaving us with just `addTodo` and `toggleTodo` action creators.

We can also delete our custom `Link` component from `src/components` since we are now using the one provided by `react-router`.

#### 3.2.3 Filtering Redux State with React Router Params

Now we're using the `Link`s provided by React Router, so when we click a link the URL gets updated. However, the content doesn't get updated because the visible `TodoList` component in its `mapStateToProps` function still depends on the `visibilityFilter` in the Redux store instead of reading it from the URL.

**`mapStateToProps` Before**

{% highlight js linenos %}
const mapStateToProps = (state) => ({
  todos: getVisibleTodos(
    state.todos,
    state.visibilityFilter
  )
})

{% endhighlight %}

In order to fix this, we'll add an argument `ownProps`, and we'll read the `visibilityFilter` from `ownProps`.

**`mapStateToProps` After**

{% highlight js linenos %}
const mapStateToProps = (state, ownProps) => ({
  todos: getVisibleTodos(
    state.todos,
    ownProps.filter
  )
})
{% endhighlight %}

We will also update our `getVisibleTodos` function to use our current convention for filter props `all`, `completed`, and `after`.

**`getVisibleTodos` Before:**
{% highlight js linenos %}
const getVisibleTodos = (todos, filter) => {
  switch (filter) {
    case 'SHOW_ALL':
      return todos;
    case 'SHOW_COMPLETED':
      return todos.filter(t => t.completed);
    case 'SHOW_ACTIVE':
      return todos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

**`getVisibleTodos` After**

{% highlight js linenos %}
const getVisibleTodos = (todos, filter) => {
  switch (filter) {
    case 'all':
      return todos;
    case 'completed':
      return todos.filter(t => t.completed);
    case 'active':
      return todos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

**updating `App.js`**

Since the `VisibleTodoList` component gets rendered from the app, we need to add the `filter` prop to make it available in the `mapStateToProps` function of the `VisibleTodoList`.

We want the filter prop to correspond to the current `filter` parameter in our route configuration (the `path='/(:filter)'`). Since the `filter` param is empty on the root path, we'll pass `all` to `VisibleTodoList` as a fallback.

{% highlight js linenos %}
const App = ({ params }) => (
  <div>
    <AddTodo />
    <VisibleTodoList
      filter={params.filter || 'all'}
    />
    <Footer />
  </div>
);
{% endhighlight %}

Now that our visibility filters are managed by React Router, we no longer need the `visibilityFilter` reducer. We can delete it, and also remove it from the `combineReducers()` declaration in `index.js`.

#### 3.2.4 Using `withRouter()` to Inject the Params into Connected Components

Currently we are reading `params.filter` passed by the Router inside of the `App` component. We can access the params from ther because the router injects the `params` prop into any Route handler component specified in the route configuration. In this case, the `filter` is passed inside `params`.

However, the `App` component itself doesn't use `filter`, it just passes it to `VisibleTodoList`, which uses it to calculate the currently visible Todos.

Passing the `params` from the top level of Route Handlers gets tedious, so we'll remove the `filter` prop. Instead, we'll find a way to read the current Router `params` in the `VisibleTodoList` itself.

**`App.js` Before:**

{% highlight js linenos %}
const App = ({ params }) => (
  <div>
    <AddTodo />
    <VisibleTodoList
      filter={params.filter || 'all'}
    />
    <Footer />
  </div>
);
{% endhighlight %}

**`App.js` After: **

{% highlight js linenos %}
const App = () => (
  <div>
    <AddTodo />
    <VisibleTodoList />
    <Footer />
  </div>
);
{% endhighlight %}

**Updating `VisibleTodoList`**

We will start by importing `withRouter` from React Router (version 3+):

`import { withRouter} from 'react-router'`

`withRouter` takes a React component and returns a different React component that injects the router-lated props such as `params` into your component.

We want `params` to be available inside of `mapStateToProps`, so we need to wrap the `connect()` results so that the connected component gets the `params` as a prop.

We will also need to change `mapStateToProps` to read the `filter` from `ownProps.params` instead of `ownProps` direclty.

**`VisibleTodoList` Before**

{% highlight js linenos %}
const mapStateToProps = (state, ownProps) => ({
  todos: getVisibleTodos(
    state.todos,
    ownProps.filter
  ),
});

// mapDispatchToProps ...

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList);
{% endhighlight %}

**`VisibleTodoList` After**

{% highlight js linenos %}
const mapStateToProps = (state, ownProps) => ({
  todos: getVisibleTodos(
    state.todos,
    ownProps.params.filter || 'all'),
});

// mapDispatchToProps ...

const VisibleTodoList = withRouter(connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList));
{% endhighlight %}

We can make `mapStateToProps` even more compact by reading `params` directly from the argument definition thanks to the ES6 destructuring syntax:

{% highlight js linenos %}
const mapStateToProps = (state, { params }) => ({
  todos: getVisibleTodos(state.todos, params.filter || 'all'),
});
{% endhighlight %}

### 3.3 Selector & Normalizing State Shape ###

#### 3.3.1 Using `mapDispatchToProps()` Shorthand Notation

The `mapDispatchToProps` function lets us inject certain props into the React component that can dispatch actions. For example, the `TodoList` component calls its `onTodoClick` callback prop with the `id` of the `todo`.

**Inside `TodoList`**

{% highlight js linenos %}
<Todo
    key={todo.id}
    {...todo}
    onClick={() => onTodoClick(todo.id)}
/>
{% endhighlight %}

Inside `mapDispatchToProps` in our `VisibleTodoList` component we specify that when `onTodoClick()` is called with an `id`, we want to dispatch the `toggleTodo` action with this `id`. The `toggleTodo` action creator uses this `id` to generate an action object that will be dispatched.

**`VisibleTodoList` `mapDispatchToProps` Before**

{% highlight js linenos %}
const mapDispatchToProps = (dispatch) => ({
  onTodoClick(id) {
    dispatch(toggleTodo(id));
  },
});

const VisibleTodoList = withRouter(connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList));
{% endhighlight %}

When the arguments for the callback prop match the arguments to the action creator exactly, there is a shorter way to specify `mapDispatchToProps`. Rather than pass a function, we can pass an object mapping of the names of the callback props that we want to inject and the action creator functions that create the corresponding actions.

This is a rather common case, so often you don't need to write `mapDispatchToProps`, and you can pass this map in object instead.

**`VisibleTodoList` After:**

{% highlight js linenos %}
const VisibleTodoList = withRouter(connect(
  mapStateToProps,
  { onTodoClick: toggleTodo }
)(TodoList));
{% endhighlight %}

#### 3.3.2 Colocating Selectors with Reducers

Inside of `VisibleTodoList`, the `mapStateToProps` function uses the `getVisibleTodos` function, and it passes the slice of the `state` corresponding to the `todos`. However, if we ever change the state's struccture, we have to remember to update this whole side.

In order to clean this up, we can move the `getVisibleTodos` function our of the view layer and place it inside of the file that contains our `todos` reducer. We do this because the `todos` reducr knows the most about the internal structure of the state's `todos`.

**`VisibleTodoList` Before**

{% highlight js linenos %}
const getVisibleTodos = (todos, filter) => {
  switch (filter) {
    case 'all':
      return todos;
    case 'completed':
      return todos.filter(t => t.completed);
    case 'active':
      return todos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};

const mapStateToProps = (state, { params }) => ({
  todos: getVisibleTodos(state.todos, params.filter || 'all'),
});
{% endhighlight %}

**Updating our Reducer**

We are going to move our `getVisibleTodos` implementation into the file with the reducers, and make it a named export.

The convention we follow is simple. The default export is always the reducer function, but any named export starting with `get` is a function that prepares the data to be displayed by the UI. We usually call these functions selectors because they select something from the current state.

In the reducers, the `state` argument corresponds to the state of this particular reducer, so we wil folllow the same convention for slectors. The `state` argument corresponds to the state of the xported reducer in this file.

**Inside `src/reducers/todos.js`**

{% highlight js linenos %}
export const getVisibleTodos = (state, filter) => {
  switch (filter) {
    case 'all':
      return state;
    case 'completed':
      return state.filter(t => t.completed);
    case 'active':
      return state.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

**Updating the Root Reducer**

In side of `VisibleTodoList` we still depend on the state structure because we read the `todos` from the state, but the actual method of reading `todos` may change in the future. With this in mind, we are going to udpate our root reducer with a named selector export. It will also be called `getVisibleTodos`, and like before it also accepts `state` and `filter`. However, in this case `state` corresponds to the state of the combine dreducer. Now we want to be able to call the `getVisibleTodos` function defined in the `todos` file alongside the reducer, but we can't use a named import because there is a function with exactly the same name in the scrope. To work around this, we will use the name space import syntax that puts all the exports on an object (called `fromTodos` in this case). Now we can use `fromTodos.getVisibleTodos()` to call the function we defined in the other file, and pass the slice of the `state` corresponding to the `todos`.

**Root Reducer Update (`src/reducers/index.js`)**

{% highlight js linenos %}
mport { combineReducers } from 'redux';
import todos, * as fromTodos from './todos';

const todoApp = combineReducers({
  todos,
});

export default todoApp;

export const getVisibleTodos = (state, filter) =>
  fromTodos.getVisibleTodos(state.todos, filter);
{% endhighlight %}

**Updating `VisibleTodoList`**

Now we can go back to our `VisibleTodoList` component and import `getVisibleTodos` from the root reducer file.

`import { getVisibleTodos } from '../reducers'`

`getVisibleTodos` encapsulates all the knowledge about the application state shae, so we can just pass it the whole state of our application and it will figure out how to select the visible todos according to the logic described in our selector.

Finally, we can refer back to our `mapStateToProps` mapping function and call `getVisibleTodos()` with the entire state, rather than with `state.todos` like we used to (this logic has been moved to the reducer):

{% highlight js linenos %}
const mapStateToProps = (state, { params }) => ({
      todos: getVisibleTodos(state, params.filter || 'all' )
  });
{% endhighlight %}

#### 3.3.3 Normalizing the State Shape

We currently represent the `todos` in the state tree as an array of `todo` objects. However, in the real app we would probably have more than a single array, and `todos` with the same `id`s in different arays might get ourt sync.

**`todos.js` Before**

{% highlight js linenos %}
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        todo(undefined, action),
      ];
    case 'TOGGLE_TODO':
      return state.map(t =>
        todo(t, action)
      );
    default:
      return state;
  }
};
{% endhighlight %}

**Refactoring `todos.js`**

We should treat our state as a database, so we are going to keep `todos` in an object indexed by `id`. We will start by renaming the reducer to `byId`. Now, rather than adding a new item at the end or mapping over every item, we will change the value in the lookup table. Now both `TOGGLE_TODO` and `ADD_TODO` have the same logic. We want to return a new lookup table where the value of `action.id` is going to be the result of calling the reducer on the previous `action.id` value and the `action`. 

{% highlight js linenos %}
const byId = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_TODO':
    case 'TOGGLE_TODO':
      return {
        ...state,
        [action.id]: todo(state[action.id], action),
      };
    default:
      return state;
  }
};
{% endhighlight %}

This is still reducer composition, but with an object instead of an array. Anytime the `byId` reducer receives an action, it's going to return a copy of its mapping between the `id` s and the actual todos with an updated `todo` for the current action.

Now we'll add another reducer that keeps track of all the added `id`s. 

**Adding an `allIds` Reducer** 

Now that we keep the todos themselves in the `byId` map, we will have the state of this reducer be an array of `id`s. This reducer will switch on the action's type, and the only action I care about is `ADD_TODO` because if a new todo is added, we want to return a new array of `id`s with the new `id` as the last item.

For any other actions, we just need to return the current state (which is the current array of `id`s).

{% highlight js linenos %}
const allIds = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [...state, action.id];
    default:
      return state;
  }
};
{% endhighlight %}

We still need to export the single reducer from the `todos.js` file, so we use `combineReducers()` again to combine the `byId` and the `allIds` reducers.

{% highlight js linenos %}
const todos = combineReducers({
  byId,
  allIds,
});
{% endhighlight %}

Note: You can use combined reducers as many times as you like. You don't have to only use it on the top-level reducer. In fact, it's very common that as your app grows, you'll use `combineReducers` in several places.

**Updating the `getVisibleTodos` Selector**

Now that we have changed the state shape in our reducers, we also need to update the selectors that rely on it. The `state` object in `getVisibleTodos` is now going to contain `byId` and `allIds` fields, because it corresponds to the `state` of the combined reducer. Since we don't use an array of todos anymore, we will write a `getAllTodos` selector to create the array for us. `getAllTodos` will take the current `state` and return all `todos` by mapping `allIds` to the `state`'s `byId` lookup table. We won't export `getAllTodos` because it will only be used in the current file.

{% highlight js linenos %}
const getAllTodos = (state) =>
  state.allIds.map(id => state.byId[id]);
{% endhighlight %}

We will use this new selector inside our `getVisibleTodo` selector to obtain an array of todos that can vbe filtered. `allTodos` is an array of todos just like the components expect, so we can return it from the selector and not worry about changing component coe.

{% highlight js linenos %}
export const getVisibleTodos = (state, filter) => {
  const allTodos = getAllTodos(state);
  switch (filter) {
    case 'all':
      return allTodos;
    case 'completed':
      return allTodos.filter(t => t.completed);
    case 'active':
      return allTodos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

**Extracting the `todo` Reducer**

The `todos.js` file has grown quite a bit, so it's a good time to extract the todo reducer that manages a single todo into a separate file of its own. We will create a file called `todo.js` in the same `src/reducers` folder, paste in the implementation. Now we can import it into the `todos.js` file.

**`todo.js`**

{% highlight js linenos %}
const todo = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        id: action.id,
        text: action.text,
        completed: false,
      };
    case 'TOGGLE_TODO':
      if (state.id !== action.id) {
        return state;
      }
      return {
        ...state,
        completed: !state.completed,
      };
    default:
      return state;
  }
};
export default todo;
{% endhighlight %}

**`todos.js`**

{% highlight js linenos %}
import { combineReducers } from 'redux';
import todo from './todo';

const byId = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_TODO':
    case 'TOGGLE_TODO':
      return {
        ...state,
        [action.id]: todo(state[action.id], action),
      };
    default:
      return state;
  }
};

const allIds = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [...state, action.id];
    default:
      return state;
  }
};

const todos = combineReducers({
  byId,
  allIds,
});

export default todos;

const getAllTodos = (state) =>
  state.allIds.map(id => state.byId[id]);

export const getVisibleTodos = (state, filter) => {
  const allTodos = getAllTodos(state);
  switch (filter) {
    case 'all':
      return allTodos;
    case 'completed':
      return allTodos.filter(t => t.completed);
    case 'active':
      return allTodos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

### 3.4 Middleware `applyMiddleware()` from `'react-redux'`####

#### 3.4.1 Wrapping `dispatch()` to Log Actions

Now that our state shape is more complex, we want to override the `store.dispatch` function to add some `console.log()` statements so we can see how the state is affected by the actions. We'll start by creating a new function called `addLogging ToDispatch` that accepts `store` as an argument. It's going to wrap the `dispatch` provided by Redux, so it reads the raw dispatch from `store.dispatch`. `addLoggingToDispatch()` will return another function with the same signature as dispatch, which is a single action argument. Some browsers like Chrome support using `console.group()` to group several log statements under a single title, and we're passing in `action.type` in order to group several logs under the action type. We will log the previous `state` before dispatching the action by calling `store.getState()`. Next, we will log the action itself so that we can see which action causes the change. To preserve the contract of the `dispatch` function exactly, we'll delcare `returnValue` and call the `rawDispatch()` function with the action. Now the calling code will not be able to distinguish between our function and the fucntion provided by Redux, except that we are also logging some information. We log the next state as well, because the store is guaranteed to be updated afgter the dispatch is called. We can use `sotre.getState()` in order to receive the next state afger the dispatch.

**`configureStore.js`**

{% highlight js linenos %}
const addLoggingToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  return (action) => {
    console.group(action.type);
    console.log('prev state', store.getState());
    console.log('action', action);
    const returnValue = rawDispatch(action);
    console.log('next state', store.getState());
    console.groupEnd(action.type);
    return returnValue;
  }
}

const configureStore = () => {
  const persistedState = loadState();
  const store = createStore(todoApp, persistedState);

  store.dispatch = addLoggingToDispatch(store);
  .
  .
  .
{% endhighlight %}

**Finishing Touches**

Chrome offers an API to style `console.log()`s, so we can add some colors to ourlogs. These modifications paint he previous state in gray, the action in blue, and the next state in green.

{% highlight js linenos %}
console.log('%c prev state', 'color: gray', store.getState());
console.log('%c action', 'color: blue', action);
const returnValue = rawDispatch(action);
console.log('%c next state', 'color: green', store.getState());
{% endhighlight %}

If the `console.group()` API is not available in all browsers, we just return raw dispatch as is.

{% highlight js linenos %}
// At the top of `addLoggingToDispatch()` after `rawDispatch` is declared
if (!console.group) {
  return rawDispatch
}
{% endhighlight %}

Since it's not a good idea to log everything in production, we add a gate inside of `configureStore()` saying that if `process.env.NODE_ENV` is not production, then we're going to run this code. Otherwise, we're just ogint to leave the store as is.

**Inside `configureStore`**

{% highlight js linenos %}
const configureStore = () => {
    const persistedState = loadState();
    const store = createStore(todoApp, persistedState);

    if (process.env.NODE_ENV !== 'production') {
      store.dispatch = addLoggingToDispatch(store);
    }
    .
    .
    .
{% endhighlight %}

Loggint the action we dispatch along with the state before and after dispatching it makes it easy to find any mistakes.

#### 3.4.2 Adding a Fake Backend to the Project

In the next lessons, we won't be dealing with persistence anymore. Instead, we're going to add some asynchronous fetching to the app. We are now removing all the code related to the `localStorage` persistence, and deleting the `localStorage.js` file as well, because a new module has been added that implements a fake remote API. All of the todos are kept in memory, and an artificial delay has been added. We also have methods that return Promises just like a real API implementation

**`src/api/index.js`**

{% highlight js linenos %}
import { v4 } from 'node-uuid';

// This is a fake in-memory implementation of something
// that would be implemented by calling a REST server.

const fakeDatabase = {
  todos: [{
    id: v4(),
    text: 'hey',
    completed: true,
  }, {
    id: v4(),
    text: 'ho',
    completed: true,
  }, {
    id: v4(),
    text: 'let’s go',
    completed: false,
  }],
};

const delay = (ms) =>
  new Promise(resolve => setTimeout(resolve, ms));

export const fetchTodos = (filter) => {
  return delay(500).then(()=>{
    switch (filter) {
      case 'all':
        return fakeDatabase;
      case 'active':
        return fakeDatabase.todos.filter(todo=>!todo.completed)
      case 'completed':
        return fakeDatabase.todos.filter(todo=>todo.completed)
      default:
        throw new Error(`Unknown filter:${filter}`)
    }
  })
}
{% endhighlight %}

This approach let us explore how Redux works with asynchronous data fetching without writing a real backend for the app. Now we will import `fetchTodos` into the different modules of our app.

`import { fetchTodos }` from './api'

We will learn how to put these todos into the Redux store later, but for now, we can call `fetchTodos` with a filter argument that will return a Promise that resolves through an array of todos, just like a REST backend would return an array.

**`index.js`**

{% highlight js linenos %}
fetchTodos('all').then(todos =>
  console.log(todos)
);
{% endhighlight %}

The fake API waits for half a second to simulate the network connection, and then resolves the promise to an array of todos that we will treat as if they were retrieved froma remote server.

#### 3.4.3 Fetching Data on Route Change

To start, we'll remove the `fetchTodos` test API call from our `index.js` entry point because we want to fetch the todos from inside our `VisibleTodoList` component. We'll start by importing `fetchTodos` into `VisibleTodoList.js`

`import { fetchTodos } from '../api';`

The `VisibleTodoList` component is generated by the `connect` and `withRouter` calls that each generate an intermediate component that injects props. A good place to call our `fetchTodos` API would be inside the `componentDidMount()` lifecycle hook. However, we can't override the life cycle hooks of generated components! This means we have to create a new React component.

**Creating a New React Component**

Inside of `VisibleTodoList.js`, we'll import `React` and the `Component` base class from React. We will then declare a React component class called `VisibleTodoList` that extends the base component class.

{% highlight js linenos %}
import React, { Component } from 'react';
// other imports...

class VisibleTodoList extends Component {
  render() {
    return <TodoList {...this.props} />;
  }
}
.
.
.
{% endhighlight %}

We still want to render the presentational `TodoList` component exactly as before. The only purpose of adding this new class is to add the lifecycle hooks. Any props will be passed down to the `TodoList`.

Now that `VisibleTodoList` is defined as a class above, we can't declare another constant with the same name, so we reassign the `VisibleTodoList` binding to point to the wrapped component. We'll also change the `connect()` call to wrap our new class instead.

{% highlight js linenos %}
VisibleTodoList = withRouter(connect(
  mapStateToProps,
  { onTodoClick: toggleTodo }
)(VisibleTodoList));
export default VisibleTodoList;
{% endhighlight %}

The component generated by the `connect()` call will render the `VisibleTodoList` class we defined. The result of the `connect` and `withRouter` wrapping calls is the final `VisibleTodoList` component that was export from the file.

**Adding Lifecycle Hooks**

When the component mounts, we want to tfetch the todos for the current filter. It will be convenient to have the filter directly available as a prop, so we change `mapStateToProps` to calculate the `filter` from `params` like it used to do, but we will also pass it as one of the properties of the `return` object. So now we'll get both the `todos` and the `filter` itself inside of the `VisibleTodoList` component.

**Updating `mapStateToProps`**

{% highlight js linenos %}
const mapStateToProps = (state, { params }) => {
  const filter = params.filter || 'all';
  return {
    todos: getVisibleTodos(state, filter),
    filter,
  };
};
{% endhighlight %}

Going back to the lifecycle method, we can use `this.props.filter` inside `componentDidMount.` When the todos are fetched, `fetchTodos` returns a Promise. We can use the `then` method to access the resolved `todos`, and log the current `filter` and the `todos` we just received from the fake backend.

**Implementing `componentDidMount`**

{% highlight js linenos %}
class VisibleTodoList extends Component {
  componentDidMount() {
    fetchTodos(this.props.filter).then(todos =>
      console.log(this.props.filter, todos)
    );
  }
{% endhighlight %}

With our current implementation, running the app will show the `all` filter being printed, and the corresponding `todos`. However, nothing will happend when filters are changed, because `componentDidMount` only runs once. To fix this, we need to add a second lifecycle hook called `componentDidUpdate`.

**Implementing `componentDidUpdate`**

{% highlight js linenos %}
// inside the `VisibleTodoList` below `componentDidMount()`
componentDidUpdate(prevProps) {
   if (this.props.filter !== prevProps.filter) {
     fetchTodos(this.props.filter).then(todos =>
       console.log(this.props.filter, todos)
     );
   }
 }
{% endhighlight %}

`componentDidUpdate` receives the previous props as an argument. We then compare the current and the previous values of the filter. If the current filter is not the same as the previous filter, we call `fetchTodos()` for the current filter.

#### 3.4.4 Dispatching Actions with the Fetched Data

Picking up where we left off inside of `VisibleTodoList`, we will extract the common code between the lifecycle hooks into a separate method called `fetchData`, where the data we want to fetch only depends on the filter. We call this method from the `componentDidMount()` hook in order to fetch the initial data. We will also call it whenever the `filter` changes inside the `componentDidUpdate` lifecycle hook.

**`VisibleTodoList.js`**

{% highlight js linenos %}
class VisibleTodoList extends Component {
  componentDidMount() {
    this.fetchData();
  }

  componentDidUpdate(prevProps) {
    if (this.props.filter !== prevProps.filter) {
      this.fetchData();
    }
  }

  fetchData() {
    fetchTodos(this.props.filter).then(todos =>
      console.log(this.props.filter, todos)
    );
  }
  .
  .
  .
{% endhighlight %}

**Updating `fetchData()`**

We want the fetched todos to become a part of the Redux store's `state`, and the only way to get something into the state is to dispatch an action. We'll have it call the callback prop `receiveTodos` with the `todos` we just fetched.

{% highlight js linenos %}
fetchData() {
  fetchTodos(this.props.filter).then(todos =>
    this.props.receiveTodos(todos)
  );
}
{% endhighlight %}

To make it available inside the component, we need to pass a function caleed `receiveTodos` that would be an action creator inside the second argument to `connect`. Since the name of the function matches the name of the callback prop, we can use the shorter ES6 Object property notation. We also will import `receiveTodos` from the file where all other action creators are defined. 

{% highlight js linenos %}
// At the top of `VisibleTodoList.js`
import { toggleTodo, receiveTodos } from '../actions'

...

// At the bottom of `VisibleTodoList.js`
VisibleTodoList = withRouter(connect(
  mapStateToProps,
  { onTodoClick: toggleTodo, receiveTodos }
)(VisibleTodoList))
{% endhighlight %}

**Implementing `receiveTodos`**

Now we need to actually implement `receiveTodos`. Inside of our action creators file, we creating a new export of a function`receiveTodos` that takes the server `response` as an argument and returns an object with the `type` of `RECEIVE_TODOS` and the response as a field.

{% highlight js linenos %}
export const receiveTodos = (filter, response) => ({
  type: 'RECEIVE_TODOS',
  filter,
  response,
});
{% endhighlight %}

**Updating the `VisibleTodoList` Component with `filter`**

Back in `VisibleTodoList`, we need to update `fetchData` to pass the filter through the action creator. We use the ES6 destructuring syntax to get the `filter` and `receiveTodos` from `props`. It's important that I destructure the `filter` right away, because by the time the callback fires, `this.props.filter` might have changed because the user might have navigated away.

**Inside `VisibleTodoList`**

{% highlight js linenos %}
fetchData() {
  const { filter, receiveTodos } = this.props;
  fetchTodos(filter).then(todos =>
    receiveTodos(filter, todos)
  );
}
{% endhighlight %}

#### 3.4.5 Wrapping `dispatch()` to Recognize Promises

The `receiveTodos` action creator is not very useful by itself because anytime we call it, we want to fetch the `todos` first. Since `fetchTodos` and `receiveTodos` accpet the same arguments, it would be great if we could group this code into a single aciton creator.

**Existing `fetchData()` inside `VisibleTodoList`**

{% highlight js linenos %}
fetchData() {
  const { filter, receiveTodos } = this.props;
  fetchTodos(filter).then(todos =>
    receiveTodos(filter, todos)
  );
}
{% endhighlight %}

**Refactoring our Action creators**

We'll get started by importing our fake API into our action creators file. `import * as api from '../api'`. Now we'll add an asynchronous action creator called `fetchTodos`. It takes `filter` as an argument, and then it calls the API's `fetchTodos` method with it. I'm using the Promise `then` method to transform the result of the Promise from the `response` to the action object generated by `receiveTodos` given the `filter` and the `response`.

{% highlight js linenos %}
export const fetchTodos = (filter) =>
  api.fetchTodos(filter).then(response =>
    receiveTodos(filter, response)
  );
{% endhighlight %}
`receiveTodos` returns an action object synchronously, but `fetchTodos` returns a Promise that resolves through the action obejct. Now can stop exporting `receiveTodos` from our action creators because we can change the components to use `fetchTodos` directly.

**Updating `VisibleTodoList`**

Back in our component file, we can use the `fetchTodos` prop injected by `connect`. This corresponds to the new asynchronous `fetchTodos` action creator we just wrote. We can remove `import { fetchTodos } from '../api'` because from now on we will be using the `fetchTodos` action creator which is ibjected into the props by `connect`.

{% highlight js linenos %}
fetchData() {
  const { filter, fetchTodos } = this.props;
  fetchTodos(filter);
}
{% endhighlight %}

**Recapping what we just did...**

The `fetchTodos` action creator calls the `fetchTodos` function from the API, but then it transforms its result into a Redux action generated by `receiveTodos`. However, by default, Redux only allows dispatching plain objects rather than Promises. We can teach it to recognize Promises by using the same trick that we used in `addLoggingToDispatch()` inside of `configureStore.js`(recall that the `addLoggintToDispatch` function takes the `dispatch` from the `store` and returns a new version of `dispatch` that logs every action and the `state`).

**Adding Promise Support**

Inside of `configureStore.js`, we will create a function `addPromiseSupport()` that takes the `store` and returns a version of `dispatch` that supports promises. First, we will grab the `rawDispatch` function at it is defined on the `store` so that we can call it later. We return a function that has the same API as a dispatch function -- that is, it takes an action.


{% highlight js linenos %}
const addPromiseSupportToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  return (action) => {
    if (typeof action.then === 'function') {
      return action.then(rawDispatch);
    }
    return rawDispatch(action);
  };
};
{% endhighlight %}

Since we don't know if the `action` is a real action or a promise of an action, we check if it has a `then` method that is a function. If it does, then we know it is a promise. If the action is a promise, we wait for it to resolve to an action object that we will pass through `rawDispatch`. Otherwise, we'll just call `rawDipsatch` right away with the `action` object we received. Our new `addPromiseSupportToDispatch` function allows us to dispatch both actions and promises that resolve to actions. To finish up, we need to call our new funciton one more time bedore returning the sotre to the app. 

{% highlight js linenos %}
// At the bottom of `configureStore.js`
const configureStore = () => {
  const store = createStore(todoApp);

  if (process.env.NODE_ENV !== 'production') {
    store.dispatch = addLoggingToDispatch(store);
  }

  store.dispatch = addPromiseSupportToDispatch(store);

  return store;
};
{% endhighlight %}

If we run the app now, we will still see the `RECEIVE_TODOS` action being dispatched when the response is ready. However, the component uses a more convenient API that encapsulates the asynchronous logic in the asynchronous action creator.

**Order Matters**

Remember that the order in which we override the `dispatch` function inside of `configureStore` is importnat. If we change it so that we call `addPromiseSupportToDispatch` before `addLoggingToDispatch`, the action will first be printed and then the promise will be processed. This would give us an action type of `undefined` and we see the Promise instead of the action, which is not very useful.

#### 3.4.6 The Middleware Chain

In our last lesson, we wrote two functions that wrap the `dispatch` function to add custom behavior. Let's take a closer look at how they work together.

{% highlight js linenos %}
const configureStore = () => {
  const store = createStore(todoApp);

  if (process.env.NODE_ENV !== 'production') {
    store.dispatch = addLoggingToDispatch(store);
  }

  store.dispatch = addPromiseSupportToDispatch(store);

  return store;
};
{% endhighlight %}

The final version of the `dispatch` function before returning the `store` is the result of calling `addPromiseSupportToDispatch`.

**`addPromiseSupportToDispatch` Before:**

{% highlight js linenos %}
const addPromiseSupportToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  return (action) => {
    if (typeof action.then === 'function') {
      return action.then(rawDispatch);
    }
    return rawDispatch(action);
  };
};
{% endhighlight %}

The function returned by `addPromiseSupport ToDispatch` acts like a normal `dispatch` function, but if it gets a Promise it waits for it to resolve, and then passes the result to `rawDispatch` (where `rawDispatch` is the revious value of `store.dispatch`).

For non-promises, the function calls `rawDispatch` right away. `rawDispatch` corresponds to store.dispatch at the time `addPromiseSupportToDispatch` was called.

**Refactoring our `dispatch` enhancing Functions**

Since `store.dispatch` was reassigned earlier (inside of `configureStore`), it's not completely fair to refer to it as `rawDispatch` inside of `addPromiseSupportToDispatch`.

We'll rename `rawDispatch` to `next`, because this is the next `dispatch` function in the chain.

**`addPromiseSupportToDispatch` After:**

{% highlight js linenos %}
const addPromiseSupportToDispatch = (store) => {
  const next = store.dispatch;
  return (action) => {
    if (typeof action.then === 'function') {
      return action.then(next);
    }
    return next(action);
  };
};
{% endhighlight %}

Above, `next` refers to the `store.dispatch` that was returned from `addLoggingToDispatch()`. Recall that our `addLoggingToDispatch()` function also returns a function with the same API as the original `dispatch` function, but it logs the action `type`, the previous `state`, the `action`, and the next `state` along the way. It calls `rawDispatch` which corresponds to `store.dispatch` at the time that `addLoggingToDispatch` was called. In this case, this is the `store.dispatch` provided by `createStore()` inside of `configureStore`. However, it is entirely  conceivable that we might want to override the `dispatch` function before adding the logging. For consistency, we will rename `rawDispatch` to `next` here as well. In this particular case, `next` points to the original `store.dispatch`.

**`addLoggingToDispatch()`**

{% highlight js linenos %}
const addLoggingToDispatch = (store) => {
  const next = store.dispatch;
  if (!console.group) {
    return next;
  }

  return (action) => {
    console.group(action.type);
    console.log('%c prev state', 'color: gray', store.getState());
    console.log('%c action', 'color: blue', action);

    const returnValue = next(action);

    console.log('%c next state', 'color: green', store.getState());
    console.groupEnd(action.type);
    return returnValue;
  };
};
{% endhighlight %}

**Introducing Middleware Functions**

While this method of extending the store works, it's not really great that we override the public API and replace it with custom functions. To get away from this pattern, we will declare an array of middleware functions, which is just a fancy name for the extra-functionality functions we wrote. This `middlewares` array will contain functions to be applied later as a single step. We'll push `addLoggingToDispatch` and `addPromiseSupportToDispatch` to the middleware array. Now we create a funciton `wrapDispatchWIthMiddlewares()` that takes the `store` as the first argument, and the array of middlewares as the second.

**Refactoring `configureStore`**

{% highlight js linenos %}
const configureStore = () => {
  const store = createStore(todoApp);
  const middlewares = [promise];

  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(logger);
  }

  wrapDispatchWithMiddlewares(store, middlewares);

  return store;
};
{% endhighlight %}

Inside of `wrapDispatchWithMiddlewares()` we're going to use `middlewares`'s `forEach` method to run some code for ever middleware. Specifically, we will override the `store.dispatch` function to point to the result of calling the middleware with the `store` as an argument.

{% highlight js linenos %}
const wrapDispatchWithMiddlewares = (store, middlewares) =>
  middlewares.forEach(middleware =>
    store.dispatch = middleware(store);
  );
{% endhighlight %}

Recall that inside of our middleware funcitons themselves, there is a certain pattern that we have to repeat. We grabbing the value of `store.dispatch` and store it in a variable called `next` that we call later. To make it a part of the midddleware contract, we can make `next` an outside argument, just like the `store` before it and the `action` after it.

**Updating `addLoggintToDispatch()`**

{% highlight js linenos %}
const addLoggingToDispatch = (store) => {
  return (next) => {
    if (!console.group) {
      return next;
    }

    return (action) => {
      console.group(action.type);
      console.log('%c prev state', 'color: gray', store.getState());
      console.log('%c action', 'color: blue', action);

      const returnValue = next(action);

      console.log('%c next state', 'color: green', store.getState());
      console.groupEnd(action.type);
      return returnValue;
    };
  }
};
{% endhighlight %}

With this change, the middleware becomes a function that returns a function that returns a function. This pattern is called **currying**. This is not very common in JavaScript, but is actually very commmon in functional programming languages.

**Updating `addPromiseSupportToDispatch`:**

{% highlight js linenos %}
const addPromiseSupportToDispatch = (store) => {
  return (next) => {
    return (action) => {
      if (typeof action.then === 'function') {
        return action.then(next);
      }
      return next(action);
    };
  }
};
{% endhighlight %}

Again, rather than take the next middleware from the store, we will make it injectable as an argument so that the function that calls the middlewares can choose which middleware to pass. Finally, since `store` is not the only injected argument, we also need to inject the next middleware, which is the previous value of `store.dispatch`

**Updating `wrapDispatchWithMiddlewares`**

{% highlight js linenos %}
const wrapDispatchWithMiddlewares = (store, middlewares) =>
  middlewares.slice().reverse().forEach(middleware => {
    store.dispatch = middleware(store)(store.dispatch);
  });
{% endhighlight %}

Now that middlewares are a first-class concept, we can rename `addLoggintToDispatch` to just `logger`, and rename `addPromiseSupportToDispatch` to `promise`

**Arrow-ifying our `promise` Middleware**

The curreid style of function declaration can get very hard to read. Luckily we can use arrow functions and rely on the fact that they can have expression as their bodies.


{% highlight js linenos %}
// Before
const addPromiseSupportToDispatch = (store) => {
  return (next) => {
    return (action) => {
      if (typeof action.then === 'function') {
        return action.then(next);
      }
      return next(action);
    };
  }
};

// After
const promise = (store) => (next) => (action) => {
  if (typeof action.then === 'function') {
    return action.then(next);
  }
  return next(action);
}
{% endhighlight %}

{% highlight js linenos %}
{% endhighlight %}

It is still a function that returns a function returning a function, but it's much easier to read. The mental model you can use for this is "this is just a fucntion with several arguments that are applied as theybecome available".

**Wrapping up Middlewares**

Our middlewares are currently specified in the order in which the `dispatch` fucntion is overridden, but it would be more natural to specify the order in which the action propagates through the middlewares.

We will change our middleware declaration to specify them in the order in which the aciton travels through them:

{% highlight js linenos %}
const configureStore = () => {
  const store = createStore(todoApp);
  const middlewares = [promise];
  .
  .
  .
{% endhighlight %}

We will also `wrapDispatchWithMiddlewares` from right to left by cloning the past array then reversing it.

{% highlight js linenos %}
const wrapDispatchWithMiddlewares = (store, middlewares) =>
  middlewares.slice().reverse().forEach(middleware => {
    store.dispatch = middleware(store)(store.dispatch);
  });
{% endhighlight %}


#### 3.4.7 Applying Redux Middleware

In the previous lesson, we figured out the contract that we want to use for our middleware functions. However, middleware wouldn't be very useful if everybody had to implement `wrapDispatchWithMiddlewares` on their own. Now we'll remove it, and instead import a utility called `applyMiddleware` from Redux.

**`configureStore` Before:**

{% highlight js linenos %}
const configureStore = () => {
  const store = createStore(todoApp);
  const middlewares = [promise];

  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(logger);
  }

  wrapDispatchWithMiddlewares(store, middlewares);

  return store;
};
{% endhighlight %}

Looking at our `configureStore` function, notice that we don't need the `store` right away. We can move the creation of the `store` down below where we specify the middleware. We can also remove our custom `wrapDispatchWithMiddlewares` function, and instead we will `createStore` with the middleware right away. The second argument to create store will be the result of calling `applyMiddleware` with my middleware functions as positional arguments. This last argument to `createStore` is called an enhancer, and it's optional. If you want to specify the `persistedState`, you need to do this before the enhancer (you can also skip the `persistedState` if you don't have it).

**`configureStore` After**

{% highlight js linenos %}
// We also deleted `wrapDispatchWithMiddlewares()`

const configureStore = () => {
  const middlewares = [promise];
  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(createLogger());
  }

  return createStore(
    todoApp,
    applyMiddleware(...middlewares)
  );
};
{% endhighlight %}

**Replacing our Custom Middleware**

Many middlewares are available as npm packages. Both the `promis` and `logger` middlewares that we wrote are no exceptions to this. Running `npm install --save redux-promise` in a terminal will install a middleware that implements Promise support. You can install a package called `redux-logger` in the same way, which is similar to the logger middleware we wrote before, but it's more configurable. Inside of `configureStore.js`, we can now import and use our new middleware. Since we don't need to reference the `store` anymore, we can just return it directly from `configureStore`.

**Updated `configureStore.js`**

{% highlight js linenos %}
import { createStore, applyMiddleware } from 'redux';
import promise from 'redux-promise';
import createLogger from 'redux-logger';
import todoApp from './reducers';

const configureStore = () => {
  const middlewares = [promise];
  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(createLogger());
    // Note: you can supply options to `createLogger()`
  }

  return createStore(
    todoApp,
    applyMiddleware(...middlewares)
  );
};

export default configureStore;
{% endhighlight %}

### 3.5 Thunk via `'redux-thunk'`###

#### 3.5.1 Updating the State with the Fectehd Data

In the current implementation of `getVisibleTodos` inside of `todos.js`, we keep all todos in memory. We have an array of all `id` s ever and we get the array of todos that we can filter according to the filter passed from React Router.

**Current `getVisibltTodos`**

{% highlight js linenos %}
export const getVisibleTodos = (state, filter) => {
  const allTodos = getAllTodos(state);
  switch (filter) {
    case 'all':
      return allTodos;
    case 'completed':
      return allTodos.filter(t => t.completed);
    case 'active':
      return allTodos.filter(t => !t.completed);
    default:
      throw new Error(`Unknown filter: ${filter}.`);
  }
};
{% endhighlight %}

However, this only works correctly if all the data from the server is already available in the client, which is usually not the case with applications that fetch something. If we have thousands of todos on the server, it would be impractical to fetch them all and filter them on the client.

**Refactoring `getVisibleTodos`**

Rather than keep one big list of `id`s, we'll keep a list of `id`s for every filter's tab so that they can be stored separately and filled according to the actions with the fetched data. We'll remove the `getAllTodos` selector because we won't have access to `allTodos`. We also don't need to filter on the cilent anymore because we will use the list of todos provided by the server. This means we can remove our `switch` statement from the current implementation. Instead of reading from `state.allIds`, we will read the IDs from `state.IdsByFilter[filter]`. Then we will map the `id`s to the `state.ById` lookup table to get the actual todos.

**Updated `getVisibleTodos`**

{% highlight js linenos %}
export const getVisibleTodos = (state, filter) => {
  const ids = state.idsByFilter[filter];
  return ids.map(id => state.byId[id]);
};
{% endhighlight %}

**Refactoring `todos`**

The selector now expects `idsByFilter` and `byId` to be part of the combiend `state` of the `todos` reducer.

**`todos` Reducer Before:**

{% highlight js linenos %}
const todos = combineReducers({
  byId,
  allIds
});
{% endhighlight %}

The `todos` reducer used to combine the lookup table and a list of `allIds`. Now, though, we'll replace the list of `allIds` with the list of `idsByFilter`, which will be a new combined reducer.

**`todos` Reducer After:**

{% highlight js linenos %}
const todos = combineReducers({
  byId,
  idsByFilter
});
{% endhighlight %}

**Creating `idsByFilter`**
`idsByFilter` combines a separate list of `id`s for every filter. So it's `allIds` for the `all` filter, `activeIds` for the `active` filter, and `completedIDs` for the `completed` filter.

{% highlight js linenos %}
const idsByFilter = combineReducers({
  all: allIds,
  active: activeIds,
  completed: completedIds,
});

const allIds = (state=[],action) =>{
  if(action.filter !== 'all'){
    return state
  }
  switch (action.type) {
    case 'RECEIVE_TODOS':
      return action.response.map(todo=>todo.id)
    default:
      return state;
  }
}

const activeIds = (state=[],action) =>{
  if(action.filter !== 'active'){
    return state
  }
  switch (action.type) {
    case 'RECEIVE_TODOS':
      return action.response.map(todo=>todo.id)
    default:
      return state;
  }
}

const completedIds = (state=[],action) =>{
  if(action.filter !== 'completed'){
    return state
  }
  switch (action.type) {
    case 'RECEIVE_TODOS':
      return action.response.map(todo=>todo.id)
    default:
      return state;
  }
}
{% endhighlight %}

**Updating the `byId` Reducer**

Now that we have reducers that managing the `id`s, we need to update the `byId` reducer to actually handle the new `todos` from the response.

**`byId`**

{% highlight js linenos %}
//before
const byId = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_TODO':
    case 'TOGGLE_TODO':
      return {
        ...state,
        [action.id]: todo(state[action.id], action),
      };
    default:
      return state;
  }
};

//after
const byId = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TODOS': // eslint-disable-line no-case-declarations
      const nextState = { ...state };
      action.response.forEach(todo => {
        nextState[todo.id] = todo;
      });
      return nextState;
    default:
      return state;
  }
};
{% endhighlight %}
Note: normally the assignment oepration is a mutation. However, in this case it's fine because `nextState` is a shallow copy, and we're only assigning one level deep. Our function stays pure becuase we're not modifying any of the original state objects.

As the last step, we can remove the import of `todo.js` as well as the file itself from our project, because the logi for adding and toggling todos will be implemented as API calls to the server in the future lessons.


#### 3.5.2 Refactoring the Reducers

Earlier, we removed the `visibilityFilter` reducer, and so the root reducer in the app now combines only a single `todos` reducer. Since `index.js` acts effectively as a proxy to the `todos` reducer, we will remove `index.js` completely. Then we will rename `todos.js` to `index.js` , there by making `todos` the new root reducer. The root reducer file now contains `byId`, `allIds`,`activeIds` and `completedIds`. We're going to extract some of them into separate files. Creating a file called `byId.js` where we paste the code for the `byId` reducer. Now we'll add a named exporrt for a selector called `getTodo` that takes the `state` and `id`, where the state corresponds to the state of the `byId` reducer. Now going back to `index.js`, we can import the reducer as a default import. We can also import any associated selectros in a single object with a namespace import `import byId, * as fromById from './byid'`. Now if we take a look at the reducers managing the IDs, we will notice that their code is almost exactly the same except for the filter value which they compare `action.filter` to. 

**Creating `createList`**

Let's create a new function called `createList` that takes `filter` as an argument. `createList` will return another function , a reducer that handles the `id`s for the specified filter (a reducer creator, analogy to action creator).

{% highlight js linenos %}
const createList = (filter) => {
  return (state = [], action) => {
    if (action.filter !== filter) {
      return state;
    }
    switch (action.type) {
      case 'RECEIVE_TODOS':
        return action.response.map(todo => todo.id);
      default:
        return state;
    }
  };
};
{% endhighlight %}

Now we can remove the `allIds`, `activeIds`, and `completedIds` reducer code completely. Instead, we will generate the reducers using the new `createList` function, and pass the filter as an argument to it.

Next, extract the `createList` function into a separate file called `createList.js`.

Now that it's in a separate file, we will add a public API for accessing the state in form of a selector. For now, we will call it `getIds`, and will just returns the state of the list (we may change this in the future).

**Finishing Up**

Back in `index.js`, we will import `createList` and any named selectors from this file.

{% highlight js linenos %}
import createList, * as fromList from './createList';
{% endhighlight %}

We will also rename `idsByFilter` to `listByFilter` because now that the list implementation is in a separate file, we will use the `getIds` selector that it exports.

{% highlight js linenos %}
export const getVisibleTodos = (state, filter) => {
  const ids = fromList.getIds(state.listByFilter[filter]);
  return ids.map(id => fromById.getTodo(state.byId, id));
};
{% endhighlight %}

Since we also moved the `byId` reducer into a separate file, we want to make sure we don't make an assumption that it's just a lookup table. With this in mind, we will use the `fromById.getTodo` selector that it exports and pass its state and the corresponding ID.

With this refactor, we can change the state shape of any reducer in the future without rippling changes across the codebase.

#### 3.5.3 Displaying Loading Indicators

When the data is fetched asynchronously, we want to display some kind  of visual cue to the user. We'll add a condition to the `render` function that says that if we're fetching data, and we have no to-dos ti sgiwm we'll return a loading indicator from the `render` function of `VisibleTodoList`. We will grab `todos` and `isFetching` from `props`. Since `todos` is the only extra prop we need to pass to the list, instead of using the spread operator, we will just pass the `todos` directly. Our `mapStateToProps` function already calculates `visibleTodos` and includes the `todos` in the props. We need to do something similar for `isFetching`. `getIsfetching` accepts the current `state` of the app, and the `filter` for the `todos` being fetched. It is declared alongside other top level selectors in the top level reducer file.

**Inside `VisibleTodoList.js`**

{% highlight js linenos %}
render() {
    const { isFetching, toggleTodo, todos } = this.props;
    if (isFetching && !todos.length) {
      return <p>Loading...</p>;
    }

    return (
      <TodoList
        todos={todos}
        onTodoClick={toggleTodo}
      />
    );
  }

  /// PropType Declarations...

  const mapStateToProps = (state, { params }) => {
    const filter = params.filter || 'all';
    return {
      isFetching: getIsFetching(state, filter),
      todos: getVisibleTodos(state, filter),
      filter,
    };
  };
{% endhighlight %}

**Updating the Root Reducer**

Switching to our root reducer file (`src/reducers/index.js`) we will add another exported anmed selector funciton for `getIsFetching`. It accepts the `state` and the `filter` as argument, and it delegates to another selector to find if the list is currently being fetched. We will pass in the state of this list from `state.listByFilter`, but we haven't written `getIsFetching` yet.

{% highlight js linenos %}
export const getIsFetching = (state, filter) =>
  fromList.getIsFetching(state.listByFilter[filter]);
{% endhighlight %}

**Updating `createList.js`**

Before creating our new `getIsFetching` selector, we need to modify the state shape of the list. Rather than assume `state` is an array of `id`s, we will assume it is an object that contains this array as a property. Now we can add another selector called `getIsFetching` that reads `state.isFetching`.


{% highlight js linenos %}
export const getIds = (state) => state.ids;
export const getIsFetching = state => state.isFetching;
{% endhighlight %}

We want our reducer to keep track of both of these fields, so rather than complicate the existing `createList` reducer, we will rename it to `ids`, becuase it manages just the `id`s.

**Creating `isFetching` Inside `createList.js`**

{% highlight js linenos %}
const isFetching = (state = false, action) => {
    if (filter !== action.filter) {
      return state;
    }
    switch (action.type) {
      case 'REQUEST_TODOS':
        return true;
      case 'RECEIVE_TODOS':
        return false;
      default:
        return state;
    }
  };
{% endhighlight %}

**Adding the 'REQUEST_TODOS' Action Creator in `src/actions/index.js`**

{% highlight js linenos %}
export const requestTodos = (filter) => ({
  type: 'REQUEST_TODOS',
  filter,
});
{% endhighlight %}

**Updating `fetchData` inside `VisibleToDoList`**

We can destructure `requestTodos` from the `props`, and call it right before starting the asynchronous `fetchTodos` operation.

{% highlight js linenos %}
fetchData() {
  const { filter, fetchTodos, requestTodos } = this.props;
  requestTodos(filter);
  fetchTodos(filter);
}
{% endhighlight %}



#### 3.5.4 Dispatching Actions Asynchronously with Thunks

To show the loading indicator in our current implementation, we dispatch the `requestTodos` action before we fetch the todos with `fetchTodos`. It would be great if we could make `requestTodos` dispatch automatically when we fetch the todos because we never want them to fire separately.

**`VisibleTodoList.js` Before**

{% highlight js linenos %}
// inside of `VisibleTodoList`
fetchData() {
  const { filter, fetchTodos, requestTodos } = this.props;
  requestTodos(filter);
  fetchTodos(filter);
}
{% endhighlight %}

To start, we will remove the explicit `requestTodos` dispatch from the component. Now we no longer need to `export` the `requestTodos` action creator inside of `action/index.js` (but don't erase the code for it).

Our goal is to dispatch `requestTodos()` when we start fetching, and `receiveTodos()` when they finish fetching, but our `fetchTodos` action creator only resolves through the `receiveTodos` action.

**Current `fetchTodos` Action Creator**

{% highlight js linenos %}
export const fetchTodos = (filter) =>
  api.fetchTodos(filter).then(response =>
    receiveTodos(filter, response)
  );
{% endhighlight %}

An action Promise resolves through to a single action at the end, but we want an **abstraction that represents multiple actions dispatched over a period of time**. This is why rather than returning a Promise, I want to return a function that accepts a dispatch **callback** argument. (Thunk actually means return a function that takes callback(s) as the input parameters).

This change lets us call `dispatch()` as many times as we want at any point of time during the async operation. We can dispatch the `requestTodos` action in the beginning, then when the Promise resolves we can explicitly dispatch another `receiveTodos` action.

**Updated `fetchTodos`**

{% highlight js linenos %}
export const fetchTodos = (filter) => (dispatch) => {
  dispatch(requestTodos(filter));

  return api.fetchTodos(filter).then(response => {
    dispatch(receiveTodos(filter, response));
  });
};
{% endhighlight %}

This is more typing than returning a Promise, but it gives us more flexibility. Since a Promise can only express one async value, `fetchTodos` now returns a function with a call back argument so that it can call it multiple times during the async operation.

**Introducing Thunks**

Functions returned from other functions like in `fetchTodos` are often called thunks. Now we're going to implement a middleware to suuport using thunks in our code.

**Updating `configureStore.js`**

Inside of `configureStore.js` we'll remove the `redux-promise` middleware and replace it with the `thunk` middleware we'll write now. The `thunk` middleware supports the dispatching of thunks. It takes the `store`, the next middleware (`next`), and the `action` as arguments, just like any other middleware. If `action` is a function instead of an action, we're going to assume that this is a thunk that wants the `dispatch` function to be injected into it. In this case, we'll call the action with `store.dispatch`. Otherwise, we just return the result of passing the action to the next middleware in chain.

**`thunk` Middleware in `configureStore.js`**

{% highlight js linenos %}

const thunk = (store) => (next) => (action) =>
  typeof action === 'function' ?
    action(store.dispatch) :
    next(action);
{% endhighlight %}

As a final step, we need to add our new `thunk` middleware to the array of middlewares inside `configureStore` so that it gets applied to the store.

{% highlight js linenos %}
const configureStore = () => {
  const middlewares = [thunk];
  // rest of configureStore
{% endhighlight %}

#### 3.5.5 Avoiding Race Conditions with Thunks

When we increase the delay in our fake API client to five seconds, we notice a problem. We aren't checking if the tab is already loading before starting a request, and then a bunch of `receiveTodos` actions come back, potentially resulting in a race condition. To fix this, we can exit early from the `fetchTodos` action creator if we know that we are already feching the todos for the given filter. Inside of `fetchTodos`, we will add an `if` to check if we are cureently fetching by using our `getIsFetching` selector that accepts the store state and the filter as arguments. If it returns `true`, we will exit early from the thunk without dispatching any actions.

**Updating `fetchTodos`**

{% highlight js linenos %}
export const fetchTodos = (filter) => (dispatch) => {
  if (getIsFetching(getState(), filter)) {
    return;
  }
  /// rest of fetchTodos
{% endhighlight %}

The `getIsFetching` selector is defined inside the top level reducer file, so we need to import it as a named `import` from `reducers`.

{% highlight js linenos %}
import { getIsFetching } from '../reducers';
{% endhighlight %}

We are also using `getState()` that isn't defined in this file. It belongs to the  `store` object, but we don't have access to it directly from the action creator.

**Updating the `thunk` Middleware**

We can make it so that the `thunk` middleware inside `configureStore.js` injects not just the `store.dispatch()` function inside the thunk actions, but also the `store.getState` function. This way, we can grab it as a second argument after `dispatch` inside of the `thunk` action creator.

{% highlight js linenos %}

// Inside configureStore.js
const thunk = (store) => (next) => (action) =>
  typeof action === 'function' ?
    action(store.dispatch, store.getState) :
    next(action);

// Add `getState` as a second parameter to `fetchTodos`
export const fetchTodos = (filter) => (dispatch, getState) => {
{% endhighlight %}

With these changes, the `fetchTodos` action creator dispatches actions conditionally. If we run the app, we can't get it to produce more than three concurrent requests (one for each filter type). The `isFetching` flag gets reset only when the corresponding `receiveTods` actions come back, and then we can request the new todos. This is a good way to avoid unnecessary network operations and potential race conditions.

**Updating `fetchTodos`**

Since the return value of the thunk is a Promise, we will change our early `return` to be a Promise that resolves immediately. We don't have to do this, but it's convenient for the calling code.

**Inside `actions/index.js`**

{% highlight js linenos %}
export const fetchTodos = (filter) => (dispatch, getState) => {
  if (getIsFetching(getState(), filter)) {
    return Promise.resolve();
  }
  // rest of fetchTodos
{% endhighlight %}

The `thunk` middleware itself does not use this Promise, but it becomes the `return` value of dispatching this action creator, so we can use it inside the component to schedule some code after the asynchronous action has completed.

**Inside `VisibleTodoList`**

{% highlight js linenos %}
fetchData() {
  const { filter, fetchTodos } = this.props;
  fetchTodos(filter).then(() => console.log('done!'));
}
{% endhighlight %}

**Introducing `redux-thunk`**

`redux-thunk` is a middlware similar to what we just implemented. To install it, run `npm install -s-ave redux-thunk`. With `redux-thunk` installed, we can remove the version of thunk middleware that we just wrote and import `thunk` from `redux-thunk` instead.


#### 3.5.6 Dispalying Error Messages

Sometimes API requests fail, and we will simulate this by `throw`ing inside the fake API client so that it returns a rejected Promise. If we run the app, the loading indicator gets stuck because the `isFetching` flag get set to `true`, but there is no corresponding `receiveTodos` action to set it back to `false` again.

**Fixing It**

We'll start by doing some cleanup inside the action creators file (`actions/index.js`). The `requestTodos` action is never used outside of `fetchTodos` by copying and pasting it inside of `fetchTodos` where it is dispatched. We will also add the rejection handler as the second argument to our `Promise.then` method.

**Inside `fetchTodos`**

{% highlight js linenos %}
return api.fetchTodos(filter).then(
  response => {
    dispatch({
      type: 'RECEIVE_TODOS',
      filter,
      response,
    });
  },
  error => {
    // To be filled in
  }
);
{% endhighlight %}

**Renmaing Actions for Clarity**

since the `fetchTodos` action creator dispatches several actions, we will rename them to tbe more consistent: `REQUEST_TODOS` becomes `FETCH_TODOS_REQUEST` for requesting the todos;`RECEIVE_TODOS` becomes `FETCH_TODOS_SUCCESS` for fetching the todos; Add `FETCH_TODOS_FAILURE` in our `error` handler when failing to fetch the todos.

Our `error` handler will also be passed two additional pieces of data: the `filter` and the `message` that can be read with `error.message` if specified. We will use `Something went wrong.` as a fallback.

**Updated `fetchTodos` `return`**

{% highlight js linenos %}
return api.fetchTodos(filter).then(
  response => {
    dispatch({
      type: 'FETCH_TODOS_SUCCESS',
      filter,
      response,
    });
  },
  error => {
    dispatch({
      type: 'FETCH_TODOS_FAILURE',
      filter,
      message: error.message || 'Something went wrong.',
    });
  }
);
{% endhighlight %}

Now our `fetchTodos` action creator handles all the cases, and we can remove the old action creators that are now inlined (`requestTodos` and `receiveTodos`).

**Updating our Reducers**

Since we changed action types, we now need to change the corresponding reducers. Our `ids` reducer needs to handle `FETCH_TODOS_SUCCESS` instead of `RECEIVE_TODOS`. The `isFetching` reducer needs to handle `FETCH_TODOS_REQUEST` instead of `REQUEST_TODOS`, and `FETCH_TODOS_SUCCESS` instead of `RECEIE_TODOS`. We will also handle `FETCH_TODOS_FAILURE` by returning `false` so our loading indicator won't get stuck. The last reducer we need to change is `byId`, where we replace `RECEIVE_TODOS` with `FETCH_TODOS_SUCCESS`.

**Updated `isFetching` Reducer**

{% highlight js linenos %}
const isFetching = (state = false, action) => {
    if (filter !== action.filter) {
      return state;
    }
    switch (action.type) {
      case 'FETCH_TODOS_REQUEST':
        return true;
      case 'FETCH_TODOS_SUCCESS':
      case 'FETCH_TODOS_FAILURE':
        return false;
      default:
        return state;
    }
  };
{% endhighlight %}

With these changes, the loading indicator won't get stuck because a corresponding failure action fires, resettting `isFetching` back to `false`.

**Displaying the Error**

We'll create a new file `FetchError.js` in our `components` directory. After `import` `React`, we'll create a new functional stateless component `FetchError` that will take two props: a `message` string, and an `onRetry` function. This comonent will be the default export for this file. The rendered `<div>` will contain an error saying that something bad happened (including the message that is passed in the props), and a button that when clicked will invoke the `onRetry` callback prop so that the user can retry fetching the data.

**`FetchError` Component**

{% highlight js linenos %}
const FetchError = ({ message, onRetry }) => (
  <div>
    <p>Could not fetch todos. {message}</p>
    <button onClick={onRetry}>Retry</button>
  </div>
);
{% endhighlight %}

**Adding `FetchError` to `VisibleTodoList`**

We need to `import FetchError` inside of `VisibleTodoList`, then update the `render` method. In order to get the error message, we need to destructure it from the `props` of the `VisibleTodoList` component.

{% highlight js linenos %}
// Inside VisibleTodoList
render() {
  const { isFetching, errorMessage, toggleTodo, todos } = this.props;
  ...
{% endhighlight %}

We will also add another condition inside of `render` saying that "if we have an error message in our props and we have no todos to display, then return the `FetchError` component". The `FetchError` component itself wants a `message` prop, which will be passed the `errorMessage` prop I just destructured. We will also provide an `onRetry` callback prop that we will pass an error function that calls `this.fetchData` to restart the data fetching process.

{% highlight js linenos %}
// Inside VisibleTodoList's `render()`
if (errorMessage && !todos.length) {
     return (
       <FetchError
         message={errorMessage}
         onRetry={() => this.fetchData()}
       />
     );
   }
{% endhighlight %}

We need to add `errorMessage` into `VisibleTodoList`'s `mapStateToProps` in order to make it available. Following the same pattern used with `isFetching`, we will get the `errorMessage` prop by calling a selector called `getErrorMessage` and pass in the `state` of the app and the `filter`.

{% highlight js linenos %}
// Inside VisibleTodoList
const mapStateToProps = (state, { params }) => {
  const filter = params.filter || 'all';
  return {
    isFetching: getIsFetching(state, filter),
    errorMessage: getErrorMessage(state, filter),
    todos: getVisibleTodos(state, filter),
    filter,
  };
};
{% endhighlight %}

**Implementing `getErrorMessage`**

We need to add `getErrorMessage` to VisibleTodoList's reducer import at the top of the file:`import { getVisibleTodos, getErrorMessage, getIsFetching } from '../reducers'`. Now inside of our root reducer file (`/reducers/index.js`) we create our `getErrorMessage` selector by copying, pasting, and refactoring our `getIsFetching` selector.

**Creating the Selector**

{% highlight js linenos %}
export const getErrorMessage = (state, filter) =>
  fromList.getErrorMessage(state.listByFilter[filter]);
{% endhighlight %}

**Updating `createList`**

Inside `createList.js`, we'll add a new exported selector called `getErrorMessage` that takes the state of the list and returns a property called error message.

{% highlight js linenos %}
export const getErrorMessage = (state) => state.errorMessage;
{% endhighlight %}

We'll now declare a new reducer called `errorMessage` with the initial `state` of `null`. We do this because a reducer cannot have an undefined initial state, so we have to make its absence explicit. Like in the other reducers in this file, we want to skip any actions with the filter that don't match the `filter` specified as an argument to `createList`. When the filter does match, we want to handle a few actions:

+ Display an error message if there's a failure
+ Clear the error message if the user retries their request
+ Return the current state for any other action

The `errorMessage` reducer needs to be added to `combineReducers` as well.

**completed `errorMessage` Reducer**

{% highlight js linenos %}
const errorMessage = (state = null, action) => {
    if (filter !== action.filter) {
      return state;
    }
    switch (action.type) {
      case 'FETCH_TODOS_FAILURE':
        return action.message;
      case 'FETCH_TODOS_REQUEST':
      case 'FETCH_TODOS_SUCCESS':
        return null;
      default:
        return state;
    }
  };

  return combineReducers({
    ids,
    isFetching,
    errorMessage,
  });
{% endhighlight %}

**Updating the API**

Instead of having our PI throw the rror every time, we'll have it throw randomly so we can try out our "retry" button.

**Update `src/api.js`**

{% highlight js linenos %}
export const fetchTodos = (filter) => {
  return delay(5000).then(()=>{
    if(Math.random()>0.5){
      throw new Error('Boom!');
    }
    switch (filter) {
      case 'all':
        return fakeDatabase.todos;
      case 'active':
        return fakeDatabase.todos.filter(todo=>!todo.completed)
      case 'completed':
        return fakeDatabase.todos.filter(todo=>todo.completed)
      default:
        throw new Error(`Unknown filter:${filter}`)
    }
  })
}
{% endhighlight %}

#### 3.5.7 Creating Data on the Server ####

**Updating the Fake API**

Some new functions were added to our fake API client for the next few lessons.

The first new fake API endpoint is called `addTodo`. It simulates a network connection and then it creates a new `todo` object. It puts the todo with the given text into the fake database, and it returns the`todo` object, just like REST endpoints normally do.

**`addTodo Endpoint`**

{% highlight js linenos %}
export const addTodo = (text) =>
  delay(500).then(() => {
    const todo = {
      id: v4(),
      text,
      completed: false,
    };
    fakeDatabase.todos.push(todo);
    return todo;
  });
{% endhighlight %}

The second fake API endpoint is called `toggleTodo`. It also simulates a network connection and it finds the corresponding todo in the fake database and flips its `completed` field, also returning the `todo` as the response.

**`toggleTodo` Endpoint**

{% highlight js linenos %}
export const toggleTodo = (id) =>
  delay(500).then(() => {
    const todo = fakeDatabase.todos.find(t => t.id === id);
    todo.completed = !todo.completed;
    return todo;
  });
{% endhighlight %}

**Updating the "Add Todo" Process**

In this lesson, we will make the add todo button called the `addTodo` fake API endpoint. Inside our action creators file, we will no longer need the `v4` function from `node-uuid` because the id generation will now occur on the server. The `addTodo` action creator will be changed to be a thunk action creator, so we will add `dispatch` as a curried argument. The thunk will call the API's `addTodo` endpoint with the given text, and wait for the response to come back. When the response is available, it will dispatch an action with the type `ADD_TODO_SUCCESS`, and the server response.

**Updated `addTodo` Action**

{% highlight js linenos %}
export const addTodo = (text) => (dispatch) =>
  api.addTodo(text).then(response => {
    dispatch({
      type: 'ADD_TODO_SUCCESS',
      response,
    });
  });
{% endhighlight %}

Updating the `byId` Reducer

Since the newly added todo will be part of the server response, we nned to change the `byId` reducer to merge the todo into the lookup table that it manages. I am adding a new case for the `ADD_TODO_SUCCESS` action. We'll use the object spread operator to create a new version of the lookup table, where under the action response ID key, there is a new todo object that I reade from aciton response.

{% highlight js linenos %}
// Inside reducers/byId.js
const byId = (state = {}, action) => {
  switch (action.type) {
    case 'FETCH_TODOS_SUCCESS':
      const nextState = { ...state };
      action.response.forEach(todo => {
        nextState[todo.id] = todo;
      });
      return nextState;
    case 'ADD_TODO_SUCCESS': // Our new case
      return {
        ...state,
        [action.response.id]: action.response,
      };
    default:
      return state;
  }
};
{% endhighlight %}

However, we have not updated the list by filter, so all still only has three IDs in the list. If I go to another tab, the new todo appears because its ID is now included int he list of fetched IDs, and similarly, if I go back to the previous tab, it appears now because the data has been re-fetched.

**Updating `createList`**

Since the list of IDs for each tab is managed by a reducer defined inside `createList.js`, we need to update our `ids` reducer to handle the `ADD_TODO_SUCCESS` action. When we receive a confirmation that the todo has been added on the server, we can return a newlist id IDs with existing IDs in the beginning, and a. newly added ID at the end. Unlike the other actions, `ADD_TODO_SUCCESS` does not have a `filter` property on the `action` object, our current `if (filter !== action.filter)` check inside of ids would fail. Because of this, we will replace the existing check with different checks in different cases. For `FETCH_TODOS_SUCCESS`, we want to replace the fetched IDs if the filter in the action matches the filter of this list. However, for `ADD_TODO_SUCCESS`, we want the newly added todo to appear in every list except the completed filter, because a newly added todo is not completed.

{% highlight js linenos %}
const createList = (filter) => {
  const ids = (state = [], action) => {
    switch (action.type) {
      case 'FETCH_TODOS_SUCCESS':
        return filter === action.filter ?
          action.response.map(todo => todo.id) :
          state;
      case 'ADD_TODO_SUCCESS':
        return filter !== 'completed' ?
          [...state, action.response.id] :
          state;
      default:
        return state;
    }
  };
{% endhighlight %}

### 3.6 Normalizing API response via `'normalizr'`

#### 3.6.1 Normalizing API Responses

The `byId` reducer currently has to handle server actions differently, because they have different response shapes. For example, the `FETCH_TODOS_SUCCESS` action's response is an array of todos. This array has be to iterated over and merged one at a time into the next state. The response for `ADD_TODOS_SUCCESS` is the single todo that has just been added, and this single todo has to be merged in a different wat. Instead of adding new cases for every new API call, I want to normalize the responses so the response shape is always the same.

**Installing `normalizr`**

`normalizr` is a utility library that will help us normalize API responses to have the same shape. `$ npm install --save normalizr`.

**Creating `schema.js`**

We'll create a new file `schema.js` inside of our `actions` directory. We'll start by importing a `Schema` constructor and a function called `arrayOf` from `normalizr`. Our first exported Schema will be for the `todo` objects, and we'll specify `todos` as the name of the dictionary in the normalized response. Our next schema called `arrayOfTodos` corresponds to the responses that contain arrays of `todo` objects.

{% highlight js linenos %}
import { schema } from 'normalizr'

export const todo = new schema.Entity('todos');
export const arrayOfTodos = new schema.Array(todo);
{% endhighlight %}

**Updating our Action Creators**

Inside of `actions/index.js`, we'll add a named import for a function called `normalize` that we import from `normalizr`. We also add a namespace import for all the Schemas we defined in the schema file. inside of the `FETCH_TODOS_SUCCESSS` callback, we'll add a "normalized response" log so that I can see what the normalized response looks like. We call the `normalize` function with the original `response` as the first argument, and the corresponding schema (th this case, `arrayOfTodos`) as the second argument.

{% highlight js linenos %}
return api.fetchTodos(filter).then(
  response => {
    console.log(
      'normalized response',
      normalize(response, schema.arrayOfTodos)
    )
    dispatch({
      type: 'FETCH_TODOS_SUCCESS',
      filter,
      response,
    });
  },
    
{% endhighlight %}

We'll update `addTodo` in a similar manner:

{% highlight js linenos %}
export const addTodo = (text) => (dispatch) =>
  api.addTodo(text).then(response => {
    console.log(
      'normalized response',
      normalize(response, schema.todo)
    )
    dispatch({
      type: 'ADD_TODO_SUCCESS',
      responsed,
    });
  });
{% endhighlight %}

**Comparing Responses**

All this point, the response in the action is an array of to-do objects, ut our normalized response for `FETCH_TODOS_SUCCESS` is an object that contans two fields: `entities` and `result`. `entities` contains a normalized dictionray called `todos` that contains every `todo` in the response by its id. `normalizr` found these `todo` objects in the response by following the `arrayOfTodos` schema. Conveniently, they are indexed by IDs, so they will be easy to merge into the lookup table. The second field is the `result`, which is an array of `todo` IDs. They are in the same order as the `todos` in the original response array. However, `normalizr` replaced each `todo` with its ID< and moved every todo into the `todos` dictionary.

**Finishing our Aciton Creator Updates**

We will now change the action creators so that they pass the normalized response in the response field, instead of the original response.

{% highlight js linenos %}
//before
return api.fetchTodos(filter).then(
  response => {
    console.log(
      'normalized response',
      normalize(response, schema.arrayOfTodos)
    )
    dispatch({
      type: 'FETCH_TODOS_SUCCESS',
      filter,
      response,
    });
  },
  
//after
return api.fetchTodos(filter).then(
    dispatch({
      type: 'FETCH_TODOS_SUCCESS',
      filter,
      response: normalize(response, schema.arrayOfTodos),
    });
  },
{% endhighlight %}

**Updating the Reducers**

We can delete the special cases in our `byId` reducer, because the response shape has been nromalized. Instead of swtiching by action type, we will check to see if the action has a response object on it.

**`byId` reducer**

{% highlight js linenos %}
//Before
const byId = (state = {}, action) => {
  switch (action.type) {
    case 'FETCH_TODOS_SUCCESS': // eslint-disable-line no-case-declarations
      const nextState = { ...state };
      action.response.forEach(todo => {
        nextState[todo.id] = todo;
      });
      return nextState;
    case 'ADD_TODO_SUCCESS':
      return {
        ...state,
        [action.response.id]: action.response,
      };
    default:
      return state;
  }
};

//after

const byId = (state = {}, action) => {
  if (action.response) {
    return {
      ...state,
      ...action.response.entities.todos,
    };
  }
  return state;
};
{% endhighlight %}

**`ids` Reducer**

{% highlight js linenos %}
//Before
const ids = (state = [], action) => {
    switch (action.type) {
      case 'FETCH_TODOS_SUCCESS':
        return filter === action.filter ?
          action.response.map(todo => todo.id) :
          state;
      case 'ADD_TODO_SUCCESS':
        return filter !== 'completed' ?
          [...state, action.response.id] :
          state;
      default:
        return state;
    }
  };
  
  //after
  const ids = (state = [], action) => {
   switch (action.type) {
     case 'FETCH_TODOS_SUCCESS':
       return filter === action.filter ?
         action.response.result :
         state;
     case 'ADD_TODO_SUCCESS':
       return filter !== 'completed' ?
         [...state, action.response.result] :
         state;
     default:
       return state;
   }
 };
{% endhighlight %}

#### 3.6.2 Updating Data on the Server

We'll start by changing the `toggleTodo` action creator to be a thunk aciton creator, so we add `dispatch` as a curried argument. Next, we'll call the `toggle tTodo` API endpoint, and wait for the response to come back. When the response isavailable, we will dispatch an aciton with the type `TOGGLE_TODO_SUCCESS`, and the `response1`. We'll use normalize agian by passing the original response as the first argument, and the todo schema as the second argument. 

**Updated `toggleTodo` Action Creator**

{% highlight js linenos %}
export const toggleTodo = (id) => (dispatch) =>
  api.toggleTodo(id).then(response => {
    dispatch({
      type: 'TOGGLE_TODO_SUCCESS',
      response: normalize(response, schema.todo),
    });
  });
{% endhighlight %}

**Updating the `ids` Reducer**

Inside of `createList.js` we will add a new case for the `Toggle_TODO_SUCCESS` action. We'll extract the code for this case into a separate function called `handleToggle`, and pass in the `state` and the `action`.

{% highlight js linenos %}
// Inside the `ids` reducer
  case 'TOGGLE_TODO_SUCCESS':
    return handleToggle(state, action);
{% endhighlight %}

We'll put our `handleToggle` function above the `ids` reducer. It accepts the `state` (an array of ids) and the `TOGGLE_TODO_SUCCESS` action. We will destructure the `result` as the `toggleId` and the `entities` from the normalized response. Next, we will read the `completed` value from the `todo`, which I get by referencing `entities.todos` by the `toggleId`. There are two cases in which we want to remove the todo from the list:

+ The `completed` field is `true` but he `filter` is `active`.
+ `completed` is `false` but the `filter` is `completed`.

**Completed `handleToggle` Function**

{% highlight js linenos %}
const handleToggle = (state, action) => {
  const { result: toggledId, entities } = action.response;
  const { completed } = entities.todos[toggledId];
  const shouldRemove = (
    (completed && filter === 'active') ||
    (!completed && filter === 'completed')
  );
  return shouldRemove ?
    state.filter(id => id !== toggledId) :
    state;
};
{% endhighlight %}


## 4 Summary 

{: .img_middle_hg}
![Redux summary](/assets/images/posts/04 Web/JS/2016-10-05-redux part I todo app/summary.png)

## 5 参考资料 ##
- [Redux](https://github.com/reactjs/redux);

- [Get Started with Redux](https://egghead.io/courses/getting-started-with-redux);

- [Note: Get Started with Redux](https://github.com/tayiorbeii/egghead.io_redux_course_notes);

- [React Code](https://github.com/shunmian/4.1.1_redux-part-one)



