---
layout: post
title: Redux Part I：Basics TodoApp
categories: [04 Web Development]
tags: [Redux]
number: [3.7.7]
fullview: false
shortinfo: 本文是对Facebook的React框架的introduction。
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


## 2 Todo List Example



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


### 2.5 Generating Containers with `connect()` from React Redux

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



## 3 Summary 

{: .img_middle_hg}
![Redux basics summary](/assets/images/posts/04 Web/JS/2016-10-05-redux part I basics todo app/summary.png)

## 4 参考资料 ##
- [Redux](https://github.com/reactjs/redux);

- [Get Started with Redux](https://egghead.io/courses/getting-started-with-redux);

- [Note: Get Started with Redux](https://github.com/tayiorbeii/egghead.io_redux_course_notes);

- [React Code](https://github.com/shunmian/4.1.1_redux-part-one)



