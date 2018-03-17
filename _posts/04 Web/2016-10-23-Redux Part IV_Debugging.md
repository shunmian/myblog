---
layout: post
title: Redux Part IV：Debugging
categories: [04 Web Development]
tags: [Redux]
number: [4.1.2]
fullview: false
shortinfo: 本文是对Rudex调试的总结。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}
 
## 1 Debugging ##

### 1.0 `redux-devtools`

### 1.1 Nothing happens when I dispatch an action

Sometimes, you are trying to dispatch an action,but your view does not update. Why does this ahppen? There may be several reasons for this.

#### 1.1.1 Never mutate reducer arguments

It is tempting to modify the `state` or `action` passed to you by Redux. Don't do this!

Redux assumes that you never mutate the objects it gives to you in the reducer. **Every single time, you must return the new state object.** Even if you don't use a library like [Immutable.JS](https://facebook.github.io/immutable-js/), you need to completely avoid mutation.

Immutability is what lets [react-redux](https://github.com/gaearon/react-redux) efficiently subscribe to fine-grained updates of your state. It also enables great developer experience featuers such as time travel with [redux-devtools](http://github.com/gaearon/redux-devtools)


For example, a reducer like this is wrong because it mutates the state:

{% highlight js linenos %}
function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      // Wrong! This mutates state
      state.push({
        text: action.text,
        completed: false
      })
      return state
    case 'COMPLETE_TODO':
      // Wrong! This mutates state[action.index].
      state[action.index].completed = true
      return state
    default:
      return state
  }
}
{% endhighlight %}

It needs to be rewritten like this:

{% highlight js linenos %}
function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      // Return a new array
      return [
        ...state,
        {
          text: action.text,
          completed: false
        }
      ]
    case 'COMPLETE_TODO':
      // Return a new array
      return state.map((todo, index) => {
        if (index === action.index) {
          // Copy the object before mutating
          return Object.assign({}, todo, {
            completed: true
          })
        }
        return todo
      })
    default:
      return state
  }
}
{% endhighlight %}

It's more code, but it's exactly what makes Redux predictable and efficient. If you want to have less code, you can use a helper like [React.addons.update](https://facebook.github.io/react/docs/update.html) to write immutable transformations with a terse syntax

{% highlight js linenos %}
// Before:
return state.map((todo, index) => {
  if (index === action.index) {
    return Object.assign({}, todo, {
      completed: true
    })
  }
  return todo
})

// After
return update(state, {
  [action.index]: {
    completed: {
      $set: true
    }
  }
})
{% endhighlight %}

Finally, to update objects, you'll need something like `_.extend` from Underscore, or better, an [Object.assign](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) polyfill.

Make sure that you use `Object.assign` correctly. For example, instead of returning something like `Object.assign(state, newData)` from your reducers, return `Object.assign({}, state, newData)`. This way you don't override the previous `state`.

You can also enable the [Object spread operator proposal](http://redux.js.org/docs/recipes/UsingObjectSpreadOperator.html) for a more succinct syntax:

{% highlight js linenos %}
// Before:
return state.map((todo, index) => {
  if (index === action.index) {
    return Object.assign({}, todo, {
      completed: true
    })
  }
  return todo
})

// After:
return state.map((todo, index) => {
  if (index === action.index) {
    return { ...todo, completed: true }
  }
  return todo
}
{% endhighlight %}

Note that experimental language features are subject to change.

Also keep an eye out for nested state objects that need to be deeply copied. Both `_.extend` and `Object.assign` make a shallow copy of the state. See [Updateing Nested Objects](http://redux.js.org/docs/recipes/reducers/ImmutableUpdatePatterns.html#updating-nested-objects) for suggestions on how to deal with nested state objects.

#### 1.1.2 Don't forget to call `dispatch(action)`

If you define an action creator, calling it will not automatically dispatch an action. For example, this code will do nothing:



{% highlight js linenos %}
//TodoActions.js
export function addTodo(text) {
  return { type: 'ADD_TODO', text }
}

//AddTodo.js
import React, { Component } from 'react'
import { addTodo } from './TodoActions'

class AddTodo extends Component {
  handleClick() {
    // Won't work!
    addTodo('Fix the issue')
  }

  render() {
    return (
      <button onClick={() => this.handleClick()}>
        Add
      </button>
    )
  }
}
{% endhighlight %}

It doesn't work because your action creator is just a function that returns an action. It is up to you to actually dispatch it. We can't bind your action creators to a particular Store instance during the definition because apps that render on the server need a separate Redux store for every request.

The fix is to call `dispatch()` method on the `store` instance:

{% highlight js linenos %}
handleClick() {
  // Works! (but you need to grab store somehow)
  store.dispatch(addTodo('Fix the issue'))
}
{% endhighlight %}

If you're somewhere deep in the component hierarchy, it is cumbersome to pass the store down manually. This is why [react-redux](https://github.com/gaearon/react-redux) lets you use a `connect` [higher-order component](https://medium.com/@dan_abramov/mixins-are-dead-long-live-higher-order-components-94a0d2f9e750) that will, apart from subscribing you to a Redux store, inject `dispatch` into your component's props.

The fixed code looks like this:

{% highlight js linenos %}
//AddTodo.js
import React, { Component } from 'react'
import { connect } from 'react-redux'
import { addTodo } from './TodoActions'

class AddTodo extends Component {
  handleClick() {
    // Works!
    this.props.dispatch(addTodo('Fix the issue'))
  }

  render() {
    return (
      <button onClick={() => this.handleClick()}>
        Add
      </button>
    )
  }
}

// In addition to the state, `connect` puts `dispatch` in our props.
export default connect()(AddTodo)
{% endhighlight %}

You can then pass `dispatch` down to other components manually, if you want to.

#### 1.1.3 Make sure `mapStateToProps` is correct

It's possible you're correctly dispatching an action and applying your reducer but the corresponding state is not being correctly translated into props.

### 1.2 Something else doesn't work

Ask around on the **#redux** [Reactiflux](http://reactiflux.com/) Discord channel, or [create an issue](https://github.com/reactjs/redux/issues).

If you figure it out, [edit this doecument](https://github.com/reactjs/redux/edit/master/docs/Troubleshooting.md) as a courtesy to the next eprson having the same problem.


## 5 参考资料 ##

- [Redux](https://github.com/reactjs/redux);

- [Get Started with Redux](https://egghead.io/courses/getting-started-with-redux);

- [Note: Get Started with Redux](https://github.com/tayiorbeii/egghead.io_redux_course_notes);

- [React Code](https://github.com/shunmian/4.1.1_redux-part-one)

