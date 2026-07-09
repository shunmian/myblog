---
layout: post
title: Standord CS146S The Modern Software Developer
categories: [-40 VibeCoding]
tags: [VibeCoding]
number: [-0.0]
fullview: false
shortinfo: 本系列是VibeCoding的第一个入门系统学习课程

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Overview ##

虽然在澳洲和香港呆了八九年，英语的阅读听力和写作有一定提高，但是口语一直没有刻意去训练，一是科研环境大都是中国人，没有练习环境；二是日常生活中和外国人的交集比较少，没有练习的条件。现在由于工作需要，同事来自于世界各地，有英式英语，美式英语，马来西亚式英语，菲律宾式英语以及港式英语，练习一口流利的美式英语对于工作和交流有着紧迫的需要。上网搜了一些资料，推荐最多的是这本教材《American Accent Training》。 相比较于零散的练习日常口语， 一本经典的教材对于再次打牢系统性基础有着极其重要的作用。结合喜马拉雅App上该书的cd，准备每天花1个小时练习，同时用该笔记记录学习过程中的知识点和想法，也算是督促自己的一种方式。



{: .img_middle_hg}
![Run hello]({{site.url}}/assets/images/posts/2014-07-01-Computer System：Overview/Run hello.png)


## 2 Content

### 2.1 Week 1: Introduction to Coding LLMs and AI Development

{: .img_middle_hg}
![Week 1: Introduction to Coding LLMs and AI Development]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 1 Introduction to Coding LLMs and AI Development.png)

<style>
.week1-deep-dive summary {
  list-style: none;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
}

.week1-deep-dive summary::-webkit-details-marker {
  display: none;
}

.week1-deep-dive__caret {
  display: inline-block;
  transition: transform 0.2s ease;
  color: #666;
}

.week1-deep-dive[open] .week1-deep-dive__caret {
  transform: rotate(90deg);
}

.week1-deep-dive__label {
  font-weight: 600;
  color: #666;
}
</style>

