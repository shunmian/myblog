---
layout: post
title: Redux Part III：FAQ
categories: [04 Web Development]
tags: [Redux]
number: [4.1.2]
fullview: false
shortinfo: 本文是对Rudex常见问题的汇总。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}
 
## 1 FAQ ##


### 1.1 General 

#### 1.1.1 When should I use Redux?

What to learn can be an overwhelming question for a JavaScript developer. It helps to narrow the range of options by learning one thing at a time and focusing on problems you find in your work. Redux is a pattern for managing application state. If you do not have problems with state management, you might find the benefits of Redux harder to understand. Some UI libraries (like React) have their own state management system. If you are using one of these libraries, expecially if you are just learning to use them, we encourage you to learn the capabilities of that built-in system first. It might be all you need to build your applicaton. If your application becomes so complex that you are confused about where state is stored or how state changes, then it is a good time to leran Redux. Experiencing the complexity that Redux seeks to abstract is the best preparation for effective ly applying that abstraction to your work.

Further Information

+ [Deciding What Not to Learn](http://gedd.ski/post/what-not-to-learn/)

+ [How to learn web frameworks](https://ux.shopify.com/how-to-learn-web-frameworks-9d447cb71e68)

+ [Redux vs MobX vs Flux vs ... Do you even need that?](https://goshakkk.name/redux-vs-mobx-vs-flux-etoomanychoices/)

+ [Ask HN: Overwhelmed with learning frong-end, how do I proceed?](https://news.ycombinator.com/item?id=12882816)

+ [Twitter: If you want to teach someone to use an abstraction...](https://twitter.com/acemarke/status/901329101088215044)

+ [Twitter: It was never intended to be learned before ...](https://twitter.com/dan_abramov/status/739961787295117312)

+ [Twitter: Learning Redux before React?](https://twitter.com/dan_abramov/status/739962098030137344)

+ [Twitter: The first time I used React, people told me I needed Redux...](https://twitter.com/raquelxmoss/status/901576285020856320)

+ [Twitter: This ws my experience with Redux...](https://twitter.com/garetmckinley/status/901500556568645634)


#### 1.1.2 When should I use Redux?

The need to use Redux should not be taken for granted. As Pete Hunt, one of the early contributors to React, says: You'll know when you need Flux. If you aren't sure if you need it, you don't need it.

Similarly, DanAbramov, one of the creators of Redux, says: I would like to amend this: don't use Redux until you have problems with vanilla React.

In general, use Redux when you have reasonable amounts of data changing over time, you need a single source of truth, and you find that approaches like keeping everything in a top-level React component's state are no longer sufficient.

However, it's also important to understand that using Redux comes with tradeoffs. It's not designed to be the shortest or fastest way to write code. It's intended to help answer the question "When did a certain slice of state change, and where did the data come from?", with predictable behavior It does so by asking you to follow specific constraints in your application: store your application's state as plain data, describe changes as plain objects, and handle those changes with pure functions that apply updates immutably. This is often the source of complaines about "boilerplate". These constraints require effort on the part of a developer, but also open up a number of additional possibilities (such as store persistence and synchronization).

In the end, Redux is just a tool. It's a great tool, and there's some great reasons to use it, but there's also reasons you might not want to use it. Make inforamed decisions about your tools, and understand the tradeoffs involved in each decision.

**Further Information**

+ [Introduction: Motivation](http://redux.js.org/docs/introduction/Motivation.html)

+ [React How-To](https://github.com/petehunt/react-howto)

+ [You Might Not Need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)

+ [The Case for Flux](https://medium.com/swlh/the-case-for-flux-379b7d1982c6)

+ [Some Reasons Why Redux is Useful in a React App](https://www.fullstackreact.com/articles/redux-with-mark-erikson/)

+ [Twitter: Don't use Redux until...](https://twitter.com/dan_abramov/status/699241546248536064)

+ [Twitter: Redux is designed to be predictable, not concise](https://twitter.com/dan_abramov/status/733742952657342464)

+ [Twitter: Redux is useful to eliminate deep prop passing](https://twitter.com/dan_abramov/status/732912085840089088)

+ [Twitter: Don't use Redux unless you're unhappy with local component state](https://twitter.com/dan_abramov/status/725089243836588032)

+ [Twitter: You don't need Redux if your data never changes](https://twitter.com/dan_abramov/status/737036433215610880)

+ [Twitter: If your reducer looks boring, don't use redux](https://twitter.com/dan_abramov/status/802564042648944642)

+ [Reddit: You don't need Redux if your app just fetches something on a single page](https://www.reddit.com/r/reactjs/comments/5exfea/feedback_on_my_first_redux_app/dagglqp/)

+ [Stack Overflow: Why use Redux over Facebook Flux?](http://stackoverflow.com/questions/32461229/why-use-redux-over-facebook-flux)

+ [Stack Overflow: Why should I use Redux in this example?](http://stackoverflow.com/questions/35675339/why-should-i-use-redux-in-this-example)

+ [Stack Overflow: What could be the downsides of using Redux instead of Flux](http://stackoverflow.com/questions/32021763/what-could-be-the-downsides-of-using-redux-instead-of-flux)

+ [Stack Overflow: When should I add Redux to a React app?](http://stackoverflow.com/questions/36631761/when-should-i-add-redux-to-a-react-app)

+ [Stack Overflow: Redux vs plain React?](http://stackoverflow.com/questions/39260769/redux-vs-plain-react/39261546#39261546)

+ [Twitter: Redux is a platform for developers to build customized state management with reusable things](https://twitter.com/acemarke/status/793862722253447168)


#### 1.1.3 Can Redux only be used with React?

Redux can be used as a data store for any UI layer. The most common usage is with React and React Native, but there are bindings available for Angular, Angular 2, Vue, Mithril, and more. Redux simply provides a subscription mechanism which can be used by any other code. That said, it is more useful when combiend with a declarative view implementation that can infer the UI updates from the state changes, such as React or one of the similar libraries available.

#### 1.1.4 Do I need to have a particular build tool to use Redux?

Redux is originally written in ES6 and transpiled for production into ES5 with Webpack and Babel. You should be able to use it regardless ofyour JavaScript build process. Redux also offers a UMD build that can be used directly without any build process at all. The [counter-vanilla](https://github.com/reactjs/redux/tree/master/examples/counter-vanilla) example demonstrates basic ES5 usage with Redux included as a `<script>` tag. As the relevant pull request says: The new Counter Vanila example is aimed to dispel the myth that Redux requires Webpack, React, hot reloading, sagas, action creators, constants, Babel, npm, CSS moduels, decorators, fluent Lation, an Egghead subscription, a PHD, or an Exceeds Expectations O.W.L. level.

Nope, it's just HTML, some artisanal `<script>` tags, and plain old DOM manipulation. Enjoy!

### 1.2 Reducers

#### 1.2.1 How do I share state between two reducers? Do I have to use combineReducers?

The suggested structure for a Redux store is to split the state object into multiple "slices" or "domains" by key, and provide a separate reducer funciton to manage each individual data slic. This is similar to how the standard Flux pattern has multiple independent stores, and Redux provides the `combineReducers` utility function to make this pattern easier. However, it's important to note that `combineReducers` is not required - it is simply a utility funciton for the common use case of having a single reducer function per state slice, with plain JavaScropt objects for the data.

Many users later want to try to share data between two reducers, but find that `combineReducers` does not allow them to do so. There are several approaches that can be used:

+ If a reducer needs to know data from another slice of state, the state tree shape may need to be reorganized so that a single reducer is handling more of the data.

+ You may need to write some custom functions for handling some of these actions. This may require replacing `combineReducers` with your own top-level reducer function. You can also use a utility such as [reducer-reducers](https://github.com/acdlite/reduce-reducers) to run `combineReducers` to handle morest actions, but also run a more specialized reducer for specific actions that cross state slices.

+ [Async action creators](http://redux.js.org/docs/faq/advanced/AsyncActions.md) such as [redux-thunk](https://github.com/gaearon/redux-thunk) have access to the entire state through `getState()`. An action creator can retrieve additional data from the state and put it in an action, so that each reducer has enough information to update its own state slice.

In general, remember that reducers are just functions - you can organize them and subdivide them any way you want, and you are encouraged to break them down into smaller, reusable functions ("reducer composition"). While you do so, you may pass a custom third argument from a parent reducer if a child reducer needs additional data to calculate its next state. You just need to make sure that together they follow the basic rules of reducers: `(state,action) => newState`, and update state immutably rather than mutating it directly.

Further Information

+ [API: combineReducers](http://redux.js.org/docs/api/combineReducers.html)

+ [Recipes: Structuring Reducers](http://redux.js.org/docs/recipes/StructuringReducers.html)

+ [#601: A concern on combineReducers, when an aciton is related to multiple reducers](https://github.com/reactjs/redux/issues/601)

+ [#1400: Is passing top-level state object to branch reducer an anti-pattern](https://github.com/reactjs/redux/issues/1400)

+ [Stack Overflow: Accessing other parts of the state when using combined reducers?](http://stackoverflow.com/questions/34333979/accessing-other-parts-of-the-state-when-using-combined-reducers)

+ [stack Overflow: Reducing an entire subtree with redux combineReducers](http://stackoverflow.com/questions/34427851/reducing-an-entire-subtree-with-redux-combinereducers)

+ [Sharing State Between Redux Reducers](https://invalidpatent.wordpress.com/2016/02/18/sharing-state-between-redux-reducers/)


#### 1.2.2 Do I have to use the `switch` statement to handle actions?

No,you are welcome to use any approach you'd like to respond to an action in a reducer. The `switch` statement is the most common approach, but it's fine to use `if` statements, a lookup table of funcitons, or to create a function that abstracts this awat. In fact, while Redux does require that aciton objects contain a `type` field, your reducer logic doesn't even have to rely on that to handle the action. That said, the standard approach is definitely using a switch statement or a lookup table based on `type`.

Further Information

+ [Recipes: Reducing Boilerplate](http://redux.js.org/docs/recipes/ReducingBoilerplate.html)

+ [Recipes: Structuring Reducers - Splitting Reducer Logic](http://redux.js.org/docs/recipes/reducers/SplittingReducerLogic.html)

+ [#883: take away the huge switch block](https://github.com/reactjs/redux/issues/883)

+ [#1167: Reducer without switch](https://github.com/reactjs/redux/issues/1167)

### 1.3 Organizing State

#### 1.3.1 Do I have to put all my state into Redux? Should I ever use React's setState()?

There is no "right" answer for this. Some users prefer to keep every single piece of data in Redux, to maintain a fully serializable and controlled version of their application at all times. Others prefer to keep non-critical or UI state, such as "is this dropdown currently open", inside a component's internal state.

**Using local component state is fine**. As a developer, it is your job to determine what kinds of state make up your application, and where each piece of state should live. Find a balance that works for you, and go with it.

Some common rules of thumb for determining what kind of data should be put into Redux:

+ Do other parts of the application care about this data?

+ Do you need to be able to create further derived data based on this oiginal data?

+ Is the same data being used to drive multiple components?

+ Is there value to you in being able to restore this state to a given point in time (ie, time travel debugging)?

+ Do you want to cache the data (ie, use what's in state if it's already there instead of re-requesting it)?

There are a number of community packages that implement various approaches for storing per-component state in a Redux store instead, such as [redux-ui](https://github.com/tonyhb/redux-ui), [redux-component](https://github.com/tomchentw/redux-component), [redux-react-local](https://github.com/threepointone/redux-react-local) and more. It's also possible to apply Redux's principles and concept of reducers to the task of updating local component state as well, along the lines `this.setState( (previousState) => reducer(previousState,someAction))`.

Further Information

+ [You Might Not Need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)

+ [Finding `state`'s place with React and Redux'](https://medium.com/@adamrackis/finding-state-s-place-with-react-and-redux-e9a586630172)

+ [A Case for setState](https://medium.com/@zackargyle/a-case-for-setstate-1f1c47cd3f73)

+ [How to handle State in React: the missing FAQ](https://medium.com/react-ecosystem/how-to-handle-state-in-react-6f2d3cd73a0c)

+ [Where to Hold React Component Data: state, store, static, and this](https://medium.freecodecamp.com/where-do-i-belong-a-guide-to-saving-react-component-data-in-state-store-static-and-this-c49b335e2a00)

+ [The 5 Types of React Application State](http://jamesknelson.com/5-types-react-application-state/)

+ [#159: Investigate using Redux for pseudo-local component state](https://github.com/reactjs/redux/issues/159)

+ [#1098: Using Redux in reusable React component](https://github.com/reactjs/redux/issues/1098)

+ [#1287: How to choose between Redux's store and React's state?](https://github.com/reactjs/redux/issues/1287)

+ [#1385: What are the disadvantages of storing all your state in a single immutable atom?](https://github.com/reactjs/redux/issues/1385)

+ [Twitter: Should I keep something in React component state?](https://twitter.com/dan_abramov/status/749710501916139520)

+ [Twitter: Using a reducer to update a component](https://twitter.com/dan_abramov/status/736310245945933824)

+ [React Forums: Redux and global state vs local state](https://discuss.reactjs.org/t/redux-and-global-state-vs-local-state/4187)

+ [Reddit: "When should I put something into my Redux store?"](https://www.reddit.com/r/reactjs/comments/4w04to/when_using_redux_should_all_asynchronous_actions/d63u4o8)

+ [Stack Overflow: Why is state all in one place, even state that isn't global?](http://stackoverflow.com/questions/35664594/redux-why-is-state-all-in-one-place-even-state-that-isnt-global)

+ [Stack OverflowL Should all component state be kept in Redux store?](http://stackoverflow.com/questions/35328056/react-redux-should-all-component-states-be-kept-in-redux-store)

+ [Redux Addons Catalog: Component State](https://github.com/markerikson/redux-ecosystem-links/blob/master/component-state.md)


#### 1.3.2 Can I put functions, promises, or other non-serializable items in my store state?

It is highly recommended that you only put plain serializable objects, arrays, and primitives into your store. It's technically possible to insert non-serializable items into the store, but doing so can break the ability to persist and rehydrate the contents of a store, as well as interface with time-travel debugging. If you are okay with things like persistence and time-travel debugging potentially not working as intended, then you are totally welcome to put non-serializable items into your Redux store. Ultimately, it's your application and how you implement it is up to you. As with many other things about Redux, just be sure you understand what tradeoffs are involved.

Further Information

+ [#1248: Is it ok and possible to store a react component in a reducer?](https://github.com/reactjs/redux/issues/1248)

+ [#1279: Have any suggestions for where to put a Map Component in Flux?](https://github.com/reactjs/redux/issues/1279)

+ [#1390: Component Loading](https://github.com/reactjs/redux/issues/1390)

+ [#1407: Just sharing a great base class](https://github.com/reactjs/redux/issues/1407)

+ [#1793: React Elements in Redux State](https://github.com/reactjs/redux/issues/1793)

#### 1.3.3 How do I organize nested or duplicate data in my state?

Data with IDs, nesting, or relationships should generally be stored in a "normalized" fashion: each object should be stored once, keyed by ID, and other objects that reference it should only store the ID rather than a copy of the entire object. It may help to think of parts of your store as a database, with individual "tables" per item type. Libraries such as [normalizer](https://github.com/paularmstrong/normalizr) and [redux-orm](https://github.com/tommikaikkonen/redux-orm) can provide help and abstractions in managing normalized data.

Further Information

+ [Advanced: Async Actions](http://redux.js.org/docs/advanced/AsyncActions.html)

+ [Examples: Real World example](http://redux.js.org/docs/introduction/Examples.html#real-world)

+ [Recipes: Structuring Reducers - Prerequisite Concepts](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html#normalizing-data)

+ [Recipes: Structuring Reducers - Normalizing State Shape](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html)

+ [Examples: Tree View](https://github.com/reactjs/redux/tree/master/examples/tree-view)

+ [High-Performance Redux](http://somebody32.github.io/high-performance-redux/)

+ [Querying a Redux Store](https://medium.com/@adamrackis/querying-a-redux-store-37db8c7f3b0f)

+ [#316: How to create nested reducers?](https://github.com/reactjs/redux/issues/316)

+ [#815: Working with Data Structures](https://github.com/reactjs/redux/issues/815)

+ [#946: Best way to update related state fields with split reducers?](https://github.com/reactjs/redux/issues/946)

+ [#994: How to cut the boilerplate when updating nested entities?](https://github.com/reactjs/redux/issues/994)

+ [#1255: Normalizr usage with nested objects in React/Redux](https://github.com/reactjs/redux/issues/1255)

+ [#1269: Add tree view example](https://github.com/reactjs/redux/pull/1269)

+ [#1824: Normalising state and garbage collection](https://github.com/reactjs/redux/issues/1824#issuecomment-228585904)

+ [Twitter: state shape should be normalized](https://twitter.com/dan_abramov/status/715507260244496384)

+ [Stack Overflow: How to handle tree-shaped entities in Redux reducers?](http://stackoverflow.com/questions/32798193/how-to-handle-tree-shaped-entities-in-redux-reducers)

+ [Stack Overflow: How to optimize small updates to props of nested components in React + Redux?](http://stackoverflow.com/questions/37264415/how-to-optimize-small-updates-to-props-of-nested-component-in-react-redux)


### 1.4 Store Setup

#### 1.4.1 Can or should I create multiple stores? Can I import my store directly, and use it in components myself?

The original Flux pattern describes having multiple "stores" in an app, each one nolding a dfferent area of domain data. This can introduce issues such as needing to have one store `waitFor` another store to update. This is not necessary in Redux because the spearation between data domains is already achieved by splitting a single reducer into smaller reducers.

As with several other questions, it is possible to create multiple distinct Redux stores in a page, but the intended pattern is to have only a single store. Having a single store enables using the Redux Devtools, makes persisting and rehydrating data simpler, and simplifies the subscription logic. 

Some valid reasons for using multiple stores in Redux might include:

+ Solving a performance issue casues by too frequent updates of some part of the state, when confirmed by profiling the app.

+ Isolating a Redux app as a component in a bigger application, in which case you might want to create a store per root component instance.

However, creating new stores shouldn't be your first instinct, expecailly if you come froma Flux background. Try reducer composition first, and only ouse multiple stores if it doesn't solve your problem.

Similarly, whil eyou can reference your store instance by importing it directly, this is not a recommended pattern in Redux. If you create a store instance and export it from a module, it will become a singleton. This means it will be harder to isolate a Redux app as a component of a larger app, ti this is ever necessary, or to enabl eserver rendering, because ont he server you want to create separate store instances for every request.

With [React Redux](https://github.com/reactjs/react-redux), the wrapper classes generated by the `connect()` function do actually look for `props.store` if it exists, but it's best if you wrap your root component in `<Provider store={store}>` and let React Redux worry about passing the store down. This way components don't need to worry about importing a store module, and isolating a Redux app or enabling server rendering is much easier to do later.

Furhter Information

+ [#1346: Is it bad practice to just have a 'stores' directory?](https://github.com/reactjs/redux/issues/1436)

+ [Stack Overflow: Redux multiple stores, why not?](http://stackoverflow.com/questions/33619775/redux-multiple-stores-why-not)

+ [Stack Oveflow: Accessing Redux state in an aciton creator](http://stackoverflow.com/questions/35667249/accessing-redux-state-in-an-action-creator)

+ [Gist: Breaking out of Redux paradigm to isolate apps](https://gist.github.com/gaearon/eeee2f619620ab7b55673a4ee2bf8400)



#### 1.4.2 Is it OK to have more than one middle ware chain in my store enhancer? What is the difference between next and dispatch in a middleware function?

Redux middleware act like a linked list. Each middleware function can either call `next(action)` to pass an aciton along to the next middleware in line, call `dispatch(action)` to restart the processing at the begining of the list, or do nothing at all to stop the action from being processed further.

This chain of middleware is defined by the arguments passed to the `applyMiddleware` funciton used when creating a store: Defining multiple chains will not work correctly, as they woul dhave distinctly different `dispatch` references and the different chains would effectively be disconnected.

Further Information

+ [Advanced: Middleware](http://redux.js.org/docs/advanced/Middleware.html)

+ [API: applyMiddleware](http://redux.js.org/docs/api/applyMiddleware.html)

+ [#1051: Shortcomings of the current applyMiddleware and composing createStore](https://github.com/reactjs/redux/issues/1051)

+ [Understanding Redux Middleware](https://medium.com/@meagle/understanding-87566abcfb7a)

+ [Exploring Redux Middlware](http://blog.krawaller.se/posts/exploring-redux-middleware/)

#### 1.4.3 How do I subscribe to only a portion of the state? Can I get the dispatched action as part of the subscription?

Redux provides a single `store.subscribe` method for notifying listeners that the store has updated. Listener callbacks do not receive the current state as an argument - it is simply an indication that something has changed. The subscriber logic can then call `getState()` to get the current state value. This API is intended as a low-level primitive with no dependencies or complications, and can be used to build higher-level subscription logic. UI bindings such as React Redux can create a subscription for each connected component. It is also possible to write functions that can intelligently compare the old state vs the new state, and execute additional logic if certain pieces have changed. Example include [redux-watch](https://github.com/jprichardson/redux-watch), [redux-subscribe](https://github.com/ashaffer/redux-subscribe) and [redux-subscriber](https://github.com/ivantsov/redux-subscriber) which offer different approaches to specifying subscriptions and handling changes. The new state is not passed to the listeners in order to simplify implementing store enhancers such as the Redux RevTools. In addition, subscribers are intended to react to the state value itself, not the action. Middleware can be used if the action is important and needs to be handled specifically.

Further Information

+ [Basics: Store](http://redux.js.org/docs/basics/Store.html)

+ [API: Store](http://redux.js.org/docs/api/Store.html)

+ [#303: subscribe API with state as an argument](https://github.com/reactjs/redux/issues/303)

+ [#580](https://github.com/reactjs/redux/issues/580)

+ [#922](https://github.com/reactjs/redux/issues/922)

+ [#1057](https://github.com/reactjs/redux/issues/1057)

+ [#1300: Redux is great but major feature is missing](https://github.com/reactjs/redux/issues/1300)

+ [Redux Addons Catalog: Store Change Subscriptions](https://github.com/markerikson/redux-ecosystem-links/blob/master/store.md#store-change-subscriptions)

### 1.5 Actions 

#### 1.5.1 Why should type be a string, or at least serializable? Why should my action types be constants

As with state, seriallizable actions enable several of Redux's defining features, such as time travel debugging, and recording and replaying actions. Using something like a `Symbol` for the `type` value or using `instanceof` checks for actions themselves would break that. Strings are serializable and easily self-descriptive, and so are a better choice. Note that it is okay to use Symbols, Promises, or other non-serializable values in an action if the action is intended for use by middleware. Actions only need to be serializable by the time they actually reach the store and are passed to the reducers.

We can't reliably enforce serializable actions for performance reasons, so Redux only checks that every aciton is a plain object, and that the `type` is defined. The rest is up to you, but you might find that keeping everything serializable helps dbug and reproduce issues. Encapsulating and centralizing commmonly used pieces of code is a key concept in programming. While it defining reusable constants makes maintaining code easier. If you put constants in a separate file, you can [check your `import` statements against typos](https://www.npmjs.com/package/eslint-plugin-import) so you can't accidentally use the wrong string.

Further Inforamation

+ [Reducing Boilerplate](http://redux.js.org/docs/recipes/ReducingBoilerplate.html#actions)

+ [#384: Recommend that Action constants be named in the past tense](https://github.com/reactjs/redux/issues/384)

+ [#628: Solution for simple action creation with less boilerplate](https://github.com/reactjs/redux/issues/628)

+ [#1024: Proposal: Declarative reducers](https://github.com/reactjs/redux/issues/1024)

+ [#1167: Reducer without switch](https://github.com/reactjs/redux/issues/1167)

+ [Stack Overflow: Why doyou need 'Actions' as data in Redux](http://stackoverflow.com/q/34759047/62937)

+ [Stack Overflow: What is the point of the constants in Redux?](http://stackoverflow.com/q/34965856/62937)

#### 1.5.2 Is there always a one-to-one mapping between reducers and actions?

No. We suggest you write independent small reducer fuctions that are each responsible for updates a specific slice of state. We call this pattern "reducer composition". A given action could be handled by all, some, or none of them. This keeps components decoupled from the actual data changes, as one action may affect different parts of the state tree, and there is no need for the component to be aware of this. Some users do choose to bind them more tightly together, such as the "ducks" file structure, but there is definitely no one-to-one mapping by default, and you should break out of such a paradigm any tiem you feel you want to handle an action in many reducers.

Further Information

+ [Basics: Reducers](http://redux.js.org/docs/basics/Reducers.html)

+ [Recipes: Structuring Reducers](http://redux.js.org/docs/recipes/StructuringReducers.html)

+ [Twitter: most common Redux misconception](https://twitter.com/dan_abramov/status/682923564006248448)

+ [#1167: Reducer without switch](https://github.com/reactjs/redux/issues/1167)

+ [Reduxible #8: Reducers and action creators aren't a one-to-one mapping](https://github.com/reduxible/reduxible/issues/8)

+ [Stack Overflow: Can I dispatch multiple actions without Redux Thunk middleware?](http://stackoverflow.com/questions/35493352/can-i-dispatch-multiple-actions-without-redux-thunk-middleware/35642783)


#### 1.5.3 How can I represent "side effects" such as AJAX calls? Why do we need things like "action creators", "thunks", and "middleware" to do async behavior?

This is a long and complex topic, with a wide variety of opinions on how code should be organized and what approaches should be used. Any meaningful web app needs to execute complex logic, usually including asynchrounous work such as making AJAX requests. That code is no longer purely a function of its inputs, and the interctions with the outside world are known as ["side effects"](https://en.wikipedia.org/wiki/Side_effect_%28computer_science%29).

Redux is inspired by functional programming, and out of the box, has no place for side effects to be executed. In particular, reducer functions must always be pure functions of `(state, action) => newState`. However, Redux's middleware makes it possible to intercept dispatchd actions and add additional complex behavior around them, including side effects.

In general, Redux suggests that code with side effects should be part of the action creation process. While that logic can be performed inside of a UI component, it generally makes sense to extract that logic into a reusable function so that the same logic can be called from multiple places - in other words, an action creator function.

The simplest and most common way to do this is to add the [Redux Thunk](https://github.com/gaearon/redux-thunk) middleware that lets you write action creators with more complex and asynchronous logic. Another widely-used method is [Redux Saga](https://github.com/yelouafi/redux-saga) which lets you write more synchronous-looking code using generators, and can act like "background threads" or "daemons" in a Redux app. Yet another approach is [Redux Loop](https://github.com/raisemarketplace/redux-loop), which invertes the process by allowingyour reducers to declare side effects in response to state changes and have them executed separately. Beyond that, there are many other community-developed libraries and ideas, each with their own take on how side effects should be managed.

Further Inforamtion

+ [Advanced: Async Actions](http://redux.js.org/docs/advanced/AsyncActions.html)

+ [Advanced: Async Flow](http://redux.js.org/docs/advanced/AsyncFlow.html)

+ [Advanced: Middleare](http://redux.js.org/docs/advanced/Middleware.html)

+ [Redux SideEffects and You](https://medium.com/@fward/redux-side-effects-and-you-66f2e0842fc3)

+ [Pure functionality and side effects in Redux](http://blog.hivejs.org/building-the-ui-2/)

+ [From Flux to Redux: Async Actions the easy way](http://danmaz74.me/2015/08/19/from-flux-to-redux-async-actions-the-easy-way/)

+ [React/Redux Links: "Redux Side Effects" category](https://github.com/markerikson/react-redux-links/blob/master/redux-side-effects.md)

+ [Gist: Redux-Thunk examples](https://gist.github.com/markerikson/ea4d0a6ce56ee479fe8b356e099f857e)

+ [#291: Trying to put API calls in the right place](https://github.com/reactjs/redux/issues/291)

+ [#455: Modeling side effects](https://github.com/reactjs/redux/issues/455)

+ [#533: Simpler introduction to async action creators](https://github.com/reactjs/redux/issues/533)

+ [#569: Proposal: API for explicit side effects](https://github.com/reactjs/redux/pull/569)

+ [#1139: An alternative side effect model based on generators and sagas](https://github.com/reactjs/redux/issues/1139)

+ [Stack Overflow: Why do we need middleware for async flow in Redux](http://stackoverflow.com/questions/34570758/why-do-we-need-middleware-for-async-flow-in-redux)

+ [Stack Overflow: How to dispatch a Redux aciton with a timeout](http://stackoverflow.com/questions/35411423/how-to-dispatch-a-redux-action-with-a-timeout/35415559)

+ [Stack Oveflow: Where should I put synchronous side effects linked to actions in redux?](http://stackoverflow.com/questions/32982237/where-should-i-put-synchronous-side-effects-linked-to-actions-in-redux/33036344)

+ [Stack Overflow: How to handle complex side-effects in Redux?](http://stackoverflow.com/questions/32925837/how-to-handle-complex-side-effects-in-redux/33036594)

+ [Stack Overflow: How to unit test aysnc Redux actions to mock ajax response](http://stackoverflow.com/questions/33011729/how-to-unit-test-async-redux-actions-to-mock-ajax-response/33053465)

+ [Stack Overflow: How to fire AJAX calls in response to the state changes with Redux?](http://stackoverflow.com/questions/35262692/how-to-fire-ajax-calls-in-response-to-the-state-changes-with-redux/35675447)

+ [Reddit: Help performing Async API calls with Redux-Promisse Middleware.](https://www.reddit.com/r/reactjs/comments/469iyc/help_performing_async_api_calls_with_reduxpromise/)

+ [Twitter: possible comparison between sagas, loops, and other approaches](https://twitter.com/dan_abramov/status/689639582120415232)


#### 1.5.4 Should I dispatch multiple actions in a row from one action creator?

There's no specific rule for how you shold structure your actions. Using an async middleware like Redux Thunk certainly enables scenarios such as dispatching multiple distinct but related actions in a row, dispatching actions to represent progression of an AJAX request, dispatching actions conditionally based on state, or even dispatching an action and cehcking the updated state immediately afterwards. In general, ask if these actions are related but independent, or should actually be represented as one action. Do what makes sense for your own situation but try to balance the readability of reducers with readability of the action log. For example, an action that includes the whole new state tree would make your reducer a one-liner, but the downside is now you have no history of why the changes are happening, so debugging gets really difficult. On the other hand, if you emit actions in a loop to keep them granular, it's a sign that you might want to introduce a new aciton type that is handled in a different way. Try to avoid dispatching several times synchronously in a row in the places where you're concerned about performance. There are a number of addons and approaches that tha can batch up dispatches as well.

Further Information

+ [FAQ: Performance - Reducing Update Events](http://redux.js.org/docs/faq/Performance.html#performance-update-events)

+ [Idiomatic Redux: Thoughts on THunks, Sagas, Abstraction, and Reusability](http://blog.isquaredsoftware.com/2017/01/idiomatic-redux-thoughts-on-thunks-sagas-abstraction-and-reusability/#multiple-dispatching)

+ [#597: Valid to dispatch multiple actions from an event handler?](https://github.com/reactjs/redux/issues/597)

+ [#959: Multiple actions one dispatch?](https://github.com/reactjs/redux/issues/959)

+ [Stack Overflow: Should I use one or several action types to represent this async action?](http://stackoverflow.com/questions/33637740/should-i-use-one-or-several-action-types-to-represent-this-async-action/33816695)

+ [Stack Overflow: Do events and actions ahve a 1:1 relatioship in Redux](http://stackoverflow.com/questions/35406707/do-events-and-actions-have-a-11-relationship-in-redux/35410524)

+ [Stack Overflow: Should actions be handled by reducers to related actions or generated by action creators themselves?](http://stackoverflow.com/questions/33220776/should-actions-like-showing-hiding-loading-screens-be-handled-by-reducers-to-rel/33226443#33226443)

+ [Twitter: "Good thread ont eh problems with Redux Thunk..."](https://twitter.com/dan_abramov/status/800310164792414208)

### 1.6 Immutable Data

#### 1.6.1 What are the benefits Immutability?

Immutability can bring increased performance to your app, and leads to simpler programming and debugging, as data that never changes is easier to reason about than data that is free to be changed arbitrarily throughout your app. In particular, immutability in the context of a Web app enables sophisticated change detection techniques to be implmented simply and cheaply, ensuring the computationally expensive process of updating the DOM occurs only when it absolutely has to (a cornerstone of React's performance improvements over other libraries)

Further Information

+ [Introduction to Immutable.js and Functional Programming Concepts](https://auth0.com/blog/intro-to-immutable-js/)

+ [JavaScript Immutability presentation (PDF - see slide 12 for benefits](https://www.jfokus.se/jfokus16/preso/JavaScript-Immutability--Dont-Go-Changing.pdf)

+ [Immutable.js - Immutable Collections for JavaScript](https://facebook.github.io/immutable-js/#the-case-for-immutability)

+ [React: Optimizing Performance](https://facebook.github.io/react/docs/optimizing-performance.html)

+ [JavaScript Application Architecture On The Road to 2015](https://medium.com/google-developers/javascript-application-architecture-on-the-road-to-2015-d8125811101b#.djje0rfys)

#### 1.6.2 Why is immutability required in Redux?

+ Both Reudx and React-Redux employ [shallow equality checking](http://redux.js.org/docs/faq/ImmutableData.html#shallow-and-deep-equality-checking). In particular: Redux's `combineReducers` utility [shallowly checks for reference changes](http://redux.js.org/docs/faq/ImmutableData.html#how-redux-uses-shallow-checking) caused by the reducers that it calls; React-Redux's `connect` method generates components that [shallowly check reference changes to the root state](http://redux.js.org/docs/faq/ImmutableData.html#how-react-redux-uses-shallow-checking), and the return values fromt eh `mapStateToProps` function to see if the wrapped components actually need to-rerender. Such [shallow checking requires immutability](http://redux.js.org/docs/faq/ImmutableData.html#redux-shallow-checking-requires-immutability) to function correctly.

+ Immutable data management ultimately makes data handling safer.

+ Time-travel debugging requires that reducers be pure functions with no side effects, so that you can correctly jump between different states.

Further Information

+ [Recipes: Prerequisite Reducer Concepts](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html)

+ [Reddit: Why Redux Needs Reducers To Be Pure Functions](https://www.reddit.com/r/reactjs/comments/5ecqqv/why_redux_need_reducers_to_be_pure_functions/dacmmjh/?context=3)

#### 1.6.3 Why does Reudx's use of shallow equality checking require immutability?

Redux's use of shallow equality checking requires immutability if any connected components are to be updated correctly. To see why, we need to understand the idfference between shallow and deep equality checking in JavaScript

##### 1.6.3.1 How do Shallow and Deep Equality Checking diff?

Shallow equality checking (or reference equality) simply checks that two different varaibles reference the same object; in contrast, deep equality checking (or value equality) must check every value of two objects' properties.

A shallow equality check is therefore as simple (and as fast) as `a === b`, whereas a deep equality check involves a recursive traversal through the properties of two objects, comparing the value of each property at each step.

It's for this improvement in performance that Redux uses shallow equality checking.

Further Information

+ [Pros and Cons of using immutability with React.js](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)

##### 1.6.3.2 How does Redux use shallow equality checking?

Redux uses shallow equality checking in its `combineReducers` function to return either a new mutated copy of the root object, or, if no mutations have been made, the current root state object.

Further Information

+ [API: combineReducers](http://redux.js.org/docs/api/combineReducers.html)

##### 1.6.3.3 How does `combineReducers` use shallow equality checking?

The [suggested structure](http://redux.js.org/docs/faq/Reducers.html#reducers-share-state) for a Redux store is to split the state object into multiple "slices" or "domains" by key, and provide a separate reducer function to manage each individual data slice. `combineReducers` makes working with this style of structure easier by taking a `reducers` argument that's defined as a hash table comprising a set of key/value pairs, where each key is the name of a state slice, and the corresponding value is the reducer funciton that will act on it. So, for example, if your state shape is `{ todos, counter }`, the call to `combineReducers` would be:

{% highlight js linenos %}
combineReducers({ todos: myTodosReducer, counter: myCounterReducer })
{% endhighlight %}

where:

+ the keys `todos` and `counter` each refer to a separate state slice;

+ the values `myTodosReducer` and `myCounterReducer` are reducer functions, with each acting on the state slice identified by the respective key.

`combineReducers` iterates through each of these key/value pairs. For each iteration, it:

+ creates a reference to the current state slice referred to by each key;

+ calls the appropriate reducer and passes it the slice;

+ creates a reference to the possibly-mutated state slice that's returned by the reducer.

As it continues through the iterations, `combineReducers` will construct a new state object with the state slices returned from each reducer. This new state object may or may not be different from the current state object. It is here that `combineReducers` uses shallow equality checking to determine whether the state has changed.

Specifically, at each stage of the iteration, `combineReducers` performs a shallow equality check on the current state slice and the state slice returned from the reducer. If the reducer returns a new object, the shallow equality check will fail, and `combineReducers` will set a `hasChanged` flag to true. 

After the iterations have completed, `combineReducers` will check the state of the `hasChanged` flag. If it's true, the newly-constructed state object will be returned. If it's false, the current state object is returned.

This is worth emphasising: If the reducers all return the same `state` object passed to them, then `combineReducers` will return the current root state object, no the newly updated one.

Further Information

+ [API: combineReducers](http://redux.js.org/docs/api/combineReducers.html)

+ [Redux FAQ - How do I share state between two reducers? Do I have to use `combineReducers`](http://redux.js.org/docs/faq/Reducers.html#reducers-share-state)

+ [Egghead.io: Redux: Implementing combineRedcers() from Scratch](https://egghead.io/lessons/javascript-redux-implementing-combinereducers-from-scratch)


##### 1.6.3.4 How does React-Redux use shallow equality checking ?

React-Redux uses shallow equality checking to determine whether the component it's wrapping needs to be re-rendered. To do this, it assumes that the wrapped component is pure: that is, that the component will produce the [same results givent eh same props and state](https://github.com/reactjs/react-redux/blob/f4d55840a14601c3a5bdc0c3d741fc5753e87f66/docs/troubleshooting.md#my-views-arent-updating-when-something-changes-outside-of-redux).

By assuming the wrapped component is pure, it need only check whether the root state object or the values returned from `mapStateToProps` have changed. If they haven't, the wrapped componenet does not need re-rendering.

It detects a change by keeping a reference to the root state object, and a reference to each value in the props object that's returned from the `mapStateToProps` function.

It then runs a shallow equality check on ites reference to the root state object and the state object passed to it, and a separate series of shallow checks on each reference to the props object's values and those that are returned from running the `mapStateToProps` function again.

Further Information

+ [React-Redux Bindings](http://redux.js.org/docs/basics/UsageWithReact.html)

+ [API: React-Redux's connect function and `mapStateToProps`](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options)

+ [Troubleshooting: My views aren't updating when something changes outside of Redux](https://github.com/reactjs/react-redux/blob/f4d55840a14601c3a5bdc0c3d741fc5753e87f66/docs/troubleshooting.md#my-views-arent-updating-when-something-changes-outside-of-redux)

##### 1.6.3.6 Why does React-Redux shallowly check each value within the props object returned from `mapStateToProp`?

React-Redux performs a shallow equality check on each value within the props object, not on the props object itself. It does so because the props object is actually a hash of prop names and their values (or selector functions that are used to retrieve or generate the values), such as in this example:

{% highlight js linenos %}
function mapStateToProps(state) {
  return {
    todos: state.todos, // prop value
    visibleTodos: getVisibleTodos(state) // selector
  }
}

export default connect(mapStateToProps)(TodoApp)
{% endhighlight %}

As such, a shallow equality check of the props object returned from repeated calls to `mapStateToProps` would always fail, as a new object woul dbe returned each time.

React-Redux therefore maintains separate references to each value in the returned props object.

Further Information

+ [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f#.gh07cm24f)

##### 1.6.3.7 How does React-Redux use shallow equality checking to determine whether a component needs re-rendering?

Each time React-Redux's `connect` function is called, it will perform a shallow equality check on its stored reference to the root state objet, and the current root stte object passed to it from the store. If the check passed, the root state object has not been updated, and so there is no need to nre-render the component, or even call `mapStateToProps`.

If the check fails, however, the root state object has been updated, and so `connect` will call `mapStateToProps` to see if the props for the wrapped component have been updated. It does this by performing a shallow equality check on each value within the object individually, and will only trigger a re-render if one of those checks fails. In the example below, if `state.todos` and the value returned from `getVisibleTodos()` do not change on succesive calls to `connect`, then the component will not re-render.

{% highlight js linenos %}
function mapStateToProps(state) {
  return {
    todos: state.todos, // prop value
    visibleTodos: getVisibleTodos(state) // selector
  }
}
export default connect(mapStateToProps)(TodoApp)
{% endhighlight %}

Conversely, in this next example (below), the component will always re-render, as the value of `todos` is always a new object, regardless of whether or not its values change:

{% highlight js linenos %}
// AVOID - will always cause a re-render
function mapStateToProps(state) {
  return {
    // todos always references a newly-created object
    todos: {
      all: state.todos,
      visibleTodos: getVisibleTodos(state)
    }
  }
}

export default connect(mapStateToProps)(TodoApp)
{% endhighlight %}

If the shallow equality check fails between the new values returned from `mapStateToProps` and the previous values that React-Redux kept a reference to , then a re-rendering of the component will be triggered.

Further Information

+ [Practical Redux, Part 6: Connected Lists, Forms, and Performance](http://blog.isquaredsoftware.com/2017/01/practical-redux-part-6-connected-lists-forms-and-performance/)

+ [React.js Pure Render Performance Anti-Pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f#.sb708slq6)

+ [High Performance Redux Apps](http://somebody32.github.io/high-performance-redux/)

+ [#1816: Component connected to state with `mapStateToProps`](https://github.com/reactjs/redux/issues/1816)

+ [#300: Potential connect() optimization](https://github.com/reactjs/react-redux/issues/300)

##### 1.6.3.8 Why will shallow equality checking not work with mutable obejcts?

Shallow equality checking cannot be used to detect if a function mutates an object passed into it if that object is mutable. This is because two variables that reference the same object will always be equal, regardless of whether the object's values changes or not, as they're both referencing the same object. Thus, the following will always return true:

{% highlight js linenos %}
function mutateObj(obj) {
  obj.key = 'newValue'
  return obj
}

const param = { key: 'originalValue' }
const returnVal = mutateObj(param)

param === returnVal
//> true
{% endhighlight %}

The shallow check of `param` and `returnValue` simply checks whether both variables reference the same object, which they do. `mutateObj()` may return a mutated version of `obj`, but it;s still the same object as that passed int. The fact that its values have been changed within `mutateObj` matters not at all to a shallow check.

Further Information

+ [Pros and Cons of using immutability with React.js](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)

##### 1.6.3.9 Does shallow equality checking with a mutable object cause problems with Redux?

Shallow equality checking with a mutable object will not cause probelms with Redux, but [it will cause problems with libraries that depend on the store, such as React-Redux](http://redux.js.org/docs/faq/ImmutableData.html#shallow-checking-problems-with-react-redux).

Specifically, it the state slice passed to a reducer by `combineReducers` is a mutable object, the reducer can modify it directly and return it.

If it does, the shallow equality check that `combineReducers` eprfroms will always pass, as the values state slice returned by the reducer may have been mutated, but the object itself has not - it's still the same object that was passed to the reducer.

Accordingly, `combineReducers` willnot set its `hasChanged` flag, even though the state has changed. If none of the other reducers return anew, updated state slice, the `hasChanged` flag will remain set to false, causing `combienReducers` to return the existing root state object.

The store will still be updated with the new values for the root state, but because the root state object itself is still the same object, libraries that bind to Redux, such as React-Redux, will not be aware of the state's mutation, and so will not trigger a wrapped component's re-rendering.

Further Information

+ [Recipes: Immutable Update Patterns](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

+ [Troubleshooting: Never mutate reducer arguments](http://redux.js.org/docs/Troubleshooting.html#never-mutate-reducer-arguments)

##### 1.6.3.10 Why does a reducer mutating the state prevent React-Redux from re-rendering a wrapped component?

If a Redux reducer directly mutates, and returns, the state object passed into it, the values of the root state object will change, but the object itself will not.

Because React-Redux performs a shallow check on the root state object to determine if its wrapped componenets need re-rendering or not, it will not be able to detect the state mutation, and so will not trigger a re-rendering.

Further Information

+ [Troubleshooting: My views aren't updating when something changes outside of Redux](https://github.com/reactjs/react-redux/blob/f4d55840a14601c3a5bdc0c3d741fc5753e87f66/docs/troubleshooting.md#my-views-arent-updating-when-something-changes-outside-of-redux)

##### 1.6.3.11 Why does a selector mutating and returning a persistent object to `mapStateToProps` prevent React-Redux from re-rendering a wrapped component?

If one of the values of the props object returned from `mapStateToProps` is an object that persistes across calls to `connect` (such as, potentially, the root state object), yet is directly mutated and returned by a selector function, React-Redux will not be able to detect the mutation, and so will not trigger a re-render of the wrapped component.

As we've seen, the values in the mutable object returned by the selector function may have changed, but the object itself has not, and shallow equality checking nonly compares the objects themselves, not their values.

For example, the following `mapStateToProps` funciton will never trigger a re-render:

{% highlight js linenos %}
// State object held in the Redux store
const state = {
  user: {
    accessCount: 0,
    name: 'keith'
  }
}

// Selector function
const getUser = state => {
  ++state.user.accessCount // mutate the state object
  return state
}

// mapStateToProps
const mapStateToProps = state => ({
  // The object returned from getUser() is always
  // the same object, so this wrapped
  // component will never re-render, even though it's been
  // mutated
  userRecord: getUser(state)
})

const a = mapStateToProps(state)
const b = mapStateToProps(state)

a.userRecord === b.userRecord
//> true
{% endhighlight %}

Note that, conversely, if an immutable object is used, the [component may re-render when it should not](http://redux.js.org/docs/faq/ImmutableData.html#immutability-issues-with-react-redux).

Further Information

+ [Practical Redux, Part 6: Connected Lists, Forms, and Performance](http://blog.isquaredsoftware.com/2017/01/practical-redux-part-6-connected-lists-forms-and-performance/)

+ [#1948: Is getMappedItems an anti-pattern in mapStateToProps](https://github.com/reactjs/redux/issues/1948)

##### 1.6.3.12 How does immutability enable a shallow check to detect object mutations?

If an object is immutable, any changes that need to be made to it within a function must be made to a copy of the object. This mutated copy is a separate object from that passed into the function, and so when it is returned, a shallow check will identify it as being a different object from that passed int and so will fail.

Further Information

+ [Pros and Cons using immutability with React.js](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)


#### 1.6.4 How can immutability in your reducers cause components to render unecessarily?

You cannot mutate an immutable object: insead, you must mutate a copy of it, leaving the original intact.

That's perfectly OK when you mutate the copy, but in the context of a reducer, if you return a copy hasn't been mutated, Redux's `combineReducers` function will still think that the state needs to be updated, as you're returning an entirely different object formt he state slice object that was passed in.

`combineReducers` will then return this new root state object to the store. The new object will have the same values as the current root state object, but because it's a different object, it will cause the store to be udpated, which will ultimately cause all connected components to be re-rendered unnecessarily.

To prevent this from happening, you must always return the state slice object that's passed into a reducer if the reducer does not mutate the state.

Further Information

+ [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f#.5hmnwygsy)

+ [Building Efficient UI with React and Redux](https://www.toptal.com/react/react-redux-and-immutablejs)

#### 1.6.5 How can immutability in `mapStateToProps` cause components to render unecessarily?

Certain immutable operations, such as an Array filter, will always return a new object, even if the values themselves have not changed.

If such an operation is used as a selector function in `mapStateToProps`, the shallow equality check that React-Redux performs on each value in the props object that's returned will always fail, as the selector is returning a new object each time.

As such, even though the values of that new object have not changed, the wrapperd component will always be re-rendered.

For example, the following will always trigger a re-render:

{% highlight js linenos %}
// A JavaScript array's 'filter' method treats the array as immutable,
// and returns a filtered copy of the array.
const getVisibleTodos = todos => todos.filter(t => !t.completed)

const state = {
  todos: [
    {
      text: 'do todo 1',
      completed: false
    },
    {
      text: 'do todo 2',
      completed: true
    }
  ]
}

const mapStateToProps = state => ({
  // getVisibleTodos() always returns a new array, and so the
  // 'visibleToDos' prop will always reference a different array,
  // causing the wrapped component to re-render, even if the array's
  // values haven't changed
  visibleToDos: getVisibleTodos(state.todos)
})

const a = mapStateToProps(state)
//  Call mapStateToProps(state) again with exactly the same arguments
const b = mapStateToProps(state)

a.visibleToDos
//> { "completed": false, "text": "do todo 1" }

b.visibleToDos
//> { "completed": false, "text": "do todo 1" }

a.visibleToDos === b.visibleToDos
//> false
{% endhighlight %}

Note that, conversely, if the values in your props object refer to mutable objects, [your component may not render when it should](http://redux.js.org/docs/faq/ImmutableData.html#shallow-checking-stops-component-re-rendering).

Further Information

+ [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f#.b8bpx1ncj)

+ [Building Efficient UI with React and Redux](https://www.toptal.com/react/react-redux-and-immutablejs)

+ [ImmutableJS: worth the price?](https://medium.com/@AlexFaunt/immutablejs-worth-the-price-66391b8742d4#.a3alci2g8)

#### 1.6.6 What approaches are there for handling data immutably? Do I have to use Immutable.JS?

You do not need to use Immutable.JS with Redux. Plain JavaScript, if written correctly, is perfectly capable of providing mimmutability without having t ouse an immutable-focused library. 

However, guaranteeing immutability with JavaScript is difficult, and it can be easy to mutate an object accidentally, causing bugs in your appthat are extremely difficult to locate. For this reason, using an immutable update utility library such as Immutable.JS can significantly improve the reliability of your app, and make your app's development much easier.

Further Information

+ [#1185: Question: Should I use immutable data structures?](https://github.com/reactjs/redux/issues/1422)

+ [Introduction to Immutable.js and Functional Programming Concepts](https://auth0.com/blog/intro-to-immutable-js/)



##### 1.6.6.1 Using Immutalbe.JS with Redux

##### 1.6.6.2 Why should I use an immutable-focused library such as Immutable.JS?

##### 1.6.6.3 Why should I choose Immutable.JS as an immutable library?

##### 1.6.6.4 What are the issues with using Immutable.JS?

##### 1.6.6.5 Is Immutable.JS worth the effort?

##### 1.6.6.6 What are some opinionated Best Practices for using Immutable.JS with Redux?

#### 1.6.7 What are the issues with using JavaScript for immutable operations?

JavaScript was never designed to provide guaranteed immutable operations. Accordingly, there are several issues you need to be aware of it you choose to use it for your immutable operations in your Redux app.

**Accidental Object Mutation**

With JavaScript, you can accidentally mutate an object (such as the Redux state tree) quite easily without realising it. For example, updating deeply nested properties, creating a new reference to an object instead of a new object, or performing a shallow copy rather than a deep copy, can all lead to inadvertent object mutation, and can trip up even the most exeprienced JavaScript coder.

To avoid these issues, ensure you follow the recommended [immutable update patterns for ES6](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

**Verbose Code**

Updating complex nested state trees can lead to verbose code that is tedious to write and difficult to debug.

**Poor Performance**

Operating on JavaScript objects and arrays in an immutable way can be slow, particularly as your state tree grows larger.

Remember, to change an immutable object, you must mutate a copy of it, and copying large objects can be slow as every property must be copied.

In contrast, immutable libraries such as Immutable.JS can employ sophisticated optimization techniques such as [structural sharing](http://www.slideshare.net/mohitthatte/a-deep-dive-into-clojures-data-structures-euroclojure-2015), which effectively returns a new object tha treuses much of the existing object being copied from.

For copying very large objects, [plain JavaScript can be over 100 times slower](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.z1g1ofrsi) than an optimized immutable library.

Further Information

+ [Immutable Update Patterns for ES6](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

+ [Immutable.js, persistent data structures and structural sharing](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2#.a2jimoiaf)

+ [A deep dive into Clojure's data structures](http://www.slideshare.net/mohitthatte/a-deep-dive-into-clojures-data-structures-euroclojure-2015)

+ [Introduction to Immutable.js and Functional Programming Concepts](https://auth0.com/blog/intro-to-immutable-js/)

+ [JavaScript and Immutability](http://t4d.io/javascript-and-immutability/)

+ [Immutable Javascript using ES6 and beyond](http://wecodetheweb.com/2016/02/12/immutable-javascript-using-es6-and-beyond/)

+ [Pros and Cons of using immutability with Reat.js - React Kung Fu](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)

### 1.7 Code Structure

#### 1.7.1 What should my file structure look like? How should I group my action creators and reducers in my project? Where should my selectors go?

Since Redux is just a data store library, it has no direct opinion on how your project should be structured. However, there are a few common patterns that most Redux developers tend to use:

+ **Rails-style**: separate foleders for "actions", "constans", "reducers", "containers", and "componenets";

+ **Domain-style**: separate folders per feature or domain, possibly with sub-folders per file type;

+ **Ducks**: similar to domain style, but explictly tying together actions and reducers, often by defining them in the same file.

It's generally suggested that selectors are defined alongside reducers and exported, and then reused elsewhere (such as in `mapStateToProps`) funcitons, in async action creators, or sagas) to colocate all the code that knows about the actual shape of the state tree in the reducer files.

While it ultimately doesn't matter how you lay out your code on disk, it's important to remember that actions and reducers shouldn't considered in isolation. It's entirely possible (and encouraged) for a reducer defined in one folder to respond to an action defined in another folder.

Further Information

+ [FAQ: Actions - "1:1 mapping between reduers and actions?"](http://redux.js.org/docs/faq/Actions.html#actions-reducer-mappings)

+ [How to Scale React Applications](https://www.smashingmagazine.com/2016/09/how-to-scale-react-applications/), [Scaling React Applications](https://vimeo.com/168648012)

+ [Redux Best Practices](https://medium.com/lexical-labs-engineering/redux-best-practices-64d59775802e)

+ [Rules For Structuring (Redux) Applications](http://jaysoo.ca/2016/02/28/organizing-redux-application/)

+ [A Better File Structure for React/Redux Applications](http://marmelab.com/blog/2015/12/17/react-directory-structure.html)

+ [Organizing Large React Applications](http://engineering.kapost.com/2016/01/organizing-large-react-applications/)

+ [Four Strategies for Organizing Code](https://medium.com/@msandin/strategies-for-organizing-code-2c9d690b6f33)

+ [Encapsulating the Redux State Tree](http://randycoulman.com/blog/2016/09/13/encapsulating-the-redux-state-tree/)

+ [Redux Reducer/Selector Asymmetry](http://randycoulman.com/blog/2016/09/20/redux-reducer-selector-asymmetry/)

+ [Modular Reducers and Selectors](http://randycoulman.com/blog/2016/09/27/modular-reducers-and-selectors/)

+ [My journey towards a maintainable project structure for React/Redux](https://medium.com/@mmazzarolo/my-journey-toward-a-maintainable-project-structure-for-react-redux-b05dfd999b5)

+ [React/Redux Links: Architecture - Project File Structure](https://github.com/markerikson/react-redux-links/blob/master/react-redux-architecture.md#project-file-structure)

+ [#839: Emphasize defining selectors alongside reducers](https://github.com/reactjs/redux/issues/839)

+ [#943: Reducer querying](https://github.com/reactjs/redux/issues/943)

+ [React Boilerplate #27: Application Structure](https://github.com/mxstbr/react-boilerplate/issues/27)

+ [Stack Overflow: How to structure Redux components/containers](http://stackoverflow.com/questions/32634320/how-to-structure-redux-components-containers/32921576)

+ [Twitter: There is no ultimate file structure for Redux](https://twitter.com/dan_abramov/status/783428282666614784)

#### 1.7.2 How should I split my logic between reducers and action creators? Where should my "business logic" go?

There's no single clear answer to exactly what pieces of logic should go in a reducer or an action creator. Some developers prefer to have "fat" action creators, with "thin" reducers that simply take the data in an action and blindly merge it into the corresponding state. Others try to emphasize keeping actions as small as possible, and minimize the usage of `getState()` in an action creator. (For purposes of this question, other async approaches such as sagas and observables fall in the "action creator" category.)

There are some potential benefits from putting more logic into your reducers. It's likely that the action types would be more semantic and more meaningful (such as `USER_UPDATED` instead of `SET_STATE`). In addition, having more logic in reducers means that more functionality will be affected by time travel debugging.

This comment sums up the dichotomy nicely:
> Now, the probelm is what to put in the action creator and what in the reducer, the choice between fat and thin action objects. If you put all the logic in the action creator, you end up with fat action objects that basically declare the updates to the state. Reducers become pure, dumb, add-this, remove that, update these functions. They will be easy to compose. But not much of your business logic will be there. If you put more logic in the reducer, you end up with nice, thin action object, most of your data logic in one place, but your reducers are harder to compose since you might need info from other branches. You end up with large reducers or reducers that take additional arguments from higher up in state.

Find the balance between these two extremes, and you will master Redux.

+ [Where do I put my business logic in a React/Redux application?](https://medium.com/@jeffbski/where-do-i-put-my-business-logic-in-a-react-redux-application-9253ef91ce1)

+ [How to Scale React Applications](https://www.smashingmagazine.com/2016/09/how-to-scale-react-applications/)

+ [The Tao of Redux, Part 2- practice and Philosophy. Thick and thin reducers](http://blog.isquaredsoftware.com/2017/05/idiomatic-redux-tao-of-redux-part-2/#thick-and-thin-reducers)

+ [How putting too much logic in action creators could affect debugging](https://github.com/reactjs/redux/issues/384#issuecomment-127393209)

+ [#384: The more that's in a reducer, the more you can replay via time travel](https://github.com/reactjs/redux/issues/384#issuecomment-127393209)

+ [#1165: Where to put business logic/ validation?](https://github.com/reactjs/redux/issues/1165)

+ [#1171: Recommendations for best practices regarding action-creators, reducers, and selectors](https://github.com/reactjs/redux/issues/1171)

+ [Stack Overflow: Accessing Redux state in an action creator](http://stackoverflow.com/questions/35667249/accessing-redux-state-in-an-action-creator/35674575)

#### 1.7.3 Why should I use action creators?

Redux does not require action creators. You are free to create actions in any way that is best for you, including simply passing an object literal to `dispatch`. Action creators emerged from the [Flux architecture](https://facebook.github.io/react/blog/2014/07/30/flux-actions-and-the-dispatcher.html#actions-and-actioncreators) and have been adopted by the Redux community because they offer several benefits.

Action creators are more maintainable. Updates to an action can be made in one place and applied everywhere. All instances of an action are guaranteed to have the same shape and the same default values.

Action creators are testable. The correctness of an inline action must be verified mannually. Like any function, tests for an action creator can be written once and run automatically. Action creators are easier to document. The action creator's parameters enumerate the actio's dependencies. And centralization of the action definition provides a convenient place for documentation comments. When actions are written inline, this information is harder to capture and communicate.

Action creators are a more powerful abstraction. Creating an action often involves transforming data or making AJAX requests. Action creators provide a unifrom interface to this varied logic. This abstraction frees a component to dispatch an action without being complicated by the dtails of that action's creation.

Further Information

+ [Idiomatic Redux: Why use action creators](http://blog.isquaredsoftware.com/2016/10/idiomatic-redux-why-use-action-creators/)

+ [Reddit: Redbox - Reux action creation made simple](https://www.reddit.com/r/reactjs/comments/54k8js/redbox_redux_action_creation_made_simple/d8493z1/?context=4)

### 1.8 Peformance

#### 1.8.1 How well does Redux "scale" in terms of performance and architecture?

While there's no single definitive answer to this, most of the time this should not be a concern in either case.

The work done by Redux generally falls into a few areas: processing actions in a middleware and reducers (including object duplication for immutable updates), notifying subscribers after actions are dispatched, and updating UI components based on the state changes. While it's certainly possible for each of these to become a performance concern in sufficiently complex situations, there's nothing inherently slow or inefficient about how Redux is implemented. In fact, React Redux in particular is heavily optimized to cut down on unnecessary re-renders, and React-Redux v5 shows noticeable improvements over earlier versions.

Redux may not be as efficient out of the box when compared to other libraries. For amximum rendering performance in a React application, state should be stored in a normalized shape, many individual components should be connected to the store instead of just a few, and connected list components should pass item IDs to their connected child list items (allowing the list items to look up their own data by ID). This minimizes the overall amount of rendering to be done. Use of memoized selector functions is also an important performance consideration. As for architecture, anecdotal evidence is that Redux works well for varying project and team sizes. Redux is currently used by hundreds of companies and thousands of developers, with several hundred thousand monthly installations from NPM. One developer reported:

> for scale, we have ~500 action types, ~400 reducer cases, ~150 components, 5 middlewares, ~200 actions, ~2300 tests.

Further Information

+ [Recipes: Structring Reducers - Normalizing State Shape](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html)

+ [How to Scale React Applications](https://www.smashingmagazine.com/2016/09/how-to-scale-react-applications/), [Scaling React Applications](https://vimeo.com/168648012)

+ [High-Performance Redux](http://somebody32.github.io/high-performance-redux/)

+ [Improving React and Redux Perf with Reselect](http://blog.rangle.io/react-and-redux-performance-with-reselect/)

+ [#310: Who uses Redux?](https://github.com/reactjs/redux/issues/310)

+ [#1751: Performance issues with large collections](https://github.com/reactjs/redux/issues/1751)

+ [React Redux #269: Connect could be used with a custom subscribe method](https://github.com/reactjs/react-redux/issues/269)

+ [React Redux #407: Rewrite connect to offer an advanced API](https://github.com/reactjs/react-redux/issues/407)

+ [React Redux #416: Rewrite connect for better performance and extensibility](https://github.com/reactjs/react-redux/pull/416)

+ [Redux vs MobX TodoMVC Benchmark: #1](https://github.com/mweststrate/redux-todomvc/pull/1)

+ [Reddit: What's the best place to keep the initial state?](https://www.reddit.com/r/reactjs/comments/47m9h5/whats_the_best_place_to_keep_the_initial_state/)

+ [Reddit: Help designing Redux state for a single page app](https://www.reddit.com/r/reactjs/comments/48k852/help_designing_redux_state_for_a_single_page/)

+ [Reddit: Redux performance issues with a large state object?](https://www.reddit.com/r/reactjs/comments/41wdqn/redux_performance_issues_with_a_large_state_object/)

+ [Reddit: React/Redux for Ultra Large Scale apps](https://www.reddit.com/r/javascript/comments/49box8/reactredux_for_ultra_large_scale_apps/)

+ [Twitter: Redux scaling](https://twitter.com/NickPresta/status/684058236828266496)

+ [Twitter: Redux vs Mob X benchmark graph - Redux state shape matters](https://twitter.com/dan_abramov/status/720219615041859584)

+ [Stack Overflow: How to optimize small updates to props of nested components?](http://stackoverflow.com/questions/37264415/how-to-optimize-small-updates-to-props-of-nested-component-in-react-redux)

+ [Chat log: React/Redux perf - updating a 10K -item Todo list](https://gist.github.com/markerikson/53735e4eb151bc228d6685eab00f5f85)

+ [Chat log: React/Redux perf - single connection vs many connections](https://gist.github.com/markerikson/6056565dd65d1232784bf42b65f8b2ad)


#### 1.8.2 Won't calling "all my reducers" for each action be slow?

It's important to note that a Redux store really only has a single reducer function. The store passes the current state and dispatched action to that one reducer funciton, and lets the reducer handle things appropriately.

Obviously, trying to handle every possible action in a single funciton does not scale well, simply in terms of function size and readability, so it makes sense to split the actual work into spearate functions that can be called by the top-level reducer. In particular, the common suggested pattern is to have a separate sub-reducer function that is responsible for managing updates to a particular slice of state at a specific key. The `combineReducers()` that comes with Redux is one of the many possible ways to achieve this. It's also highly suggested to keep your store state as flat and as normalized as possible. Ultimately, though, you are in charge of organizing your reducer logic any way you want.

However, even if you happen to have many different reducer functions composed together, and even with deeply nested state, reducer speed is unlikely to be a problem. JavaScript engines are capable of running a very large number of function calls per second, and most of your reducers are probably just using a `switch` statement and returning the existing state by default in response to most actions.

If you actuallly are concerned about reducer performance, you can use a utility such as [redux-ignore](https://github.com/omnidan/redux-ignore) or [redux-scoped-reducer](https://github.com/chrisdavies/reduxr-scoped-reducer) to ensure that only certain reducers listen to specific actions. You can also use [redux-log-slow-reducers](https://github.com/michaelcontento/redux-log-slow-reducers) to do some performance benchmarking.

Further Information

+ [#912: Proposal: action filter utility](https://github.com/reactjs/redux/issues/912)

+ [#1303: Redux Performance with Large Store and Frequent Updates](https://github.com/reactjs/redux/issues/1303)

+ [#Stack OVerflow: State in Redux app has the name of the reducer](http://stackoverflow.com/questions/35667775/state-in-redux-react-app-has-a-property-with-the-name-of-the-reducer/35674297)

+ [Stack Overflow: How does Redux deal with deeply nested models](http://stackoverflow.com/questions/34494866/how-does-redux-deals-with-deeply-nested-models/34495397)

#### 1.8.3 Do I have to deep-clone my state in a reducer? Isn't copying my state going to be slow?

Immutably updating state generally means making shallow copies, not deep copies. Shallow copies are much faster than deep copies, because fewer objects and fields have to be copied, and it effectively comes down to moving some pointers around.

However, you do need to create a copied and updated object for each level of nesting that is affected. Alghtough that shouldn't be particularly expensive, it's another good reason why you should keep your state normalized and shallow if possible.

> Common Redux misconception: you need to deeply clone the state. Reality: if something inside doesn't change, keep its reference the same!

+ [Recipes: Structuring Reducers - Prerequisite Concepts](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html)

+ [Recipes: Structuring Reducers - Immutable Update Patterns](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

+ [#454: Handling big states in reducer](https://github.com/reactjs/redux/issues/454)

+ [#758: Why can't state be mutated](https://github.com/reactjs/redux/issues/758)

+ [#994: How to cut the boilerplate when updating nested entities?](https://github.com/reactjs/redux/issues/994)

+ [Twitter: common misconception - deep cloning](https://twitter.com/dan_abramov/status/688087202312491008)

+ [Cloning Objects in JavaScript](http://www.zsoltnagy.eu/cloning-objects-in-javascript/)

#### 1.8.4 How can I reducer the number of store update events?

Redux notifies subscribers after each successfully dispatched action (i.e. an action reached the store and was ahndled by reducers). In some cases, it may be useful to cut down on the number of times subscribers are called, particularly if an action creator dispatches multiple distinct actions in a row.

If you use React, note that you can improve perfromance of multiple synchronous dispatches by wrapping them in `ReactDOM.unstable_batchedUpdates()`, but his API is experimental and may be removed in any React release so don't rely on it too heavily. Take a look at [redux-batched-actions](https://github.com/tshelburne/redux-batched-actions)(a higher order reducer that lets you dispatch several actions as if it was one and "unpack" them in the reducer), [redux-batched-subscribe](https://github.com/tappleby/redux-batched-subscribe)(a store enhancer that lets you debounce subscriber calls for multiple dispatches), or [redux-batch](https://github.com/manaflair/redux-batch)(a store enhancer that handles dispatching an array of actions with a single subscriber notification).

+ [#125: Strategy for avoiding cascading renders](https://github.com/reactjs/redux/issues/125)

+ [#542: Idea: batching actions](https://github.com/reactjs/redux/issues/542)

+ [#911: Batching actions](https://github.com/reactjs/redux/issues/911)

+ [#1813: Use a loop to support dispatching arrays](https://github.com/reactjs/redux/pull/1813)

+ [React Redux #263: Huge performance issue when dispatching hundreds of actions](https://github.com/reactjs/react-redux/issues/263)

+ [Redux Addons Catalog: Store - Change Subscriptions](https://github.com/markerikson/redux-ecosystem-links/blob/master/store.md#store-change-subscriptions)

#### 1.8.5 Will having "one state tree" cause memory problems? Will dispatching many actions take up memory?

First, in terms of raw memory usage, Redux is no different than any other JavaScript library. The only difference is that all the various object references are nested together into one tree, instead of maybe saved in various independent model instances such as in Backbone. Second, a typical Redux app would probably have somewhat less memory usage than an equivalent Backbone app because Redux encourages use of plain JavaScript objects and arrays rather than creating instances of Models and Collections. Finally, Redux only holds onto a single state tree reference at a time. Objects that are no longer referenced in that tree will be garbage collected, as usual.

Redux does not store a history of actions itself. However, the Redux DevTools do store actions so they can be replayed, but those are generally only enabled during development, and not used in production.

Further Information

+ [Docs: Async Actions](http://redux.js.org/docs/advanced/AsyncActions.html)

+ [Stack Overflow: Is there any way to "commit" the state in Redux to free memory](http://stackoverflow.com/questions/35627553/is-there-any-way-to-commit-the-state-in-redux-to-free-memory/35634004)

+ [Stack Overflow: Can a Redux store lead to a memory leak?](https://stackoverflow.com/questions/39943762/can-a-redux-store-lead-to-a-memory-leak/40549594#40549594)

+ [Stack Overflow: Redux and ALL the application state](https://stackoverflow.com/questions/42489557/redux-and-all-the-application-state/42491766#42491766)

+ [Stack Overflow: Memory Usage Concern with Controlled Components](https://stackoverflow.com/questions/44956071/memory-usage-concern-with-controlled-components?noredirect=1&lq=1)

+ [Reddit: What's the bes place to keep initial state?](https://www.reddit.com/r/reactjs/comments/47m9h5/whats_the_best_place_to_keep_the_initial_state/)


### 1.9 Design Decisions

#### 1.9.1 Why doesn't Redux pass the state and action to subscribers?

#### 1.9.2 Why doesn't Redux support using classes for actions and reducers?

#### 1.9.3 Why does the middleware signature use currying?

{% highlight js linenos %}
{% endhighlight %}

#### 1.9.4 Why does applyMiddlware use a closure for dispatch?

{% highlight js linenos %}
{% endhighlight %}

#### 1.9.5 Why doesn't `combineReducers` include a third argument with the entire state when it calls each reducer?

{% highlight js linenos %}
{% endhighlight %}

#### 1.9.6 Why doesn't `mapDispatchToProps` allow use of return values from `getState()` or `mapStateToProps()`?

### 1.10 React Redux

#### 1.10.1 Why isn't my component re-rendering, or my mapStateToProps running?

Accidentally mutating or modifying your state directly is by far the most common reason why components do not re-render after an action has been dispatched. Redux expects that your reducers will update their state "immutably", which effectively means always making copies of your data, and applying your changes to the copies. If you return the same object from a reducer, Redux assumes that nothing has been change, even if you made changes to its contents. Similarly, React Redux tries to improve performance by doing shallow equality reference checks on incoming props in `shouldComponentUpdate`, and if all references are the same, returns `false` to skip actually updating your original component.

It's important to remember that whenever you update a nested value, you must also return new copies of anything above it in your state tree. If you have `state.a.b.c.d`, and you want to make an update to `d`, you would also need to return new copies of `c`, `b`, `a`, and `state`. This [state tree mutation diagram](http://arqex.com/wp-content/uploads/2015/02/trees.png) demonstrates how a change deep in a tree requires changes all the way up.

Note that "updating data immutably" does no mean that you must use `Immutable.js`, although that is certainly an option. You can do immutable updates to plain JS objects and arrays using several different approaches:

+ Copying objects using functions like `Object.assign()` or `_.extend()`, and array functions such as `slice()` and `concat()`.

+ The array spread operator in ES6, and the similar object spread operator that is proposed for a future version of JavaScript.

+ Utility libraries that wrap immutable update logic into simpler functions.

Further Information

+ [Toubleshooting](http://redux.js.org/docs/Troubleshooting.html)

+ [React Redux: Troubleshooting](https://github.com/reactjs/react-redux/blob/master/docs/troubleshooting.md)

+ [Recipes: Using the Object Spread Operator](http://redux.js.org/docs/recipes/UsingObjectSpreadOperator.html)

+ [Recipes: Structuring Reducers - Prerequisite Concepts](http://redux.js.org/docs/recipes/reducers/PrerequisiteConcepts.html)

+ [Recipes: Structuring Reducers - Immutable Update Patterns](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html)

+ [Pros and Cons of Using Immutability with React](http://reactkungfu.com/2015/08/pros-and-cons-of-using-immutability-with-react-js/)

+ [React/Redux Links - Immutable Data](https://github.com/markerikson/react-redux-links/blob/master/immutable-data.md)

+ [#1262: Immutable data + bad performance](https://github.com/reactjs/redux/issues/1262)

+ [React Redux #235: Predictate funciton for updating component](https://github.com/reactjs/react-redux/issues/235)

+ [React Redux #291: Should mapStateToProps be called every time an action is dispatched?](https://github.com/reactjs/react-redux/issues/291)

+ [Stack Overflow: Cleaner/shorter way to update nested state in Redux](http://stackoverflow.com/questions/35592078/cleaner-shorter-way-to-update-nested-state-in-redux)

+ [Gist: state mutations](https://gist.github.com/amcdnl/7d93c0c67a9a44fe5761#gistcomment-1706579)

#### 1.10.2 Why is my component re-renderint too often?


React Redux implements several optimizations to ensure your actual component only re-renders when actually necessary. One of those is a shallow equality check on the combined props object generated by the `mapStateToProps` and `mapDispatchToProps` arguments passed to `connect`. Unfortunately, shallow equality does no thelp in cases where new array or object instances are created each time `mapStateToProps` is called. A typical example might be mapping over an array of IDs and returning the matching object reference, such as:

{% highlight js linenos %}
const mapStateToProps = state => {
  return {
    objects: state.objectIds.map(id => state.objects[id])
  }
}
{% endhighlight %}

Even though the array might contain the exact same object references each time, the array itself is a different references, so the shallow equality check fails and React Redux would re-render the wrapped component.

The extra re-renders could be resolved by saving the array of objects into the state using a reducer, caching the mapped array using [Reselect](https://github.com/reactjs/reselect), or implementing `shouldComponentUpdate` in the component by hand and oing a more in-depth props comparison using a funciton such as `_.isEqual`. Be careful to not make your custom `shouldComponentUpdate()` more expensive than the rendering itself! Always use a profiler to check your assumptions about performance.

For non-connected components, you may want to check what props are being passed in. A common issue is having a parent componenet re-bind a callback inside its render fucntion, like `<Child onClick={this.handleClick.bind(this)} />`. That creates a new funciton reference every time the parent re-renders. It's generally good practice to only bind callbacks once in the parent component's constructor.

Further Information

+ [FAQ: Performance - Scaling](http://redux.js.org/docs/faq/Performance.html#performance-scaling)

+ [A Deep Dive into React Perf Debugging](http://benchling.engineering/deep-dive-react-perf-debugging/)

+ [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f)

+ [Improving React and Redux Performance with Reselect](http://blog.rangle.io/react-and-redux-performance-with-reselect/)

+ [Encapsulating the Redux State Tree](http://randycoulman.com/blog/2016/09/13/encapsulating-the-redux-state-tree/)

+ [React/Redux Links: React/Redux Peformance](https://github.com/markerikson/react-redux-links/blob/master/react-performance.md)

+ [Stack Overflow: Can a React Redux app scale as well as Backbone?](http://stackoverflow.com/questions/34782249/can-a-react-redux-app-really-scale-as-well-as-say-backbone-even-with-reselect)

+ [Redux Addons Catalog: DevTools - Component Update Monitoring](https://github.com/markerikson/redux-ecosystem-links/blob/master/devtools.md#component-update-monitoring)

#### 1.10.3 How can I speed up my `mapStateToProps`?

While React Redux does work to minimize the number of times that your `mapStateToProps` function is called, it's still a good idea to ensure that your `mapStateToProps` runs quickly and also minimizes the amount of work it does. THe common recommended approach is to create memoized "selector" functions using [Reselect](https://github.com/reactjs/reselect). These selectors can be combined and composed together, adn selectors later in a pipeline will only run if their inputs have changed. This means you can create selectors that do things like filtering or sorting, and ensure that the real work only happens if needed.

Further Information

+ [Recipes: Computed Derived Data](http://redux.js.org/docs/recipes/ComputingDerivedData.html)

+ [Improving React and Redux Peformance with Reselect](http://blog.rangle.io/react-and-redux-performance-with-reselect/)

+ [#815: Working with Data Structures](https://github.com/reactjs/redux/issues/815)

+ [Reselect #47: Memoizing Hierarchical Selectors](https://github.com/reactjs/reselect/issues/47)

#### 1.10.4 Why don't I have `this.props.dispatch` available in my connected component?

The `connect()` function takes two primary arugments, both optinal. The first, `mapStateToProps`, is a function you provide to pull data from the store when it changes, and pass those values as props to your component. The second, `mapDispatchProps`, is a funciton you provide to make use of the store's `dispatch` function, usually by creating pre-bound versions of action creators that will automatically dispatch their actions as soon as they are called.

If you don not provide your own `mapDispatchToProps` function when calling `connect()`, React Redux will provide a default version, which simply returns the `dispatch` function as a prop. That means that if you do provide your own function, `dispatch` is not automatically provided. If you still want it available as a prop, you need to explicitly return it yourself in your `mapDispatchToProps` implementation.

Further Information

+ [React Redux API: connect()](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options)

+ [React Redux #89: can I wrap multi actionCreators into one props with name](https://github.com/reactjs/react-redux/issues/89)

+ [React Redux #145: consider always passing down dipsatch regardless of what `mapDispatchToProps` does](https://github.com/reactjs/react-redux/issues/145)

+ [React Redux #255: `this.props.dispatch` is undefined if using mapDispatchToProps](https://github.com/reactjs/react-redux/issues/255)

+ [Stack Overflow: How to get simple dispatch from `this.props` using connect w/ Redux](http://stackoverflow.com/questions/34458261/how-to-get-simple-dispatch-from-this-props-using-connect-w-redux/34458710])


#### 1.10.5 Should I only connect my top component, or can I connect multiple components in my tree?

Early Redux documentation advised that you should only have a few connected components near the top of your component tree. However, time and eexperience has shown that that generally requires a few components to know too much about the data requirements of all their descendatns, and forces them to pass down a confusing number of props.

The current suggested best practice is to categorize your components as `presentational` or `container` components, and extract a connected container component whereever it makes sense:

> Emphasizing "one container component at the top" in Redux examples was a mistake. Don't take this as amaxim. Try to keep your presentation components separate. Create container components by connecting them when it's convenient. Whenever you feel like you're duplicating code in parent components to provide data for same kinds of children, time to extract a container. Generally as soon as you fell a parent knows too much about "personal" data or actions of its children, time to extarct a container.

In fact, benchmarks have shown that more connected components generally leads to better performance than fewer connected components. In general, try to find a balance between understandable data flow and areas of responsibility with your components.

Further Information

+ [Baiscs: Usage with React](http://redux.js.org/docs/basics/UsageWithReact.html)

+ [FAQ: Performance - Scaling](http://redux.js.org/docs/faq/Performance.html#performance-scaling)

+ [Presentational and Container Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

+ [High-Performance Redux](http://somebody32.github.io/high-performance-redux/)

+ [React/Redux Links: Architecture - Redux Architecture](https://github.com/markerikson/react-redux-links/blob/master/react-redux-architecture.md#redux-architecture)

+ [React/Redux Links: Performance - Redux Performance](https://github.com/markerikson/react-redux-links/blob/master/react-performance.md#redux-performance)

+ [Twitter: emphasizing "one container" was a mistake](https://twitter.com/dan_abramov/status/668585589609005056)

+ [#419: Recommended usage of connect](https://github.com/reactjs/redux/issues/419)

+ [#756: Container vs component?](https://github.com/reactjs/redux/issues/756)

+ [#1176: Redux+React with only stateless components](https://github.com/reactjs/redux/issues/1176)

+ [Stack Overflow: can a dumb component use a Redux container](http://stackoverflow.com/questions/34992247/can-a-dumb-component-use-render-redux-container-component)


### 1.11 Miscellaneous

#### 1.11.1 Are there any larger, "real" Redux projects?

Yes, lots of them! to name just a few:

+ [Twitter's mobile stie](https://twitter.com/necolas/status/727538799966715904)

+ [Wordpress's new admin Page](https://github.com/Automattic/wp-calypso)

+ [Firfox's new debugger](https://github.com/jlongster/debugger.html)

+ [Mozilla's experimental browser testbed](https://github.com/mozilla/tofino)

+ [The HyperTerm terminal application](https://github.com/zeit/hyperterm)

And many, many more! The Redux Addons Catalog has [a list of Redux-based applications and examples](https://github.com/markerikson/redux-ecosystem-links/blob/master/apps-and-examples.md) that points to a variety of actual applications, large and small.

+ [Introduction: Example](http://redux.js.org/docs/introduction/Examples.html)

+ [Reddit: Large open source react/redux projects?](https://www.reddit.com/r/reactjs/comments/496db2/large_open_source_reactredux_projects/)

+ [HN: Is there any huge web application built using Redux?](https://news.ycombinator.com/item?id=10710240)

#### 1.11.2 How can I implement authentication in Redux?

Authentication is essentail to any real application. When going about authentication you must keep in mind that nothing changes with how you should organize your appplication and you should implement authentication in the same way you would any other feature. It is relatively straightforward:

1. Create action constants for `LOGIN_SUCCESS, `LOGIN_FAILURE`, etc.

2. Create action creators that take in credentials, a flag that signifies whether authentication succeeded, a token, or an error message as the payload.

3. Create an async action creator with Redux Thunk middlware or any middleware you see fit to fire network request to an API that returns a token if the credentials are valid. Then save the token in the local storage or show a response to the user if it failed. You can perform these side effects from the action creators  you wrote in the previous step.

4. Create a reducer that returns the next state for each possible authentication case (`LOGIN_SUCCESS`, `LOGIN_FAILURE`, etc).

+ [Authentication with JWT by Auth0](https://auth0.com/blog/2016/01/04/secure-your-react-and-redux-app-with-jwt-authentication/)

+ [Tips to Handle Authentication in Redux](https://medium.com/@MattiaManzati/tips-to-handle-authentication-in-redux-2-introducing-redux-saga-130d6872fbe7)

+ [react-redux-jwt-auth-example](https://github.com/joshgeller/react-redux-jwt-auth-example)

+ [Redux Addons Catalog: Use Cases - Authentication](https://github.com/markerikson/redux-ecosystem-links/blob/master/use-cases.md#authentication)


## 2. To be read

+ [A Deep Dive into React Perf Debugging](http://benchling.engineering/deep-dive-react-perf-debugging/)

+ [Redux Addons Catalog: DevTools - Component Update Monitoring](https://github.com/markerikson/redux-ecosystem-links/blob/master/devtools.md#component-update-monitoring)

+ [1.10.2 Why is my component re-renderint too often?](#why-is-my-component-re-renderint-too-often)











