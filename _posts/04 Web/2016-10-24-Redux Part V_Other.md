---
layout: post
title: Redux Part V：Other
categories: [04 Web Development]
tags: [Redux]
number: [4.1.2]
fullview: false
shortinfo: 本文是对Rudex之前4篇文章没有提到的主题的总结。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}
 
## 1 Other ##

### 1.1 Glossary

This a glossary of the core terms in Redux, along with their type signatures. The typs are documented using [Flow notation](http://flowtype.org/docs/quick-reference.html)

#### 1.1.1 State

{% highlight js linenos %}
type State = any
{% endhighlight %}

**State** (also called the state tree) is a broad term, but in the Redux API it usually refers to the single state value that is managed by the store and returned `getState()`. It represents the entire state of a Redux application, which is often a deeply nested object.

By convention, the top-level state is an object or some other key-value collection like a Map, but technically it can be any types. Still, you should do your best to keep the state serializable. Don't put anything inside it that you can't easily turn into JSON.

#### 1.1.2 Action

{% highlight js linenos %}
type Action = Object
{% endhighlight %}

An action is a plain object that represents in intention to change the state. Actions are the only way to get data into the store. Any data, whether from UI events, network callbacks, or other sources such as WebSockets needs to eventually de dispatched as actions.

Actions must have a `type` field that indicates the type of action being performed. Types can be defined as constants and imported from another module. It's better to use strings for `type` than [Symbols](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Symbol) becuase strings are **serializable**.

Other than `type`, the structure of an action is really up to you. If you're interested, check out [Flux Standard Action](https://github.com/acdlite/flux-standard-action) for recommendations on how actions should be constructed.

See also [async action](http://redux.js.org/docs/Glossary.html#async-action) below.

#### 1.1.3 Reducer

{% highlight js linenos %}
type Reducer<S, A> = (state: S, action: A) => S
{% endhighlight %}

A **reducer** (also called a reducing function) is a function that accepts an accumulation and a value and returns a new accumulation. They are used to reduce a collection of values down to a single value.

Reducers are not unique to Redux-they are a fundamental concept in functional programming. Even most non-functional languages, like JavaScript, have a built-in API for reducing. In JavaScript, it's `Array.prototype.reducer()`.

In Redux, the accumulated state is the state object, and the values being accumulated are actions. Reducers calculate a new state given the previous state and an action. They must be pure functions -- functions that return the exact same output for given inputs. They should also be free of side-ffects. This is what enables exciting features like hot reloading and time travel.

Reducers are the mot important concept in Redux.

**Do not put PAI calls into reducers**.


#### 1.1.4 Dispatching Function

{% highlight js linenos %}
type Base Dispatch = (a: Action) => Action
type Dispatch = (a: Action | AsyncAction) => any
{% endhighlight %}

A **dispatching function** (or simply dispatch function) is a function that accepts an action or an [async action](http://redux.js.org/docs/Glossary.html#async-action); it then may or may not dispatch one or more actions to the store.

We must distinguish between dispatching functions in general and the base `dispatch` function provided by the store instance without any middleware.

The base dispatch function always synchronously sends an aciton to the store's reducer, along with the previous state returned by the store to calculate a new state. It expects action to be plain objects ready to be consumed by the reducer.

[Middlware](http://redux.js.org/docs/Glossary.html#middleware) wraps the base dispatch function. It allows the dispatch function to handle [async actions](http://redux.js.org/docs/Glossary.html#async-action) in addition to actions. Middleware may transform, delay, ignore, or otherwise interpret actions or async actions before passing them to the next middleware. See below for more information.

#### 1.1.5 Action Creator

{% highlight js linenos %}
type ActionCreator = (...args:any) => Action | AsyncAction
{% endhighlight %}

An **action creator** is, quite simply, a funciton that creates an action. Do not confuse the two terms --  again, an action is a payload of information and an action creator is a **factory** that creats an action

Calling an action creator only produces an action, but does not dispatch it. You need to call the store's `dispatch` function to actually cause the mutation. Sometimes we say **bound action** creators to mean functions that call an action creator and immeidately dispatch its result to a specific store instance.

If an action creator needs to read the current state, perform an API call, or cause a side effect, like a routing transition, it should return an [async action](http://redux.js.org/docs/Glossary.html#async-action) instead of an action.

#### 1.1.6 Async Action

{% highlight js linenos %}
type AsyncAction = any
{% endhighlight %}

An async action is a value that is sent to dispatching funciton, but is not yet ready for consumption by the reducer. It will be transformed by [middleware](http://redux.js.org/docs/Glossary.html#middleware) into an action (or a series of actions) before being sent to the base `dispatch()` funciton. Async actions may have different types, depending ont he midddlware you use. They are often asynchronous primitives, like a Promise or a thunk, which are not passed to the reducer immediately, but trigger action dispatches once an operation has completed.

#### 1.1.7 Middleware

{% highlight js linenos %}
type MiddlewareAPI = { dispatch: Dispatch, geState: () => State }
type Middleware = { api: MiddlewareAPI } => (next: Dispatch) => Dispatch
{% endhighlight %}

A **middleware** is a higher-order function that composes a [disaptch function](http://redux.js.org/docs/Glossary.html#dispatching-function) to return a new dispatch function. It often turns [aysnc actions](http://redux.js.org/docs/Glossary.html#async-action) into actions.

Middleware is composable using funciton composition. It is useful for logging actions, performing side effects like routing, or turning an asynchronous API call into a seris of synchronous actions.

See [applyMiddleware(...middlewares)](http://redux.js.org/docs/api/applyMiddleware.html) for a detailed look at middleware

#### 1.1.8 Store

{% highlight js linenos %}
type Store = {
    dispatch: Dispatch
    getState: () => State
    subscribe: (listener: () => void) => () => void
    replaceReducer: (reducer: Reducer) => void
}
{% endhighlight %}

A **store** is an object that holds the application's state tree. There should only be a single store in Redux app, as the composition happens on the reducer level.

+ [dispatch(action)](http://redux.js.org/docs/api/Store.html#dispatch)  is the base dispatch function described above.

+ [getState()](http://redux.js.org/docs/api/Store.html#getState) returns the current state of the store.

+ [subscribe(listener)](http://redux.js.org/docs/api/Store.html#subscribe) registers a function to be called on state changes.

+ [replaceReducer(nextReducer)](http://redux.js.org/docs/api/Store.html#replaceReducer) can be used to implement hot reloading and code splitting. Most likely you won't use it.

See the complete [store API reference](http://redux.js.org/docs/api/Store.html#dispatch) for more details.

#### 1.1.9 Store creator

{% highlight js linenos %}
type StoreCreator = (reducer: Reducer, preloadedState: ?State) => Store
{% endhighlight %}

A store creator is a funciton that creates a Redux store. Like with dispatching funciton, we must distinguish the base store creator, [createStore(reducer, preloadedState)](http://redux.js.org/docs/api/createStore.html) exported from the Redux package, from store creators that returned from the store enhancers.

#### 1.1.10 Store enhancer

{% highlight js linenos %}
type StoreEnhancer = (next: StoreCreator) => StoreCreator
{% endhighlight %}

A store enhancer is a higher-order function that composes a store creator to return a new, enhanced store creator. This is similar to middleware in that it allows you to alter the store interface in a composable way.

Store enhancers are much the same concept as higher-order componenets in React, which are also occaasionally called "component enhancers".

Because a store is not an instace, but rather a plain-object collection of functions, copies can be easily created and modified without mutating the original store. There is an example in [compose](http://redux.js.org/docs/api/compose.html) documentation demonstrating that.

Most likely you'll never write a store enhancer, but you may the the one provided by the [developer tools](https://github.com/gaearon/redux-devtools). It is what makes time travel possible without the app being aware it is happening. Amusingly, the [Redux middleware implementation](http://redux.js.org/docs/api/applyMiddleware.html) is itself a store enhancer.

### 1.2 API Reference

The Redux API surface is tiny. Redux defines a set of contracts for you to implement (such as [reducers](http://redux.js.org/docs/Glossary.html#reducer)) and provides a few helper functions to tie these contracts together.

This section documents the complete Redux API. Keep in mind that Redux is only concerned with managing the state. In a real app, you'll also want to use UI bindings like [react-redux](https://github.com/gaearon/react-redux)




#### 1.2.1 `CreateStore(reducer, [preloadedState],[enhancer])` ####

Create a Redux [store](http://redux.js.org/docs/api/Store.html) that holds the complete state tree of your app. These should only be a single store in your app.

**Arguments**:

1. `reducer` (Function): A [reducer function](http://redux.js.org/docs/Glossary.html#reducer) that returns the next [state tree](http://redux.js.org/docs/Glossary.html#state), given the current state tree and an [action](http://redux.js.org/docs/Glossary.html#action) to handle

2. `[preloadedState]` (any): The initial state. You may optionally specify it to hydrate the state from the server in universal apps, or to restore a previously serialized user session. If you produced `reducer` with [combineReducers](http://redux.js.org/docs/api/combineReducers.html), this must ba a plain object with the same shape as the keys passed to it. Otherwise, you are free to pass anything that your `reducer` can understand.

3. `[enhancer]` (Function): The store enhancer. You may optionally specify it to enhance the store with third-party capabilities such as middleware, time travel, persistence, etc. The only store enahncer that ships with Redux is [applyMiddleware()](http://redux.js.org/docs/api/applyMiddleware.html).

**Returns**

([Store](http://redux.js.org/docs/api/Store.html)): An objects that holds the complete state of your app. The only way to change its state is by [dispatching actions](http://redux.js.org/docs/api/Store.html#dispatch). You may also [subscribe](http://redux.js.org/docs/api/Store.html#subscribe) to the changes to the state to update the UI.

**Example**

{% highlight js linenos %}
import { createStore } from 'redux'

function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      return [...state, action.text]
    default:
      return state
  }
}

let store = createStore(todos, ['Use Redux'])

store.dispatch({
  type: 'ADD_TODO',
  text: 'Read the docs'
})

console.log(store.getState())
// [ 'Use Redux', 'Read the docs' ]
{% endhighlight %}

**Tips**

+ Don't create more than one store in an application! Instead, use [combineReducers](http://redux.js.org/docs/api/combineReducers.html) to create a single root reducer out of many.

+ It is up to you to choose the state format. You can use plain objects or something like [Immutable](http://facebook.github.io/immutable-js/). If you're not sure, start with plain objects.

+ If your state is a plain object, make sure you never mutate it! For example, instead of returning something like `Object.assign(state, newData)` from your reducers, return `Object.assign({},state, newData)`. This way you don't override the previous `state`. You can also write `return {...state,...newData}` if you enable the [object spread operator proposal](http://redux.js.org/docs/recipes/UsingObjectSpreadOperator.html).

+ For universal apps that run on the server, create a store intance with every request so that they are isolated. Dispatch a few data fetching actions to a store instance and wait for them to complete before rendering the app on the server.

+ When a store is created, Redux dispatches a dummy action to your reducer to populate the store with the initial state. You are not meant to handle the dummy action directly. Just remember that your reducer should return some kind of initial state if the state given to it as the first argument is `undefined`, and you're all set.

+ To apply multiple store enhancers, you may use [compose()](http://redux.js.org/docs/api/compose.html).

#### 1.2.2 Store ####

A store holds the whole [state tree](http://redux.js.org/docs/Glossary.html#state) of your application. The only way to change the state inside it is to dispatch an [action](http://redux.js.org/docs/Glossary.html#action) on it.

A store is not a class. It's just an object with a few methods on it. To create it, pass your root [reducing function](http://redux.js.org/docs/Glossary.html#reducer) to [createStore](http://redux.js.org/docs/api/createStore.html).

> **A Note for Flux Users**: If you're coming from Flux, there is a single important difference you need to understand. Redux doesn't have a Dispatcher or support many stores. **Instead, there is just a single store with a single root reducing function**. As your app grows, instead of adding stores, you split the root reducer into smaller reducers independently operating on the different parts of the state tree. You can use a helper like [combinReducers](http://redux.js.org/docs/api/combineReducers.html) to combine them. This is similar to how there is just one root component in a React app, but it is composed out of many small components.

##### 1.2.2.1 `getState()`

Returns the current state tree of your application. It is equal to the last value returned by the store's reducer.

**Returns**

(any): The current state tree of your application.

##### 1.2.2.2 `dispatch(action)`

Dispatches an action. This is the only way to trigger a state change.

The store's reducing function will be called with the current `getState()` result and the given `action` synchronously. Its return value will be considered the next state. It will be returned form `getState()` from now on, and the change listeners will immediately be notified.

> **A Note for Flux Users**: If you attempt to call `dispatch` from inside the `reducer`, it will throw with an error saying "Reducers may not dispatch actions." This is similar to "Cannot dispatch in a middle of diaptch" error in Flux, but doesn't cause the problems associated with it. In Flux, a dispatch is forbidden while Stores are handling the action and emitting udpates. This is unfortunate because it makes it impossible to dispatc actions from component lifecycle hooks or other benign places. In Redux, subscriptions are called after the root reducer has returned the new state, so you may dispatch in the subscription listeners. You are only disallowed to dispatch inside the reducers because they must have no side effects. If you want to cause a side effect in response to an action, the right place to do this is in the potentially aysnc [action creator](http://redux.js.org/docs/Glossary.html#action-creator).

**Arguments**:

1. `action` (Object): a plain object describing the change that makes sense for your application. Actions are the only way to get data ino the store, so any data, whether from the UI events, network callbacks, or other sources such as WebSockets needs to eventually be dispatched as actions. Actions must have a `type` field that indicates the type of action being performed. Types can be defined as constants and imported from another module. It's better to use strings for `type` than [Symbols](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Symbol) because strings are serializable. Other than `type`, the structure of an action object is really up to you. if you're interested, check out [Flux Standard Action](https://github.com/acdlite/flux-standard-action) for recommendations on how actions could be constructed.

**Returns**

(Object): The dispatched action. The "vanilla" store implementation you get be calling `createStore` only supports plain object actions and hands them immediately to the reducer. Howevver, if you wrap `createStore` with `applyMiddleware`, the middleware can interpret actions differently, and provide support for dispatching `async actions`. Async actions are usually aysnchronous primitives like Promises, Obervables, or thunks.

Middleware is created by the community and does not ship with Redux by default. You need to explicitly install packages like [redux-thunk](https://github.com/gaearon/redux-thunk) or [redux-promise](https://github.com/acdlite/redux-promise) to use it. You may also create your own middleware.

To learn how to describe asynchronous API calls, read the current state inside action creators, perform side effects, or chain them to execute in a sequence, see the examples for [applyMiddleware](http://redux.js.org/docs/api/applyMiddleware.html).

**Example**
{% highlight js linenos %}
import { createStore } from 'redux'
let store = createStore(todos, ['Use Redux'])

function addTodo(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}

store.dispatch(addTodo('Read the docs'))
store.dispatch(addTodo('Read about the middleware'))
{% endhighlight %}

##### 1.2.2.3 `subscribe(listener)`

Adds a change listener. It will be called any time an action is dispatched, and some part of the state tree may potentially have changed. You may then call `getState()` to read the current state tree inside the callback.

You may call `dispatch()` from a change listener, with the following caveats:

1. The listener should only call `dispatch()` either in response to user actions or under specific condictions (e.g. dispatching an action when the store has specific field). Calling `dispatch()` without any conditions is technically possible, however it lead to an infinite loop as every `dispatch()` call usually triggers the listener again.

2. The subscriptions are snapshotted just before every `dispatch()` call. If you subscribe or unsubsribe while the listeners are being invoked, this will n ot have any effect on the `dispatch()` that is currently in progress. However, the next `dispatch()` call, whether nested or not, will use a more recent snapshot of the subscritpion list.

3. The listener should not expect to see all state changes, as the state might have been udpated multiple times during a nested `dispatch()` before the listener is called. It is however guaranteed that all subscribers registered before the `dispatch()` started will be called with the latest state by the time it exits.

It is a low-level API. Most likely, instead of using it directly, you'll use React (or other) bindings. If you commonly use the callback as a hook to react to state changes, you might want to [write a custom `observeStore` utility](https://github.com/reactjs/redux/issues/303#issuecomment-125184409). The `store` is also an `Observable`, so you can `subscribe` to changes with libraries like [RxJS](https://github.com/ReactiveX/RxJS).

To unsubscribe the change listener, invoke the function returned by `subscribe`.

**Arguments**
1. `listener` (Function): The callback to be invoked any time an action has been dispatched, and the state tree might have changed. You may call `getState()` inside the callback to read the current state tree. It is resonable to expect that the store's reducer is a pure function, so you may compare references to some deep path in the state tree to learn whether its value has changed.

**Returns**
(Function): Afunction that unsubscribes the change listener.

**Example**
{% highlight js linenos %}
function select(state) {
  return state.some.deep.property
}

let currentValue
function handleChange() {
  let previousValue = currentValue
  currentValue = select(store.getState())

  if (previousValue !== currentValue) {
    console.log(
      'Some deep nested property changed from',
      previousValue,
      'to',
      currentValue
    )
  }
}

let unsubscribe = store.subscribe(handleChange)
unsubscribe()
{% endhighlight %}

##### 1.2.2.4 `replaceReducer(nextReducer)`

Replaces the reducer currently used by the store to calculate the state. It is an advanced API. You might need this ifyour app implements code splitting, and you want to load some of the reducers dynamically. You might also need this if you implement a hot reloading mechanis, for Redux.

**Arguments**
1. `nextReducer` (Function) The next reducer for the store to use.

#### 1.2.3 `combineReducers(reducers)` ####

As yuor app grows more complex, you'll want to split your [reducing function](http://redux.js.org/docs/Glossary.html#reducer) into separate functions, each managing independent parts of the `state`.

The `combineReducers` helper function turns an object whose values are different reducing functions into a single reducing function you can pass to `craeteStore`.

The resulting reducer calls every child reducer, and gathers their results into a single state object. **The shape of the state object matches the keys of the passed `reducers`**.

Consequently, the state object will look like this:

{% highlight js linenos %}
{
  reducer1: ...
  reducer2: ...
}
{% endhighlight %}

You can control state key names by using different keys for the reducers in the passed object. For example, you may call `combineReducers({ todos: myTodosReducer, counter: myCounterReducer })` for the state shape to be `{ todos, counter }`.

A popular convention is to name reducers after the state slices they manage, so you can use ES6 property shorthand notation: `combineReducers({ counter, todos })`. This is equivalent to writing `combineReducers({ counter: counter, todos: todos })`.

> **A Note for Flux Users**: This function helps you organize your reducers to manage their own slices of state, similar to how you would have idfferent Flux Stores to manaeg different state. With Redux, there is just one store, but `combineReducers` helps you keep the same logical division between reducers.

**Arguments**

1. `reducers` (Object): An object whose values correspond to different reducing functions that need to be combined into one. See the notes below for some rulse every passed reducer must follow.

> Earlier documentation suggested the use of the ES6 `import * as reducers` syntax to obtain the reducers object. This was the source of a lot of confusion, which is why we now recommend exporting a single reducer obtained using `combineReducers()` from `reducers/index.js` instead. An exmaple is included below.

**Returns**
(Function): A reducer that invokes every reducer inside the `reducers` object, and constructs a state object with the same shape.

**Notes**
This function is mildly opinionated and is skewed towards helping beginners avoid common pitfalls. This is why it attempts to enforce some rules that you don't have to follow if you write the root reducer manually.

Any reducer passed to `combineReducers` must satisfy these rules:

+ For any action that is not recognized, it must return the `state` given to it as the first argument.

+ It must never return `undefined`. It is too easy to do this by mistake via en early `return` statement, so `combineReducers` throws if you do that instead of letting the error manifest itself somewhere else.

+ If the `state` given to it is `undefined`, it must return the initial state for this specific reducer. According to the previous rule, the initial state must not be `undefined` either. It is handy to specify it with ES6 optional arguments syntax, but you can also explicitly check the first argument for being `undefined`.

While `combineReducers` attempts to check that your reducers conform to some of these rules, you should remember them, and do your best to folow them. `combineReducers` will check your reducers by passing `undefined` to them; this is done even if you specify initial state to `Redux.createStore(combineReducers(...), initialState)`. Therefore, you **must** ensure your reducers work properly when receiving `undefined` as state, even if you never intend for them to actually receive `undefined` in your own code.

**Example**

{% highlight js linenos %}
// reducers/todos.js
export default function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      return state.concat([action.text])
    default:
      return state
  }
}

//  reducers/counter.js
export default function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1
    case 'DECREMENT':
      return state - 1
    default:
      return state
  }
}

// reducers/index.js
import { combineReducers } from 'redux'
import todos from './todos'
import counter from './counter'

export default combineReducers({
  todos,
  counter
})

// App.js
import { createStore } from 'redux'
import reducer from './reducers/index'

let store = createStore(reducer)
console.log(store.getState())
// {
//   counter: 0,
//   todos: []
// }

store.dispatch({
  type: 'ADD_TODO',
  text: 'Use Redux'
})
console.log(store.getState())
// {
//   counter: 0,
//   todos: [ 'Use Redux' ]
// }
{% endhighlight %}

**Tips**

+ This helper is just a convenience! You can write your own `combineReducers` that [works differently](https://github.com/acdlite/reduce-reducers) or even assmble the state object from the child reducers manually and write a root reducing funciton explicitly, like you would write any other function.

+ You may call `combineReducers` at any level of the reducer hierarchy. It doesn't have to happen at the top. In fact you may use it again to split the child reducers that get too complicated into independent grandchildren, and so on.


#### 1.2.4 `applyMiddleware(...middlewares)` ####

Middleware is the suggested way to extend Redux with custom functionality. Middleware lets you wrap the store's `dispatch` method for fun and profit. The key feature of middleware is that it is composable. Multiple middlewre can be combined together, where each middleware requires no knowledge of what comes before or after in the chain. The most common use case for middleware is to support asynchronous actions without much boilerplate code of a dependency on a library like [Rx](https://github.com/Reactive-Extensions/RxJS). It does so be letting you dispatch [async actions](http://redux.js.org/docs/Glossary.html#async-action) in addition to normal actions.

For example, [redux-thunk](https://github.com/gaearon/redux-thunk) lets the action creators invert control by dispatching functions. They would receive `dispatch` as an argument and may call it asynchronously. Such functions are called thunks. Another exmaple of middleware is [redux-promise](https://github.com/acdlite/redux-promise). It lets you dispatch a `Promise` async action, and dispatches a normal action when the Promise resovles.

Middleware is not baked into `createStore` and is not a fundamental part of the Redux architecture, but we consider it useful enough to be supported right in the core. This way, there is asingle standard way to extend `dispatch` in the ecosystem, and different middleware may compete in the expressibeness and utility. 

**Arguments**
+ `...middleware` (arguments): Functions that conform to the Redux middlware API. Each middleware receives `store`'s `dispatch` and 	`getState` functions as named arguments, and returns a function. That function will be given the `next` middleware's dispatch method, and is expected to return a function of `action` calling `next(action)` with a potentially differnt argument, or at a differnt time, or maybe not calling it at all. The last middleware in the cahin will receive the real store's `dispatch` methid as the `next` parameter, thus endig the chain. So, the middleware signature is `{(getState, dispatch)} => next => action`.

**Returns**
(Function) A store enhancer that applies the given middleware. The store enahncer signature is `createStore => createStore` but he easiest way to apply it is to pass it to `createStore()` as the last `enhancer` argument.

TBC



{% highlight js linenos %}
{% endhighlight %}

#### 1.2.5 `bindActionCreators(actionCreators, dispatch)` ####

Turns an object whose values are [action creators](http://redux.js.org/docs/Glossary.html#action-creator) into an object with the same keys, but with every action creator wrapped into a `dispatch` call so they may be invoked directly.

Normally you should just call `dispatch` directly on your `store` instance. If you use Redux with React, `react-redux` will provide you with the `dispatch` function so you can call it directly, too.

The olly use case for `bindActionCreators` is  when you want to pass some action creators down to a component that isn't aware of Redux, and you don't want to pass `dispatch` or the Redux store to it.

For convenience, you can also pass a single function as the first argument, and get a function in return.

TBC

{% highlight js linenos %}
{% endhighlight %}

#### 1.2.6 `compose(...functions)` ####

Compose function from right to left.

This is a functional programming utility and is included in Redux as a convenience. You might want to use it to apply several [store enhancers](http://redux.js.org/docs/Glossary.html#action-creator) in a row.

**Arguments**

1. (arguments): The functions to compose. Each function is expected to accept a single parameter. Its return value will be provided as an argument to the function standing to the left, and so on. The exception is the right-most argument which can accpet multiple parameters, as it will provide the signature for thre resulting composed function.

**Returns**

(Function): The final function obtained by composing the given functions from right to left.

**Example**

This example demonstrates how to use `compose` to enhance a `store` with `applyMiddleware` and a few developer tools from the `redu-devtools` package.

{% highlight js linenos %}
import { createStore, applyMiddleware, compose } from 'redux'
import thunk from 'redux-thunk'
import DevTools from './containers/DevTools'
import reducer from '../reducers/index'

const store = createStore(
  reducer,
  compose(
    applyMiddleware(thunk),
    DevTools.instrument()
  )
)
{% endhighlight %}

**Tips**

+ All `compose` does is let you write deeply nested function transformations without the rightward drift of the code. Don't give it too much credit!


### 1.3 Change Log

This project adheres to [Semantic Versioning](http://semver.org/)

Every release, along with the migration instructions, is documented on the Github [Releases](https://github.com/reactjs/redux/releases) page.

### 1.4 Patrons

The work on Redux was [funded by the community](https://www.patreon.com/reactdx). 

Meet some of the outstanding companies and individuals that made it possible:

+ [Webflow](https://github.com/webflow)

+ [Ximedes](https://www.ximedes.com/)

+ [HauteLook](http://hautelook.github.io/)

+ [Ken Wheeler](http://kenwheeler.github.io/)

+ [Chung Yen Li](https://www.facebook.com/prototocal.lee)

+ [Sunil Pai](https://twitter.com/threepointone)

+ [Charlie Cheever](https://twitter.com/ccheever)

+ [Eugene G](https://twitter.com/e1g)

+ [Matt Apperson](https://twitter.com/mattapperson)

+ [Jed Watson](https://twitter.com/jedwatson)

+ [Sasha Aickin](https://twitter.com/xander76)

+ [Stefan Tennighkeit](https://twitter.com/whobubble)

+ [Sam Vincent](https://twitter.com/samvincent)

+ Olegzandr Denman

### 1.5 Feedback

We appreciate feedback from the community. You can post feature requests and bug reports on [Product Pains](https://productpains.com/product/redux).

## 5 参考资料 ##

- [Redux](https://github.com/reactjs/redux);

- [Get Started with Redux](https://egghead.io/courses/getting-started-with-redux);

- [Note: Get Started with Redux](https://github.com/tayiorbeii/egghead.io_redux_course_notes);

- [React Code](https://github.com/shunmian/4.1.1_redux-part-one)