- what is LLM: now RL enable user extra input and extra info source for LLM
- Prompt skill
- <details class="week1-deep-dive" markdown="1">
  <summary><a href="https://www.youtube.com/watch?v=7xTGNNLPyMI">Deep Dive into LLMs</a> <span class="week1-deep-dive__caret">▸</span> <span class="week1-deep-dive__label">Summary</span></summary>
  <div markdown="1">

  This lecture gives a clean mental model for modern coding LLMs: an LLM starts as a next-token predictor, becomes an assistant through post-training, and becomes much more useful for software work when it can reason longer and call external tools.

  **1. Foundations of LLMs**

  **1.1 Core Mental Model**

  An LLM is fundamentally a probability machine over token sequences.

  ```text
  input context
      -> neural network
      -> next-token probabilities
      -> sample next token
      -> append token
      -> repeat
  ```

  ChatGPT feels like a conversational system, but under the hood it is still continuing a structured conversation transcript. That is the first key idea of the talk.

  **1.2 Pretraining: Where Raw Capability Comes From**

  The first major stage is pretraining. Companies collect large amounts of public text, clean it aggressively, and train a transformer to predict the next token.

  ```text
  internet text
      -> filtering and deduplication
      -> tokenization
      -> transformer training
      -> base model
  ```

  Important technical points:

  - dataset quality matters as much as dataset size
  - the corpus is filtered for language, spam, boilerplate, and unsafe content
  - a lot of world knowledge is compressed into model weights during this stage

  The result is a `base model`: a powerful text continuation system, but not yet a polished assistant.

  **1.3 Tokenization and Transformers**

  Models do not read words directly. They read tokens, which are compressed text units.

  ```text
  raw text
      -> bytes
      -> merged fragments
      -> token IDs
  ```

  These token IDs are embedded into vectors and processed by transformer layers.

  ```text
  token IDs
      -> embeddings
      -> attention layers
      -> MLP layers
      -> logits
      -> next-token distribution
  ```

  The context window is the model's active working memory. If information is not in the current token context, the model only has whatever was already absorbed into its parameters during training.

  **1.4 Inference: Why Outputs Are Useful but Unreliable**

  After training, inference is just iterative token generation.

  ```text
  prompt
      -> predict
      -> sample
      -> append
      -> predict again
  ```

  Because sampling is probabilistic, the same prompt can lead to different outputs. This explains both creativity and instability: the model can produce good continuations, but it can also drift, overconfidently improvise, or hallucinate.

  **2. From Model to Assistant**

  **2.1 Prompt Skill and In-Context Learning**

  Before fine-tuning, even a base model can already perform useful tasks if the prompt is structured well. This is the foundation of prompt skill.

  ```text
  few-shot examples
      -> pattern appears in context
      -> model infers the task
      -> useful continuation
  ```

  In other words, prompting is not magic. It works because the model has learned many text patterns and can continue a new pattern when the context is set up clearly.

  **2.2 Post-Training: From Base Model to Assistant**

  A base model becomes a chat assistant through supervised fine-tuning on curated human-assistant conversations.

  ```text
  base model
      + conversation data
      -> supervised fine-tuning
      -> assistant model
  ```

  This does not change the core objective very much. It changes the data distribution. Instead of predicting generic internet text, the model is optimized to produce responses that look like helpful assistant answers.

  A very practical interpretation from the talk is this: a ChatGPT-style response is like a neural simulation of a human labeler who has been trained to produce ideal responses under company guidelines.

  The lecture also makes a subtle but important point: even when two human-labeled answers are both correct, they are not equally good training targets for the model.

  In the example below, the **right-hand answer is better than the left-hand answer** for post-training because it decomposes the reasoning into smaller, explicit, checkable steps:

  - first compute the total orange cost: `2 x $2 = $4`
  - then subtract from the total: `$13 - $4 = $9`
  - then divide by the number of apples: `$9 / 3 = $3`

  The left-hand answer is also correct, but it compresses more reasoning into fewer jumps. The talk's point is that LLMs often do better when the supervision shows a clearer intermediate path, because the model generates text token by token with limited compute at each step. A response that exposes the intermediate arithmetic is easier for the model to imitate and more likely to generalize reliably.

  <p class="img_middle_hg">
    <img
      src="{{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/week-1-post-training-human-labeler-example.png"
      alt="Week 1 Post-Training Human Labeler Example"
      style="display:block; width:100%; max-width:100%; margin:16px auto;"
    />
  </p>

  *This is a concrete post-training example from the lecture: better human-labeled answers are not only correct, but also structured in a way that is easier for the model to follow token by token.*

  **2.3 Hallucination and Jagged Intelligence**

  Hallucination is a natural consequence of token prediction. If the model has seen many examples of confident answer-shaped text, it may continue that pattern even when it lacks the facts.

  ```text
  unknown or weakly known fact
      -> answer-shaped continuation
      -> plausible wording
      -> possible fabrication
  ```

  The talk also argues that LLM capability is jagged:

  - very strong on many hard tasks
  - surprisingly weak on some simple tasks
  - not uniformly reliable across domains

  This is a useful warning for coding work: a model can solve a subtle architecture question and still make a dumb counting or comparison error.

  **2.4 Tool Use: Extra Input and Extra Information Sources**

  This is the part most relevant to modern AI development. Strong systems do not rely only on frozen model weights. They can use tools and pull in new evidence.

  ```text
  user request
      -> model decides a tool is needed
      -> web search / code interpreter / retrieval / API
      -> tool output added to context
      -> model answers with better grounding
  ```

  That is the clean way to refine your note:

  - pretraining provides internal knowledge
  - prompting provides task framing
  - tool use provides fresh or exact external information
  - RL helps the model choose better reasoning traces and better moments to use those tools

  This is why coding LLMs are much more powerful than plain chatbots. They can read files, run commands, inspect outputs, search docs, and incorporate new evidence before answering.

  A concrete example is string manipulation: when the model is asked to print every third character of `"Ubiquitous"`, the direct answer can be wrong, but asking it to `Use code` makes the system execute Python slicing and return the correct result.

  <p class="img_middle_hg">
    <img
      src="{{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/week-1-use-code-string-slicing-example.png"
      alt="Week 1 Use Code String Slicing Example"
      style="display:block; width:100%; max-width:100%; margin:16px auto;"
    />
  </p>

  *This screenshot shows the exact engineering pattern the lecture recommends: prefer executable tools when correctness matters, instead of trusting the model to do the operation mentally.*

  The same pattern appears in simple counting tasks. The direct answer for the number of dots can be wrong, while `Use code` counts the characters explicitly and produces the grounded result.

  <p class="img_middle_hg">
    <img
      src="{{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/week-1-use-code-dot-counting-example.png"
      alt="Week 1 Use Code Dot Counting Example"
      style="display:block; width:100%; max-width:100%; margin:16px auto;"
    />
  </p>

  *This is a concrete example of why using code is more accurate than letting the LLM count strings directly. For efficiency, the model does not operate on individual characters during inference; it first tokenizes the input into larger units, so a long run of 177 dots is not naturally treated as 177 separate primitive elements. A coding tool can count characters exactly. In the future, character-level tokenization might reduce this kind of error, but the tradeoff would be lower tokenization efficiency.*

  **2.5 Models Need Tokens to Think**

  A recurring practical point in the lecture is that models should not be forced to do everything in one mental jump.

  ```text
  hard problem
      -> generate intermediate steps
      -> or call a tool
      -> reduce error
  ```

  For arithmetic, counting, parsing, and exact computation, external tools are often more trustworthy than hidden internal reasoning. This is directly relevant to coding workflows, where executing code is usually better than guessing what code will do.

  **3. Reasoning and Coding Agents**

  **3.1 Reinforcement Learning and Reasoning Models**

  The third major training stage is reinforcement learning. Here the goal is not just to imitate good answers, but to optimize for better problem-solving behavior, especially when correctness is verifiable.

  ```text
  assistant model
      -> generate candidate reasoning paths
      -> score them
      -> optimize for better trajectories
      -> reasoning model
  ```

  This is where newer thinking models come from. In domains like math and code, RL can improve how the model searches for solutions rather than only how it imitates human-written responses.

  **3.2 RLHF and Reward Models**

  When the reward is not directly verifiable, companies often use RLHF.

  ```text
  prompt
      -> multiple responses
      -> human ranking
      -> reward model learns preferences
      -> RL optimizes against reward model
  ```

  The talk makes an important distinction: RLHF can improve usefulness, but it is easier to game because the reward model is only a proxy for human judgment. RL is much stronger when the feedback signal is objective, such as code passing tests or math answers being correct.

  **3.3 Why This Matters for Coding Agents**

  A coding agent is best understood as a composition of several layers:

  ```text
  pretrained knowledge
      + prompt skill
      + repo context
      + tool use
      + RL-improved reasoning
      = coding assistant / coding agent
  ```

  That stack explains modern AI software development better than the old idea of "just ask a chatbot." Real coding systems work because they can:

  - use pretrained knowledge of languages and libraries
  - infer tasks from prompts and examples
  - read local files and external documentation
  - execute tools for verification
  - use longer reasoning traces on harder problems

  **3.4 Final Takeaway**

  The cleanest summary of the lecture is:

  ```text
  LLM = next-token predictor
  Chat assistant = post-trained LLM
  Coding agent = post-trained LLM + prompt skill + tools + reasoning optimization
  ```

  That framework is a strong foundation for Week 1 because it explains why prompt skill matters, why RL matters, and why external tools and extra information sources are central to modern coding LLMs.
  </div>
  </details>

