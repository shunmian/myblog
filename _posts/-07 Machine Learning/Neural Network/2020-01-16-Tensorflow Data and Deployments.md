---
layout: post
title: Tensorflow Data and Deployments 
categories: [-07 Machine Learning]
tags: [Neural Networks]
number: [-11.1]
fullview: false
shortinfo: Tensorflow Tutorial。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## Course 1: Browser-based Models with TensorFlow.js

### Week 1: intro to `tensforflow.js` 

{% highlight js linenos %}
<html>

<head></head>
<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@latest"></script>
<script lang="js">
  async function run() {
    const csvUrl = 'iris.csv';
    const trainingData = tf.data.csv(csvUrl, {
      columnConfigs: {
        species: {
          isLabel: true
        }
      }
    });
    console.log('==> trainingData', trainingData)
    const numOfFeatures = (await trainingData.columnNames()).length - 1;
    const numOfSamples = 150;
    const convertedData =
      trainingData.map(({ xs, ys }) => {
        const labels = [
          ys.species == "setosa" ? 1 : 0,
          ys.species == "virginica" ? 1 : 0,
          ys.species == "versicolor" ? 1 : 0
        ]
        const updatedData = { xs: Object.values(xs), ys: Object.values(labels) };
        console.log('==> updatedData', updatedData);
        return updatedData
      }).batch(10);

    const model = tf.sequential();
    model.add(tf.layers.dense({ inputShape: [numOfFeatures], activation: "sigmoid", units: 5 }))
    model.add(tf.layers.dense({ activation: "softmax", units: 3 }));

    model.compile({ loss: "categoricalCrossentropy", optimizer: tf.train.adam(0.06) });

    await model.fitDataset(convertedData,
      {
        epochs: 100,
        callbacks: {
          onEpochEnd: async (epoch, logs) => {
            console.log("Epoch: " + epoch + " Loss: " + logs.loss);
          }
        }
      });

    // Test Cases:

    // Setosa
    const testVal = tf.tensor2d([4.4, 2.9, 1.4, 0.2], [1, 4]);

    // Versicolor
    // const testVal = tf.tensor2d([6.4, 3.2, 4.5, 1.5], [1, 4]);

    // Virginica
    // const testVal = tf.tensor2d([5.8,2.7,5.1,1.9], [1, 4]);

    const prediction = model.predict(testVal);
    const pIndex = tf.argMax(prediction, axis = 1).dataSync();

    const classNames = ["Setosa", "Virginica", "Versicolor"];

    // alert(prediction)
    alert(classNames[pIndex])

  }
  run();
</script>

<body>
</body>

</html>
{% endhighlight %}

### Week 2: visualizing training with `tfjs-vis`

[tfjs-vis example](https://github.com/lmoroney/dlaicourse/tree/master/TensorFlow%20Deployment/Course%201%20-%20TensorFlow-JS/Week%202/Examples).

### Week 3: transfer tensorflow trained model from python to js

{: .img_middle_lg}
![Image Classification Summary]({{site.url}}/assets/images/posts/-07_Machine Learning/2020-01-16-Tensorflow Data and Deployments/port-python-model-to-js.png)

## Course 2: Device-based Models with TensorFlow Lite

## Course 3: Data Pipelines with TensorFlow Data Services

## Course 4: Advanced Deployment Scenarios with TensorFlow

## Summary




## Reference

- [《Learning Internal Representations by Error Propagation》 by Geoffrey Hinton](https://web.stanford.edu/class/psych209a/ReadingsByDate/02_06/PDPVolIChapter8.pdf)
- [《Apprenticeship Learning via Inverse Reinforcement Learning》 by Pieter Abbeel](https://ai.stanford.edu/~ang/papers/icml04-apprentice.pdf)
- [《Generative Adversarial Networks》 by Ian GoodFellow](https://arxiv.org/pdf/1406.2661.pdf)

{: .img_middle_hg}
![Image Classification Summary]({{site.url}}/assets/images/posts/07_Machine Learning/Convolutional Neural Network/2015-06-01-CNN for Visual Recognition Part I：入门(一)：图片分类/Image Classification Summary.png)

## 3 参考资料 ##

- [Tutorial](https://www.coursera.org/learn/aws-machine-learning/home/welcome);









