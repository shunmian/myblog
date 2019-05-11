---
layout: post
title: C++ Boost Libary
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对C++ Boost Libary的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Install

{% highlight cpp linenos %}
// Step 1: install
brew install boost
// ==> Pouring boost-1.69.0_2.mojave.bottle.tar.gz
🍺  /usr/local/Cellar/boost/1.69.0_2: 13,717 files, 489.4MB

// Step 2: export boost path in ~/.bash_profile
export BOOST_ROOT = "/usr/local/Cellar/boost/1.69.0_2"

// Step 3: write test code
#include <boost/lambda/lambda.hpp>
#include <iostream>
#include <iterator>
#include <algorithm>

int main()
{
    using namespace boost::lambda;
    typedef std::istream_iterator<int> in;
    std::for_each(
        in(std::cin), in(), std::cout << (_1 * 3) << " ");
}

// Step 4: compile
g++ -I BOOST_ROOT ./boost.cpp -o example

// Step 4: test
echo 1 2 3 | ./example
{% endhighlight %}

## 2 Quick start

### 2.1 Lexical Cast


{% highlight cpp linenos %}
#include <boost/lexical_cast.hpp>
#include <iostream>
#include <string>

using namespace std;
using boost::lexical_cast;
using boost:: bad_lexical_cast;

int main()
{
    // with c++ standard libarary, cast invloves different functions which is hard to remember
    /*  Convert from string
    atof        Convert string to float (function)
    atoi        Convert string to integer (function)
    atoll       Convert string to long integer (function)
    strtod      Convert string to long long integer (function)
    strtof      Convert string to double (function)
    strtol      Convert string to float (function)
    strtold     Convert string to long integer (function)
    strtoll     Convert string to long long integer (function)
    strtoul     Convert string to unsigned long integer (function)
    strtoull    Convert string to unsigned long long integer (function)
    */

   /* Convert to string
   stringstream strm;
   strm << int_val;
   string s = strm.str();
   */

/*  with boost::lexical_cast:
1. convert from/to string is much easier
2. convert from/to other type is also supported
*/
    int s = 23;
    string str = lexical_cast<string>(s);
    str = "Message: " + lexical_cast<string>('A') + "=" + lexical_cast<string>(34.5);
    array<char, 64> msg = lexical_cast< array<char, 64> >('A');
    s = lexical_cast<int>("3456");
    try {
        s = lexical_cast<int>("56.78");
    } catch (bad_lexical_cast &e) {
        cout << "Exception caught: " << e.what() << endl;
    }
    s = lexical_cast<int>("3456yu"); // bad_lexcial_cast
    s = lexical_cast<int>("3456yu", 4);  // not a bad_lexical_cast
}
{% endhighlight %}


### 2.2 Variant

- vector: one type, multi-value
- variant/union: multi type, one-value

{% highlight cpp linenos %}
#include <boost/variant.hpp>
#include <iostream>
#include <string>

using namespace std;

int main()
{
	// union can only work with old data (string is not)
	union {int i; float f;} u;
	u.i = 34;
	u.f = 2.3;
	// union { int i; string f; } u; not work
	boost::variant<int, string> u1, u2;
	u1 = 2;
	u2 = "hello";
	cout << u1 << " " << u2 << endl;

	// u1 = u1 * 2, not work since u1 has no overload * method
	u1 = boost::get<int>(u1)*2; // this works but require hard-coded <int>, how to make it dynamic?

	// Using visitor

	void Double(boost::variant<int, string>);

	class DoulbeVisitor : public boost::static_visitor<> {	//functor
		public:
			void operator() (int& i) const {
				i += i;
			}
			void operator() (string& str) const {
				str += str;
			}
	};

	boost::apply_visitor(DoulbeVisitor(), u1);
	cout << "after apply_visitor variant int: " << u1 << endl;
	boost::apply_visitor(DoulbeVisitor(), u2);
	cout << "after apply_visitor variant string: " << u2 << endl ;
}
{% endhighlight %}

### 2.3 Any

{% highlight cpp linenos %}

#include <boost/any.hpp>
#include <iostream>
#include <string>

using namespace std;

int main()
{
	/* any vs union
	1. both store multi type in one value
	2. any can store unlimited types, union can store limited predefined types
	*/

	boost::any x, y, z;

	x = string("hello");
	x = 2.3;
	y = 'z';
	z = vector<int>();	// use dynamic storage

	cout << boost::any_cast<char>(y) << endl;	// return a copy of y's data: 'z
	cout << boost::any_cast<double>(x) << endl;	// return a copy of x's data: 2.3
 	// cout << boost::any_cast<int>(x) << endl;	// throws bad_any_cast
	// cout << boost::any_cast<float>(x) << endl;	// throws bad_any_cast

	boost::any_cast< vector<int> >(z).push_back(23);
	// int i = boost::any_cast<vector<int>>(z).back();	// crash because line 26 push into a copy of z instead of z

	int i;
	boost::any p = &i;
	int *pInt = boost::any_cast<int *>(p); 	// returns a pointer

	vector<boost::any> m;
	m.push_back(2);
	m.push_back('a');
	m.push_back(p);
	m.push_back(boost::any());

	struct Property {
		string name;
		boost::any value;
	};

	vector<Property> properties;
}
{% endhighlight %}

### 2.4 Optional

{% highlight cpp linenos %}
#include <boost/optional.hpp>
#include <boost/variant.hpp>
#include <iostream>
#include <string>

using namespace std;

deque<char> queue;

boost::optional<char> get_async_data() {
	if (!queue.empty())
		return boost::optional<char>(queue.back());
	else
		return boost::optional<char>(); // this is a valid char
}
int main()
{
	boost::variant<nullopt_t, char> v;
	boost::optional<char> op;
	op = 'A';
	op = get_async_data();
	if (!op) cout << "No data is available" << endl;
	else {
		cout << "op contains" << op.get() << endl;
		cout << "op contains" << *op << endl;
	}
}
{% endhighlight %}


## 2. 总结 ##

1. 用`select`来读取timeout之内的fd的I/O;若比如0.5s之内用户没有按旋转俄罗斯，则下移。


## 3. Reference ##

- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《Effective C++》](https://book.douban.com/subject/1842426/);
- [《More Effective C++》](https://book.douban.com/subject/1457891/);