- [AI Prompt Engineering: A Deep Dive](https://www.youtube.com/watch?v=T9aRN5JkmL8)


### 2.2 Week 2: The Anatomy of Coding Agents

{: .img_middle_hg}
![Week 2: The Anatomy of Coding Agents]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 2 The Anatomy of Coding Agents.png)


- MCP: the universal adpator protocal from extra ino source to LLM


### 2.3 Week 3: The AI IDE

{: .img_middle_hg}
![Week 3: The AI IDE]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 3 The AI IDE.png)


- [Specs Are the New Source Code](https://blog.ravi-mehta.com/p/specs-are-the-new-source-code). Sean Grove, from OpenAI, has a provocative thesis. In his recent talk, The [New Code](https://www.youtube.com/watch?v=8rABwKRsec4), he argues that a well-written prompt (i.e., the spec) is the new source code.The old workflow looked like this: vague idea → wireframes → designs → engineer-built MVP → customer feedback → painful spec revision → wireframes → designs → rebuild → pray; The new workflow: vague idea → rapid prototype → customer feedback → crystal-clear spec → AI-assisted implementation.

- [ai-that-works](https://github.com/ai-that-works/ai-that-works)

- claude.md

### 2.4 Week 4: Coding Agent Patterns

{: .img_middle_hg}
![Week 4: Coding Agent Patterns]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 4 Coding Agent Patterns.png)


### 2.5 Week 5: The Modern AI Terminal

{: .img_middle_hg}
![Week 5: The Modern AI Terminal]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 5 The Modern AI Terminal.png)
- Cursor

### 2.6 Week 6: AI Testing and Security

{: .img_middle_hg}
![Week 6: AI Testing and Security]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 6 AI Testing and Security.png)


### 2.7 Week 7: Modern Software Support

{: .img_middle_hg}
![Week 7: Modern Software Support]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 7 Modern Software Support.png)


### 2.8 Week 8: Automated UI and App Building

{: .img_middle_hg}
![Week 8: Automated UI and App Building]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 8 Automated UI and App Building.png)

### 2.9 Week 9: Agents Post-Deployment

{: .img_middle_hg}
![Week 9: Agents Post-Deployment]({{site.url}}/assets/images/posts/-40_VibeCoding/StanfordCS146S-TMSD/2026-03-29-The Modern Software Development/Week 9 Agents Post-Deployment.png)

### 2.10 Week 10: What's Next for AI Software Engineering

## Reference ##

- [《官网@CS146S: The Modern Software Developer》](https://themodernsoftware.dev/);
- [《github@CS146S: The Modern Software Developer》](https://github.com/mihail911/modern-software-dev-assignments);
- [《youtube@CS146S: The Modern Software Developer》](https://www.youtube.com/playlist?list=PLxpwjSdVZQ95OWe3QvkVEcU1f1X-6NDj9);

- [《官网@Codex》](https://developers.openai.com/codex);
- [《官网@CaludeCode》](https://claude.com/product/claude-code);

- [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
= [claude-howto](https://github.com/luongnv89/claude-howto)
