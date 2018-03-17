---
layout: post
title: RN(一) Component
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

## 1 Basic ##

{: .img_middle_hg}
![JS React Summary](/assets/images/posts/04 Web/JS/2016-10-03-React入门/JS React Summary.png)

## 2 Advance

### 2.1 `this.props.children`

{% highlight js linenos %}

// CardSection.js
const CardSection = ({ children }) => (<View style={styles.cardSectionStyle}>{children}</View>);

// Card.js. CardSection instantiation. One can wrap the content within <CardSection> <//CardSection>. Otherwise, you need to write as <CardSection image={image} />

const Card(props) => {
	return (
		<CardSection>
		 	<Image style={contentImageStyle} source={{ uri: image }} />
		</CardSection>
	)
}
{% endhighlight %}

### 2.2 HOC(Higher Order Component)

> HOC: a class factory, `hocFactory:: W: React.Component => E: React.Component`. W is WrappedComponent, E is EnhancedComponent.

#### 2.1 Props Proxy

##### 2.1.1 Manipulating props

{% highlight js linenos %}
// add user prop to WrappedComponent
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      const newProps = {
        user: currentLoggedInUser
      }
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}
{% endhighlight %}

##### 2.1.2 Accessing the instance via Refs

##### 2.1.3 Abstracting State

##### 2.1.4 Wrapping the WrappedComponent with other elements


#### 2.2 Inheritance Inversion


## 2 参考资料 ##
- [React](https://facebook.github.io/react/);
- [Learning React](https://www.amazon.com/Learning-React-Kirupa-Chinnathambi/dp/0134546318);
- [React Higher Order Components in depth](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e);
