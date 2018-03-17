---
layout: post
title: Redux Part II：Recipies
categories: [04 Web Development]
tags: [Redux]
number: [4.1.2]
fullview: false
shortinfo: 本文是对Rudex框架的介绍。通过一个TodoList App从零开始的构建，读者可以对Redux的主要结构有一个全面的了解。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}
 
## 1 Recipies ##

These are some use cases and code snippets to get you started with Redux in a real app. They assume you understand the topics in [Redux Part I：TodoList App]({ site.baseurl}}/04%20web%20development/2016/10/05/Redux-Part-I_TodoApp.html}})

TBC:

+ [Symbols](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Symbol);

+ [hotreloading with time travel](https://www.youtube.com/watch?v=xsSnOQynTHs)

### 1.1 Migrating to Redux ###

Redux is not a onolithic framework, but a set of contracts and a [few functions that make them work together](http://redux.js.org/docs/api/). The majority of "Redux code" will not even use Redux APIs, as most of the time you'll be writing functions. This makes it easy to migrate both to and from Redux. We don't want to lock you in!

#### 1.1.1 From Flux

[Reducers](http://redux.js.org/docs/Glossary.html#reducer) capture the "essence" of Flux stores, so it's possible to gradually migrate an existing Flux project towards Redux, whether you are using [Flummox](http://github.com/acdlite/flummox), [Alt](http://github.com/goatslacker/alt), [traditional Flux](https://github.com/facebook/flux), or any other Flux library. It is also possible to do the reverse and migrate from Redux to any of these libraries following the same steps. 

Your process will look like this:

+ Create a function called `createFluxStore(reducer)` that creates a Flux store compatible with your existing app from a reducer function. Internally it might look similar to [createStore](http://redux.js.org/docs/api/createStore.html) implementation from Redux. Its dispatch handler should just call the `reducer` for any action, store the next state and emit change.

+ This allows you to gradually rewrite every Flux Store in your app as a reducer, but still export `createFluxStore(reducer)` so the rest of your app is not aware that this is happening and sees the Flux stores.

+ As you rewrite your Stores, you will find that oyu need to avoid certain `Flux` anti-patterns such as fetching API inside the Store, or triggering the actions inside the Stores. Your Flux code will be easier to follow once you port it to be based on reducers!

+ When you have ported all of your Flux Stores to be implemented on top of reducers, you can replace the Flux library with a single Redux store, and combine those reducers you already have into one using [combineReducers(reducers)](http://redux.js.org/docs/api/combineReducers.html).

+ Now all that's left to do is to port the UI to [use react-redux](http://redux.js.org/docs/basics/UsageWithReact.html) or equivalent.

+ Finally, you might want to begin using some Redux idioms like middleware to further simplify your asynchronous code.

#### 1.1.2 From Backbone

Backbone's model layer is quite different from Redux, so we don't suggest mixing them. If possible, it is best that you rewrite your app's model layer from scratch instead of connecting Backbone to Redux. However, if a rewrite is not feasible, you may use [backbone-redux](https://github.com/redbooth/backbone-redux)to migrate gradually, and keep the Redux store in sync with Backbone models and collections.

If your Backbone codebase is too big for a quick rewrite or you don't want to manage interactions between store and models, use `backbone-redux-migrator` to help your two codebases coexist while keeping healthy separation. Once your rewrite finishes, Backbone code can be discarded and your Redux application can work on its own once you configure router.

### 1.2 Using Object Spread Opertor ###

Since one of the core tenets of Redux is to never mutate state, you'll often find yourself using [Object.assign](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) to create copies of objects with new or updated values. For example, in the `todoApp` below `Object.assign()` is used to return a new `state` object with an updated `visibilityFilter` property:

{% highlight js linenos %}
function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    default:
      return state
  }
}
{% endhighlight %}

While effective, using `Object.assign()` can quickly make simple reducers difficult to read given its rather verbose syntax. An alternative approach is to use the spread `...` operator to copy enumerable properties from one object to another in a more succinct way. The object spread operator is conceptually similar to the ES6 [array spread operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator). We can simplifiy the `todoApp` example above by using the object spread syntax:

{% highlight js linenos %}
function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return { ...state, visibilityFilter: action.filter }
    default:
      return state
  }
}
{% endhighlight %}

The advantage of using the object spread syntax becomes more apparent when you're composing complex objects. Below `getAddedIds` maps an array of `id` values to an array of objects with values returned from `getProduct` and `getQuantity`.

{% highlight js linenos %}
return getAddedIds(state.cart).map(id =>
  Object.assign({}, getProduct(state.products, id), {
    quantity: getQuantity(state.cart, id)
  })
)
{% endhighlight %}

Object spread lets us simplify the above `map` call to:

{% highlight js linenos %}
return getAddedIds(state.cart).map(id => ({
  ...getProduct(state.products, id),
  quantity: getQuantity(state.cart, id)
}))
{% endhighlight %}

Since the object spread syntax is still a [Stage 3](https://github.com/sebmarkbage/ecmascript-rest-spread#status-of-this-proposal) proposal for ECMAScript you'll need to use a transpiler such as [Babel](http://babeljs.io/) to use it in production. You can use your existing `es2015` preset, install [babel-plugin-transform-object-rest-spread](http://babeljs.io/docs/plugins/transform-object-rest-spread/) and add it individually to the `plugins` array in your `.babelrc`.

{% highlight js linenos %}
{
  "presets": ["es2015"],
  "plugins": ["transform-object-rest-spread"]
}
{% endhighlight %}

Note that this is still an experimental language feature proposal so it may change in the future. Nevertheless some large projects such as [React Native](https://github.com/facebook/react-native) already use it extensively so it is safe to say that there will be a good automated migration path if it changes.

### 1.3 Reducing Boilerplate ###

Redux is in part [inspired by Flux](http://redux.js.org/docs/introduction/PriorArt.html), and the most common complaint about Flux is how it makes you write a lot of boilerplate. In this recipe, we will consider how Redux lets us choose how verbose we'd like our code to be, depending on personal style, team preferences, longer term maintainability, and son so.

#### 1.3.1 Actions

Actions are plain objects describing what happened in the app, and serve as the sole way to describe an intention to mutate the data. It's important that **actions being objets you have to dispatch is not boilerplate, but one of the [fundamental design choices](http://redux.js.org/docs/introduction/ThreePrinciples.html) of Redux**.

There are frameworks claiming to be similar to Flux, but without a concept of action objects. In terms of being predictable, this is a step backwards from Flux or Redux. If there are no serializable plain object actions, it is impossible to record and replay user sessions, or to implement [hot reloading with time travel](https://www.youtube.com/watch?v=xsSnOQynTHs). If you'd rather modify data directly, you don't need Redux.

Actions look like this:

{% highlight js linenos %}
{ type: 'ADD_TODO', text: 'Use Redux' }
{ type: 'REMOVE_TODO', id: 42 }
{ type: 'LOAD_ARTICLE', response: { ... } }
{% endhighlight %}

It is a common convention that actions have a constant type that helps reducers (or Stores in Flux). We recommend that you use strings not [Symbols](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Symbol) for action types, because strings are serializable, and by using Sumbols you make recording and replaying harder than it needs to be. In Flux, it is tradtionally thought that you would define every action type as string constant:

{% highlight js linenos %}
const ADD_TODO = 'ADD_TODO'
const REMOVE_TODO = 'REMOVE_TODO'
const LOAD_ARTICLE = 'LOAD_ARTICLE'
{% endhighlight %}

Why is this beneficial? **It is often claimed that constants are unnecessary, and for small projects, this might be correct.** For larger projects, there are some benefits to defining action types as constants:

+ It helps keep the naming consistent because all action types are gathered in a single place.

+ Sometimes you want to see all existing actions before working on a new feature. It may be that the action you need was already added by somebody on the team, but you didn't know.

+ The List of action types that were added, removed and changed in a Pull Request helps everyne on the team keep track of scope and implementation of new features.

+ If you make a typo when importing an action constant, you will get `undefined`. Redux will immediately throw when dispatching  such action, and you'll find the mistake sooner.

It is up to you to choose the conventions for your project. You may start by using inline strings, and later transition to constants, and maybe later group them into a single file. Redux does not have any opinion here, so use your best judgment.

#### 1.3.2 Action Creators

It is another common convention that, instead of creating action objects inline in the places where you dispatch the actions, you would create functions generating them.

For example, instead of calling `dispatch` with an object literal

{% highlight js linenos %}
// somewhere in an event handler
dispatch({
  type: 'ADD_TODO',
  text: 'Use Redux'
})
{% endhighlight %}

You might write an action creator in a separate file, and import it into your component.

`actionCreators.js`

{% highlight js linenos %}
export function addTodo(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}
{% endhighlight %}

`AddTodo.js`

{% highlight js linenos %}
import { addTodo } from './actionCreators'

// somewhere in an event handler
dispatch(addTodo('Use Redux'))
{% endhighlight %}

Action creators have often been criticized as boilerplate. Well, you don't have to write them! **You can use object literals if you feel this better suits your project**. There are, however, some benefits for writing action creators you should know about.

Let's say a designer comes back to us after reviewing our prototype, and tells us that we need to allow three todos maximum. We can enforce this by rewriting our action creator to a callback form with [redux-thunk](https://github.com/gaearon/redux-thunk) middleware and adding an early exit:

{% highlight js linenos %}
function addTodoWithoutCheck(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}

export function addTodo(text) {
  // This form is allowed by Redux Thunk middleware
  // described below in “Async Action Creators” section.
  return function (dispatch, getState) {
    if (getState().todos.length === 3) {
      // Exit early
      return
    }
    dispatch(addTodoWithoutCheck(text))
  }
}
{% endhighlight %}

We just modified how the `addTodo` action creator behaves, completely invisible to the calling code. **We don't have to worry about looking at each place where todos are being added, to make sure they have this check.** Action creators let you decouple additional logic around dispatching an action, from the actual components emitting those actions. it's very handy when the application is under heavy development, and the requirements change often.

#### 1.3.3 Generating Action Creators

Some frameworks like [Flummox](https://github.com/acdlite/flummox) generate action type constants automatically from the action creator function definitions. The idea is that you don't need to both define `ADD_TODO` constant and `addTodo()` action creator. Under the hood, such solutions still generate action type constants, but they're created implicitly so it's a level of indirection and can cause confusion. We recommend creating your action type constatns explicitly.

Writing simple action creators can be tiresome and often ends up generating redundant boilerplate code:

{% highlight js linenos %}
export function addTodo(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}

export function editTodo(id, text) {
  return {
    type: 'EDIT_TODO',
    id,
    text
  }
}

export function removeTodo(id) {
  return {
    type: 'REMOVE_TODO',
    id
  }
}
{% endhighlight %}

You can always write a function that generates an action creator:

{% highlight js linenos %}
function makeActionCreator(type, ...argNames) {
  return function (...args) {
    let action = { type }
    argNames.forEach((arg, index) => {
      action[argNames[index]] = args[index]
    })
    return action
  }
}

const ADD_TODO = 'ADD_TODO'
const EDIT_TODO = 'EDIT_TODO'
const REMOVE_TODO = 'REMOVE_TODO'

export const addTodo = makeActionCreator(ADD_TODO, 'text')
export const editTodo = makeActionCreator(EDIT_TODO, 'id', 'text')
export const removeTodo = makeActionCreator(REMOVE_TODO, 'id')
{% endhighlight %}

There are also utility libraries to aid in generating action creators such as [redux-act](https://github.com/pauldijou/redux-act) and [redux-actions](https://github.com/acdlite/redux-actions). These can help reduce boilerplate code and enforce adherence to standards such as [Flux Standard](https://github.com/acdlite/flux-standard-action)

#### 1.3.4 Async Action Creators

> [Middleware](http://redux.js.org/docs/Glossary.html#middleware) lets you inject custom logic that iterprets every action object before it is dispatched. Async actions are the most common use case for middleware.

Without any middleware, `dispatch` only accepts a plain object, so we have to perform AJAX calls inside our components.

`actionCreator.js`

{% highlight js linenos %}
export function loadPostsSuccess(userId, response) {
  return {
    type: 'LOAD_POSTS_SUCCESS',
    userId,
    response
  }
}

export function loadPostsFailure(userId, error) {
  return {
    type: 'LOAD_POSTS_FAILURE',
    userId,
    error
  }
}

export function loadPostsRequest(userId) {
  return {
    type: 'LOAD_POSTS_REQUEST',
    userId
  }
}
{% endhighlight %}

`UserInfo.js`

{% highlight js linenos %}
import { Component } from 'react'
import { connect } from 'react-redux'
import {
  loadPostsRequest,
  loadPostsSuccess,
  loadPostsFailure
} from './actionCreators'

class Posts extends Component {
  loadData(userId) {
    // Injected into props by React Redux `connect()` call:
    let { dispatch, posts } = this.props

    if (posts[userId]) {
      // There is cached data! Don't do anything.
      return
    }

    // Reducer can react to this action by setting
    // `isFetching` and thus letting us show a spinner.
    dispatch(loadPostsRequest(userId))

    // Reducer can react to these actions by filling the `users`.
    fetch(`http://myapi.com/users/${userId}/posts`).then(
      response => dispatch(loadPostsSuccess(userId, response)),
      error => dispatch(loadPostsFailure(userId, error))
    )
  }

  componentDidMount() {
    this.loadData(this.props.userId)
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.userId !== this.props.userId) {
      this.loadData(nextProps.userId)
    }
  }

  render() {
    if (this.props.isFetching) {
      return <p>Loading...</p>
    }

    let posts = this.props.posts.map(post =>
      <Post post={post} key={post.id} />
    )

    return <div>{posts}</div>
  }
}

export default connect(state => ({
  posts: state.posts
}))(Posts)
{% endhighlight %}

However, this quickly gets repetitive because different components request data from the sam PAI endpoints. Moreover, we want to reuse some of this logic (e.g. early exit when there is cached data available) from many components.

**Middleware let us write more expressive, potentially async action creators.** It lets us dispatch something other than plain obejcts, and interprets the values. For example, middleware can "catch" dispatched Promises and turn them into a paire of request and success/failure actions.

The simplest example of middleware is [redux-thunk](https://github.com/gaearon/redux-thunk). **"Thunk" middleware lets you write action creators as "thunks", that is, functions returning functions.** This invertes the control: you will get `dispatch` as an argument, so you can write an action creator that dispatches many times.

> **Note**: Thunk middleware is just one example of middleware. Middleware is not about "letting you dispatch functions". It's about letting you dispatch anything that the particular middlware you use knows how to handle. Thunk middleware adds a specific behavior when you dispatch functions, but it really depends on the middleware you use.

Consider the code above rewritten with `redux-thunk`:

`actionCreators.js`

{% highlight js linenos %}
export function loadPosts(userId) {
  // Interpreted by the thunk middleware:
  return function (dispatch, getState) {
    let { posts } = getState()
    if (posts[userId]) {
      // There is cached data! Don't do anything.
      return
    }

    dispatch({
      type: 'LOAD_POSTS_REQUEST',
      userId
    })

    // Dispatch vanilla actions asynchronously
    fetch(`http://myapi.com/users/${userId}/posts`).then(
      response =>
        dispatch({
          type: 'LOAD_POSTS_SUCCESS',
          userId,
          response
        }),
      error =>
        dispatch({
          type: 'LOAD_POSTS_FAILURE',
          userId,
          error
        })
    )
  }
}
{% endhighlight %}

`UserInfo.js`

{% highlight js linenos %}
import { Component } from 'react'
import { connect } from 'react-redux'
import { loadPosts } from './actionCreators'

class Posts extends Component {
  componentDidMount() {
    this.props.dispatch(loadPosts(this.props.userId))
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.userId !== this.props.userId) {
      this.props.dispatch(loadPosts(nextProps.userId))
    }
  }

  render() {
    if (this.props.isFetching) {
      return <p>Loading...</p>
    }

    let posts = this.props.posts.map(post =>
      <Post post={post} key={post.id} />
    )

    return <div>{posts}</div>
  }
}

export default connect(state => ({
  posts: state.posts
}))(Posts)
{% endhighlight %}

This is much less typing! If you'd like, you can still have "vanilla" action creators like `loadPostsSuccess` which you'd use from a container `loadPosts` action creator.

**Finally, you can write your own middleware.** Let's say you want to generalize the pattern above and describe your async action creators like this instead:

{% highlight js linenos %}
export function loadPosts(userId) {
  return {
    // Types of actions to emit before and after
    types: ['LOAD_POSTS_REQUEST', 'LOAD_POSTS_SUCCESS', 'LOAD_POSTS_FAILURE'],
    // Check the cache (optional):
    shouldCallAPI: state => !state.posts[userId],
    // Perform the fetching:
    callAPI: () => fetch(`http://myapi.com/users/${userId}/posts`),
    // Arguments to inject in begin/end actions
    payload: { userId }
  }
}
{% endhighlight %}

The middleware that interprets such actions could look like this:

{% highlight js linenos %}
function callAPIMiddleware({ dispatch, getState }) {
  return next => action => {
    const {
      types,
      callAPI,
      shouldCallAPI = () => true,
      payload = {}
    } = action

    if (!types) {
      // Normal action: pass it on
      return next(action)
    }

    if (
      !Array.isArray(types) ||
      types.length !== 3 ||
      !types.every(type => typeof type === 'string')
    ) {
      throw new Error('Expected an array of three string types.')
    }

    if (typeof callAPI !== 'function') {
      throw new Error('Expected callAPI to be a function.')
    }

    if (!shouldCallAPI(getState())) {
      return
    }

    const [requestType, successType, failureType] = types

    dispatch(
      Object.assign({}, payload, {
        type: requestType
      })
    )

    return callAPI().then(
      response =>
        dispatch(
          Object.assign({}, payload, {
            response,
            type: successType
          })
        ),
      error =>
        dispatch(
          Object.assign({}, payload, {
            error,
            type: failureType
          })
        )
    )
  }
}
{% endhighlight %}

After passing it once to [applyMiddleware(...middlewares)](http://redux.js.org/docs/api/applyMiddleware.html), you can write all your API-calling action creators the same way:

{% highlight js linenos %}
export function loadPosts(userId) {
  return {
    types: ['LOAD_POSTS_REQUEST', 'LOAD_POSTS_SUCCESS', 'LOAD_POSTS_FAILURE'],
    shouldCallAPI: state => !state.posts[userId],
    callAPI: () => fetch(`http://myapi.com/users/${userId}/posts`),
    payload: { userId }
  }
}

export function loadComments(postId) {
  return {
    types: [
      'LOAD_COMMENTS_REQUEST',
      'LOAD_COMMENTS_SUCCESS',
      'LOAD_COMMENTS_FAILURE'
    ],
    shouldCallAPI: state => !state.comments[postId],
    callAPI: () => fetch(`http://myapi.com/posts/${postId}/comments`),
    payload: { postId }
  }
}

export function addComment(postId, message) {
  return {
    types: [
      'ADD_COMMENT_REQUEST',
      'ADD_COMMENT_SUCCESS',
      'ADD_COMMENT_FAILURE'
    ],
    callAPI: () =>
      fetch(`http://myapi.com/posts/${postId}/comments`, {
        method: 'post',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message })
      }),
    payload: { postId, message }
  }
}
{% endhighlight %}

#### 1.3.5 Reducers

Redux reduces the boilerplate of Flux stores considerably by describing the update logic as a function. A funciton is simpler than an object and much simpler than a class.

Consider this Flux store:

{% highlight js linenos %}
let _todos = []

const TodoStore = Object.assign({}, EventEmitter.prototype, {
  getAll() {
    return _todos
  }
})

AppDispatcher.register(function (action) {
  switch (action.type) {
    case ActionTypes.ADD_TODO:
      let text = action.text.trim()
      _todos.push(text)
      TodoStore.emitChange()
  }
})

export default TodoStore
{% endhighlight %}

With Redux, the same update logic can be described as a reducing function:

{% highlight js linenos %}
export function todos(state = [], action) {
  switch (action.type) {
    case ActionTypes.ADD_TODO:
      let text = action.text.trim()
      return [...state, text]
    default:
      return state
  }
}
{% endhighlight %}

The `switch` statement is not the real boilerplate. The real boilerplate of Flux is conceptual: the need to emit an update, the need to register the Store with a Dispatcher, the need for the Store to be an object (and the complications that arise when you want a universal app).

It's unfortunate that many still choose Flux framework based on whether it uses `switch` statements in the documentation. If you don't like `switch`, you can solve this with a single function, as we show below.

#### 1.3.6 Generating Reducers

Let's write a function that let us express reducers as an object mapping from action types to handlers. For example, if we want our `todos` reducers to be defined like this: 

{% highlight js linenos %}
export const todos = createReducer([], {
  [ActionTypes.ADD_TODO](state, action) {
    let text = action.text.trim()
    return [...state, text]
  }
})
{% endhighlight %}

We can write the following helper to accomplish this:

{% highlight js linenos %}
function createReducer(initialState, handlers) {
  return function reducer(state = initialState, action) {
    if (handlers.hasOwnProperty(action.type)) {
      return handlers[action.type](state, action)
    } else {
      return state
    }
  }
}
{% endhighlight %}

This wasn't difficult, was it? Redux doesn't provide such a helper function by default because there are many ways to write it. Maybe you want it to automatically convert plain JS objects to Immutable objects to hydratet the server state. Maybe you want to merge the returned state with the current state. There may be different approches to a "catch all" handler. All of this depends on the conventions you choose foryour team on a specific project..

The Redux reducer API is `(state, action) => state`, but how you crewate those reducers is up to you.


### 1.4 Server Rendering ###

The most common use case for server-side rendering is to handle the initial render when a user (or search engine crawler) firt requests our app. When the server receives the request, it redners the required components(s) into an HTML string, and then sends it as aresponse to the client. From that point on, the client takes over rendering duties.

We will use React in the examples below, but the same techniques can be used with other view frameworks that can render on the server.

#### 1.4.1 Redux on the Server

#### 1.4.2 Stting Up

#### 1.4.3 The Server Side

#### 1.4.4 The Client Side

#### 1.4.5 Preparing the Initial State

#### 1.4.7 Next Steps

TBC

### 1.5 Writing Tests via `jest`###

Because most of the Redux code you write are functions, and many of them are pure, they are easy to test without mocking.

#### 1.5.1 Setting Up

We recommend [Jest](http://facebook.github.io/jest/) as the testing engine. Note that it runs in a Node environment, so you won't have access to the DOM.

{% highlight js linenos %}
npm install --save-dev jest
{% endhighlight %}

To use it together with [Babel](http://babeljs.io/), you will need to install `babel-jest`:

{% highlight js linenos %}
npm install --save-dev babel-jest
{% endhighlight %}

and configure it to use ES2015 features in `.babelrc`:

{% highlight js linenos %}
{
  "presets": ["es2015"]
}
{% endhighlight %}

Then, add this to `scripts` in your `package.json`:

{% highlight js linenos %}
{
  ...
  "scripts": {
    ...
    "test": "jest",
    "test:watch": "npm test -- --watch"
  },
  ...
}
{% endhighlight %}

and run `npm test` to run it once, or `npm run test:watch` to test on every file change.

#### 1.5.2 Action Creators

In Redux, action creators are functions which return plain objects. When testing action creators we want to test whether the correct action creator was called and also whether the right action was returned.

{% highlight js linenos %}
export function addTodo(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}
{% endhighlight %}

can be tested like:

{% highlight js linenos %}
import * as actions from '../../actions/TodoActions'
import * as types from '../../constants/ActionTypes'

describe('actions', () => {
  it('should create an action to add a todo', () => {
    const text = 'Finish docs'
    const expectedAction = {
      type: types.ADD_TODO,
      text
    }
    expect(actions.addTodo(text)).toEqual(expectedAction)
  })
})
{% endhighlight %}

#### 1.5.3 Async Action Creators

For async action creators using [Redux Thunk](https://github.com/gaearon/redux-thunk) or other middleware, it's best to completely mock the Redux store for tests. You can apply the middleware to a mock store using [redux-mock-store](https://github.com/arnaudbenard/redux-mock-store). You can aslo use [fetch-mock](http://www.wheresrhys.co.uk/fetch-mock/) to mock the HTTP requests.


{% highlight js linenos %}
import fetch from 'isomorphic-fetch'

function fetchTodosRequest() {
  return {
    type: FETCH_TODOS_REQUEST
  }
}

function fetchTodosSuccess(body) {
  return {
    type: FETCH_TODOS_SUCCESS,
    body
  }
}

function fetchTodosFailure(ex) {
  return {
    type: FETCH_TODOS_FAILURE,
    ex
  }
}

export function fetchTodos() {
  return dispatch => {
    dispatch(fetchTodosRequest())
    return fetch('http://example.com/todos')
      .then(res => res.json())
      .then(json => dispatch(fetchTodosSuccess(json.body)))
      .catch(ex => dispatch(fetchTodosFailure(ex)))
  }
}
{% endhighlight %}

can be tested

{% highlight js linenos %}
import configureMockStore from 'redux-mock-store'
import thunk from 'redux-thunk'
import * as actions from '../../actions/TodoActions'
import * as types from '../../constants/ActionTypes'
import fetchMock from 'fetch-mock'
import expect from 'expect' // You can use any testing library

const middlewares = [thunk]
const mockStore = configureMockStore(middlewares)

describe('async actions', () => {
  afterEach(() => {
    fetchMock.reset()
    fetchMock.restore()
  })

  it('creates FETCH_TODOS_SUCCESS when fetching todos has been done', () => {
    fetchMock
      .getOnce('/todos', { body: { todos: ['do something'] }, headers: { 'content-type': 'application/json' } })


    const expectedActions = [
      { type: types.FETCH_TODOS_REQUEST },
      { type: types.FETCH_TODOS_SUCCESS, body: { todos: ['do something'] } }
    ]
    const store = mockStore({ todos: [] })

    return store.dispatch(actions.fetchTodos()).then(() => {
      // return of async actions
      expect(store.getActions()).toEqual(expectedActions)
    })
  })
})
{% endhighlight %}

#### 1.5.4 Reducers

> A **reducer** should return the new state after applying the action to the previous state, and that's the behavior tested below.

{% highlight js linenos %}
import { ADD_TODO } from '../constants/ActionTypes'

const initialState = [
  {
    text: 'Use Redux',
    completed: false,
    id: 0
  }
]

export default function todos(state = initialState, action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        {
          id: state.reduce((maxId, todo) => Math.max(todo.id, maxId), -1) + 1,
          completed: false,
          text: action.text
        },
        ...state
      ]

    default:
      return state
  }
}
{% endhighlight %}

can be tested

{% highlight js linenos %}
import reducer from '../../reducers/todos'
import * as types from '../../constants/ActionTypes'

describe('todos reducer', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual([
      {
        text: 'Use Redux',
        completed: false,
        id: 0
      }
    ])
  })

  it('should handle ADD_TODO', () => {
    expect(
      reducer([], {
        type: types.ADD_TODO,
        text: 'Run the tests'
      })
    ).toEqual([
      {
        text: 'Run the tests',
        completed: false,
        id: 0
      }
    ])

    expect(
      reducer(
        [
          {
            text: 'Use Redux',
            completed: false,
            id: 0
          }
        ],
        {
          type: types.ADD_TODO,
          text: 'Run the tests'
        }
      )
    ).toEqual([
      {
        text: 'Run the tests',
        completed: false,
        id: 1
      },
      {
        text: 'Use Redux',
        completed: false,
        id: 0
      }
    ])
  })
})
{% endhighlight %}

#### 1.5.5 Components

A nice thing about React components is that they are usually small and only rely on their props. That makes them easy to test.

First we will install [Enzyme](http://airbnb.io/enzyme/) `npm install --save-dev enzyme`. Enzyme uses the [React Test Utilities](https://facebook.github.io/react/docs/test-utils.html) underneath, but is more convenient, readable, and powerful. To test the components we make a `setup()` helper that passes the stubbed callbacks as props and renders the component with [shallow renderting](http://airbnb.io/enzyme/docs/api/shallow.html). This lets individual tests assert on whether the callbacks were called when expected.

{% highlight js linenos %}
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import TodoTextInput from './TodoTextInput'

class Header extends Component {
  handleSave(text) {
    if (text.length !== 0) {
      this.props.addTodo(text)
    }
  }

  render() {
    return (
      <header className="header">
        <h1>todos</h1>
        <TodoTextInput
          newTodo={true}
          onSave={this.handleSave.bind(this)}
          placeholder="What needs to be done?"
        />
      </header>
    )
  }
}

Header.propTypes = {
  addTodo: PropTypes.func.isRequired
}

export default Header
{% endhighlight %}

can be tested like:

{% highlight js linenos %}
import React from 'react'
import { mount } from 'enzyme'
import Header from '../../components/Header'

function setup() {
  const props = {
    addTodo: jest.fn()
  }

  const enzymeWrapper = mount(<Header {...props} />)

  return {
    props,
    enzymeWrapper
  }
}

describe('components', () => {
  describe('Header', () => {
    it('should render self and subcomponents', () => {
      const { enzymeWrapper } = setup()

      expect(enzymeWrapper.find('header').hasClass('header')).toBe(true)

      expect(enzymeWrapper.find('h1').text()).toBe('todos')

      const todoInputProps = enzymeWrapper.find('TodoTextInput').props()
      expect(todoInputProps.newTodo).toBe(true)
      expect(todoInputProps.placeholder).toEqual('What needs to be done?')
    })

    it('should call addTodo if length of text is greater than 0', () => {
      const { enzymeWrapper, props } = setup()
      const input = enzymeWrapper.find('TodoTextInput')
      input.props().onSave('')
      expect(props.addTodo.mock.calls.length).toBe(0)
      input.props().onSave('Use Redux')
      expect(props.addTodo.mock.calls.length).toBe(1)
    })
  })
})
{% endhighlight %}

#### 1.5.6 Connected Components

If you use a library like [React Redux](https://github.com/reactjs/react-redux), you might be using [higher-order components](https://medium.com/@dan_abramov/mixins-are-dead-long-live-higher-order-components-94a0d2f9e750) like [connect()](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options). This lets you inject Redux state into a regular React component.

Consider the following `App` component:

{% highlight js linenos %}
import { connect } from 'react-redux'

class App extends Component { /* ... */ }

export default connect(mapStateToProps)(App)
{% endhighlight %}

In a unit test, you would normally import the `App` component like this:

{% highlight js linenos %}
import App from './App'
{% endhighlight %}

However, when you import it, you're actually holding the wrapper component returned by `connect()`, and not the `App` component itself. If you want to test its interaction with Redux, this is good news: you can wrap it in a `<Provider>` with a store created specifically for this unit test. But sometimes you want to test just the rendering of the component, without a Redux store. In order to be able to test the App component itself without having to deal with the decorator, we recommend you to also export the undecorated component:

{% highlight js linenos %}
import { connect } from 'react-redux'

// Use named export for unconnected component (for tests)
export class App extends Component { /* ... */ }

// Use default export for the connected component (for app)
export default connect(mapStateToProps)(App)
{% endhighlight %}

Since the default export is still the decorated component, the import statement pictured above will work as before so you won't have to change your application code. However, you can now import the undecorated `App` components in your test file like this:

{% highlight js linenos %}
// Note the curly braces: grab the named export instead of default export
import { App } from './App'
{% endhighlight %}

And if you need both:

{% highlight js linenos %}
import ConnectedApp, { App } from './App'
{% endhighlight %}

In the app itself, you would still import it normally:

{% highlight js linenos %}
import App from './App'
{% endhighlight %}

You would only use the named export for tests.


#### 1.5.7 Middleware

Middleware functions wrap behavior of `dispatch` calls in Redux, so to test this modified behavior we need to mock the behavior of the `dispatch` call.

First we'll need a middlware function. This is similar to the [redux-thunk](https://github.com/gaearon/redux-thunk/blob/master/src/index.js)

{% highlight js linenos %}
const thunk = ({ dispatch, getState }) => next => action => {
  if (typeof action === 'function') {
    return action(dispatch, getState)
  }

  return next(action)
}
{% endhighlight %}

We need to create a fake `getState`, `dispatch`, and `next` functions. We use `jest.fn()` to create stubs, but with other test frameworks you would likely use sinon.

The invoke function runs our middleware in the same way Redux does.

{% highlight js linenos %}
const create = () => {
  const store = {
    getState: jest.fn(() => ({})),
    dispatch: jest.fn(),
  };
  const next = jest.fn()

  const invoke = (action) => thunk(store)(next)(action)

  return {store, next, invoke}
};
{% endhighlight %}

We test that our middleware is calling the `getState`, `dispatch`, and `next` functions at the right time.

{% highlight js linenos %}
it(`passes through non-function action`, () => {
  const { next, invoke } = create()
  const action = {type: 'TEST'}
  invoke(action)
  expect(next).toHaveBeenCalledWith(action)
})

it('calls the function', () => {
  const { invoke } = create()
  const fn = jest.fn()
  invoke(fn)
  expect(fn).toHaveBeenCalled()
});

it('passes dispatch and getState', () => {
  const { store, invoke } = create()
  invoke((dispatch, getState) => {
    dispatch('TEST DISPATCH')
    getState();
  })
  expect(store.dispatch).toHaveBeenCalledWith('TEST DISPATCH')
  expect(store.getState).toHaveBeenCalled()
});
{% endhighlight %}

In some cases, you will need to modify the `create` function to use different mock implementations of `getState` and `next`.

### 1.6 Computing Derived Data via `reselect`###

[Reselect](https://github.com/reactjs/reselect) is a simple library for creating memoized, composable **selector** functions. Reselect selectors can be used to efficiently computed derived data from the Redux store.

#### 1.6.1 Motivation for Memoized Selectors

Let's revisit the [Todos List example](http://redux.js.org/docs/basics/UsageWithReact.html).

`containers/VisibleTodoList.js`

{% highlight js linenos %}
import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TodoList from '../components/TodoList'

const getVisibleTodos = (todos, filter) => {
  switch (filter) {
    case 'SHOW_ALL':
      return todos
    case 'SHOW_COMPLETED':
      return todos.filter(t => t.completed)
    case 'SHOW_ACTIVE':
      return todos.filter(t => !t.completed)
  }
}

const mapStateToProps = state => {
  return {
    todos: getVisibleTodos(state.todos, state.visibilityFilter)
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onTodoClick: id => {
      dispatch(toggleTodo(id))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
{% endhighlight %}

In the above example, `mapStateToProps` calls `getVisibleTodos` to calculate `todos`. This works great, but there is a drawback:  `todos` is calculated every time the component is updated. If the state tree is large, or the calculation is expensive, repeating the calculation on every update may cause performance problems. Reselect can help to avoid these unnecessary recalculations.

**Creating a Memoized Selector**

We would like to replace `getVisibleTodos` with a memoized selector that recalculates `todos` when the value of `state.todos` or `state.visibilityFilter` changes, but not when changes occur in other (unrelated) parts of the state tree. Reselect provides a function `createSelector` for creating memozied selectors. `createSelector` takes an array of input-selectors and transform function as its arguments. If the Redux state tree is mutated in a way that causes the value of an input-selector to change, the selector will call its trabsform function with the values of the input-selectros as arguments and return the result. If the values of the input-selectors are the same as the previous call to the selector, it will return the reviously computed value insteadt of calling the transform function.

Let's define a memoized selector named `getVisibleTodos` to replace the non-memoized version above:

`selectros/index.js`

{% highlight js linenos %}
import { createSelector } from 'reselect'

const getVisibilityFilter = state => state.visibilityFilter
const getTodos = state => state.todos

export const getVisibleTodos = createSelector(
  [getVisibilityFilter, getTodos],
  (visibilityFilter, todos) => {
    switch (visibilityFilter) {
      case 'SHOW_ALL':
        return todos
      case 'SHOW_COMPLETED':
        return todos.filter(t => t.completed)
      case 'SHOW_ACTIVE':
        return todos.filter(t => !t.completed)
    }
  }
)
{% endhighlight %}

In the example above, `getVisibilityFilter` and `getTodos` are input-selectors. They are created as ordinary non-memoized selector functions because they do not transform the data they select. `getVisibleTodos` on the other hand is a memoized selector. It takes `getVisibilifyFilter` and `getTodos` as input-selectors, and a transform function that calculates the filtered todos list.

#### 1.6.2 Composing Selectors

A memoized selector can itself be an input-selector to another memoized selector. Here is `getVisibleTodos` being used as an input-selector to a selector that further filters the todos by keyword:

{% highlight js linenos %}
const getKeyword = state => state.keyword

const getVisibleTodosFilteredByKeyword = createSelector(
  [getVisibleTodos, getKeyword],
  (visibleTodos, keyword) =>
    visibleTodos.filter(todo => todo.text.indexOf(keyword) > -1)
)
{% endhighlight %}

#### 1.6.3 Connecting a Selector to the Redux Store

If you are using [React Redux](https://github.com/reactjs/react-redux), you can call selectors as regular functions inside `mapStateToProps()`:

{% highlight js linenos %}
import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TodoList from '../components/TodoList'
import { getVisibleTodos } from '../selectors'

const mapStateToProps = state => {
  return {
    todos: getVisibleTodos(state)
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onTodoClick: id => {
      dispatch(toggleTodo(id))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
{% endhighlight %}

#### 1.6.4 Accessing React Props in Selectors

This section introduces a hypothetical extension to our app that allows it to support multiple TodoLists. Please not that a full implementation of this extension requires changes to the reducers, components, action etc. that aren't direcly relevant to the topics discussed and have been omitted for brevity.

So far we have only seen selectors receive the Redux store state as an argument, but a selector can receive props too.

Here is an `App` component that renders three `VisibleTodoList` components, each of which has a `listId` prop:

`components/App.js`

{% highlight js linenos %}
import React from 'react'
import Footer from './Footer'
import AddTodo from '../containers/AddTodo'
import VisibleTodoList from '../containers/VisibleTodoList'

const App = () => (
  <div>
    <VisibleTodoList listId="1" />
    <VisibleTodoList listId="2" />
    <VisibleTodoList listId="3" />
  </div>
)
{% endhighlight %}

Each `VisibleTodoList` container should select a different slice of the state depending on the value of the `listId` prop, so let's modify `getVisibilityFilter` and `getTodos` to accept a props argument:

`selectors/todoSelectors.js`

{% highlight js linenos %}
import { createSelector } from 'reselect'

const getVisibilityFilter = (state, props) =>
  state.todoLists[props.listId].visibilityFilter

const getTodos = (state, props) => state.todoLists[props.listId].todos

const getVisibleTodos = createSelector(
  [getVisibilityFilter, getTodos],
  (visibilityFilter, todos) => {
    switch (visibilityFilter) {
      case 'SHOW_COMPLETED':
        return todos.filter(todo => todo.completed)
      case 'SHOW_ACTIVE':
        return todos.filter(todo => !todo.completed)
      default:
        return todos
    }
  }
)
{% endhighlight %}

`props` can be passed to `getVisigleTodos` from `mapStateToProps`:

{% highlight js linenos %}
const mapStateToProps = (state, props) => {
  return {
    todos: getVisibleTodos(state, props)
  }
}
{% endhighlight %}

So now `getVisibleTodos` has access to `props`, and everything seems to be working fine.

**But there is a problem!**

Using the `getVisibleTodos` selector with multiple instances of the `visibleTodoList` container will not correctly memoize:

`container/VisibleTodoList.js`

{% highlight js linenos %}
import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TodoList from '../components/TodoList'
import { getVisibleTodos } from '../selectors'

const mapStateToProps = (state, props) => {
  return {
    // WARNING: THE FOLLOWING SELECTOR DOES NOT CORRECTLY MEMOIZE
    todos: getVisibleTodos(state, props)
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onTodoClick: id => {
      dispatch(toggleTodo(id))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
{% endhighlight %}

A selector created with `createSelector` only returns the cached value when its set of arguments is the same as its previous set of arguments. If we alternate between rendering `<VisibleTodoList listId="1">` and `<VisibleTodoList listId="2">`, the shared selector will alternate between receiving `{listId:1}` and `{listId:2}` as its `props` argument. This will cause the arguments to be different on each call, so the selector will always recompute instead of returning the cacehd value. We'll see how to overcome this limitation in the next section.

#### 1.6.5 Sharing Selectors Across Multiple Components

The example s in this section require React Redux v4.3.0 or greater.

In order to share a selector across multiple `VisibleTodoList` components
and retian memoization, each instance of the component needs its own private copy of the selector. Let's create a function named `makeGetVisibleTodos` that returns a new copy of the `getVisibleTodos` selector each time it is called:

`selectors/todoSelectors.js`

{% highlight js linenos %}
import { createSelector } from 'reselect'

const getVisibilityFilter = (state, props) =>
  state.todoLists[props.listId].visibilityFilter

const getTodos = (state, props) => state.todoLists[props.listId].todos

const makeGetVisibleTodos = () => {
  return createSelector(
    [getVisibilityFilter, getTodos],
    (visibilityFilter, todos) => {
      switch (visibilityFilter) {
        case 'SHOW_COMPLETED':
          return todos.filter(todo => todo.completed)
        case 'SHOW_ACTIVE':
          return todos.filter(todo => !todo.completed)
        default:
          return todos
      }
    }
  )
}
export default makeGetVisibleTodos
{% endhighlight %}

We also need a way to give each instance of a container access to its own private selector. The `mapStateToProps` argument of `connect` can help with this.

**If the `mapStateToProps` argument supplied to `connect` returns a function instead of an object, it will be used to create an individual `mapStateToProps` function for each instance of the container.**

In the exanpmle below `makeMapeStateToProps` creates a new `getVisibleTodos` selector, and returns a `mapStateToProps` function that has exclusive access to the new selector:

{% highlight js linenos %}
const makeMapStateToProps = () => {
  const getVisibleTodos = makeGetVisibleTodos()
  const mapStateToProps = (state, props) => {
    return {
      todos: getVisibleTodos(state, props)
    }
  }
  return mapStateToProps
}
{% endhighlight %}

If we pass `makeMapStateToProps` to `connect`, each instance of the `VisibleTodosList` container will get its own `mapStateToProps` function with a private `getVisibleTodos` selector. Memoization will now work correclty regardless of the render order of the `VisibleTodoList` containers.

`containers/VisibleTodoList.js`

{% highlight js linenos %}
import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TodoList from '../components/TodoList'
import { makeGetVisibleTodos } from '../selectors'

const makeMapStateToProps = () => {
  const getVisibleTodos = makeGetVisibleTodos()
  const mapStateToProps = (state, props) => {
    return {
      todos: getVisibleTodos(state, props)
    }
  }
  return mapStateToProps
}

const mapDispatchToProps = dispatch => {
  return {
    onTodoClick: id => {
      dispatch(toggleTodo(id))
    }
  }
}

const VisibleTodoList = connect(
  makeMapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
{% endhighlight %}

#### 1.6.6 Next Steps

Checkout the [offical documentation](https://github.com/reactjs/reselect) of Reselect as well as its [FAQ](https://github.com/reactjs/reselect#faq). Most Redux projects start using Reselect when they have performance problems because of too many derived computations and wasted re-renders, so make sure you are familiar with it before you build something big. It can also be useful to study [its source code](https://github.com/reactjs/reselect/blob/master/src/index.js) so you don't think it's magic.

### 1.7 Implementing Undo History via `redux-undo`###

Building an Undo and Redo functionality into an app has traditionally required conscious effort from the developer. It is not an easy problem with classical MVC frameworks because you need to keep track of every past state by cloning all relevant models. In addition, you need to be mindful of the undo stack because the user-initiated changes should be undoable.

This means that implementing Undo and Redo in an MVC application usually forces you to rewrite parts of your applicatoin to use a specific dat.a mutation pattern like [Command](https://en.wikipedia.org/wiki/Command_pattern).

With Redux, however, implementing undo history is a breeze. There are three reasons for this:

+ There are no multiple models - just a state subtree that you want to keep track of.

+ The state is already immutable, and mutations are already described as discrete actions, which is cloe to the undo stack mental model.

+ The reducer `(state, action) => state` signature makes it natural to implement generic "reducer enhancers" or "higher order reducers". They are functions that take your reducer and enhance it with some additional functionality while preserving its signature. Undo history is exactly such a case.

Before proceeding, make sure you have worked through the [basics tutorial](http://redux.js.org/docs/basics/) and understand [reducer composition](http://redux.js.org/docs/basics/Reducers.html) well. This recipe will build on top of the example described in the [basics tutorial](http://redux.js.org/docs/basics/)

In the first part of this recipe, we will explain the underlying concepts that make Undo and Redo possible to impplement in a generic way.

In the second part of this recipe, we will show how to use [Redux Undo](https://github.com/omnidan/redux-undo) package that provides this functionality out of the box.

#### 1.7.1 Understanding Undo History

##### 1.7.1.1 Designing the State Shape

Undo history is also part of your app's state, and there is no reason why we should approach it differently. Regardless of the type of the state changing over time, when you implement Undo and Redo, you want to keep track of the history of this state at different points in time.

For example, the state shape of a counter app might look like this:

{% highlight js linenos %}
{
  counter: 10
}
{% endhighlight %}

If we wanted to implement Undo and Redo in such an app, we'd need to store more state so we can anser the following questions:

+ Is there anything left to undo or redo?
+ What is the current state?
+ What are the past (and future) states in the undo stack?

It is reasonable to suggest that our state shape should change to answer these questions:

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    present: 10,
    future: []
  }
}
{% endhighlight %}

Now if user presses "Undo", we want it to change to move into the past:

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2, 3, 4, 5, 6, 7, 8],
    present: 9,
    future: [10]
  }
}
{% endhighlight %}

And further yet:

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2, 3, 4, 5, 6, 7],
    present: 8,
    future: [9, 10]
  }
}
{% endhighlight %}

When the user presses "Redo", we want to move one step back into the future:

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2, 3, 4, 5, 6, 7, 8],
    present: 9,
    future: [10]
  }
}
{% endhighlight %}

Finally, if the user performs an action (e.g. decrement the counter) while we're in the middle of the undo stack, we're going to discard the existing future.

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    present: 8,
    future: []
  }
}
{% endhighlight %}

The interesting part here is that it does not matter whether we want to keep an undo stack of numbers, strings, arrays, or objects. The structure will always be the same:

{% highlight js linenos %}
{
  counter: {
    past: [0, 1, 2],
    present: 3,
    future: [4]
  }
}
{% endhighlight %}

{% highlight js linenos %}
{
  todos: {
    past: [
      [],
      [{ text: 'Use Redux' }],
      [{ text: 'Use Redux', complete: true }]
    ],
    present: [
      { text: 'Use Redux', complete: true },
      { text: 'Implement Undo' }
    ],
    future: [
      [
        { text: 'Use Redux', complete: true },
        { text: 'Implement Undo', complete: true }
      ]
    ]
  }
}
{% endhighlight %}

In general, it looks like this:

{% highlight js linenos %}
{
  past: Array<T>,
  present: T,
  future: Array<T>
}
{% endhighlight %}

It is also up to us whether to keep a single top-level history:

{% highlight js linenos %}
{
  past: [
    { counterA: 1, counterB: 1 },
    { counterA: 1, counterB: 0 },
    { counterA: 0, counterB: 0 }
  ],
  present: { counterA: 2, counterB: 1 },
  future: []
}
{% endhighlight %}

Or many granular histories so user can undo and redo actions in them independently.

{% highlight js linenos %}
{
  counterA: {
    past: [1, 0],
    present: 2,
    future: []
  },
  counterB: {
    past: [0],
    present: 1,
    future: []
  }
}
{% endhighlight %}

We will see later how the approach we take lets us choose how granular Undo and Redo need to be.

##### 1.7.2 Designing the Algorithm

Regardless of the specific data type, the shape of the undo history state is the same:

{% highlight js linenos %}
{
  past: Array<T>,
  present: T,
  future: Array<T>
}
{% endhighlight %}

Let's talk through the algorithm to manipulate the state shape described above. We can define two actions to operate on this state: `UNDO` and `REDO`. In our reducer, we will do the following steps to handle these actions:

**Handling Undo**

+ Remove the last element from the `past`.

+ Set the `present` to the element we removed in the previous step.

+ Insert the old `present` state at the beginning of the `future`.

**Handling Redo**

+ Remove the first element from the `future`.

+ Set the `present` to the element we removed in the previous step.

+ Insert the old `present` state at the end of the `past`.

**Handling Other Actions**

+ Insert the `present` at the end of the `past`.

+ Set the `present` to the new state after handling the action.

+ Clear the `future`.

##### 1.7.1.3 First Attempt: Writing a Reducer

{% highlight js linenos %}
const initialState = {
  past: [],
  present: null, // (?) How do we initialize the present?
  future:[]

  function undoable(state = initialState, action) {
    const { past, present, future } = state
    switch (action.type) {
      case 'UNDO':
        const previous = past[past.length-1]
        const newPast = past.slice(0, past.length-1)
        return {
          past: newPast,
          present: previous,
          future: [present, ...future]
        }
      case 'REDO':
        const next = future[0]
        const newFuture = future.slice(1)
        return {
          past: [...past, present].
          present: next,
          future: newFuture
        }
      default:
        // (?) How do we handle other actions?
        return state
    }
  }
}
{% endhighlight %}

This implementation isn't usable because it leaves out three important questions:

+ Where do we get the initial `present` state from? We don't seem to know it beforehand.

+ Where do we react to the external actions to save the `present` to the `past`?

+ How do we actually delegate the control over the `present` state to a custom reducer?

It seems that reducer isn't the right abstraction, but we're very close.

##### 1.7.1.4 Meet Reducer Enahncers

You might be familiar with [higher order functions](https://en.wikipedia.org/wiki/Higher-order_function). If you use React, you might be familiar with [higher order components](https://medium.com/@dan_abramov/mixins-are-dead-long-live-higher-order-components-94a0d2f9e750). Here is a variation on the same pattern, applied to reducers.

A **reducer enhancer** (or a **higher order reducer**) is a function that takes a reducer, and returns a new reducer that is able to handle new actions, or to hold more state, delegating control to the inner reducer for the actions it doesn't understand. This isn't a new pattern - technically, [combineReducers()](http://redux.js.org/docs/api/combineReducers.html) is also a reducer enhancer because it takes reducers and returns a new reducer.

A reducer enhancer that doesn't do anything looks like this:

{% highlight js linenos %}
function doNothingWith(reducer) {
  return function (state, action) {
    // Just call the passed reducer
    return reducer(state, action)
  }
}
{% endhighlight %}

A reducer enhancer that combines other reducers might look like this:

{% highlight js linenos %}
function combineReducers(reducers) {
  return function (state = {}, action) {
    return Object.keys(reducers).reduce((nextState, key) => {
      // Call every reducer with the part of the state it manages
      nextState[key] = reducers[key](state[key], action)
      return nextState
    }, {})
  }
}
{% endhighlight %}

##### 1.7.5 Second Attempt: Writing a Reducer Enhancer

Now that we have a better understanding of reducer enhancers, we can see that this is exactly what `undoable` shoule have been:

{% highlight js linenos %}

function undoable(reducer) {
  // Call the reducer with empty action to populate the initial state
  const initialState = {
    past: [],
    present: reducer(undefined, {}),
    future: []
  }

  // Return a reducer that handles undo and redo
  return function (state = initialState, action) {
    const { past, present, future } = state

    switch (action.type) {
      case 'UNDO':
        const previous = past[past.length - 1]
        const newPast = past.slice(0, past.length - 1)
        return {
          past: newPast,
          present: previous,
          future: [present, ...future]
        }
      case 'REDO':
        const next = future[0]
        const newFuture = future.slice(1)
        return {
          past: [...past, present],
          present: next,
          future: newFuture
        }
      default:
        // Delegate handling the action to the passed reducer
        const newPresent = reducer(present, action)
        if (present === newPresent) {
          return state
        }
        return {
          past: [...past, present],
          present: newPresent,
          future: []
        }
    }
  }
}
{% endhighlight %}

We can now wrap any reducer into `undoable` reducer enhancer to teachit to react to `UNDO` and `REDO` actions.

{% highlight js linenos %}
// This is a reducer
function todos(state = [], action) {
  /* ... */
}

// This is also a reducer!
const undoableTodos = undoable(todos)

import { createStore } from 'redux'
const store = createStore(undoableTodos)

store.dispatch({
  type: 'ADD_TODO',
  text: 'Use Redux'
})

store.dispatch({
  type: 'ADD_TODO',
  text: 'Implement Undo'
})

store.dispatch({
  type: 'UNDO'
})
{% endhighlight %}

There is an important gotcha: you need to remember to append `.present` to the current state when you retrieve it. You may also check `.past.length` and `.future.length` to determine whether to enable or to disable the Undo and Redo buttons, respectively.

You might have heartd that Redux was influenced by [Elm Architecture](https://github.com/evancz/elm-architecture-tutorial/). It shouldn't come as a surprise that this example is very similar to [elm-undo-redo package](http://package.elm-lang.org/packages/TheSeamau5/elm-undo-redo/2.0.0)

#### 1.7.2 Using Redux Undo

This was all very informative, but can't we just drop a library and use it instead of implementing `undoable` ourselves? Sure, we can! Meet [Redux Undo](https://github.com/omnidan/redux-undo), a library that provides simple Undo and Redo functionality for any part of your Redux tree.

In this part of the recipe, you will learn how to make the [Todo List example](undoable). You can find the full source of this recipe in the [todos-with-undo example that comes with Redux](https://github.com/reactjs/redux/tree/master/examples/todos-with-undo).

##### 1.7.2.1 Installation

First of all, you need to run `npm install --save redux-undo`

This installs the package that provides the `undoable` reducer enhancer.

##### 1.7.2.2 Wrapping the Reducer

You will need to wrap the reducer you wish to enhance with `undoable` function. For example, if you exported a `todos` reducer from a dedicated file, you will want to change it to export the result of calling `undoable()` with the reducer you wrote

**reducers/todos.js**

{% highlight js linenos %}
import undoable, { distinctState } from 'redux-undo'

/* ... */

const todos = (state = [], action) => {
  /* ... */
}

const undoableTodos = undoable(todos, {
  filter: distinctState()
})

export default undoableTodos
{% endhighlight %}

The `distinctState()` filte serves to ignore the actions that didn't result in a state change. There are [many other options](https://github.com/omnidan/redux-undo#configuration) to configure your undoable reducer, like setting the action type for Undo and Redo actions. Note that your `combineReducers()` call will stay exactly as it was, but the `todos` reducer will now refer to the reducer enhanced with Redux Undo:

**reducers/index.js**

{% highlight js linenos %}
import { combineReducers } from 'redux'
import todos from './todos'
import visibilityFilter from './visibilityFilter'

const todoApp = combineReducers({
  todos,
  visibilityFilter
})

export default todoApp
{% endhighlight %}

You may wrap one or more reducers in `undoable` at any level of the reducer composition hierarchy, We choose to wrap `todos` instead of the top-level combined reducer so that changes to `visibilityFilter` are not reflected in the undo history.

##### 1.7.2.3 Updating the Selectors

Now the `todos` part of the state looks like this:

{% highlight js linenos %}
{
  visibilityFilter: 'SHOW_ALL',
  todos: {
    past: [
      [],
      [{ text: 'Use Redux' }],
      [{ text: 'Use Redux', complete: true }]
    ],
    present: [
      { text: 'Use Redux', complete: true },
      { text: 'Implement Undo' }
    ],
    future: [
      [
        { text: 'Use Redux', complete: true },
        { text: 'Implement Undo', complete: true }
      ]
    ]
  }
}
{% endhighlight %}

This means you need to access your state with `state.todos.present` instead of just `state.todos`

**containers/VisibleTodoList.js**

{% highlight js linenos %}
const mapStateToProps = state => {
  return {
    todos: getVisibleTodos(state.todos.present, state.visibilityFilter)
  }
}
{% endhighlight %}

##### 1.7.2.4 Adding the Buttons

Now all you need to do is add the buttons for the Undo and Redo actions.

First, create a new container component called `UndoRedo` for these buttons, we won't bother to split the presentational part into a separate file because it is very small:

**containers/UndoRedo.js**

{% highlight js linenos %}
import React from 'react'

/* ... */

let UndoRedo = ({ canUndo, canRedo, onUndo, onRedo }) => (
  <p>
    <button onClick={onUndo} disabled={!canUndo}>
      Undo
    </button>
    <button onClick={onRedo} disabled={!canRedo}>
      Redo
    </button>
  </p>
)
{% endhighlight %}

You will use `connect()` from [React Redux](https://github.com/reactjs/react-redux) to generate a container component. To determine whether to enable Undo and Redo buttons, you can check `state.todos.past.length` and `state.todos.future.length`. You won't need to write action creators for performing undo and redo because Redux Undo already provides them:

**containers/UndoRedo.js**
{% highlight js linenos %}
/* ... */

import { ActionCreators as UndoActionCreators } from 'redux-undo'
import { connect } from 'react-redux'

/* ... */

const mapStateToProps = state => {
  return {
    canUndo: state.todos.past.length > 0,
    canRedo: state.todos.future.length > 0
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onUndo: () => dispatch(UndoActionCreators.undo()),
    onRedo: () => dispatch(UndoActionCreators.redo())
  }
}

UndoRedo = connect(
  mapStateToProps,
  mapDispatchToProps
)(UndoRedo)

export default UndoRedo
{% endhighlight %}

Now you can add `UndoRedo` component to the `App` component.

**components/App.js**

{% highlight js linenos %}

import React from 'react'
import Footer from './Footer'
import AddTodo from '../containers/AddTodo'
import VisibleTodoList from '../containers/VisibleTodoList'
import UndoRedo from '../containers/UndoRedo'

const App = () => (
  <div>
    <AddTodo />
    <VisibleTodoList />
    <Footer />
    <UndoRedo />
  </div>
)

export default App
{% endhighlight %}

This is it! Run `npm start` in the [example folder](https://github.com/reactjs/redux/tree/master/examples/todos-with-undo) and try it out!

### 1.8 Isolating Subapps ###

Consider the case of a "big" app (contained in a `<BigApp>` component) that embeds smaller "sub-apps" (contained in `<SubApp>` components):

{% highlight js linenos %}
import React, { Component } from 'react'
import SubApp from './subapp'

class BigApp extends Component {
  render() {
    return (
      <div>
        <SubApp />
        <SubApp />
        <SubApp />
      </div>
    )
  }
}
{% endhighlight %}

These `<SubApp>`s will be completely independent. They won't share data or actions, and won't see or communicate with each other.

It's best not to mix this approach with standard Redux reducer composition. For typical web apps, stick with reducer composition. For "product hubs", "dashboards", or enterprise software that groups disparate tools into a unified package, give the sub-app apparoach a try.

The sub-app approach is also useful for large teams that are divided by product or feature verticals. These teams can ship sub-apps independently or in combination with an enclosing "app shell".

Below is a sub-app's root connected component. As usual, it can render more more components, connected or not, as children. Usually we'd render it in `<Provider>` and be done with it.

{% highlight js linenos %}
class App extends Component { ... }
export default connect(mapStateToProps)(App)
{% endhighlight %}

However, we don't have to call `ReactDOM.render(<Provider><App /></Provider>)` if we're interested in hiding the fact that the sub-app component is a Redux app.

Maybe we want to be able to run multiple instances of it in the same "bigger" app and keep it as a complete black box, with Redux being an implementation detail.

To hid Redux behind a React API, we can wrap it in a special component that initializes the store in the constructor:

{% highlight js linenos %}
import React, { Component } from 'react'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import reducer from './reducers'
import App from './App'

class SubApp extends Component {
  constructor(props) {
    super(props)
    this.store = createStore(reducer)
  }

  render() {
    return (
      <Provider store={this.store}>
        <App />
      </Provider>
    )
  }
}
{% endhighlight %}

This way every instance will be independent.

This pattern is not recommended for parts of the same app that share data. However, it can be useful when the bigger app has zero access to the smaller app's internals, and we'd like to keep the fact that they are implemented with Redux as an implementation detail. Each component instance will have its own store, so they won't "know" about each other. 

### 1.9 Structuring Reducers

At its core, Redux is really a fairly simple design patter: all your "write" logic goes into a single function, and the only way to run that logic is to give Redux a plain object that describes something that has happened. The Redux store calls that write logic function and passes in the current state tree and the descriptive object, the write logic function returns some new state tree, and the Redux store notifies any subscriberes that the state tree has changed.

Redux puts some basic constraints on how that write logic function should work. As described in [Reducers](http://redux.js.org/docs/basics/Reducers.html), it has to have a signature of `(previousState,action) => newState`, is known as a **reducer function**, and must be pure and predictable.

Beyond that, Redux does not really care how you actually structure your logic inside that reducer funciton, as long as it obeys those basic rules. This is both a source of freedom and a source of confusion. However, there are a number of common patterns that are widely used when writing reducers, as well as a number of related topics and concepts to be aware of. As an application grows, these patterns play a crucial role in managing reducer code complexity, handling real-world data, and optimizing UI performance.

#### 1.9.1 Prerequisite Concepts

Some of these concepts are already described elsewhere in the Redux documentation. Others are generic and applicable outside of Redux itself, and there are numerous existing articles that cover these concepts in detail. These concepts and techniques form the foundation of writing solid Redux reducer logic.

It is vital that these Prerequisite Concepts are **thoroughly understood** before moving on to more advanced and Redux-specific techniques. A recommended reading list is available at: [Prerequisite Concepts](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html).

It is also important to note that some of these suggestions may or may not be directly applicable based on architectural decisions in a specific application. For example, an application using `Immutable.js` maps to store data would likely have its reducer logic structured at least somewhat differently than an application using plain Javascript objects. This documentation primarily assumes use of plain Javascript objects, but many of the principles would still apply if using other tools.

**Reducer Concpets and Techinuqes**

+ [Basic Reducer Structure](http://redux.js.org/docs/recipes/reducers/BasicReducerStructure.html)

+ [Splitting Reducer Logic](http://redux.js.org/docs/recipes/reducers/SplittingReducerLogic.html)

+ [Refactoring Reducers Example](http://redux.js.org/docs/recipes/reducers/RefactoringReducersExample.html)

+ [Using `combineReducers`](http://redux.js.org/docs/recipes/reducers/UsingCombineReducers.html)

+ [Beyond `combineReducers`](http://redux.js.org/docs/recipes/reducers/BeyondCombineReducers.html)

+ [Normalizing State Shape](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html)

+ [Updating Normalized Data](http://redux.js.org/docs/recipes/reducers/UpdatingNormalizedData.html)

+ [Reusing Reducer Logic](http://redux.js.org/docs/recipes/reducers/ReusingReducerLogic.html)

+ [Immutable Update Patterns](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

+ [Initializing State](http://redux.js.org/docs/recipes/reducers/InitializingState.html)


#### 1.9.2 Basic Reducer Structure and State Shape

##### 1.9.2.1 Basic Reducer Structure

First and foremost, it's important to understand that your entire application really only has **one single reducer function**: the function that you've passed into `createStore` as the first argument. That one single reducer function ultimately needs to do several things:

+ The first time the reducer is called, the `state` value will be `undefined`. The reducer needs to handle this case by supplying a default state value before handling the incoming aciton.

+ It needs to look at the previous state and the dispatched action, and determine what kind of work nedds to be done.

+ Assuming actual changes need to occur, it needs to create new objets and arrays with the updated data and return those.

+ If no changes are needed, it should return the existing state as-is.

The simplest possible approach to wrting reducer logic is to put everything into a single funciton declaration, like this:

{% highlight js linenos %}
function counter(state, action) {
  if (typeof state === 'undefined') {
    state = 0; // If state is undefined, initialize it with a default value
  }

  if (action.type === 'INCREMENT') {
    return state + 1;
  } 
  else if (action.type === 'DECREMENT') {
    return state - 1;
  } 
  else {
    return state; // In case an action is passed in we don't understand
  }
}
{% endhighlight %}

Notice that this simple function fulfills all the basic requirements. It returns a default value if none exists, initializing the store; it determines what sort of update needs to be done based on the type of the action, and returns new values; and it returns the previous state if no work needs to be done.

There are some simple tweaks that can be made to this reducer. First, repeated `if/else` statements quickly grow tiresome, so it's very common to use `switch` statements instead. Second, we can use ES6's default parameter values to handle the initial "no existing data" case. With those changes, the reducer would look like:

{% highlight js linenos %}
function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}
{% endhighlight %}

This is the basic structure that a typical Redux reducer function uses.

##### 1.9.2.2 Basic State Shape

Redux encourages you to think about your application in terms of the data you need to manage. The data at any given point in time is the "state" of your application, and the structure and organization of that state is typically referred to as its "shape". The shape of your state plays a major role in how you structure your reducer logic.

A Redux state usually has a plain Javascript object as the top of the state tree. (It is certainly possible to have another type of data instead, such as a single number, an array, or a specialized data structure, but most libraries assume that the top-level value is a plain object.) The most common way to organize data within that top-level object is to further divide data into sub-trees, where each top-level key represents some "domain" or "slice" of related data. For example, a basic Todo app's state might look like:

{% highlight js linenos %}
{
  visibilityFilter: 'SHOW_ALL',
  todos: [
    {
      text: 'Consider using Redux',
      completed: true,
    },
    {
      text: 'Keep all state in a single tree',
      completed: false
    }
  ]
}
{% endhighlight %}

In this example, `todos` and `visibilityFilter` are both top-level keys in the state, and each represents a "slice" of data for some particular concept.

Mmost applications deal with multiple types of data, which can be broadly divided into three categories:

+ **Domain data**: data that the application needs to show, use, or modify (such as "all of the Todos retreived from the server");

+ **App state**: data that is specific to the application's behavior (such as "Todo #5 is currently selected", or "there is a request in progress to fetch Todos");

+ **UI state**: data that represents how the UI is currently displayed (such as "The EditTodo modal dialog is currently open").

Becasue the store represents the core of your application, you should **define your state shape in terms of your domain data and app state, not your UI component tree**. As an example, a shape of `state.leftPane.todoList.todos` would be a bad idea, because the idea of "todos" is central to the whole application, not just a single part of the UI. The `todos` slice should be at the top of the state tree instead.

There will rarely be a 1-to-1 correspondence between your UI tree and your state shape. The exception to that might be if you are eplicitly tracking various aspects of UI data in your Redux store as well, but even then the shape of the UI data and the shape of the domain data would likely be different.

A typucal app's state shape might look roughly like:

{% highlight js linenos %}
{
    domainData1 : {},
    domainData2 : {},
    appState1 : {},
    appState2 : {},
    ui : {
        uiState1 : {},
        uiState2 : {},
    }
}
{% endhighlight %}


#### 1.9.3 Splitting Up Reducer Logic

For any meaningful application, putting all your update logic into a single reducer function is quickly going to become unmaintainable. While there's no single rule for how long a function should be, it's generally agreed that functions should be relatively short and ideally only to one specific thing. Because of this, it's good programming practice to take pieces of code that are very long or do many different things, and break them into smaller pieces that are easier to understand.

Since a Redux reducer is just a funciton, the same concept applies. You can split some of your reducer logic out into another function, and call that new function from the parent function.

These new functions should typically fall into one of three categories:

1. Small utility functions containing some reusable chunk of logic that is needed in multiple places (which may or may not be actually related to the specific business logic);

2. Functions which handling a specific update case, which often need parameters other than the typical `(state, action)` pair

3. Functions which handle all updates of a given slice of state. These functions do generally have the typical `(state, action)` parameter signature.

For clarity, these terms will be used to distinguish between different types of functions and different use cases:

+ **reducer**: any function with the signature `(previousState, action) -> state` (ie, any funciton that could be used as an argument to `Array.prototype.reduce`);

+ **root reducer**: the reducer function that is actually passed as the first argument to `createStore`. This is the only part of the reducer logic that must have the `(previousState, action) ->  state`;

+ **slice reducer**: a reducer that is being used to handle updates to one specific slice of the state tree, usually done by passing it to `combineReducers`;

+ **case function**: a function that is being used to handle the update logic for a specific action. This may actually be a reducer function, or it may require other parameters to do its work properly;

+ **higer-order reducer**: a function that takes a reducer function as an argument, and/or returns a new reducer function as a result (such as `combineReducers`, or `redux-undo`);

The term "sub-reducer" has also been used in various discussions to mean any function that is not the root reducer, although the term is not very precise. Some people may also refer to some functions as "business logic" (functions that relate to application-specific behavior) or "utility functions" (generic functions that are not application-specific).

Breaking down a complex process into smaller, more understandable parts is usually described with the term [functional decomposition](http://stackoverflow.com/questions/947874/what-is-functional-decomposition). This term and concept can be applied generically to any code. However, in Redux it is very common to structure reducer logic using approach #3, where update logic is delegated to other functions based on slice of state. Redux refers to tis concept as **reducer composition**, and it is by far the most widely-used approach to structuring reducer logic. In fact, it's so common that Redux includes a utility function called `combineReducers()`, which specifically abstracts the process of delegating work to other reducer functions based on slices of state. However, it's important to note that it is not the only pattern that can be used. In fact, it's entirely possible to use all three approaches for splitting up logic into functions, and usually a good idea as well. The [Refactoring Reducers]({{site.baseurl}}}/04%20web%20development/2016/10/06/Redux-Part-II_Recipies.html#refactoring-reducers-example) seciton shows some examples of this in action.

#### 1.9.4 Refactoring Reducers Example

It may be helpful to see examples of what the different types of sub-reducer functions look like and how they fit together. Let's look at a demonstration of how a large single reducer funcation can be refactored into a composition of several smaller functions.

##### 1.9.4.1 Initial Reducer

Let's say that our initial reducer looks like this:

{% highlight js linenos %}
const initialState = {
    visibilityFilter : 'SHOW_ALL',
    todos : []
};


function appReducer(state = initialState, action) {
    switch(action.type) {
        case 'SET_VISIBILITY_FILTER' : { 
            return Object.assign({}, state, {
                visibilityFilter : action.filter
            });
        }
        case 'ADD_TODO' : {
            return Object.assign({}, state, {
                todos : state.todos.concat({
                    id: action.id,
                    text: action.text,
                    completed: false
                })
            });
        }
        case 'TOGGLE_TODO' : {
            return Object.assign({}, state, {
                todos : state.todos.map(todo => {
                    if (todo.id !== action.id) {
                      return todo;
                    }

                    return Object.assign({}, todo, {
                        completed : !todo.completed
                    })
                  })
            });
        } 
        case 'EDIT_TODO' : {
            return Object.assign({}, state, {
                todos : state.todos.map(todo => {
                    if (todo.id !== action.id) {
                      return todo;
                    }

                    return Object.assign({}, todo, {
                        text : action.text
                    })
                  })
            });
        } 
        default : return state;
    }
}
{% endhighlight %}

That function is fairly short, but already becoming overly complex. We're dealing with two different areas of concern (filtering vs managing our list of todos), the nesting is making the update logic harder to read, and it's not exactly clear what's going on everywhere.

##### 1.9.4.2 Extracting Utility Functions

A good first step might be to break out a utility function to return a new object with updated fields. There's also a repreated pattern with trying to udpate a specific item in an array that we could extract to a function:

{% highlight js linenos %}
function updateObject(oldObject, newValues) {
    // Encapsulate the idea of passing a new object as the first parameter
    // to Object.assign to ensure we correctly copy data instead of mutating
    return Object.assign({}, oldObject, newValues);
}

function updateItemInArray(array, itemId, updateItemCallback) {
    const updatedItems = array.map(item => {
        if(item.id !== itemId) {
            // Since we only want to update one item, preserve all others as they are now
            return item;
        }

        // Use the provided callback to create an updated item
        const updatedItem = updateItemCallback(item);
        return updatedItem;
    });

    return updatedItems;
}

function appReducer(state = initialState, action) {
    switch(action.type) {
        case 'SET_VISIBILITY_FILTER' : { 
            return updateObject(state, {visibilityFilter : action.filter});
        }
        case 'ADD_TODO' : {
            const newTodos = state.todos.concat({
                id: action.id,
                text: action.text,
                completed: false
            });

            return updateObject(state, {todos : newTodos});
        }
        case 'TOGGLE_TODO' : {
            const newTodos = updateItemInArray(state.todos, action.id, todo => {
                return updateObject(todo, {completed : !todo.completed});
            });

            return updateObject(state, {todos : newTodos});
        } 
        case 'EDIT_TODO' : {
            const newTodos = updateItemInArray(state.todos, action.id, todo => {
                return updateObject(todo, {text : action.text});
            });

            return updateObject(state, {todos : newTodos});
        } 
        default : return state;
    }
}
{% endhighlight %}

That reduced the duplication and made things a bit easier to read.

##### 1.9.4.3 Extracting Case Reducers

Next, we can split each specific case into its own function:

{% highlight js linenos %}
// Omitted
function updateObject(oldObject, newValues) {}
function updateItemInArray(array, itemId, updateItemCallback) {}


function setVisibilityFilter(state, action) {
    return updateObject(state, {visibilityFilter : action.filter });
}

function addTodo(state, action) {
    const newTodos = state.todos.concat({
        id: action.id,
        text: action.text,
        completed: false
    });

    return updateObject(state, {todos : newTodos});
}

function toggleTodo(state, action) {
    const newTodos = updateItemInArray(state.todos, action.id, todo => {
        return updateObject(todo, {completed : !todo.completed});
    });

    return updateObject(state, {todos : newTodos});
}

function editTodo(state, action) {
    const newTodos = updateItemInArray(state.todos, action.id, todo => {
        return updateObject(todo, {text : action.text});
    });

    return updateObject(state, {todos : newTodos});
}

function appReducer(state = initialState, action) {
    switch(action.type) {
        case 'SET_VISIBILITY_FILTER' : return setVisibilityFilter(state, action);
        case 'ADD_TODO' : return addTodo(state, action);
        case 'TOGGLE_TODO' : return toggleTodo(state, action);
        case 'EDIT_TODO' : return editTodo(state, action);
        default : return state;
    }
}
{% endhighlight %}

Now it's very clear what's happening in each case. We can also start to see some patterns emerging.

##### 1.9.4.4 Separating Data Handling by Domain

Our app reducer is still aware of all the different cases for our application. Let's try splitting things up so that the filter logic and the todo logic are separated:

{% highlight js linenos %}
// Omitted
function updateObject(oldObject, newValues) {}
function updateItemInArray(array, itemId, updateItemCallback) {}



function setVisibilityFilter(visibilityState, action) {
    // Technically, we don't even care about the previous state
    return action.filter;
}

function visibilityReducer(visibilityState = 'SHOW_ALL', action) {
    switch(action.type) {
        case 'SET_VISIBILITY_FILTER' : return setVisibilityFilter(visibilityState, action);
        default : return visibilityState;
    }
};


function addTodo(todosState, action) {
    const newTodos = todosState.concat({
        id: action.id,
        text: action.text,
        completed: false
    });

    return newTodos;
}

function toggleTodo(todosState, action) {
    const newTodos = updateItemInArray(todosState, action.id, todo => {
        return updateObject(todo, {completed : !todo.completed});
    });

    return newTodos;
}

function editTodo(todosState, action) {
    const newTodos = updateItemInArray(todosState, action.id, todo => {
        return updateObject(todo, {text : action.text});
    });

    return newTodos;
}

function todosReducer(todosState = [], action) {
    switch(action.type) {
        case 'ADD_TODO' : return addTodo(todosState, action);
        case 'TOGGLE_TODO' : return toggleTodo(todosState, action);
        case 'EDIT_TODO' : return editTodo(todosState, action);
        default : return todosState;
    }
}

function appReducer(state = initialState, action) {
    return {
        todos : todosReducer(state.todos, action),
        visibilityFilter : visibilityReducer(state.visibilityFilter, action)
    };
}
{% endhighlight %}

Notice that because the two "slice of state" reducers are now getting only their own part of the whole state as arguments, they no longer need to return complex nested state objects, and are now simpler as a result.

##### 1.9.4.5 Reducing Boilerplate

We're almost done. Since many people don't like switch statements, it's very common to use a function that creates a lookup table of action types to case functions. We'll use the `createReducer` function described in [Reducing Boilerplate](http://redux.js.org/docs/recipes/ReducingBoilerplate.html#generating-reducers) 

{% highlight js linenos %}
// Omitted
function updateObject(oldObject, newValues) {}
function updateItemInArray(array, itemId, updateItemCallback) {}

function createReducer(initialState, handlers) {
  return function reducer(state = initialState, action) {
    if (handlers.hasOwnProperty(action.type)) {
      return handlers[action.type](state, action)
    } else {
      return state
    }
  }
}


// Omitted
function setVisibilityFilter(visibilityState, action) {}

const visibilityReducer = createReducer('SHOW_ALL', {
    'SET_VISIBILITY_FILTER' : setVisibilityFilter
});

// Omitted
function addTodo(todosState, action) {}
function toggleTodo(todosState, action) {}
function editTodo(todosState, action) {}

const todosReducer = createReducer([], {
    'ADD_TODO' : addTodo,
    'TOGGLE_TODO' : toggleTodo,
    'EDIT_TODO' : editTodo
});

function appReducer(state = initialState, action) {
    return {
        todos : todosReducer(state.todos, action),
        visibilityFilter : visibilityReducer(state.visibilityFilter, action)
    };
}
{% endhighlight %}

##### 1.9.4.6 Combining Reducers by Slice

As our last step, we can now use Redux's built-in `combineReducers` utility to handle the "slice-of-state" logic for our top=level app reducer. Here's the final result:

{% highlight js linenos %}
// Reusable utility functions

function updateObject(oldObject, newValues) {
    // Encapsulate the idea of passing a new object as the first parameter
    // to Object.assign to ensure we correctly copy data instead of mutating
    return Object.assign({}, oldObject, newValues);
}

function updateItemInArray(array, itemId, updateItemCallback) {
    const updatedItems = array.map(item => {
        if(item.id !== itemId) {
            // Since we only want to update one item, preserve all others as they are now
            return item;
        }

        // Use the provided callback to create an updated item
        const updatedItem = updateItemCallback(item);
        return updatedItem;
    });

    return updatedItems;
}

function createReducer(initialState, handlers) {
  return function reducer(state = initialState, action) {
    if (handlers.hasOwnProperty(action.type)) {
      return handlers[action.type](state, action)
    } else {
      return state
    }
  }
}


// Handler for a specific case ("case reducer")
function setVisibilityFilter(visibilityState, action) {
    // Technically, we don't even care about the previous state
    return action.filter;
}

// Handler for an entire slice of state ("slice reducer")
const visibilityReducer = createReducer('SHOW_ALL', {
    'SET_VISIBILITY_FILTER' : setVisibilityFilter
});

// Case reducer
function addTodo(todosState, action) {
    const newTodos = todosState.concat({
        id: action.id,
        text: action.text,
        completed: false
    });

    return newTodos;
}

// Case reducer
function toggleTodo(todosState, action) {
    const newTodos = updateItemInArray(todosState, action.id, todo => {
        return updateObject(todo, {completed : !todo.completed});
    });

    return newTodos;
}

// Case reducer
function editTodo(todosState, action) {
    const newTodos = updateItemInArray(todosState, action.id, todo => {
        return updateObject(todo, {text : action.text});
    });

    return newTodos;
}

// Slice reducer
const todosReducer = createReducer([], {
    'ADD_TODO' : addTodo,
    'TOGGLE_TODO' : toggleTodo,
    'EDIT_TODO' : editTodo
});

// "Root reducer"
const appReducer = combineReducers({
    visibilityFilter : visibilityReducer,
    todos : todosReducer
});
{% endhighlight %}

We now have examples of several kinds of split-up reducer functions: helper utilities like `updateObject` and `createReducer`, handlers for specific cases like `setVisibilityFilter` and `addTodo`, and slice-of-stte handlers like `visibilityReducer` and `todosReducer`. We also can see that `appReducer` is an example of a "root reducer".

Although the final result in this example is noticeably longer than the original version, this is primarily due to the extraction of the utility functions, the addition of comments, and some deliberate verbosity for the sake of clarity, such as separatte return statements. Looking at each function individually, the amount of responsibility is now smaller, and the intent is hopefully clearer. Also, ina real application, there functions would probably then be split into separate files such as `reducerUtilities.js`, `visibilityReducer.js`, `todosReducer.js` and `rootReducer.js`

#### 1.9.5 Using `combineReducers`

##### 1.9.5.1 Core Concepts

The most common state shape for a Redux app is a plain Javascript object containing "slices" of domain-specific data at each top-level key. Similarly, the most common approach to writing reducer logic for that state shape is to have "slice reducer" functions, each with the same `(state, action)` signature, and each responsigle for managing all updates to that specific slice of state. Multiple slice reducers can respond to the same action, independently update their own slice as neede, and the updated slices are combiend into the new state object.

Because this pattern is so common, Redux provides the `combineReducers` utility to implement that behavior. It is an example of a higher-order reducer, which takes an object full of slice reducer functions, and returns a new reducer function.

There are several important ideas to be aware of when using `combineReducers`:

+ First and foremost, `combineReducers` is simply **a utility function to simplify the most common use case when writing Redux reducers**. You are not required to use it in your own application, and it does not handle every posbbile scenario. It is entirely possible to write reducer logic without using it, and it is quite common to need to write custom reducer logic for cases that `combineReducer` does not handler. (see [Beyond `combineReducers`](http://redux.js.org/docs/recipes/reducers/BeyondCombineReducers.html)for examples and suggestions.)

+ While Redux itself is not opinionated about how your state is organized, `combineReducers` enforces several rules to help users avoid common errors. (See [`combineReducers`](http://redux.js.org/docs/api/combineReducers.html) for details.)

+ One frequently asked question is whether Redux "calls all reducers" when dispatching anaction. Since there really is only one root reducer function, the default is "no, it does not". Hoever, `combineReducers` has specific behavior that does work that way. In order to assemble the new state tree, `combineReducers` will call each slice reducer with its current slice of state and the current action, giving the slice reducer a change to respond and update its slice of state if needed. So, in that sense, using `combineReducers` does "call all reducers", or at least all of the slice reducres it is wrapping.

+ You can use it at all levels of your reducer structure, not just to create the root reducer. It's very common to have multiple combined reducers in various places, which are composed together to create the root reducer.

##### 1.9.5.2 Defining State Shape

There are two ways to define the initial shape and contents of your store's state. First, the `createstore` function can take `preloadedState` as its second argument. This is primarily intended for initializing the store with state that was previously persisted elsewhere, such as the browser's localStorgage. The other way is for the root reducer to return the initial state value when the state argument is `undefined`. These two approaches are described in more detail in [Initializing State](http://redux.js.org/docs/recipes/reducers/InitializingState.html), but there are some additional concerns to be aware of when using `combineReducers`.

`combineReducers` takes an object full of slice reducer functions, and creates a function that outputs a corresponding state object with the same keys. This means that if no preloaded state is provided to `createStore`, the naming of the keys in the input slice reducer object will define the naming of the keys in the output state object. The correlation between these names is not always apparent, expecially when using ES6 features such as default module exports and object literal shorthands.

Here's an example of how use of ES6 object literal shorthand with `combineReducers` can define the state shape:

{% highlight js linenos %}
// reducers.js
export default theDefaultReducer = (state = 0, action) => state;

export const firstNamedReducer = (state = 1, action) => state;

export const secondNamedReducer = (state = 2, action) => state;


// rootReducer.js
import {combineReducers, createStore} from "redux";

import theDefaultReducer, {firstNamedReducer, secondNamedReducer} from "./reducers";

// Use ES6 object literal shorthand syntax to define the object shape
const rootReducer = combineReducers({
    theDefaultReducer,
    firstNamedReducer,
    secondNamedReducer
});

const store = createStore(rootReducer);
console.log(store.getState());
// {theDefaultReducer : 0, firstNamedReducer : 1, secondNamedReducer : 2}
{% endhighlight %}

Notice that because we used the ES6 shorthand for defining an object literal, the key names in the resulting state are the same as the variable names from the imports. This may not always be the desired behavior, and is often a cause of confusion for those who aren't as familiar with ES6 syntax.

Also, the resulting names are a bit odd. It's generally not a good practice to actually include words like "reducer" in your state key names - the ekys should simply reflect the domain or type of data they hold. This means we should either explicitly specify the namses of the keys in the slice reducer object to dein the keys in the output stat objec,t or carefully rename the variables for the imported slice reducers to set up the keys when using the shorthand object literal syntax.

A better usage might look like:

{% highlight js linenos %}
import {combineReducers, createStore} from "redux";

// Rename the default import to whatever name we want. We can also rename a named import.
import defaultState, {firstNamedReducer, secondNamedReducer as secondState} from "./reducers";

const rootReducer = combineReducers({
    defaultState,                   // key name same as the carefully renamed default export
    firstState : firstNamedReducer, // specific key name instead of the variable name
    secondState,                    // key name same as the carefully renamed named export
});

const reducerInitializedStore = createStore(rootReducer);
console.log(reducerInitializedStore.getState());
// {defaultState : 0, firstState : 1, secondState : 2}
{% endhighlight %}

This state shape better reflects the data involved, because we took care to set up the keys we passed to `combineReducers`.


#### 1.9.6 Beyond `combineReducers`

The `combineReducers` utility included with Redux is very useful, but is deliberately limited to handle a single common use case: updating a state tree that is a plain Javascrip object, by delegating the work of updating each slice of state to a specific slice reducer. It does not handle other use cases, such as a state tree made up of `Immutable.js` Maps, trying to pass other portions of the state tree as an additional argument to a slice reducer, or performing "ordering" of slice reducer calls. It also does not care how a give slice reducer does its work.

The common question, then, is "How can I use `combineReducers` to handle these other use cases?". The answer to that is simply: "you don't - you probably need to use something else". **Once you go past the core use case for `combineReducers`, it's time to use more "custom" reducer logic**, whether it be specific logic for a one-off use case, or a reusable function that could be widely shared. Here's some suggestions for dealing with a couple of these typical use cases, but fell free to come up with your won approaches.

##### 1.9.6.1 Sharing data between slice reducers

Similarly, if `sliceReducerA` happens to need some data from `sliceReducerB`'s slice of state in order to handle a particular action, or `sliceReducerB` happens to need the entire state as an argument, `combineReducers` does not handle that itself. This could be resolved by writing a custom function that knows to pass the needed data as an additional argument in those specific cases, such as:

{% highlight js linenos %}
function combinedReducer(state, action) {
    switch(action.type) {
        case "A_TYPICAL_ACTION" : {
            return {
                a : sliceReducerA(state.a, action),
                b : sliceReducerB(state.b, action)
            };
        }
        case "SOME_SPECIAL_ACTION" : {
            return {
                // specifically pass state.b as an additional argument
                a : sliceReducerA(state.a, action, state.b),
                b : sliceReducerB(state.b, action)
            }        
        }
        case "ANOTHER_SPECIAL_ACTION" : {
            return {
                a : sliceReducerA(state.a, action),
                // specifically pass the entire state as an additional argument
                b : sliceReducerB(state.b, action, state)
            }         
        }    
        default: return state;
    }
}
{% endhighlight %}

Another alternative to the "shared-slice updates" issue would be to simply put more data into the action. This is easily accomplisehd using thunk funcitons or a similar approach, per this example:


{% highlight js linenos %}
function someSpecialActionCreator() {
    return (dispatch, getState) => {
        const state = getState();
        const dataFromB = selectImportantDataFromB(state);

        dispatch({
            type : "SOME_SPECIAL_ACTION",
            payload : {
                dataFromB
            }
        });
    }
}
{% endhighlight %}

Because the data from B's slice is already in the action, the parent reducer doesn't have to do anything special to make that data available to `sliceReducerA`.

A third approach would be to use the reducer generated by `combineReducers` to handle the "simple" cases where each slice reducer can update itself independently, but also use another reducer to handle the "special" cases where data needs to be shared across slices. Then, a wrapping function could call both of those reducers in turn to generate the final result:

{% highlight js linenos %}
const combinedReducer = combineReducers({
    a : sliceReducerA,
    b : sliceReducerB
}); 

function crossSliceReducer(state, action) {
    switch(action.type) {
        case "SOME_SPECIAL_ACTION" : {
            return {
                // specifically pass state.b as an additional argument
                a : handleSpecialCaseForA(state.a, action, state.b),
                b : sliceReducerB(state.b, action)
            }        
        }
        default : return state;
    }
}

function rootReducer(state, action) {
    const intermediateState = combinedReducer(state, action);
    const finalState = crossSliceReducer(intermediateState, action);
    return finalState;
}
{% endhighlight %}

As it turns out, ther's a useful utility called [reduce-reducers](https://github.com/acdlite/reduce-reducers) that can make that process easier. It simply takes multiple reducers and runs `reduce()` on them, passing the intermediate state values to the next reducer in line:

{% highlight js linenos %}
// Same as the "manual" rootReducer above
const rootReducer = reduceReducers(combinedReducers, crossSliceReducer);
{% endhighlight %}

Note that if you use `reduceReducers`, you should make sure that the first reducer in the list is able to define the initial state, since the later reducers will generally assume that the entire state already exists and not try to provide defaults.

##### 1.9.6.2 Further Suggestions

Again, it's important to understand that Redux reducers are just functions. While `combineReducers` is useful, it's just one tool in the toolbox. Functions can contain conditional logic other than switch statements, functions ca be composed to wrap each other, and functions can call other functions. Matybe you need one of your slice reducers to be able to reset its state, and to only respond to specific actions overall. You could do:

{% highlight js linenos %}
const undoableFilteredSliceA = compose(undoReducer, filterReducer("ACTION_1", "ACTION_2"), sliceReducerA);
const rootReducer = combineReducers({
    a : undoableFilteredSliceA,
    b : normalSliceReducerB
});
{% endhighlight %}

Note that `combineReducers` doesn't know or care that there's anything special about the reducer funciton that's responsible for managing `a`. We didn't need to modify `combinedReducers` to specifically know how to undo things - we just built up the pieces we needed into a new composed function.

Also, while `combineReducers` is the one reducer utility function that's built into Redux, there's a wide variety of third-party reducer utilities that have published for reuse. The [Redux Addons Catalog](https://github.com/markerikson/redux-ecosystem-links) lists many of the third-party utilities that are available. Or, if none of the published utilities solve your use case, you can always write a function yourself that does just exactly what you need.

#### 1.9.7 Normalizing State Shape

Many applications deal with data that is nested or relational in nature. For example, a blog editor could have many Posts, each Post could have many Comments, and both Posts and Comments would be written by a User. Data for this kind of pplication might look like:

{% highlight js linenos %}
const blogPosts = [
    {
        id : "post1",
        author : {username : "user1", name : "User 1"},
        body : "......",
        comments : [
            {
                id : "comment1",
                author : {username : "user2", name : "User 2"},
                comment : ".....",
            },
            {
                id : "comment2",
                author : {username : "user3", name : "User 3"},
                comment : ".....",
            }
        ]    
    },
    {
        id : "post2",
        author : {username : "user2", name : "User 2"},
        body : "......",
        comments : [
            {
                id : "comment3",
                author : {username : "user3", name : "User 3"},
                comment : ".....",
            },
            {
                id : "comment4",
                author : {username : "user1", name : "User 1"},
                comment : ".....",
            },
            {
                id : "comment5",
                author : {username : "user3", name : "User 3"},
                comment : ".....",
            }
        ]    
    }
    // and repeat many times
]
{% endhighlight %}

Notice that the structure of the data is a bit complex, and some of the data is repeated. This is a concern for several reasons:

+ When a piece of data is duplicated in several places, it becomes harder to make sure that it is udpated appropriately.

+ Nested data means that the corresponding reducer logic has to be more nested and therefore more complex. In particular, trying to update a deeply nested fiedl can become very ugly very fast.

+ Since immutable data updates require all ancestors in the state tree to be copied and updated as well, and new object references will cause connected UI components to re-render, an update to a depply nested data object could force toally unrelated UI componenets to re-render even if the data they're dispalying hasn't actually change.

Because of this, the recommended approach to managing relationsal or nested data in a Redux store is to treat a portion of your store as if **it were a database, and keep that data in a normalized form**.

##### 1.9.7.1 Designing a Normalized State

The basic concepts of normalizing data are:

+ Each type of data gets its own "table" in the state.

+ Each "data table" should store the individual items in an object, with the IDs of the items as keys and the items themselves as the values.

+ Any references to individual items should be done by storing the item's ID.

+ Arrays of IDs should be used to indicate ordering.

An example of a normalized state structure for the blog example above might look like:

{% highlight js linenos %}
{
    posts : {
        byId : {
            "post1" : {
                id : "post1",
                author : "user1",
                body : "......",
                comments : ["comment1", "comment2"]    
            },
            "post2" : {
                id : "post2",
                author : "user2",
                body : "......",
                comments : ["comment3", "comment4", "comment5"]    
            }
        },
        allIds : ["post1", "post2"]
    },
    comments : {
        byId : {
            "comment1" : {
                id : "comment1",
                author : "user2",
                comment : ".....",
            },
            "comment2" : {
                id : "comment2",
                author : "user3",
                comment : ".....",
            },
            "comment3" : {
                id : "comment3",
                author : "user3",
                comment : ".....",
            },
            "comment4" : {
                id : "comment4",
                author : "user1",
                comment : ".....",
            },
            "comment5" : {
                id : "comment5",
                author : "user3",
                comment : ".....",
            },
        },
        allIds : ["comment1", "comment2", "comment3", "commment4", "comment5"]
    },
    users : {
        byId : {
            "user1" : {
                username : "user1",
                name : "User 1",
            }
            "user2" : {
                username : "user2",
                name : "User 2",
            }
            "user3" : {
                username : "user3",
                name : "User 3",
            }
        },
        allIds : ["user1", "user2", "user3"]
    }
}
{% endhighlight %}

This state structure is much flatter overall. Compared to the original nested format, this is an improvement in several ways:

+ Because each item is only defined in one place, we don't have to try to make changes in multiple places if that item is updated.

+ The reducer logic doesn't have to deal with depp levels of nesting, so it will probably be much simpler.

+ Since each data type is separated, an update like changing the text of a comment would only require new copies of the "comments > byId > comment" portion of the tree. This will generally mean fewer portions of the UI that need to update because their data has changed. In contrast, updating a comment in the original nested shape would have required updating the comment obejct, the parent post object, the array of all post objects, and likely have caused all of the Post components and Comment components in th UI to re-render themselves.

Note that a normalized state structure generally implies that more components are connected and each component is responsible for looking up its own data, as opposed to a few connected components looking up large amounts of data and passing all that data downwards. As it turns out, having connected parent components simply pass item IDs to connected children is a good pattern for optimizing UI performance in a React Redux application, so keeping state normalized plays a key role in improving performance.

##### 1.9.7.2 Organizing Normalized Data in State

A typical application will likely have a mixture of relational data and non-relational data. While there is no single rule for exactly how those different types of data should be organizedm one common pattern is to put the relational "tables" under a common parent key, such as "entities". A state structure using this approach might look like:

{% highlight js linenos %}
{
    simpleDomainData1: {....},
    simpleDomainData2: {....}
    entities : {
        entityType1 : {....},
        entityType2 : {....}
    }
    ui : {
        uiSection1 : {....},
        uiSection2 : {....}
    }
}
{% endhighlight %}

This could be expanded in a number of ways. For example, an application that does a lot of editing of entities might want to keep two sets of "tables" in the state, one for the "current" item values and one for the "work-in-progress" item values. When an item is edited, its values could be copied into the "work-in-progress" section, and any actions that update it would be applied to the "work-in-progress" copy, allowing the editing form to be controlled by that set of data while another part of the UI still refres to the original version. "Resetting" the edit form would simply require removing the item from the "work-in-progress" section and re-copying the original data from "current" to "work-in-progress", while "applying" the edits would involve copying the values from the "work-in-progress" section to the "current" section.

##### 1.9.7.3 Relationships and Tables

Because we're treating a portion of our Redux store as a "database", many of the principles of database design also apply here as well. For example, if we have a many-to-many relationship, we can model that using an intermediate table that stores the IDs of the corresponding items (often known as a "join table" or an "associative table"). For consistency, we would probably also want to use the same `byId` and `allIds` approach that we used for the actual item tables, like this:

{% highlight js linenos %}
{
    entities: {
        authors : { byId : {}, allIds : [] },
        books : { byId : {}, allIds : [] },
        authorBook : {
            byId : {
                1 : {
                    id : 1,
                    authorId : 5,
                    bookId : 22
                },
                2 : {
                    id : 2,
                    authorId : 5,
                    bookId : 15,
                }
                3 : {
                    id : 3,
                    authorId : 42,
                    bookId : 12
                }
            },
            allIds : [1, 2, 3]

        }
    }
}
{% endhighlight %}

Operations like "Look up all books by this author", can then be accomplished easily with a single loop over the join table. Given the typical amounts of data in a client application and the speed of Javascript engines, this kind of operation is likely to have sufficiently fast perfromance for most use cases.

##### 1.9.7.4 Normalizing Nested Data

Because APIs frequently send back data in a nested form, that data needs to be transformed into a normalized shape before it can be included in the state tree. The [Normaliz](https://github.com/paularmstrong/normalizr) library is usually used for this task. You can define schema types and relations, feed the schema and the response data to Normalizr, and it will output a normalized transformation of the response. That output can then be included in an action and used to update the store. See the normalizr documentation for more details on its usage.

#### 1.9.8 Updating Normalized Data

TBC

#### 1.9.9 Reusing Reducer Logic

As an application grows, common patterns in reducer logic will start to emerge. You may find several parts of your reducer logic doing the same kinds of work for different types of data, and want to reduce duplication by reusing the same common logic for each data type. Or, you may want to hav multiple "instances" of a certain type of data being handled in the store. However, the global structure of a Redux store comes with some trade-offs: it makes it easy to track the overall state of an application, but can also make it harder to "target" actions that need to update a specific piece of state, particularly if you are using `combineReducers`.

As an example, let's say that we want to track multiple counters in our application, named A, B and C. We define our initial `counter` reducer, and we use `combineReducers` to set up our state:

{% highlight js linenos %}
function counter(state = 0, action) {
    switch (action.type) {
        case 'INCREMENT':
            return state + 1;
        case 'DECREMENT':
            return state - 1;
        default:
            return state;
    }
}

const rootReducer = combineReducers({
    counterA : counter,
    counterB : counter,
    counterC : counter
});
{% endhighlight %}

Unfortunately, this setup has a problem. Because `combineReducers` will call each slice reducer with the same action, dispatching `{type: 'INCREMENT'}` will actually cause all three counter values to be incremented, not just one of them. We need some way to wrap the `counter` logic so that we can ensure that only the counter we care about is udpated.

##### 1.9.9.1 Customizing Behavior with Higher-Order Reducers

As defined in [Splitting Reducer Logic](http://redux.js.org/docs/recipes/reducers/SplittingReducerLogic.html), a higher-order reducer is a function that takes a reducer function as an argument, and/or returns a new reducer function as a result. It can also be viewed as a "reducer factory". `combineReducers` is one example of a higher-order reducer. We can use this pattern to create specialized versions of our own reducer functions, with each verion only responding to specific actions.

The two most common ways to specialize a reducer are to generate new action constants with a given prefix or suffix, or to attach additional info inside the action object. Here's what those might look like:

{% highlight js linenos %}
function createCounterWithNamedType(counterName = '') {
    return function counter(state = 0, action) {
        switch (action.type) {
            case `INCREMENT_${counterName}`:
                return state + 1;
            case `DECREMENT_${counterName}`:
                return state - 1;
            default:
                return state;
        }
    }
}

function createCounterWithNameData(counterName = '') {
    return function counter(state = 0, action) {
        const {name} = action;
        if(name !== counterName) return state;

        switch (action.type) {
            case `INCREMENT`:
                return state + 1;
            case `DECREMENT`:
                return state - 1;
            default:
                return state;
        }
    }
}
{% endhighlight %}

We should now be able to use either of these to generate our specialized counter reducers, and then dispatch actions that will affect the portion of the state that we care about:

{% highlight js linenos %}
const rootReducer = combineReducers({
    counterA : createCounterWithNamedType('A'),
    counterB : createCounterWithNamedType('B'),
    counterC : createCounterWithNamedType('C'),
});

store.dispatch({type : 'INCREMENT_B'});
console.log(store.getState());
// {counterA : 0, counterB : 1, counterC : 0}
{% endhighlight %}

We could also vary the approach somewhat, and create a more generic higher-order reducer that accepts both a given reducer funciton and a name or identifier:

{% highlight js linenos %}
function counter(state = 0, action) {
    switch (action.type) {
        case 'INCREMENT':
            return state + 1;
        case 'DECREMENT':
            return state - 1;
        default:
            return state;
    }
}

function createNamedWrapperReducer(reducerFunction, reducerName) {
    return (state, action) => {
        const {name} = action;
        const isInitializationCall = state === undefined;
        if(name !== reducerName && !isInitializationCall) return state;

        return reducerFunction(state, action);    
    }
}

const rootReducer = combineReducers({
    counterA : createNamedWrapperReducer(counter, 'A'),
    counterB : createNamedWrapperReducer(counter, 'B'),
    counterC : createNamedWrapperReducer(counter, 'C'),
});
{% endhighlight %}

You could even go as far as to make a generic filtering higher-order reducer:

{% highlight js linenos %}
function createFilteredReducer(reducerFunction, reducerPredicate) {
    return (state, action) => {
        const isInitializationCall = state === undefined;
        const shouldRunWrappedReducer = reducerPredicate(action) || isInitializationCall;
        return shouldRunWrappedReducer ? reducerFunction(state, action) : state;
    }
}

const rootReducer = combineReducers({
    // check for suffixed strings
    counterA : createFilteredReducer(counter, action => action.type.endsWith('_A')),
    // check for extra data in the action
    counterB : createFilteredReducer(counter, action => action.name === 'B'),
    // respond to all 'INCREMENT' actions, but never 'DECREMENT'
    counterC : createFilteredReducer(counter, action => action.type === 'INCREMENT')
};
{% endhighlight %}

These basic patterns allow you to do things like having multiple instances of a smart connected component within the UI, or reuse common logic for generic capabilities such as pagination or sorting.

In addition to generating reducers this way, you might also want to generate action creators using the same approach, and could generate them both at the same time with helper functions. See [Action/Reducer Generators](https://github.com/markerikson/redux-ecosystem-links/blob/master/action-reducer-generators.md) and [Reducers](https://github.com/markerikson/redux-ecosystem-links/blob/master/reducers.md) libraries for action/reducer utilities.

#### 1.9.10 Immutable Update Patterns

The articles listed in [Prerequisite Concepts#Immutable Data Management](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html#immutable-data-management) give a number of good examples for how to perform basic update operations immutably, such as updating a field in an object or adding an item to the end of an array. However, reducers will often need to use those basic operations in combination to perform more complicated tasks. Here are some examples for some of the more common tasks you might have to implement.

##### 1.9.10.1 Updating Nested Objects

The key to updating nested data is **that every level of nesting must be copied and updated appropriately.** This is often a difficult concept for those learning Redux, and there are some specific problems that frequently occur when trying to update nested objects. These lead to accidental direct mutation, and should be avoided.

**Common Mistake #1: New variables that point to the same objects**

Defining a new variable does not create a new actual object - it only creates another reference to the same object. An example of this error would be: 

{% highlight js linenos %}
function updateNestedState(state, action) {
    let nestedState = state.nestedState;
    // ERROR: this directly modifies the existing object reference - don't do this!
    nestedState.nestedField = action.data;

    return {
        ...state,
        nestedState
    };
}
{% endhighlight %}

This function does correctly return a shallow copy of the top-level state object, but because the `nestedState` variable was still pointing at the existing object, the state was directly mutated.

**Common Mistake #2: Only making a shallow copy of one level**

Another common version of this error looks like this:

{% highlight js linenos %}
function updateNestedState(state, action) {
    // Problem: this only does a shallow copy!
    let newState = {...state};

    // ERROR: nestedState is still the same object!
    newState.nestedState.nestedField = action.data;

    return newState;
}
{% endhighlight %}

Doing a shalow copy of the top level is not sufficient - the `nestedState` object should be copied as well.

**Correct Approach: Copying All Levels of Nested Data**

Unfortunately, the process of correctly applying immutable updates to deeply nested state can easily become verbose and hard to read. Here's what an example of updating `state.firt.second[someId].fourth` might look like:

{% highlight js linenos %}
function updateVeryNestedField(state, action) {
    return {
        ...state,
        first : {
            ...state.first,
            second : {
                ...state.first.second,
                [action.someId] : {
                    ...state.first.second[action.someId],
                    fourth : action.someValue
                }
            }
        }
    }
}
{% endhighlight %}

Obviously, each layer of nesting makes this harder to read, and gives more chances to make mistakes. This is one of several reasons why you are encouraged to keep your state flattened, and compose reducers as much as possible.

##### 1.9.10.2 Inserting and Removing Items in Arrays

Normally, a Javascript array's contents are modified using mutative functions like `push`, `unshift`, and `splice`. Since we don't want to mutate state directly in reducers, those should normally be avoided. Because of that, you might see "insert" or "remove" behavior written like this:

{% highlight js linenos %}
function insertItem(array, action) {
    return [
        ...array.slice(0, action.index),
        action.item,
        ...array.slice(action.index)
    ]
}

function removeItem(array, action) {
    return [
        ...array.slice(0, action.index),
        ...array.slice(action.index + 1)
    ];
}
{% endhighlight %}

However, remember that the key is that the original in-memory reference is not modified. **As long as we make a copy first, we can safely mutate the copy**. Note that this is true for both arrays and objects, but nested values still must be updated using the same rules.

This means that we could also write the insert and remove functions like this:

{% highlight js linenos %}
function insertItem(array, action) {
    let newArray = array.slice();
    newArray.splice(action.index, 0, action.item);
    return newArray;
}

function removeItem(array, action) {
    let newArray = array.slice();
    newArray.splice(action.index, 1);
    return newArray;
}
{% endhighlight %}

The remove function could also be implemented as:

{% highlight js linenos %}
function removeItem(array, action) {
    return array.filter( (item, index) => index !== action.index);
}
{% endhighlight %}

##### 1.9.10.3 Updating an Item in an Array

Updating one item in an array can be accomplished by using `Array.map`, returning a new value for the item we want to update, and returning the existing values for all other items:

{% highlight js linenos %}
function updateObjectInArray(array, action) {
    return array.map( (item, index) => {
        if(index !== action.index) {
            // This isn't the item we care about - keep it as-is
            return item;
        }

        // Otherwise, this is the one we want - return an updated value
        return {
            ...item,
            ...action.item
        };    
    });
}
{% endhighlight %}

##### 1.9.10.4 Immutable Update Utility Libraries

Because writing immutable update code can become tedious, there are a number of utility libraries that try to abstract out the process. These libraries varyin APIs and usage, but all try to provide a shorter and more succinct way of writing these updates. Some, like [dot-prop-immutable](https://github.com/debitoor/dot-prop-immutable), take string paths for commands:

{% highlight js linenos %}
state = dotProp.set(state, `todos.${index}.complete`, true)
{% endhighlight %}

Others, like [immutability-helper](https://github.com/kolodny/immutability-helper)(a fork of the now-deprecated React Immutability Helpers addon), use nested values and helper functions:

{% highlight js linenos %}
var collection = [1, 2, {a: [12, 17, 15]}];
var newCollection = update(collection, {2: {a: {$splice: [[1, 1, 13, 14]]}}});
{% endhighlight %}

They can provide a useful alternative to writing manual immutable update logic.

A list of many immutable update utilities can be found in the [Immutable Data#Immutable Update Utilities](https://github.com/markerikson/redux-ecosystem-links/blob/master/immutable-data.md#immutable-update-utilities) section of the [Redux Addons Catalog](https://github.com/markerikson/redux-ecosystem-links).

#### 1.9.11 Initializing State

There are two main ways to initialize state for your application. The `createStore` method can accept an optional `preloadedState` value as its second argument. Reducers can also specify an initial value by looking for an incoming state argument that is `undefined`, and returning the value they'd like to use as a default. This can either be doen with an explicit check inside the reducer, or by using the ES6 default argument value syntax: `function myReducer(state = someDefaultValue, action)`.

It's not always immediately clear how these two approaches interact. Fortunately, the process does follow some predictable rulse. Here's how the pieces fit together.

##### 1.9.11.1 Summary

Without `combineReducers()` or similar manual code, `preloadedState` always wins over `state = ...` in the reducer because the `state` passed to the reducer is `preloadedState` and is not `undefined`, so the ES6 argument syntax doesn't apply.

With `combineReducers()` the behavior is more nuanced. Those reducers whose state is specified in `preloadedState` will receive that state. Other reducers will receive `undefined` and because of that will fall back to the `state = ...` default argument they specify.

**In general, `preloadedState` wins over the state specified by the reducer. This lets reducers specify initial data that makes sense to them as default arguments, but also allows loading existing data (fully or partially) when you're hydrating the store form some persistent storage or the server.**

Note: Reducers whose initial state is populated using `preloadedState` will **still need to provide a default value** to hanlde when apssed a `state` of `undefined`. All reducers are passed `undefined` on initialization, so they should be written such that when given `undefined`, some value should be returned. This can be any non-`undefined` value; there's no need to duplicate the section of `preloadedState` here as the default.

##### 1.9.11.2 In Depth

**Single Simple Reducer**

First let's consider a case where you have a single reducer. Say you don't use `combineReducers()`. Then your reducer might look like this:

{% highlight js linenos %}
function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT': return state + 1;
    case 'DECREMENT': return state - 1;
    default: return state;
  }
}
{% endhighlight %}

Now let's say you create a store with it.

{% highlight js linenos %}
import { createStore } from 'redux';
let store = createStore(counter);
console.log(store.getState()); // 0
{% endhighlight %}

The initial state is zero. Why? Because the second argument to `createStore` was `undefined`. This is the `state` passed to your reducer the first time. When Redux initializes it dispatches a "dummy" action to fill the state. So your `counter` reducer was called with `state` equal to `undefined`. **This is exactly the case that "activates" the default argument.** Therefore, `state` is now `0` as per the default `state` value (`state = 0`). This state (`0`) will be returned.

Let's consider a different scenario:

{% highlight js linenos %}
import { createStore } from 'redux';
let store = createStore(counter, 42);
console.log(store.getState()); // 42
{% endhighlight %}

Why is it `42`, and not `0`, this time? Becuase `createStore` was called with `42` as the second argument. This argument becomes the `state` passed to your reducer along with the dummy aciton. **This time, `state` is not undefined (it's `42`), so ES6 default arugment syntax has no effect.** The `state` is `42`, and `42` is returned fromt the reducer.

**Combined Reducers**

Now let's consider a case where you use `combineReducers()`.
You have two reducers:

{% highlight js linenos %}
function a(state = 'lol', action) {
  return state;
}

function b(state = 'wat', action) {
  return state;
}
{% endhighlight %}

The reducer generated by `combineReducers({ a,b })` looks like this:

{% highlight js linenos %}
// const combined = combineReducers({ a, b })
function combined(state = {}, action) {
  return {
    a: a(state.a, action),
    b: b(state.b, action)
  };
}
{% endhighlight %}

If we call `createStore` without the `preloadedState`, it's going to initialize the `state` to `{}`. Therefore, `state.a` and `state.b` will be `undefined` by the time it calls `a` and `b` reducers. **Both `a` and `b` reducers will receive `undefined` as their `state` arguments, and if they specify default `state` values, those will be returned.** This is how the combined reducer returns a `{ a: 'lol', b: 'wat'}` state object on the first invocation.

{% highlight js linenos %}
import { createStore } from 'redux';
let store = createStore(combined);
console.log(store.getState()); // { a: 'lol', b: 'wat' }
{% endhighlight %}

Let's consider a different scenario:

{% highlight js linenos %}
import { createStore } from 'redux';
let store = createStore(combined, { a: 'horse' });
console.log(store.getState()); // { a: 'horse', b: 'wat' }
{% endhighlight %}

Now I specified the `preloadedState` as the argument to `createStore()`. The state returned from the combined reducer combines the initial state I specified for the `a` reducer with the `wat` default argument specified that `b` reducer chose itself.

Le't recall what the combined reducer does:

{% highlight js linenos %}
// const combined = combineReducers({ a, b })
function combined(state = {}, action) {
  return {
    a: a(state.a, action),
    b: b(state.b, action)
  };
}
{% endhighlight %}

In this case, `state` was specified so it didn't fall back to `{}`. It was an object with `a` field equal to `horse`, but without the `b` field. This is why the `a` reducer received `horse` as its `state` and gladly returned it, but the `b` reducer received `undefined` as its `state` and thus returned its idea of the default `state` (in our example, `wat`). This is how we get `{ a: 'horse', b: 'wat'}` in return.


##### 1.9.11.3 Recap

To sum this up, if you stick to Redux conventions and return the initial state from reducers when they're called with `undefined` as the `state` argument (the easiest way to implement this is to specify the `state` ES6 defualt argument value), you're going to have a nice useful behavior for combined reducers. **They will prefer the corresponding value in the `preloadedState` object you pass to the `createStore()` function, but if you didn't pass any, or if the corresponding field is not set, the default `state` argument specified by the reducer is chosen instead.** This approach works well because it provides both initialization and hydration of existing data, but lets individual reducers reset their state if their data was not preserved. Of course you can apply this pattern recursively, as you can use `combineReducers()` on many levels, or even compose reducers manually by calling reducers and giving them the relevant part of the state tree.



### 1.10 Using `'Immutable.JS'` with Reudx

#### 1.10.1 Why should I use an immutable-focused library such as `Immutable.JS`?

Immutable-focused libraries such as Immutable.JS have been designed to overcome the issues with immutability inherent within JavaScript, providing all the benefits of immutability with the performance oyour app requires.

Whether you choose to use such a library, or stick with plain JavaScript, depends on how comforable you are with adding another dependency to your app, or how sure you are that you can avoid the pitfalls inherent within JavaScript's approach to immutability.

Whichever option you choose, maje sure you're familiar with the concepts of [immutability, side effects and mutation](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html#note-on-immutability-side-effects-and-mutation). In particular, ensure you have a deep understanding of what JavaScript does when updating and copying values in order to guard against accidental mutations that will degrade your app's performance, or break it altogether.

**Further Information**

+ [Recipes: immutability, side effects and mutation](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html#note-on-immutability-side-effects-and-mutation)

+ [Introduction to `Immutable.js` and Functional Programming Concepts](https://auth0.com/blog/intro-to-immutable-js/)

+ [Pros and Cons of using immutability with `React.js`](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)

#### 1.10.2 Why should I choose `Immutable.JS` as an immutable library?

`Immutable.JS` was designed to provide immutability in a performant manner in an effort to overcome the limitations of immutability with JavaScript. Its principle advantages include:

**Guaranteed immutability**

Data encapsulated in an `Immutable.JS` object is never mutated. A new copy is always returned. This contrasts with JavaScript, in which some operations do not mutate your data (e.g. some Array methods, including map, filter, concat, forEach, etc.), but some do (Array's pop, push, splice, etc.).

##### 1.10.2.1 Rich API

`Immutable.JS` provides a rich set of immutable objects to encapsulate your data (e.g. Maps, Lists, Sets, Records, etc.), and an extensive set of methods to manipulate it, including methods to sort, filter, and group the data, reverse it, flatten it, and create subsets.

##### 1.10.2.2 Performance

`Immutable.JS` does a lot of work behind the scenes to optimize performance. This is the key to its power, as using immutable data strcutures can involve a lot of expensive copying. In particular, immutably manipulating large, complex data sets, such as a nested Redux state tree, can generate many intermediate copies of objects, which consume memory and slow down performance as the browser's garbage collector fights to clean things up.

`Immutable.JS` avoids this by [cleverly sharing data structures](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.z1g1ofrsi) under the surface, minimizing the need to copy data. It also enables complex chains of operations to be carried out without creating unnecessary (and costly) cloned intermediate data that will quickly be thrown away.

You never see this, of course - the data you give to an Immutable.JS object is never mutated. Rather, it's the intermediate data generated within `Immutable.JS` from a chained sequence of method calls that is free to be mutated. You therefore get all the benefits of immutable data structures with none (or very little) of the potential performance hits.

**Further Information**

+ [`Immutable.js`, persistent data structures and structural sharing](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.6nwctunlc)

+ [PDF: JavaScript Immutability - Don't go changing](https://www.jfokus.se/jfokus16/preso/JavaScript-Immutability--Dont-Go-Changing.pdf)

+ [`Immutable.js`](https://facebook.github.io/immutable-js/)

#### 1.10.3 What are the issues with using `Immutable.JS`?

Although powerful, `Immutable.js` needs to be used carefully, as it comes with issues of its own. Note, however, that all of these issues can be overcome quite easily with careful coding.

##### 1.10.3.1 Difficult to interoperate with

JavaScript does not provide immutable data structures. As such, for `Immutable.JS` to provide its immutable guarantees, your data must be encapsulated within an `Immutable.JS` object (such as a `Map` or a `List`, etc.). Once it's contained in this way, it's hard for that data to then interoperate with other, plain JavaScript objects.

For example, you will no longer be able to reference an object's properties through standard JavaScript dot or bracked notation. Instead, you must reference them via `Immutable.js`'s `get` or `getIn()` methods, which use an awkward syntax that accesses properties via an array of strings, each of which represents a property key.

For example, instead of `myObj.prop1.prop2.prop3`, you would use `muImmutableMap.getIn(['prop1', 'prop2', 'prop3'])`.

This makes it awkward to interoperate not just with your own code, but also with other libraries, such as lodash or ramda, that expect plain JavaScript objects.

Not that `Immutable.JS` objects do have a `toJS()` method, which returns the data as a plain JavaScript data structure, but this method is extremely slow, and using it extensively will negate the performance benefits that `Immutable.JS` provides.

##### 1.10.3.2 Once used, `Immutable.JS` will spread throughout your codebase

Once you encapsulate your data with `Immutable.JS`, you have to use `Immutable.JS`'s  `get()` or `getIn()` property accessors to access it.

This has the effect of psreading `Immutable.JS` across your entire codebase, including potentially your components, where you may prefer not to have such external dependencies. You entire codebase must know what is, and what is not, an `Immutable.JS` object. It also makes removing `Immutable.JS` from your app difficult in the future, should you ever need to.

This issue can be avoided by [uncoupling your application logic from your data structures](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.z1g1ofrsi), as outlined in the [best practices section](http://redux.js.org/docs/recipes/UsingImmutableJS.html#immutable-js-best-practices) below.

##### 1.10.3.3 No Destructuring or Spread Operators

Because you must access your data via `Immutable.JS`'s own `get()` and `getIn()` methods, you can no longer use JavaScript's destructuring operator (or the proposed Object spread operator), making your code more verbose

##### 1.10.3.4 Not suitable for small values that change often

`Immutable.JS` works best for collections of data, and the larger the better. It can be slow when your data comprises lots of small, simple JavaScript objects, with each comprising a few keys of primitive values. Note, however, that this does not apply to the Redux state tree, which is (usually) represented as a large collection of data.

##### 1.10.3.5 Difficult to Debug

`Immutable.JS` objects, such as `Map`, `List`, etc., can be difficult to debug, as inspecting such an object will reveal an entire nested herarchy of Immutalbe.JS-specific properties that you don't care about, while your actual data that you do care about is encapsulated several layers deep.


To resolve this issue, use a browser extension such as the [Immutable.js Object Formatter](https://chrome.google.com/webstore/detail/immutablejs-object-format/hgldghadipiblonfkkicmgcbbijnpeog), which surfaces your data in ChromeDev Tools, and hides Immutable.JS's properties when inspecting your data.

##### 1.10.3.6 Breaks object references, causing poor performance

One of the key advantages of immutability is that it enables shallow equality checking, which dramatically improves performance.

If two different variables reference the same immutable object, then a simple equality check of the two variables is enough to determine that they are equal, and that the object they both reference is uncahge. The equality check never has to check the values of any of the object's properties, as it is, of course, immutable.

However, shallow checking will not work if your data encapsulated within an `Immutable.JS` object is itself an object. This is becuase `Immutable.JS`'s `toJS()` method, which returns the data contained within an `Immutable.JS` object as a JavaScript value, will create a new object every time it's called, and so break the reference wit the encapsulated data.

Accordingly, calling `toJS()` twice, for example, and assigning the result to two different variables will cause an equality check on those two variables fo fail, even though the object values themselves haven't change. 

This is a particular issue if you use `toJS()` in a wrapped component's `mapStateToProps` function, as React-Redux shallowly compares each vlaue in the returned props object. For example, the value referenced by the `todos` prop returned form `mapStateToProps` below will always be a different object, and so will fail a shallow equality check.

{% highlight js linenos %}
// AVOID .toJS() in mapStateToProps
function mapStateToProps(state) {
  return {
    todos: state.get('todos').toJS() // Always a new object
  }
}
{% endhighlight %}

When the shallow check fails, React-Redux will cause the component to re-render. Using `toJS()` in `mapStateToProps` in this way, therefore, will always cause the component to re-render, even if the value never changes, impacting heavily on performance.

This can be prevented by using `toJS()` in a Higher Order Component, as discussed in the [Best Practices section](http://redux.js.org/docs/recipes/UsingImmutableJS.html#immutable-js-best-practices) below.

**Further Information**

+ [Immutable.js, persistent data structures and structural sharing](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.hzgz7ghbe)

+ [Immutable Data Structures and JavaScript](http://jlongster.com/Using-Immutable-Data-Structures-in-JavaScript)

+ [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f#.9ucv6hwk4)

+ [Building Efficient UI with React and Redux](https://www.toptal.com/react/react-redux-and-immutablejs)

+ [Immutable Object Formatter: Chrome Extension](https://chrome.google.com/webstore/detail/immutablejs-object-format/hgldghadipiblonfkkicmgcbbijnpeog)

#### 1.10.4 Is `Immutable.JS` worth the effort?

Frequently, yes. There are various tradeoffs and opinions to consider, but there are many good reasons to use `Immutable.JS`. Do not underestimate the difficulty of trying to track down a property of your state tree that has been inadvertently mutated.

Components will both re-render when they shouldn't, and refuse to render when they should, and tracking down the bug causing the rendering issue is hard, as the component rendering incorrectly is not necessarily the one whose properties are being accidentally mutated.

This problem is caused predominantly by returning a mutated state object from a Redux reducer. With `Immutable.JS`, this problem simple does not exist, there by removing a whole class of bugs from your app.

This, together with its performance and rich API for data manipulation, is why `Immutable.JS` is worth the effort.

**Further Information**

+ [Troubleshooting: Nothing happens when I dispatch an action](http://redux.js.org/docs/Troubleshooting.html#nothing-happens-when-i-dispatch-an-action)


#### 1.10.5 What are some opinionated Best Practices for using `Immutable.JS` with Redux?

`Immutable.JS` can provide significant reliability and performance improvements to your app, but it must be used correctly. If you choose to use `Immutable.JS` (and remember, you are not required to , and there are other immutable libraries you can use), follow these opinionated best practices, and you'll be able to get the most out of it, without tripping up on any of the issues it can potentially cause. 

##### 1.10.5.1 Never mix plain JavaScrip objects with `Immutable.JS`

Never let a plain JavaScript object contain `Immutable.JS` properties. Equally, never let an `Immutable.JS` object contain a plain JavaScript object.

+ [Immutable Data Structures and JavaScript](http://jlongster.com/Using-Immutable-Data-Structures-in-JavaScript)

##### 1.10.5.2 Make your entire Redux state tree an `Immutable.JS object`

For a Redux app, your entire state tree should be an `Immutable.JS` object, with no plain JavaScript objects used at all.

+ Create the tree using `Immutable.JS`'s `fromJS()` function.

+ Use an `Immutable.JS`-aware version of the `combineReducers` function, such as the one in [redux-immutable](https://www.npmjs.com/package/redux-immutable), as Redux itself expects the state tree to be a plain JavaScript object.

+ When adding JavaScript objects to an `Immutable.JS` Map or List using `Immutable.JS`'s `update`, `merge` or `set` methods, ensure that the object being added is first converted to an Immutable object using `fromJS()`.

{% highlight js linenos %}
// avoid
const newObj = { key: value }
const newState = state.setIn(['prop1'], newObj)
// newObj has been added as a plain JavaScript object, NOT as an Immutable.JS Map

// recommended
const newObj = { key: value }
const newState = state.setIn(['prop1'], fromJS(newObj))
// newObj is now an Immutable.JS Map
{% endhighlight %}

Further Information:

+ [Immutable Data Structures and JavaScript](http://jlongster.com/Using-Immutable-Data-Structures-in-JavaScript)

+ [redux-immutable](https://www.npmjs.com/package/redux-immutable)

##### 1.10.5.3 Use `Immutable.JS` everywhere except your dumb components

Using `Immutable.JS` everywhere keeps your code performant. Use it in your smart components, your selectors, your sagas or thunks, action creators, and expecially your reducers. Do not, however, use `Immutable.JS` in your dumb components.

Further Information

+ [Immutable Data Structures and JavaScript](http://jlongster.com/Using-Immutable-Data-Structures-in-JavaScript)

+ [Smart and Dumb Components in React](http://jaketrent.com/post/smart-dumb-components-react/)

##### 1.10.5.4 Limit your use of `toJS()`

`toJS()` is an expensive function and negates the purpose of using `Immutable.JS`. Avoid its use

Further Information

+ [Lee Byron on Twitter: “Perf tip for #immutablejs…”](https://twitter.com/leeb/status/746733697093668864)

##### 1.10.5.5 Your selectors should return `Immutable.JS` objects

Always.

##### 1.10.5.6 Use `Immutable.JS` objects in your Smart Components

Smart components that access the store via React Redux's `connect` function must use the `Immutable.JS` values returned by your selectors. Make sure you avoid the potential issues this can cause with unnecessary component re-rendering. Memoize your selectors using a library such as reselect if necessary.

Further Information

+ [Recipes: Computing Derived Data](http://redux.js.org/docs/recipes/ComputingDerivedData.html)

+ [FAQ: Immutable Data](http://redux.js.org/docs/faq/ImmutableData.html#immutability-issues-with-react-redux)

+ [Reselect Documentation: How do I use Reselect with Immutable.js?](https://github.com/reactjs/reselect/#q-how-do-i-use-reselect-with-immutablejs)

+ [Redux Patterns and Anti-Patterns](https://tech.affirm.com/redux-patterns-and-anti-patterns-7d80ef3d53bc#.451p9ycfy)

+ [Reselect: Selector library for Redux](https://github.com/reactjs/reselect)

##### 1.10.5.7 Never use `toJS()` in `mapStateToProps`

Converting an Immutable.JS object to a JavaScript object using `toJS()` will return a new object every time. If you do this in `mapStateToProps`, you will cause the component to believe that the object has changed every time the stte tree changes, and so trigger an unnecessary re-render.

Further Information

+ [FAQ: Immutable Data](http://redux.js.org/docs/faq/ImmutableData.html#how-can-immutability-in-mapstatetoprops-cause-components-to-render-unnecessarily)

##### 1.10.5.8 Never use Immutable.JS in your Dumb Components

Your dumb components should be pure; that is, they should produce the same output give the same input, and have no external dependencies. If you pass such a component an `Immutable.JS` object as a prop, you make it dependent upon `Immutable.JS` to extract the prop's value and otherwise manipulate it.

Such a dependency renders the component impure, makes testing the component more difficult, and makes resusing and refactoring the component unnecessarily difficult.

Further Information

+ [Immutable Data Structures and JavaScript](http://jlongster.com/Using-Immutable-Data-Structures-in-JavaScript)

+ [Smart and Dumb Components in React](http://jaketrent.com/post/smart-dumb-components-react/)

+ [Tips For a Better Redux Architecture: Lessons for Enterprise Scale](https://hashnode.com/post/tips-for-a-better-redux-architecture-lessons-for-enterprise-scale-civrlqhuy0keqc6539boivk2f)

##### 1.10.5.9 User a Higher Order Component to convert your Smart Component's `Immutable.JS` props to your Dumb Component's JavaScript props

Something needs to map the `Immutable.JS` props in your Smart Component to the pure `JavaScript` props used in your Dumb Component. That something is a Higher Order Component (HOC) that simply takes the `Immutable.JS` props from your Smart Component, and converts them using `toJS()` to plain JavaScript props, which are then passed to your Dumb Component.

Here is an example of such a HOC:

{% highlight js linenos %}
import React from 'react'
import { Iterable } from 'immutable'

export const toJS = WrappedComponent => wrappedComponentProps => {
  const KEY = 0
  const VALUE = 1

  const propsJS = Object.entries(
    wrappedComponentProps
  ).reduce((newProps, wrappedComponentProp) => {
    newProps[wrappedComponentProp[KEY]] = Iterable.isIterable(
      wrappedComponentProp[VALUE]
    )
      ? wrappedComponentProp[VALUE].toJS()
      : wrappedComponentProp[VALUE]
    return newProps
  }, {})

  return <WrappedComponent {...propsJS} />
}
{% endhighlight %}

And this is how you would use it in your Smart Component:

{% highlight js linenos %}
import { connect } from 'react-redux'

import { toJS } from './to-js'
import DumbComponent from './dumb.component'

const mapStateToProps = state => {
  return {
    // obj is an Immutable object in Smart Component, but it’s converted to a plain
    // JavaScript object by toJS, and so passed to DumbComponent as a pure JavaScript
    // object. Because it’s still an Immutable.JS object here in mapStateToProps, though,
    // there is no issue with errant re-renderings.
    obj: getImmutableObjectFromStateTree(state)
  }
}
export default connect(mapStateToProps)(toJS(DumbComponent))
{% endhighlight %}

By converting `Immutable.JS` objects to plain JavaScript values within a HOC, we achieve Dumb Component portability, but without the performance hits of using `toJS()` in the Smart Component.

Note: if your app requires high performance, you may need to avoid `toJS()` altogether, and so will have to use `Immutable.JS` in your dumb components. However, for most apps this will not be the case, and the benefits of keeping `Immutable.JS` out of your dumb components (maintainability, portability and easier testing) will far outweigh any perceived performance improvements of keeping it in. In addition, using `toJS` in a Higher Order Component should not cause much, if any, perfromance degradation, as the component will only be called when the connected component's props change. As with any performance issue, conduct performance checks first before deciding what to optimise.

Further Information

+ [React: Higher-Order Components](https://facebook.github.io/react/docs/higher-order-components.html)

+ [React Higher Order Components in depth](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e#.dw2qd1o1g)

+ [Reddit: acemarke and cpsubrian comments on Dan Abramov: Redux is not an architecture or design pattern, it is just a library](https://www.reddit.com/r/javascript/comments/4rcqpx/dan_abramov_redux_is_not_an_architecture_or/d5rw0p9/?context=3)

+ [cpsubrian: React decorators for redux/react-router/immutable ‘smart’ components](https://gist.github.com/cpsubrian/79e97b6116ab68bd189eb4917203242c#file-tojs-js)

##### 1.10.5.10 Use the Immutable Object Formatter Chrome Extension to Aid Debugging

install the [Immutable Object Formatter](https://chrome.google.com/webstore/detail/immutablejs-object-format/hgldghadipiblonfkkicmgcbbijnpeog), and inspect your `Immutable.JS` data without seeing the noise of `Immutable.JS`'s own object properties

Further Information

+ [Immutable Object Formatter](https://chrome.google.com/webstore/detail/immutablejs-object-format/hgldghadipiblonfkkicmgcbbijnpeog)


## 2 参考资料 ##
- [Redux](https://github.com/reactjs/redux);

- [Get Started with Redux](https://egghead.io/courses/getting-started-with-redux);

- [Note: Get Started with Redux](https://github.com/tayiorbeii/egghead.io_redux_course_notes);

- [React Code](https://github.com/shunmian/4.1.1_redux-part-one)