# Natural Language Processing

> From [this Playlist](https://www.youtube.com/watch?v=fNxaJsNG3-s&list=PLQY2H8rRoyvwLbzbnKJ59NkZvQAW9wLbx&index=1)

## Tokenization and Sequence Analysis

Natural language processing makes use of something called tokenization, this is a method of encoding text in a numeric form. An example of this would be assigning each unique word in our data an associated number

We can do this encoding using Tensorflow like so:

```py
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.text import Tokenizer

sentences = [
    'I am a person',
    'What am I?',
    "What is a person!",
    "Hey, how are you doing today>"
]

tokenizer = Tokenizer(num_words=20)
tokenizer.fit_on_texts(sentences)

print(tokenizer.word_index)
# {'i': 1, 'am': 2, 'a': 3, 'person': 4, 'what': 5, 'is': 6, 'hey': 7, 'how': 8,
# 'are': 9, 'you': 10, 'doing': 11, 'today': 12}
```

The above `Tokenizer` will only tokenize the `20` most common words, the list of words are available as a `word_index` property

A `Tokenizer` instance will also catch out and correctly handle punctuation, etc.

Once we've got tokens we can represent sentences as sequences of ordered numbers

The `Tokenizer` contains a function called `texts_to_sequences` which will convert a sentence into its sequence/token representation

We can use it like so:

```py
sequences = tokenizer.texts_to_sequences(sentences)

print(sequences)
# [[1, 2, 3, 4], [5, 2, 1], [5, 6, 3, 4], [7, 8, 9, 10, 11, 12]]
```

Sometimes, a `Tokenizer` may get words that it's never seen before it may not know how to handle these. By default the `Tokenizer` will just leave these out. The problem with doing this is that we loose the sentence lengths

To get around this issue, we can sen an `OOV Token` which will be used in the place of missing words instead. We can set this to any string that we wouldn't expect in our text, such as `<OOV>` when we instantiate the `Tokenizer`:

```py
tokenizer = Tokenizer(num_words=20, oov_token='<OOV>')
```

Another issue when using a neural network is that we typically need to provide data of the same shape to the network, however, different sentences can be different lengths. In order for us to get around this we can simply pad our sequences:

```py
from tensorflow.keras.preprocessing.sequence import pad_sequences

# ...

padded = pad_sequences(sequences)

print(padded)
# [[0  0  2  3  4  5]
#  [0  0  0  6  3  2]
#  [0  0  6  7  4  5]
#  [8  9 10 11 12 13]]
```

We can see that the shorter sentences have been padded with `0` on the left. If we want the `0`s at the end or want to set a maximum length or truncation, we can specify those too:

```py
padded = pad_sequences(
    sequences,
    padding='post',
    truncating='post',
    maxlen=5
)

print(padded)
# [[ 2  3  4  5  0]
#  [ 6  3  2  0  0]
#  [ 6  7  4  5  0]
#  [ 8  9 10 11 12]]
```

Once we've got our data into a structure like we do above we can make use of a neural network to build a model

We'll build a model using the [News Headlines Dataset for Sarcasm Detection](https://www.kaggle.com/rmisra/news-headlines-dataset-for-sarcasm-detection/home)

The code for the model is below:

```py
import json
import numpy as np

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

vocab_size = 10000
sentence_max = 100

headlines = []
labels = []

with open('./nlp/Sarcasm_Headlines_Dataset.json') as f:
    lines = f.readlines()
    for line in lines:
        datapoint = json.loads(line)
        headlines.append(datapoint['headline'])
        labels.append(datapoint['is_sarcastic'])

test_size = int(len(headlines) * 0.2)

# TF needs this to be an array
headlines_test = np.array(headlines[0:test_size])
headlines_train = np.array(headlines[test_size:])

labels_test = np.array(labels[0:test_size])
labels_train = np.array(labels[test_size:])

tokenizer = Tokenizer(num_words=vocab_size, oov_token='<OOV>')
tokenizer.fit_on_texts(headlines_test)


def preprocess_sentences(sentences):
    sequences = tokenizer.texts_to_sequences(sentences)
    padded = pad_sequences(sequences, maxlen=sentence_max)
    return padded


padded_train = preprocess_sentences(headlines_train)
padded_test = preprocess_sentences(headlines_test)

embedding_dim = 16

model = keras.Sequential([
    # Embedding creates a vector that will represent each input
    keras.layers.Embedding(vocab_size, embedding_dim,
                           input_length=sentence_max),
    keras.layers.GlobalAveragePooling1D(),
    keras.layers.Dense(24, activation='relu'),
    keras.layers.Dense(1, activation='sigmoid')
])

model.compile(loss='binary_crossentropy',
              optimizer='adam', metrics=['accuracy'])

epoch_num = 30

history = model.fit(x=padded_train, y=labels_train, epochs=epoch_num,
                    validation_data=(padded_test, labels_test), verbose=2)

sentences_new = [
    "OMG this weather is perfect",
    "Absolutely wonderful weather we're having"
]

padded_new = preprocess_sentences(sentences_new)

result = model.predict(padded_new)

for i in range(len(result)):
    print(f'Sentence: ${sentences_new[i]}\nSarcasm{result[i]}')
```
