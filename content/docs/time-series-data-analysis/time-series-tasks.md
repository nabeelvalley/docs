---
title: Types of Time Series Tasks
subtitle: Overview of the different types of tasks when analyzing time series data
published: true
---

> This document is a summary of this [Overview of time series analysis Python packages](https://siebert-julien.github.io/time-series-analysis-python/)

# Analysis tasks

## Forecasting

Forecast/predict future values based on some past data

![Forecasting example](https://siebert-julien.github.io/time-series-analysis-python/images/forecasting.svg)

## Classification

Classify time series data to groups/classes

![Classificaion example](https://siebert-julien.github.io/time-series-analysis-python/images/classification_word_height_profiles.svg)

## Clustering

Clustering series into similar groups based on statistical properties - different to classification since the groups are not predefined

![Clustering example](https://siebert-julien.github.io/time-series-analysis-python/images/overview_word_height_profiles.svg)

## Anomaly Detection

Anomaly/outlier/novelty detection is about finding abnormal:

- Data points - outliers
- Subsequences - discords

![Anomaly detection example](https://siebert-julien.github.io/time-series-analysis-python/images/anomaly_detection_ecg.svg)

## Segmentation

Segmentation/summarization is about approximating time series data while retaining important features

![Segmentation example](https://siebert-julien.github.io/time-series-analysis-python/images/segentation_SAX.svg)

## Pattern recognition

Pattern recognition/motif discovery is about finding subsequences that apper recurrently

![Pattern recognition example](https://siebert-julien.github.io/time-series-analysis-python/images/motifs_detection.svg)

## Indexing

Indexing is similar to pattern recognition, is query by content which is about finding sequences in a time series and can be used as the basis of other tasks like clustering and motifs discovery

![Indexing example](https://siebert-julien.github.io/time-series-analysis-python/images/pattern_detection.svg)

## Change point detection

Finding points in time where statistical properties like mean and variance change abruptly

![Change point detection](https://siebert-julien.github.io/time-series-analysis-python/images/changepoint_detection.svg)

# Data preparation

Techniques used to support or imporve analysis

- Dimensionality reduction
- Missing value imputation
- Decomposition
- Preprocessing
- Similarity measurement

# Evaluation

Used for evaluating results of analysis tasks

- Selection
  - Model selection
  - Hyperparameter search
  - Feature selection
- Metrics and statistical tests
- Visualization
