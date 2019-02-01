# Deep Learning Fundamentals

- [Deep Learning Fundamentals](#deep-learning-fundamentals)
  - [Introduction to Deep Learning](#introduction-to-deep-learning)
    - [What is a Neural Network](#what-is-a-neural-network)
    - [Why Deep Learning?](#why-deep-learning)
    - [Different Deep Nets](#different-deep-nets)
    - [The Vanishing Gradient](#the-vanishing-gradient)
  - [Deep Learning Models](#deep-learning-models)
    - [Restricted Boltzmann Machines](#restricted-boltzmann-machines)
    - [Deep Belief Nets](#deep-belief-nets)
    - [Convolutional Nets](#convolutional-nets)
    - [Recurrent Nets](#recurrent-nets)
    - [Autoencoders](#autoencoders)
    - [Recursive Neural Tensor Nets](#recursive-neural-tensor-nets)
    - [Uses for Deep Learning](#uses-for-deep-learning)
  - [Deep Learning Platforms](#deep-learning-platforms)
    - [H2O.ai](#h2oai)
    - [Data Graphlab](#data-graphlab)
  - [Deep Learning Libraries](#deep-learning-libraries)
    - [Theano](#theano)
    - [Caffe](#caffe)
    - [Tensorflow](#tensorflow)

## Introduction to Deep Learning

### What is a Neural Network

> For more look at: Micheal Nielson and Andrew Ng

A NN's main function is to receive an input, do some calculations, and based on that solve some sort of problem

NN's can be done for a few different things, such as classification

It is made up of a series of classifiers layered after one another, this makes use of an **Input Layer**, an **Output Layer**, and a few **Hidden Layers**

The process of going from Input to Output is known as Forward Propogation

Neural Nets are also known as Multi Layer Perceptrons, each node is not necessarily a perceptron but may be a slightly more complex node

NN's make use of weights and biases to place different importance of inputs. We train a network by comparing the predicted output to the actual output and modify weights and biases in order to train and become more accurate

### Why Deep Learning?

NN's are exceptionally good at finding complex patterns as well as enabling us to train them by making use of GPUs

If the data has many different inputs NN's tend to become better than other classifiers

When we have many features and combinations we need a Deep Net in order to properly classify the data due to the complexity in patterns

Deep nets break down complex patterns into many simpler patterns and combine these

The problem is that Deep Nets take very long to train, we can however use high speed GPU's to train NN's faster


### Different Deep Nets

- Unlabelled Data
    - RBM
    - Autoencoder
- Labelled
    - Text Processing
        - RNTN
        - Recurrent Net
    - Image Recognition
        - DBN
        - Convolutional Net
    - Object Recognition
        - Convolutional Net
        - RNTN
    - Speech Recognition
        - Recurrent Net
- General
    - Classification
        - MLP
        - RELU
    - Time Series
        - Recurrent Net

### The Vanishing Gradient

Deep Nets have been around for a long time, but they are really difficult to train with back propogation due to a problem known as the Vanishing Gradient

The gradient is the rate that the cost will change given a change in weights or biases

When a gradient is large, the net will train faster than when the gradient is small

Early Layers have the smallest gradient but are the most important part as these being poorly trained can result in the later layers being affected

Due to the way the bias multiplication works, Back propogation performs poorly due to the fact that the biases keep getting smaller towards the later layers thus leadning to a smaller and smaller gradient

## Deep Learning Models

> The major breakthrough came after three papers by Hinton, Lecun and Bengio in 2006 and 2007

### Restricted Boltzmann Machines

The RBM is a shallow, two layer net. Each node is connected to each previous layer, but not to any node on their layer

An RBM is trained to reconstruct the input data through a series of forward and backward passes

RBM's make use of KL Divergence to train them

RBM Data does not need to be labelled. An RBM makes decisions about what features are important and how they should be combined. RBM is part of a family of NN's known as Autoencoders which are able to extract features

### Deep Belief Nets

A DBN is a combination of RBM's. A DBN is identical to an MLP but is trained in a different way which is the differentiating factor

Every set of two layers is used trained as an RBM and tunes the entire model simultaneously

To finish the training process we take a small set of labelled samples which will slightly affect the biases in the net but increase the accuracy

### Convolutional Nets

The CNN has dominated the Image Recognition space. CNN's were developed by Yann Lecun 

> For more detailed information look at Andrej Karpathy's CS231 Notes

A CNN consists of many components

The first component is the Convolutional Layer, this is used to identify a specific pattern such as an edge, this creates a filter. We use multiple simultaneous filters to look for different patterns

The net uses Convolution to search for a specific pattern

In the Convolutoion layer the neurons does convlution. Each neuron is only connected to **some** input neurons, not all

The next two layers are RELU and Pooling. CNN's combine multiple Convolutional Layers, RELU and Pooling layers. The Pooling layers help to reduce the complexity between layers

At the end there is a Fully Connected net which helps to classify the output data from the Pooling Layer

CNN's are supervised models which mean they require a lot of labelled data which can be difficult to come across


### Recurrent Nets

> Jurgen Schmidhuber, Sepp Horchreiter and Alex Graves

These can be applied to anything from speech recognition to driverless cars

These networks have a feedback loop in which the output is fed back into the input layer

A recurrent net can receive a sequence and output a sequence

RNN's can be stacked to perform more complex operations

RNN's are dificult to train and result in an extreme vanishing gradient

There are multiple solutions to this problem, the most popular is to use Gating units like LSTM and GRU

Gating helps the net figure out when to remember and forget a specific input

GPU's are the usual tool for training an RNN

Feed Forward Nets output one Value, whereas an RNN can output a sequence of values such as in the case of forecasting

### Autoencoders

Autoencoders help us to figure out the underlying stucture of a data set, these are a family of NN's that help us to extract features

AE's are typically very shallow, an RBM is an AE with only 2 layers

Autoencoders are using a backpropogation value of *loss*, which is a measure of the information loss

Deep AE's are useful for maintaining information while reducing the dimensionality of data

Deep AE's work better than PCA's which are their predecesors

### Recursive Neural Tensor Nets

> Richard Socher

It may be useful to discover the heirarchy of a data structure, this is something that RNTN's can be helpful for

These were initally designed in order to solve sentiment analysis problems

These networks consist of root and leaf nodes into what form a binary tree

The leaves receive input and the Root outputs a class and a score

Data moves recursively within these networks

These nets work best with specific vector representations that are able to encode the similarity between inputs best

The net will typically look at different combinations of parsing methods and using a scoring system to select the optimal tree structure

RNTS's are trained by back propogation and is used for syntactic parsing, sentiment analysis, image parsing with many components among other things

### Uses for Deep Learning

Some of the biggest usecases for Deep Learning are in the spaces such as

- Machine Vision
- Object Recognition -> Clarifai uses a CNN
- Speech Recognition
- Machine Translation
- Fact Extraction
- Sentiment Analysis -> Metamind
- Cancer Detection
- Drug Discovery
- Radiology
- Finance
- Digital Advertising
- Fraud Detection
- Customer Intel

## Deep Learning Platforms

Deep learning platforms provide users with a set of tools for training custom nets

- Platform
  - Do not need to know to code
  - Constrained by selection of Nets and Config
- Library
  - Flexibility
  - Set of functions that we can use with code

### H2O.ai

H2O is a software platform that provides one Deep Net (MLP) and a few other Machine Learning Algorithms, the platform also offers data preprocessing and model management

H2O allows easy integration to external Data Sources while also allowing you to plug into other services for data processing

H2O is downloadable and can be deployed and managed on your own

### Data Graphlab

Graphlab offers 2 Deep Nets as well as Machine Learning and Graph models

Graphlab has a CNN and MLP among tools for Classification, Regression, Text analysis, and Clustering 

Built in integration for external data sources as well as tools for visualizations

Graphlab is downloadable and needs to be locally managed

## Deep Learning Libraries

A Library is a premade set of tools that can be used by our code

Some libraries that are suitable for commercial use are

- Deeplearning4j
- Torch
- Caffe

For educational uses libraries like Theano can be useful

### Theano

Theano provides functions for building deep nets that can train quickly

> Developed by Machine Learning Group at the University of Montreal

Theano is a Python libraries that makes use net representations as Matrix Representations for the Network structure. Theano therefore allows for fast training due to the parallel optimizations available for training deep nets

Theano requires you to build your NN's from the ground up, specifying everything from layers to activation functions

The Blocks library allows to build on top of Theano, and the Lasagne/Keras libraries allow us to build on top of Theano by providing the Net's hyperparameters layer by layer

Libraries like Passage are also useful for RNN training for textual analysis

### Caffe

Caffe is a deep learning library for machine vision and forecasting which allows you to train custom nets as well as use prebuilt nets via the community

Caffe is well suited for CNN's among other types of nets and is written in C++ and can be accessed with Matlab and Python. It provides the user an ability to very flexibly define nets and net parameters as needed. CaffeNets are uploaded to what is called the Model Zoo

### Tensorflow

Tensorflow is a library built by Google for building Commercial Deep Learning applications. The goal was to build a Machine Learning model that can be deployed on a variety of end devices

Tensorflow is based on the concept of a Computational Graph in which Tensors flow along graph connections

If Hyperparameter interfaces are available by way of the Keras library

Tensorboard allows you to view visualizations about the network with methods such as Network architecture as well as model progression

