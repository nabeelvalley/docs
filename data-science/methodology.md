# Methodology

[Based on this Cognitive Class Course](https://cognitiveclass.ai/courses/data-science-methodology-2/)

- [Methodology](#methodology)
	- [The Methodology](#the-methodology)
	- [The Questions](#the-questions)
		- [From Problem to Approach](#from-problem-to-approach)
		- [Working with the Data](#working-with-the-data)
		- [Deriving the Answer](#deriving-the-answer)
	- [Problem and Approach](#problem-and-approach)
		- [Business Understanding](#business-understanding)
		- [Analytic Approach](#analytic-approach)
			- [Approach to be Used](#approach-to-be-used)
			- [Question Types](#question-types)
			- [Machine Learning](#machine-learning)
			- [Decision Trees](#decision-trees)
		- [Labs](#labs)
	- [Requirements and Collection](#requirements-and-collection)
		- [Data Requirements](#data-requirements)
		- [Data Collection](#data-collection)
		- [Labs](#labs-1)

## The Methodology

The data science methodology described here is as outlined by John Rollins of IBM

The Methodology can be seen in the following steps

![Data Science Methodology (Cognitive Class)](../.gitbook/assets/datascience_methodology_flowchart.png "Data Science Methodology (Cognitive Class)")


## The Questions

The Data Science methodology aims to answer ten main questions

### From Problem to Approach

1. What is the problem you are trying to solve?
2. How can you use data to answer the question?

### Working with the Data

3. What data do you need to answer the question?>
4. Where is the data coming from and how will you get it?
5. Is the data that you collected representative of the problem to be solved?
6. What additional work is required to manipulate and work with the data

### Deriving the Answer

7. In what way can the data be visualized to get to the answer that is required?
8. Does the model used really answer the initial question or does it need to be adjusted?
9. Can you put the model into practice?
10. Can you get constructive feedback into answering the question?

## Problem and Approach

### Business Understanding

> What is the problem you are trying to solve?

The firs step in the methodology involves seeking any needed clarification in order to identify what the problem we are trying to solve is as this drives the data we use and the analytical approach that we will go about applying

It is important to seek clarification early on otherwise we can waste time and resources moving in the wrong direction

In order to understand a question, it is important to understand the goal of the person asking the question

Based on this we will break down objectives and prioritize them

### Analytic Approach

> How can you use data to answer the question?

The second step in the methodology is electing the correct approach involves the specific problem being addressed, this points to the purpose of business understanding and helps us to identify what methods we should use in order to address the problem

#### Approach to be Used

When we have a strong understanding of the problem, wwe can pick an analytical approach to be used

- Descriptive
  - Current Status
- Diagnostic (Statistical Analysis)
  - What happened?
  - Why is this happening?
- Predictive (Forecasting)
  - What if these trends continue?
  - What will happen next?
- Prescriptive
  - How do we solve it?

#### Question Types

We have a few different types of questions that can direct our modelling

- Question is to determine probabilities of an action
  - Predictive Model
- Question is to show relationships
  - Descriptive Model
- Question requires a binary answer
  - Classification Model

#### Machine Learning

Machine learning allows us to identify relationships and trends that cannot otherwise be established

#### Decision Trees

Decision trees are a machine learning algorithm that allow us to classify nodes while also giving us some information as to how the information is classified

It makes use of a tree structure with *recursive partitioning* to classify data, *predictiveness* is based on decrease in entropy - gain in information or impurity

A decision tree for classifying data can result in leaf nodes of varying purity, as seen below which will provide us with different ammounts of information

![Pure Decision Tree (Cognitive Class)](../.gitbook/assets/decision_tree_5.png "Pure Decision Tree (Cognitive Class)")

![Impure Decision Tree (Cognitive Class)](../.gitbook/assets/decision_tree_2.png "Impure Decision Tree (Cognitive Class)")

Some of the characteristics of decision trees are summarized below

| Pros                                        | Cons                                      |
| ------------------------------------------- | ----------------------------------------- |
| Easy to interpret                           | Easy to over or underfit the model        |
| Can handle numeric or categorical features  | Cannot model feature interaction          |
| Can handle missing data                     | Large trees can be difficult to interpret |
| Uses only the most important features       |
| Can be used on very large or small datasets |


### Labs

The Lab notebooks have been added in the `labs` folder, and are released under the MIT License

The Lab for this section is `1-From-Problem-to-Approach.ipynb`

## Requirements and Collection

### Data Requirements

We need to understand what data is required, how to collect it, and how to transform it to address the problem at hand

It is necessary to identify the data requirements for the initial data collection

We typically make use of the following steps

1. Define and select the set of data needed
2. Content format and representation of data was defined
3. It is important to look ahead when transforming our data to a form that would be most suitable for us

### Data Collection

After the initial data collection has been performed, we look at the data and verify that we have all the data that we need, and the data requirements are revisited in order to define what has not been met or needs to be changed

We then make use of descriptive statistics and visuals in order to define the quality and other aspects of the data and then identify how we can fill in these gaps

Collecting data requires that we know the data source and where to find the required data

### Labs

The lab documents for this section are in both Python and R, and can be found in the `labs` folder as `2-Requirements-to-Collection-py.ipynb` and `2-`